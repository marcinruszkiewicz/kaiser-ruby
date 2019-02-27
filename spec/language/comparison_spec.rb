# frozen_string_literal: true

RSpec.describe KaiserRuby do
  context 'equality' do
    let(:if_block) do
      <<~CODE
        If Tommy is nobody
        Shout "Nobody"
      CODE
    end

    it 'makes a comparison' do
      expect(KaiserRuby.transpile(if_block)).to eq <<~RESULT
        if @tommy == 0.0
          puts "Nobody"
        end
      RESULT
    end
  end

  context 'inequality' do
    let(:if_block) do
      <<~CODE
        If Tommy ain't nobody
        Shout "Nobody"
      CODE
    end

    it 'makes a comparison' do
      expect(KaiserRuby.transpile(if_block)).to eq <<~RESULT
        if @tommy != 0.0
          puts "Nobody"
        end
      RESULT
    end
  end

  context 'greater than' do
    let(:if_block) do
      <<~CODE
        If Tommy is higher than nobody
        Shout "Nobody"
      CODE
    end

    it 'makes a comparison' do
      expect(KaiserRuby.transpile(if_block)).to eq <<~RESULT
        if @tommy > 0.0
          puts "Nobody"
        end
      RESULT
    end
  end

  context 'greater than or equal' do
    let(:if_block) do
      <<~CODE
        If Tommy is as high as nobody
        Shout "Nobody"
      CODE
    end

    it 'makes a comparison' do
      expect(KaiserRuby.transpile(if_block)).to eq <<~RESULT
        if @tommy >= 0.0
          puts "Nobody"
        end
      RESULT
    end
  end

  context 'less than' do
    let(:if_block) do
      <<~CODE
        If Tommy is smaller than nobody
        Shout "Nobody"
      CODE
    end

    it 'makes a comparison' do
      expect(KaiserRuby.transpile(if_block)).to eq <<~RESULT
        if @tommy < 0.0
          puts "Nobody"
        end
      RESULT
    end
  end

  context 'less than or equal' do
    let(:if_block) do
      <<~CODE
        If Tommy is as small as nobody
        Shout "Nobody"
      CODE
    end

    it 'makes a comparison' do
      expect(KaiserRuby.transpile(if_block)).to eq <<~RESULT
        if @tommy <= 0.0
          puts "Nobody"
        end
      RESULT
    end
  end
end
