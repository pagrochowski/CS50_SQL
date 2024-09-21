
import csv
import random
import string


def main():

    # Example usage
    input_csv = 'input.csv'  # Path to your input CSV file
    output_csv = 'output.csv'  # Path to your output CSV file

    scramble_csv(input_csv, output_csv)

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

# Function to read the CSV and scramble alphabetical data (excluding the header)
def scramble_csv(input_file, output_file):
    with open(input_file, mode='r', newline='', encoding='utf-8') as infile:
        reader = csv.reader(infile)
        rows = list(reader)
        
    # Scramble the rows (excluding the first row, i.e., header)
    scrambled_rows = [rows[0]]  # Keep header intact
    for row in rows[1:]:
        scrambled_row = [scramble_text(cell) for cell in row]
        scrambled_rows.append(scrambled_row)
    
    # Write the scrambled data to a new CSV file
    with open(output_file, mode='w', newline='', encoding='utf-8') as outfile:
        writer = csv.writer(outfile)
        writer.writerows(scrambled_rows)


if __name__ == "__main__":
    main()