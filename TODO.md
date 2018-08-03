# TODO notes for KaiserRuby transpiler

## Variables

- [ ] Handle pronouns - he, she, it, and others should refer to the last used variable

## Types

- [ ] Handle null type differently - nil in Ruby isn't really comparable to 0
- [ ] Handle mysterious type - probably this should be nil and what is now nil should be 0 instead
- [ ] Handle object type

## Comparisons

- [ ] Handle gt, gte, lt, lte comparisons
- [ ] Handle negation

## Input

- [ ] Handle input from STDIN

## Flow Control

- [ ] While loop
- [ ] Until loop
- [ ] Break and continue

## Functions

- [ ] Define functions
- [ ] Handle function calls

## Examples

- [ ] FizzBuzz example (should also be in tests to check if it runs)
- [ ] Should be able to run the [Cellular Rockomata](https://github.com/Rifhutch/cellular-rocktomata)
- [ ] Fibonacci example https://github.com/dylanbeattie/rockstar/issues/94#issuecomment-408217504
- [ ] Math module https://gist.github.com/wrenoud/6be6f7509c88a3d8f9867ae782fb768f
- [ ] Primality checker https://www.reddit.com/r/RockstarDevs/comments/92i6sm/primality_checker_in_rockstar/

## Other stuff

- [ ] Test if it handles metal umlauts (Ruby shouldn't care much, but tests should be made)
- [ ] Ignore comments in parentheses