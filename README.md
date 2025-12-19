# Helm Helpers 🛠️

The `helm helpers` is a helm library to assist when creating charts.

Its offers multiples functions to create common Kubernetes resources.

In order to avoid repeating the same properties all over again, these are common values which can be used in **ANY** function:
| Name          | Type               | Description                                                            |
| ------------- | ------------------ | ---------------------------------------------------------------------- |
| `name`        | *string            | The name of the resource.                                              |
| `nameSuffix`  | string             | Suffix to append in the resource name. Defaults to resource's acronym. |
| `instance`    | string             | The instance label value.                                              |
| `component`   | string             | The component label value.                                             |
| `labels`      | map[string,string] | Additional labels to add to the resource.                              |
| `annotations` | map[string,string] | Annotations to add to the resource.                                    |


## Kubernetes Native ☸️
### HTTPRoute - `gsaiki-helpers.httpRoute`
| Name                            | Type          | Description                                             |
| ------------------------------- | ------------- | ------------------------------------------------------- |
| `gateways`                      | *list[map]    | List of Gateway references for the route.               |
| `gateways[*].name`              | *string       | Name of the referenced Gateway.                         |
| `gateways[*].namespace`         | *string       | Namespace of the referenced Gateway.                    |
| `hostnames`                     | *list[string] | Hostnames the route will match.                         |
| `rules`                         | *list[map]    | Routing rules for the route.                            |
| `rules[*].matches`              | *list[map]    | Match conditions for the rule.                          |
| `rules[*].matches[*].matchType` | *string       | Type of match to apply (e.g. Path, Header, Query).      |
| `rules[*].matches[*].type`      | *string       | Match operator (e.g. Exact, Prefix, RegularExpression). |
| `rules[*].matches[*].value`     | *string       | Value used for matching.                                |
| `rules[*].backendRefs`          | *list[map]    | Backend service references for the rule.                |
| `rules[*].backendRefs[*].name`  | *string       | Name of the backend Service.                            |
| `rules[*].backendRefs[*].port`  | *string       | Port of the backend Service.                            |


### Persistant Volume Claim - `gsaiki-helpers.pvc`
| Name                | Type         | Description                                               |
| ------------------- | ------------ | --------------------------------------------------------- |
| `storage`           | *map         | Storage configuration for the PersistentVolumeClaim.      |
| `storage.requests`  | *string      | Requested storage size (e.g. `10Gi`).                     |
| `storageClass`      | map[string]  | StorageClass configuration for the volume.                |
| `storageClass.name` | string       | Name of the StorageClass to use.                          |
| `volumeMode`        | string       | Volume mode for the PVC. Defaults to `Filesystem`.        |
| `accessModes`       | list[string] | Access modes for the PVC. Defaults to `["ReadWriteOnce"]` |

### Service - `gsaiki-helpers.service`

| Name                  | Type              | Description                                            |
| --------------------- | ----------------- | ------------------------------------------------------ |
| `ports`               | list              | List of ports to expose. Each port is a map with keys: |
| `ports[*].port`       | int               | The port number to expose.                             |
| `ports[*].targetPort` | (Optional) int    | The target port number. Defaults to `port`.            |
| `ports[*].nodePort`   | (Optional) int    | The node port number (for NodePort services).          |
| `ports[*].portName`   | (Optional) string | The name of the port.                                  |
| `ports[*].protocol`   | (Optional) string | The protocol (TCP/UDP). Defaults to "TCP".             |

## External Resources
### External Secret - `gsaiki-helpers.externalSecret`
| Name               | Type                | Description                                                                                                    |
| ------------------ | ------------------- | -------------------------------------------------------------------------------------------------------------- |
| `refreshInterval`  | string              | Interval at which the ExternalSecret is refreshed. Defaults to `5m`.                                           |
| `secretStore`      | *map                | SecretStore or ClusterSecretStore reference configuration.                                                     |
| `secretStore.name` | *string             | Name of the referenced SecretStore or ClusterSecretStore.                                                      |
| `secretStore.kind` | string              | Kind of the secret store. Defaults to `ClusterSecretStore`.                                                    |
| `references`       | map[string, object] | Raw ExternalSecret fields merged directly into the manifest (e.g. `data`, `dataFrom`). Must follow its schema. |
> [!NOTE] The created secret will be the same as the `name`, without the `namePrefix`.
