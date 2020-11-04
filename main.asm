    .area CODE (ABS)
    .org 0x100

; CONSTANTS

    input_register = 0x9f02
    system_sound_83 = 0x0054

; PROGRAM

    jp start
    .db 0x00

bg_struct:
    .dw bg_tiles
    .dw palette
    .dw bg_map
    .db 0x28                      ; num_tiles (40)
    .db 0x00
    .db 0x04                      ; num_palettes
    .db 0x00

bg_settings:
    .db 0x20                      ; ?
    .db 0x20                      ; ?
    .dw bg_map

kirby_struct:
    .dw kirby_tiles
    .dw palette
    .db 0x04                      ; width = 4 tiles
    .db 0x03                      ; height = 3 tiles
    .db 0x01                      ; frame 1
    .db 0x01                      ; ?
    .db 0x01                      ; ?
    .db 0x01                      ; ?
    .db 0x01                      ; ?
	
banner1_struct:
    .dw banner1_tiles
    .db 0x77
    .db 0x02                      ; banner1 palette
    .db 0x10                      ; width = 16 tiles
    .db 0x05                      ; height = 5 tiles
    .db 0x01                      ; frame 1
    .db 0x01                      ; ?
    .db 0x01                      ; ?
    .db 0x01                      ; ?
    .db 0x01                      ; ?

banner2_struct:
    .dw banner2_tiles
    .db 0x77
    .db 0x02                      ; banner2 palette
    .db 0x06                      ; width = 6 tiles
    .db 0x05                      ; height = 5 tiles
    .db 0x01                      ; frame 1
    .db 0x01                      ; ?
    .db 0x01                      ; ?
    .db 0x01                      ; ?
    .db 0x01                      ; ?

fire_struct:
    .dw fire_tiles
    .db 0xe0
    .db 0x02                      ; fire palette
    .db 0x04                      ; width = 4 tiles
    .db 0x02                      ; height = 2 tiles
    .db 0x01                      ; frame 1
    .db 0x01                      ; ?
    .db 0x01                      ; ?
    .db 0x01                      ; ?
    .db 0x01                      ; ?

start:
    ld e,#0x23
    ld a,#0x10
    rst 0
    .db 0x1a                      ; unknown API call
    
    ld de,#0x0000

populate_palette:
    ld a,e
    sub #0x06
    ld a,d
    sbc a,#0x00
    jr nc,load_graphics
    push de
    ld l,e
    ld h,d
    add hl,hl
    add hl,hl
    add hl,hl
    add hl,hl
    push hl
    ex de,hl
    add hl,hl
    add hl,hl
    add hl,hl
    add hl,hl
    add hl,hl
    ld de,#palette
    add hl,de                     ; de=offset
    pop de
    ld c,#0x10                    ; c=num_colors
    rst 0
    .db 0x7e                      ; SetBackgroundPalette, hl=src_addr
    pop de
    inc de
    jr populate_palette

load_graphics:
    ld bc,#0x1e09
    ld de,#0x0009
    ld hl,#0x0104; h=bg#, l=palette bank
    rst 0
    .db 0x90                      ; CreateRegion
    ld (region_ptr),a
	
    ld h,a
    ld l,#0x00
    rst 0
    .db 0x9a                      ; SetTextSize
    
    ld de,#0x0100
    ld a,(region_ptr)
    rst 0
    .db 0x98                      ; SetTextColor
    
    ld de,#text1                  ; ld de,#text1
    ld a,(region_ptr)
    rst 0
    .db 0xc0                      ; GetTextWidth
    ld (text_width_ptr),a

    rrca
    and #0x7e
    ld l,a
    ld a,#0x78
    sub l
    ld (text_width_ptr),a
    ld bc,#text1
    ld a,(text_width_ptr)
    ld de,#0x0000
    or d
    ld d,a
    ld a,(region_ptr)
    rst 0
    .db 0x99                      ; DrawText

    rrca
    and #0x7e
    ld l,a
    ld a,#0x4a
    sub l
    ld (text_width_ptr),a
    ld bc,#text2
    ld a,(text_width_ptr)
    ld de,#0x000e
    or d
    ld d,a
    ld a,(region_ptr)
    rst 0
    .db 0x99                      ; DrawText

    ld de,#bg_struct
    xor a                         ; bg #
    rst 0
    .db 0x2d                      ; LoadCustomBackground

    ld hl,#bg_settings
    push hl
    ld c,#0x00                    ; y bg offset
    ld e,#0x00                    ; x bg offset
    xor a                         ; bg number
    rst 0
    .db 0x1c                      ; unknown API call: bg settings?

    pop bc
    ld e,#0x80                    ; palette
    ld hl,#kirby_struct
    rst 0
    .db 0x4d                      ; CreateCustomSprite
    ld (kirby_sprite_ptr),hl      ; obtain sprite handle

    ld bc,#0x0074                 ; y
    ld de,#0x0080                 ; x
    ld hl,(kirby_sprite_ptr)
    rst 0
    .db 0x32                      ; SetSpritePos

    ld e,#0x82                    ; palette
    ld hl,#banner1_struct
    rst 0
    .db 0x4d                      ; CreateCustomSprite
    ld (banner1_sprite_ptr),hl

    ld bc,#0x002B                 ; y
    ld de,#0x0060                 ; x
    ld hl,(banner1_sprite_ptr)
    rst 0
    .db 0x32                      ; SetSpritePos

    ld e,#0x82                    ; palette
    ld hl,#banner2_struct
    rst 0
    .db 0x4d                      ; CreateCustomSprite
    ld (banner2_sprite_ptr),hl
    
    ld bc,#0x002B                 ; y
    ld de,#0x00b8                 ; x
    ld hl,(banner2_sprite_ptr)
    rst 0
    .db 0x32                      ; SetSpritePos

    ld e,#0x82                    ; palette
    ld hl,#fire_struct
    rst 0
    .db 0x4d                      ; CreateCustomSprite
    ld (fire_sprite_ptr),hl      ; obtain sprite handle

    ld bc,#0x006A                 ; y
    ld de,#0x007C                 ; x
    ld hl,(fire_sprite_ptr)
    rst 0
    .db 0x32                      ; SetSpritePos

    ld hl,#system_sound_83        ; hl=system sound number
    rst 8
    .db 0x05                      ; PlaySystemSound

    ld a,#0x10                    ; num of frames
    rst 0
    .db 0x00                      ; FadeIn

    ld e,#0x01
    ld hl,#0x0067                 ; ?
    rst 8                         ; IsSoundPlaying
    .db 0x19

main_loop:
    ld hl,(input_register)        ; GetKeyStateSticky
    ld a,l
    or h                          ; press any button to exit
    jr nz,exit
    ld a,#0x01
    halt
    jr main_loop

exit:
    ld a,#0x02
    rst 8
    .db 0x00                      ; ERAPI_exit
    ret

; DATA

text1:
    .include "text/text.asm"

text2:
    .include "text/text2.asm"

palette:
    .include "gfx/palette.asm"

kirby_tiles:
    .include "gfx/kirby_tiles.asm"

bg_tiles:
    .include "gfx/bg_tiles.asm"

bg_map:
    .include "gfx/bg_map.asm"

banner1_tiles:
    .include "gfx/banner1_tiles.asm"

banner2_tiles:
    .include "gfx/banner2_tiles.asm"
	
fire_tiles:
    .include "gfx/fire_tiles.asm"

; VARIABLES

kirby_sprite_ptr:
    .ds 2
unused:
    .ds 1
banner1_sprite_ptr:
    .ds 2
banner2_sprite_ptr:
    .ds 2
fire_sprite_ptr:
    .ds 3
region_ptr:
    .ds 1
text_width_ptr:
    .ds 1