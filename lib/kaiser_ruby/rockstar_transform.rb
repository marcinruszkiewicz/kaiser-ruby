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

    rule(line: simple(:block)) { block == "\n" ? nil : block }
    rule(lyrics: sequence(:lines)) { lines.join("\n") + "\n" }

    def self.parameterize(string)
      string.to_s.downcase.gsub(/\s+/, '_')
    end

    def self.str_to_num(string)
      string.to_s.split(/\s+/).map { |e| e.length % 10 }.join.to_i
    end
  end
end