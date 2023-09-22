from kubernetes import client, config

def label_low_memory_nodes(threshold=2000000000):  # 2GB threshold
    config.load_kube_config()
    api = client.CoreV1Api()

    nodes = api.list_node()
    for node in nodes.items:
        memory = int(node.status.capacity["memory"].rstrip('Ki'))
        if memory < threshold:
            if not node.metadata.labels:
                node.metadata.labels = {}
            node.metadata.labels["low-memory"] = "true"
            api.patch_node(node.metadata.name, node)
            print(f"Labeled node {node.metadata.name} as low-memory")

# Usage
# label_low_memory_nodes()