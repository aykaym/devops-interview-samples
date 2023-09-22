def read_first_5_lines(filename):
    with open(filename, 'r') as file:
        for i, line in enumerate(file):
            if i < 5:
                print(line.strip())

# Usage:
# read_first_5_lines('path_to_file.txt')