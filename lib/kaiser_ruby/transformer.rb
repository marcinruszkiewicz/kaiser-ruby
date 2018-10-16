module KaiserRuby
  class Transformer
    attr_reader :parsed_tree, :output, :indent, :last_variable, :method_names, :global_variables, :local_variables

    def initialize(tree)
      @parsed_tree = tree
      @output = []
      @method_names = []
      @global_variables = []
      @nesting = 0
      @indentation = ''
    end

    def transform
      @last_variable = nil
      @global_variable_scope = true

      @parsed_tree.each do |line_object|
        transformed_line = select_transformer(line_object)
        if line_object[:nesting]
          @nesting = line_object[:nesting]
        else
          @nesting = 0
        end

        @indentation = '  ' * @nesting
        @output << @indentation + transformed_line
      end

      while @nesting > 0
        @nesting -= 1
        @indentation = '  ' * @nesting
        @output << @indentation + "end"
      end
      @output << '' if @output.size > 1
      @output.join("\n")
    end

    def select_transformer(object)
      key = object.keys.first
      send("transform_#{key}", object)
    end

    def method_missing(m, *args, &block)
      raise ArgumentError, "missing Transform rule: #{m}, #{args}"
    end

    # transform language tree into Ruby

    def transform_print(object)
      var = select_transformer(object[:print])
      "puts #{var}"
    end

    def transform_listen(object)
      var = select_transformer(object[:listen])
      "print '> '\n__input = STDIN.gets.chomp\n#{var} = Float(__input) rescue __input"
    end

    def transform_return(object)
      var = select_transformer(object[:return])
      "return #{var}"
    end

    def transform_continue(_object)
      "next"
    end

    def transform_break(_object)
      "break"
    end

    def transform_variable_name(object)
      if @global_variable_scope
        varname = "@#{object[:variable_name]}"
        @global_variables << varname
      else
        varname = object[:variable_name]
        varname = "@#{object[:variable_name]}" if @global_variables.include?("@#{object[:variable_name]}")
      end
      @last_variable = varname
      varname
    end

    def transform_local_variable_name(object)
      object[:local_variable_name]
    end

    def transform_function_name(object)
      object[:function_name]
    end

    def transform_pronoun(_object)
      @last_variable
    end

    def transform_string(object)
      object[:string]
    end

    def transform_number(object)
      object[:number]
    end

    def transform_argument_list(object)
      list = []
      object[:argument_list].each do |arg|
        list << select_transformer(arg)
      end

      list.join(', ')
    end

    def transform_addition(object)
      left = select_transformer(object[:addition][:left])
      right = select_transformer(object[:addition][:right])
      "#{left} + #{right}"
    end

    def transform_multiplication(object)
      left = select_transformer(object[:multiplication][:left])
      right = select_transformer(object[:multiplication][:right])
      "#{left} * #{right}"
    end

    def transform_subtraction(object)
      left = select_transformer(object[:subtraction][:left])
      right = select_transformer(object[:subtraction][:right])
      "#{left} - #{right}"
    end

    def transform_division(object)
      left = select_transformer(object[:division][:left])
      right = select_transformer(object[:division][:right])
      "#{left} / #{right}"
    end

    def transform_assignment(object)
      left = select_transformer(object[:assignment][:left])
      right = select_transformer(object[:assignment][:right])
      "#{left} = #{right}"
    end

    def transform_decrement(object)
      argument = select_transformer(object[:decrement])
      "#{argument} -= 1"
    end

    def transform_increment(object)
      argument = select_transformer(object[:increment])
      "#{argument} += 1"
    end

    def transform_function_call(object)
      func_name = select_transformer(object[:function_call][:left])
      argument = select_transformer(object[:function_call][:right])

      "#{func_name}(#{argument})"
    end

    def transform_passed_function_call(object)
      return transform_function_call(object[:passed_function_call])
    end

    def transform_poetic_string(object)
      var = select_transformer(object[:poetic_string][:left])
      value = select_transformer(object[:poetic_string][:right])

      "#{var} = #{value}"
    end

    def transform_poetic_type(object)
      var = select_transformer(object[:poetic_type][:left])
      value = select_transformer(object[:poetic_type][:right])
      "#{var} = #{value}"
    end

    def transform_poetic_number(object)
      var = select_transformer(object[:poetic_number][:left])
      value = select_transformer(object[:poetic_number][:right])
      "#{var} = #{value}"
    end

    def transform_number_literal(object)
      string = object[:number_literal]
      if string.include?('.')
        string.split('.', 2).map do |sub|
          str_to_num(sub.strip)
        end.join('.').to_f
      else
        str_to_num(string).to_f
      end
    end

    def transform_type(object)
      case object[:type]
      when "nil"
        'nil'
      when "null"
        '0.0'
      when "true"
        'true'
      when "false"
        'false'
      end
    end

    def transform_empty_line(_object)
      if @nesting == 0
        @global_variable_scope = true
        return ""
      else
        return "end\n"
      end
    end

    def additional_argument_transformation(argument)
      if @method_names.include?(argument)
        arg = "defined?(#{argument})"
      else
        arg = argument
      end

      if arg !~ /==|>|>=|<|<=|!=/
        arg = "#{arg}.to_bool"
      end

      return arg
    end

    def transform_if(object)
      argument = select_transformer(object[:if][:argument])
      argument = additional_argument_transformation(argument)
      "if #{argument}"
    end

    def transform_else(_object)
      "else"
    end

    def transform_while(object)
      argument = select_transformer(object[:while][:argument])
      argument = additional_argument_transformation(argument)
      "while #{argument}"
    end

    def transform_until(object)
      argument = select_transformer(object[:until][:argument])
      argument = additional_argument_transformation(argument)
      "until #{argument}"
    end

    def transform_equality(object)
      left = select_transformer(object[:equality][:left])
      right = select_transformer(object[:equality][:right])
      "#{left} == #{right}"
    end

    def transform_inequality(object)
      left = select_transformer(object[:inequality][:left])
      right = select_transformer(object[:inequality][:right])
      "#{left} != #{right}"
    end

    def transform_gt(object)
      left = select_transformer(object[:gt][:left])
      right = select_transformer(object[:gt][:right])
      "#{left} > #{right}"
    end

    def transform_gte(object)
      left = select_transformer(object[:gte][:left])
      right = select_transformer(object[:gte][:right])
      "#{left} >= #{right}"
    end

    def transform_lt(object)
      left = select_transformer(object[:lt][:left])
      right = select_transformer(object[:lt][:right])
      "#{left} < #{right}"
    end

    def transform_lte(object)
      left = select_transformer(object[:lte][:left])
      right = select_transformer(object[:lte][:right])
      "#{left} <= #{right}"
    end

    def transform_function(object)
      funcname = transform_function_name(object[:function][:name])
      @method_names << funcname
      argument = select_transformer(object[:function][:argument])
      @global_variable_scope = false

      "def #{funcname}(#{argument})"
    end

    def transform_and(object)
      left = select_transformer(object[:and][:left])
      right = select_transformer(object[:and][:right])

      "#{left} && #{right}"
    end

    def transform_not(object)
      arg = select_transformer(object[:not])
      "!#{arg}"
    end

    def transform_or(object)
      left = select_transformer(object[:or][:left])
      right = select_transformer(object[:or][:right])

      "#{left} || #{right}"
    end

    # private

    def str_to_num(string)
      filter_string(string).map { |e| e.length % 10 }.join
    end

    def filter_string(string, rxp: /[[:alpha:]]/)
      string.to_s.split(/\s+/).map { |e| e.chars.select { |c| c =~ rxp }.join }.reject { |a| a.empty? }
    end
  end
end