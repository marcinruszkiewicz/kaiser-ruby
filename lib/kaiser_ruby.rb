require 'parslet'
require 'kaiser_ruby/rockstar_parser'
require 'kaiser_ruby/rockstar_transform'
require 'pry'

module KaiserRuby
  def self.parse(input)
    if input.split("\n").size == 1
      KaiserRuby::RockstarSingleLineParser.new.parse(input.chomp)
    else
      KaiserRuby::RockstarParser.new.parse(input)
    end
  rescue Parslet::ParseFailed => failure
    puts input.inspect
    puts failure.parse_failure_cause.ascii_tree
  end

  def self.transform(tree)
    KaiserRuby::RockstarTransform.new.apply(tree)
  end

  def self.transpile(input)
    transform(parse(input))
  end
end