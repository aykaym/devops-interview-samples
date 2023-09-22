from kubernetes import client, config

def rotate_secret(secret_name, namespace='default'):
    config.load_kube_config()
    api = client.CoreV1Api()

    # Fetching old secret - this example assumes a 'key' in the secret data.
    old_secret = api.read_namespaced_secret(secret_name, namespace)
    old_key = old_secret.data["key"]

    # Generate a new key - here, it's a simple transformation for example purposes.
    new_key = old_key[::-1]  # reverse the key as a dummy rotation

    # Update the secret
    old_secret.data["key"] = new_key
    api.patch_namespaced_secret(secret_name, namespace, old_secret)
    print(f"Rotated secret {secret_name}")

# Usage
# rotate_secret('my-secret')