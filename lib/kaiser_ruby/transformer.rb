# frozen_string_literal: true

module KaiserRuby
  # taking the intermediate tree output of parsing, output Ruby code
  class Transformer
    attr_reader :parsed_tree, :output

    def initialize(tree)
      @parsed_tree = tree
      @output = []
      @method_names = []
      @global_variables = []
      @nested_functions = {}
      @nesting = 0
      @indentation = ''
      @lnum = 0
      @current_scope = [nil]
    end

    def transform
      @last_variable = nil # name of last used variable for pronouns
      @else_already = nil # line number of a current if block, so we can avoid double else

      # first pass over the tree to find out which variables are global and which are not
      # in case some are declared *after* the function definition that uses them
      @parsed_tree.each do |line_object|
        next unless line_object[:current_scope].nil?

        line_object.extend(Hashie::Extensions::DeepLocate)

        line_object.deep_locate(:variable_name).each do |vname_obj|
          @global_variables.push vname_obj.dig(:variable_name)
        end
      end
      @global_variables = @global_variables.compact.uniq

      @parsed_tree.each_with_index do |line_object, lnum|
        @current_scope.push(line_object[:current_scope]) unless @current_scope.last == line_object[:current_scope]
        @lnum = lnum
        transformed_line = select_transformer(line_object)
        @nesting = line_object[:nesting] || 0
        actual_nesting = line_object.key?(:else) ? @nesting - 1 : @nesting
        @indentation = '  ' * actual_nesting
        @output << @indentation + transformed_line
      end

      # at end of file, close all the blocks that are still started
      while @nesting.positive?
        @nesting -= 1
        @indentation = '  ' * @nesting
        @output << @indentation + 'end'
      end

      @output << '' if @output.size > 1
      @output.join("\n")
    end

    def select_transformer(object)
      key = object.keys.first
      send("transform_#{key}", object)
    end

    def method_missing(rule, *args, &_block)
      raise ArgumentError, "missing Transform rule: #{rule}, #{args}"
    end

    def transform_print(object)
      var = select_transformer(object[:print])

      "puts (#{var}).to_s"
    end

    def transform_listen_to(object)
      var = select_transformer(object[:listen_to])
      "print '> '\n__input = $stdin.gets.chomp\n#{var} = Float(__input) rescue __input"
    end

    def transform_listen(_object)
      "print '> '\n$stdin.gets.chomp"
    end

    def transform_return(object)
      raise KaiserRuby::RockstarSyntaxError, 'Return used outside of a function' if object[:nesting].to_i.zero?

      var = select_transformer(object[:return])
      "return #{var}"
    end

    def transform_continue(object)
      raise KaiserRuby::RockstarSyntaxError, 'Continue used outside of a loop' if object[:nesting].to_i.zero?

      'next'
    end

    def transform_break(object)
      raise KaiserRuby::RockstarSyntaxError, 'Break used outside of a loop' if object[:nesting].to_i.zero?

      'break'
    end

    def transform_variable_name(object)
      varname = object[:variable_name]

      if object[:type] == :assignment
        varname = "@#{varname}" if @global_variables&.include?(varname)
      elsif @global_variables.include?(varname)
        varname = @method_names.include?(varname) ? varname : "@#{varname}"
      end

      # have to break this to make 99 beers example work as it only updates the pronoun
      # on assignment, which is technically a bug but seems like a good feature though
      # so will most likely make it way to spec as is
      # @last_variable = varname
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
      normalize_num(object[:number])
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

      @last_variable = left
      "#{left} = #{right}"
    end

    def transform_decrement(object)
      argument = select_transformer(object[:decrement])
      amount = object.dig(:decrement, :amount)

      "#{argument} -= #{amount}"
    end

    def transform_increment(object)
      argument = select_transformer(object[:increment])
      amount = object.dig(:increment, :amount)

      "#{argument} += #{amount}"
    end

    def transform_function_call(object)
      func_name = select_transformer(object[:function_call][:left])
      argument = select_transformer(object[:function_call][:right])

      if @nested_functions[@current_scope.last]&.include?(func_name)
        "#{func_name}.call(#{argument})"
      else
        "#{func_name}(#{argument})"
      end
    end

    def transform_passed_function_call(object)
      transform_function_call(object[:passed_function_call])
    end

    def transform_poetic_string(object)
      var = select_transformer(object[:poetic_string][:left])
      value = select_transformer(object[:poetic_string][:right])

      @last_variable = var
      "#{var} = #{value}"
    end

    def transform_poetic_type(object)
      var = select_transformer(object[:poetic_type][:left])
      value = select_transformer(object[:poetic_type][:right])

      @last_variable = var
      "#{var} = #{value}"
    end

    def transform_poetic_number(object)
      var = select_transformer(object[:poetic_number][:left])
      value = select_transformer(object[:poetic_number][:right])

      @last_variable = var
      "#{var} = #{value}"
    end

    def transform_number_literal(object)
      string = object[:number_literal]
      out = if string.include?('.')
              string.split('.', 2).map do |sub|
                str_to_num(sub.strip)
              end.join('.').to_f
            else
              str_to_num(string).to_f
            end

      normalize_num(out)
    end

    def transform_type(object)
      case object[:type]
      when 'mysterious'
        'KaiserRuby::Mysterious.new'
      when 'null'
        'nil'
      when 'true'
        'true'
      when 'false'
        'false'
      end
    end

    def transform_empty_line(_object)
      if @nesting.zero?
        ''
      elsif @nesting == 1
        "end\n"
      else
        @else_already = nil
        "end\n"
      end
    end

    def additional_argument_transformation(argument)
      # testing function existence
      arg = @method_names.include?(argument) ? "defined?(#{argument})" : argument

      # single variable without any operator needs to return a refined boolean
      arg = "#{arg}.to_bool" if arg !~ /==|>|>=|<|<=|!=/

      arg
    end

    def transform_if(object)
      argument = select_transformer(object[:if][:argument])
      argument = additional_argument_transformation(argument)

      "if #{argument}"
    end

    def transform_else(object)
      raise KaiserRuby::RockstarSyntaxError, 'Else outside an if block' if object[:nesting].to_i.zero?
      raise KaiserRuby::RockstarSyntaxError, 'Double else inside if block' if !@else_already.nil? && object[:nesting_start_line] == @else_already

      @else_already = object[:nesting_start_line]

      'else'
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
      argument = select_transformer(object[:function][:argument])

      if @current_scope.last.nil?
        @method_names << funcname
        "def #{funcname}(#{argument})"
      else
        @nested_functions[@current_scope.last] ||= []
        @nested_functions[@current_scope.last].push funcname

        "#{funcname} = ->(#{argument}) do"
      end
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

    def transform_nor(object)
      left = select_transformer(object[:nor][:left])
      right = select_transformer(object[:nor][:right])

      "!(#{left} || #{right})"
    end

    # private

    def str_to_num(string)
      filter_string(string).map { |e| e.length % 10 }.join
    end

    def filter_string(string, rxp: /[[:alpha:]]/)
      string.to_s.split(/\s+/).map { |e| e.chars.select { |c| c =~ rxp }.join }.reject(&:empty?)
    end

    def normalize_num(num)
      num.modulo(1).zero? ? num.to_i : num
    end
  end
end
