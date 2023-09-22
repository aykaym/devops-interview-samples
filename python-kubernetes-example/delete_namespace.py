from kubernetes import client, config

def delete_namespace(namespace_name):
    config.load_kube_config()
    v1 = client.CoreV1Api()
    v1.delete_namespace(name=namespace_name)

# Usage:
# delete_namespace('old-namespace')