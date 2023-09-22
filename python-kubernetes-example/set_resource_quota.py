from kubernetes import client, config

def set_default_resource_quota():
    config.load_kube_config()
    api = client.CoreV1Api()

    namespaces = api.list_namespace()
    for ns in namespaces.items:
        quota = client.V1ResourceQuota(
            metadata=client.V1ObjectMeta(name="default-quota", namespace=ns.metadata.name),
            spec=client.V1ResourceQuotaSpec(
                hard={"requests.cpu": "500m", "requests.memory": "200Mi"}
            )
        )
        try:
            api.create_namespaced_resource_quota(ns.metadata.name, quota)
            print(f"Set default quota for namespace {ns.metadata.name}")
        except Exception as e:
            print(f"Failed to set quota for {ns.metadata.name}. Error: {e}")

# Usage
# set_default_resource_quota()