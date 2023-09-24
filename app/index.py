import mysql.connector
import os
from dotenv import load_dotenv
import matplotlib.pyplot as plt

# functions
def _exit(_):
    print("Exiting... ")
    exit()

def insertOwner(cursor):
    fname = input("Enter first name: ")
    lname = input("Enter last name: ")
    sql = "CALL insert_owner(%s, %s)"
    val = (fname, lname)
    cursor.execute(sql, val)
    print("Owner inserted")

def insertOwnerPhoneNumber(cursor):
    phone = input("Enter phone number: ")
    owner_id = input("Enter owner id: ")
    sql = "CALL insert_phone(%s, %s)"
    val = (phone, owner_id)
    cursor.execute(sql, val)
    print("Owner phone number inserted")

def deleteOwnerPhoneNumber(cursor):
    phone = input("Enter phone number: ")
    owner_id = input("Enter owner id: ")
    sql = "CALL delete_phone(%s, %s)"
    val = (phone, owner_id)
    cursor.execute(sql, val)
    print("Owner phone number deleted")

def insertCar(cursor):
    model = input("Enter car model: ")
    color = input("Enter car color: ")
    brand = input("Enter car brand: ")
    year = input("Enter car year: ")
    owner_id = input("Enter owner id: ")

    sql = "CALL insert_car(%s, %s, %s, %s, %s)"
    val = (model, color, brand, year, owner_id)
    cursor.execute(sql, val)
    print("Car inserted")

def createInsurance(cursor):
    valid_till = input("Enter valid till date (YYYY-MM-DD HH:MM:SS): ")
    amount = input("Enter amount: ")
    agent_name = input("Enter agent name: ")
    paid_by = input("Enter paid by: ")

    sql = "CALL create_insurance(%s, %s, %s, %s)"
    val = (valid_till, amount, agent_name, paid_by)
    cursor.execute(sql, val)
    print("Insurance created")

def reportAccident(cursor):
    cause = input("Enter cause: ")
    date = input("Enter date (YYYY-MM-DD HH:MM:SS): ")
    location = input("Enter location: ")
    car_id = input("Enter car id: ")

    sql = "CALL report_accident(%s, %s, %s, %s)"
    val = (cause, date, location, car_id)
    cursor.execute(sql, val)
    print("Accident reported")

def fileClaim(cursor):
    filed_by = input("Enter filed by: ")
    insurance_id = input("Enter insurance id: ")
    accident_id = input("Enter accident id: ")

    sql = "CALL file_claim(%s, %s, %s)"
    val = (filed_by, insurance_id, accident_id)
    cursor.execute(sql, val)
    print("Claim filed")

def approveClaim(cursor):
    claim_id = input("Enter claim id: ")
    sql = "CALL approve_claim(%s)"
    val = (claim_id,)
    cursor.execute(sql, val)
    print("Claim approved")

def rejectClaim(cursor):
    claim_id = input("Enter claim id: ")
    sql = "CALL reject_claim(%s)"
    val = (claim_id,)
    cursor.execute(sql, val)

def generateCarOwnerReport(cursor):
    sql = "SELECT * FROM vw_cars_owners"
    cursor.execute(sql)
    result = cursor.fetchall()
    print(result)

def generateCarAccidentReport(cursor):
    sql = "SELECT * FROM vw_accidents_cars"
    cursor.execute(sql)
    result = cursor.fetchall()
    print(result)

def generateClaimAccidentReport(cursor):
    sql = "SELECT * FROM vw_claims_accidents"
    cursor.execute(sql)
    result = cursor.fetchall()
    print(result)

def generateSuccessClaimsReport(cursor):
    sql = "SELECT * FROM vw_total_claims"
    cursor.execute(sql)
    result = cursor.fetchall()
    print(result)

def generateSuccessClaimsByAgentReport(cursor):
    sql = "SELECT * FROM vw_successful_claims"
    cursor.execute(sql)
    result = cursor.fetchall()
    print(result)




# def GenerateReport():
#     print("Generating report...")
#     # Sample data
#     x = [1, 2, 3, 4, 5]
#     y = [2, 4, 6, 8, 10]

#     # Create a figure and axis
#     fig, ax = plt.subplots()

#     # Plot the data as a line
#     ax.plot(x, y, label='Line Plot')

#     # Add labels and a title
#     ax.set_xlabel('X-axis')
#     ax.set_ylabel('Y-axis')
#     ax.set_title('Simple Line Plot')

#     # Add a legend
#     ax.legend()

#     # Show the plot
#     plt.show()

# app
menus = [
    {"label": "Insert Owner", "action": insertOwner},
    {"label": "Insert Owner Phone Number", "action": insertOwnerPhoneNumber},
    {"label": "Delete Owner Phone Number", "action": deleteOwnerPhoneNumber},
    
    {"label": "Insert Car", "action": insertCar},
    
    {"label": "Create Insurance", "action": createInsurance},
    
    {"label": "Report accident", "action": reportAccident},
    
    {"label": "File a Claim", "action": fileClaim},
    {"label": "Approve Claim", "action": approveClaim},
    {"label": "Reject Claim", "action": rejectClaim},
    
    {"label": "Generate Car Owner Report", "action": generateCarOwnerReport},
    {"label": "Generate Car Accident Report", "action": generateCarAccidentReport},
    {"label": "Generate Claim Accident Report", "action": generateClaimAccidentReport},
    {"label": "Generate Success Claims Report", "action": generateSuccessClaimsReport},
    {"label": "Generate Success Claims by Agent Report", "action": generateSuccessClaimsByAgentReport},

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
        cursor = db.cursor()

        print("DATABASE CONNECTED " + str(db.is_connected()))

        while(True):
            try:

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
                selected_menu["action"](cursor)
                db.commit()
                back()
            except Exception as e:
                print("Error: " + str(e))
                back()
                continue
    except Exception as e:
        print("Error: " + str(e))


main()