# KaiserRuby - a Rockstar to Ruby transpiler

This tool translates a file containing a program written in the [Rockstar language](https://github.com/dylanbeattie/rockstar) to Ruby code.

This is still a work in progress. For details on that, see the TODO.md file.

## Installation

Install the gem by issuing the following command.

    $ gem install kaiser-ruby

## Usage

The most common usage of this gem is to transpile (or transpile and run immediately) Rockstar code into Ruby code.

This gem provides a commandline tool for you to use:

    $ kaiser-ruby

There are a few ways you can use it. First one will just output the result of the transpilation.

```
$ kaiser-ruby transpile ./examples/assignment.rock
tommy = 15
puts tommy

```

The `--show-source` flag will output the Rockstar code along with the resulting Ruby code like this:

This will have a following output:

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

Finally, you can also transpile and immediately execute the code, like this:

```
$ kaiser-ruby execute ./examples/assignment.rock
15

```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/marcinruszkiewicz/kaiser-ruby.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
