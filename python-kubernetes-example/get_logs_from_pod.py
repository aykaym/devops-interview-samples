from kubernetes import client, config

def get_pod_logs(pod_name, namespace='default'):
    config.load_kube_config()
    api = client.CoreV1Api()
    
    log = api.read_namespaced_pod_log(name=pod_name, namespace=namespace)
    print(log)

# Usage
# get_pod_logs('my-pod')