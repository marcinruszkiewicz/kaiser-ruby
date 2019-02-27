# frozen_string_literal: true

RSpec.describe KaiserRuby do
  context 'assignment statement' do
    it 'assigns common variables' do
      expect(KaiserRuby.transpile('Put the love into the heart')).to eq '@the_heart = @the_love'
    end

    it 'assigns proper variables' do
      expect(KaiserRuby.transpile('Put Love into Heart')).to eq '@heart = @love'
    end

    it 'assigns string to a common variable' do
      expect(KaiserRuby.transpile('Put "Hello World" into your soul')).to eq '@your_soul = "Hello World"'
    end

    it 'assigns number to a common variable' do
      expect(KaiserRuby.transpile('Put 3.14 into X')).to eq '@x = 3.14'
    end

    it 'assigns an expression to a variable' do
      expect(KaiserRuby.transpile('Put the whole of your heart into my hands')).to eq '@my_hands = @the_whole * @your_heart'
    end

    it 'assigns a returned value to a variable' do
      expect(KaiserRuby.transpile('Put Midnight taking Dreams into my hands')).to eq '@my_hands = midnight(@dreams)'
    end
  end
end
