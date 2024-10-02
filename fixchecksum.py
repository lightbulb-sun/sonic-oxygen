import sys
import struct

filename_in = sys.argv[1]
filename_out = sys.argv[2]

CHECKSUM_OFFSET = 0x18e

with open(filename_in, 'rb') as inf:
    rom = inf.read()

total = 0
for (word, ) in struct.iter_unpack('>H', rom[0x200:]):
    total += word

total &= 0xffff
print(f'Writing checksum 0x{total:04x} at offset 0x{CHECKSUM_OFFSET:04x} to file {filename_out}')

rom = rom[:CHECKSUM_OFFSET] + total.to_bytes(2, 'big') + rom[CHECKSUM_OFFSET+2:]

with open(filename_out, 'wb') as outf:
    outf.write(rom)
