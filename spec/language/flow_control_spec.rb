# frozen_string_literal: true

RSpec.describe KaiserRuby do
  context 'if else' do
    let(:if_block) do
      <<~CODE
        If Tommy is nobody
        Shout "Nobody"
      CODE
    end

    let(:if_else_block) do
      <<~CODE
        If Tommy is a human
        Shout "Human"
        Else
        Shout "Nobody"
      CODE
    end

    let(:multiple_ifs) do
      <<~CODE
        If Tommy is a human
        Shout "Human"

        If Tommy is a boss
        Shout "Nobody"
      CODE
    end

    let(:nested_ifs) do
      <<~CODE
        If Tommy is a human
        Shout "Human"
        If Tommy is a boss
        Shout "Nobody"
        Else
        Shout "Unknown"
      CODE
    end

    let(:two_conditions) do
      <<~CODE
        If Tommy is a man and Gina is a vampire
        Shout "Master"
      CODE
    end

    it 'makes an if block' do
      expect(KaiserRuby.transpile(if_block)).to eq <<~'RESULT'
        if @tommy == nil
          puts "#{"Nobody"}"
        end
      RESULT
    end

    it 'makes an if else block' do
      expect(KaiserRuby.transpile(if_else_block)).to eq <<~'RESULT'
        if @tommy == @a_human
          puts "#{"Human"}"
          else
          puts "#{"Nobody"}"
        end
      RESULT
    end

    it 'makes multiple consecutive if blocks correctly' do
      expect(KaiserRuby.transpile(multiple_ifs)).to eq <<~'RESULT'
        if @tommy == @a_human
          puts "#{"Human"}"
        end

        if @tommy == @a_boss
          puts "#{"Nobody"}"
        end
      RESULT
    end

    it 'makes nested if blocks correctly' do
      expect(KaiserRuby.transpile(nested_ifs)).to eq <<~'RESULT'
        if @tommy == @a_human
          puts "#{"Human"}"
          if @tommy == @a_boss
            puts "#{"Nobody"}"
            else
            puts "#{"Unknown"}"
          end
        end
      RESULT
    end

    it 'makes a comparison with two elements' do
      expect(KaiserRuby.transpile(two_conditions)).to eq <<~'RESULT'
        if @tommy == @a_man && @gina == @a_vampire
          puts "#{"Master"}"
        end
      RESULT
    end
  end

  context 'while loop' do
    let(:while_block) do
      <<~CODE
        While Tommy is nobody
        Shout "Nobody"
      CODE
    end

    let(:two_conditions) do
      <<~CODE
        While Tommy is nobody or Gina is nobody
        Shout "Nobody"
      CODE
    end

    it 'makes a while block' do
      expect(KaiserRuby.transpile(while_block)).to eq <<~'RESULT'
        while @tommy == nil
          puts "#{"Nobody"}"
        end
      RESULT
    end

    it 'makes a while block with two conditions' do
      expect(KaiserRuby.transpile(two_conditions)).to eq <<~'RESULT'
        while @tommy == nil || @gina == nil
          puts "#{"Nobody"}"
        end
      RESULT
    end
  end

  context 'until loop' do
    let(:until_block) do
      <<~CODE
        Until Tommy is nobody
        Shout "Nobody"
      CODE
    end

    let(:two_conditions) do
      <<~CODE
        Until Tommy is nobody or Gina is nobody
        Shout "Nobody"
      CODE
    end

    let(:nested_if) do
      <<~CODE
        Until Tommy is nobody
        Shout "Nobody"
        If Tommy is a man
        Take it to the top

        If Tommy is the boss
        Take it to the top

        Shout "Until"
      CODE
    end

    it 'makes a until block' do
      expect(KaiserRuby.transpile(until_block)).to eq <<~'RESULT'
        until @tommy == nil
          puts "#{"Nobody"}"
        end
      RESULT
    end

    it 'makes a until block with two conditions' do
      expect(KaiserRuby.transpile(two_conditions)).to eq <<~'RESULT'
        until @tommy == nil || @gina == nil
          puts "#{"Nobody"}"
        end
      RESULT
    end

    it 'nests if and comes back to the until loop' do
      expect(KaiserRuby.transpile(nested_if)).to eq <<~'RESULT'
        until @tommy == nil
          puts "#{"Nobody"}"
          if @tommy == @a_man
            next
          end

          if @tommy == @the_boss
            next
          end

          puts "#{"Until"}"
        end
      RESULT
    end
  end

  context 'break' do
    let(:break_block) do
      <<~CODE
        While Tommy is nobody
        Break
      CODE
    end

    let(:alias_block) do
      <<~CODE
        While Tommy is nobody
        Break it down
      CODE
    end

    it 'makes break command' do
      expect(KaiserRuby.transpile(break_block)).to eq <<~'RESULT'
        while @tommy == nil
          break
        end
      RESULT
    end

    it 'alias makes break command' do
      expect(KaiserRuby.transpile(alias_block)).to eq <<~'RESULT'
        while @tommy == nil
          break
        end
      RESULT
    end
  end

  context 'continue' do
    let(:continue_block) do
      <<~CODE
        While Tommy is nobody
        Continue
      CODE
    end

    let(:alias_block) do
      <<~CODE
        While Tommy is nobody
        Take it to the top
      CODE
    end

    it 'makes continue command' do
      expect(KaiserRuby.transpile(continue_block)).to eq <<~'RESULT'
        while @tommy == nil
          next
        end
      RESULT
    end

    it 'alias makes continue command' do
      expect(KaiserRuby.transpile(alias_block)).to eq <<~'RESULT'
        while @tommy == nil
          next
        end
      RESULT
    end
  end
end
