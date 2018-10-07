require 'parslet'
require 'kaiser_ruby/rockstar_parser'
require 'kaiser_ruby/rockstar_transform'

module KaiserRuby
  def self.parse(input)
    # eat comments since we don't care about them
    input = input.gsub(/\(.*?\)/, '')

    # expand contractions
    input = input.gsub(/'s\W+/, ' is ')

    # strings without a line ending (or single lines) should be fed into the alternative parser
    if input.split("\n").size == 1
      KaiserRuby::RockstarSingleLineParser.new.parse(input.chomp, reporter: Parslet::ErrorReporter::Deepest.new)
    else
      KaiserRuby::RockstarParser.new.parse(input, reporter: Parslet::ErrorReporter::Deepest.new)
    end
  rescue Parslet::ParseFailed => failure
    unless ENV['RACK_ENV'] == 'test'
      puts input.inspect
      puts failure.parse_failure_cause.ascii_tree
    end
    
    raise SyntaxError, failure.message
  end

  def self.transform(tree)
    KaiserRuby::RockstarTransform.new.apply(tree)
  end

  def self.transpile(input)
    transform(parse(input))
  end
end
