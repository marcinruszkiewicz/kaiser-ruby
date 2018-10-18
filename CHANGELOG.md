# 0.7

Language Implementation

- [x] Full language implementation according to the spec

- [x] Added forgotten `break` and `continue` keywords
- [x] STDIN input now converts to Float or Integer as expected
- [x] Fixed indenting of nested blocks, deep nesting works too
- [x] Variables are scoped properly if you declare them before a function
- [x] Handle ',' and 'and' in function calls together with precedence of &&
- [x] Function calls should work with `, `, `, and`, `'n'` and `&` as argument separators. `and` without the comma is deprecated.
- [x] Poetic assignment works with string and number literals
- [x] All numbers are represented as floats
- [x] Implement refinements to make math operations and comparisons work properly
- [x] Handle NOT operator
- [x] Handle NOR operation
- [x] Handle equality
- [x] `Listen` should just wait for user input and do nothing with it
- [x] Multiple increments/decrements with `build X up, up up` and `knock Y down, down, down`
- [x] Handle global variables if they're declared after function definition that uses them

Other

- [x] Replaced parsing with Parslet with a hand-written parser in plain Ruby
- [x] Implemented reference tests
- [x] Handle testing STDIN in RSpec tests
- [x] CLI command reports which version it is
- [x] Updated README with new examples and info
- [x] Automatically adds require and using line to saved ruby file output

# 0.6 - unreleased

- [x] Fixed error in input from STDIN
- [x] The transpiler now throws a SyntaxError instead of Parslet exception

Test Suite

- [x] Refactored the test suite to make more sense
- [x] Added a ton of new negative and positive tests

# 0.5

- [x] Fixed converting decimals so "Conversion is lovestruck. lovestruck and essential seasick" results in "conversion = 0.0397" as one would expect.

Other stuff

- [x] Updated the REPL to work on Ruby versions earlier than 2.5 (2.3 is the minimum supported version)
- [x] Travis CI tests on all supported Ruby versions

# 0.4

Language Implementation:

- [x] Handle non-alpha values in quoted strings
- [x] Ignore comments in parentheses
- [x] Handle input from STDIN
- [x] Handle contractions - "Janie's got a gun" should be expanded to "Janie is got a gun" and so it should transpile to "janie = 313"
- [x] Handle pronouns - he, she, it, and others should refer to the last used variable
- [x] Better handle input of integers from STDIN
- [x] Print can print returned values from functions

Other stuff:

- [x] Updated the FizzBuzz example
- [x] Catch exceptions in the REPL
- [x] Suppressed warning about eval from Thor
- [x] Move nesting indentation from main module to transformer
- [x] Celsius to Fahrenheit example

# 0.3

Language Implementation:

- [x] Handle null type differently - nil in Ruby isn't really comparable to 0
- [x] Handle mysterious type - probably this should be nil and what is now nil should be 0 instead
- [x] Handle gt, gte, lt, lte comparisons
- [x] Handle inequality
- [x] While loop
- [x] Until loop
- [x] Break and continue
- [x] And/Or keywords for conditionals
- [x] Define functions
- [x] Handle function calls
- [x] Return can return math operations directly

Other stuff:

- [x] FizzBuzz example is working
- [x] Fibonacci example is working
- [x] Added comments to resulting ruby code flow control statements, so it's easier to see where what ends. This should help making the code more readable (and easier to figure out if it's actually correct), at least while the indentation feature is not fully working yet.

# 0.2

- [x] Rewrote the Parser and Transform classes from scratch
- [x] basic CLI and REPL
- [x] Metal umlauts
- [x] Most variable types, assignmnents, output, conditionals are working.

# 0.1

- [x] Initial implementation of the Rockstar Language based using `Parslet::Parser`
