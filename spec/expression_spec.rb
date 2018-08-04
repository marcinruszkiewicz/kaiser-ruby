RSpec.describe KaiserRuby do
  context 'basic assigmnent expression' do
    it 'assigns string to a common variable' do
      expect(KaiserRuby.transpile('Put "Hello World" into your soul')).to eq 'your_soul = "Hello World"'
    end

    it 'assigns number to a common variable' do
      expect(KaiserRuby.transpile('Put 3.14 into X')).to eq 'x = 3.14'
    end

    it 'assigns an expression to a variable' do
      expect(KaiserRuby.transpile('Put the whole of your heart into my hands')).to eq 'my_hands = the_whole * your_heart'
    end

    it 'assigns a returned value to a variable' do
      expect(KaiserRuby.transpile('Put Midnight taking Dreams into my hands')).to eq 'my_hands = midnight(dreams)'
    end
  end

  context 'increment expression' do
    it 'increments a common variable' do
      expect(KaiserRuby.transpile('Build my world up')).to eq 'my_world += 1'
    end

    it 'increments a proper variable' do
      expect(KaiserRuby.transpile('Build Best City up')).to eq 'best_city += 1'
    end
  end

  context 'decrement expression' do
    it 'decrements a common variable' do
      expect(KaiserRuby.transpile('Knock the walls down')).to eq 'the_walls -= 1'
    end

    it 'decrements a proper variable' do
      expect(KaiserRuby.transpile('Knock London Bridge down')).to eq 'london_bridge -= 1'
    end
  end

  context 'addition expression' do
    it 'adds two values' do
      expect(KaiserRuby.transpile('3 with 4')).to eq '3 + 4'
    end

    it 'adds two variables' do
      expect(KaiserRuby.transpile('Universe plus my love')).to eq 'universe + my_love'
      expect(KaiserRuby.transpile('My world with my love')).to eq 'my_world + my_love'
    end

    it 'adds a value to a variable' do
      expect(KaiserRuby.transpile('You with "my axe"')).to eq 'you + "my axe"'
    end
  end

  context 'subtraction expression' do
    it 'subtracts two values' do
      expect(KaiserRuby.transpile('3 without 4')).to eq '3 - 4'
    end

    it 'subtracts two variables' do
      expect(KaiserRuby.transpile('Universe minus mysterious')).to eq 'universe - nil'
      expect(KaiserRuby.transpile('My world without my love')).to eq 'my_world - my_love'
    end

    it 'subtracts a value from a variable' do
      expect(KaiserRuby.transpile('You without "my axe"')).to eq 'you - "my axe"'
    end
  end

  context 'division expression' do
    it 'divides two values' do
      expect(KaiserRuby.transpile('3 over 4')).to eq '3 / 4'
    end

    it 'divides two variables' do
      expect(KaiserRuby.transpile('My world over my love')).to eq 'my_world / my_love'
    end

    it 'divides a value to a variable' do
      expect(KaiserRuby.transpile('You over "my axe"')).to eq 'you / "my axe"'
    end
  end

  context 'multiplication expression' do
    it 'multiplicates two values' do
      expect(KaiserRuby.transpile('3 times 4')).to eq '3 * 4'
    end

    it 'multiplicates two variables' do
      expect(KaiserRuby.transpile('Universe of my love')).to eq 'universe * my_love'
      expect(KaiserRuby.transpile('My world times my love')).to eq 'my_world * my_love'
    end

    it 'multiplicates a value with a variable' do
      expect(KaiserRuby.transpile('Your head of "my axe"')).to eq 'your_head * "my axe"'
    end
  end
end