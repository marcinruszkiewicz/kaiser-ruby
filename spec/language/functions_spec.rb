RSpec.describe KaiserRuby do
  context 'function definition' do
    let(:one_argument) do <<~END
        Midnight takes Hate
        Shout Desire
        Give back Desire
      END
    end

    let(:two_arguments) do <<~END
        Midnight takes Hate and Desire
        Shout Desire
      END
    end

    it 'makes a function definition' do
      expect(KaiserRuby.transpile(one_argument)).to eq <<~RESULT
        def Midnight(Hate)
          puts Desire
          return Desire
        end
      RESULT
    end

    it 'makes a function definition with two arguments' do
      expect(KaiserRuby.transpile(two_arguments)).to eq <<~RESULT
        def Midnight(Hate, Desire)
          puts Desire
        end
      RESULT
    end
  end

  context 'function calls' do
    let(:one_argument) { "Midnight taking Hate" }
    let(:two_arguments) { "Metal taking a man, a song" }

    it 'calls a function' do
      expect(KaiserRuby.transpile(one_argument)).to eq "Midnight(Hate)"
    end

    it 'calls a function with more arguments' do
      expect(KaiserRuby.transpile(two_arguments)).to eq "Metal(a_man, a_song)"
    end
  end

  context 'return a value' do
    let(:variable) { "Give back Desire" }
    let(:expression) { "Give back the daylight with the night" }

    it 'returns a variable' do
      expect(KaiserRuby.transpile(variable)).to eq "return Desire"
    end

    it 'returs an expression' do
      expect(KaiserRuby.transpile(expression)).to eq "return the_daylight + the_night"
    end
  end
end