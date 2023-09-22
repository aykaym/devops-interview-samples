from kubernetes import client, config

def create_namespace(namespace_name):
    config.load_kube_config()
    v1 = client.CoreV1Api()
    body = client.V1Namespace(metadata=client.V1ObjectMeta(name=namespace_name))
    v1.create_namespace(body)

# Usage:
# create_namespace('new-namespace')