# Kubernetes


## K8S components

Brendan Burns

### Elements of orchestration

![Node components](https://d33wubrfki0l68.cloudfront.net/7016517375d10c702489167e704dcb99e570df85/7bb53/images/docs/components-of-kubernetes.png)

Orchestrator role: get a status defined declarativly by the prgrammer.



### Control Plane Components

* **kube-apiserver** exposes K8S API.
* **etcd** <badge-stars repo='etcd-io/etcd'></badge-stars> is distributed key-value store used to store all cluster data.
* **kube-scheduler** watches and decide on why node to run newly created pods.
* **kube-controller-manager**
      - *Node controller*: notices and responds when nodes go down.
      - *Replication controller*: maintains the correct number of pods for every replication controller object
      - *Endpoints controller*: populates the Endpoints object (that is, joins Services & Pods).
      - *Service Account & Token controllers*: creates default accounts and API access tokens.
* **cloud-controller-manager** embeds cloud-specific control logic, e.g.:
     * *Node controller*: checks the cloud provider to determine if a node has been deleted in the cloud after it stops responding
     * *Route controller*: sets up routes
     * *Service controller*: creates, updates and deletes cloud provider load balancers

### Node Components

* **kubelet** is an agent running on each node that starts and monitor the container runtime workloads.
* **kube-proxy** routes inter-pod and internet requests.
* **Container runtime** is responsible for running containers (usually Docker).


### Objects

#### Pods

Set of containers, all containers inside a port share a port-space. An appliciation-specfic "logical host". A pod is started on a node: containers in the pod can communicate over localhost.



### Deployments and ReplicaSets

Desired state definition for pods. Deployment strategies on Kubernetes


Kubernetes Examples <badge-stars repo='ContainerSolutions/kubernetes-examples'></badge-stars>

#### Strategies

 Kubernetes deployment strategies explained <badge-stars repo='ContainerSolutions/k8s-deployment-strategies'></badge-stars>

<div class="table_initial"></div>

| Strategy                                                                                                  | ZERO DOWNTIME | REAL TRAFFIC  TESTING | TARGETED USER | CLOUD COST | ROLLBACK DURATION | NEGATIVE IMPACT ON USER | COMPLEXITY OF SETUP |
|-----------------------------------------------------------------------------------------------------------|:-------------:|:---------------------:|:-------------:|:----------:|:-----------------:|:-----------------------:|:-------------------:|
| **RECREATE**</br/>Version A is terminated then version B is rolled out                                    |       ✗       |           ✗           |       ✗       |   ⬛⬜⬜   |       ⬛⬛⬛      |          ⬛⬛⬛         |        ⬜⬜⬜       |
| **RAMPED**</br/>Version B is slowly rolled out and replacing version A                                    |       ✓       |           ✗           |       ✗       |   ⬛⬜⬜   |       ⬛⬛⬛      |          ⬛⬜⬜         |        ⬛⬜⬜       |
| **BLUE/GREEN**</br/>version A and B are released alongside, then traffic switched to B                    |       ✓       |           ✗           |       ✗       |   ⬛⬛⬛   |       ⬜⬜⬜      |          ⬛⬛⬜         |        ⬛⬛⬜       |
| **CANARY**</br/>version B is released to a subset of users before full rollout                            |       ✓       |           ✓           |       ✗       |   ⬛⬜⬜   |       ⬛⬜⬜      |          ⬛⬜⬜         |        ⬛⬛⬜       |
| **A/B TESTING**</br/>version B is released to a subset of users under specific conditions                 |       ✓       |           ✓           |       ✓       |   ⬛⬜⬜   |       ⬛⬜⬜      |          ⬛⬜⬜         |        ⬛⬛⬛       |
| **SHADOW**</br/>version B receives seal world traffic alongside version A and doesn't impact the responce |       ✓       |           ✓           |       ✗       |   ⬛⬛⬛   |       ⬜⬜⬜      |          ⬜⬜⬜         |        ⬛⬛⬛       |
[*Source*](https://www.cncf.io/wp-content/uploads/2020/08/CNCF-Presentation-Template-K8s-Deployment.pdf)


## Bridge to Kubernetes


On Azure Dev Spaces tooling [AZDS Connect](https://code.visualstudio.com/docs/containers/bridge-to-kubernetes), [repo to extension](https://github.com/Microsoft/mindaro)

Outer loop

## Networking

### Ingress and Egress flows


Ingress enables traffic from outside the cluster. A LoadBalancer service provides the routing to the pod.

CNI: Container Network Interface


2 options:
- in cluster Ingress Controller
- External Ingress Controller


  - Nginx
  - Kong
  - Azure AppGW
  - ..

Azure: AGIC (Application Gateway Ingress Controller)

DNS operator
allow for dynamic configuraiton of DNS records

### Kubernetes network policy

kind: NetworkPolicy (networking.k8s.io/v1)

- Only ingress controlle is public
- namespaces for different workloads
- DMS names automatically maintained by opertaurs
- network policies for isolatind workloards against each other

### Securing  your identities and secrets

- identities on Azure: aad-pod-identiy
- secrets on Azure: kubernetes-keyvault-flextool (today) -> secrets-store-csi-driver (soon)

Azure Securtiy Center on AKS:
- continuoous discovery of managed AKS instances
- actionable recommendations...
- ...

### Policies

- prevent any publics ips on the load balancer
- no image from repo xyz
- ...

No native kubernetes solution for this.




## Giant swarm

Cloud native for entreprise



## Day 2 operation

try to ensure everything is:
- immutable
- automated
- declarative
- operated


## Testing

**conftest** <badge-stars repo='open-policy-agent/conftest'></badge-stars> helps defining tests against structured configuration data for Kubernetes configuration, Tekton pipeline definitions, Terraform code, Serverless configs or any other config files.

## Tools

### GitOps

**flux2** <badge-stars repo='fluxcd/flux2'></badge-stars> <badge-doc href='https://toolkit.fluxcd.io'></badge-doc> is constructed
with the GitOps Toolkit and is a tool for keeping Kubernetes clusters in sync
with sources of configuration (like Git repositories), and automating updates to
configuration when there is new code to deploy.

### Tracing

- applicaton Insights (Azure)
- [OpenCensus](https://github.com/census-instrumentation) /
  [OpenTelemetry](https://github.com/open-telemetry)

  - **Zipkin** (java) <badge-stars repo='openzipkin/zipkin'></badge-stars>
  - **Jaeger** (go) <badge-stars repo='jaegertracing/jaeger'></badge-stars>

### Others

**dapr.io** <badge-stars repo='dapr/dapr'></badge-stars> is a portable,
event-driven, runtime for building distributed applications across cloud and
edge.

- Service invocation over API
- State management: key/value
- Publish and subscribe `v1.0/publish/`

![Overview](https://raw.githubusercontent.com/dapr/dapr/master/img/overview.png)
