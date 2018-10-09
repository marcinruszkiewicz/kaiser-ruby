module KaiserRuby
  class Parser
    attr_reader :lines, :raw_input, :tree

    POETIC_STRING_KEYWORDS = %w(says)
    POETIC_NUMBER_KEYWORDS = %w(is was were are)
    POETIC_NUMBER_CONTRACTIONS = %w('s 're)
    POETIC_TYPE_KEYWORDS = %w(is)
    PRINT_KEYWORDS = %w(say whisper shout scream)
    LISTEN_KEYWORDS = ['listen to']
    BREAK_KEYWORDS = ['break it down']
    CONTINUE_KEYWORDS = ['take it to the top']
    RETURN_KEYWORDS = ['give back']
    FUNCTION_CALL_KEYWORDS = %w(taking)
    INCREMENT_FIRST_KEYWORDS = %w(build)
    INCREMENT_SECOND_KEYWORDS = %w(up)
    DECREMENT_FIRST_KEYWORDS = %w(knock)
    DECREMENT_SECOND_KEYWORDS = %w(down)
    ASSIGNMENT_FIRST_KEYWORDS = %w(put)
    ASSIGNMENT_SECOND_KEYWORDS = %w(into)

    FUNCTION_KEYWORDS = %w(takes)
    IF_KEYWORDS = %w(if)
    UNTIL_KEYWORDS = %w(until)
    WHILE_KEYWORDS = %w(while)
    ELSE_KEYWORDS = %w(else)

    NULL_TYPE = %w(null nothing nowhere nobody gone)
    TRUE_TYPE = %w(true yes ok right)
    FALSE_TYPE = %w(false no lies wrong)
    NIL_TYPE = %w(mysterious)
    POETIC_TYPE_LITERALS = NIL_TYPE + NULL_TYPE + TRUE_TYPE + FALSE_TYPE

    COMMON_VARIABLE_KEYWORDS = %w(a an the my your)
    PRONOUN_KEYWORDS = %w(he him she her it its they them)

    ADDITION_KEYWORDS = %w(plus with)
    SUBTRACTION_KEYWORDS = %w(minus without)
    MULTIPLICATION_KEYWORDS = %w(times of)
    DIVISION_KEYWORDS = %w(over)

    def initialize(input)
      @raw_input = input
      @lines = input.split /\n/
    end

    def parse
      @tree = []

      # we need the deep locate from hashie to do proper nesting
      @tree.extend(Hashie::Extensions::DeepLocate)
      @current_block = []
      @nesting = 0

      # parse through lines to get the general structure (statements/flow control/functions/etc) out of it
      @lines.each do |line|
        parse_line(line)
      end
      # fill_block # end of file should close blocks

      @tree
    end

    def parse_line(line)
      if line.empty?
        fill_block
        add_to_tree(parse_empty_line) if @nesting == 0
      else
        words = line.split /\s/

        if matches_first?(words, IF_KEYWORDS)
          one_argument_block(line, :if, IF_KEYWORDS)
        elsif matches_first?(words, ELSE_KEYWORDS)
          add_to_tree parse_else
        elsif matches_first?(words, WHILE_KEYWORDS)
          one_argument_block(line, :while, WHILE_KEYWORDS)
        elsif matches_first?(words, UNTIL_KEYWORDS)
          one_argument_block(line, :until, UNTIL_KEYWORDS)  
        elsif matches_separate?(words, ASSIGNMENT_FIRST_KEYWORDS, ASSIGNMENT_SECOND_KEYWORDS)
          add_to_tree parse_assignment(line)
        elsif matches_several_first?(line, RETURN_KEYWORDS)
          add_to_tree parse_return(line)
        elsif matches_first?(words, PRINT_KEYWORDS)
          add_to_tree parse_print(line)
        else
          if matches_any?(words, POETIC_STRING_KEYWORDS)
            add_to_tree parse_poetic_string(line)
          elsif matches_consecutive?(words, POETIC_TYPE_KEYWORDS, POETIC_TYPE_LITERALS)
            add_to_tree parse_poetic_type(line)
          elsif matches_any?(words, POETIC_NUMBER_KEYWORDS, contractions: true)
            add_to_tree parse_poetic_number(line)
          else
            add_to_tree(parse_listen(line)) if matches_several_first?(line, LISTEN_KEYWORDS)
            add_to_tree(parse_break) if matches_several_first?(line, BREAK_KEYWORDS)
            add_to_tree(parse_continue) if matches_several_first?(line, CONTINUE_KEYWORDS)
            add_to_tree(parse_function_call(line)) if matches_any?(words, FUNCTION_CALL_KEYWORDS)

            if matches_separate?(words, INCREMENT_FIRST_KEYWORDS, INCREMENT_SECOND_KEYWORDS)
              add_to_tree parse_increment(line)
            end
            
            if matches_separate?(words, DECREMENT_FIRST_KEYWORDS, DECREMENT_SECOND_KEYWORDS)
              add_to_tree parse_decrement(line)
            end

            two_arguments_block(line, :function, FUNCTION_KEYWORDS) if matches_any?(words, FUNCTION_KEYWORDS)
          end
        end
      end
    end

    # statements
    def parse_print(line)
      words = line.split prepared_regexp(PRINT_KEYWORDS)

      { print: parse_argument(words.last.strip) }
    end

    def parse_listen(line)
      words = line.split prepared_regexp(LISTEN_KEYWORDS)

      { listen: parse_variables(words.last.strip) }
    end

    def parse_return(line)
      words = line.split prepared_regexp(RETURN_KEYWORDS)

      { return: parse_argument(words.last.strip) }
    end

    def parse_increment(line)
      match_rxp = prepared_capture(INCREMENT_FIRST_KEYWORDS, INCREMENT_SECOND_KEYWORDS)
      capture = parse_variables(line.match(match_rxp).captures.first.strip)

      { increment: capture }
    end

    def parse_decrement(line)
      match_rxp = prepared_capture(DECREMENT_FIRST_KEYWORDS, DECREMENT_SECOND_KEYWORDS)
      capture = parse_variables(line.match(match_rxp).captures.first.strip)

      { decrement: capture }
    end

    def parse_else
      { else: nil }
    end

    def parse_empty_line
      { empty_line: nil }
    end

    def parse_break
      { break: nil }
    end

    def parse_continue
      { continue: nil }
    end

    def parse_function_call(line)
      words = line.split /\s/
      if matches_any?(words, FUNCTION_CALL_KEYWORDS)
        words = line.split prepared_regexp(FUNCTION_CALL_KEYWORDS)
        left = parse_variables(words.first.strip)
        right = parse_variables(words.last.strip)
        { function_call: { left: left, right: right } }
      else
        return false
      end
    end

    def parse_poetic_string(line)
      words = line.split prepared_regexp(POETIC_STRING_KEYWORDS)
      left = parse_variables(words.first.strip)
      right = { string: "\"#{words.last.strip}\"" }
      { poetic_string: { left: left, right: right } }
    end

    def parse_poetic_type(line)
      words = line.split prepared_regexp(POETIC_TYPE_KEYWORDS)
      left = parse_variables(words.first.strip)
      right = parse_type_literal(words.last.strip)
      { poetic_type: { left: left, right: right } }
    end

    def parse_poetic_number(line)
      words = line.split prepared_regexp(POETIC_NUMBER_KEYWORDS, contractions: true)
      left = parse_variables(words.first.strip)
      right = { number_literal: words.last.strip }
      { poetic_number: { left: left, right: right } }
    end

    def parse_type_literal(string)
      words = string.split /\s/
      raise SyntaxError, "too many words in poetic type literal: #{string}" if words.size > 1

      if matches_first?(words, NIL_TYPE)
        { type: 'nil' }
      elsif matches_first?(words, NULL_TYPE)
        { type: 'null' }
      elsif matches_first?(words, TRUE_TYPE)
        { type: 'true' }
      elsif matches_first?(words, FALSE_TYPE)
        { type: 'false' }
      else
        raise SyntaxError, "unknown poetic type literal: #{string}"
      end
    end

    def parse_assignment(line)
      match_rxp = prepared_capture(ASSIGNMENT_FIRST_KEYWORDS, ASSIGNMENT_SECOND_KEYWORDS)
      right = parse_argument(line.match(match_rxp).captures.first.strip)
      left = parse_variables(line.match(match_rxp).captures.last.strip)

      { assignment: { left: left, right: right } }
    end

    def two_arguments(line, type, rxp, contractions: false)
      words = line.split prepared_regexp(rxp, contractions: contractions)
      add_to_tree({ type => { left: words.first.strip, right: words.last.strip } })
    end

    def one_argument_separate(line, type, first_rxp, second_rxp)
      match_rxp = prepared_capture(first_rxp, second_rxp)
      capture = line.match(match_rxp).captures.first.strip
      add_to_tree({ type => capture })
    end

    def two_arguments_separate(line, type, first_rxp, second_rxp)
      match_rxp = prepared_capture(first_rxp, second_rxp)
      left = line.match(match_rxp).captures.first.strip
      right = line.match(match_rxp).captures.last.strip
      add_to_tree({ type => { left: left, right: right } })
    end

    def two_arguments_block(line, type, rxp)
      words = line.split prepared_regexp(rxp)
      add_to_tree({ type => { left: words.first.strip, right: words.last.strip }, block: [] })
      @nesting += 1
    end

    def one_argument_block(line, type, rxp)
      words = line.split prepared_regexp(rxp)
      add_to_tree({ type => words.last.strip, block: [] })
      @nesting += 1
    end

    def parse_argument(string)
      fcl = parse_function_call(string)
      return fcl if fcl

      str = parse_literal_string(string)
      return str if str

      num = parse_literal_number(string)
      return num if num

      math = parse_math_operations(string)
      return math if math 

      vars = parse_variables(string)
      return vars if vars
    end

    def parse_variables(string)
      words = string.split /\s/
      words = words.map { |e| e.chars.select { |c| c =~ /[[:alnum:]]|\./ }.join }
      string = words.join(' ')

      if matches_first?(words, COMMON_VARIABLE_KEYWORDS)
        return parse_common_variable(string)
      elsif matches_all?(words, /\A[[:upper:]]/)
        return parse_proper_variable(string)
      else
        raise SyntaxError, "invalid variable name: #{string}"
      end

      return false
    end

    def parse_common_variable(string)
      words = string.split(/\s/)

      copied = words.dup
      copied.shift
      copied.each do |w|
        raise SyntaxError, "invalid common variable name: #{string}" if w =~ /[[:upper:]]/
      end

      words = words.map { |e| e.chars.select { |c| c =~ /[[:alpha:]]/ }.join }
      { variable_name: words.map { |w| w.downcase }.join('_') }
    end

    def parse_proper_variable(string)
      words = string.split(/\s/)

      copied = words.dup
      copied.shift
      copied.each do |w|
        raise SyntaxError, "invalid proper variable name: #{string}" unless w =~ /\A[[:upper:]]/
      end      

      words = words.map { |e| e.chars.select { |c| c =~ /[[:alpha:]]/ }.join }
      { variable_name: words.join('_') }
    end

    def parse_math_operations(string)
      words = string.split(/\s/)

      if matches_any?(words, ADDITION_KEYWORDS)
        return parse_addition(string)
      elsif matches_any?(words, SUBTRACTION_KEYWORDS)
        return parse_subtraction(string)
      elsif matches_any?(words, MULTIPLICATION_KEYWORDS)
        return parse_multiplication(string)
      elsif matches_any?(words, DIVISION_KEYWORDS)
        return parse_division(string)
      end

      return false
    end

    def parse_addition(string)
      words = string.split prepared_regexp(ADDITION_KEYWORDS)
      left = parse_argument(words.first.strip)
      right = parse_argument(words.last.strip)

      { addition: { left: left, right: right } }
    end

    def parse_subtraction(string)
      words = string.split prepared_regexp(SUBTRACTION_KEYWORDS)
      left = parse_argument(words.first.strip)
      right = parse_argument(words.last.strip)

      { subtraction: { left: left, right: right } }
    end

    def parse_multiplication(string)
      words = string.split prepared_regexp(MULTIPLICATION_KEYWORDS)
      left = parse_argument(words.first.strip)
      right = parse_argument(words.last.strip)

      { multiplication: { left: left, right: right } }
    end

    def parse_division(string)
      words = string.split prepared_regexp(DIVISION_KEYWORDS)
      left = parse_argument(words.first.strip)
      right = parse_argument(words.last.strip)

      { division: { left: left, right: right } }
    end

    def parse_literal_string(string)
      if string.strip.start_with?('"') && string.end_with?('"')
        { string: string }
      else
        return false
      end
    end

    def parse_literal_number(string)
      num = Float(string) rescue string
      if num.is_a? Float
        { number: num }
      else
        return false
      end
    end

    #private

    def add_to_tree(object)
      object.extend(Hashie::Extensions::DeepLocate)

      if @nesting == 0
        @tree << object
        @current_block = @tree.count - 1
      else
        blocks = @tree[@current_block].deep_locate(:block)
        blocks[@nesting - 1][:block] << object
      end
    end

    def fill_block      
      @nesting -= 1 if @nesting >= 1
    end

    def prepared_regexp(array, contractions: false)
      if contractions
        rxp = (array.map { |a| '\b' + a + '\b' } + POETIC_NUMBER_CONTRACTIONS.map { |a| a + '\b' }).join('|')
      else
        rxp = array.map { |a| '\b' + a + '\b' }.join('|')
      end
      Regexp.new(rxp, Regexp::IGNORECASE)
    end

    def prepared_capture(farr, sarr)
      frxp = farr.map { |a| '\b' + a + '\b' }.join('|')
      srxp = sarr.map { |a| '\b' + a + '\b' }.join('|')
      Regexp.new(frxp + '(.*?)' + srxp + '(.*)', Regexp::IGNORECASE)
    end

    def matches_any?(words, rxp, contractions: false)
      regexp = rxp.is_a?(Regexp) ? rxp : prepared_regexp(rxp, contractions: contractions)
      words.any? { |w| w =~ regexp } 
    end

    def matches_all?(words, rxp, contractions: false)
      regexp = rxp.is_a?(Regexp) ? rxp : prepared_regexp(rxp, contractions: contractions)
      words.all? { |w| w =~ regexp } 
    end

    def matches_consecutive?(words, first_rxp, second_rxp)
      first_idx = words.index { |w| w =~ prepared_regexp(first_rxp) }
      second_idx = words.index { |w| w =~ prepared_regexp(second_rxp) }

      second_idx != nil && first_idx != nil && second_idx.to_i - first_idx.to_i == 1
    end

    def matches_first?(words, rxp, contractions: false)
      words.index { |w| w =~ prepared_regexp(rxp, contractions: contractions) } == 0
    end

    def matches_several_first?(line, rxp)
      (line =~ prepared_regexp(rxp)) == 0
    end

    def matches_separate?(words, first_rxp, second_rxp)
      first_idx = words.index { |w| w =~ prepared_regexp(first_rxp) }
      second_idx = words.index { |w| w =~ prepared_regexp(second_rxp) }

      second_idx != nil && first_idx != nil && second_idx.to_i > first_idx.to_i
    end
  end
end