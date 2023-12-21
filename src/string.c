#include "string.h"
#include "assert.h"

usize strnlen(char const * const s, usize max, bool *err) {
    if (err != NULL) *err = false;
    usize l = 0;

    while (s[l] != '\0') {
        if (l == max) {
            if (err != NULL) *err = true;
            return max;
        }

        l += 1;
    }

    return l;
}

usize strlen(char const * const s) {
    bool e;
    usize l = strnlen(s, USIZE_MAX, &e);
    assert(e == false);
    return l;
}
