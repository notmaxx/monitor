# Set Tag Configuration
[tags]

{{ if .GLOBAL_TAGS }}
[global_tags]
  {{ range $index, $item := split "," .GLOBAL_TAGS }}
    {{ $value := split ":" $item }}{{ $value._0 }}={{ $value._1 | quote }}
  {{end}}
{{ end }}

# Set Agent Configuration
[agent]
  interval = {{ default "10s" .AGENT_INTERVAL | quote }}
  round_interval = {{ default true .AGENT_ROUND_INTERVAL }}
  metric_buffer_limit = {{ default "10000" .AGENT_BUFFER_LIMIT }}
  collection_jitter = {{ default "1s" .AGENT_COLLECTION_JITTER | quote }}
  flush_interval = {{ default "1s" .AGENT_FLUSH_INTERVAL | quote }}
  flush_jitter = {{ default "0s" .AGENT_FLUSH_JITTER | quote }}
  debug = {{ default false .AGENT_DEBUG }}
  quiet = {{ default false .AGENT_QUIET }}
  flush_buffer_when_full = {{ default true .AGENT_FLUSH_BUFFER }}
  {{ if .AGENT_HOSTNAME }}hostname = {{ .AGENT_HOSTNAME | quote }} {{ end }}

# Set output configuration
{{ if .LIBRATO_API_TOKEN }}
[[outputs.librato]]
  api_user = {{ .LIBRATO_API_USER }}
  api_token = {{ .LIBRATO_API_TOKEN }}
  source_tag = {{ .LIBRATO_SOURCE_TAG | quote }}
{{ end }}

{{ if and .AWS_CLOUDWATCH_ENABLE .AWS_CLOUDWATCH_ACCESS_KEY}}
[[outputs.cloudwatch]]
  region = {{ .AWS_CLOUDWATCH_REGION | quote }}
  namespace = {{ .AWS_CLOUDWATCH_NAMESPACE | quote }}
  access_key = {{ .AWS_CLOUDWATCH_ACCESS_KEY | quote }}
  secret_key = {{ .AWS_CLOUDWATCH_SECRET_KEY | quote }}
{{ end }}

# Set Input Configuration

# skip machine information
# [[inputs.netstat]]
# [[inputs.swap]]
# [[inputs.system]]
# [[inputs.mem]]
# [[inputs.cpu]]
#   percpu = true
#   totalcpu = true
#
# [[inputs.disk]]
#   {{ if .DISK_MOUNT_POINTS }} mount_points = [{{ .DISK_MOUNT_POINTS }}] {{ end }}
#
# [[inputs.diskio]]
#   {{ if .DISKIO_DEVICES }} devices = [{{ .DISKIO_DEVICES }}] {{ end }}
#   {{ if .DISKIO_SKIP_SERIAL_NUMBER }} skip_serial_number = {{ .DISKIO_SKIP_SERIAL_NUMBER }} {{ end }}
#
# [[inputs.net]]
#   {{ if .NET_INTERFACES }} interfaces = [{{ .NET_INTERFACES}}] {{ end }}

# kubernetes - https://github.com/influxdata/telegraf/tree/master/plugins/inputs/kubernetes
{{ if and .KUBERNETES_URL .ENABLE_KUBERNETES }}
[[inputs.kubernetes]]
  url = {{ .KUBERNETES_URL | quote }}
  bearer_token = {{ .KUBERNETES_BEARER_TOKEN_PATH | quote }}
  {{ if .KUBERNETES_SSL_CA }} ssl_ca = {{ .KUBERNETES_SSL_CA | quote }} {{ end }}
  {{ if .KUBERNETES_SSL_CERT }} ssl_cert = {{ .KUBERNETES_SSL_CERT | quote }} {{ end }}
  {{ if .KUBERNETES_SSL_KEY }} ssl_key = {{ .KUBERNETES_SSL_KEY | quote }} {{ end }}
  insecure_skip_verify = {{ default true .KUBERNETES_INSECURE_SKIP_VERIFY }}
  # prefix with namespace
  name_prefix = {{ .KUBERNETES_ENV_PREFIX | quote }}
  # drop most of information to reduce traffic
  {{ if .KUBERNETES_LITE_MODE_ENABLED }}
  {{ $var_full_name_container_pass := printf "%s%s" .KUBERNETES_ENV_PREFIX "kubernetes_pod_container" }}
  {{ $var_full_name_network_pass := printf "%s%s" .KUBERNETES_ENV_PREFIX "kubernetes_pod_network" }}
  namepass = [ {{ $var_full_name_container_pass | quote }}, {{ $var_full_name_network_pass | quote }} ]
  fieldpass = [ "cpu_usage_nanocores", "memory_usage_bytes", "rx_bytes", "tx_bytes" ]
  {{ end }}
{{ end }}

# collect custom information
# see exec plugin https://github.com/influxdata/telegraf/tree/master/plugins/inputs/exec

# collect docker information
# {{ if .DOCKER_ENDPOINT }}
# [[inputs.docker]]
#   endpoint = {{ .DOCKER_ENDPOINT | quote }}
#   container_names = [{{ if .DOCKER_CONTAINER_NAMES }}{{ .DOCKER_CONTAINER_NAMES }}{{ end }}]
# {{ end }}

# collect information about nginx (https://github.com/influxdata/telegraf/tree/master/plugins/inputs/nginx)
# {{ if .NGINX_URLS }}
# [[inputs.nginx]]
#   urls = [{{ .NGINX_URLS }}]
# {{ end }}

# collect information about postgresql
# {{ if .POSTGRESQL_ADDRESS }}
# [[inputs.postgresql]]
#   address = {{ .POSTGRESQL_ADDRESS | quote }}
#   {{ if .POSTGRESQL_DATABASES }} databases = [{{ .POSTGRESQL_DATABASES }}]  {{ end }}
# {{ end }}

# collect master-node & etcd information (in prometheus format - https://github.com/influxdata/telegraf/tree/master/plugins/inputs/prometheus)
# {{ if and .PROMETHEUS_URLS .ENABLE_PROMETHEUS }}
# [[inputs.prometheus]]
#   urls = [{{ .PROMETHEUS_URLS }}]
#   insecure_skip_verify = {{ default true .PROMETHEUS_INSECURE_SKIP_VERIFY }}
#   bearer_token = {{ .PROMETHEUS_BEARER_TOKEN_PATH | quote }}
# {{ end }}

# {{ if .ENABLE_ETCD }}
# [[inputs.prometheus]]
#   urls = [{{ .ETCD_URLS }}]
# {{ end }}

