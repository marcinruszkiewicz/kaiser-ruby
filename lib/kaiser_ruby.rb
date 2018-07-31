require 'parslet'
require 'kaiser_ruby/rockstar'

module KaiserRuby
  def self.parse(input)
    Rockstar.new.parse(input)
  rescue Parslet::ParseFailed => failure
    puts failure.parse_failure_cause.ascii_tree
  end
end