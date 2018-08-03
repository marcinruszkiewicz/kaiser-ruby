require 'pry'
module KaiserRuby
  class RockstarTransform < Parslet::Transform
    rule(variable_name: simple(:str)) { |c| parameterize(c[:str]) }

    rule(nil_value: simple(:_)) { 'nil' }
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

    rule(equals: { left: simple(:left), right: simple(:right) }) { "#{left} == #{right}" }
    rule(if: { if_condition: simple(:if_condition), if_block: sequence(:if_block_lines), endif: simple(:_)} ) do
      output = "#{' ' * KaiserRuby.indent}if #{if_condition}\n"
      KaiserRuby.up_indent
      output += if_block_lines.map { |l| "#{' ' * KaiserRuby.indent}#{l}\n" }.join
      KaiserRuby.down_indent
      output += "#{' ' * KaiserRuby.indent}end"
      output
    end

    rule(if_else: { if_condition: simple(:if_condition), if_block: sequence(:if_block_lines), else_block: sequence(:else_block_lines), endif: simple(:_)} ) do
      output = "#{' ' * KaiserRuby.indent}if #{if_condition}\n"
      KaiserRuby.up_indent
      output += if_block_lines.map { |l| "#{' ' * KaiserRuby.indent}#{l}\n" }.join
      KaiserRuby.down_indent
      output += "#{' ' * KaiserRuby.indent}else\n"
      KaiserRuby.up_indent
      output += else_block_lines.map { |l| "#{' ' * KaiserRuby.indent}#{l}\n" }.join
      KaiserRuby.down_indent
      output += "#{' ' * KaiserRuby.indent}end"
      output
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