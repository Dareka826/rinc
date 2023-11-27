#!/bin/sh
# \
exec tclsh "${0}" "${@}"

proc with {vars body} {
    foreach var $vars { upvar $var $var }
    eval $body
}

proc sidx {str idx} { string index $str $idx }

# Lexer
proc tokenize {str} {
    # {{{
    set tokens {}

    set i 0
    set l [string length $str]

    set ops [list "<<=" ">>=" "<=" ">=" "==" "!=" "|=" "&=" "^=" "&&" "||" "<" ">" "=" "+" "-" "*" "/" "|" "&" "!" "^"]

    while {$i < $l} {
        set c [sidx $str $i]

        # Macro {{{
        if {$c == "#" && ($i == 0 || [sidx $str [expr {$i - 1}]] == "\n")} {
            set token $c
            incr i

            # Read until unescaped newline
            while {$i < $l} {
                set c [sidx $str $i]

                # Pass escaped chars
                if {$c == "\\"} {
                    if {[expr {$i + 1}] < $l} {
                        set nc [sidx $str [expr {$i + 1}]]
                        if {$nc != "\n"} {
                            append token "$c$nc"
                        }
                        incr i

                    } else { append token $c }

                    incr i
                    continue
                }

                # End
                if {$c == "\n"} { break }

                append token $c
                incr i
            }

            lappend tokens [list "MACRO" $token]
            incr i
            continue
        }
        # }}}

        # Whitespace {{{
        if {$c == " " || $c == "\t" || $c == "\n"} {
            incr i
            continue
        }
        # }}}

        # Special {{{
        if {$c == "{" || $c == "}" || $c == "(" || $c == ")" || \
            $c == "\[" || $c == "\]" || $c == ";" || $c == ":" || \
            $c == "," || $c == "."} {

            lappend tokens [list "SPECIAL" $c]
            incr i
            continue
        }
        # }}}

        # Identifiers {{{
        if {[string is alpha $c] == 1 || $c == "_"} {
            set token $c

            while {$i < $l} {
                set nc [sidx $str [expr {$i + 1}]]

                if {!([string is alnum $nc] == 1 || $c == "_")} { break }

                append token $nc
                incr i
            }

            lappend tokens [list "IDENTIFIER" $token]
            incr i
            continue
        }
        # }}}

        # Numbers {{{
        if {[string is digit $c] == 1 || \
            ($c == "-" && ($i + 1) < $l && \
            [string is digit [sidx $str [expr {$i + 1}]]] == 1)} {

            set token $c

            while {$i < $l} {
                set nc [sidx $str [expr {$i + 1}]]

                if {[string is digit $nc] == 0} { break }

                append token $nc
                incr i
            }

            lappend tokens [list "NUMBER" $token]
            incr i
            continue
        }
        # }}}

        # Strings {{{
        if {$c == "\""} {
            set token {}
            incr i

            # Read until unescaped quote
            while {$i < $l} {
                set c [sidx $str $i]

                # Pass escaped chars
                if {$c == "\\"} {
                    if {[expr {$i + 1}] < $l} {
                        append token "$c[sidx $str [expr {$i + 1}]]"
                        incr i
                    } else { append token $c }

                    incr i
                    continue
                }

                # End
                if {$c == "\""} { break }

                append token $c
                incr i
            }

            lappend tokens [list "STRING" $token]
            incr i
            continue
        }
        # }}}

        # Operators {{{
        set cnt 0
        foreach op $ops {
            set op_i 0
            set op_l [string length $op]

            set match 1
            while {$op_i < $op_l && ($op_i + $i) < $l} {
                if {[sidx $op $op_i] != [sidx $str [expr {$i + $op_i}]]} {
                    set match 0
                    break
                }
                incr op_i
            }
            if {$match == 0} { continue }

            lappend tokens [list "OPERATOR" $op]
            incr i $op_i
            set cnt 1
        }
        if {$cnt == 1} {
            set cnt 0
            continue
        }
        # }}}

        lappend tokens [list "UNKNOWN" $c]
        incr i
    }

    return $tokens
    # }}}
}

proc parse {tokens} {
    puts $tokens
    # [ [rule_name start_idx rule_specific_state_array ] ]
    set stack [list [list "PROG" 0 [llength $tokens] ] ]

    # "return" -> the point after which the tokens are still not parsed
    set new_start 0
    # "return" -> the resulting ast
    set ast_result {}

    # start and end index "pointers" store
    while {[llength $stack] > 0} {
        puts $stack

        # Pop an element from stack
        set current [lindex $stack end]
        set stack [lreplace $stack end end]

        set current_rule  [lindex $current 0]
        set current_start [lindex $current 1]
        set current_end   [lindex $current 2]

        if {$current_rule == "PROG"} {
            # macro
            # var_def
            # func
            set token [lindex $tokens $current_start]

            # Macro
            if {[lindex $token 0] == "MACRO"} {
                lappend stack [list "PROG" [expr {$current_start + 1}] $current_end]
                lappend stack [list "MACRO" $current_start $current_start]

                continue
            }
        }

        exit 1
    }
}

# x: int = 10;
#
# [ [PROG ???] ]
# [ [PROG ???] [VARDEF ???] ]
# [ [PROG ???] [VARDEF ???] [TYPE ???] ]
# [ [PROG ???] [VARDEF ???] [EXPR ???] ]
# [ [PROG ???] [VARDEF ???] ]
# [ [PROG ???] ]
# [ ]

# ==========

puts [parse [list \
        [list "MACRO" "#include <stdio.h>"] \
        [list "IDENTIFIER" "x_var"] \
        [list "SPECIAL" ":"] \
        [list "IDENTIFIER" "int"] \
        [list "SPECIAL" ";"] \
        [list "IDENTIFIER" "y_var"] \
        [list "SPECIAL" ":"] \
        [list "IDENTIFIER" "int"] \
        [list "OPERATOR" "="] \
        [list "NUMBER" "10"] \
        [list "SPECIAL" ";"] \
        [list "IDENTIFIER" "fn"] \
        [list "IDENTIFIER" "main"] \
        [list "SPECIAL" "("] \
        [list "SPECIAL" ")"] \
        [list "IDENTIFIER" "void"] \
        [list "SPECIAL" "{"] \
        [list "SPECIAL" "}"] \
    ]]

exit 0

set fcnt {}

with {fcnt} {
    set fh [open "./test.c" r]
    set fcnt [read $fh]
    close $fh
}

puts [join [tokenize $fcnt] "\n"]
