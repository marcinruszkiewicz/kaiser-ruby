RSpec.describe KaiserRuby do
  context 'proper variables' do
    it 'handles a single word' do
      expect(KaiserRuby.transpile("say Jean")).to eq "puts Jean"
    end

    it 'handles more words' do
      expect(KaiserRuby.transpile("say Mister Sandman")).to eq "puts Mister_Sandman"
    end

    it 'handles single capitalized letters' do
      expect(KaiserRuby.transpile("say Johnny B Goode")).to eq "puts Johnny_B_Goode"
    end

    it 'handles metal umlauts' do
      expect(KaiserRuby.transpile('say Motörhead')).to eq 'puts Motörhead'
    end  

    it 'handles single uppercase letters' do
      expect(KaiserRuby.transpile('say X')).to eq 'puts X'
    end

    it "doesn't convert mixed case words" do
      expect { KaiserRuby.transpile("say Mister sandman") }.to raise_error SyntaxError
    end
  end

  context 'common variables' do
    it 'converts My world to a variable' do
      expect(KaiserRuby.transpile("say My world")).to eq "puts my_world"
    end

    it 'converts your soul to a variable' do
      expect(KaiserRuby.transpile("say your soul")).to eq "puts your_soul"
    end

    it 'ignores commas' do
      expect(KaiserRuby.transpile('say a man,')).to eq "puts a_man"
    end

    it 'ignores nonalpha chars' do
      expect(KaiserRuby.transpile('say a 332man!')).to eq "puts a_man"
    end

    it 'a single lowercased word is not a variable name' do
      expect { KaiserRuby.transpile('say johnny') }.to raise_error SyntaxError
    end

    it "doesn't convert mixed case words" do
      expect { KaiserRuby.transpile('say the World') }.to raise_error SyntaxError
    end

    it 'handles metal umlauts' do
      expect(KaiserRuby.transpile('say the öyster')).to eq "puts the_öyster"
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
        Desire = 16
        puts Desire
        Union = 426
        puts Union
      RESULT
    end
  end  
end