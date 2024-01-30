#!/usr/bin/perl

# C99, but:
# - different type syntax
# - generics
# - short types (u8, u16, u32, i32, etc.)
# - nullable/optional type
# - utf8 strings
# - local functions
# - local structs

# types syntax:
#   C99:
#     int *x[];
#   RC:
#     x: []*int;

sub strchr {
    my ($str, $idx) = @_;
    return substr($str, $idx, 1);
}

# 1. Lexer
sub tokenize {
    my $data = shift(@_);
    my @tokens = ();

    my $idx = 0;
    my $data_len = length($data);

    while ($idx < $data_len) {
        my $c = strchr($data, $idx);
        # TODO: Lexing

        # Macro: from # until unescaped newline

        $idx += 1;
    }

    return \@tokens;
}

tokenize(<<"EOF");

#include <stdio.h>
#include "test.h"

typedef uint32_t u32;

fn main(argc: int, argv: []*char) int {
    x: int = 10;
    y: int;

    printf("abc");

    x = 20;
    return 0;
}
EOF

exit(0);

# 2. Parser

# 3. Code generation
