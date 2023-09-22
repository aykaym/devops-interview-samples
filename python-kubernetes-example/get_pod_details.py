from kubernetes import client, config

def get_pod_details(pod_name, namespace='default'):
    config.load_kube_config()
    v1 = client.CoreV1Api()
    pod = v1.read_namespaced_pod(name=pod_name, namespace=namespace)
    print(f"Pod Name: {pod.metadata.name}")
    print(f"Status: {pod.status.phase}")

# Usage:
# get_pod_details('pod-name', 'default')