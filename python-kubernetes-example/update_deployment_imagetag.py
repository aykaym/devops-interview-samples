from kubernetes import client, config

def update_deployment_image(deployment_name, image_name, namespace='default'):
    config.load_kube_config()
    api = client.AppsV1Api()
    
    # Update the deployment
    patch = {
        "spec": {
            "template": {
                "spec": {
                    "containers": [
                        {
                            "name": deployment_name,
                            "image": image_name
                        }
                    ]
                }
            }
        }
    }
    api.patch_namespaced_deployment(name=deployment_name, namespace=namespace, body=patch)

# Usage
# update_deployment_image('my-deployment', 'new-image:tag')