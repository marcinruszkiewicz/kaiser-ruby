module KaiserRuby
  class RockstarParser < Parslet::Parser
    root(:lyrics)
    rule(:lyrics) { (verse.repeat(1) >> eof).as(:lyrics) }

    # define a line and a verse
    rule(:line) { (poetic_literal.repeat(1) >> eol.repeat(0, 1)).as(:line) }
    rule(:verse) { (line.repeat(1) >> eol.repeat(0, 1)).as(:verse) }

    # declare eol/eof/spaces to DRY out later definitions
    rule(:space) { match(' ').repeat(1) }
    rule(:eol) { match['\n'] }
    rule(:eof) { any.absent? }

    # parts of a variable assignment
    rule(:proper_variable_name) { match('[A-Z]') >> match('[a-z]').repeat(1) }
    rule(:common_variable_name) { match('[a-z]').repeat }
    rule(:proper_variable) { proper_variable_name >> (space >> proper_variable_name).repeat }
    rule(:common_variable_keyword) { (str('A') | str('My') | str('An') | str('The') | str('Your') | str('a') | str('my') | str('an') | str('the') | str('your')) >> space }
    rule(:common_variable) { common_variable_keyword >> common_variable_name }
    rule(:variable_name) { common_variable | proper_variable }

    # handle poetic numbers
    rule(:number_assignment_worded) { space >> (str('is') | str('was') | str('were')) >> space }
    rule(:number_assigmnent_shortened) { str("'s") >> space }
    rule(:number_assignment) { number_assignment_worded | number_assigmnent_shortened }
    rule(:number_literal) { (match['a-z'].repeat(1) >> space.maybe).repeat.as(:number_str) }
    rule(:poetic_number_literal) { variable_name.as(:var_name) >> number_assignment >> number_literal.as(:var_value) }

    # poetic strings
    rule(:string_assignment) { space >> str('says') >> space }
    rule(:string_literal) { (any.repeat).as(:string_str) }
    rule(:poetic_string_literal) { variable_name.as(:var_name) >> string_assignment >> string_literal.as(:var_value) }

    # poetic type literals
    rule(:type_literal) { null_type_literal.as(:nil) | true_type_literal.as(:true) | false_type_literal.as(:false) }
    rule(:true_type_literal) { str('true') | str('right') | str('yes') | str('ok') }
    rule(:false_type_literal) { str('false') | str('wrong') | str('no') | str('lies') }
    rule(:null_type_literal) { str('nothing') | str('nowhere') | str('nobody') | str('empty') | str('gone') }
    rule(:poetic_type_literal) { variable_name.as(:var_name) >> number_assignment >> type_literal.as(:var_value) }

    rule(:poetic_literal) { (poetic_type_literal | poetic_string_literal | poetic_number_literal).as(:var) }
  end
end
