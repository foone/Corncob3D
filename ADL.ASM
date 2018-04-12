;=============================================================================
;FILE:	ITHINK.ASM
;
;DESC:	Sample program from page 30 of the manual.
;
;NOTES:	Created using the MAIN.XXX skeleton file.
;=============================================================================

_MODEL	equ	<SMALL>

include		MODEL.INC

ADLIBREG	equ	388h
ADLIBWRT	equ	ADLIBREG+1
BASELEVEL	equ	9
PRINTFLAG	equ	0
larryflag	equ	0

.codeseg	lib
.extrn		init_msec:auto,sleep_msec:auto,tmr_reset:auto,tmr_read:auto
.extrn		get_chr:auto
.extrn		open_h:auto,close_h:auto,read_h:auto,hget_line:auto
.extrn		asc_to_byte:auto,put_chr:auto
IF PRINTFLAG EQ 1
.extrn		put_newline:auto,put_str:auto
ENDIF
.ends
.public	adldelay,adlwdelay,adldelayinit,adlwrt,adlseq,adlreginit,voiceon
.public	voiceoff,engineinit,guninit,boominit,snareinit,initsound
.public	bassinit,snaresnd,screechinit,blaminit,scrapeinit,windinit
.public	windflag,initvoices,nwait,saucerinit,orbinit

.dataseg
.extrn		kbuf:byte,sndflg:byte

nwait	dw	?
windflag	db	0		; nonzero means wind active

enginefreq	dw	100
cmdname	db	'3.adl',0
dfhandl	dw	?

enginetbl	db	020h,020h
		db	0c0h,0
		db	040h,0
		db	0e0h,3
		db	023h,021h
		db	0e0h,3
		db	043h,BASELEVEL+8
		db	(28+enginetbl-$)dup(-1)
		db	-1

guntbl	db	061h,08fh
	db	064h,0ffh
	db	081h,08h
	db	084h,08h
	db	0c1h,0
	db	0e4h,3
	db	041h,0
	db	044h,0
		db	(28+guntbl-$)dup(-1)
	db	-1

boomtbl	db	062h,0f5h
	db	065h,0f5h
	db	082h,05h
	db	085h,03h
	db	0c2h,0
	db	0e2h,1
	db	042h,0
	db	045h,BASELEVEL
		db	(28+boomtbl-$)dup(-1)
	db	-1

		
screechtbl	db	068h,0f8h
		db	06bh,0f0h
	        db	088h,0ffh
		db	08bh,0ffh
		db	0c3h,0
		db	0ebh,3
		db	0e8h,3
		db	048h,0
		db	04bh,BASELEVEL+6
		db	02bh,025h
		db	028h,024h
		db	(28+screechtbl-$)dup(-1)
		db	-1

blamtbl	db	062h,0f0h
	db	065h,0f0h
	db	082h,03h
	db	085h,05h
	db	042h,0
	db	045h,0
	db	0c2h,00h
	db	0e2h,1
	db	0e5h,0
	db	025h,21h
		db	(28+blamtbl-$)dup(-1)
	db	-1

snaretbl	db	034h,3
		db	074h,64h
		db	94h,62h
		db	54h,20
		db	0b7h,00h
		db	0a7h,020h
		db	0
		db	(28+snaretbl-$)dup(-1)
		db	-1

scrapetbl	db	034h,3
		db	074h,0f4h
		db	94h,0f4h
		db	54h,20
		db	0b7h,00h
		db	0a7h,020h
		db	0
		db	(28+scrapetbl-$)dup(-1)
		db	-1

windtbl		db	034h,3
		db	074h,10h
		db	94h,01h
		db	54h,20
		db	0b7h,00h
		db	0a7h,020h
		db	0
		db	(28+windtbl-$)dup(-1)
		db	-1

stalltbl	db	06ah,030h
		db	06dh,00fh
	        db	08ah,030h
		db	08dh,00fh
		db	0c5h,1
		db	0edh,1
		db	0eah,1
		db	04ah,BASELEVEL+5
		db	04dh,BASELEVEL+6
		db	02dh,020h
		db	02ah,023h
		db	(28+stalltbl-$)dup(-1)
		db	-1
		
saucertbl	db	068h,098h
		db	06bh,098h
	        db	088h,00ah
		db	08bh,00ah
		db	0c3h,0
		db	0ebh,3
		db	0e8h,0
		db	048h,12
		db	04bh,63
		db	02bh,020h
		db	028h,028h
		db	(28+saucertbl-$)dup(-1)
		db	-1
		
orbtbl	db	068h,098h
		db	06bh,098h
	        db	088h,00ah
		db	08bh,00ah
		db	0c3h,0
		db	0ebh,3
		db	0e8h,0
		db	048h,12
		db	04bh,63
		db	02bh,020h
		db	028h,028h
		db	(28+orbtbl-$)dup(-1)
		db	-1
		
klatbl		db	069h,095h
		db	06ch,095h
	        db	089h,002h
		db	08ch,002h
		db	0c4h,0
		db	0e9h,0
		db	0ech,00h
		db	049h,0h
		db	04ch,010h
		db	02ch,02fh
		db	029h,020h
		db	(28+klatbl-$)dup(-1)
		db	-1
.ends


;=============================================================================
;FUNC:	MAIN
;
;DESC:	Main body of program.
;
;IN:	DX		segment address of PSP
;
;ASUMS:	DS,ES		@DATASEG  (same as @CODESEG in TINY model)
;	SS		@STACKSEG (same as @CODESEG in TINY model)
;=============================================================================

.codeseg

IF __TINY__
assume		cs:@codeseg, ds:@dataseg, es:@dataseg
ELSE
;assume		cs:@codeseg, 
	assume ds:@dataseg, es:@dataseg
ENDIF



.proc	adldelay	auto		; waits 35 microsecond for ADLIB
					; I/O port
	push	cx
	push	dx
	push	ax
	mov	cx,nwait
	mov	dx,ADLIBREG
adldlp:
	in	al,dx
	loop	adldlp
	pop	ax
	pop	dx
	pop	cx
	ret
.endp

.proc	adlwdelay	auto		; waits 3.3 microsecond for ADLIB
					; I/O port
	push	cx
	push	dx
	push	ax
	mov	cx,nwait
	shr	cx,1
	shr	cx,1
	shr	cx,1
	inc	cx			; divide 35 by 8 to get 3 microsec
	mov	dx,ADLIBREG
wadldlp:
	in	al,dx
	loop	wadldlp
	pop	ax
	pop	dx
	pop	cx
	ret
.endp

.proc	adldelayinit	auto		; measures how many loops are needed
					; for adlib delay
		call	tmr_reset
		mov	cx,3
oloop:
		push	cx
		xor	cx,cx
iloop:
		in	al,dx
		loop	iloop
		pop	cx
		loop	oloop
		call	tmr_read
		push	ax
		mov	al,ah
		mov	ah,100
		mul	ah
		pop	bx
		xor	bh,bh
		add	bx,ax
		mov	ax,bx
;		call	wword
		mov	ax,700
		xor	dx,dx
		div	bx
		mov	nwait,ax
;		call	wword
		ret
.endp

.proc	adlwrt	auto		; writes a byte to an adlib register
				; port number in bl, and the value in al
	cmp	sndflg,0
	jnz	contsnd
	ret
contsnd:
	push	dx
	push	ax
	mov	dx,ADLIBREG
	mov	al,bl
IF larryflag EQ 0
	out	dx,al
ENDIF
	call	adlwdelay	; delay between the port# write and reg write
	inc	dx
	pop	ax
IF larryflag EQ 0
	out	dx,al
ENDIF
	call	adldelay	; now wait the required 30 microseconds
	pop	dx
	ret
.endp

.proc	adlseq	auto		; writes the same value to sequence of registers
				; cx has count, bl has starting value of reg#
				; al has the data to be written
adlslp:
	call	adlwrt
	inc	bl
	loop	adlslp
	ret
.endp


.proc	adlreginit	auto

		mov	cx,13h		; all maximum level, ksl=0
		mov	al,63
		mov	bl,40h
		call	adlseq

		mov	cx,0dh		; all maximum level, ksl=0
		mov	al,20
		mov	bl,53h
		call	adlseq

		mov	cx,8		; set keys off, octave to 3, fb msbs
		mov	al,0dh
		mov	bl,0b0h
		call	adlseq

		mov	al,0
		mov	bl,1
		call	adlwrt		; 0 to test register and wse bit

		mov	al,20h		; set waveform enable bit on
		mov	bl,1
		call	adlwrt		; 0 to test register and wse bit

		mov	al,0		; 0 to csm and split bits
		mov	bl,8
		call	adlwrt

		mov	cx,20h		; 0 to am,vib,eg,ksr=0, multi=1
		mov	al,1
		mov	bl,20h
		call	adlseq	

		mov	cx,20h		; ar=15, dr=3
		mov	al,0f3h
		mov	bl,60h
		call	adlseq

		mov	cx,20h		; sl=0, rr=3
		mov	al,003h
		mov	bl,80h
		call	adlseq

		mov	cx,8		; set tones of voices to midrange
		mov	al,0
		mov	bl,0a0h
		call	adlseq

		mov	al,20h		; percussion mode, drums key off
		mov	bl,0bdh
		call	adlwrt

		mov	cx,8		; feedback=0, additive mode
		mov	al,0
		mov	bl,0c0h
		call	adlseq

		mov	cx,16h		; set all wave bits to zero
		mov	al,0
		mov	bl,0e0h
		call	adlseq

		ret
.endp


.proc		voiceon	auto		; turns on a voice
					; ax = fnum bits
					; bl = voice
		push	bx
		push	ax
		add	bl,0a0h		; make voice number into port adr
		call	adlwrt
		mov	al,ah
		shl	al,1		; move msbs up into block number
		shl	al,1		; move msbs up into block number
		or	al,1		; put msb into fnum
		or	al,20h		; enable key on bit
		add	bl,10h		; look at next upper part port
		call	adlwrt
		pop	ax
		pop	bx
		ret
.endp

.proc		voiceoff	auto		; turns off a voice
					; ax = fnum bits
					; bl = voice
		push	bx
		push	ax
		mov	al,ah
		shl	al,1		; move msbs up into block number
		shl	al,1		; move msbs up into block number
		or	al,1		; put msb into fnum
		and	al,0dfh		; reset key on bit
		add	bl,0b0h		; look at next upper part port
		call	adlwrt
		pop	ax
		pop	bx
		ret
.endp

.proc	bassinit	auto
		mov	al,01h
		mov	bl,0b6h
		call	adlwrt
	mov	al,0
	mov	bl,50h
	call	adlwrt
	mov	al,0
	mov	bl,53h
	call	adlwrt
		ret
.endp

.proc		engineinit	auto	;
		mov	si,offset @dataseg:enginetbl
		jmp	tblinit
.endp


.proc	guninit	auto
	mov	si,offset @dataseg:guntbl
	jmp	tblinit
.endp

.proc	tblinit	auto
notherreg:
	mov	bl,[si]
	cmp	bl,-1
	jz	nomoreregs
	inc	si
	mov	al,[si]
	call	adlwrt
	inc	si
	jmp	notherreg
nomoreregs:
	ret
.endp

.proc	screechinit	auto
	mov	si,offset @dataseg:screechtbl
	jmp	tblinit
.endp

.proc	saucerinit	auto
	mov	si,offset @dataseg:saucertbl
	jmp	tblinit
.endp

.proc	orbinit	auto
	mov	si,offset @dataseg:orbtbl
	jmp	tblinit
.endp

.proc	klainit	auto
	mov	si,offset @dataseg:klatbl
	jmp	tblinit
.endp

.proc	boominit	auto
	mov	si,offset @dataseg:boomtbl
	jmp	tblinit
.endp
		

.proc	blaminit	auto
	mov	si,offset @dataseg:blamtbl
	jmp	tblinit
.endp
		

.proc	snaresnd	auto		; keys on snare
	cmp	windflag,0
	jnz	skipsnare
	mov	al,20h
	mov	bl,0bdh
	call	adlwrt
	mov	al,28h			; turn on snare, leave mode alone
	mov	bl,0bdh
	call	adlwrt
skipsnare:
	ret
.endp

.proc		windinit	auto	;
	mov	si,offset @dataseg:windtbl
	jmp	tblinit
.endp

.proc		scrapeinit	auto	;
	mov	si,offset @dataseg:scrapetbl
	jmp	tblinit
.endp

.proc		snareinit	auto	;
	mov	si,offset @dataseg:snaretbl
	jmp	tblinit
.endp

.proc		stallinit	auto	;
	mov	si,offset @dataseg:stalltbl
	jmp	tblinit
.endp

.proc	readasound	auto	; reads sound
	mov	cx,15		; maximum of 14 register values
readloop:
	push	cx
	mov	si,offset @dataseg:kbuf

IF PRINTFLAG EQ 1
	call	put_str
	call	put_newline
ENDIF
	mov	cx,8		; read a max of 79 characters
	mov	bx,dfhandl	; handle for file	
	mov	ax,ds		; set es for lord knows why?
	mov	es,ax
	call	hget_line
	jnc	nohgeterr
	jmp	cmdclose1
nohgeterr:
	mov	si,offset @dataseg:kbuf
	mov	bl,16		; read hexadecimal number
	call	asc_to_byte
	jz	numgood
	mov	al,7
	call	put_chr
	jmp	cmdclose1
numgood:
	inc	si		; advance over the space or comma
	cmp	al,0ffh		; look for end of data word
	jz	nextvoice
	mov	[di],al		; store register numbers
	inc	di

	mov	bl,16		; read hexadecimal number
	call	asc_to_byte
	jz	numgood1
	mov	al,7
	call	put_chr
	jmp	cmdclose1
numgood1:
	mov	[di],al		; store value
	inc	di
	pop	cx
	loop	readloop
	clc
	ret
nextvoice:
	pop	cx
	clc
	ret

cmdclose1:
	pop	cx
	stc
	ret			; got an error
.endp
	

.proc	readsounds	auto
	mov	si,offset @dataseg:cmdname
	mov	ax,0102h
	call	open_h
	mov	dfhandl,bx
	jc	nocmdfile

	mov	di,offset @dataseg:enginetbl
	call	readasound
	jc	cmdfileclose
	mov	di,offset @dataseg:guntbl
	call	readasound
	jc	cmdfileclose
	mov	di,offset @dataseg:boomtbl
	call	readasound
	jc	cmdfileclose
	mov	di,offset @dataseg:screechtbl
	call	readasound
	jc	cmdfileclose
	mov	di,offset @dataseg:blamtbl
	call	readasound
	jc	cmdfileclose
	mov	di,offset @dataseg:snaretbl
	call	readasound
	jc	cmdfileclose
	mov	di,offset @dataseg:scrapetbl
	call	readasound
	jc	cmdfileclose
	mov	di,offset @dataseg:windtbl
	call	readasound
	jc	cmdfileclose
	mov	di,offset @dataseg:stalltbl
	call	readasound
	jc	cmdfileclose
	mov	di,offset @dataseg:saucertbl
	call	readasound
	jc	cmdfileclose
	mov	di,offset @dataseg:orbtbl
	call	readasound
	jc	cmdfileclose
	mov	di,offset @dataseg:klatbl
	call	readasound
	jc	cmdfileclose


cmdfileclose:
	mov	bx,dfhandl	; handle for file	
	call	close_h
nocmdfile:
	ret
.endp

.proc		initvoices	auto
		call	snareinit
		call	guninit
		call	boominit
		call	bassinit
		call	engineinit
		call	screechinit
;		call	blaminit ; removed because shares voice with boom
		call	stallinit
		call	klainit
		mov	ax,0100h		; mid-octave voice
		mov	enginefreq,ax
		ret
.endp


.proc	initsound	auto		; initializes board
		call	init_msec
		call	adldelayinit

		call	adlreginit		; init adlib board registers
		call	readsounds

		call	initvoices		; initialize our voices

nogun:
		ret
.endp
.ends

		end
