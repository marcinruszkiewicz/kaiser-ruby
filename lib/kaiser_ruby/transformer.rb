module KaiserRuby
  class Transformer
    attr_reader :parsed_tree, :output

    def initialize(tree)
      @parsed_tree = tree
      @output = []
    end

    def transform
      @parsed_tree.each do |line_object|
        @output << select_transformer(line_object)
      end

      @output << '' if @output.size > 1
      @output.join("\n")
    end

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

    def transform_variable_name(object)
      object[:variable_name]
    end

    def transform_string(object)
      object[:string]
    end

    def transform_number(object)
      object[:number]
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
        string.split('.').map do |sub|
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
        0
      when "true"
        true
      when "false"
        false
      end
    end

    def transform_empty_line(_object)
      ""
    end

    def select_transformer(object)
      key = object.keys.first
      send("transform_#{key}", object)
    end

    def method_missing(m, *args, &block)  
      raise ArgumentError, "missing Transform rule: #{m}, #{args}"
    end

    def str_to_num(string)
      filter_string(string).map { |e| e.length % 10 }.join
    end

    def filter_string(string, rxp: /[[:alpha:]]/)
      string.to_s.split(/\s+/).map { |e| e.chars.select { |c| c =~ rxp }.join }
    end    
  end
end