module KaiserRuby
  class Transformer
    attr_reader :parsed_tree, :output, :indent, :last_variable, :method_names, :global_variables, :local_variables

    def initialize(tree)
      @parsed_tree = tree
      @output = []
      @method_names = []
      @global_variables = []
      @local_variables = []
    end

    def transform
      @indent = 0
      @last_variable = nil
      @global_variable_scope = true

      @parsed_tree.each do |line_object|
        @output << select_transformer(line_object)
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
      varname = @global_variable_scope ? "@#{object[:variable_name]}" : object[:variable_name]
      @last_variable = varname
      varname
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
        str_to_num(string).to_i
      end
    end

    def transform_type(object)
      case object[:type]
      when "nil"
        'nil'
      when "null"
        '0'
      when "true"
        'true'
      when "false"
        'false'
      end
    end

    def transform_empty_line(_object)
      ""
    end

    def additional_argument_transformation(argument)
      if @method_names.include?(argument)
        return "defined?(#{argument})"
      end

      return argument
    end

    def transform_if(object)
      argument = select_transformer(object[:if][:argument])
      argument = additional_argument_transformation(argument)

      block = transform_block(object[:if][:block])
      output = "if #{argument}\n"
      output += "#{' ' * @indent}#{block}"
      output += "#{' ' * @indent}end\n"
      output
    end

    def transform_block(block)
      output = ''
      @indent += 2
      block_output = []

      block.each do |block_line|
        block_output << select_transformer(block_line)
      end

      output += block_output.map { |l| "  #{l}" }.join("\n") + "\n"
      @indent -= 2
      output
    end

    def transform_else(_object)
      "else"
    end

    def transform_while(object)
      argument = select_transformer(object[:while][:argument])
      block = transform_block(object[:while][:block])
      output = "while #{argument}\n"
      output += "#{' ' * @indent}#{block}"
      output += "#{' ' * @indent}end\n"
      output
    end

    def transform_until(object)
      argument = select_transformer(object[:until][:argument])
      block = transform_block(object[:until][:block])
      output = "until #{argument}\n"
      output += "#{' ' * @indent}#{block}"
      output += "#{' ' * @indent}end\n"
      output
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
      block = transform_block(object[:function][:block])

      output = "def #{funcname}(#{argument})\n"
      output += "#{' ' * @indent}#{block}"
      output += "#{' ' * @indent}end\n"
      output      
    end

    def transform_and(object)
      left = select_transformer(object[:and][:left])
      right = select_transformer(object[:and][:right])

      "#{left} && #{right}"
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