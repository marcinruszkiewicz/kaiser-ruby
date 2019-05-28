[![Build Status](https://travis-ci.com/marcinruszkiewicz/kaiser-ruby.svg?branch=master)](https://travis-ci.com/marcinruszkiewicz/kaiser-ruby)
[![Gem Version](https://badge.fury.io/rb/kaiser-ruby.svg)](https://badge.fury.io/rb/kaiser-ruby)

# KaiserRuby - a Rockstar to Ruby transpiler

This tool translates a file containing a program written in the [Rockstar language](https://github.com/dylanbeattie/rockstar) to Ruby code.

As of version 0.7, Kaiser-Ruby implements all of the Rockstar language spec and further versions will keep up with new language features as they are added.

For details on what is done and what I'm still working on, see the TODO.md and CHANGELOG.md files.

## Installation

Install the gem by issuing the following command.

```
$ gem install kaiser-ruby
```

This gem works best on a current Ruby version and requires Ruby 2.3 at minimum. Running it on 2.3 has the downside of metal umlauts not being entirely correct as that Ruby version doesn't know how to `.downcase` a capital umlaut letter, which was fixed in 2.4.

If you're not using the umlauts (or at least are careful to only replace lowercase letters with them), all should be fine otherwise.

## Usage

The most common usage of this gem is to transpile (or transpile and run immediately) Rockstar code into Ruby code.

This gem provides a commandline tool for you to use:

```
$ kaiser-ruby
```

There are a few ways you can use it. First one will just output the result of the transpilation.

```
$ kaiser-ruby transpile ./examples/simple.rock
@tommy = 15.0
puts @tommy

if "".to_bool
  puts "empty strings are false"
end

```

The `--show-source` flag will output the Rockstar code along with the resulting Ruby code like this:

```
$ kaiser-ruby transpile ./examples/simple.rock --show-source
Tommy is a rebel
Shout Tommy

if ""
Shout "empty strings are false"
----------------------------------------
@tommy = 15.0
puts @tommy

if "".to_bool
  puts "empty strings are false"
end

```

You can also use the `--save=FILE` option to write the resulting transpiled code as a file instead of outputting it.

```
$ kaiser-ruby transpile ./examples/simple.rock --save=simple.rb
Saved output in `simple.rb`

```

The saved output will have a few additional lines at the start that include the language changes necessary for Rockstar to work correctly. You need the gem installed to run this file:

```
$ ruby simple.rb
15.0

```

Another option is to run an interactive console (REPL):

```
$ kaiser-ruby rock --debug
Type 'exit' to exit the console. Otherwise, rock on!
\m/> Put "Hello San Francisco" into the message
\m/> @the_message = "Hello San Francisco"
  => Hello San Francisco
\m/> Scream the message
\m/> puts @the_message
Hello San Francisco
  => nil
\m/> exit
$
```

Finally, you can also transpile and immediately execute the code, like this:

```
$ kaiser-ruby execute ./examples/simple.rock
15

```

Or even better, this:

```
$ kaiser-ruby execute ./examples/fibonacci.rock
1.0
1.0
2.0
3.0
5.0
8.0
13.0
21.0
34.0
55.0
89.0
144.0
233.0
377.0
610.0
987.0
1597.0
2584.0
4181.0
6765.0
10946.0
17711.0
28657.0
46368.0

$
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/marcinruszkiewicz/kaiser-ruby. I'm also available for questions at the [Rockstar Developers Discord Group](https://discord.gg/kEUe5bM)

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
