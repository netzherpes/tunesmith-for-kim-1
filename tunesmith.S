;tunesmith
;test #1


pad 	 .equ 	 $1700
padd 	 .equ 	 $1701
timer	 .equ 	 $1704
ttimer	 .equ 	 $1707
stimer	 .equ 	 $170f
sad		 .equ 	 $1740
sadd	 .equ 	 $1741
sbd		 .equ 	 $1742
pbdd	 .equ 	 $1743
keyin	 .equ 	 $1f40 
getkey	 .equ 	 $1f6a
tuntbl   .equ  	 $0060
lnttbl   .equ  	 $00A8


         .org    $0000
note:    .byte   $fb
         .byte   $df
         .byte   $c6
         .byte   $bb
         .byte   $a6
         .byte   $93
         .byte   $8a
hinote:  .byte   $7b
         .byte   $6d
         .byte   $61
         .byte   $5b
         .byte   $51
         .byte   $48
         .byte   $43
shpnote: .byte   $ed
         .byte   $d2
         .byte   $01
         .byte   $b0
         .byte   $9c
         .byte   $01
         .byte   $83
hishrp:  .byte   $74
         .byte   $67
         .byte   $01
         .byte   $56
         .byte   $4c
         .byte   $01
         .byte   $3f
         .byte   $00
         .byte   $00
         .byte   $00
         .byte   $00
deltim:  .byte   $02
timd:    .byte   $00
timc:    .byte   $00
savflg:  .byte   $00
tlenth:  .byte   $00
notptr:  .byte   $00
keyptr:  .byte   $00
tnote:   .byte   $00
hiflg:   .byte   $00
shpflg:  .byte   $00
notnum:  .byte   $00
prmnot:  .byte   $00
fstflg:  .byte   $00
plenth:  .byte   $00
tntnum:  .byte   $00
nexnot:  .byte   $00
delaya:  .byte   $00
delayb:  .byte   $00
pntptr:  .byte   $00
delayc:  .byte   $00
ttbptr:  .byte   $00
ntbptr:  .byte   $00
notcnt:  .byte   $00
dntcnt:  .byte   $00
temnot:  .byte   $00
temlen:  .byte   $00
count:   .byte   $00
dfour:   .byte   $00
dthree:  .byte   $00
dtwo:    .byte   $00
done:    .byte   $00
lntptr:  .byte   $00

keylnt:  .byte   $01
         .byte   $02
         .byte   $04
         .byte   $08
lnth:    .byte   $20
         .byte   $10
         .byte   $08
         .byte   $04
lnshp:   .byte   $86
         .byte   $db
         .byte   $e6
         .byte   $ff
ntshp:   .byte   $bd
         .byte   $f7
         .byte   $fc
         .byte   $b9
         .byte   $de
         .byte   $f9
         .byte   $f1
letnum:  .byte   $00
         .byte   $0f
         .byte   $0d
         .byte   $0b
         .byte   $09
letter:  .byte   $08
         .byte   $f9
         .byte   $be
         .byte   $f7
         .byte   $ed

         .org    disnts
disnts:  lda     #$01
         sta     dntcnt
nxtnot:  lda     dntcnt
         cmp     notcnt
         bne     begin
         jmp     doagnb

begin:   ldx     dntcnt
         lda     tuntbl,x
         sta     temnot
         lda     lnttbl,x
         sta     temlen
         ldx     #$00
rpt:     lda     temnot
         cmp     #$01
         beq     diszer
         cmp     $00,x
         beq     sub
         inx
         jmp     rpt

sub:     sec
         txa
         sbc     hinote
         bcs     nxgrpa
         lda     ntshp,x
         sta     dtwo
         lda     #$c0
         sta     done
         sta     dthree
         jmp     dislen

nxgrpa:  sec
         txa
         sbc     shpnot
         bcs     nxgrpb
         txa
         sbc     #$06
         tax
         lda     ntshp,x
         sta     dtwo
         lda     #$f6
         sta     done
         lda     #$c0
         sta     dthree
         jmp     dislen

nxgrpb:  sec
         txa
         sbc     #hishrp
         bcs     nxgrpc
         txa
         sbc     #$0d
         tax
         lda     ntshp,x
         sta     dtwo
         lda     #$ed
         sta     dthree
         lda     #$c0
         sta     done
         jmp     dislen

nxgrpc:  sec
         txa
         sbc     #hishrp
         tax
         lda     ntshp,x
         sta     dtwo
         lda     #$ed
         sta     dthree
         lda     #$f6
         sta     done
         jmp     dislen

diszer:  lda     #$bf
         sta     dtwo
         lda     #$c0
         sta     done
         sta     dthree
dislen:  ldx     #$00
rptb:    lda     temlen
         cmp     lnth,x
         beq     gtshp
         inx
         jmp     rptb

gtshp:   lda     lnshp,x
         sta     dfour
dis:     lda     #$80
         sta     delayc
         lda     #$7f
         sta     sadd
rptc:    ldx     #$04
lite:    ldy     #$ff
         lda     letnum,x
         sta     sbd
         lda     count,x
         sta     sad
wait:    dey
         bne     wait
         dex
         bpl     lite
         ldy     delayc
         dey
         sty     delayc
         bne     rptc
         jsr     keyin
         jsr     getkey
         cmp     #$03
         beq     next
         jsr     keyin
         jsr     getkey
         cmp     #$11
         beq     doagnb
         bne     dis

next:    jsr     delay
         inc     dntcnt
         ldx     #$ff
         txs
         nop
         nop
         jmp     nxtnot

doagnb:  lda     #$00
         sta     notcnt
         jmp     nutune


         .org    $0200
nutune:  lda     #$00
         sta     savflg
         sta     notnum
         sta     fstflg
         lda     #$01
         sta     tuntbl
         sta     lnttbl
         sta     tnote
         lda     #$10
         sta     tlenth
nunote:  lda     #$06
         sta     notptr
         lda     #$0f
         sta     keyptr
playb:  jsr     keyin
         jsr     getkey
         cmp     keyptr
         beq     gtnote
         cmp     #$00
         beq     gtrest
         lda     fstflg
         cmp     #$00
         beq     noplay
         dec     keyptr
         dec     notptr
         bpl     delya
         bmi     nunote

delya: 	 ldx     delaya
         dex
         stx     delaya
         bne     playb
         jmp     svnote

noplay:  dec     keyptr
         dec     notptr
         bpl     playb
         bmi     nunote

gtrest:  lda     #$01
         sta     fstflg
         sta     tnote
         jmp     svnote

gtnote:  lda     #$01
         sta     fstflg
         ldx     keyptr
         lda     #$00
         sta     hiflg
         sta     shpflg
         lda     note,x
         sta     tnote
         stx     pntptr
svnote:  jsr     gethi
         jsr     getsrp
         jsr     gtlnth
         jsr     platun
         jsr     keyin
         jsr     getkey
         cmp     #$03
         beq     save
         jsr     keyin
         jsr     getkey
         cmp     #$11
         beq     doagn
         jsr     keyin
         jsr     getkey
         cmp     #$12
         beq     dnotes
         bne     playb

save:    lda     #$01
         sta     savflg
         jmp     nunote

doagn:   lda     #$00
         sta     notcnt
         ldx     #$ff
         txs
         nop
         nop
         jmp     nutune

dnotes:  ldx     #$ff
         txs
         nop
         nop
         jmp     disnts

delay:	 lda 	 deltim
		 sta 	 timed
dela: 	 lda 	 #$ff
		 sta 	 timer
test: 	 bit	 ttimer
		 bpl	 test
		 dec 	 timec
		 bne	 dela
		 dec 	 timed
		 bne	 timea
		 rts

		 .org 	 $02dd
tone: 	 lda 	 #$01
		 sta	 padd
sound: 	 lda 	 #$20
		 sta	 stimer
notex: 	 ldx 	 prmnot
nwait:	 dex
		 bne 	 nwait
		 inc	 pad
		 lda	 #$80
		 bit 	 ttimer
		 bmi 	 timout
		 jmp 	 notex
timout:  dec 	 plenth
		 bne 	 sound
		 rts

         .org    $0300
platun:  lda     notnum
         sta     tntnum
         lda     #$00
         sta     nexnot
         lda     tnote
         sta     prmnot
         lda     tlenth
         sta     plenth
         jsr     tone
         lda     savflg
         cmp     #$01
         beq     savex
         lda     notnum
         cmp     #$00
         beq     return
playc:   ldx     nexnot
         lda     tuntbl,x
         sta     prmnot
         lda     lnttbl,x
         sta     plenth
         jsr     tone
         inc     nexnot
         dec     tntnum
         bpl     playc
return:  rts

savex:   lda     #$00
         sta     savflg
         lda     #$00
         sta     tnote
         inc     notnum
         ldx     notnum
         lda     prmnot
         sta     tuntbl,x
         lda     tlenth
         sta     lnttbl,x
         jsr     disply
         jmp     platun

         .org    gethi
         jsr     keyin
         jsr     getkey
         cmp     #hinote
         bne     retrnb
         lda     shpflg
         cmp     #$00
         beq     loadhi
         ldx     pntptr
         lda     hishrp,x
         sta     tnote
         jmp     retrnb

loadhi:  ldx     pntptr
         lda     hinote,x
         sta     tnote
retrnb:   rts

         .org    $0386
getsrp:  jsr     keyin
         jsr     getkey
         cmp     #$05
         bne     retrnc
         lda     #$01
         sta     shpflg
         ldx     pntptr
         lda     shpnot,x
         sta     tnote
retrnc:  rts

         .org    $03aa
disply:  lda     #$80
         sta     delayc
         lda     #$7f
         sta     sadd
repeat:  ldx     #$04
light:   ldy     #$ff
         lda     letnum,x
         sta     sbd
         lda     letter,x
         sta     sad
waity:   dey
         bne     waity
         dex
         bpl     light
         ldy     delayc
         dey
         sty     delayc
         bne     repeat
         lda     notcnt
         cmp     #$48
         bne     incnot
         jmp     disnts

incnot:  inc     notcnt
         rts
		 
gtlnth:  lda     #$03
         sta     lntptr
keytst:  jsr     keyin
         jsr     getkey
         ldx     lntptr
         cmp     keylnt,x
         beq     lodlnt
         dec     lntptr
         bpl     keytst
         rts

lodlnt:  lda     lnth,x
         sta     tlenth
         rts


