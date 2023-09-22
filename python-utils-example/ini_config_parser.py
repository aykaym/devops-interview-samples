import configparser

def parse_ini(file_path, section, key):
    config = configparser.ConfigParser()
    config.read(file_path)
    
    try:
        value = config[section][key]
        print(value)
    except KeyError:
        print("Section or key not found")

# Usage:
# parse_ini('config.ini', 'DEFAULT', 'key_name')