import mysql.connector
import os
from dotenv import load_dotenv


def menu():
    print ("Welcome to the Car Insurance App. Please select an option:")
    print("1. Register New Car")
    print("2. Register as insurance")
    print("3. Report accident")
    print("4. Claim Insurance")
    print("5. Generate Report")
    print("6. Exit")
    option = input("> ")
    return option
def back():
    print("Press any key to go back")
    input()
    return

def main():
    load_dotenv()
    # Connect to database
    db_host = os.environ.get('DB_HOST')
    db_username = os.environ.get('DB_USERNAME')
    db_password = os.environ.get('DB_PASSWORD')
    db_name = os.environ.get('DB_NAME')
    
    try:
        db = mysql.connector.connect(
            host=db_host,
            user=db_username,
            password=db_password,
            database=db_name
        )
        print("DATABASE CONNECTED " + str(db.is_connected()))

        while(True):
            # clear screen and show menu
            os.system('cls' if os.name == 'nt' else 'clear')
            option = menu()
            if option == "1":
                print("Register New Car")
            elif option == "2":
                print("Register as insurance")
            elif option == "3":
                print("Report accident")
            elif option == "4":
                print("Claim Insurance")
            elif option == "5":
                print("Generate Report")
            elif option == "6":
                print("Exiting...")
                exit()
            else:
                print("Invalid option")
            back()
    except Exception as e:
        print("Error connecting to database: " + str(e))


main()