require 'pry'
module KaiserRuby
  class RockstarTransform < Parslet::Transform
    rule(variable_name: simple(:str)) { |c| parameterize(c[:str]) }

    rule(mysterious_value: simple(:_)) { 'nil' }
    rule(null_value: simple(:_)) { '0' }
    rule(true_value: simple(:_)) { 'true' }
    rule(false_value: simple(:_)) { 'false' }
    rule(string_value: simple(:str)) { str }
    rule(numeric_value: simple(:num)) { num }
    rule(unquoted_string: simple(:str)) { "\"#{str}\"" }
    rule(string_as_number: simple(:str)) do |c|
      if c[:str].to_s.include?('.')
        c[:str].to_s.gsub(/[^A-Za-z\s\.]/, '').split('.').map do |sub|
          str_to_num(sub)
        end.join('.').to_f
      else
        str_to_num(c[:str])
      end
    end

    rule(assignment: { left: simple(:left), right: simple(:right) }) { "#{left} = #{right}" }
    rule(increment: simple(:str)) { "#{str} += 1" }
    rule(decrement: simple(:str)) { "#{str} -= 1" }
    rule(addition: { left: simple(:left), right: simple(:right) }) { "#{left} + #{right}" }
    rule(subtraction: { left: simple(:left), right: simple(:right) }) { "#{left} - #{right}" }
    rule(multiplication: { left: simple(:left), right: simple(:right) }) { "#{left} * #{right}" }
    rule(division: { left: simple(:left), right: simple(:right) }) { "#{left} / #{right}" }

    rule(print: { output: simple(:output) }) { "puts #{output}" }
    rule(continue: simple(:_)) { "next" }
    rule(break: simple(:_)) { "break" }

    rule(equals: { left: simple(:left), right: simple(:right) }) { "#{left} == #{right}" }
    rule(not_equals: { left: simple(:left), right: simple(:right) }) { "#{left} != #{right}" }
    rule(gt: { left: simple(:left), right: simple(:right) }) { "#{left} > #{right}" }
    rule(gte: { left: simple(:left), right: simple(:right) }) { "#{left} >= #{right}" }
    rule(lte: { left: simple(:left), right: simple(:right) }) { "#{left} <= #{right}" }
    rule(lt: { left: simple(:left), right: simple(:right) }) { "#{left} < #{right}" }

    rule(if: {
      if_condition: simple(:if_condition),
      if_block: sequence(:if_block_lines),
      endif: simple(:_)
    } ) do
      output = "#{' ' * KaiserRuby.indent}if #{if_condition}\n"
      KaiserRuby.up_indent
      output += if_block_lines.map { |l| "#{' ' * KaiserRuby.indent}#{l}\n" }.join
      KaiserRuby.down_indent
      output += "#{' ' * KaiserRuby.indent}end # endif"
      output
    end

    rule(if: {
      if_condition: simple(:if_condition),
      and_or: simple(:and_or),
      second_condition: simple(:second_condition),
      if_block: sequence(:if_block_lines),
      endif: simple(:_)
    } ) do
      proper_and_or = and_or == 'and' ? '&&' : '||'
      output = "#{' ' * KaiserRuby.indent}if #{if_condition} #{proper_and_or} #{second_condition}\n"
      KaiserRuby.up_indent
      output += if_block_lines.map { |l| "#{' ' * KaiserRuby.indent}#{l}\n" }.join
      KaiserRuby.down_indent
      output += "#{' ' * KaiserRuby.indent}end # endif"
      output
    end

    rule(if_else: {
      if_condition: simple(:if_condition),
      if_block: sequence(:if_block_lines),
      else_block: sequence(:else_block_lines),
      endif: simple(:_)
    } ) do
      output = "#{' ' * KaiserRuby.indent}if #{if_condition}\n"
      KaiserRuby.up_indent
      output += if_block_lines.map { |l| "#{' ' * KaiserRuby.indent}#{l}\n" }.join
      KaiserRuby.down_indent
      output += "#{' ' * KaiserRuby.indent}else\n"
      KaiserRuby.up_indent
      output += else_block_lines.map { |l| "#{' ' * KaiserRuby.indent}#{l}\n" }.join
      KaiserRuby.down_indent
      output += "#{' ' * KaiserRuby.indent}end # endifelse"
      output
    end

    rule(if_else: {
      if_condition: simple(:if_condition),
      and_or: simple(:and_or),
      second_condition: simple(:second_condition),
      if_block: sequence(:if_block_lines),
      else_block: sequence(:else_block_lines),
      endif: simple(:_)
    } ) do
      proper_and_or = and_or == 'and' ? '&&' : '||'
      output = "#{' ' * KaiserRuby.indent}if #{if_condition} #{proper_and_or} #{second_condition}\n"
      KaiserRuby.up_indent
      output += if_block_lines.map { |l| "#{' ' * KaiserRuby.indent}#{l}\n" }.join
      KaiserRuby.down_indent
      output += "#{' ' * KaiserRuby.indent}else\n"
      KaiserRuby.up_indent
      output += else_block_lines.map { |l| "#{' ' * KaiserRuby.indent}#{l}\n" }.join
      KaiserRuby.down_indent
      output += "#{' ' * KaiserRuby.indent}end # endifelse"
      output
    end

    rule(while: {
      while_condition: simple(:while_condition),
      while_block: sequence(:while_block_lines),
      endwhile: simple(:_)
    } ) do
      output = "#{' ' * KaiserRuby.indent}while #{while_condition}\n"
      KaiserRuby.up_indent
      output += while_block_lines.map { |l| "#{' ' * KaiserRuby.indent}#{l}\n" }.join
      KaiserRuby.down_indent
      output += "#{' ' * KaiserRuby.indent}end # endwhile"
      output
    end

    rule(while: {
      while_condition: simple(:while_condition),
      and_or: simple(:and_or),
      second_condition: simple(:second_condition),
      while_block: sequence(:while_block_lines),
      endwhile: simple(:_)
    } ) do
      proper_and_or = and_or == 'and' ? '&&' : '||'
      output = "#{' ' * KaiserRuby.indent}while #{while_condition} #{proper_and_or} #{second_condition}\n"
      KaiserRuby.up_indent
      output += while_block_lines.map { |l| "#{' ' * KaiserRuby.indent}#{l}\n" }.join
      KaiserRuby.down_indent
      output += "#{' ' * KaiserRuby.indent}end # endwhile"
      output
    end

    rule(until: {
      until_condition: simple(:until_condition),
      until_block: sequence(:until_block_lines),
      enduntil: simple(:_)
    } ) do
      output = "#{' ' * KaiserRuby.indent}until #{until_condition}\n"
      KaiserRuby.up_indent
      output += until_block_lines.map { |l| "#{' ' * KaiserRuby.indent}#{l}\n" }.join
      KaiserRuby.down_indent
      output += "#{' ' * KaiserRuby.indent}end # enduntil"
      output
    end

    rule(until: {
      until_condition: simple(:until_condition),
      and_or: simple(:and_or),
      second_condition: simple(:second_condition),
      until_block: sequence(:until_block_lines),
      enduntil: simple(:_)
    } ) do
      proper_and_or = and_or == 'and' ? '&&' : '||'
      output = "#{' ' * KaiserRuby.indent}until #{until_condition} #{proper_and_or} #{second_condition}\n"
      KaiserRuby.up_indent
      output += until_block_lines.map { |l| "#{' ' * KaiserRuby.indent}#{l}\n" }.join
      KaiserRuby.down_indent
      output += "#{' ' * KaiserRuby.indent}end # enduntil"
      output
    end

    rule(argument_name: simple(:str)) { str }
    rule(return_value: simple(:value)) { "return #{value}" }

    rule(function_definition: {
      function_name: simple(:function_name),
      arguments: sequence(:arguments),
      function_block: sequence(:function_block_lines),
      enddef: simple(:_)
    } ) do
      output = "#{' ' * KaiserRuby.indent}def #{function_name}(#{arguments.join(', ')})\n"
      KaiserRuby.up_indent
      output += function_block_lines.map { |l| "#{' ' * KaiserRuby.indent}#{l}\n" }.join
      KaiserRuby.down_indent
      output += "#{' ' * KaiserRuby.indent}end # enddef"
      output
    end

    rule(function_call: {
      function_name: simple(:function_name),
      arguments: sequence(:arguments)
    } ) do
      "#{function_name}(#{arguments.join(', ')})"
    end

    rule(line: simple(:line)) { line == "\n" ? nil : line }
    rule(lyrics: sequence(:lines)) { lines.join("\n") + "\n" }

    def self.parameterize(string)
      string.to_s.downcase.gsub(/\s+/, '_')
    end

    def self.str_to_num(string)
      string.to_s.split(/\s+/).map { |e| e.length % 10 }.join.to_i
    end
  end
end