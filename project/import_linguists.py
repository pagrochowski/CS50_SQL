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
    """Create the Linguists table if it doesn't exist."""
    create_table_sql = """
    CREATE TABLE IF NOT EXISTS Linguists (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        supplier_code TEXT NOT NULL UNIQUE,
        removed INTEGER DEFAULT 0
    );
    """
    try:
        cur = conn.cursor()
        cur.execute(create_table_sql)
    except sqlite3.Error as e:
        print(e)


def insert_linguist(conn, linguist, error_log):
    """
    Insert a new linguist into the Linguists table.
    `linguist` should be a tuple of (name, supplier_code).
    If an error occurs (e.g., UNIQUE constraint), add it to error_log.
    """
    sql = '''INSERT INTO Linguists(name, supplier_code)
             VALUES(?, ?)'''
    try:
        cur = conn.cursor()
        cur.execute(sql, linguist)
        conn.commit()
    except sqlite3.IntegrityError as e:
        # Log error and skip this row
        error_log.append((linguist, str(e)))


def import_csv_to_db(csv_file, conn):
    """Import data from the CSV file into the SQLite database."""
    error_log = []  # To log rows that failed due to IntegrityError

    with open(csv_file, mode='r', newline='', encoding='ISO-8859-1') as infile:
        reader = csv.reader(infile)
        
        # Get the header row and find the indices of the relevant columns
        header = next(reader)
        supplier_name_idx = header.index("Supplier name")
        supplier_id_idx = header.index("Supplier ID")
        
        # Read the first 5 rows and insert into the database
        for i, row in enumerate(reader):
            if i >= 265:  # Limit number of rows as needed
                break
            
            # Extract relevant columns (Supplier name and Supplier ID)
            supplier_name = row[supplier_name_idx]
            supplier_code = row[supplier_id_idx]
            
            # Insert the row into the database
            insert_linguist(conn, (supplier_name, supplier_code), error_log)
    
    return error_log


def report_errors(error_log):
    """Summarize and report any rows that were skipped due to errors."""
    if error_log:
        print(f"\nSummary: {len(error_log)} row(s) were skipped due to errors.")
        for row, error in error_log:
            print(f"Skipped row with Supplier: {row[0]} (Supplier Code: {row[1]}) - Error: {error}")
    else:
        print("\nAll rows inserted successfully!")


def main():
    # Create a connection to the SQLite database
    conn = create_connection(db_file)
    
    if conn is not None:
        # Create the Linguists table if it doesn't exist
        create_table(conn)
        
        # Import the first 5 rows from the CSV file into the SQLite DB and capture errors
        error_log = import_csv_to_db(csv_file, conn)
        
        # Report any skipped rows with errors
        report_errors(error_log)
        
        # Close the connection
        conn.close()
    else:
        print("Error! Cannot create the database connection.")


if __name__ == '__main__':
    main()
