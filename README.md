# Helm Helpers 🛠️

**Helm Helpers** is a Helm **library chart** designed to simplify and standardize the creation of common Kubernetes resources.

It provides reusable helper templates that reduce duplication and enforce consistent defaults across charts.

---

## Common Values

The following values are **shared by all helpers** and can be used in **any** resource:

| Name          | Type               | Description                                                                   |
| ------------- | ------------------ | ----------------------------------------------------------------------------- |
| `name`        | *string            | Base name of the resource. Defaults to the release name.                      |
| `nameSuffix`  | string             | Suffix appended to the resource name. Use this for distinguish the resources. |
| `instance`    | string             | Value for the `app.kubernetes.io/instance` label.                             |
| `component`   | string             | Value for the `app.kubernetes.io/component` label.                            |
| `labels`      | map[string,string] | Additional labels applied to the resource.                                    |
| `annotations` | map[string,string] | Annotations applied to the resource.                                          |

---

## Kubernetes Native ☸️

### ConfigMap — `gsaiki-helpers.configMap`

| Name   | Type               | Description                                                                                                                   |
| ------ | ------------------ | ----------------------------------------------------------------------------------------------------------------------------- |
| `data` | map[string,string] | Key-value pairs stored in the ConfigMap. Each key is created as a file or environment entry, depending on how it is consumed. |

---

### Deployment — `gsaiki-helpers.deployment`

| Name                                     | Type            | Description                                                   |
| ---------------------------------------- | --------------- | ------------------------------------------------------------- |
| `replicas`                               | int             | Number of pod replicas. Default: `1`.                         |
| `containers`                             | *list[map]      | List of containers in the pod.                                |
| `containers[*].name`                     | *string         | Container name.                                               |
| `containers[*].image`                    | *map            | Container image configuration.                                |
| `containers[*].image.name`               | *string         | Image name (e.g. `nginx`).                                    |
| `containers[*].image.tag`                | *string         | Image tag (e.g. `latest`).                                    |
| `containers[*].image.pullPolicy`         | *string         | Image pull policy. Default: `IfNotPresent`.                   |
| `containers[*].probes`                   | map             | Container health probes.                                      |
| `containers[*].probes.startup`           | DeploymentProbe | Startup probe configuration.                                  |
| `containers[*].probes.readiness`         | DeploymentProbe | Readiness probe configuration.                                |
| `containers[*].probes.liveness`          | DeploymentProbe | Liveness probe configuration.                                 |
| `containers[*].cpu`                      | map             | CPU resource configuration.                                   |
| `containers[*].cpu.requests`             | string          | Requested CPU. Default: `50m`.                                |
| `containers[*].cpu.limits`               | string          | CPU limit. Default: `50m`.                                    |
| `containers[*].memory`                   | map             | Memory resource configuration.                                |
| `containers[*].memory.requests`          | string          | Requested memory. Default: `128Mi`.                           |
| `containers[*].memory.limits`            | string          | Memory limit. Default: `128Mi`.                               |
| `containers[*].env`                      | list[map]       | Environment variables.                                        |
| `containers[*].env[*].name`              | *string         | Environment variable name.                                    |
| `containers[*].env[*].value`             | string          | Environment variable value.                                   |
| `containers[*].env[*].type`              | string          | Source type (`secretRef`, `configMapRef`).                    |
| `containers[*].ports`                    | list[map]       | Container ports to expose.                                    |
| `containers[*].ports[*].port`            | *int            | Container port number.                                        |
| `containers[*].ports[*].name`            | string          | Port name.                                                    |
| `containers[*].ports[*].protocol`        | string          | Network protocol. Default: `TCP`.                             |
| `containers[*].volumes`                  | list[map]       | Volumes mounted into the container.                           |
| `containers[*].volumes[*].name`          | *string         | Volume name.                                                  |
| `containers[*].volumes[*].type`          | *string         | Volume type (`persistentVolumeClaim`, `configMap`, `secret`). |
| `containers[*].volumes[*].items`         | list[map]       | Key-to-path mappings (only for `configMap`).                  |
| `containers[*].volumes[*].items[*].key`  | string          | ConfigMap key.                                                |
| `containers[*].volumes[*].items[*].path` | string          | File path inside the volume.                                  |
| `containers[*].volumes[*].mountPath`     | *string         | Mount path inside the container.                              |
| `containers[*].volumes[*].subPath`       | string          | Sub-path within the volume.                                   |
| `containers[*].volumes[*].readOnly`      | bool            | Mount as read-only. Default: `false`.                         |

#### Deployment Probe - `gsaiki-helpers.deploymentProbe`

| Name                  | Type         | Description                                          |
| --------------------- | ------------ | ---------------------------------------------------- |
| `httpGet`             | map          | HTTP probe configuration.                            |
| `httpGet.path`        | string       | HTTP path to probe.                                  |
| `httpGet.port`        | int          | Port to access for the HTTP probe.                   |
| `command`             | list[string] | Command executed inside the container (exec probe).  |
| `periodSeconds`       | int          | Probe interval. Default: `30`.                       |
| `timeoutSeconds`      | int          | Probe timeout. Default: `10`.                        |
| `initialDelaySeconds` | int          | Initial delay before the first probe. Default: `10`. |
| `failureThreshold`    | int          | Failure threshold. Default: `3`.                     |
| `successThreshold`    | int          | Success threshold. Default: `3`.                     |


---

### HTTPRoute — `gsaiki-helpers.httpRoute`

| Name                            | Type          | Description                                                  |
| ------------------------------- | ------------- | ------------------------------------------------------------ |
| `gateways`                      | *list[map]    | Gateway references for the route.                            |
| `gateways[*].name`              | *string       | Gateway name.                                                |
| `gateways[*].namespace`         | *string       | Gateway namespace.                                           |
| `hostnames`                     | *list[string] | Hostnames matched by the route.                              |
| `rules`                         | *list[map]    | Routing rules.                                               |
| `rules[*].matches`              | *list[map]    | Match conditions.                                            |
| `rules[*].matches[*].matchType` | *string       | Match target (path, header, query).                          |
| `rules[*].matches[*].type`      | *string       | Match operator (`PathPrefix`, `Exact`, `RegularExpression`). |
| `rules[*].matches[*].value`     | *string       | Match value (e.g. `/`).                                      |
| `rules[*].backendRefs`          | *list[map]    | Backend service references.                                  |
| `rules[*].backendRefs[*].name`  | *string       | Backend Service name.                                        |
| `rules[*].backendRefs[*].port`  | *string       | Backend Service port.                                        |

---

### PersistentVolumeClaim — `gsaiki-helpers.pvc`

| Name                | Type         | Description                                 |
| ------------------- | ------------ | ------------------------------------------- |
| `storage`           | *map         | Storage request configuration.              |
| `storage.requests`  | *string      | Requested storage size (e.g. `10Gi`).       |
| `storageClass`      | map          | StorageClass configuration.                 |
| `storageClass.name` | string       | StorageClass name.                          |
| `volumeMode`        | string       | Volume mode. Default: `Filesystem`.         |
| `accessModes`       | list[string] | Access modes. Default: `["ReadWriteOnce"]`. |

---

### Service — `gsaiki-helpers.service`

| Name                  | Type   | Description                        |
| --------------------- | ------ | ---------------------------------- |
| `ports`               | list   | Ports exposed by the Service.      |
| `ports[*].port`       | int    | Service port.                      |
| `ports[*].targetPort` | int    | Target port. Defaults to `port`.   |
| `ports[*].nodePort`   | int    | NodePort (NodePort services only). |
| `ports[*].portName`   | string | Port name.                         |
| `ports[*].protocol`   | string | Protocol. Default: `TCP`.          |

---

## External Resources

### ExternalSecret — `gsaiki-helpers.externalSecret`

| Name               | Type               | Description                                                     |
| ------------------ | ------------------ | --------------------------------------------------------------- |
| `refreshInterval`  | string             | Refresh interval. Default: `5m`.                                |
| `secretStore`      | *map               | Secret store reference.                                         |
| `secretStore.name` | *string            | SecretStore or ClusterSecretStore name.                         |
| `secretStore.kind` | string             | Store kind. Default: `ClusterSecretStore`.                      |
| `references`       | map[string,object] | Raw ExternalSecret fields merged directly (`data`, `dataFrom`). |

> [!NOTE] The generated Kubernetes Secret uses the same resource name as the `ExternalSecret`.
