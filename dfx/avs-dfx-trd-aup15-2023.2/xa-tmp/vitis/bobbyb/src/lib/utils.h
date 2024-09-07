/*=============================================================================
#
#       Purpose: provides utils.c function prototypes
#
#    Limitation:
#
#          Note:
#
#        Author: Marco Höfle
#                marco.hoefle@avnet.eu
#                +41 78 790 93 62
#
#============================================================================*/
#ifndef UTILS_H_
#define UTILS_H_

#include <stdarg.h>
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>

#define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:-!!(e); }))
#define __same_type(a, b) __builtin_types_compatible_p(typeof(a), typeof(b))
#define __must_be_array(a) BUILD_BUG_ON_ZERO(__same_type((a), &(a)[0]))
#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))

void mdelay( uint32_t ms);
void copy_32bit(uint32_t *dest, const uint32_t *src, size_t len);

bool test_bit(uint32_t y, uint8_t pos);
uint32_t set_bit(uint32_t y, uint8_t pos);
uint32_t clear_bit(uint32_t y, uint8_t pos);
uint32_t toggle_bit(uint32_t y, uint8_t pos);
uint32_t bf_get(uint32_t y, uint8_t shift, uint8_t len);
uint32_t bf_merge(uint32_t y, uint32_t x, uint8_t shift, uint8_t len);

const char * utostr( unsigned int u, int base);
int vsnprtf( char *buf, size_t maxlen, const char *format, va_list va);

#endif /* UTILS_H_ */
