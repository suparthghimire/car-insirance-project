import mysql.connector
import os
from dotenv import load_dotenv


# functions

def _exit():
    print("Exiting... ")
    exit()


menus = [
    {"label": "Register New Car", "action": lambda: print("Register new car")},
    {"label": "Register as insurance", "action": lambda: print("Register as insurance")},
    {"label": "Report accident", "action": lambda: print("Report an accident")},
    {"label": "Claim Insurance", "action": lambda: print("Claim Insurance")},
    {"label": "Generate Report", "action": lambda: print("Generate Insurance Report")},
    {"label": "Exit", "action": _exit},
]




def menu():
    print ("Welcome to the Car Insurance App. Please select an option:")
    for i in range(len(menus)):
        print(str(i+1) + ". " + menus[i]["label"])
    option = input("> ")

    return int(option)
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
            # see if option is valid
            if len(menus) < option or option < 1:
                print("Invalid option")
                back()
                continue

            selected_menu = menus[option-1]
            #execute the action
            selected_menu["action"]()
            back()
    except Exception as e:
        print("Error: " + str(e))


main()