# TODO notes for KaiserRuby transpiler

# 0.9

Language implementation

- [ ] Support for lists
- [ ] Support executing treesort.rock - nested functions are actually objects, so if they get passed around to
      other functions they need to be called using `.call()` not `name()`... or just `.call` everything so
      it's easier.


# Other stuff

Examples

- [ ] Should be able to run the [Cellular Rockomata](https://github.com/Rifhutch/cellular-rocktomata)
- [ ] Math module https://gist.github.com/wrenoud/6be6f7509c88a3d8f9867ae782fb768f
- [ ] Add code history to the REPL
- [ ] Make REPL work with multiline input also, not only singular lines
- [ ] Make a demo visitor that evals the code and waits a bit between commands, so it's more music video-ish.
      Maybe should change the console colors while at it?
