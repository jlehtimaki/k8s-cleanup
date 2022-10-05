#k8s-cleanup

This container can be used to clean up you k8s cluster by running the container as a Kubernetes cronjob.

This container will delete pods with these statuses by default but these can be [disabled]():
- ContainerStatusUnknown
- Evicted
- Completed
- NodeAffinity
- Error

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
Clean every pod except the ones with Error and Completed
```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: k8s-cleanup
  namespace: default
spec:
  concurrencyPolicy: Forbid
  failedJobsHistoryLimit: 2
  jobTemplate:
    spec:
      backoffLimit: 0
      completions: 1
      parallelism: 1
      template:
        spec:
          containers:
            - name: k8s-cleanup
              args:
                - Error
                - Completed
              image: ghcr.io/jlehtimaki/k8s-cleanup:latest
              imagePullPolicy: Always
          restartPolicy: Never
          serviceAccountName: k8s-cleanup
          terminationGracePeriodSeconds: 30
  schedule: '*/1 * * * *'
  successfulJobsHistoryLimit: 3
```
