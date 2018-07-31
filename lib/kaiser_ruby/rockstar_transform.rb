module KaiserRuby
  class RockstarTransform < Parslet::Transform
    rule(:number_str => simple(:str)) { str.to_s.split(/\s+/).map {|e| e.length % 10}.join.to_i }

    rule(:var => { :var_name => simple(:name), :var_value => simple(:value) }) do |context|
      "#{parameterize(context[:name])} = #{context[:value]}"
    end

    def self.parameterize(string)
      string.to_s.downcase.gsub(/\s+/, '_')
    end
  end
end