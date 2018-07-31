require 'parslet'
require 'kaiser_ruby/rockstar_parser'
require 'kaiser_ruby/rockstar_transform'

module KaiserRuby
  def self.parse(input)
    KaiserRuby::RockstarParser.new.parse(input)
  rescue Parslet::ParseFailed => failure
    puts failure.parse_failure_cause.ascii_tree
  end

  def self.transform(tree)
    KaiserRuby::RockstarTransform.new.apply(tree)
  end

  def self.transpile(input)
    transform(parse(input))
  end
end