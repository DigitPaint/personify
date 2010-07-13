Current state
=============

## String
["string"]

## Substitution
[SUBSTITUTE]

## Substitution with alternatives
[SUBSTITUTE | ALT]

## Function with substitution parameters
[FUN(SUBSTITUTE)]

## Function with string parameter
[FUN("string")]

## !? Does this work?
[FUN(1)]


Proposals for block syntax
==========================

[FUN() DO]
passed to function as last parameter
[END]

[START:FUN]
pass to block?
[STOP:FUN]

[FUN<]
[>]

[VAR<]
[>VAR]

[VAR]
[/VAR]

[FUN>
some weird stuff
<]

[SUBSTITUTE | >

<]

[SUBSTITUTE | FUN() >
<]

[FUN()] 
passed to function as last parameter
[/]

[FUN(){
passed to function as last parameter
}]

[VAR{
show text if VAR == true
}]

# Context
{
  :subscriber => {
    :email => "flurin@digitpaint.nl",
    :token => "abcdef",
    :id => 201,
    :newsletters => {
      1 => {
        :frequency => "day"
      },
      5 => {
        :frequency => "day"
      }
    }
  }
}
# /Context

[SUBSCRIBER.EMAIL] #=> "flurin@digitpaint.nl"
[SUBSCRIBER.NEWSLETTER.1.FREQUENCY] #=> "day"

[IF SUBSCRIBER.NEWSLETTER.1]
...
[END]

# Capture content to pass to function
[FUN(VAR) DO]
content passed to the IF fn as last parameter, the whole block will be substituted.
for example lambda{|var,glob| var > 1 ? glob : "" }
[END]

[FIRST | FUN() DO]
if FIRST is available do that, if not pass this text to FUN() call.
Always replace this text.
[END]

[FIRST | FUN() DO]
First check FIRST, then try to call the FUN with this content, as a last resort use the 
fallback string
[END | "fallback"]

[FUN() DO]
Pass this to FUN and if it returns non false/nil we show the return value
[END | FUN2() DO]
If FUN() return a false/nil value we pass this to FUN2() and show it's return value
[END]

[VAR DO]
invalid syntax will not substitue
[END]

# IF as a language construct with ELSIF and ELSE
[IF EXPR1]
if EXPR is true do this
[ELSIF EXPR2]
if EXPR1 is false and EXPR2 is true, do this
[ELSE]
all other cases do this
[END]

COMPARATORS

A == "b"
A > 1
A < 1
A <= 1
A >= 1
FN(A) == true 



[IF(VAR){

[} ELSE {]

[}]
