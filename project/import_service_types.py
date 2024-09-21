import csv
import sqlite3
import re  # Import regex module for cleaning up values

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
    """Create the ServiceTypes table if it doesn't exist."""
    create_table_sql = """
    CREATE TABLE IF NOT EXISTS ServiceTypes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        linguist_id INTEGER,
        service_type TEXT NOT NULL,  -- Translation, Revision, Language Lead
        sub_service_type TEXT,       -- Software, Documentation
        rate_per_word REAL,
        rate_per_hour REAL,
        art_code TEXT,
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


def clean_value(value):
    """
    Cleans up a value by removing unwanted characters like '€', ' ', and converts it to a float if possible.
    Returns None if conversion fails or if the value is not a valid number.
    """
    if not value or value.strip() == '-' or value.strip() == '#VALUE!':
        return None
    
    # Remove currency symbols, spaces, or other non-numeric characters except for '.'
    cleaned_value = re.sub(r'[^\d.-]', '', value)
    
    try:
        return float(cleaned_value)
    except ValueError:
        return None


def insert_service_type(conn, service_details):
    """
    Insert a new service type into the ServiceTypes table.
    `service_details` should be a tuple of (linguist_id, service_type, sub_service_type, rate_per_word, rate_per_hour, art_code).
    """
    sql = '''INSERT INTO ServiceTypes(linguist_id, service_type, sub_service_type, rate_per_word, rate_per_hour, art_code)
             VALUES(?, ?, ?, ?, ?, ?)'''
    try:
        cur = conn.cursor()
        cur.execute(sql, service_details)
        conn.commit()
    except sqlite3.Error as e:
        print(f"Error inserting service type: {e}")


def import_csv_to_db(csv_file, conn):
    """Import service types from the CSV file into the SQLite database."""
    error_log = []  # To log rows that failed due to missing linguist_id

    with open(csv_file, mode='r', newline='', encoding='ISO-8859-1') as infile:
        reader = csv.reader(infile)
        
        # Get the header row and find the indices of the relevant columns
        header = next(reader)
        supplier_id_idx = header.index("Supplier ID")
        sw_rate_idx = header.index("SW")  # Software translation rate per word
        sw_art_code_idx = header.index("SW Art Code")  # Software Art code
        ua_rate_idx = header.index("UA")  # Documentation translation rate per word
        ua_art_code_idx = header.index("UA Art Code")  # Documentation Art code
        revision_rate_per_word_idx = header.index("Revison per word")  # Revision per word (same for both SW and UA)
        revision_rate_per_hour_idx = header.index("Revision per hour / Linguistic testing")  # Revision per hour
        hourly_rate_idx = header.index("Hourly rate")  # Language Lead hourly rate
        
        # Iterate through the rows and insert service types
        for row in reader:
            supplier_code = row[supplier_id_idx]
            linguist_id = get_linguist_id(conn, supplier_code)
            
            if linguist_id:
                # Clean up the rate values
                sw_rate_per_word = clean_value(row[sw_rate_idx])
                sw_art_code = row[sw_art_code_idx]
                ua_rate_per_word = clean_value(row[ua_rate_idx])
                ua_art_code = row[ua_art_code_idx]
                revision_rate_per_word = clean_value(row[revision_rate_per_word_idx])
                revision_rate_per_hour = clean_value(row[revision_rate_per_hour_idx])
                hourly_rate = clean_value(row[hourly_rate_idx])

                # Insert Software Translation service
                if sw_rate_per_word is not None or revision_rate_per_word is not None:
                    insert_service_type(conn, (linguist_id, 'Translation', 'Software', sw_rate_per_word, None, sw_art_code))
                    insert_service_type(conn, (linguist_id, 'Revision', 'Software', revision_rate_per_word, revision_rate_per_hour, sw_art_code))

                # Insert Documentation Translation service
                if ua_rate_per_word is not None or revision_rate_per_word is not None:
                    insert_service_type(conn, (linguist_id, 'Translation', 'Documentation', ua_rate_per_word, None, ua_art_code))
                    insert_service_type(conn, (linguist_id, 'Revision', 'Documentation', revision_rate_per_word, revision_rate_per_hour, ua_art_code))

                # Insert Language Lead service
                if hourly_rate is not None:
                    insert_service_type(conn, (linguist_id, 'Language Lead', None, None, hourly_rate, None))
            else:
                # Log an error if the linguist_id is not found
                error_log.append(supplier_code)
    
    return error_log


def report_errors(error_log):
    """Summarize and report any rows that were skipped due to missing linguist_id."""
    if error_log:
        print(f"\nSummary: {len(error_log)} row(s) were skipped due to missing linguist_id.")
        for supplier_code in error_log:
            print(f"Skipped row with Supplier Code: {supplier_code}")
    else:
        print("\nAll service types inserted successfully!")


def main():
    # Create a connection to the SQLite database
    conn = create_connection(db_file)
    
    if conn is not None:
        # Create the ServiceTypes table if it doesn't exist
        create_table(conn)
        
        # Import service types from the CSV file into the SQLite DB and capture errors
        error_log = import_csv_to_db(csv_file, conn)
        
        # Report any skipped rows with errors
        report_errors(error_log)
        
        # Close the connection
        conn.close()
    else:
        print("Error! Cannot create the database connection.")


if __name__ == '__main__':
    main()
