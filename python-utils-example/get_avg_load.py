import os

def get_system_load():
    load = os.getloadavg()
    print(f"Average load over the last 1 minute: {load[0]}")

# Usage:
# get_system_load()