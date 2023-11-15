
# CLI

- <b>helm</b> <badge-stars repo='helm/helm'></badge-stars> is a tool for managing Charts. Charts are packages of pre-configured Kubernetes resources.
- <b>kustomize</b> <badge-stars repo='kubernetes-sigs/kustomize'></badge-stars> lets you customize raw, template-free YAML files for multiple purposes, leaving the original YAML untouched and usable as is. kustomize build system has been included in kubectl.
- <b>helm convert</b> <badge-stars repo='ContainerSolutions/helm-convert'></badge-stars> let you convert existing charts into Kustomize compatible package.

## kubectl

### Context

Clusters and users can be managed within contexts <badge-doc
href='https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters/'
logo="kubernetes"></badge-doc>.

`kubectl` enable setting the different parameters:

```bash
# Completion results:
> kubectl config <TAB>
current-context  get-contexts     set-context      view
delete-cluster   rename-context   set-credentials
delete-context   set              unset
get-clusters     set-cluster      use-context

> kubectl config --<TAB>
--add-dir-header            --logtostderr
--alsologtostderr           --match-server-version
--as                        --namespace
--as-group                  --password
--cache-dir                 --profile
--certificate-authority     --profile-output
--client-certificate        --request-timeout
--client-key                --server
--cluster                   --skip-headers
--context                   --skip-log-headers
--insecure-skip-tls-verify  --stderrthreshold
--kubeconfig                --token
--log-backtrace-at          --user
--log-dir                   --username
--log-file                  --v
--log-file-max-size         --vmodule
--log-flush-frequency
```

??? example "Config example"

    ```yaml
    apiVersion: v1
    clusters:
    - cluster:
        certificate-authority: fake-ca-file
        server: https://1.2.3.4
    name: development
    - cluster:
        insecure-skip-tls-verify: true
        server: https://5.6.7.8
    name: scratch
    contexts:
    - context:
        cluster: development
        namespace: frontend
        user: developer
    name: dev-frontend
    - context:
        cluster: development
        namespace: storage
        user: developer
    name: dev-storage
    - context:
        cluster: scratch
        namespace: default
        user: experimenter
    name: exp-scratch
    current-context: ""
    kind: Config
    preferences: {}
    users:
    - name: developer
    user:
        client-certificate: fake-cert-file
        client-key: fake-key-file
    - name: experimenter
    user:
        password: some-password
        username: exp
    '''

`kubectl` config is stored by default in `$HOME/.kube/config`. The default
location are several locations can be set in `$KUBECONFIG`.

## helm

## kustomize
