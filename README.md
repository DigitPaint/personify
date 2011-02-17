Personify : personalisation template language
=============================================

Personfify is meant for use in environments where templates just need
to be personalized.

Basic syntax
------------

Alle expressions are wrapped in brackets ([ ]). All code outside
of brackets will not be evaluated.

If the return statement of an expression is nil, it won't be replaced
by it's output.

All whitespace within expressions is ignored.

Simple substitution
-------------------

The simplest use of the personify template language is to just use
the standard substitution expressions. A substitution expression
exists of a key which will be replaced if it's found in the context.

#### Examples:

With context:

    {"key" => "value"}

Example:

    [KEY] => value
    [UNKNOWN] => [UNKNOWN]
    
Substitutions with fallback
--------------------------- 

A more advanced feature is to use fallbacks on missing keys. If a key can't
be found in the context, all alternative keys (separated by a pipe (|))
will be tried until a non-nil value is found. If a the last alternative
returns nil, the original expression won't be replaced.

You can also specify strings as fallbacks, they will always return the string.
See also the note on strings below.


#### Examples: 

With context:

    {"key" => "value"}

Example:
    
    [UNKNOWN | KEY] => value
    [UNKNOWN1 | UNKNOWN2 | "default"] => default
    [UNKNOWN1 | UNKNOWN2 | default] => default
    
Boolean logic
-------------

You can use boolean logic parameters && (and) and || (or) to implement simple logic. The logic can be used
anywhere where you can use a substitution, which means you can use it as a standalone subsitition, within a function
parameter or as an alternative.

**Attention!** We currently do not support operator precedence and parenthesis, the logic will be evaluated
backwards so the statement A && B || C will actually be evaluated as A && (B || C).

#### Examples: 

with context:
    
    {
      "a" => "a",
      "b" => "b",
      "c" => "c",
      "d" => nil
    }
    
Example:

    [A && B] => a
    [A && D | "default"] => default
    
    [A || B] => a
    [B || A] => b
    [D || A] => a
    
    [A && B || C] => a
    [A && D || C] => c
    
    [A || B && C] => a
    [D || B && C || "default"] => default


Function calls
--------------

For more flexibility, it is possible to put functions in
the context by means of lamda's and procs. However you need to be very
carefull with accepting parameters as Personify will just splat all
parameters into the proc's call method. If an expected function
doesn't respond to a call method, it just works like a normal substitution.

### Simple Syntax

#### Examples:

With context:

    {
      "key1" => "v1", 
      "key2" => "v2" 
      "ampersandize" => Proc.new{|*c| c.join(" & ") }
    }

Example:
    
    [AMPERSANDIZE(KEY1,KEY2)] => v1 & v2
    [AMPERSANDIZE(KEY1 , "default")] => v1 & default
    [AMPERSANDIZE("1","2","3")] => 1 & 2 & 3
    [AMPERSANDIZE("1",2,3)] => 1 & 2 & 3    

### Block Syntax

You can also use a block-style syntax with functions. The content of the block will be passed
to the function as the last parameter.

#### Example: Simple function substitution

    [FUN(VAR) DO]
    content passed to the IF fn as last parameter, the whole block will be substituted.
    for example lambda{|var,glob| var > 1 ? glob : "" }
    [END]

#### Example: Function as alternative

    [FIRST | FUN() DO]
    if FIRST is available do that, if not pass this text to FUN() call.
    Always replace this text.
    [END]

#### Example: Function as an alternative with a fallback string

    [FIRST | FUN() DO]
    First check FIRST, then try to call the FUN with this content, as a last resort use the 
    fallback string
    [END | "fallback"]

#### Example: Function as an alternative with another function as fallback

    [FUN() DO]
    Pass this to FUN and if it returns non false/nil we show the return value
    [END | FUN2() DO]
    If FUN() return a false/nil value we pass this to FUN2() and show it's return value
    [END]


Strings
-------

Strings can be used either as parameters for a function or in an expression
as an alternative. Strings don't necessarily need to be quoted as long
as they don't contain any of these characters: "]),|

Strings cannot ever contain double qoutes (").


Copyright
---------
Copyright (c) 2011 Digitpaint, Flurin Egger. See LICENSE for details.