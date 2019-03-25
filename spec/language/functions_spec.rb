# frozen_string_literal: true

RSpec.describe KaiserRuby do
  context 'function definition' do
    let(:one_argument) do
      <<~CODE
        Midnight takes Hate
        Shout Desire
        Give back Hate
      CODE
    end

    let(:two_arguments) do
      <<~CODE
        Midnight takes Hate and Desire
        Shout Desire
      CODE
    end

    let(:two_arguments_output) do
      <<~'RESULT'
        def midnight(hate, desire)
          puts (desire).to_s
        end
      RESULT
    end

    let(:two_arguments_contracted) do
      <<~CODE
        Midnight takes Hate 'n' Desire
        Shout Desire
      CODE
    end

    let(:two_arguments_ampersand) do
      <<~CODE
        Midnight takes Hate & Desire
        Shout Desire
      CODE
    end

    it 'makes a function definition' do
      expect(KaiserRuby.transpile(one_argument)).to eq <<~'RESULT'
        def midnight(hate)
          puts (desire).to_s
          return hate
        end
      RESULT
    end

    it 'makes a function definition with two arguments' do
      expect(KaiserRuby.transpile(two_arguments)).to eq two_arguments_output
    end

    it 'works with contraction' do
      expect(KaiserRuby.transpile(two_arguments_contracted)).to eq two_arguments_output
    end

    it 'works with ampersand' do
      expect(KaiserRuby.transpile(two_arguments_ampersand)).to eq two_arguments_output
    end
  end

  context 'function calls' do
    let(:one_argument) { 'Midnight taking Hate' }
    let(:two_arguments) { 'Metal taking a man, a song' }
    let(:mixed_arguments) { 'Metal taking a man, a song, and a life' }
    let(:contraction) { "Music taking Rock'n'Roll" }
    let(:ampersand) { 'Music taking Rock & Roll' }

    it 'calls a function' do
      expect(KaiserRuby.transpile(one_argument)).to eq 'midnight(@hate)'
    end

    it 'calls a function with more arguments' do
      expect(KaiserRuby.transpile(two_arguments)).to eq 'metal(@a_man, @a_song)'
    end

    it 'calls a function with mixed separators' do
      expect(KaiserRuby.transpile(mixed_arguments)).to eq 'metal(@a_man, @a_song, @a_life)'
    end

    it 'works with contractions' do
      expect(KaiserRuby.transpile(contraction)).to eq 'music(@rock, @roll)'
    end

    it 'works with ampersand' do
      expect(KaiserRuby.transpile(ampersand)).to eq 'music(@rock, @roll)'
    end
  end

  context 'return a value' do
    let(:variable) do
      <<~CODE
        Function takes Desire
        Give back Desire
      CODE
    end
    let(:expression) do
      <<~CODE
        Function takes the daylight & the night
        Give back the daylight with the night
      CODE
    end

    it 'returns a variable' do
      expect(KaiserRuby.transpile(variable)).to eq <<~RESULT
        def function(desire)
          return desire
        end
      RESULT
    end

    it 'returs an expression' do
      expect(KaiserRuby.transpile(expression)).to eq <<~RESULT
        def function(the_daylight, the_night)
          return the_daylight + the_night
        end
      RESULT
    end
  end
end
