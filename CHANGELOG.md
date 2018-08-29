# 0.1

- [x] Initial implementation of the Rockstar Language based using `Parslet::Parser`

# 0.2

- [x] Rewrote the Parser and Transform classes from scratch
- [x] basic CLI and REPL
- [x] Metal umlauts
- [x] Most variable types, assignmnents, output, conditionals are working.

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

0.5

Other stuff

- [x] Updated the REPL to work on Ruby versions earlier than 2.5 (2.3 is the minimum supported version)
- [x] Travis CI tests on all supported Ruby versions
