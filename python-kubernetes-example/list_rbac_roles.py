from kubernetes import client, config

def list_rbac_roles(namespace='default'):
    config.load_kube_config()
    api = client.RbacAuthorizationV1Api()
    
    roles = api.list_namespaced_role(namespace)
    for role in roles.items:
        print(role.metadata.name)

# Usage
# list_rbac_roles()