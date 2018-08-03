require 'thor'

module KaiserRuby
  class CLI < Thor
    desc "transpile FILE", "transpile a .rock FILE and output the result"
    option :show_source, type: :boolean, desc: "prints out the source file along with the transpiled output"
    option :save, desc: "saves the transpiled output in SAVE"
    def transpile(filename)
      file = File.read filename
      output = KaiserRuby.transpile(file)

      if options[:show_source]
        puts file
        puts "-" * 40
      end

      if options[:save]
        out = File.new(options[:save], 'w')
        out.write output
        out.close
        puts "Saved output in `#{options[:save]}`"
      else
        puts output
      end
      puts
    end

    desc "execute FILE", "transpiles and runs a .rock FILE"
    def execute(filename)
      file = File.read filename
      output = KaiserRuby.transpile(file)

      eval output
    end
  end
end