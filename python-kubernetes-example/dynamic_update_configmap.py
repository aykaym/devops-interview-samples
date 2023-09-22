import os
from kubernetes import client, config

def update_configmap_from_directory(configmap_name, directory_path, namespace='default'):
    config.load_kube_config()
    api = client.CoreV1Api()
    
    data = {}
    for root, dirs, files in os.walk(directory_path):
        for file in files:
            with open(os.path.join(root, file), 'r') as f:
                data[file] = f.read()

    configmap = client.V1ConfigMap(data=data)
    api.patch_namespaced_config_map(configmap_name, namespace, configmap)
    print(f"Updated ConfigMap {configmap_name} from directory {directory_path}")

# Usage
# update_configmap_from_directory('my-configmap', '/path/to/config/directory')