# frozen_string_literal: true

RSpec.describe KaiserRuby do
  context 'verses' do
    let(:more_lines) do
      <<~CODE
        Put 5 into your heart
        Whisper your heart
      CODE
    end

    it 'ignores empty lines' do
      expect(KaiserRuby.transpile("\n")).to eq ''
    end

    it 'transpiles a string' do
      expect(KaiserRuby.transpile('Tommy is a vampire')).to eq '@tommy = 17'
    end

    it 'transpiles a single line' do
      expect(KaiserRuby.transpile("Put 3 into your mind\n")).to eq '@your_mind = 3'
    end

    it 'transpiles multiple lines' do
      expect(KaiserRuby.transpile(more_lines)).to eq <<~'RESULT'
        @your_heart = 5
        puts (@your_heart).to_s
      RESULT
    end
  end

  context 'lyrics' do
    let(:lyrics) do
      <<~CODE
        Put 5 into your heart
        Whisper your heart

        Put "Ruby" into a rockstar
        Scream a rockstar
      CODE
    end

    it 'transpiles multiple blocks of code' do
      expect(KaiserRuby.transpile(lyrics)).to eq <<~'RESULT'
        @your_heart = 5
        puts (@your_heart).to_s

        @a_rockstar = "Ruby"
        puts (@a_rockstar).to_s
      RESULT
    end
  end

  context 'comments' do
    let(:comments) do
      <<~CODE
        Ruby is a language
        (a programming one)
        Javascript is a language (probably)
      CODE
    end

    it 'consumes comments' do
      expect(KaiserRuby.transpile(comments)).to eq <<~RESULT
        @ruby = 18

        @javascript = 18
      RESULT
    end
  end
end
