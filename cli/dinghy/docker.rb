# This wraps the `docker` binary and ensures that we can use it even if the
# shell doesn't have the necessary ENV vars set.
class Docker
  attr_reader :machine

  def initialize(machine, check_env = nil)
    @machine = machine
    @check_env = check_env || CheckEnv.new(machine)
  end

  def exec(*command)
    system("docker",*command)
  end

  def compose(*command)
    system("docker-compose",*command)
  end

  protected

  # Make sure to restore the old env afterwards, so that CheckEnv can validate
  # the user's environment.
  def set_env
    old_env = {}
    @check_env.expected.each { |k,v| old_env[k] = ENV[k]; ENV[k] = v }
    yield
  ensure
    old_env.each { |k,v| ENV[k] = v }
  end

  def system(binary,*command)
    set_env do
      Kernel.system(binary, *command)
    end
  end
end