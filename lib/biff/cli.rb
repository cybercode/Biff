require 'biff'
require 'biff/options'

class Biff::CLI
  attr_reader :servers

  def initialize
    @servers = {}

    options = Biff::Options.new
    options.parse!

    options.config.each do |name, config|
      config['debug'] ||= options.debug
      config['verbose'] ||= options.verbose
      config['name'] = name
      $stderr.puts("INFO #{name}") if options.verbose

      b = @servers[name] = Biff.new(config)
      b.open
      b.count
    end
  end

  def disconnect
    map_servers(&:disconnect)
  end

  def listen(&block)
    threads = []
    map_servers do |obj|
      threads << Thread.new do
        obj.listen(&block)
      end
    end

    threads
  end

  def update
    count
    map_servers(&:notify)
    map_servers(&:run)
  end

  def count
    map_servers(&:count)
  end

  def status
    map_servers(&:status)
  end

  def map_servers
    @servers.values.map do |obj|
      yield obj
    end
  end
end
