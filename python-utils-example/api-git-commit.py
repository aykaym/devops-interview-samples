import requests

def fetch_commits(repo):
    url = f'https://api.github.com/repos/{repo}/commits'
    response = requests.get(url)
    
    if response.status_code == 200:
        commits = response.json()
        for commit in commits[:5]:
            print(commit['commit']['message'])
    else:
        print(f"Error: {response.status_code}")

# Usage:
# fetch_commits('octocat/Hello-World')