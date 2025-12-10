# Helm Helpers 🛠️

The `helm helpers` is a helm library to assist when creating charts.

Its offers multiples functions to create common Kubernetes resources.

## Service 🌐

the `gsaiki-helpers.service` function create a service resource.

### Arguments

| Name                  | Type              | Description                                               |
| --------------------- | ----------------- | --------------------------------------------------------- |
| `name`                | string            | The name of the service.                                  |
| `nameSuffix`          | (Optional) string | Suffix to append to the service name. Defaults to "-svc". |
| `instance`            | (Optional) string | The instance label value.                                 |
| `component`           | (Optional) string | The component label value.                                |
| `labels`              | map[string]string | Additional labels to add to the service.                  |
| `annotations`         | map[string]string | Annotations to add to the service.                        |
| `type`                | (Optional) string | The type of the service. Defaults                         |
| `ports`               | list              | List of ports to expose. Each port is a map with keys:    |
| `ports[*].port`       | int               | The port number to expose.                                |
| `ports[*].targetPort` | (Optional) int    | The target port number. Defaults to `port`.               |
| `ports[*].nodePort`   | (Optional) int    | The node port number (for NodePort services).             |
| `ports[*].portName`   | (Optional) string | The name of the port.                                     |
| `ports[*].protocol`   | (Optional) string | The protocol (TCP/UDP). Defaults to "TCP".                |
