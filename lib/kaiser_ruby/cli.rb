require 'thor'

module KaiserRuby
  class CLI < Thor
    package_name "Kaiser-Ruby v#{KaiserRuby::VERSION}"
    
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
        out.write <<~REQ
          require 'kaiser_ruby/refinements'
          using KaiserRuby::Refinements
          
        REQ
        out.write output
        out.close
        say "Saved output in `#{options[:save]}`", :green
      else
        say output
      end
      say
    end

    using KaiserRuby::Refinements

    desc "execute FILE", "transpiles and runs a .rock FILE"
    def execute(filename)
      file = File.read filename
      output = KaiserRuby.transpile(file)
      instance_eval output
      say
    end

    desc "rock", "opens an interactive console that accepts and evaluates Rockstar code"
    option :debug, type: :boolean, desc: "also shows transpiled code"
    def rock
      say "Type 'exit' to exit the console. Otherwise, rock on!"

      # grab the outside block's binding, so that we can use it to eval code
      # this makes it not lose local variables throughout the loop
      b = binding

      loop do
        begin
          input = ask('\m/>')
          break if input == 'exit'

          code = KaiserRuby.transpile(input)
          say "\\m/> #{code}", :blue if options[:debug]
          output = b.eval(code)
          output = 'nil' if output.nil?
          say "  => #{output}\n"
        rescue Exception => e
          say "THE STAGE IS ON FIRE! #{e}: #{e.message}"
        end
      end
    end
  end
end
