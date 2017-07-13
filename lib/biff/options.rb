require 'optparse'
require 'yaml'

class Biff::Options
  ARGS = {
    debug: 'Debug IMAP connection',
    file: ['Config file', 'FILE', '~/.biff.yaml']
  }.freeze

  attr_accessor(*ARGS.keys)

  def parse!
    parser = OptionParser.new do |o|
      o.banner = 'Usage: biff [options]'

      ARGS.each do |k, v|
        default = false

        if v.is_a?(Array)
          default = v[2]
          v = ["#{v[0]} (default #{v[2]})", v[1]]
        end

        set(k, default)
        on(o, k, *v)
      end

      on(o, :help, 'Print help') do
        puts parser
        exit
      end

      on(o, :version, "Print version (#{Biff::VERSION})") do
        puts Biff::VERSION
        exit
      end
    end

    parser.parse!(ARGV)
  end

  def config
    @config ||= YAML.parse(File.open(File.expand_path(file))).transform
  end

  private
  def set(arg, v)
    send("#{arg}=", v)
  end

  def on(o, arg, doc, name=nil)
    long = name ? "#{arg} #{name}" : arg

    o.on("-#{arg[0]}", "--#{long}", doc) do |v|
      if block_given?
        yield v
      else
        set(arg, v)
      end
    end
  end
end
