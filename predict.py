import time
import pandas as pd
import mysql.connector
import google.generativeai as genai  # Assuming this is used for Gemini API
import json
import re
import sys

# Step 1: Configure Gemini API
genai.configure(api_key="AIzaSyBUt15mFPXmUiMJYUxceIpRkuw-sCLjQlI")  # Replace with your Gemini API key
model = genai.GenerativeModel("gemini-1.5-flash")

if len(sys.argv) > 1:
    restaurant_id = int(sys.argv[1])  # Ensure it is an integer
    print(f"Received restaurant_id: {restaurant_id}")
else:
    print("Error: No restaurant_id provided. Pass the restaurant_id as a command-line argument.")
    sys.exit(1)
# Step 2: Database connection
def connect_to_db():
    return mysql.connector.connect(
        host="localhost",
        user="root",
        password="6829",
        database="resta"
    )

# Step 3: Fetch sales data for a specific restaurant
def fetch_sales_data_by_restaurant(connection, restaurant_id):
    query = """
    SELECT
        dish_id,
        sales_count,
        rating
    FROM
        Sales
    WHERE
        restaurant_id = %s;
    """
    cursor = connection.cursor(dictionary=True)
    cursor.execute(query, (restaurant_id,))
    return pd.DataFrame(cursor.fetchall())


# Step 5: Use Gemini API to predict sales for all dishes in a restaurant
def get_predictions_from_gemini(restaurant_id, data):
    # Prepare structured prompt with comma-separated predicted sales
    dishes = "\n".join(
        f"- Dish ID: {row['dish_id']}, Sales Count: {row['sales_count']}, Rating: {row['rating']}"
        for _, row in data.iterrows()
    )
    prompt = (
        f"Restaurant ID: {restaurant_id}\n"
        f"Here is the sales data for each dish:\n{dishes}\n\n"
        f"Predict the future sales count for each dish and return the results only as a comma-separated list of numbers, with no explanations or extra text.\n"
        f"Example format:\n"
        f"28, 35, 45, 50\n"
        f"Only return the comma-separated list of numbers. No extra explanations."
    )

    # Call Gemini API to generate content
    try:
        response = model.generate_content(prompt)
        
        # Debugging: Print the entire response object
        print("Raw Gemini API response:", response)

        # Extracting the response content as text
        raw_content = response.text if hasattr(response, 'text') else response.output

        # Debugging: Inspect the raw response content
        print("Raw response content:", raw_content)

        # Parse the comma-separated response to extract values
        try:
            # Remove any non-numeric characters and split by commas
            predictions = re.findall(r'\d+', raw_content.strip())
            predictions = [int(pred) for pred in predictions]  # Convert to integers
        except Exception as e:
            print(f"Error parsing predictions: {e}")
            predictions = []
        
    except Exception as e:
        print(f"Error parsing Gemini response: {e}")
        predictions = []

    return predictions

def save_predictions(connection, restaurant_id, predictions, data):
    cursor = connection.cursor()
    
    # Ensure that predictions match the number of dishes
    if len(predictions) != len(data):
        print("Error: Predictions count does not match the number of dishes.")
        return
    
    # Insert predicted sales into the Predictions table
    for i, prediction in enumerate(predictions):
        dish_id = (int)(data.iloc[i]['dish_id'])
        query = """
        INSERT INTO Predictions (restaurant_id, dish_id, predicted_sales)
        VALUES (%s, %s, %s)
        ON DUPLICATE KEY UPDATE
        predicted_sales = VALUES(predicted_sales);
        """
        cursor.execute(query, (restaurant_id, dish_id, prediction))
    
    connection.commit()

def predictor(restaurant_id):
        connection = connect_to_db()
        try:
            # Fetch all unique restaurant IDs
                sales_data = fetch_sales_data_by_restaurant(connection, restaurant_id)

                # Get predictions from Gemini API
                predictions = get_predictions_from_gemini(restaurant_id, sales_data)

                # Save predictions to the database
                save_predictions(connection, restaurant_id, predictions, sales_data)

        except Exception as e:
            print(f"Error: {e}")
        finally:
            connection.close()

predictor(restaurant_id)
