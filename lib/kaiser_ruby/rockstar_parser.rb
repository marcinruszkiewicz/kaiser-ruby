module KaiserRuby
  class RockstarParser < Parslet::Parser
    # ORDER OF THESE RULES ABSOLUTELY MATTERS
    # DON'T MESS WITH IT

    # all the keywords separately, so that variable names can't use them

    rule(:reserved) do
      mysterious_value_keywords | null_value_keywords | true_value_keywords | false_value_keywords |
      plus_keywords | minus_keywords | times_keywords | over_keywords | increment_keywords |
      assignment_keywords | poetic_string_keywords | poetic_number_keywords |
      say_keywords | flow_keywords | comparison_keywords | function_keywords
    end

    rule(:mysterious_value_keywords) { str('mysterious') }
    rule(:null_value_keywords) { str('nothing') | str('nowhere') | str('nobody') | str('empty') | str('gone') }
    rule(:false_value_keywords) { str('false') | str('wrong') | str('no') | str('lies') }
    rule(:true_value_keywords) { str('true') | str('right') | str('yes') | str('ok') }
    rule(:plus_keywords) { str('plus') | str('with') }
    rule(:minus_keywords) { str('minus') | str('without') }
    rule(:minus_keywords) { str('minus') | str('without') }
    rule(:times_keywords) { str('times') | str('of') }
    rule(:over_keywords) { str('over') }
    rule(:poetic_number_keywords) { str('is') | str('was') | str('were') }
    rule(:say_keywords) { str('Say') | str('Shout') | str('Scream') | str('Whisper') }
    rule(:flow_keywords) { str('If') | str('Else') | str('While') | str('Until') }
    rule(:increment_keywords) { str('Knock') | str('Build') }
    rule(:assignment_keywords) { str('Put') | str('into') }
    rule(:poetic_string_keywords) { str('says') }
    rule(:comparison_keywords) { str("is") | not_keywords | gt_keywords | gte_keywords | lt_keywords | lte_keywords }
    rule(:function_keywords) { str('Break it down') | str('Take it to the top') | str('Give back') | str('takes') | str('taking') }

    rule(:comment) { str('(') >> match['^)'].repeat.as(:comment) >> str(')') }

    # variable names
    # using [[:upper:]] etc here allows for metal umlauts and other UTF characters

    rule(:proper_word) { reserved.absent? >> match['[[:upper:]]'] >> match['[[:alpha:]]'].repeat }
    rule(:common_variable_name) do
      (
        str('A ') | str('a ') |
        str('An ') | str('an ') |
        str('The ') | str('the ') |
        str('My ') | str('my ') |
        str('Your ') | str('your ')
      ) >> reserved.absent? >> match['[[:lower:]]'].repeat >> match[','].maybe.ignore
    end
    rule(:proper_variable_name) do
      (proper_word >> (space >> proper_word).repeat) >> match[','].maybe.ignore
    end

    rule(:variable_names) do
      (common_variable_name | proper_variable_name).as(:variable_name)
    end

    # all the different value types (except Object for now)

    rule(:mysterious_value) { mysterious_value_keywords.as(:mysterious_value) }
    rule(:null_value) { null_value_keywords.as(:null_value) }
    rule(:true_value) { true_value_keywords.as(:true_value) }
    rule(:false_value) { false_value_keywords.as(:false_value) }
    rule(:string_value) { (str('"') >> match['^"'].repeat >> str('"')).as(:string_value) }
    rule(:numeric_value) { match['0-9\.'].repeat.as(:numeric_value) }
    rule(:unquoted_string) { match['^\n'].repeat.as(:unquoted_string) }
    rule(:string_as_number) { reserved.absent? >> (match('.*?\(').present? >> match['^\('] | match('.*?\(').absent? >> match['^\n']).repeat.as(:string_as_number) }

    # assignment

    rule(:basic_assignment_expression) do
      match('Put ').present? >>
      (
        str('Put ') >> string_input.as(:right) >> str(' into ') >> variable_names.as(:left)
      ).as(:assignment)
    end

    # math operations

    rule(:increment) do
      (
        str('Build ') >> variable_names.as(:variable_name) >> str(' up')
      ).as(:increment)
    end

    rule(:decrement) do
      (
        str('Knock ') >> variable_names.as(:variable_name) >> str(' down')
      ).as(:decrement)
    end

    rule(:addition) do
      (match('.*? plus') | match('.*? with')).present? >>
      (
        value_or_variable.as(:left) >> space >> plus_keywords >> space >> value_or_variable.as(:right)
      ).as(:addition)
    end

    rule(:subtraction) do
      (match('.*? minus') | match('.*? without')).present? >>
      (
        value_or_variable.as(:left) >> space >> minus_keywords >> space >> value_or_variable.as(:right)
      ).as(:subtraction)
    end

    rule(:division) do
      match('.*? over').present? >>
      (
        value_or_variable.as(:left) >> space >> over_keywords >> space >> value_or_variable.as(:right)
      ).as(:division)
    end

    rule(:multiplication) do
      (match('.*? times') | match('.*? of')).present? >>
      (
        value_or_variable.as(:left) >> space >> times_keywords >> space >> value_or_variable.as(:right)
      ).as(:multiplication)
    end

    # functions

    rule(:function) do
      match('.*? takes').present? >>
      (
        variable_names.as(:function_name) >> str(' takes') >>
        (space >> str('and ').maybe >> variable_names.as(:argument_name)).repeat.as(:arguments) >> eol >>
        scope {
          inner_block_line.repeat.as(:function_block) >>
          (eol | eof).as(:enddef)
        }
      ).as(:function_definition)
    end

    rule(:function_call) do
      (
        variable_names.as(:function_name) >> str(' taking') >>
        (space >> str('and ').maybe >> variable_names.as(:argument_name)).repeat.as(:arguments)
      ).as(:function_call)
    end

    # poetic assignments

    rule(:poetic_type_literal) do
      (flow_keywords.absent?) >>
      (
        variable_names.as(:left) >> str(' is ') >> (mysterious_value | null_value | false_value | true_value).as(:right)
      ).as(:assignment)
    end

    rule(:poetic_string_literal) do
      (
        variable_names.as(:left) >> str(' says ') >> unquoted_string.as(:right)
      ).as(:assignment)
    end

    rule(:poetic_number_literal) do
      (flow_keywords.absent?) >>
      (
        variable_names.as(:left) >> space >> poetic_number_keywords >> space >> string_as_number.as(:right)
      ).as(:assignment)
    end

    # single statements

    rule(:print_function) do
      (
        say_keywords >> space >> value_or_variable.as(:output)
      ).as(:print)
    end

    rule(:break_function) do
      str('Break it down').as(:break)
    end

    rule(:continue_function) do
      str('Take it to the top').as(:continue)
    end

    rule(:return_function) do
      str('Give back ') >> (math_operations | value_or_variable).as(:return_value)
    end

    # comparisons

    rule(:equality) do
      (
        value_or_variable.as(:left) >> str(' is ') >> value_or_variable.as(:right)
      ).as(:equals)
    end

    rule(:not_keywords) { str(' is not ') | str(" ain't ")}
    rule(:inequality) do
      (
        value_or_variable.as(:left) >> not_keywords >> value_or_variable.as(:right)
      ).as(:not_equals)
    end

    rule(:gt_keywords) { str(' is ') >> (str('higher') | str('greater') | str('bigger') | str('stronger')) >> str(' than ') }
    rule(:gt) do
      (
        value_or_variable.as(:left) >> gt_keywords >> value_or_variable.as(:right)
      ).as(:gt)
    end

    rule(:lt_keywords) { str(' is ') >> (str('lower') | str('less') | str('smaller') | str('weaker')) >> str(' than ') }
    rule(:lt) do
      (
        value_or_variable.as(:left) >> lt_keywords >> value_or_variable.as(:right)
      ).as(:lt)
    end

    rule(:gte_keywords) { str(' is as ') >> (str('high') | str('great') | str('big') | str('strong')) >> str(' as ') }
    rule(:gte) do
      (
        value_or_variable.as(:left) >> gte_keywords >> value_or_variable.as(:right)
      ).as(:gte)
    end

    rule(:lte_keywords) { str(' is as ') >> (str('low') | str('little') | str('small') | str('weak')) >> str(' as ') }
    rule(:lte) do
      (
        value_or_variable.as(:left) >> lte_keywords >> value_or_variable.as(:right)
      ).as(:lte)
    end

    # flow control - if, else, while, until

    rule(:if_block) do
      (
        str('If ') >> comparisons.as(:if_condition) >>
          (space >> (str('and') | str('or')).as(:and_or) >> space >> comparisons.as(:second_condition)).maybe >> eol >>
          scope {
            inner_block_line.repeat.as(:if_block)
          } >> (eol | eof).as(:endif)
      ).as(:if)
    end

    rule(:if_else_block) do
      (
        str('If ') >> comparisons.as(:if_condition) >>
          (space >> (str('and') | str('or')).as(:and_or) >> space >> comparisons.as(:second_condition)).maybe >> eol >>
          scope {
            inner_block_line.repeat.as(:if_block)
          } >>
        str('Else') >> eol >>
          scope {
            inner_block_line.repeat.as(:else_block) >>
            (eol | eof).as(:endif)
          }
      ).as(:if_else)
    end

    rule(:while_block) do
      (
        str('While ') >> comparisons.as(:while_condition) >>
          (space >> (str('and') | str('or')).as(:and_or) >> space >> comparisons.as(:second_condition)).maybe >> eol >>
          scope {
            inner_block_line.repeat.as(:while_block) >>
            (eol | eof).as(:endwhile)
          }
      ).as(:while)
    end

    rule(:until_block) do
      (
        str('Until ') >> comparisons.as(:until_condition) >>
          (space >> (str('and') | str('or')).as(:and_or) >> space >> comparisons.as(:second_condition)).maybe >> eol >>
          scope {
            inner_block_line.repeat.as(:until_block)

          } >> (eol | eof).as(:enduntil)
      ).as(:until)
    end

    # sets of rules

    rule(:simple_values) { mysterious_value | null_value | false_value | true_value | string_value | numeric_value }
    rule(:value_or_variable) { variable_names | simple_values }
    rule(:math_operations) { increment | decrement | addition | subtraction | multiplication | division }
    rule(:expressions) { basic_assignment_expression | math_operations }
    rule(:comparisons) { gte | gt | lte | lt | inequality | equality }
    rule(:flow_control) { if_block | if_else_block | while_block | until_block }
    rule(:poetics) { poetic_type_literal | poetic_string_literal | poetic_number_literal }
    rule(:functions) { function_call | function | print_function | break_function | continue_function | return_function }
    rule(:line_elements) { flow_control | poetics | expressions | functions | eol | comment }

    # handle multiple lines in a file

    rule(:string_input) { line_elements | value_or_variable }
    rule(:line) { (line_elements >> eol.maybe).as(:line) }
    rule(:inner_block_line) { ( (flow_control | poetics | expressions | functions) >> eol.maybe).as(:line) }
    rule(:lyrics) { line.repeat.as(:lyrics) }
    root(:lyrics)

    # DRY helpers

    rule(:eol) { match["\n"] }
    rule(:eof) { any.absent? }
    rule(:space) { match[' \t'].repeat(1) }
  end

  # this is an alternative parser that enables all the RSpec tests to pass
  # it specifically has a single line rule that matches a string instead of lines
  # it also matches the value_or_variable rule, so that the value creation can be tested
  class RockstarSingleLineParser < KaiserRuby::RockstarParser
    root(:string_input)
  end
end
