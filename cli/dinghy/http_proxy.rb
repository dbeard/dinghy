require 'dinghy/container'

class HttpProxy < Container
  CONTAINER_NAME = "dinghy_http_proxy"
  IMAGE_NAME = "codekitchen/dinghy-http-proxy:2.0.2"
  PORTS = "80:80"
  VOLUMES= ["/var/run/docker.sock:/tmp/docker.sock", "/usr/local/bin/docker:/usr/local/bin/docker"]

  def initialize(machine)
    super(machine,CONTAINER_NAME,IMAGE_NAME,PORTS,VOLUMES)
  end
end
