require 'hashie'
require 'kaiser_ruby/parser'
require 'kaiser_ruby/transformer'
require 'kaiser_ruby/refinements'
require 'pry'

module KaiserRuby
  def self.parse(input)
    # eat comments since we don't care about them
    input = input.gsub(/\n *\(.*?\) *\n/m, "\n\n")
    input = input.gsub(/\(.*?\)\s*\n/m, "\n").gsub(/ +/, ' ')
    parser = KaiserRuby::Parser.new(input)
    parser.parse
  end

  def self.transpile(input)
    tree = parse(input)
    KaiserRuby::Transformer.new(tree).transform
  end

  using KaiserRuby::Refinements
  
  def self.execute(input)
    with_captured_stdout do
      instance_eval transpile(input)
    end
  end

  private

  def self.with_captured_stdout
    old_stdout = $stdout
    $stdout = StringIO.new
    yield
    $stdout.string
  ensure
    $stdout = old_stdout
  end
end
