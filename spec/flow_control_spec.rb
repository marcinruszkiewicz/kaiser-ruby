RSpec.describe KaiserRuby do
  context 'if else' do
    let(:if_block) do <<~END
        If Tommy is nobody
        Shout "Nobody"
      END
    end

    let(:if_else_block) do <<~END
        If Tommy is a human
        Shout "Human"
        Else
        Shout "Nobody"
      END
    end

    let(:multiple_ifs) do <<~END
        If Tommy is a human
        Shout "Human"

        If Tommy is da boss
        Shout "Nobody"
      END
    end

    let(:nested_ifs) do <<~END
        If Tommy is a human
        Shout "Human"
        If Tommy is da boss
        Shout "Nobody"
        Else
        Shout "Unknown"
      END
    end

    it 'makes an if block' do
      expect(KaiserRuby.transpile(if_block)).to eq <<~RESULT
        if tommy == 0
          puts "Nobody"
        end # endif
      RESULT
    end

    it 'makes an if else block' do
      expect(KaiserRuby.transpile(if_else_block)).to eq <<~RESULT
        if tommy == 15
          puts "Human"
        else
          puts "Nobody"
        end # endifelse
      RESULT
    end

    it 'makes multiple consecutive if blocks correctly' do
      expect(KaiserRuby.transpile(multiple_ifs)).to eq <<~RESULT
        if tommy == 15
          puts "Human"
        end # endif
        if tommy == 24
          puts "Nobody"
        end # endif
      RESULT
    end

    it 'makes nested if blocks correctly' do
      expect(KaiserRuby.transpile(nested_ifs)).to eq <<~RESULT
        if tommy == 15
          puts "Human"
          if tommy == 24
          puts "Nobody"
        else
          puts "Unknown"
        end # endifelse
        end # endif
      RESULT
    end
  end

  context 'while loop' do
    let(:while_block) do <<~END
        While Tommy is nobody
        Shout "Nobody"
      END
    end

    it 'makes a while block' do
      expect(KaiserRuby.transpile(while_block)).to eq <<~RESULT
        while tommy == 0
          puts "Nobody"
        end # endwhile
      RESULT
    end
  end

  context 'until loop' do
    let(:until_block) do <<~END
        Until Tommy is nobody
        Shout "Nobody"
      END
    end

    it 'makes a until block' do
      expect(KaiserRuby.transpile(until_block)).to eq <<~RESULT
        until tommy == 0
          puts "Nobody"
        end # enduntil
      RESULT
    end
  end
end
