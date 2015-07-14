# Japalisp
Japanese Programming Language as natural as possible.
Its Github Page is [here](https://kenzan100.github.io/japalisp).

# Why I made this
I wanted Japanese non-programmers (my friends) to realize that "thinking about computing is one of the most exciting things the human mind can do (from The Little Schemer)".
Also, I wanted to explain the beauty of the Japanese language to non-Japanese programmers :)

# What it does
* If you're familiar with the book [The Little Schemer](https://mitpress.mit.edu/index.php?q=books/little-schemer),
  most functions in Chapter 4 "Numbers Games" will work if you can define them properly.
  meaning you can:

  * define function
  * call funcation
  * do basic numeric calculations (using its underlying language)

# How to use it
Currently, I used Ruby and Javascript to implement its interpreter.

## Ruby version
There's `japalisp` bash script, please feed `example.jpl` to see what it's like(`./japalisp example.jpl`).
If you want to contribute to its implementation, please look into `ruby` directory.

## Javascript version
Under `public/js` directory, there's `jexer.js` which tokenizes code, and `japalisp.js` which interprets the tokens.
Also, [REPL in Github Page](https://kenzan100.github.io/japalisp/repl.html) is using this version.
