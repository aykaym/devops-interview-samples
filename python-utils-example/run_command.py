import subprocess

def run_command(command):
    process = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    stdout, stderr = process.communicate()
    
    if process.returncode == 0:
        print(stdout.decode('utf-8'))
    else:
        print(f"Error: {stderr.decode('utf-8')}")

# Usage:
# run_command('ls -l')