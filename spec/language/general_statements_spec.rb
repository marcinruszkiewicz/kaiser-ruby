RSpec.describe KaiserRuby do
  context 'print statement' do
    let(:input) do <<~END
        put 0 into I
        put 1 into J
        say J plus ", " plus I
      END
    end

    it 'prints values' do
      expect(KaiserRuby.transpile('Scream my love')).to eq 'puts @my_love'
    end

    context 'different types' do
      it 'converts types' do
        expect(KaiserRuby.transpile(input)).to eq <<~RESULT
          @i = 0
          @j = 1
          puts @j + ", " + @i
        RESULT
      end

      it 'executes correctly' do 
        expect(KaiserRuby.execute(input)).to eq "1, 0\n"
      end
    end
  end

  context 'input from STDIN' do
    let(:input) do <<~END
        Listen to the news
        Shout the news
      END
    end

    it 'transforms into ruby' do
      expect(KaiserRuby.transpile(input)).to eq <<~RESULT
        print '> '
        __input = STDIN.gets.chomp
        @the_news = Float(__input) rescue __input
        puts @the_news
      RESULT
    end
  end
end