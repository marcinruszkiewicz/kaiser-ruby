# TODO notes for KaiserRuby transpiler

## Variables

- [ ] Handle pronouns - he, she, it, and others should refer to the last used variable
- [ ] Handle "Janie's got a gun"

## Types

- [x] Handle null type differently - nil in Ruby isn't really comparable to 0
- [x] Handle mysterious type - probably this should be nil and what is now nil should be 0 instead
- [ ] Handle object type

## Comparisons

- [x] Handle gt, gte, lt, lte comparisons
- [x] Handle negation

## Input

- [ ] Handle input from STDIN

## Flow Control

- [x] While loop
- [x] Until loop
- [x] Break and continue
- [x] And/Or keywords for conditionals

## Functions

- [ ] Define functions
- [ ] Handle function calls

## Examples

- [x] FizzBuzz example (should also be in tests to check if it runs)
- [ ] Should be able to run the [Cellular Rockomata](https://github.com/Rifhutch/cellular-rocktomata)
- [ ] Fibonacci example https://github.com/dylanbeattie/rockstar/issues/94#issuecomment-408217504
- [ ] Math module https://gist.github.com/wrenoud/6be6f7509c88a3d8f9867ae782fb768f
- [ ] Primality checker https://www.reddit.com/r/RockstarDevs/comments/92i6sm/primality_checker_in_rockstar/

- [ ] Make a demo command in the CLI that runs all examples (would that even work as a gem? it should be doable somehow)

## Other stuff

- [x] Test if it handles metal umlauts (Ruby shouldn't care much, but tests should be made)
- [ ] Ignore comments in parentheses

- [x] Nicely indent blocks
- [ ] Fix indenting of nested blocks that doesn't really work well

- [x] Working basic REPL
- [ ] Add code history to the REPL
- [ ] Make REPL work with multiline input also, not only singular lines

- [ ] Better error handling