# Cloud native

## Definition


!!! quote "CNCF Coud Native Definition v1.0"

    === "English"

        Cloud native technologies empower organizations to build and run scalable applications in modern, dynamic environments such as public, private, and hybrid clouds. Containers, service meshes, microservices, immutable infrastructure, and declarative APIs exemplify this approach.

        These techniques enable loosely coupled systems that are resilient, manageable, and observable. Combined with robust automation, they allow engineers to make high-impact changes frequently and predictably with minimal toil.
      
        The Cloud Native Computing Foundation seeks to drive adoption of this paradigm by fostering and sustaining an ecosystem of open source, vendor-neutral projects. We democratize state-of-the-art patterns to make these innovations accessible for everyone.  

    === "Français"

        Les technologies nativement cloud permettent aux entreprises de construire et d'exploiter des applications élastiques dans des environnements modernes et dynamiques comme des clouds publics, privés ou bien hybrides. Les conteneurs, les services maillés, les micro services, les infrastructures immuables et les API déclaratives illustrent cette approche.

        Ces techniques permettent la mise en œuvre de systèmes faiblement couplés, à la fois résistants, pilotables et observables. Combinés à un robuste système d'automatisation, ils permettent aux ingénieurs de procéder à des modifications impactantes, fréquemment et de façon prévisible avec un minimum de travail.

        La Cloud Native Computing Foundation cherche à favoriser l'adoption de ce paradigme en encourageant et en soutenant un écosystème de projets "opensource" et indépendants. Nous démocratisons l'état de l'art des pratiques afin de rendre l'innovation accessible à tous.

    === "Deutsch"

        Cloud native Technologien ermöglichen es Unternehmen, skalierbare Anwendungen in modernen, dynamischen Umgebungen zu implementieren und zu betreiben. Dies können öffentliche, private und Hybrid-Clouds sein. Best-Practises, wie Container, Service-Meshs, Microservices, immutable Infrastruktur und deklarative APIs, unterstützen diesen Ansatz.

        Die zugrundeliegenden Techniken ermöglichen die Umsetzung von entkoppelten Systemen, die belastbar, handhabbar und beobachtbar sind. Kombiniert mit einer robusten Automatisierung können Softwareentwickler mit geringem Aufwand flexibel und schnell auf Änderungen reagieren.
        
        Die Cloud Native Computing Foundation fördert die Akzeptanz dieser Paradigmen durch die Ausgestaltung eines Open Source Ökosystems aus herstellerneutralen Projekten. Wir demokratisieren modernste und innovative Softwareentwicklungs-Patterns, um diese Innovationen für alle zugänglich zu machen.

## Microservices

Status: Application where all configuration, and config run on a guest OS in a VM. For scaling, a new VM must be set up.

Containers: Application run in containers with config, binarires and libraries. Abstraction over operating system.

Elements of orchestration: Kubernetes 

## Serverless vs containers:

- Abstraction of servers
- Event driven/event scale
- Micro-billing

Cloud native uses DevOps

Develop, Deliver, Operate, Security


## Pattern

[**Fallacies of distributed computing**](https://en.wikipedia.org/wiki/Fallacies_of_distributed_computing) are a set of assertions made by L Peter Deutsch and others at Sun Microsystems describing false assumptions that programmers new to distributed applications invariably make:

- The network is reliable;
- Latency is zero;
- Bandwidth is infinite;
- The network is secure;
- Topology doesn't change;
- There is one administrator;
- Transport cost is zero;
- The network is homogeneous.

### Retry Pattern

On failure, an application retries to connect the server


### Circuit Breaker Pattern

If a service is not available, the user can become quicker information on the failure. Kind of proxy. Made through a State machine:

- Open
- Closed: a timer will be increased. Over a threshold, no requests any more
- Half-Open: an amount of requests are satisfied; Over a threshold, goes in closed


### Pub & Sub 

A sender can reach several consumer without to know which part is interesting for the consumer

Message Broker: from an input channel, fills output channels that can be consummed by consumers.


## Work at scale

**vertical scaling** k
horizontal scaling involves service instances, e.g. load balancer in K8s

