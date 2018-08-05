# TODO notes for KaiserRuby transpiler

## Language Implementation

- [ ] Handle pronouns - he, she, it, and others should refer to the last used variable
- [ ] Handle "Janie's got a gun"
- [ ] Ignore comments in parentheses
- [ ] Handle object type
- [ ] Handle input from STDIN
- [ ] Function calls can be used as expressions in flow statements
- [ ] Handle ',' instead of 'and' in function calls
- [ ] Somehow handle function variable scope

## Examples

- [ ] Should be able to run the [Cellular Rockomata](https://github.com/Rifhutch/cellular-rocktomata)
- [ ] Fibonacci example https://github.com/dylanbeattie/rockstar/issues/94#issuecomment-408217504
- [ ] Math module https://gist.github.com/wrenoud/6be6f7509c88a3d8f9867ae782fb768f
- [ ] Primality checker https://www.reddit.com/r/RockstarDevs/comments/92i6sm/primality_checker_in_rockstar/
- [ ] Make a demo command in the CLI that runs all examples (would that even work as a gem? it should be doable somehow)

## Other stuff

- [ ] Fix indenting of nested blocks that doesn't really work well
- [ ] Add code history to the REPL
- [ ] Make REPL work with multiline input also, not only singular lines
- [ ] Better error handling
- [ ] Suppress warnign about eval from Thor