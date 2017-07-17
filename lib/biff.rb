require 'net/imap'
require 'rfc2047'
require 'version'

Status = Struct.new(:name, :unseen, :all)

class Biff
  is_versioned

  def initialize(config)
    @config = config

    @imap = Net::IMAP.new(
      @config['host'],
      @config['port'] || 993,
      @config['tls'] || true
    )
    Net::IMAP.debug = @config['debug']
  end

  def open
    pass = @config['password'] || `#{@config['passcmd']}`.chomp
    log('login', @config['user'])

    @imap.login(@config['user'], pass)
    @imap.examine('INBOX')
  end

  def status
    Status.new(@config['name'], @unseen.count, @all.count)
  end

  def listen
    unless @imap.capability.include?('IDLE')
      $stderr.puts "ERR #{config['name']} #{@config['host']} unsupported"
      exit 1
    end

    @idling = true

    while @idling
      begin
        idle # wait

        count
        yield status

        run
      rescue ThreadError
        # thread killed (exited app?)
        @imap.disconnect
      end
    end

    @idling = false
  end

  def run
    return unless cmd = @config['run'] # rubocop:disable Lint/AssignmentInCondition

    log('running', cmd)
    system(cmd)
  end

  def count
    @all    = @imap.search('ALL')
    @unseen = @imap.search('UNSEEN')

    [@unseen, @all]
  end

  def cmd
    @config['cmd']
  end

  def disconnect
    if @idling
      @idling = false
      @imap.send(:put_string, "DONE\r\n")
    end

    @imap.logout
    @imap.disconnect unless @imap.disconnected?
  end

  NAME_MAX = 15
  SUBJ_MAX = 40

  def unseen_headers
    return unless @unseen

    @imap.fetch(@unseen, 'ENVELOPE').map { |e| e.attr['ENVELOPE'] }.map do |e|
      from = e.from[0]
      name    = Rfc2047.decode(from.name || from.mailbox)
      subject = Rfc2047.decode(e.subject)
      nl = name.length    > NAME_MAX ? NAME_MAX - 1 : NAME_MAX
      sl = subject.length > SUBJ_MAX ? SUBJ_MAX - 1 : SUBJ_MAX

      # rubocop doesn't understand '*.*' width.precision
      # rubocop:disable Lint/FormatParameterMismatch
      sprintf(
        '%-*.*s%s %-*.*s%s',
        nl, nl, name,    name.length    > NAME_MAX ? '…' : '',
        sl, sl, subject, subject.length > SUBJ_MAX ? '…' : '',
      )
    end
  end

  private
  def log(*args)
    return unless @config['verbose']
    $stderr.puts(['INFO', *args].join(' '))
  end

  def idle
    @imap.idle(@config['timeout'] || 29 * 60) do |resp|
      @imap.idle_done if resp.is_a?(Net::IMAP::UntaggedResponse) &&
                         resp.name != 'OK'
    end
  end
end
