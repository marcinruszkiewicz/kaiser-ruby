module KaiserRuby
  class RockstarParser < Parslet::Parser
    root(:poetic_literal)

    # declare spaces to DRY out later definitions
    rule(:space) { match(' ').repeat(1) }

    # parts of a variable assignment
    rule(:proper_variable_name) { (match('[A-Z]') >> match('[a-z]').repeat(1)) }
    rule(:assignment) { space >> (str('is') | str('was') | str('were')) >> space }
    rule(:number_literal) { (match['a-z'].repeat(1) >> space.maybe).repeat.as(:number_str) }

    rule(:poetic_literal) { poetic_number_literal.as(:var) }
    rule(:poetic_number_literal) { proper_variable_name.as(:var_name) >> assignment >> number_literal.as(:var_value) }
  end
end
