import mysql.connector
import os
from dotenv import load_dotenv

def main():
    load_dotenv()
    # Connect to database
    db_host = os.environ.get('DB_HOST')
    db_username = os.environ.get('DB_USERNAME')
    db_password = os.environ.get('DB_PASSWORD')
    db_name = os.environ.get('DB_NAME')
    
    db = mysql.connector.connect(
        host=db_host,
        user=db_username,
        password=db_password,
        database=db_name
    )

    print("DATABASE CONNECTED " + str(db.is_connected()))

main()