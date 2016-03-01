require 'stringio'

require 'dinghy/machine'

class Container

  attr_reader :machine, :container_name, :image_name, :ports, :volumes

  def initialize(machine,container_name,image_name=nil,ports="80:80",volumes=nil)
    @machine = machine
    @container_name = container_name
    @image_name = image_name
    @ports = ports
    @volumes = volumes
  end

  def up
    puts "Starting #{container_name}"
    System.capture_output do
      docker.exec("rm", "-fv", container_name)
    end
    args = []
    volumes.each{|volume| args += ['-v',volume]}
    args += ["-d", "-p", ports, "-e", "CONTAINER_NAME=#{container_name}", "--name", container_name, image_name]
    docker.exec("run", *args)
  end

  def status
    return "stopped" if !machine.running?

    output, _ = System.capture_output do
      docker.exec("inspect", "-f", "{{ .State.Running }}", container_name)
    end

    if output.strip == "true"
      "running"
    else
      "stopped"
    end
  end

  private

  def docker
    @docker ||= Docker.new(machine)
  end
end
