FILENAME = 'o2lut.bin'
MAX_O2 = 30

result = bytearray()

def char_to_byte(c):
    if c == ' ':
        return 0xff
    return int(c)

def string_to_bytes(s):
    return bytearray(map(char_to_byte, s))

for i in range(MAX_O2+1):
    percentage = int(round(100*i/MAX_O2))
    s = f'{percentage:3}'
    result.extend(string_to_bytes(s) + b'\x00')

with open(FILENAME, 'wb') as outf:
    outf.write(result)
