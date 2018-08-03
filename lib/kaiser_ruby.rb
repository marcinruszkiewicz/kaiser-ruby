require 'parslet'
require 'kaiser_ruby/rockstar_parser'
require 'kaiser_ruby/rockstar_transform'

module KaiserRuby
  def self.up_indent
    @@indent ||= 0
    @@indent += 2
  end

  def self.down_indent
    @@indent ||= 0
    @@indent -= 2
  end

  def self.indent
    @@indent ||= 0
  end

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