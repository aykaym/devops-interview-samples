from kubernetes import client, config

def list_services_in_namespace(namespace='default'):
    config.load_kube_config()
    v1 = client.CoreV1Api()
    services = v1.list_namespaced_service(namespace=namespace)
    for service in services.items:
        print(service.metadata.name)

# Usage:
# list_services_in_namespace('default')