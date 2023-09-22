import requests

def get_status_code(url):
    response = requests.get(url)
    print(response.status_code)

# Usage:
# get_status_code('https://www.example.com')