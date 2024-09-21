import csv
import sqlite3

# Path to your SQLite database
db_file = 'resources.db'

# Path to your input CSV file
csv_file = 'output.csv'


def create_connection(db_file):
    """Create a database connection to the SQLite database specified by db_file."""
    conn = None
    try:
        conn = sqlite3.connect(db_file)
        return conn
    except sqlite3.Error as e:
        print(e)
    
    return conn


def create_table(conn):
    """Create the ContactDetails table if it doesn't exist."""
    create_table_sql = """
    CREATE TABLE IF NOT EXISTS ContactDetails (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        linguist_id INTEGER,
        email TEXT NOT NULL,
        phone TEXT,
        FOREIGN KEY (linguist_id) REFERENCES Linguists(id)
    );
    """
    try:
        cur = conn.cursor()
        cur.execute(create_table_sql)
    except sqlite3.Error as e:
        print(e)


def get_linguist_id(conn, supplier_code):
    """
    Get the linguist_id from the Linguists table based on supplier_code.
    Returns the linguist_id if found, otherwise None.
    """
    sql = '''SELECT id FROM Linguists WHERE supplier_code = ?'''
    cur = conn.cursor()
    cur.execute(sql, (supplier_code,))
    result = cur.fetchone()
    return result[0] if result else None


def insert_contact_details(conn, contact_details):
    """
    Insert new contact details into the ContactDetails table.
    `contact_details` should be a tuple of (linguist_id, email, phone).
    """
    sql = '''INSERT INTO ContactDetails(linguist_id, email, phone)
             VALUES(?, ?, ?)'''
    try:
        cur = conn.cursor()
        cur.execute(sql, contact_details)
        conn.commit()
    except sqlite3.Error as e:
        print(f"Error inserting contact details: {e}")


def import_csv_to_db(csv_file, conn):
    """Import contact details from the CSV file into the SQLite database."""
    error_log = []  # To log rows that failed due to missing linguist_id

    with open(csv_file, mode='r', newline='', encoding='ISO-8859-1') as infile:
        reader = csv.reader(infile)
        
        # Get the header row and find the indices of the relevant columns
        header = next(reader)
        supplier_id_idx = header.index("Supplier ID")
        email_idx = header.index("email address")
        phone_idx = header.index("Phone number")
        
        # Iterate through the rows and insert contact details
        for row in reader:
            supplier_code = row[supplier_id_idx]
            email = row[email_idx]
            phone = row[phone_idx]
            
            # Get the linguist_id based on supplier_code
            linguist_id = get_linguist_id(conn, supplier_code)
            
            if linguist_id:
                # Insert the contact details if linguist_id is found
                insert_contact_details(conn, (linguist_id, email, phone))
            else:
                # Log an error if the linguist_id is not found
                error_log.append((supplier_code, email, phone))
    
    return error_log


def report_errors(error_log):
    """Summarize and report any rows that were skipped due to missing linguist_id."""
    if error_log:
        print(f"\nSummary: {len(error_log)} row(s) were skipped due to missing linguist_id.")
        for supplier_code, email, phone in error_log:
            print(f"Skipped row with Supplier Code: {supplier_code}, Email: {email}, Phone: {phone}")
    else:
        print("\nAll contact details inserted successfully!")


def main():
    # Create a connection to the SQLite database
    conn = create_connection(db_file)
    
    if conn is not None:
        # Create the ContactDetails table if it doesn't exist
        create_table(conn)
        
        # Import contact details from the CSV file into the SQLite DB and capture errors
        error_log = import_csv_to_db(csv_file, conn)
        
        # Report any skipped rows with errors
        report_errors(error_log)
        
        # Close the connection
        conn.close()
    else:
        print("Error! Cannot create the database connection.")


if __name__ == '__main__':
    main()
