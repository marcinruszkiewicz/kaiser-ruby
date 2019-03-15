# frozen_string_literal: true

require 'hashie'
require 'kaiser_ruby/parser'
require 'kaiser_ruby/refinements'
require 'kaiser_ruby/transformer'
require 'pry'

# Transpile Rockstar into Ruby code
module KaiserRuby
  class RockstarSyntaxError < SyntaxError
  end

  def self.parse(input)
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

  def self.with_captured_stdout
    old_stdout = $stdout
    $stdout = StringIO.new
    yield
    $stdout.string
  ensure
    $stdout = old_stdout
  end
end
