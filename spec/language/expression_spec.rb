RSpec.describe KaiserRuby do
  context 'increment expression' do
    it 'increments a common variable' do
      expect(KaiserRuby.transpile('Build my world up')).to eq 'my_world += 1'
    end

    it 'increments a proper variable' do
      expect(KaiserRuby.transpile('Build Best City up')).to eq 'Best_City += 1'
    end
  end

  context 'decrement expression' do
    it 'decrements a common variable' do
      expect(KaiserRuby.transpile('Knock the walls down')).to eq 'the_walls -= 1'
    end

    it 'decrements a proper variable' do
      expect(KaiserRuby.transpile('Knock London Bridge down')).to eq 'London_Bridge -= 1'
    end
  end

  context 'addition expression' do
    it 'adds two values' do
      expect(KaiserRuby.transpile('Say 3 with 4')).to eq 'puts 3.0 + 4.0'
    end

    it 'adds two variables' do
      expect(KaiserRuby.transpile('Say Universe plus my love')).to eq 'puts Universe + my_love'
      expect(KaiserRuby.transpile('Say My world with my love')).to eq 'puts my_world + my_love'
    end

    it 'adds a value to a variable' do
      expect(KaiserRuby.transpile('Say You with "my axe"')).to eq 'puts You + "my axe"'
    end
  end

  context 'subtraction expression' do
    it 'subtracts two values' do
      expect(KaiserRuby.transpile('Say 3 without 4')).to eq 'puts 3.0 - 4.0'
    end

    it 'subtracts two variables' do
      expect(KaiserRuby.transpile('Say My world without my love')).to eq 'puts my_world - my_love'
    end

    it 'subtracts a value from a variable' do
      expect(KaiserRuby.transpile('Say You without "my axe"')).to eq 'puts You - "my axe"'
    end
  end

  context 'division expression' do
    it 'divides two values' do
      expect(KaiserRuby.transpile('Say 3 over 4')).to eq 'puts 3.0 / 4.0'
    end

    it 'divides two variables' do
      expect(KaiserRuby.transpile('Say My world over my love')).to eq 'puts my_world / my_love'
    end

    it 'divides a value to a variable' do
      expect(KaiserRuby.transpile('Say You over "my axe"')).to eq 'puts You / "my axe"'
    end
  end

  context 'multiplication expression' do
    it 'multiplicates two values' do
      expect(KaiserRuby.transpile('Say 3 times 4')).to eq 'puts 3.0 * 4.0'
    end

    it 'multiplicates two variables' do
      expect(KaiserRuby.transpile('Say Universe of my love')).to eq 'puts Universe * my_love'
      expect(KaiserRuby.transpile('Say My world times my love')).to eq 'puts my_world * my_love'
    end

    it 'multiplicates a value with a variable' do
      expect(KaiserRuby.transpile('Say Your head of "my axe"')).to eq 'puts your_head * "my axe"'
    end
  end
end