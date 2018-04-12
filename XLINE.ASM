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
include	pixaddr1.inc


.codeseg	lib
.extrn		pixaddr10:auto
.extrn		egaline:auto	; draws a line in graphics mode
.extrn		dline:auto
.extrn		kline:auto
.extrn		horline:auto
.extrn		clhorline:auto
.extrn		start:AUTO, exit:AUTO, exit_ok:AUTO
.extrn		put_str:AUTO
.extrn		get_chr:auto
.extrn		words_to_dec:auto,put_chr:auto
.extrn		word_to_hex:auto
.extrn		rand_init:auto,randr_w:auto
.extrn		set_vect:auto,get_vect:auto
.extrn		ssin:auto,scos:auto
.extrn		sqrt:auto
.extrn		csqrt:auto
.extrn		div_dw:auto
.ends

.public	argx1,argx2,argy1,argy2,n


.dataseg
ithink		db	13,10,"I think, therfore I ASM.",13,10,0
argx1	dw	0
argy1	dw	0
argx2	dw	0
argy2	dw	0
n	db	15
vboff	dw	0
walkx	dw	0
scncode	db	?
scnflg	db	0				; non-zero means change
old9	dw	?,?				; old int vector
bsyflg	db	-1				; if non-zero, machine is bsy
kbdtbl	db	16 dup(0)			; table for key presses
kbuf	db	128 dup(0)
gwinf	dw	75,50,565,300,622,193,300,200,320,102,4000,24000
ysfl	dw	?
ysfh	dw	?
ysfig	dw	?
xc	dw	?
yc	dw	?
xw	dw	?
yw	dw	?
yline	dw	?
tyline	dw	?
nbits	dw	?
npts	dw	?

cir0	dw	1
	dw	0,080h
cir1	dw	1
	dw	0,080h
cir2	dw	2
	dw	-80,080h
	dw	0,0c0h
cir3	dw	3
	dw	-80,180h
	dw	0,1c0h
	dw	80,080h
cir4	dw	3
	dw	 -80,0180h
	dw	0,3c0h
	dw	80,180h
cir5	dw	4
	dw	-160,1c0h
	dw	-80,3e0h
	dw	0,3e0h
	dw	80,1c0h
cir6	dw	5
	dw	-160,3c0h
	dw	-80,7e0h
	dw	0,7e0h
	dw	80,7e0h
	dw	160,3c0h
cir7	dw	6
	dw	-240,1c0h
	dw	-160,7f0h
	dw	-80,7f0h
	dw	0,7f0h
	dw	80,7f0h
	dw	160,1c0h
cir8	dw	7
	dw	-240,3c0h
	dw	-160,07e0h
	dw	-80,0ff0h
	dw	0,0ff0h
	dw	80,0ff0h
	dw	160,7e0h
	dw	240,3c0h
cir9	dw	7
	dw	-240,03e0h
	dw	-160,07f0h
	dw	-80,0ff8h
	dw	0,0ff8h
	dw	240,03e0h
	dw	160,07f0h
	dw	80,0ff8h
cir10	dw	7
	dw	-240,07e0h
	dw	-160,0ff0h
	dw	-80,1ff8h
	dw	0,1ff8h
	dw	240,07e0h
	dw	160,0ff0h
	dw	80,1ff8h
cir11	dw	8
	dw	-320,03e0h
	dw	-240,0ff8h
	dw	-160,1ffch
	dw	-80,1ffch
	dw	0,1ffch
	dw	80,1ffch
	dw	160,0ff8h
	dw	240,03e0h
cir12	dw	8
	dw	-320,07e0h
	dw	-240,1ff8h
	dw	-160,3ffch
	dw	-80,3ffch
	dw	0,3ffch
	dw	80,3ffch
	dw	160,1ff8h
	dw	240,07e0h
cir13	dw	9
	dw	-320,03e0h
	dw	-240,0ff80h
	dw	-160,1ffch
	dw	-80,3ffeh
	dw	0,3ffeh
	dw	80,3ffeh
	dw	160,1ffch
	dw	240,0ff8h
	dw	320,03e0h
cir14	dw	10
	dw	-400,07e0h
	dw	-320,1ff8h
	dw	-240,3ffch
	dw	-160,7ffeh
	dw	-80,7ffeh
	dw	0,7ffeh
	dw	80,7ffeh
	dw	160,3ffch
	dw	240,1ff8h
	dw	320,07e0h
cir15	dw	11
	dw	-400,03e0h
	dw	-320,0ff8h
	dw	-240,3ffeh
	dw	-160,3ffeh
	dw	-80,7fffh
	dw	0,7fffh
	dw	80,7fffh
	dw	400,03e0h
	dw	320,0ff8h
	dw	240,3ffeh
	dw	160,3ffeh
cir16	dw	11
	dw	-400,07e0h
	dw	-320,1ff8h
	dw	-240,7ffeh
	dw	-160,7ffeh
	dw	-80,0ffffh
	dw	0,0ffffh
	dw	80,0ffffh
	dw	400,07e0h
	dw	320,1ff8h
	dw	240,7ffeh
	dw	160,7ffeh
	
cirtbl	dw	@dataseg:cir0
	dw	@dataseg:cir1
	dw	@dataseg:cir2
	dw	@dataseg:cir3
	dw	@dataseg:cir4
	dw	@dataseg:cir5
	dw	@dataseg:cir6
	dw	@dataseg:cir7
	dw	@dataseg:cir8
	dw	@dataseg:cir9
	dw	@dataseg:cir10
	dw	@dataseg:cir11
	dw	@dataseg:cir12
	dw	@dataseg:cir13
	dw	@dataseg:cir14
	dw	@dataseg:cir15
	dw	@dataseg:cir16


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
.proc	wcr	auto
	push	ax
	mov	ax,13
	call	put_chr
	mov	ax,10
	call	put_chr
	pop	ax
	ret
.endp


.public		main
.proc		main		AUTO
		mov	si,offset @DATASEG:ithink
		call	put_str
		call	rand_init
		call get_chr
;		call	grab08
		mov 	ax,10h
		int	10h
		jmp	fuck
		mov	cx,1
xtlp:		push	cx
		mov	cx,349
xlnlp:		push	cx
		mov	ax,174
		sub	ax,cx
		.abs_w	ax
		mov	bx,1023
		imul	bx
		mov	bx,174
		idiv	bx
		call	sqrt
		mov	bx,250
		imul	bx
		mov	bx,4097
		idiv	bx
		mov	bx,320
		sub	bx,ax
		mov	argx1,bx
		add	ax,320
		mov	argx2,ax
		mov	argy1,cx
		mov	argy2,cx
		mov	n,7
		mov	si,offset @dataseg:gwinf
		call	clhorline
		pop	cx
		loop	xlnlp
		pop	cx
		loop	xtlp
		mov	cx,349
xlnlp1:		push	cx
		mov	ax,174
		sub	ax,cx
		.abs_w	ax
		mov	bx,1023
		imul	bx
		mov	bx,174
		idiv	bx
		call	sqrt
		mov	bx,250
		imul	bx
		mov	bx,4097
		idiv	bx
		mov	bx,320
		sub	bx,ax
		mov	argx1,bx
		add	ax,320
		mov	argx2,ax
		mov	argy1,cx
		mov	argy2,cx
		mov	n,12
		mov	si,offset @dataseg:gwinf
		call	clhorline
		pop	cx
		loop	xlnlp1
fuck:
		mov	n,2
		mov	argx1,320
		mov	argx2,320
		mov	argy1,0
		mov	argy2,349
		call	dline

		mov	ax,0
		mov	xw,ax
ddlp:
		mov	xc,70
		mov	yc,45
		mov	n,1
		mov	si,offset @dataseg:gwinf
		call	drawdisc
		inc	xw
		call	get_chr
		cmp	al,1
		jnz	ddlp

;		call	rest08
	  	mov	ax,3
		int	10h
		ret			;exit to DOS with ERRORLEVEL=0
.endp		main

.proc	drawdisc	auto		; draws a damn disc
	mov	ax,xw			; get size
	or	ax,ax			; check size
	jns	ddlm1			; do bounds check
ddbag:	ret
ddlm1:
	cmp	ax,1024			; make x size allowed today
	js	ddlm2
	mov	ax,1023
ddlm2:
	cmp	ax,17
	jns	ddl0
	jmp	smldisc			; if small, go to small code
ddl0:	push	ax
	mov	dx,3ceh		; dx := graphics controller port addr
	mov	ah,n
	xor	al,al
	out	dx,ax		; put color selection in set/reset reg
	mov	ax,0f01h
	out	dx,ax		; put 0fh in bit plane enable
	mov	ah,0
	mov	al,3
	out	dx,ax		; 0 for the RWM bits of the ALU
	mov	ax,0305h	; write mode 3 select
	out	dx,ax
	
	mov	ax,yc		; get basic di address
	mov	bx,0		;
	pixadd			; get bx with proper value
	mov	yline,bx	; put in variables
	mov	tyline,bx	; put in variables

	pop	ax
	mov	dx,45397		; has to do with aspect ratio
	mul	dx
	mov	yw,dx			; set actual y size
	mov	bx,xw			; set up a mult
;	inc	bx
	mov	dx,2936			; now we calculate ysf
	xor	ax,ax
	call	div_dw			; ysf=2048/(yw+1)
	mov	ysfl,ax			; save in double variable
	mov	ysfh,dx
	mov	cx,4			; now mult by 32 for x calcs
dsl1:	shl	ax,1
	rcl	dx,1
	loop	dsl1
	mov	ysfig,dx		; save  for later
	mov	ax,xw			; write out first line
	mov	bx,ax			; make copy
	shr	ax,1			; do the rigamorole
	inc	bx
	shr	bx,1
	add	bx,xc
	neg	ax
	add	ax,xc			; get x coords of center line
	mov	argx1,ax
	inc	bx			; make up for n-1 line problem
	mov	argx2,bx
;	mov	ax,yc			; get y coord of center
;	mov	argy1,ax
;	mov	argy2,ax
;	mov	yline,ax
;	mov	tyline,ax
	mov	di,yline		; set up start address
	call	rawhline			; draw center line

	xor	ax,ax			; prepare for awesome loop
	push	ax
	push	ax			; start with variable =0
	mov	cx,yw			; get bumber of lines
	inc	cx			; to go in the downward direction
	shr	cx,1
	jz	cbtlpd			; ctr line already drawn. 
cbtlp:	
	pop	ax			; get scaled y coord rel to center
	pop	dx
	add	ax,ysfl			; move down by 1 notch
	adc	dx,ysfh			; 32bit add for dramaticks
	push	dx
	push	ax
;	shl	ax,1			; round ax value
;	adc	dx,0
	mov	di,yline
	add	di,80
;	inc	ax
	mov	yline,di
;	mov	argy1,ax
;	mov	argy2,ax
	mov	ax,dx			; only the high word matters
;	call	wword
;	call	wcr
	push	si
	call	csqrt			; xlate this to x
	pop	si
	push	cx
	mov	cl,5			; mult by 32
	shl	ax,cl
	mov	bx,ysfig		; get pre-multed ysf
	xor	dx,dx
	div	bx			; xlate scale to our scale
;	sub	dx,bx
;	jns	dls2
;	inc	ax			; round value
;dls2:
	push	ax			; now do the n, n+1 dance
	inc	ax
	shr	ax,1
	add	ax,xc
	inc	ax			; make up for early end of line
	mov	argx2,ax		; set up right coord
	pop	ax			; now do left coord
	shr	ax,1			; note no inc ax before this one
	neg	ax
	add	ax,xc			; finalize the left x coord
	mov	argx1,ax
	call	rawhline			; finally write the darn line!
	mov	di,tyline
;	dec	ax
	sub	di,80
	mov	tyline,di
;	mov	argy1,ax
;	mov	argy2,ax
	call	rawhline			; draw center line
	pop	cx
	loop	cbtlp			; do another line
cbtlpd:	pop	ax
	pop	ax			; bag two useless items
	mov	dx,3ceh		; dx := graphics controller port addr
	mov	ax,5
	out	dx,ax		; write mode 0
	xor	ax,ax
	out	dx,ax
	inc	ax
	out	dx,ax
	clc			; give no error flag
	ret

smldisc:
	mov	ax,yc		; set up for correct pixel address
	mov	bx,xc
	cmp	bx,[si]		; see if in window
	js	smlbag		; out of window, forget disc
	cmp	bx,[si+4]
	jns	smlbag
	pixadd
	cmp	bx,[si+20]	; see if we are out of window
	jns	smld0
smlbag:	ret
smld0:	cmp	bx,[si+22]	; is y too big?
	js	smld1
	ret
smld1:
	mov	dx,3ceh		; dx := graphics controller port addr
	mov	ah,n
	xor	al,al
	out	dx,ax		; put color selection in set/reset reg
	mov	ax,0f01h
	out	dx,ax		; put 0fh in bit plane enable
	mov	ah,0
	mov	al,3
	out	dx,ax		; 0 for the RWM bits of the ALU
	mov	ax,0305h	; write mode 3 select
	out	dx,ax
	dec	bx		; start back 1 byte assume not left edge
	mov	di,bx		; of screen
	xor	ch,ch		; convert cx to properness
	neg	cx
	add	cx,7
	mov	nbits,cx	; and store
	mov	bx,xw		; now use number of x bits to examine
				; table
	shl	bx,1
	add	bx,offset @dataseg:cirtbl
;	mov	bx,5555h
;	mov	bx,offset @dataseg:cirtbl
	mov	si,[bx]	; get address of table
;	mov	si,offset @dataseg:cir0
	mov	cx,[si]		; get vertical size count
	mov	ax,cx
;	call	wword
	add	si,2		; incr pointer
ddl6:	mov	bx,[si]		; get offset into bx
	mov	ax,[si+2]
	add	si,4
	xor	dx,dx		; prepare for shifting operation
	push	cx
	mov	cx,nbits	; save cx, and replace cx with nbits
	or	cx,cx		; verify cx not zero
	jz	ddl7
ddl8:	shr	ax,1		; shift bit mask to line up with xc
	rcr	dx,1		; copy bits into dh
	loop	ddl8
ddl7:	pop	cx
	xchg	es:[di+bx],ah	; write 3 bytes of data
	xchg	es:[di+bx+1],al	; write 3 bytes of data
	xchg	es:[di+bx+2],dh	; write 3 bytes of data
	loop	ddl6



	mov	dx,3ceh		; dx := graphics controller port addr
	mov	ax,5
	out	dx,ax		; write mode 0
	xor	ax,ax
	out	dx,ax
	inc	ax
	out	dx,ax
	ret

.endp

.proc	rawhline	auto
	cmp	di,[si+20]	; see if di below max
	jns	rhl0		; no, we're fine here
	jmp	hordone
rhl0:	cmp	di,[si+22]	; make sure we're less than maximum
	js	rhl1
bagit:	jmp	hordone
rhl1:
	mov	ax,argx2	; check for x2>x1
	cmp	ax,[si]	; see if line not in window
	js	bagit	; if not in window, bag line right away
	cmp	ax,[si+4]	; see if extends past window
	js	rhl2		; no, leave alone
	mov	ax,[si+4]	; yes, then limit max x
rhl2:
	mov	bx,argx1	; do the same sort of checks with x1
	cmp	bx,[si+4]	; is there any work to do here?
	jns	bagit		; not this line!
	cmp	bx,[si]		; keep in window
	jns	rhl3
	mov	bx,[si]
	mov	argx1,bx
rhl3:
	sub	ax,argx1
	jz	bagit		; bag lines of zero length
;	jnz	dd0
;	jmp	hordone	; if there is no line to draw, skip it
;dd0:	jns	dd1	; reverse x2,x1 if reversed
;	neg	ax
;	mov	bx,argx1
;	xchg	bx,argx2
;	mov	argx2,bx
;dd1:	
	mov	cx,ax	; see what scale we're talking, here
	sub	cx,8
	jg	dd2	; if bigger than 8, skip ahead
	mov	cx,ax	; put count in ax
	dec	cx
	mov	ax,08000h ; make mask
	sar	ax,cl
;	mov	di,ax	; save mask in di
;	mov	ax,argy1
;	mov	bx,argx1
;	pixadd
;	mov	ax,di	; restore bit mask
;	mov	di,bx	; set address

	mov	bx,argx1
	mov	dx,bx
	mov	cl,3
	shr	bx,cl
	and	dx,7
	mov	cx,dx
	add	di,bx

	
;	neg	cl	; xlate  count
;	add	cl,7
	shr	ax,cl
	xchg	es:[di],ah
	inc	di
	xchg	es:[di],al
	jmp	hordone

dd2:	cmp	cx,8		; is npts > 16?
	jg	dd3		; yes, continue with other code
	mov	ax,0ff00h	; make big bit mask
	sar	ax,cl		; ax will hold upto 16 bit mask

	mov	bx,argx1
	mov	dx,bx
	mov	cl,3
	shr	bx,cl
	add	di,bx
	mov	cx,dx
	xor	dx,dx
	and	cx,7

;	mov	ax,argy1
;	mov	bx,argx1
;	pixadd
;	mov	ax,di		; restore bit mask
;	mov	di,bx		; put address in proper register
;	xor	ch,ch
;	neg	cx		; adjust bit count
;	add	cx,7

	jz	dd4		; don't shift once if count=0
dd5:	shr	ax,1		; shift mask to starting position
	rcr	dx,1
	loop	dd5
dd4:	xchg	es:[di],ah	;
	inc	di
	xchg	es:[di],al
	inc	di
	xchg	es:[di],dh
	jmp	hordone

dd3:	mov	npts,cx	; save number of points - 8
	mov	bx,argx1
	mov	dx,bx
	mov	cl,3
	shr	bx,cl
	add	di,bx
	mov	cx,dx
	xor	dx,dx
	and	cx,7

;	mov	ax,argy2
;	mov	bx,argx1
;	pixadd
;	mov	di,bx
;	neg	cl
;	add	cl,7
;	xor	ch,ch
	add	npts,cx
	mov	al,-1
	shr	al,cl
	xchg	al,es:[di]
	inc	di
	mov	cx,npts
	shr	cx,1		; how many bytes to write?
	shr	cx,1
	shr	cx,1
	cmp	cx,9
	js	dd7
	mov	ax,-1
	test	di,1		; see if on even or odd addr
	jz	dd8		; if even, jump ahead
	stosb
	dec	cx
dd8:	shr	cx,1		; now write words
	rep	stosw
	jnc	dd9		; if cx was even, then we're done
	stosb			; if odd, then do last byte
	jmp	dd9

dd7:	mov	al,-1
	cld
	rep stosb
dd9:	mov	cx,npts
	and	cl,7
	mov	ax,0ff00h
	shr	ax,cl
	xchg	al,es:[di]
hordone:	ret
.endp
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
