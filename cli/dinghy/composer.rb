require 'stringio'
require 'yaml'
require 'tempfile'

require 'dinghy/machine'
require 'dinghy/container'

class Composer
  PROJECT_NAME = 'dinghy'

  attr_reader :machine, :containers

  def initialize(machine,containers)
    @machine = machine
    @containers = containers
  end

  def up
    puts "Starting containers: #{containers.keys.join(',')}"
    compose_yaml = Tempfile.new('compose.yml')
    compose_yaml.write({"version" => "2", "services" => containers}.to_yaml)
    compose_yaml.close
    docker.compose("-f", compose_yaml.path, "-p", PROJECT_NAME, "up", "-d")
  end

  def statuses
    container_statuses = {}
    containers.each do |name, container|
      container_statuses[name] = Container.new(machine,"#{PROJECT_NAME}_#{name}_1").status
    end

    return container_statuses
  end

  private

  def docker
    @docker ||= Docker.new(machine)
  end
end
