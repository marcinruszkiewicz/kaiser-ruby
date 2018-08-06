# KaiserRuby - a Rockstar to Ruby transpiler

This tool translates a file containing a program written in the [Rockstar language](https://github.com/dylanbeattie/rockstar) to Ruby code.

This is still a work in progress, however most of the language implementation is already finished and working (as are the fibonacci sequence and fizzbuzz examples in the repository). For details on what is done, see the TODO.md and CHANGELOG.md files.

## Installation

Install the gem by issuing the following command.

```
$ gem install kaiser-ruby
```

## Usage

The most common usage of this gem is to transpile (or transpile and run immediately) Rockstar code into Ruby code.

This gem provides a commandline tool for you to use:

```
$ kaiser-ruby
```

There are a few ways you can use it. First one will just output the result of the transpilation.

```
$ kaiser-ruby transpile ./examples/assignment.rock
tommy = 15
puts tommy

```

The `--show-source` flag will output the Rockstar code along with the resulting Ruby code like this:

```
$ kaiser-ruby transpile ./examples/assignment.rock --show-source
Tommy is a rebel
Shout Tommy
----------------------------------------
tommy = 15
puts tommy

```

You can also use the `--save=FILE` option to write the resulting transpiled code as a file instead of outputting it:

```
$ kaiser-ruby transpile ./examples/assignment.rock --save=a.rb
Saved output in `a.rb`

```

Another option is to run an interactive console (REPL):

```
$ kaiser-ruby rock --debug
Type 'exit' to exit the console. Otherwise, rock on!
\m/> Put "Hello San Francisco" into the message
\m/> the_message = "Hello San Francisco"
  => Hello San Francisco
\m/> Scream the message
\m/> puts the_message
Hello San Francisco
  => nil
\m/> exit
$
```

Finally, you can also transpile and immediately execute the code, like this:

```
$ kaiser-ruby execute ./examples/assignment.rock
15

```

Or even better, this:

```
$ kaiser-ruby execute ./examples/fibonacci.rock
1
1
2
3
5
8
13
21
34
55
89
144
233
377
610
987
1597
2584
4181
6765
10946
17711
28657
46368

$
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/marcinruszkiewicz/kaiser-ruby.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
