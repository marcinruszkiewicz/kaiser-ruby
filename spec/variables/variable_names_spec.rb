RSpec.describe KaiserRuby do
  context 'proper variables' do
    it 'handles a single word' do
      expect(KaiserRuby.transpile("Jean")).to eq "jean"
    end

    it 'handles more words' do
      expect(KaiserRuby.transpile("Mister Sandman")).to eq "mister_sandman"
    end

    it 'handles single capitalized letters' do
      expect(KaiserRuby.transpile("Johnny B Goode")).to eq "johnny_b_goode"
    end

    it 'handles metal umlauts' do
      expect(KaiserRuby.transpile('Motörhead')).to eq 'motörhead'
    end    
  end

  context 'common variables' do
    it 'converts My world to a variable' do
      expect(KaiserRuby.transpile("My world")).to eq "my_world"
    end

    it 'converts your soul to a variable' do
      expect(KaiserRuby.transpile("your soul")).to eq "your_soul"
    end

    it 'ignores commas' do
      expect(KaiserRuby.transpile('a man,')).to eq "a_man"
    end

    it 'a single lowercased word is not a variable name' do
      expect { KaiserRuby.transpile('johnny') }.to raise_error SyntaxError
    end

    it "doesn't convert mixed case words" do
      expect { KaiserRuby.transpile('the World') }.to raise_error SyntaxError
    end

    it 'handles metal umlauts' do
      expect(KaiserRuby.transpile('the öyster')).to eq "the_öyster"
    end    
  end

  context 'pronouns' do
    let(:example) do <<~END
        Desire is a killer
        Shout it
        Union's been on strike
        Whisper them
      END
    end

    it 'converts pronouns to last used variable' do
      expect(KaiserRuby.transpile(example)).to eq <<~RESULT
        desire = 16
        puts desire
        union = 426
        puts union
      RESULT
    end
  end
end