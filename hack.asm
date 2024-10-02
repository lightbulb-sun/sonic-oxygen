NUM_SPRITES_HUD0 = 13 ; default: 10
NUM_SPRITES_HUD1 = 13 ; default: 10
BIT_SPRITE_HS = 2
BIT_SPRITE_VS = 0
BIT_SPRITE_PRIORITY = 15
BIT_SPRITE_PALETTE_LINE = 13
BIT_SPRITE_VF = 12
BIT_SPRITE_HF = 11
GFX_OFFSET = $6c0
OXYGEN_GAUGE_X = $00
OXYGEN_GAUGE_Y = $b0
OXYGEN_GAUGE_TILE = $7a6
O_TILE = $6ce
SMALL_2_TILE = $6c0
OXYGEN_NUMBER_TILES = $6c2
CUR_OXYGEN = $fffe15
LAST_OXYGEN = $fffe17
    if rev = 0
DIGITS_TABLE = $001cada
    elsif rev = 1
DIGITS_TABLE = $001d2a6
    endif


Sprite macro x, y, hs, vs, priority, palette_line, vf, hf, gfx
            db      y
            db      (hs<<BIT_SPRITE_HS) | (vs<<BIT_SPRITE_VS)
            dw      (priority<<BIT_SPRITE_PRIORITY) | (palette_line<<BIT_SPRITE_PALETTE_LINE) | (vf<<BIT_SPRITE_VF) | (hf<<BIT_SPRITE_HF) | (gfx-GFX_OFFSET)
            db      x
            endm

VRAMCopyCommandToD0 macro tile
            move.l  #$40000000+(((tile*$20)&$3fff)<<16)+(((tile*$20)&$c000)>>14), d0
            endm


    org 0
    if rev = 0
        incbin "sonic-rev00.md"
    elsif rev = 1
        incbin "sonic-rev01.md"
    endif


    if rev = 0
        org $003940
    elsif rev = 1
        org $00393c
    endif
            jsr     copy_small_2


    org $000d88
            jsr     update_o2_in_hud


    if rev = 0
        org $01c572
    elsif rev = 1
        org $01cd28
    endif
            move.w  #GFX_OFFSET, (2, a0)


    if rev = 0
        org $01c5b4
    elsif rev = 1
        org $01cd6a
    endif
            dw      hud0_sprite_data-.
            dw      hud1_sprite_data-.+2


    if rev = 0
        org $01db20
    elsif rev = 1
        org $01e280
    endif
hud0_sprite_data:
            db      NUM_SPRITES_HUD0
            db      $80, $0d, $80, $00+$0a, $00
            db      $80, $0d, $80, $18+$0a, $20
            db      $80, $0d, $80, $20+$0a, $40
            db      $90, $0d, $80, $10+$0a, $00
            db      $90, $0d, $80, $28+$0a, $28
            db      $a0, $0d, $80, $08+$0a, $00
            db      $a0, $01, $80, $00+$0a, $20
            db      $a0, $09, $80, $30+$0a, $30
            db      $40, $05, $81, $0a+$0a, $00
            db      $40, $0d, $81, $0e+$0a, $10
            Sprite  OXYGEN_GAUGE_X+$00, OXYGEN_GAUGE_Y,     0, 1, 1, 0, 0, 0, O_TILE
            Sprite  OXYGEN_GAUGE_X+$07, OXYGEN_GAUGE_Y+$06, 0, 0, 1, 0, 0, 0, SMALL_2_TILE
            Sprite  OXYGEN_GAUGE_X+$30, OXYGEN_GAUGE_Y,     2, 1, 1, 0, 0, 0, OXYGEN_NUMBER_TILES
            db      0
hud1_sprite_data:
            db      NUM_SPRITES_HUD1
            db      $80, $0d, $80, $00+$0a, $00
            db      $80, $0d, $80, $18+$0a, $20
            db      $80, $0d, $80, $20+$0a, $40
            db      $90, $0d, $80, $10+$0a, $00
            db      $90, $0d, $80, $28+$0a, $28
            db      $a0, $0d, $a0, $08+$0a, $00
            db      $a0, $01, $a0, $00+$0a, $20
            db      $a0, $09, $80, $30+$0a, $30
            db      $40, $05, $81, $0a+$0a, $00
            db      $40, $0d, $81, $0e+$0a, $10
            Sprite  OXYGEN_GAUGE_X+$00, OXYGEN_GAUGE_Y,     0, 1, 1, 0, 0, 0, O_TILE
            Sprite  OXYGEN_GAUGE_X+$07, OXYGEN_GAUGE_Y+$06, 0, 0, 1, 0, 0, 0, SMALL_2_TILE
            Sprite  OXYGEN_GAUGE_X+$30, OXYGEN_GAUGE_Y,     2, 1, 1, 0, 0, 0, OXYGEN_NUMBER_TILES
            db      0


    org $071400
copy_small_2:
            ; replace original instruction
    if rev = 0
            jsr     $01c822
    elsif rev = 1
            jsr     $01cfee
    endif
            move.b  #$ff, (LAST_OXYGEN)
            VRAMCopyCommandToD0 SMALL_2_TILE
            move.l  d0, (4, a6)
            lea     yellow_small_digit_2, a3
            jmp     copy_8_bytes_from_a3_to_a6


update_o2_in_hud:
            ; replace original instruction
    if rev = 0
            jsr     $01c024
    elsif rev = 1
            jsr     $01c7da
    endif
            move.b  LAST_OXYGEN, d6
            cmp.b   CUR_OXYGEN, d6
            beq     .the_end
.update
            moveq   #2, d6
            VRAMCopyCommandToD0 OXYGEN_NUMBER_TILES
            lea     DIGITS_TABLE, a1
            move.b  CUR_OXYGEN, d2
            ext.w   d2
            lsl.w   #2, d2
            lea     o2_lut, a2
            lea     (a2, d2), a2
.loop
            move.l  d0, (4, a6)
            move.b  (a2)+, d2
            cmp.b   #$ff, d2
            bne     .digit
.space
            moveq   #0, d2
            move.l  d2, (a6)
            move.l  d2, (a6)
            move.l  d2, (a6)
            move.l  d2, (a6)
            move.l  d2, (a6)
            move.l  d2, (a6)
            move.l  d2, (a6)
            move.l  d2, (a6)
            move.l  d2, (a6)
            move.l  d2, (a6)
            move.l  d2, (a6)
            move.l  d2, (a6)
            move.l  d2, (a6)
            move.l  d2, (a6)
            move.l  d2, (a6)
            move.l  d2, (a6)
            bra     .end_of_loop
.digit
            ext.w   d2
            lsl.w   #6, d2
            lea     (a1, d2), a3
            jsr     copy_16_bytes_from_a3_to_a6
.end_of_loop
            addi.l  #0x400000, d0
            dbf     d6, .loop
.the_end
            move.b  CUR_OXYGEN, d6
            move.b  d6, LAST_OXYGEN
            rts


copy_16_bytes_from_a3_to_a6:
            move.l  (a3)+, (a6)
            move.l  (a3)+, (a6)
            move.l  (a3)+, (a6)
            move.l  (a3)+, (a6)
            move.l  (a3)+, (a6)
            move.l  (a3)+, (a6)
            move.l  (a3)+, (a6)
            move.l  (a3)+, (a6)
copy_8_bytes_from_a3_to_a6:
            move.l  (a3)+, (a6)
            move.l  (a3)+, (a6)
            move.l  (a3)+, (a6)
            move.l  (a3)+, (a6)
            move.l  (a3)+, (a6)
            move.l  (a3)+, (a6)
            move.l  (a3)+, (a6)
            move.l  (a3)+, (a6)
            rts


o2_lut:
            incbin  "o2lut.bin"


yellow_small_digit_2:
            db      $00, $00, $00, $00
            db      $00, $ff, $ff, $10
            db      $00, $11, $1f, $f1
            db      $00, $00, $ff, $11
            db      $00, $0f, $f1, $10
            db      $00, $ff, $11, $10
            db      $0f, $ff, $ff, $f1
            db      $01, $11, $11, $11
