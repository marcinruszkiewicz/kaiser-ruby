module KaiserRuby
  class RockstarParser < Parslet::Parser
    rule(:reserved) do
      nil_value_keywords | true_value_keywords | false_value_keywords | plus_keywords | minus_keywords | times_keywords | over_keywords |
      str('Knock') | str('Build') | str('Put') | str('into') | str('says') | poetic_number_keywords | say_keywords
    end

    rule(:nil_value_keywords) { str('nothing') | str('nowhere') | str('nobody') | str('empty') | str('gone') }
    rule(:false_value_keywords) { str('false') | str('wrong') | str('no') | str('lies') }
    rule(:true_value_keywords) { str('true') | str('right') | str('yes') | str('ok') }
    rule(:plus_keywords) { str('plus') | str('with') }
    rule(:minus_keywords) { str('minus') | str('without') }
    rule(:minus_keywords) { str('minus') | str('without') }
    rule(:times_keywords) { str('times') | str('of') }
    rule(:over_keywords) { str('over') }
    rule(:poetic_number_keywords) { str('is') | str('was') | str('were') }
    rule(:say_keywords) { str('Say') | str('Shout') | str('Scream') | str('Whisper') }

    rule(:proper_word) { reserved.absent? >> match['A-Z'] >> match['A-Za-z'].repeat }
    rule(:common_word) { reserved.absent? >> match['A-Za-z'].repeat }
    rule(:common_variable_name) do
      (
        str('A ') | str('a ') |
        str('An ') | str('an ') |
        str('The ') | str('the ') |
        str('My ') | str('my ') |
        str('Your ') | str('your ')
      ) >> reserved.absent? >> match['a-z'].repeat
    end
    rule(:proper_variable_name) do
      (proper_word >> (space >> proper_word).repeat).repeat(1)
    end

    rule(:variable_names) do
      (common_variable_name | proper_variable_name).as(:variable_name)
    end

    rule(:nil_value) { nil_value_keywords.as(:nil_value) }
    rule(:true_value) { true_value_keywords.as(:true_value) }
    rule(:false_value) { false_value_keywords.as(:false_value) }
    rule(:string_value) { (str('"') >> match['A-Za-z '].repeat >> str('"')).as(:string_value) }
    rule(:numeric_value) { match['0-9\.'].repeat.as(:numeric_value) }
    rule(:unquoted_string) { match['^\n'].repeat.as(:unquoted_string) }
    rule(:string_as_number) { match['^\n'].repeat.as(:string_as_number) }

    rule(:basic_assignment_expression) do
      match('Put ').present? >>
      (
        str('Put ') >> string_input.as(:right) >> str(' into ') >> variable_names.as(:left)
      ).as(:assignment)
    end

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

    # math operations

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

    # poetic assignments

    rule(:poetic_type_literal) do
      (
        variable_names.as(:left) >> str(' is ') >> (nil_value | false_value | true_value).as(:right)
      ).as(:assignment)
    end

    rule(:poetic_string_literal) do
      (
        variable_names.as(:left) >> str(' says ') >> unquoted_string.as(:right)
      ).as(:assignment)
    end

    rule(:poetic_number_literal) do
      (
        variable_names.as(:left) >> space >> poetic_number_keywords >> space >> string_as_number.as(:right)
      ).as(:assignment)
    end

    rule(:print_function) do
      (
        say_keywords >> space >> value_or_variable.as(:output)
      ).as(:print)
    end


    rule(:simple_values) { nil_value | false_value | true_value | string_value | numeric_value }
    rule(:value_or_variable) { variable_names | simple_values }
    rule(:expressions) { basic_assignment_expression | increment | decrement | addition | subtraction | multiplication | division }
    rule(:poetics) { poetic_type_literal | poetic_string_literal | poetic_number_literal }
    rule(:functions) { print_function }
    rule(:line_elements) { poetics | expressions | functions | eol }

    rule(:string_input) { line_elements | value_or_variable }
    rule(:line) { (line_elements >> eol.maybe).as(:line) }
    rule(:lyrics) { line.repeat.as(:lyrics) }
    root(:lyrics)

    rule(:eol) { match['\n'] }
    rule(:eof) { any.absent? }
    rule(:space) { match[' \t'].repeat(1) }
  end

  class RockstarSingleLineParser < KaiserRuby::RockstarParser
    root(:string_input)
  end
end
