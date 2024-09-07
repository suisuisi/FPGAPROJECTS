#ifndef CRC_H_
#define CRC_H_

#include <stddef.h>
#include <stdint.h>

enum {
    CRC16_InitValue = 0xffff,
};

uint16_t crc16_update( void const* pdata, size_t len, uint16_t crc);


static inline uint16_t crc16_updateWithByte( uint8_t data, uint16_t crc) {
    return crc16_update( &data, 1, crc);
}

static inline uint16_t crc16_blockcalc( void const* pdata, size_t len) {
    return crc16_update( pdata, len, CRC16_InitValue);
}

uint16_t crc16_updateWithWord(uint16_t data, uint16_t crc);

uint16_t crc16_updateWithDoubleWord(uint32_t data, uint16_t crc);

#endif /* CRC_H_ */
