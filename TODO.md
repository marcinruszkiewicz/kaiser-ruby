# TODO notes for KaiserRuby transpiler

## Language Implementation

- [ ] Function calls can be used as expressions in flow statements
- [ ] Handle ',' instead of 'and' in function calls

- [ ] Somehow handle function variable scope
- [ ] Handle object type

## Examples

- [ ] Should be able to run the [Cellular Rockomata](https://github.com/Rifhutch/cellular-rocktomata)
- [ ] Math module https://gist.github.com/wrenoud/6be6f7509c88a3d8f9867ae782fb768f
- [ ] Primality checker https://www.reddit.com/r/RockstarDevs/comments/92i6sm/primality_checker_in_rockstar/
- [ ] Make a demo command in the CLI that runs all examples (would that even work as a gem? it should be doable somehow)

## Other stuff

- [ ] Fix indenting of nested blocks that doesn't really work well (this should also help deeper nesting)
- [ ] Add code history to the REPL
- [ ] Make REPL work with multiline input also, not only singular lines
- [ ] Make a demo visitor that evals the code and waits a bit between commands, so it's more music video-ish. Maybe should change the console colors while at it?
