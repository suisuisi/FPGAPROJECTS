/*=============================================================================
#
#       Purpose: provides general helper functions used within this application
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
#include <stdlib.h>
#include <string.h>

#include "utils.h"


#define BIT(n)                  ( 1<<(n) )
#define BIT_MASK(len)           ( BIT(len)-1 )


inline bool test_bit(uint32_t y, uint8_t pos)
{
	return (bool)(y & BIT(pos));
}

inline uint32_t set_bit(uint32_t y, uint8_t pos)
{
	return (y | BIT(pos));
}

inline uint32_t clear_bit(uint32_t y, uint8_t pos)
{
	return (y & ~(BIT(pos)));
}

inline uint32_t toggle_bit(uint32_t y, uint8_t pos)
{
	return (y ^ BIT(pos));
}

/**
* extracts a bit field.
* @param y the original value
* @param shift the bit position were the bit field starts
* @param len the bit filed size in bits
* @return extracted bit field
*/
inline uint32_t bf_get(uint32_t y, uint8_t shift, uint8_t len)
{
	return (y>>shift) & BIT_MASK(len);
}


/**
* merges a bit field into a value
* @param y the destination
* @param x contains the bitfield
* @param shift the bit position were the bit field starts
* @param len the bit filed size in bits
* @return the merged value
*/
inline uint32_t bf_merge(uint32_t y, uint32_t x, uint8_t shift, uint8_t len)
{
	uint32_t mask = BIT_MASK(len);
	return (y &~ (mask<<shift)) | (x & mask)<<shift;
}


/**
* only 32bit accesses can be made via the current AXI - BRAM connection.
* The standard C function memcpy() might not work correctly.
*/
void copy_32bit(uint32_t *dest, const uint32_t *src, size_t len)
{
	while(len--)
	{
		*dest++=*src++;
	}
}




/**
 * Slim signed integer to string function. Attention: could lead to buffer overflow!
 * @param i integer value
 * @param base base
 * @return pointer to string
 */
static const char * itostr( int i, int base)
{
	static char buf[16];
	char *p = buf;

	if (i==0) {
		*p++ = '0';
		*p = 0;
		return buf;
	}

	if (i<0) {
		i = -i;
		*p++ = '-';
	}

	int j=i;
	while( j) {
		*p++ = '0';
		j /= base;
	}

	*p = 0;
	while (i) {
		char c = i % base;
		if (c < 10) {
			*--p = '0' + c;
		} else {
			*--p = 'A' + c - 10;
		}
		i /= base;
	}
	return buf;
}


/**
 * Slim unsigned integer to string function. Attention: could lead to buffer overflow!
 * @param i integer value
 * @param base base
 * @return pointer to string
 */
const char * utostr( unsigned int u, int base)
{
	static char buf[16];
	char *p = buf;

	if (u==0) {
		*p++ = '0';
		*p = 0;
		return buf;
	}

	unsigned int j=u;
	while( j) {
		*p++ = '0';
		j /= base;
	}

	*p = 0;
	while (u) {
		char c = u % base;
		if (c < 10) {
			*--p = '0' + c;
		} else {
			*--p = 'A' + c - 10;
		}
		u /= base;
	}
	return buf;
}


/**
 * Slim unsigned double to string function. Attention: could lead to buffer overflow!
 * @param d double float value
 * @return pointer to string
 */
static const char *dtostr( double d)
{
	int i;
	char *b = (char*)itostr( (int)d, 10);
	char *p = b + strlen( b);
	*p++ = '.';
	for( i=0; i<4; i++) {
		d = d - (int)d;
		d *= 10;
		*p++ = '0' + (int)d;
	}
	*p = 0;
	return b;
}


/**
 * slim vsnpritf like function.
 * Composes a string with the same text that would be printed if format was used on printf,
 * but using the elements in the variable argument list identified by arg instead of additional
 * function arguments and storing the resulting content as a C string in the buffer
 * pointed by s (taking maxlen as the maximum buffer capacity to fill).
 * @param *buf Pointer to a buffer where the resulting C-string is stored.
 * 	The buffer should have a size of at least maxlen characters.
 * @param maxlen Maximum number of bytes to be used in the buffer.
 * @param *format C string that contains a format string.
 * @param va A value identifying a variable arguments list initialized with va_start
 * @return The number of characters that would have been written if maxlen
 * 	had been sufficiently large, not counting the terminating null character.
 */
int vsnprtf( char *buf, size_t maxlen, const char *format, va_list va)
{
	char *pt = buf;
	char *pt_end = pt + maxlen;
	int fillzero = 0;
	const char *p;
	int i;
	unsigned int u;
	double d;
	for (p = format; *p != 0; p++) {
		if (*p != '%') {
			*pt++ = *p;
			if (pt == pt_end) {
				return maxlen;
			}
			continue;
		}

		p++;
		int precision = 0;
		int rightalign = 0;
		if (((*p >= '0') && (*p <= '9')) || (*p == '-')) {
			char *endp;
			precision = strtol( p, &endp, 10);
			if (precision < 0) {
				rightalign = 1;
				precision = -precision;
			}
			fillzero = (p[0] == '0');
			p = endp;
		}

		const char *src = NULL;
		switch (*p) {
			case '%':	*pt++ = *p;
						break;
			case 'c':	*pt++ = va_arg( va, int);
						break;
			case 'd':	i = va_arg( va, int);
						src = itostr( i, 10);
						rightalign = !rightalign;
						break;
			case 'u':	u = va_arg( va, unsigned int);
						src = utostr( u, 10);
						rightalign = !rightalign;
						break;
			case 'x':	u = va_arg( va, unsigned int);
						src = utostr( u, 16);
						rightalign = !rightalign;
						break;
			case 'f':	d = va_arg( va, double);
						src = dtostr( d);
						break;
			case 's':	src = va_arg( va, const char *);
						break;
		}
		if (src) {
			int spaces = 0;
			if (precision > 0) {
				spaces = precision - strlen( src);
				if (spaces < 0) {
					spaces = 0;
				}
			}

			if (rightalign) {
				while (spaces-- > 0) {
					*pt++ = fillzero ? '0' : ' ';
					if (pt == pt_end) { return maxlen; }
				}
			}

			while (*src != 0) {
				*pt++ = *src++;
				if (pt == pt_end) { return maxlen; }
			}

			while (spaces-- > 0) {
				*pt++ = fillzero ? '0' : ' ';
				if (pt == pt_end) { return maxlen; }
			}
		}
	}
	*pt = 0;
	return pt - buf;
}


