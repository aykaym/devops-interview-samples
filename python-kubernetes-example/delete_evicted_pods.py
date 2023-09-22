from kubernetes import client, config

def delete_evicted_pods(namespace='default'):
    config.load_kube_config()
    api = client.CoreV1Api()

    pods = api.list_namespaced_pod(namespace)
    for pod in pods.items:
        if pod.status.reason == "Evicted":
            api.delete_namespaced_pod(pod.metadata.name, namespace)
            print(f"Deleted evicted pod {pod.metadata.name}")

# Usage
# delete_evicted_pods()