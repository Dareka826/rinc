#ifndef __TYPES_H_hdbo3kI5Z6LF57I8
#define __TYPES_H_hdbo3kI5Z6LF57I8

#include <stdint.h>
#include <stdbool.h>
#include <stddef.h>
#include <sys/types.h>

// Integers
typedef uint8_t  u8;
typedef uint16_t u16;
typedef uint32_t u32;

typedef  int8_t  i8;
typedef  int16_t i16;
typedef  int32_t i32;

#define U8_MAX  UINT8_MAX
#define U16_MAX UINT16_MAX
#define U32_MAX UINT32_MAX

#define I8_MIN   INT8_MIN
#define I16_MIN  INT16_MIN
#define I32_MIN  INT32_MIN

#define I8_MAX   INT8_MAX
#define I16_MAX  INT16_MAX
#define I32_MAX  INT32_MAX

// Floating point
typedef float f32;
typedef double f64;

// Size integers
typedef  size_t usize;
typedef ssize_t isize;

#define USIZE_MAX SIZE_MAX
#define ISIZE_MIN -1
#define ISIZE_MAX SSIZE_MAX

#endif
