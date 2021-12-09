---
title: "Minio in podman"
date: 2021-10-22T07:14:13+02:00
draft: false
slug: podman_minio
categories:
- Development
- Podman
url: /posts/bla/
tags:
- podman
- container
- s3
- minio
---

# Podman

{{<hint info>}}
**MinIO**

MinIO is API compatible with Amazon’s S3 cloud storage service released under the [GNU Affero General Public License v3.0](https://www.gnu.org/licenses/agpl-3.0.en.html)
{{</hint>}}


```shell
podman run
  --detach \
  --volume minio:/data \
  --pod minio \
  minio/minio:latest server --console-address :9090 /data
```

## Port forwarding

Port auto-forwarding was added to [podman 3.4.0](https://github.com/containers/podman/issues/11396)

Mouting the volume is


# bla


{{< gist spf13 7896402 >}}
