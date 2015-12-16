require 'optparse'

class Coursemology::Evaluator::CLI
  Options = Struct.new(:host, :api_token, :api_user_email)

  def self.start(argv)
    new.start(argv)
  end

  def start(argv)
    run(argv)
  end

  def run(argv)
    options = optparse!(argv)
    Coursemology::Evaluator::Client.initialize(options.host, options.api_user_email,
                                               options.api_token)
    Coursemology::Evaluator::Client.new.run
  end

  private

  # Parses the options specified on the command line.
  #
  # @param [Array<String>] argv The arguments specified on the command line.
  # @return [Coursemology::Evaluator::CLI::Options]
  def optparse!(argv) # rubocop:disable Metrics/MethodLength
    options = Options.new
    option_parser = OptionParser.new do |parser|
      parser.banner = "Usage: #{parser.program_name} [options]"
      parser.on('-hHOST', '--host=HOST', 'Coursemology host to connect to') do |host|
        options.host = host
      end

      parser.on('-tTOKEN', '--api-token=TOKEN') do |token|
        options.api_token = token
      end

      parser.on('-uUSER', '--api-user-email=USER') do |user|
        options.api_user_email = user
      end
    end

    option_parser.parse!(argv)
    options
  end
end
