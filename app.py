from flask import Flask, render_template, request, redirect, url_for, flash, get_flashed_messages
import mysql.connector
import subprocess

app = Flask(__name__)
app.secret_key = '<secret_key>' #Enter your secret key

# Database connection
def get_db_connection():
    return mysql.connector.connect(
        host="<hostname>", #Enter your hostname
        user="<username>", #Enter your username
        password="<password>", #Enter your MySQL password
        database="<database_name>" #Enter your database name
    )

# Home page with location selection
@app.route('/')
def index():
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT DISTINCT location FROM Restaurant")
    locations = cursor.fetchall()
    conn.close()
    return render_template('index.html', locations=locations)

# Show restaurants and menu after location is selected
@app.route('/location_home/<location>', methods=['GET', 'POST'])
def location_home(location):
    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        # Fetch all restaurants for the given location
        query_restaurants = "SELECT restaurant_id, name FROM Restaurant WHERE location = %s"
        cursor.execute(query_restaurants, (location,))
        restaurants = cursor.fetchall()

        # Fetch the menu (shared by all restaurants)
        query_menu = "SELECT Dish_ID, dish_name, price FROM dish"
        cursor.execute(query_menu)
        menu = cursor.fetchall()

        # Fetch all restaurants in other locations to serve as target options
        cursor.execute("SELECT restaurant_id, name, location FROM Restaurant WHERE location != %s", (location,))
        target_restaurants = cursor.fetchall()

        # Fetch all ingredients available in the location
        cursor.execute("SELECT ingredient_id, ingredient_name FROM ingredient")
        ingredients = cursor.fetchall()

        # Handle "Generate Predictions" button click
        predictions = None
        if request.method == 'POST' and 'generate_predictions' in request.form:
            # Fetch all restaurant IDs for the selected location
            restaurant_ids = [restaurant[0] for restaurant in restaurants]
            
            # Call the prediction script for each restaurant in the location
            # Use subprocess to run the prediction script and pass restaurant_ids
            for restaurant_id in restaurant_ids:
                subprocess.run(['python', 'predict.py', str(restaurant_id)])

            # Optionally, fetch the updated predictions from the database
            predictions = []
            for restaurant in restaurants:
                restaurant_id = restaurant[0]
                cursor.execute("""
                    SELECT d.dish_name, p.predicted_sales
                    FROM Predictions p
                    JOIN dish d ON p.dish_id = d.Dish_ID
                    WHERE p.restaurant_id = %s
                """, (restaurant_id,))
                restaurant_predictions = cursor.fetchall()
                for dish_name, predicted_sales in restaurant_predictions:
                    predictions.append({
                        'restaurant_name': restaurant[1],
                        'dish_name': dish_name,
                        'predicted_sales': predicted_sales
                    })

        # Handle ingredient supply functionality
        if request.method == 'POST' and 'supply_ingredients' in request.form:
            source_restaurant_id = request.form['source_restaurant']  # This will be the current restaurant
            target_restaurant_id = request.form['target_restaurant']
            ingredient_id = request.form['ingredient_id']
            supply_quantity = int(request.form['supply_quantity'])

            # Check if source restaurant has enough quantity of the ingredient
            cursor.execute("""
                SELECT ri.quantity 
                FROM Restaurant_Ingredients ri 
                WHERE ri.restaurant_id = %s AND ri.ingredient_id = %s
            """, (source_restaurant_id, ingredient_id))
            source_quantity = cursor.fetchone()
            
            if not source_quantity:
                flash("Ingredient not available in source restaurant.", "error")
            else:
                source_quantity = source_quantity[0]
                if source_quantity < supply_quantity:
                    flash("Insufficient quantity of ingredient to supply.", "error")
                else:
                    # Fetch the current ingredient quantity in the target restaurant
                    cursor.execute("""
                        SELECT ri.quantity 
                        FROM Restaurant_Ingredients ri 
                        WHERE ri.restaurant_id = %s AND ri.ingredient_id = %s
                    """, (target_restaurant_id, ingredient_id))
                    target_quantity = cursor.fetchone()
                    
                    if target_quantity:
                        target_quantity = target_quantity[0]
                    else:
                        target_quantity = 0  # If ingredient doesn't exist in target, assume 0 quantity
                    
                    # Update both the source and target restaurant's ingredient quantities
                    new_source_quantity = source_quantity - supply_quantity
                    new_target_quantity = target_quantity + supply_quantity
                    
                    # Update the source restaurant's ingredient quantity
                    cursor.execute("""
                        UPDATE Restaurant_Ingredients 
                        SET quantity = %s 
                        WHERE restaurant_id = %s AND ingredient_id = %s
                    """, (new_source_quantity, source_restaurant_id, ingredient_id))
                    
                    # Update the target restaurant's ingredient quantity
                    cursor.execute("""
                        INSERT INTO Restaurant_Ingredients (restaurant_id, ingredient_id, quantity) 
                        VALUES (%s, %s, %s) 
                        ON DUPLICATE KEY UPDATE quantity = %s
                    """, (target_restaurant_id, ingredient_id, new_target_quantity, new_target_quantity))

                    flash("Ingredients supplied successfully.", "success")
                    conn.commit()

        cursor.close()

        # Set the source restaurant to be the first restaurant in the list or a selected restaurant
        source_restaurant_id = request.args.get('restaurant_id')
        if not source_restaurant_id:
            source_restaurant_id = restaurants[0][0]  # Set the first restaurant as default (can change this logic)

        return render_template(
            'location_home.html',
            location=location,
            restaurants=restaurants,
            menu=menu,
            predictions=predictions,
            target_restaurants=target_restaurants,  # Pass target restaurants to the template
            ingredients=ingredients,  # Pass ingredients to the template
            current_restaurant_id=source_restaurant_id  # Pass the current restaurant's ID
        )
    except Exception as e:
        return f"An error occurred: {e}", 500


# View the menu for a selected restaurant and order items
@app.route('/menu/<restaurant_id>', methods=['GET', 'POST'])
def menu(restaurant_id):
    conn = get_db_connection()
    cursor = conn.cursor()

    # Fetch dishes for the restaurant
    cursor.execute("SELECT Dish_ID, dish_name, price FROM dish")
    dishes = cursor.fetchall()

    if request.method == 'POST':
        # Handling the order submission
        dish_quantities = request.form.getlist('dish_quantity')

        for i, quantity in enumerate(dish_quantities):
            if int(quantity) > 0:
                dish_id = dishes[i][0]

                # Check ingredient availability for the dish
                cursor.execute("""
                    SELECT di.ingredient_id, di.quantity_required, ri.quantity
                    FROM dish_ingredient di
                    JOIN Restaurant_Ingredients ri ON di.ingredient_id = ri.ingredient_id
                    WHERE di.dish_id = %s AND ri.restaurant_id = %s
                """, (dish_id, restaurant_id))
                ingredients = cursor.fetchall()

                insufficient_ingredients = []
                for ingredient_id, quantity_required, current_quantity in ingredients:
                    required_quantity = int(quantity) * quantity_required
                    if current_quantity < required_quantity:
                        insufficient_ingredients.append((ingredient_id, required_quantity - current_quantity))

                # Send messages to other restaurants for insufficient ingredients
                for ingredient_id, shortfall in insufficient_ingredients:
                    message = f"{shortfall} units of ingredient {ingredient_id} needed by Restaurant ID {restaurant_id}"

                    # Update the Messages column for other restaurants in the same location
                    cursor.execute("""
                        UPDATE Restaurant
                        SET Messages = %s
                        WHERE restaurant_id != %s
                    """, (message, restaurant_id))

                # After sending messages, reject the order if ingredients are still insufficient
                if insufficient_ingredients:
                    conn.commit()
                    conn.close()
                    return f"Order cannot be processed due to insufficient ingredients. Messages have been sent to other restaurants.", 400

                # Update sales and reduce ingredient quantities if ingredients are sufficient
                cursor.execute("""
                    UPDATE Sales
                    SET sales_count = sales_count + %s
                    WHERE restaurant_id = %s AND dish_id = %s
                """, (int(quantity), restaurant_id, dish_id))

                for ingredient_id, quantity_required, _ in ingredients:
                    cursor.execute("""
                        UPDATE Restaurant_Ingredients
                        SET quantity = quantity - (%s * %s)
                        WHERE restaurant_id = %s AND ingredient_id = %s
                    """, (int(quantity), quantity_required, restaurant_id, ingredient_id))

        conn.commit()
        conn.close()
        return redirect(url_for('menu', restaurant_id=restaurant_id))

    conn.close()
    return render_template('menu.html', dishes=dishes, restaurant_id=restaurant_id)

# View inventory for the selected restaurant
@app.route('/inventory/<int:restaurant_id>')
def inventory(restaurant_id):
    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        # Fetch inventory for the selected restaurant
        query = """
            SELECT i.ingredient_name, ri.quantity
            FROM ingredient i
            JOIN Restaurant_Ingredients ri ON i.ingredient_id = ri.ingredient_id
            WHERE ri.restaurant_id = %s
        """
        cursor.execute(query, (restaurant_id,))
        inventory = cursor.fetchall()
        cursor.close()

        return render_template('inventory.html', inventory=inventory)
    except Exception as e:
        return f"An error occurred: {e}", 500

if __name__ == '__main__':
    app.run(debug=True)
