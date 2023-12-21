#include <stdio.h>
#include "types.h"

i32 main(i32 argc, char *argv[]) {
    void *_;
    _ = &_;

    _ = &argc;
    _ = &argv;

    printf("Hello!\n");
}
