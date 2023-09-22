from kubernetes import client, config

def list_pods_in_namespace(namespace='default'):
    config.load_kube_config()
    v1 = client.CoreV1Api()
    pods = v1.list_namespaced_pod(namespace=namespace)
    for pod in pods.items:
        print(pod.metadata.name)

# Usage:
# list_pods_in_namespace('default')