import csv
import random


def main():

    # Example usage
    input_csv = 'input.csv'  # Path to your input CSV file
    output_csv = 'output.csv'  # Path to your output CSV file

    # Specify columns to scramble (these must match the column headers exactly)
    columns_to_scramble = ["Supplier name", "email address"]

    scramble_csv(input_csv, output_csv, columns_to_scramble)


# Function to scramble only the alphabetical characters in a string
def scramble_text(text):
    # Separate the alphabetical characters from non-alphabetical ones
    letters = [c for c in text if c.isalpha()]
    
    # Randomly shuffle the letters
    random.shuffle(letters)
    
    # Rebuild the string with scrambled letters and keeping numbers in place
    result = []
    letter_index = 0
    for char in text:
        if char.isalpha():
            result.append(letters[letter_index])
            letter_index += 1
        else:
            result.append(char)
    
    return ''.join(result)


# Function to read the CSV and scramble only specified columns (excluding the header)
def scramble_csv(input_file, output_file, columns_to_scramble):
    with open(input_file, mode='r', newline='', encoding='ISO-8859-1') as infile:
        reader = csv.reader(infile)
        rows = list(reader)

    # Get the header row
    header = rows[0]

    # Find the indices of the columns that need to be scrambled
    scramble_indices = [header.index(col) for col in columns_to_scramble if col in header]

    # Scramble the rows (excluding the first row, i.e., header)
    scrambled_rows = [header]  # Keep header intact
    for row in rows[1:]:
        scrambled_row = []
        for i, cell in enumerate(row):
            # Scramble only if the column index is in the scramble_indices list
            if i in scramble_indices:
                scrambled_row.append(scramble_text(cell))
            else:
                scrambled_row.append(cell)
        scrambled_rows.append(scrambled_row)
    
    # Write the scrambled data to a new CSV file
    with open(output_file, mode='w', newline='', encoding='utf-8') as outfile:
        writer = csv.writer(outfile)
        writer.writerows(scrambled_rows)


if __name__ == "__main__":
    main()
