# frozen_string_literal: true

RSpec.describe KaiserRuby do
  context 'proper variables' do
    it 'handles a single word' do
      expect(KaiserRuby.transpile('say Jean')).to eq 'puts (@jean).to_s'
    end

    it 'handles more words' do
      expect(KaiserRuby.transpile('say Mister Sandman')).to eq 'puts (@mister_sandman).to_s'
    end

    it 'handles single capitalized letters' do
      expect(KaiserRuby.transpile('say Johnny B Goode')).to eq 'puts (@johnny_b_goode).to_s'
    end

    it 'handles metal umlauts' do
      expect(KaiserRuby.transpile('say Motörhead')).to eq 'puts (@motörhead).to_s'
    end

    it 'handles single uppercase letters' do
      expect(KaiserRuby.transpile('say X')).to eq 'puts (@x).to_s'
    end

    it "doesn't convert mixed case words" do
      expect { KaiserRuby.transpile('say Mister sandman') }.to raise_error SyntaxError
    end
  end

  context 'common variables' do
    it 'converts My world to a variable' do
      expect(KaiserRuby.transpile('say My world')).to eq 'puts (@my_world).to_s'
    end

    it 'converts your soul to a variable' do
      expect(KaiserRuby.transpile('say your soul')).to eq 'puts (@your_soul).to_s'
    end

    it 'ignores commas' do
      expect(KaiserRuby.transpile('say a man,')).to eq 'puts (@a_man).to_s'
    end

    it 'ignores nonalpha chars' do
      expect(KaiserRuby.transpile('say a 332man!')).to eq 'puts (@a_man).to_s'
    end

    it "doesn't convert mixed case words" do
      expect(KaiserRuby.transpile('say the World')).to eq 'puts (@the_world).to_s'
    end

    it 'handles metal umlauts' do
      expect(KaiserRuby.transpile('say the öyster')).to eq 'puts (@the_öyster).to_s'
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
    let(:assignment) do
      <<~CODE
        The beers were numbering fa'too'many
        While the beers ain't nothing
        Say it with your heart
        Say it with your soul
      CODE
    end

    it 'converts pronouns to last used variable' do
      expect(KaiserRuby.transpile(example)).to eq <<~'RESULT'
        @desire = 16
        puts (@desire).to_s
        @union = 426
        puts (@union).to_s
      RESULT
    end

    it 'only updates pronoun on assignment' do
      expect(KaiserRuby.transpile(assignment)).to eq <<~'RESULT'
        @the_beers = 99
        while @the_beers != nil
          puts (@the_beers + @your_heart).to_s
          puts (@the_beers + @your_soul).to_s
        end
      RESULT
    end
  end

  context 'simple variables' do
    it 'converts a single lowercased word' do
      expect(KaiserRuby.transpile('say johnny')).to eq 'puts (@johnny).to_s'
    end

    it 'leaves numbers' do
      expect(KaiserRuby.transpile('say a5')).to eq 'puts (@a5).to_s'
    end

    it 'strips special chars' do
      expect(KaiserRuby.transpile('say bad_name!')).to eq 'puts (@badname).to_s'
    end
  end
end
