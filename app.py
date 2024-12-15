from flask import Flask, render_template, request, redirect, url_for
from flask_sqlalchemy import SQLAlchemy
import logging

# Initialize Flask app
app = Flask(__name__)

# Database configuration for MySQL
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+pymysql://root:6829@localhost/resta'  # Use pymysql for Python 3.x compatibility
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False  # Disable modification tracking for efficiency

db = SQLAlchemy(app)

# Set up logging
logging.basicConfig(level=logging.INFO)

# Database models
class MenuItem(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    price = db.Column(db.Float, nullable=False)

class Order(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    dish_name = db.Column(db.String(100), nullable=False)
    total_price = db.Column(db.Float, nullable=False)

class Inventory(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    item_name = db.Column(db.String(100), nullable=False)
    quantity = db.Column(db.Integer, nullable=False)

# Routes
@app.route('/')
def home():
    return render_template('home.html')

@app.route('/menu')
def menu():
    menu_items = MenuItem.query.all()
    return render_template('menu.html', menu_items=menu_items)

@app.route('/add-data', methods=['GET', 'POST'])
def add_data():
    menu_items = MenuItem.query.all()
    if request.method == 'POST':
        dish_id = request.form.get('dish')
        try:
            dish = MenuItem.query.get(dish_id)
            if dish:
                new_order = Order(dish_name=dish.name, total_price=dish.price)
                db.session.add(new_order)
                db.session.commit()
                return redirect(url_for('view_sales'))
            else:
                return "Dish not found", 404
        except Exception as e:
            logging.error(f"Error adding data: {e}")
            return f"An error occurred: {e}", 500
    return render_template('add_data.html', menu_items=menu_items)

@app.route('/view-inventory')
def view_inventory():
    inventory_items = Inventory.query.all()
    return render_template('view_inventory.html', inventory_items=inventory_items)

@app.route('/view-sales')
def view_sales():
    orders = Order.query.all()
    return render_template('view_sales.html', orders=orders)

@app.route('/add-inventory', methods=['GET', 'POST'])
def add_inventory():
    if request.method == 'POST':
        item_name = request.form.get('item_name')
        quantity = request.form.get('quantity')

        # Validate input
        if not item_name or not quantity.isdigit() or int(quantity) <= 0:
            return "Invalid input: quantity must be a positive number.", 400

        try:
            new_item = Inventory(item_name=item_name, quantity=int(quantity))
            db.session.add(new_item)
            db.session.commit()
            return redirect(url_for('view_inventory'))
        except Exception as e:
            db.session.rollback()
            logging.error(f"Error adding inventory: {e}")
            return f"An error occurred: {e}", 500

    return render_template('add_inventory.html')

if __name__ == '__main__':
    with app.app_context():
        db.create_all()  # Ensure tables are created in the database (in MySQL)
    app.run(debug=True)

