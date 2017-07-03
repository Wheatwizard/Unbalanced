# Unbalanced

Unbalanced is a language about mismatching parentheses.  The goal of Unbalanced is to create a programming language where only parentheses matter and balanced parentheses do nothing.

# Usage

The Unbalance is written in Haskell and can be compiled with

    ghc Unbalanced.hs

Once compiled it can be run with

    Unbalanced [options] source_file args...

Run `Unbalanced -h` for more information

# The language

## Memory

Unbalanced uses an infinite tape for its memory,  each cell is unbounded and defaults to zero.  At the beginning and end of execution zeros are trimmed from the ends of the tape.

Unbalanced has a single read / write head, that starts at the last input.  For example if we input "String" the read / write head would start at 'g'

    String
         ^

## Commands

 - `(` decrements the current cell

 - `)` increments the current cell

 - `<` moves the read head left

 - `>` moves the read head right

 - `[` switches the current cell with the cell to its left, moves the ip left 

 - `]` switches the current cell with the cell to its right, moves the ip right

 - `{...}` constitutes a loop

## Loops

When a loop is entered it remembers the value at the read head.  It will then perform the inside of the loop until the value at the read head is the same as the rembered one.
Every loop will execute the contents a minimum of once.  If you are familiar with Stack Cats you may notice that this behavior is lifted directly from Stack Cats.

Unbalanced has implicit loop closure.  This means that if the interpreter cannot find a match to a `{` or `}` it will place one to match it at the beginning or end of the code.
For example

    >>}((([)

is the same as 

   {>>}((([)

and 

    (>(]]{((

is the same as 

    (>(]]{((}
