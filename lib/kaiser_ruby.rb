require 'parslet'
require 'hashie'
require 'kaiser_ruby/parser'
require 'kaiser_ruby/transformer'
require 'kaiser_ruby/rockstar_parser'
require 'kaiser_ruby/rockstar_transform'
require 'pry'

module KaiserRuby
  def self.old_parse(input)
    #strings without a line ending (or single lines) should be fed into the alternative parser
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
    tree = parse(input)
    KaiserRuby::Transformer.new(tree).transform
  end

  def self.execute(input)
    with_captured_stdout do
      instance_eval transpile(input)
    end
  end

  def self.with_captured_stdout
    old_stdout = $stdout
    $stdout = StringIO.new
    yield
    $stdout.string
  ensure
    $stdout = old_stdout
  end

  def self.parse(input)
    # eat comments since we don't care about them
    input = input.gsub(/\(.*?\)/, '')

    parser = KaiserRuby::Parser.new(input)
    parser.parse
  end
end
