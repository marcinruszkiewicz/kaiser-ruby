# 0.1

- Initial implementation of the Rockstar Language based using `Parslet::Parser`

# 0.2

- Rewrote the `KaiserRuby::RockstarParser` and `KaiserRuby::RockstarTransform` from scratch
- basic CLI and REPL
- Metal umlauts
- Most variable types, assignmnents, output, conditionals are working.

# 0.3

- Switched null and mysterious types around - mysterious is now nil and 'null' is just 0 as it should be.
- All flow control statements are working correctly.
- Added comments to resulting ruby code flow control statements, so it's easier to see where what ends. This should help making the code more readable (and easier to figure out if it's actually correct), at least while the indentation feature is not fully working yet.

- Functions are working and callable
- Pronouns are handled correctly

# 0.4

- Input from STDIN is handled correctly
- Object type is working
- All examples should be running correctly