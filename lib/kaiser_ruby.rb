require 'parslet'
require 'kaiser_ruby/rockstar/parser'
require 'kaiser_ruby/rockstar/transform'

module KaiserRuby
  def self.parse(input)
    KaiserRuby::Rockstar::Parser.new.parse(input)
  rescue Parslet::ParseFailed => failure
    puts failure.parse_failure_cause.ascii_tree
  end

  def self.transform(tree)
    KaiserRuby::Rockstar::Transform.new.apply(tree)
  end

  def self.transpile(input)
    transform(parse(input))
  end
end