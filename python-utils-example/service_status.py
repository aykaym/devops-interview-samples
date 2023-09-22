import subprocess

def check_service_status(service_name):
    cmd = f"systemctl is-active {service_name}"
    process = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    stdout, _ = process.communicate()
    
    status = stdout.decode('utf-8').strip()
    print(f"{service_name} is {status}")

# Usage:
# check_service_status('nginx')