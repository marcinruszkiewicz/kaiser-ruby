RSpec.describe KaiserRuby do
  context 'print statement' do
    it 'prints values' do
      expect(KaiserRuby.transpile('Scream my love')).to eq 'puts my_love'
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
        the_news = Integer(__input) rescue __input
        puts the_news
      RESULT
    end
  end
end