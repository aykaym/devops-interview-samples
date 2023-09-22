from kubernetes import client, config

def list_nodes():
    config.load_kube_config()
    api = client.CoreV1Api()
    
    nodes = api.list_node()
    for node in nodes.items:
        print(node.metadata.name)

# Usage
# list_nodes()