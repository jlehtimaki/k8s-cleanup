#k8s-cleanup

This container can be used to clean up you k8s cluster by running the container as a Kubernetes cronjob.

This container will delete pods with these statuses by default but these can be [disabled]():
- ContainerStatusUnknown
- Evicted
- Completed
- NodeAffinity

## Requirements
- Serviceaccount
```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: k8s-cleanup
  namespace: default
```
- ClusterRole/Role
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: k8s-cleanup
rules:
  - apiGroups: [""]
    resources: ["pods"]
    verbs: ["get","list","delete"]
  - apiGroups: [""]
    resources: ["namespaces"]
    verbs: ["list"]

```
- ClusterRoleBinding/RoleBinding
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: k8s-cleanup
subjects:
  - kind: ServiceAccount
    name: k8s-cleanup
    namespace: default
roleRef:
  kind: ClusterRole
  name: pod-manager
  apiGroup: rbac.authorization.k8s.io
```



You can disable one/multiple rules by adding argument to the job.

## Example
