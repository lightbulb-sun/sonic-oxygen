.DELETE_ON_ERROR:

AS = asmx
ASFLAGS = -e -b -C 68k
PYTHON = python3

ASM = hack.asm
CHECKSUM_SCRIPT = fixchecksum.py
LUT_SCRIPT = o2lut.py

OBJ_LUT = o2lut.bin
OBJ_REV00 = hack-rev00.asm.bin
OBJ_REV01 = hack-rev01.asm.bin
OUTPUT_ROM_REV00 = hack-rev00.md
OUTPUT_ROM_REV01 = hack-rev01.md

OBJS = $(OBJ_LUT) $(OUTPUT_ROM_REV00) $(OUTPUT_ROM_REV01) $(OBJ_REV00) $(OBJ_REV01)

all: $(OUTPUT_ROM_REV00) $(OUTPUT_ROM_REV01)

$(OUTPUT_ROM_REV00): $(OBJ_REV00)
	$(PYTHON) $(CHECKSUM_SCRIPT) $< $@

$(OUTPUT_ROM_REV01): $(OBJ_REV01)
	$(PYTHON) $(CHECKSUM_SCRIPT) $< $@

$(OBJ_REV00): $(ASM) $(OBJ_LUT)
	$(AS) $(ASFLAGS) -d rev=0 -o $@ $<

$(OBJ_REV01): $(ASM) $(OBJ_LUT)
	$(AS) $(ASFLAGS) -d rev=1 -o $@ $<

$(OBJ_LUT): $(LUT_SCRIPT)
	$(PYTHON) $<

.PHONY: all clean test
clean:
	rm -rf $(OBJS)
