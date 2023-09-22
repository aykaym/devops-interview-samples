import json

json_string = '{"name": "Alice", "age":30}'

def parse_json(json_string, key):
    data = json.loads(json_string)
    print(data.get(key, 'Key not found'))

# Usage:
# json_string = '{"name": "Alice", "age": 30}'
# parse_json(json_string, 'name')