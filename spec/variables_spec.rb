RSpec.describe KaiserRuby do
  context 'variable names' do
    it 'converts My world to a variable' do
      expect(KaiserRuby.transpile("My world")).to eq "my_world"
    end

    it 'converts your soul to a variable' do
      expect(KaiserRuby.transpile("your soul")).to eq "your_soul"
    end

    it 'converts Jean to a variable' do
      expect(KaiserRuby.transpile("Jean")).to eq "jean"
    end

    it 'converts Mister Sandman to a variable' do
      expect(KaiserRuby.transpile("Mister Sandman")).to eq "mister_sandman"
    end

    it 'converts Johnny B Goode to a variable' do
      expect(KaiserRuby.transpile("Johnny B Goode")).to eq "johnny_b_goode"
    end

    it 'ignores commas' do
      expect(KaiserRuby.transpile('a man,')).to eq "a_man"
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
