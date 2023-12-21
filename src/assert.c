#include "assert.h"
#include <stdlib.h>

void assert(bool expr) {
    if (expr == false)
        exit(EXIT_FAILURE);
}
