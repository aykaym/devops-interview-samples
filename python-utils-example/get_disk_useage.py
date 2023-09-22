import shutil

def get_disk_usage(path='/'):
    total, used, free = shutil.disk_usage(path)
    print(f"Total: {total // (2**30)} GB")
    print(f"Used: {used // (2**30)} GB")
    print(f"Free: {free // (2**30)} GB")

# Usage:
# get_disk_usage()