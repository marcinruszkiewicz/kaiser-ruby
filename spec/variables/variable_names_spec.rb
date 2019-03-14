# frozen_string_literal: true

RSpec.describe KaiserRuby do
  context 'proper variables' do
    it 'handles a single word' do
      expect(KaiserRuby.transpile('say Jean')).to eq 'puts @jean'
    end

    it 'handles more words' do
      expect(KaiserRuby.transpile('say Mister Sandman')).to eq 'puts @mister_sandman'
    end

    it 'handles single capitalized letters' do
      expect(KaiserRuby.transpile('say Johnny B Goode')).to eq 'puts @johnny_b_goode'
    end

    it 'handles metal umlauts' do
      expect(KaiserRuby.transpile('say Motörhead')).to eq 'puts @motörhead'
    end

    it 'handles single uppercase letters' do
      expect(KaiserRuby.transpile('say X')).to eq 'puts @x'
    end

    it "doesn't convert mixed case words" do
      expect { KaiserRuby.transpile('say Mister sandman') }.to raise_error SyntaxError
    end
  end

  context 'common variables' do
    it 'converts My world to a variable' do
      expect(KaiserRuby.transpile('say My world')).to eq 'puts @my_world'
    end

    it 'converts your soul to a variable' do
      expect(KaiserRuby.transpile('say your soul')).to eq 'puts @your_soul'
    end

    it 'ignores commas' do
      expect(KaiserRuby.transpile('say a man,')).to eq 'puts @a_man'
    end

    it 'ignores nonalpha chars' do
      expect(KaiserRuby.transpile('say a 332man!')).to eq 'puts @a_man'
    end

    it "doesn't convert mixed case words" do
      expect(KaiserRuby.transpile('say the World')).to eq 'puts @the_world'
    end

    it 'handles metal umlauts' do
      expect(KaiserRuby.transpile('say the öyster')).to eq 'puts @the_öyster'
    end
  end

  context 'pronouns' do
    let(:example) do
      <<~CODE
        Desire is a killer
        Shout it
        Union's been on strike
        Whisper them
      CODE
    end

    it 'converts pronouns to last used variable' do
      expect(KaiserRuby.transpile(example)).to eq <<~RESULT
        @desire = 16
        puts @desire
        @union = 426
        puts @union
      RESULT
    end
  end

  context 'simple variables' do
    it 'converts a single lowercased word' do
      expect(KaiserRuby.transpile('say johnny')).to eq 'puts @johnny'
    end

    it 'leaves numbers' do
      expect(KaiserRuby.transpile('say a5')).to eq 'puts @a5'
    end

    it 'strips special chars' do
      expect(KaiserRuby.transpile('say bad_name!')).to eq 'puts @badname'
    end
  end
end
