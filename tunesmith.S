.segment = "CODE"
 ;*****************************
 ;* KIM - The Tunesmith       *
 ;*                           *
 ;* Anthony T. Scarpelli      *
 ;* RR1, Box 426              *
 ;* N. Windham, ME 04062      *
 ;*                           *
 ;* in MICRO NUMBER 13        *
 ;* (c) May 1979 by           *
 ;* THE COMPUTERIST, INC.     *
 ;*                           *
 ;*****************************


pad 	 = 	 $1700 	;data register
padd 	 = 	 $1701 	;data direction register
timer	 = 	 $1704	;set Timer
ttimer	 = 	 $1707	;test Timer
stimer	 = 	 $170f	;start Timer
sad	 	 = 	 $1740	;System Data Register A
sadd	 = 	 $1741	;System Data direction A
sbd	 	 = 	 $1742	;System Data Register B
pbdd	 = 	 $1743	;System Data Direction B
keyin	 = 	 $1f40 	;Keypad input
getkey	 = 	 $1f6a	;get Keyboard input
tuntbl   =   $0060 	;Tune table
lnttbl   =   $00A8	;Length Table


         .org    $0000

note:    .byte   $fb	;G
         .byte   $df	;A
         .byte   $c6	;B
         .byte   $bb	;C
         .byte   $a6	;D
         .byte   $93	;E
         .byte   $8a	;F
		 
hinote:  .byte   $7b	;G
         .byte   $6d	;A
         .byte   $61	;B
         .byte   $5b	;C
         .byte   $51	;D
         .byte   $48	;E
         .byte   $43	;F
		 
shpnot:  .byte   $ed	;G_sharp, A_flat
         .byte   $d2	;A_sharp, B_flat
         .byte   $01	;and so on
         .byte   $b0
         .byte   $9c
         .byte   $01
         .byte   $83

hishrp:  .byte   $74	;G_sharp, A_flat
         .byte   $67	;on and on
         .byte   $01
         .byte   $56
         .byte   $4c
         .byte   $01
         .byte   $3f

         .byte   $00	;unused
         .byte   $00
         .byte   $00
         .byte   $00

deltim:  .byte   $02	;Delay time
timed:   .byte   $00
timec:   .byte   $00
savflg:  .byte   $00	;save flag 
tlenth:  .byte   $00	;temp length 
notptr:  .byte   $00	;note pointer 
keyptr:  .byte   $00	;key pointer 
tnote:   .byte   $00	;temp note 
hiflg:   .byte   $00	;hi flag 
shpflg:  .byte   $00	;sharp flag 
notnum:  .byte   $00	;note number
prmnot:  .byte   $00	;permanent nore 
fstflg:  .byte   $00	;first time flag
plenth:  .byte   $00	;perm length 
tntnum:  .byte   $00	;temp. note number 
nexnot:  .byte   $00	;next note 
delaya:  .byte   $00
delayb:  .byte   $00	
pntptr:  .byte   $00	;perm. note pointer 
delayc:  .byte   $00	
ttbptr:  .byte   $00	;tunetable pointer 
ntbptr:  .byte   $00	;note table pointer 
notcnt:  .byte   $00	;note count 
dntcnt:  .byte   $00	;display note count
temnot:  .byte   $00	;temp.note
temlen:  .byte   $00	;temp.length
count:   .byte   $00
dfour:   .byte   $00
dthree:  .byte   $00
dtwo:    .byte   $00
done:    .byte   $00	
lntptr:  .byte   $00	;length pointer

keylnt:  .byte   $01	;whole note 
         .byte   $02	;half note 
         .byte   $04	;quater note 
         .byte   $08	;eighth note 
lnth:    .byte   $20	;length 
         .byte   $10
         .byte   $08
         .byte   $04
lnshp:   .byte   $86	;length shape
         .byte   $db
         .byte   $e6
         .byte   $ff
ntshp:   .byte   $bd	;letter shapes
         .byte   $f7
         .byte   $fc
         .byte   $b9
         .byte   $de
         .byte   $f9
         .byte   $f1
letnum:  .byte   $00 	;letter number 
         .byte   $0f
         .byte   $0d
         .byte   $0b
         .byte   $09
letter:  .byte   $08	;letter shapes 
         .byte   $f9
         .byte   $be
         .byte   $f7
         .byte   $ed

         .org    $0100

disnts:  lda     #$01		;reset display note count 
         sta     dntcnt	
nxtnot:  lda     dntcnt		;test for end
         cmp     notcnt	
         bne     begin
         jmp     doagnb

begin:   ldx     dntcnt		;store note 
         lda     tuntbl,x	;and length
         sta     temnot
         lda     lnttbl,x
         sta     temlen
         ldx     #$00
rpt:     lda     temnot		;test for second 
         cmp     #$01		;group
         beq     diszer
         cmp     $00,x
         beq     sub
         inx
         jmp     rpt

sub:     sec				;test for first 
         txa				;group 
         sbc     hinote
         bcs     nxgrpa
         lda     ntshp,x	;store note shape 
         sta     dtwo
         lda     #$c0
         sta     done
         sta     dthree
         jmp     dislen

nxgrpa:  sec				;test for second 
         txa				;group 
         sbc     #$0e
         bcs     nxgrpb
         txa
         sbc     #$06		;store note shape 
         tax
         lda     ntshp,x
         sta     dtwo
         lda     #$f6		;store hi shape 
         sta     done
         lda     #$c0
         sta     dthree
         jmp     dislen

nxgrpb:  sec				;test for third
         txa				;group 
         sbc     #hishrp
         bcs     nxgrpc
         txa
         sbc     #$0d		;store note shape 
         tax
         lda     ntshp,x
         sta     dtwo
         lda     #$ed
         sta     dthree
         lda     #$c0
         sta     done
         jmp     dislen

nxgrpc:  sec				;store note shape 
         txa
         sbc     #hishrp
         tax
         lda     ntshp,x	
         sta     dtwo
         lda     #$ed		;store sharp note 
         sta     dthree
         lda     #$f6
         sta     done
         jmp     dislen

diszer:  lda     #$bf		;store zero shape 
         sta     dtwo
         lda     #$c0
         sta     done
         sta     dthree
dislen:  ldx     #$00
rptb:    lda     temlen		;test for length 
         cmp     lnth,x
         beq     gtshp
         inx
         jmp     rptb

gtshp:   lda     lnshp,x	;store length shape 
         sta     dfour
dis:     lda     #$80		;load display 
         sta     delayc		;length time
         lda     #$7f		;set direction reg 
         sta     sadd	
rptc:    ldx     #$04		;up to 4 letters	
lite:    ldy     #$ff		;and display 
         lda     letnum,x	;light letters 
         sta     sbd	
         lda     count,x
         sta     sad
wait:    dey				;delay 
         bne     wait
         dex				;get next letter 
         bpl     lite
         ldy     delayc		;delay 
         dey
         sty     delayc
         bne     rptc
         jsr     keyin		;test for next note 
         jsr     getkey	
         cmp     #$03
         beq     next
         jsr     keyin		;test for start again
         jsr     getkey
         cmp     #$11
         beq     doagnb
         bne     dis

next:    jsr     delay
         inc     dntcnt		;increment display note 
         ldx     #$ff		;count reset stack
         txs				;pointer 
         nop				;padding
         nop
         jmp     nxtnot

doagnb:  lda     #$00
         sta     notcnt
         jmp     nutune


;main program 
         .org    $0200
nutune:  lda     #$00		;initialize tune
         sta     savflg
         sta     notnum
         sta     fstflg
         lda     #$01
         sta     tuntbl
         sta     lnttbl
         sta     tnote
         lda     #$10
         sta     tlenth
nunote:  lda     #$06		;initialize note 
         sta     notptr
         lda     #$0f
         sta     keyptr
playb:   jsr     keyin		;test keypad for note 
         jsr     getkey
         cmp     keyptr
         beq     gtnote
         cmp     #$00		;for rest 
         beq     gtrest
         lda     fstflg		;test for first time 
         cmp     #$00
         beq     noplay
         dec     keyptr		;set up for next note 
         dec     notptr
         bpl     delya
         bmi     nunote

delya: 	 ldx     delaya
         dex
         stx     delaya
         bne     playb
         jmp     svnote

noplay:  dec     keyptr		;set up for next note 
         dec     notptr
         bpl     playb
         bmi     nunote

gtrest:  lda     #$01		;load rest 
         sta     fstflg
         sta     tnote
         jmp     svnote

gtnote:  lda     #$01		;load forst note flag 
         sta     fstflg
         ldx     keyptr		;load chosen note 
         lda     #$00
         sta     hiflg
         sta     shpflg
         lda     note,x
         sta     tnote
         stx     pntptr
svnote:  jsr     gethi		;get hi note
         jsr     getsrp		;get sharp note 
         jsr     gtlnth		;get length 
         jsr     platun		;play note 
         jsr     keyin		;test to save note 
         jsr     getkey
         cmp     #$03
         beq     save
         jsr     keyin		;test for start over
         jsr     getkey
         cmp     #$11		;DA = do again 
         beq     doagn		
         jsr     keyin		;test for display note 
         jsr     getkey
         cmp     #$12		;=+
         beq     dnotes
         bne     playb

save:    lda     #$01		;save note 
         sta     savflg
         jmp     nunote

doagn:   lda     #$00		;reset note counter 
         sta     notcnt		
         ldx     #$ff		;reset stack pointer 
         txs
         nop				;padding 
         nop
         jmp     nutune

dnotes:  ldx     #$ff		;reset stack pointer 
         txs
         nop
         nop
         jmp     disnts		;jump to display notes 

delay:	 lda 	 deltim		;get delay value 
		 sta 	 timed
dela: 	 lda 	 #$ff		;load timer 
		 sta 	 timer
test: 	 bit	 ttimer		;test timer
 		 bpl	 test		;branch if not run out
		 dec 	 timec		;reduce time value
		 bne	 dela		;start again 
		 dec 	 timed		;reduce delay value 
		 bne	 dela		;branch if not done 
		 rts


	;tone subroutine
		 .org 	 $02dd
tone: 	 lda 	 #$01		;open port
		 sta	 padd		
sound: 	 lda 	 #$20		;start timer 
		 sta	 stimer
notex: 	 ldx 	 prmnot		;note freq
nwait:	 dex	
		 bne 	 nwait
		 inc	 pad		;toggle output
		 lda	 #$80		;test counter 
		 bit 	 ttimer
		 bmi 	 timout
		 jmp 	 notex
timout:  dec 	 plenth		;note length
		 bne 	 sound
		 rts


;play tune subroutine 
         .org    $0300
platun:  lda     notnum		;set up first note 
         sta     tntnum
         lda     #$00
         sta     nexnot
         lda     tnote		;play note 
         sta     prmnot
         lda     tlenth
         sta     plenth
         jsr     tone
         lda     savflg		;test for save 
         cmp     #$01
         beq     savex
         lda     notnum		;test for note 
         cmp     #$00		;(not required)
         beq     return
playc:   ldx     nexnot		;load next note 
         lda     tuntbl,x
         sta     prmnot
         lda     lnttbl,x	;load next length 
         sta     plenth
         jsr     tone		;play note 
         inc     nexnot		;set up for 
         dec     tntnum		;next note 
         bpl     playc
return:  rts

savex:   lda     #$00		;reset save flag 
         sta     savflg
         lda     #$00		;no play 
         sta     tnote
         inc     notnum		;load note into 
         ldx     notnum		;tunetable 	
         lda     prmnot
         sta     tuntbl,x
         lda     tlenth		;load length 
         sta     lnttbl,x	;into length table 
         jsr     disply
         jmp     platun


;get hi subroutine 
         .org    $0356
gethi:   jsr     keyin		;test for hi note 
         jsr     getkey
         cmp     #$07
         bne     retrnb
         lda     shpflg		;load shape flag 
         cmp     #$00
         beq     loadhi		
         ldx     pntptr		;load hi sharp note 
         lda     hishrp,x	
         sta     tnote
         jmp     retrnb		;could have been rts 
loadhi:  ldx     pntptr		;load hi note 
         lda     hinote,x
         sta     tnote
retrnb:  rts

;get sharp subroutine 
         .org    $0386
getsrp:  jsr     keyin		;test for sharp note 
         jsr     getkey
         cmp     #$05
         bne     retrnc
         lda     #$01		;load sharp flag 
         sta     shpflg
		 ldx     pntptr		;load sharp note 
         lda     shpnot,x
         sta     tnote
retrnc:  rts


;display save subroutine 
         .org    $03aa
disply:  lda     #$80		;load disply	
         sta     delayc		;ligth time
         lda     #$7f		;set direction 
         sta     sadd
repeat:  ldx     #$04		;4 letters 
light:   ldy     #$ff		;and delay 
         lda     letnum,x	;light letters 
         sta     sbd
         lda     letter,x
         sta     sad
waity:   dey				;delay 
         bne     waity
         dex				;get next letter 
         bpl     light
         ldy     delayc		;delay 
         dey
         sty     delayc
         bne     repeat
         lda     notcnt		;test for 72 notes 
         cmp     #$48		;48 hex is 72 dec 
         bne     incnot
         jmp     disnts

incnot:  inc     notcnt		;increase note count 
         rts
		 
;get length subroutine 
gtlnth:  lda     #$03		;load length pointer 
         sta     lntptr
keytst:  jsr     keyin		;test keypad for
         jsr     getkey		;length 
         ldx     lntptr
         cmp     keylnt,x
         beq     lodlnt
         dec     lntptr
         bpl     keytst
         rts
lodlnt:  lda     lnth,x		;load length
         sta     tlenth
         rts


