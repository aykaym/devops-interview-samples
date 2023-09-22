from kubernetes import client, config

def scale_deployment(deployment_name, replicas, namespace='default'):
    config.load_kube_config()
    api = client.AppsV1Api()
    
    patch = {
        "spec": {
            "replicas": replicas
        }
    }
    api.patch_namespaced_deployment_scale(name=deployment_name, namespace=namespace, body=patch)

# Usage
# scale_deployment('my-deployment', 3)