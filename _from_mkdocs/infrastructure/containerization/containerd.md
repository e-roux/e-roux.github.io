# Docker


## Containerd 

- A “container runtime” layer located between platforms (Docker,
  Kubernetes) and lower level runtimes (runc, Kata, Firecracker,
  gVisor)
- a resource manager for container processes, image
  artifacts, filesystem snapshots, metadata and dependencies

Originally built up alongside Docker, the project was nor forked nor inherited but grew in scope from a container supervisor to full runtime. Completely new interfaces for managing containers and images were created.

![Containerd](https://containerd.io/img/architecture.png)

  Source: https://static.sched.com/hosted_files/kccnceu20/99/2020%20-%20Kubecon%20EU%20Introduction-containerd.pdf



https://youtube.com/watch?v=aVReM1D82iY
https://static.sched.com/hosted_files/kccnceu20/c1/containerd-deep-dive.pdf

https://youtube.com/c/cloudnativef
