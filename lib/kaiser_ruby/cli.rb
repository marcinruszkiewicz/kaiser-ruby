require 'thor'

module KaiserRuby
  class CLI < Thor
    desc "transpile FILE", "transpile a .rock FILE and output the result"
    option 'show-source'.to_sym, type: :boolean, desc: "prints out the source file along with the transpiled output"
    option :save, desc: "saves the transpiled output in SAVE"
    def transpile(filename)
      file = File.read filename
      output = KaiserRuby.transpile(file)

      if options['show-source'.to_sym]
        say file
        say "-" * 40, :green
      end

      if options[:save]
        out = File.new(options[:save], 'w')
        out.write output
        out.close
        say "Saved output in `#{options[:save]}`", :green
      else
        say output
      end
      say
    end

    desc "execute FILE", "transpiles and runs a .rock FILE"
    def execute(filename)
      file = File.read filename
      output = KaiserRuby.transpile(file)

      eval output
      say
    end

    desc "rock", "opens an interactive console that accepts and evaluates Rockstar code"
    option :debug, type: :boolean, desc: "also shows transpiled code"
    def rock
      say "Type 'exit' to exit the console. Otherwise, rock on!"

      b = binding

      begin
        input = ask('\m/>')
        if input != 'exit'
          code = KaiserRuby.transpile(input)
          say "\\m/> #{code}", :blue if options[:debug]
          output = b.eval(code)
          output = 'nil' if output.nil?
          say "  => #{output}\n"
        end
      end until input == 'exit'
    end
  end
end