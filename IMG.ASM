;=============================================================================
;FILE:	ITHINK.ASM
;
;DESC:	Sample program from page 30 of the manual.
;
;NOTES:	Created using the MAIN.XXX skeleton file.
;=============================================================================

_MODEL	equ	<TINY>

include		c:\sa\MODEL.INC
include		c:\sa\include\imath.INC


.codeseg	lib
.extrn		pixaddr10:auto
.extrn		egaline:auto	; draws a line in graphics mode
.extrn		hline:auto
.extrn		start:AUTO, exit:AUTO, exit_ok:AUTO
.extrn		put_str:AUTO
.extrn		get_chr:auto
.extrn		words_to_dec:auto,put_chr:auto
.extrn		word_to_hex:auto
.extrn		byte_to_asc:auto
.extrn		rand_init:auto,randr_w:auto
.extrn		set_vect:auto,get_vect:auto
.extrn		get_version:auto
.extrn		open_h:auto,close_h:auto,read_h:auto
.ends

.public	argx1,argx2,argy1,argy2,n


.dataseg
ithink		db	13,10,"I think, therfore I ASM.",13,10,0
argx1	dw	0
argy1	dw	0
argx2	dw	0
argy2	dw	0
n	db	15
walkx	dw	0
scncode	db	?
scnflg	db	0				; non-zero means change
old9	dw	?,?				; old int vector
bsyflg	db	-1				; if non-zero, machine is bsy
kbdtbl	db	16 dup(0)			; table for key presses
kbuf	db	128 dup(0)
gwinf	dw	8,4,631,199,622,193,300,200,320,102
fname	db	'3d.img',0
ferrmsg	db	0dh,0ah,'File error has occured',0dh,0ah,0

fhandl	dw	?
imgbuf	db	8192 dup(?)
dimx	dw	16000

.ends


IF NOT __TINY__
.stackseg
		db	128 dup(?)	;define a 128 byte stack
.ends
ENDIF


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
assume		cs:@codeseg, ds:@dataseg, es:@dataseg, ss:@dataseg
ELSE
assume		cs:@codeseg, ds:@dataseg, es:@dataseg, ss:@stackseg
ENDIF


.proc	grab08	auto		;grabs an int, man
;	mov	si,offset @dataseg:infmsg
;	call	put_str
	mov	bl,08		; video int
	call	get_vect	; get the current vector
	mov	cs:old08+2,dx	; put into memory
	mov	cs:old08,ax
	mov	bl,008		; now put in our new vector
	mov	dx,cs		; setup segment
	mov	ax,offset @codeseg:new08
	call	set_vect	; grab that vector!
	ret
.endp

.proc	rest08	auto		; restores int 08
	mov	bl,08		; int 08 is video bios
	mov	dx,cs:old08+2	; get old segment
	mov	ax,cs:old08	; get the old offset 
	call	set_vect	; set 'em back to orig state
	ret
.endp
ticks	dw	?
dticks	dw	?,?
old08	dw	?,?

.proc	new08	far		; tick, man
	pushf			; simulate an int
	call	dword ptr cs:old08
				; call old int 8 routine
	inc	word ptr cs:ticks
	add	cs:dticks,1
	adc	cs:dticks+2,0
				; inc ticks
	iret			; return to interrupted program
.endp


.proc	wword	auto
	push	si
	push	ax
	mov	si,offset @dataseg:kbuf
	call	word_to_hex
	call	put_str
	pop	ax
	pop	si
	ret
	.endp

.proc	wbyte	auto
	push	si
	push	ax
	mov	si,offset @dataseg:kbuf
	mov	bl,16
	call	byte_to_asc
	call	put_str
	pop	ax
	pop	si
	mov	al,20h
	call	put_chr
	ret
	.endp

.public		main
.proc		main		AUTO
		mov	si,offset @DATASEG:ithink
		call	put_str
		call	rand_init
		call	get_version
		call get_chr
		mov	si,offset @dataseg:fname
		xor	ax,ax
		call	open_h
		jc	error
		mov	fhandl,bx
		mov	si,offset @dataseg:imgbuf
		mov	cx,8191
		mov	bx,fhandl
		call	read_h
		jc	error
		mov	bx,fhandl
		call	close_h
		jc 	error
		mov	cx,16
		mov	si,offset @dataseg:imgbuf
imglp1:		mov	al,[si]
		call	wbyte
		inc	si
		loop	imglp1
		jmp	wrtimg

error:		mov	si,offset @dataseg:ferrmsg
		call	put_str
		ret

;		call	grab08
wrtimg:
	call	get_chr
		mov 	ax,10h
		int	10h
	mov	dx,3ceh		; dx := graphics controller port addr
	mov	ah,07
	xor	al,al
	out	dx,ax		; put color selection in set/reset reg
	mov	ax,0f01h
	out	dx,ax		; put 0fh in bit plane enable
	mov	ah,0
	mov	al,3
	out	dx,ax		; 0 for the RWM bits of the ALU
	mov	ax,0305h	; write mode 3 select
	out	dx,ax
	mov	di,0
	mov	ax,0a000h
	mov	es,ax		; set up segment
	mov	al,es:[di]	; read latches
	mov	si,offset @dataseg:imgbuf
	add	si,4		; skip first four bytes
	cld
imglp2:	
	mov	ax,di		; check for finish
	cmp	ax,dimx
	jns	idone
	mov	cx,[si]		; get count of fill bytes
	and	cx,03fffh	; limit max count to 16383
	add	si,2
	mov	ax,dimx
	sub	ax,di		; get max bytes left
	cmp	cx,ax
	js	imlb1
	mov	cx,ax
imlb1:	
	mov	al,[si]		; get byte to fill with
	inc	si
	rep	stosb		; fill RAM
	mov	cx,[si]		; get count for data bytes
	and	cx,03fffh	; limit max count to 16383
	add	si,2
	mov	ax,dimx
	sub	ax,di		; get max bytes left
	cmp	cx,ax
	js	imlb2
	mov	cx,ax
imlb2:	
	rep	movsb		; move bytes
	jmp	imglp2		; go back for another

idone:	



	mov	dx,3ceh		; dx := graphics controller port addr
	mov	ax,5
	out	dx,ax		; write mode 0
	xor	ax,ax
	out	dx,ax
	inc	ax
	out	dx,ax
	call	get_chr
;		call	rest08
	  	mov	ax,3
		int	10h
		ret			;exit to DOS with ERRORLEVEL=0
.endp		main

.ends







;=============================================================================
; Stack normalization and memory management initialization labels
;
; NOTE: These declarations must remain after the declaration of the stack
; and anything in the stack segment. These labels define the end of the
; stack and the program, which is where the near and far heaps are placed
; by default. These declarations do not affect the size of the program and
; may be left here even if the stack is not normalized and the heaps are
; not used.
;=============================================================================

.public		nheap_default, fheap_default
IF NOT __TINY__
.stackseg
  IF __SMALL__ OR __MEDIUM__
.public		stack_end		;used by START to normalize stack
.label		stack_end	word	;must be defined past entire stack
  ENDIF
.label		nheap_default	word	;used by the near heap
.label		fheap_default	word	;used by the far heap
.ends
ELSE
_BSSEND		segment	byte public 'STACK'
.label		nheap_default	word	;used by the near heap
.label		fheap_default	word	;used by the far heap
_BSSEND		ends
% @dataseg	group	_BSSEND
ENDIF


		end	start		;specify START as starting address
