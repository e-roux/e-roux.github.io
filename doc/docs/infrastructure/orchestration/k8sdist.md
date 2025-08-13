# Kubernetes distribution

## Minikube

**Minikube** <badge-stars repo='kubernetes/minikube'></badge-stars> <badge-doc href="https://minikube.sigs.k8s.io"></badge-doc> installs a local kubernetes cluster. 

### Installation

Direct download via:

```terminal
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 \
  && chmod +x minikube
```

### Driver:

The [vmware driver](https://minikube.sigs.k8s.io/docs/drivers/vmware/)
 supports virtualization across all VMware based hypervisors.

```bash
r=https://api.github.com/repos/machine-drivers/docker-machine-driver-vmware
curl -LO $(curl -s $r/releases/latest | grep -o 'http.*darwin_amd64' | head -n1) \
 && install docker-machine-driver-vmware_darwin_amd64 \
   /usr/local/bin/docker-machine-driver-vmware
```

## OpenShift


### Service accounts

List service accounts:

```bash
oc get serviceaccounts
```

Service accounts can be created with `oc create sa <ACCOUNTNAME>`, the informations relative to this account can be displayed with `oc describe sa <ACCOUNTNAME>`.

Namespace, labels, annotations, secrets, tokens and events can de parsed, e.g. for a secret cert:

```bash
oc get secret <ACCOUNTNAME>-token-<RANDOM> -o "jsonpath={.data['service-ca\.crt']}" | base64 -d
```


### Resources

**Quota** can be visualized per namespace with `oc describe quota`

**Usage** can be visualized for resources `images`, `imagestreams`, `node` and `pods` with `oc adm top <RESOURCE>`. This one is a built on `kubectl top <RESOURCE>`.


## Minishift

**Minishift** <badge-stars repo='minishift/minishift'></badge-stars> <badge-doc href='https://docs.okd.io'></badge-doc> is a tool that helps run OpenShift locally by running a single-node OpenShift cluster inside a VM.


Note:

[^1]: [Install minikube](https://kubernetes.io/docs/tasks/tools/install-minikube/)
