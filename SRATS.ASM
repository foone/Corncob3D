;=============================================================================
;FILE:	ITHINK.ASM
;
;DESC:	Sample program from page 30 of the manual.
;
;NOTES:	Created using the MAIN.XXX skeleton file.
;=============================================================================

qmode	equ	1		; 0 means call from DOS command line


_MODEL	equ	<SMALL>

include		c:\sa\MODEL.INC
include		c:\sa\include\imath.INC
include 3dvid.inc
include pixaddr1.inc

MXSTRS	EQU	768			; MAX # OF STARS
ZRNGE	EQU	32767			; RANGE OF STAR Z COORDS
XYRNGE	EQU	8192
XYRNGE2	EQU	XYRNGE/2
NWDS	EQU	5
PSIZE	EQU	640			; BASE SIZE OF VIEWING PLANE
ZRNGM1	EQU	ZRNGE-1			; MASK FOR MOD 16384
PLORGX	EQU	-PSIZE
PLORGY	EQU	(-PSIZE)*5/7
PLORGZ	EQU	PSIZE*5
PLSZX	EQU	2*PSIZE
PLSZY	EQU	2*PSIZE*5/7
XBIG	EQU	639

fadeframe	equ 8*18


.codeseg	lib
.extrn		start:AUTO, exit:AUTO, exit_ok:AUTO
.extrn		put_str:AUTO,get_chr:auto
.extrn	arg_count:auto,arg_next:auto,str_cat:auto
.extrn		div_dw:AUTO,rand_w:auto
.extrn		words_to_dec:auto,put_chr:auto
.extrn		word_to_hex:auto
.extrn		byte_to_asc:auto
.extrn		rand_init:auto,randr_w:auto
.extrn		set_vect:auto,get_vect:auto
.extrn		get_version:auto
.extrn		open_h:auto,close_h:auto,read_h:auto
.extrn		csqrt:auto
.ends


.dataseg
panicmsg	db	0dh,0ah,'This program cannot be run directly, it is'
		db	' called by other programs.'
		db	0dh,0ah,'Exiting..',0dh,0ah,0

earthsize	dw	1023
nframes		dw	0
wrpflg		db	0
nstars		dw	768
zi		dw	-128
warpframes	dw	0

IF qmode EQ 0
kbuf	db	80 dup (?)

ENDIF

vboff		dw	0
pgflg		db	0
fbxindx		dw	0
brdrclr		db	7
	mgwins	; let macro from 3dvid.inc do the window definitions
ptrgwinf	dw	@dataseg:gwinf
ptrgwint	dw	@dataseg:gwint
clrwinf		db	0bh
clrwint		db	0
clrbits		db	?
colordata	db	?,?,?
fadeclr		db	255
clrflg		db	0
exitflag	db	0
regflag		db	0

npts	dw	0
nbits	dw	0
xc	dw	0
yc	dw	0
xw	dw	0
yw	dw	0

ysfig	dw	0

argx1	dw	0
argy1	dw	0
argx2	dw	0
argy2	dw	0
n	db	0

yline	dw	0
tyline	dw	0
ysfl	dw	0
ysfh	dw	0

tcount	dw	0

tempsum	dw	0

hlinemask	db	-1
bhlinemask	dw	-1

cir0	dw	1
	dw	0,080h
cir1	dw	1
	dw	0,080h
cir2	dw	2
	dw	-lconst,080h
	dw	0,0c0h
cir3	dw	3
	dw	-lconst,180h
	dw	0,1c0h
	dw	lconst,080h
cir4	dw	3
	dw	 -lconst,0180h
	dw	0,3c0h
	dw	lconst,180h
cir5	dw	4
	dw	-2*lconst,1c0h
	dw	-lconst,3e0h
	dw	0,3e0h
	dw	lconst,1c0h
cir6	dw	5
	dw	-2*lconst,3c0h
	dw	-lconst,7e0h
	dw	0,7e0h
	dw	lconst,7e0h
	dw	2*lconst,3c0h
cir7	dw	6
	dw	-3*lconst,1c0h
	dw	-2*lconst,7f0h
	dw	-lconst,7f0h
	dw	0,7f0h
	dw	lconst,7f0h
	dw	2*lconst,1c0h
cir8	dw	7
	dw	-3*lconst,3c0h
	dw	-2*lconst,07e0h
	dw	-lconst,0ff0h
	dw	0,0ff0h
	dw	lconst,0ff0h
	dw	2*lconst,7e0h
	dw	3*lconst,3c0h
cir9	dw	7
	dw	-3*lconst,03e0h
	dw	-2*lconst,07f0h
	dw	-lconst,0ff8h
	dw	0,0ff8h
	dw	3*lconst,03e0h
	dw	2*lconst,07f0h
	dw	lconst,0ff8h
cir10	dw	7
	dw	-3*lconst,07e0h
	dw	-2*lconst,0ff0h
	dw	-lconst,1ff8h
	dw	0,1ff8h
	dw	3*lconst,07e0h
	dw	2*lconst,0ff0h
	dw	lconst,1ff8h
cir11	dw	8
	dw	-4*lconst,03e0h
	dw	-3*lconst,0ff8h
	dw	-2*lconst,1ffch
	dw	-lconst,1ffch
	dw	0,1ffch
	dw	lconst,1ffch
	dw	2*lconst,0ff8h
	dw	3*lconst,03e0h
cir12	dw	8
	dw	-4*lconst,07e0h
	dw	-3*lconst,1ff8h
	dw	-2*lconst,3ffch
	dw	-lconst,3ffch
	dw	0,3ffch
	dw	lconst,3ffch
	dw	2*lconst,1ff8h
	dw	3*lconst,07e0h
cir13	dw	9
	dw	-4*lconst,03e0h
	dw	-3*lconst,0ff8h
	dw	-2*lconst,1ffch
	dw	-lconst,3ffeh
	dw	0,3ffeh
	dw	lconst,3ffeh
	dw	2*lconst,1ffch
	dw	3*lconst,0ff8h
	dw	4*lconst,03e0h
cir14	dw	10
	dw	-5*lconst,07e0h
	dw	-4*lconst,1ff8h
	dw	-3*lconst,3ffch
	dw	-2*lconst,7ffeh
	dw	-lconst,7ffeh
	dw	0,7ffeh
	dw	lconst,7ffeh
	dw	2*lconst,3ffch
	dw	3*lconst,1ff8h
	dw	4*lconst,07e0h
cir15	dw	11
	dw	-5*lconst,03e0h
	dw	-4*lconst,0ff8h
	dw	-3*lconst,3ffeh
	dw	-2*lconst,3ffeh
	dw	-lconst,7fffh
	dw	0,7fffh
	dw	lconst,7fffh
	dw	5*lconst,03e0h
	dw	4*lconst,0ff8h
	dw	3*lconst,3ffeh
	dw	2*lconst,3ffeh
cir16	dw	11
	dw	-5*lconst,07e0h
	dw	-4*lconst,1ff8h
	dw	-3*lconst,7ffeh
	dw	-2*lconst,7ffeh
	dw	-lconst,0ffffh
	dw	0,0ffffh
	dw	lconst,0ffffh
	dw	5*lconst,07e0h
	dw	4*lconst,1ff8h
	dw	3*lconst,7ffeh
	dw	2*lconst,7ffeh
	
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

MILKY	DW	NWDS*MXSTRS DUP (?)
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


.proc	drawdisc	auto		; draws a damn disc
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	mov	dx,3ceh		; dx := graphics controller port addr
	mov	ah,n		; set color to n
	xor	al,al
	out	dx,ax		; put color selection in set/reset reg
	mov	ax,0f01h
	out	dx,ax		; put 0fh in bit plane enable
	mov	ah,0
	mov	al,3
	out	dx,ax		; 0 for the RWM bits of the ALU
	mov	ax,0305h	; write mode 3 select
	out	dx,ax
	mov	ah,-1		; set bits
	MOV	DX,03CEH		; ADDR PORT
	MOV	AL,8			; SELECT BIT MASK REG
	OUT	DX,AX			; CHOOSE REGISTER
	mov	ax,-1		; set bits
	ENDIF
	mov	bx,yc			; check out possibilities
	mov	ax,xw
	cmp	ax,1024			; make x size allowed today
	jl	ddlm2
	mov	ax,1023
ddlm2:
	push	ax
	mov	dx,45397		; has to do with aspect ratio
	mul	dx
	mov	yw,dx			; set actual y size
	pop	ax
	sar	dx,1			; divide diameter by 2
	sub	bx,dx
	cmp	bx,[si+6]		; see if no way sphere can be drawn
	jg	ddbag
	mov	bx,yc
	add	bx,dx
	cmp	bx,[si+2]
	jl	ddbag
	or	ax,ax			; check size
	jns	ddlm1			; do bounds check
ddbag:	ret
ddbagp:	
	jmp	ddbagp1
ddlm1:
	cmp	ax,17
	jns	ddl0
	jmp	smldisc			; if small, go to small code
ddl0:	
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
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
	ENDIF	
	mov	ax,yc		; get basic di address
;	mov	bx,0		;
;	pixadd			; get bx with proper value
;	mov	cx,ax		; multiply y by 80
;	shl	ax,1		; mult by 4
;	shl	ax,1		; mult by 4
;	add	ax,cx		; not it's by 5
;	mov	cl,4		; now by 16
;	shl	ax,cl
;	add	bx,ax		; add in y offset
	mov	dx,bpl		; do signed multiply
	imul	dx
	mov	bx,ax		; leave result in bx
	.abs_d	dx,ax
	or	dx,dx
	jnz	ddbagp		; sph ctr tooo far away
	or	tempsum,ax	; fakey fakey
	mov	ax,vgseg	; load es with proper segment
	mov	es,ax

	mov	yline,bx	; put in variables
	mov	tyline,bx	; put in variables

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
	IF (vgmode EQ 81h)
	mov	ax,yc			; get y coord of center
	mov	argy1,ax
	mov	argy2,ax
	mov	y_up,ax
	mov	y_down,ax
	call	clip
	call	hgcline
	ENDIF
;	mov	yline,ax
;	mov	tyline,ax
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	mov	di,yline		; set up start address
	call	rawhlinewin			; draw center line
	ENDIF
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
	add	di,bpl
	cmp	di,[si+22]		; are we less than the max?
	jl	ylnok			; yes, then continue on
	sub	di,bpl
ylnok:
	IF (vgmode EQ 81h)
	dec	y_up
	inc	y_down
	ENDIF
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
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	call	rawhlinewin			; finally write the darn line!
	ENDIF
	IF (vgmode EQ 81h)
	mov	ax,y_up			; get y coord of center
	mov	argy1,ax
	mov	argy2,ax
	call	clip
	call	hgcline
	ENDIF
	mov	di,tyline
;	dec	ax
	sub	di,bpl
	jns	tylnok
	add	di,bpl
tylnok:
	mov	tyline,di
;	mov	argy1,ax
;	mov	argy2,ax
	IF (vgmode EQ 81h)
	mov	ax,y_down		; get y coord of center
	mov	argy1,ax
	mov	argy2,ax
	call	clip
	call	hgcline
	ENDIF
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	call	rawhlinewin			; finally write the darn line!
	ENDIF
	pop	cx
	loop	cbtlp			; do another line
cbtlpd:	pop	ax
	pop	ax			; bag two useless items
ddbagp1:
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	mov	dx,3ceh		; dx := graphics controller port addr
	mov	ax,5
	out	dx,ax		; write mode 0
	xor	ax,ax
	out	dx,ax
	inc	ax
	out	dx,ax
	ENDIF
	clc			; give no error flag
smlbag:	ret

smldisc:
	mov	ax,yc		; set up for correct pixel address
	mov	bx,xc
	cmp	bx,[si]		; see if in window
	js	smlbag		; out of window, forget disc
	cmp	bx,[si+4]
	jns	smlbag
	cmp	ax,[si+2]
	js	smlbag
	cmp	ax,[si+6]
	jns	smlbag
	pixadd
smld1:
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
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
	ENDIF
	IF vgmode EQ 81h
	push	bx
	push	ax
	push	dx
	mov	al,n
	xor	ah,ah
	mov	bx,offset @dataseg:bkclrs
	xlat
	mov	bkbits,al
	pop	dx
	pop	ax
	pop	bx
	ENDIF
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
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	xchg	es:[di+bx],ah	; write 3 bytes of data
	xchg	es:[di+bx+1],al	; write 3 bytes of data
	xchg	es:[di+bx+2],dh	; write 3 bytes of data
	ENDIF
	IF vgmode EQ 81h
	not	ah		; clear out writable bits
	and	es:[di+bx],ah
	not	ah
	and	ah,bkbits
	or	es:[di+bx],ah
	not	al		; clear out writable bits
	and	es:[di+bx+1],al
	not	al
	and	al,bkbits
	or	es:[di+bx+1],al
	not	dh		; clear out writable bits
	and	es:[di+bx+2],dh
	not	dh
	and	dh,bkbits
	or	es:[di+bx+2],dh
	ENDIF
	loop	ddl6


	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)

	mov	dx,3ceh		; dx := graphics controller port addr
	mov	ax,5
	out	dx,ax		; write mode 0
	xor	ax,ax
	out	dx,ax
	inc	ax
	out	dx,ax
	ENDIF
	ret

.endp

.proc	rawhlinewin	auto
	cmp	di,[si+20]	; see if di below max
	jge	rhl0
	jmp	hordone
rhl0:	cmp	di,[si+22]	; make sure we're less than maximum
	jl	rhl1
bagit:	jmp	hordone
rhl1:
	add	di,vboff	; switch for proper animation frame
	mov	ax,argx2	; check for x2>x1
	mov	bx,argx1	; do the same sort of checks with x1
	cmp	ax,bx
	jge	x2bigger	; do we reverse the order?
	xchg	ax,bx
x2bigger:
	cmp	ax,[si]	; see if line not in window
	jl	bagit
	cmp	ax,[si+4]	; see if extends past window
	jl	rhl2
	mov	ax,[si+4]	; yes, then limit max x
rhl2:
	cmp	bx,[si+4]	; is there any work to do here?
	jge	bagit
	cmp	bx,[si]		; keep in window
	jge	rhl3
	mov	bx,[si]
rhl3:
	sub	ax,bx
	jz	bagit		; bag lines of zero length
dd1:	
	mov	cx,ax	; see what scale we're talking, here
	sub	cx,8
	jg	dd2	; if bigger than 8, skip ahead
	mov	cx,ax	; put count in ax
	dec	cx
	mov	ax,08000h ; make mask
	sar	ax,cl
	mov	dx,bx
	mov	cl,3
	shr	bx,cl
	and	dx,7
	mov	cx,dx
	add	di,bx

	
	shr	ax,cl
	and	ax,bhlinemask
	xchg	es:[di],ah
	inc	di
	xchg	es:[di],al
	jmp	hordone

dd2:	cmp	cx,8		; is npts > 16?
	jg	dd3		; yes, continue with other code
	mov	ax,0ff00h	; make big bit mask
	sar	ax,cl		; ax will hold upto 16 bit mask

	mov	dx,bx
	mov	cl,3
	shr	bx,cl
	add	di,bx
	mov	cx,dx
	xor	dx,dx
	and	cx,7

	jz	dd4		; don't shift once if count=0
dd5:	shr	ax,1		; shift mask to starting position
	rcr	dx,1
	loop	dd5
	and	ax,bhlinemask
	and	dh,hlinemask
dd4:	xchg	es:[di],ah	;
	inc	di
	xchg	es:[di],al
	inc	di
	xchg	es:[di],dh
	jmp	hordone

dd3:	mov	npts,cx	; save number of points - 8
	mov	dx,bx
	mov	cl,3
	shr	bx,cl
	add	di,bx
	mov	cx,dx
	xor	dx,dx
	and	cx,7

	add	npts,cx
	mov	al,hlinemask
	shr	al,cl
	xchg	al,es:[di]
	inc	di
	mov	cx,npts
	shr	cx,1		; how many bytes to write?
	shr	cx,1
	shr	cx,1

dd7:	mov	al,hlinemask
	cld
	rep stosb
dd9:	mov	cx,npts
	and	cl,7
	xor	al,al
	mov	ah,hlinemask
	shr	ax,cl
	xchg	al,es:[di]
hordone:
	clc
	ret
.endp



IF	(vgmode EQ 10h) or (vgmode EQ 81h)
	brthk	equ 4
ENDIF
IF	vgmode EQ 0dh
	brthk	equ 2
ENDIF


.proc	thckbar	auto		; draws a vertical bar 1 byte wide
				; di=start addr cx= ysize
				; assumes controller in wrt mode 3
	mov	al,-1
	add	di,vboff	; start in correct page
thckbl:	stosb
	add	di,bpl-1		; 80 -1 for stosb advance
	loop	thckbl
	ret
.endp

.proc	thckh	auto		; draws a thick horiz line 4 deep
				; di= start addr
				; cx= # bytes to write
	mov	bx,brthk		; line count
	call	fillbx		; fill box
	ret
.endp

.proc	fillbx	auto		; fill a box with data
	.push	ax,dx
	MOV	DX,03CEH		; ADDR PORT
	MOV	Ax,0ff08h		; SELECT BIT MASK REG
	OUT	DX,AX			; CHOOSE REGISTER
	.pop	ax,dx
	mov	fbxindx,bx	; save box vertical size
	add	di,vboff	; add offset of current buffer
	mov	bx,di		; save start addr
	mov	si,cx		; save count
fbxlp:	rep	stosw		; write bar
	mov	cx,si		; restore count
	add	bx,lconst	; goto next line
	mov	di,bx
	dec	fbxindx		; decrement box count size
	jnz	fbxlp
	ret
.endp

.proc	scrfbx	auto		; do above, but set controller registers
		mov	ax,vgseg
		mov	es,ax
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	mov	dx,3ceh		; dx := graphics controller port addr
	mov	ah,n		; set color to n
	xor	al,al
	out	dx,ax		; put color selection in set/reset reg
	mov	ax,0f01h
	out	dx,ax		; put 0fh in bit plane enable
	mov	ah,0
	mov	al,3
	out	dx,ax		; 0 for the RWM bits of the ALU
	mov	ax,0305h	; write mode 3 select
	out	dx,ax
	mov	ax,-1		; set bits
	ENDIF
	call	fillbx		; call real routine
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	mov	dx,3ceh		; dx := graphics controller port addr
	xor	ax,ax
	out	dx,ax		; write mode 0
	inc	ax
	out	dx,ax
	mov	al,3
	out	dx,ax
	mov	ax,5
	out	dx,ax		; write mode 0
	mov	ax,0ff08h
	out	dx,ax
	ENDIF
	ret
.endp


.proc	epage	auto		; erases the page pointed to by bx
	.push	ax,dx
	MOV	DX,03CEH		; ADDR PORT
	MOV	Ax,0ff08h		; SELECT BIT MASK REG
	OUT	DX,AX			; CHOOSE REGISTER
	.pop	ax,dx
	push	dx
	mov	dx,3ceh		; dx := graphics controller port addr
	mov	ah,0
	xor	al,al
	out	dx,ax		; put color selection in set/reset reg
	mov	ax,0f01h
	out	dx,ax		; put 0fh in bit plane enable
	mov	ah,0
	mov	al,3
	out	dx,ax		; 0 for the RWM bits of the ALU
	mov	ax,0305h	; write mode 3 select
	out	dx,ax
		mov	ax,vgseg
		mov	es,ax
		mov	di,vboff
		mov	cx,8000
	mov	ax,-1
;	rep	stosw
	mov	bx,95
	mov	cx,19
	mov	di,20341
;	call	fillbx		; erase contents of other window
	mov	ah,brdrclr	; make these bars grey
	xor	al,al
	out	dx,ax		; put color selection in set/reset reg
	mov	si,ptrgwinf	; load window info
;	mov	di,gfymin*bpl		; make a vertical bar
	mov	di,[si+20]	; mininmum
	dec	di		; take off the stupid offset
	mov	cx,[si+10]	; gfymax-gfymin
	call	thckbar		; do it up!
	mov	si,ptrgwinf	; load window info
;	mov	di,gfymin*bpl+bpl-1
	mov	di,[si+20]	; mininmum
	dec	di		; take off the stupid offset
	add	di,bpl-1	; add enough  to pt to eol
;	mov	cx,gfymax-gfymin
	mov	cx,[si+10]	; gfymax-gfymin
	call	thckbar		; do it up!


	mov	ax,-1
	mov	di,vboff
	mov	cx,brthk*bpl
	rep	stosw		; write horiz bar at top
	mov	di,vboff
;	add	di,15920	; write horiz bar at bottom of main window
	mov	si,ptrgwinf	; load window info
;	add	di,gfymax*bpl
	add	di,[si+22]	; get the data
	mov	cx,brthk*bpl
;	mov	cx,200
	rep	stosw

	cmp	ptrgwint,0
	jz	nolowfrm
;	mov	di,20020	; write one horiz for left win
	mov	di,gtmnb-(brthk*bpl)-1-bpl
;	mov	cx,20
	mov	cx,(gtxmax-gtxmin+1)/16+1
	mov	bx,brthk+1
	call	fillbx
;	mov	di,27540	; bottom of rear window
	mov	di,((vysiz-brthk-1)*bpl)+(gtxmin/8)-bpl-1

;	mov	cx,20
	mov	cx,(gtxmax-gtxmin+1)/16+1
	mov	bx,brthk+1
	call	fillbx
;	IF vgmode EQ 10h
;	jmp	nolowfrm
;	ENDIF
;	mov	di,20340
	mov	di,gtmnb-1
;	mov	cx,96
	mov	cx,gtymax-gtymin+1
	call	thckbar
;	mov	di,20379
	mov	di,gtmnb+(gtxmax-gtxmin+1)/8
;	mov	cx,96
	mov	cx,gtymax-gtymin+1
	call	thckbar

nolowfrm:
	mov	dx,3ceh		; dx := graphics controller port addr
	mov	ax,5
	out	dx,ax		; write mode 0
	xor	ax,ax
	out	dx,ax
	pop	dx
	ret
.endp	

.proc	clearwindows auto
	cmp	wrpflg,0
	jnz	eraserear
	mov	bl,clrwinf
	mov	n,bl
	push	si
	mov	si,ptrgwinf	; get window info
	mov	bx,[si+10]	; ysize
	mov	cx,[si+8]	; xsize in pixels
	inc	cx		; add one for good measure
	rept	4
	shr	cx,1		; divide by 16
	endm
	mov	di,[si+20]
	pop	si
	call	scrfbx		; erase contents of other window
eraserear:
	mov	bl,clrwint
	mov	n,bl
	mov	bx,gtymax-gtymin
	mov	cx,(gtxmax-gtxmin+1)/16
	mov	di,gtmnb
	call	scrfbx		; erase contents of other window
	ret
.endp


.proc	strtadr	auto		; sets the start address of the ega to an adr
	push	dx		; given in ax
	push	ax
	mov	ax,40h		; bios segment
	mov	es,ax
	pop	ax
	mov	es:[4eh],ax
	mov	dx,3d4h		; point to the address register
	cli			; turn off ints to stop tsrs
	mov	al,0ch
	out	dx,al		; select the start addr high register
 	inc	dx		; now point to the data register
	mov	al,ah
	out	dx,al		; change the register value
	sti			; re-enable ints
	mov	dx,3d4h		; point to the address register
	cli			; turn off ints to stop tsrs
	mov	al,0dh
	out	dx,al		; select the start addr high register
 	inc	dx		; now point to the data register
	mov	al,bl
	out	dx,al		; change the register value
	sti			; re-enable ints
	pop	dx
	ret
.endp

.proc	flipage	auto		; flips the page of the board
	xor	bl,bl		; wow!
	xor	pgflg,-1	; invert all the bits in pageflag
	jz	flpbk		; flip back to original
	mov	vboff,0		; change to other page 
	mov	ah,7eh		; display other page
	mov	al,bl
	call	strtadr
	ret
flpbk:	mov	vboff,07e00h	; now draw in page 2
	xor	ah,ah		; while we display page 1
	mov	al,bl
	call	strtadr
	ret
.endp

.proc	readskycolor	auto
	cli
	mov	dx,3dah
	in	al,dx		; reset flip flop
	mov	dx,3c0h
	mov	al,11		; this is the color of the sky
	out	dx,al		; set address
	inc	dx		; read from 3c1h port
	in	al,dx
	mov	clrbits,al	; save in variable

	mov	dx,03c7h	; prepare to read from vga
	out	dx,al		; set address of color reg desired
	mov	dx,03c9h	; point to data register
	mov	si,offset @dataseg:colordata
rept	3
	in	al,dx
	mov	[si],al
	inc	si
endm
	mov	dx,3dah
	in	al,dx		; reset flip flop
	mov	dx,3c0h
	mov	al,20h		; set PAS bit in attrib controller reg
	out	dx,al		; set address
	sti
	ret
.endp	

.proc	fadesky	auto		; 0-255 factor in bl
	mov	al,clrbits		; get palette value to change
	mov	dx,03c8h	; prepare to read from vga
	out	dx,al		; set address of color reg desired
	mov	dx,03c9h	; point to data register
	mov	si,offset @dataseg:colordata
rept	3
	mov	al,[si]
	mul	bl
	mov	al,ah
	out	dx,al
	inc	si
endm
	ret
.endp


RAND	PROC	NEAR			; GENERATES RAND# FROM 0-N N IN AX
	PUSH	BX
	PUSH	DX
	PUSH	AX
	CALL	rand_w
	POP	BX
	MUL	BX
	MOV	BX,65535
	DIV	BX
	POP	DX
	POP	BX
	RET
RAND	ENDP

RANSTR1	PROC	NEAR			; FILLS ONE STAR WITH RANDOMNESS
	PUSH	AX
	PUSH	BX			; ASSUME BX HAS STAR BASE ADR
	REPT	2
	  MOV	  AX,XYRNGE
	  CALL	  RAND
	  SUB	  AX,XYRNGE2
	  MOV	  [BX],AX
	  ADD	  BX,2
	ENDM
	MOV	AX,ZRNGE
	mov	ax,zi
	add	[bx],ax
	and	[bx],07fffh
	CMP	CLRFLG,0
	JZ	MONOST1			; MONOCHROME STARS
	MOV	AX,32			; 8 DIFFERENT COLORS
	CALL	RAND			; GET RANDOM COLOR
	INC	AL			; NO BLACK STARS
	CMP	AL,8			; MAKE SURE NO COLOR BIGGER THAN 7
	JB	RNST11
MONOST1:	MOV	AL,7
RNST11:
RNST91:	POP	BX
	POP	AX
	RET
RANSTR1	ENDP


RANSTR	PROC	NEAR			; FILLS ONE STAR WITH RANDOMNESS
	PUSH	AX
	PUSH	BX			; ASSUME BX HAS STAR BASE ADR
	REPT	2
	  MOV	  AX,XYRNGE
	  CALL	  RAND
	  SUB	  AX,XYRNGE2
	  MOV	  [BX],AX
	  ADD	  BX,2
	ENDM
	MOV	AX,ZRNGE
	CALL	RAND
	MOV	[BX],AX
	CMP	CLRFLG,0
	JZ	MONOST			; MONOCHROME STARS
	MOV	AX,32			; 8 DIFFERENT COLORS
	CALL	RAND			; GET RANDOM COLOR
	INC	AL			; NO BLACK STARS
	CMP	AL,8			; MAKE SURE NO COLOR BIGGER THAN 7
	JB	RNST1
MONOST:	MOV	AL,7
RNST1:	XOR	AH,AH
	XCHG	AH,AL
	MOV	[BX+4],AX
	MOV	AX,-1
	MOV	[BX+2],AX
RNST9:	POP	BX
	POP	AX
	RET
RANSTR	ENDP


RANMIL	PROC	NEAR			; FILLS MILKY WAY WITH RANDOM INFO
	MOV	CX,NSTARS
	MOV	BX,offset @dataseg:milky	; OFFSET OF MILKY WAY
RM1:	CALL	RANSTR
	ADD	BX,0AH			; ADVANCE TO NEXT STAR
	LOOP	RM1
	RET
RANMIL	ENDP



EPSTR	PROC	NEAR			; CGA PSTARS
	MOV	SI,offset @dataseg:milky	; LOAD BASE OF GALAXY
	MOV	DI,NSTARS		; LOAD # OF STARS TO DISPLAY
	MOV	BP,PLORGZ		; GET THIS CONSTANT INTO BP
	MOV	AX,vgseg		; VIDEO BUFFER SEGMENT
	MOV	ES,AX			; LEAVE IN ES
	MOV	DX,3CEH			; SET PORT TO GC ADDR REG
;	MOV	AL,8			; SELECT BIT MASK REG
;	OUT	DX,AX			; CHOOSE REGISTER
	MOV	AX,205H			; AL := MODE REGISTER #
	OUT	DX,AX			; AH := WRT MODE 2 (BITS0,1)
	MOV	AH,0			; REPLACE CODE IN READ-MOD-WRITE BITS
	MOV	AL,3			; ADDR OF SELECT/ROTATE REG
	OUT	DX,AX
	ASSUME DS:NOTHING
EPST1:	
ESTXY1:	MOV	AX,[SI]			; GET STAR X COORD
	MOV	BX,[SI+4]		; STAR Z COORD
	ADD	BX,ZI			; MOVE Z COORD UP BY ZI
	JNS	ETXY52			; IF NON-NEG, IGNORE WHOLE THING
etxy50:
ETXY51:	SHL	BX,1
	SHR	BX,1			; CLEAR HI BIT
ETXY52:	MOV	[SI+4],BX		; SAVE NEW STAR Z COORD
ESTXY4:	IMUL	BP			; STAR.X * PLORG.Z
	CMP	BX,BP
	JA	ESTXY6			; IF STAR ISN'T TOO CLOSE, SKIP NEXT
	PUSH	DX
	PUSH	AX
	MOV	CX,-PLORGX		; PLANE X ORG
	IDIV	CX			; DIVIDE BY PLANE SIZE
	OR	AX,AX			; IF AX IS NEG, MAKE POSITIVE
	JNS	ESTXY5
	NEG	AX
ESTXY5:	CMP	AX,BX
	POP	AX
	POP	DX
	JB	ESTXY6
ESTXY9:	JMP	ESTXY2
ESTXY6:	IDIV	BX			; NOW AX HAS XPROJECTION ON VIEW PLANE
	SUB	AX,PLORGX		; SUBTRACT NEG ORIGIN, TO MAKE 0-XYRNGE
	JS	ESTXY9			; ABORT IF PROJECTION IS NEGATIVE
	SHR	AX,1			; DIVIDE X COORD BY TWO
	CMP	AX,XBIG
	JNS	ESTXY2
;	JMP	STXY2
ESTXYA:	MOV	CX,AX			; SAVE X COORD
	MOV	AX,[SI+2]		; GET STAR Y COORD
	IMUL	BP			; START CALCS FOR PROJECTION
	CMP	BX,BP			; IF STAR Z IS > PLORG Z, THEN SKIP
	JA	ESTXY8			; THIS NEXT PART
	PUSH	DX
	PUSH	AX
	PUSH	CX
	MOV	CX,-PLORGY		; PLANE Y ORG
	IDIV	CX			; DIVIDE BY PLANE SIZE
	POP	CX
	OR	AX,AX			; IF AX IS NEG, MAKE POSITIVE
	JNS	ESTXY7
	NEG	AX
ESTXY7:	CMP	AX,BX
	POP	AX
	POP	DX
	JB	ESTXY8
	JMP	ESTXY2
ESTXY8:	IDIV	BX			; AX HAS PROJECTION ON PLANE
	SUB	AX,-200
	JS	ESTXY2			; ABORT IF NEGATIVE
	CMP	AX,400
	JAE	ESTXY2
	SHR	AX,1			; DIVIDE BY 2 TO SCALE INTO 0-350
ESPLOT:	jmp	esplt2
ESTXY2:	MOV	AX,-1			; SET NO-PLOT FLAG
ESPLT2:	
	PUSH	AX			; SAVE AX
	CMP	CS:WRPFLG,0
	JS	EVADR1
	MOV	BX,[SI+6]		; GET OLD PLOT ADDR (OR -1)
	MOV	AH,[SI+8]		; WORD CONTAINING PLOTTED BIT

IF 1 EQ 0
	CMP	AH,0FFH	; IS NO-PLOT FLAG SET?
	JZ	EVADR1			; DON'T UN-PLOT
	MOV	DX,03CEH		; ADDR PORT
	MOV	AL,8			; SELECT BIT MASK REG
	OUT	DX,AX			; CHOOSE REGISTER
;	MOV	AX,205H			; AL := MODE REGISTER #
;	OUT	DX,AX			; AH := WRT MODE 2 (BITS0,1)
;	MOV	AH,0			; REPLACE CODE IN READ-MOD-WRITE BITS
;	MOV	AL,3			; ADDR OF SELECT/ROTATE REG
;	OUT	DX,AX
	add	bx,vboff
	MOV	DL,ES:[BX]		; LATCH FROM BIT PLANE
	XOR	DL,DL			; NEW PIXEL VALUE
	MOV	ES:[BX],DL
ENDIF
EVADR1:	
	POP	AX
	OR	AX,AX			; IF AX<0, THEN NO PLOT
	JS	EVABT
	MOV	BX,CX			; RESTORE X COORD
;	MOV	CL,BL			; CL := LOW ORDER BYTE OF X
	MOV	DX,80			; 80 BYTES PER LINE
	MUL	DX			; CALC OFFSET
	SHR	BX,1
	SHR	BX,1
	SHR	BX,1			; BX := X/8
	ADD	BX,AX			; BX := #BYTESPERLINE*Y + X/8
	AND	CL,7			; CL = X&7
	XOR	CL,7			; # OF BITS TO SHIFT LEFT
	MOV	AH,1			; UNSHIFTED BIT MASK
	SHL	AH,CL			; SET BIT IN CORRECT BYTE POS
	MOV	[SI+8],AH		; SAVE BIT #
;	PUSH	AX			; SAVE AX
	MOV	DX,03CEH		; ADDR PORT
	MOV	AL,8			; SELECT BIT MASK REG
	OUT	DX,AX			; CHOOSE REGISTER
;	MOV	AX,205H			; AL := MODE REGISTER #
;	OUT	DX,AX			; AH := WRT MODE 2 (BITS0,1)
;	MOV	AH,0			; REPLACE CODE IN READ-MOD-WRITE BITS
;	MOV	AL,3			; ADDR OF SELECT/ROTATE REG
;	OUT	DX,AX
	add	bx,vboff
	MOV	AL,ES:[BX]		; LATCH FROM BIT PLANE
	MOV	DL,8			; DEFAULT IS HIGH INTENSITY
	MOV	AX,[SI+4]
	CMP	AX,26000		; SEE IF REALLY FAR AWAY
	JA	EP3			; IF SO, SHOW AS VERY DIM
	CMP	AX,20000		; SEE IF FAR AWAY
	JB	EP2			; YES
	XOR	DL,DL			; LOW INTENSITY
EP2:	ADD	DL,[SI+9]		; COLOR
EP3:	MOV	ES:[BX],DL
	MOV	[SI+6],BX		; SAVE ADDRESS OF STAR
EP1:	ADD	SI,NWDS*2		; ADVANCE SI
	DEC	DI
	JZ	EPST2
	JMP	EPST1
EPST2:	
	RET

EVABT:	MOV	[SI+6],BX		; SAVE ADDRESS OF STAR
	MOV	[SI+8],AH		; SAVE BIT #
	JMP	SHORT EP1

EPSTR	ENDP


.public		main
.proc		main		AUTO

IF qmode EQ 0
	mov	ax,vgmode
	int	10h
ENDIF
	call	arg_count
	mov	regflag,cl		; non zero means registered version
	mov	exitflag,0
	mov	ax,0f00h
	int	10h			; make sure we are in graphics mode
	cmp	al,vgmode		; is it correct?
	jz	modeok			; yes, continue
	mov	si,offset @dataseg:panicmsg		; no, panic and exit
	call	put_str
	mov	al,1
	jmp	exit			; exit with error code set
modeok:

	call	ranmil			; fill the stars with data
	cmp	exitflag,0
	jnz	skiprsc
	call	readskycolor
skiprsc:
	mov	ax,40h
	mov	es,ax		; talk to segment 40
	mov	ax,es:[6ch]	; get Nticks
	mov	tcount,ax
	mov	cx,30*18
	mov	nframes,0
ratloop:
;	push	cx
	cmp	nframes,fadeframe
	jae	nfrmpp
	inc	nframes
nfrmpp:
	mov	ax,nframes
	cmp	ax,fadeframe
	jae	skipet
	sub	ax,fadeframe
	neg	ax
	mul	ax
	mov	bx,1024
	mul	bx
	mov	bx,(fadeframe)*(fadeframe)
	div	bx
	mov	earthsize,ax
skipet:
	mov	ax,nframes
	cmp	ax,fadeframe
	jae	skipet1
	mov	dx,255
	mul	dx
	mov	bx,fadeframe
	div	bx
	sub	ax,255
	neg	ax
	js	skipet1
	mov	fadeclr,al
	jmp	clrset
skipet1:
	cmp	exitflag,0
	jz	clrset0
	cmp	vboff,0
	jnz	rightpage
	call	flipage
rightpage:
	mov	ax,1
	jmp	exit
clrset0:
	mov	fadeclr,0
clrset:

	mov	bl,fadeclr
	call	fadesky

	call	clearwindows

	cmp	nframes,fadeframe/2
	jb	skipstars
	call	epstr
skipstars:

	cmp	nframes,fadeframe
	jae	skipearth
	cmp	exitflag,0
	jz	skipplanet

	mov	si,ptrgwinf
	mov	ax,[si+16]
	mov	xc,ax
	mov	ax,[si+18]
	mov	yc,ax
	mov	ax,100
	mov	xw,ax
	mov	n,2
	call	drawdisc
	jmp	skipearth
skipplanet:
	mov	si,ptrgwint
	mov	ax,[si+16]
	mov	xc,ax
	mov	ax,[si+18]
	mov	yc,ax
	mov	ax,earthsize
	mov	xw,ax
	mov	n,2
	call	drawdisc
skipearth:
	call	epage
	call	flipage


	mov	ax,40h
	mov	es,ax		; talk to segment 40
	mov	cx,65535
twaitlp:
	mov	ax,es:[6ch]	; get Nticks
	cmp	ax,tcount	; wait for timer to tick
	loopz	twaitlp
	mov	tcount,ax


	mov	ah,1
	int	16h		; check keyboard status
	jnz	qkey

afterkey:
;	pop	cx
;	loop	ratloop1

	cmp	wrpflg,0
	jz	nofrminc
	inc	warpframes
	cmp	warpframes,270
	ja	flashaway
nofrminc:

	jmp	ratloop1
flashaway:
	cmp	regflag,0
	jnz	ratreg
	mov	clrwinf,0bh
	mov	clrwint,0bh
	mov	wrpflg,0
	mov	colordata,63
	mov	colordata+1,63
	mov	colordata+2,63
	call	clearwindows
	call	flipage
	call	clearwindows
	mov	exitflag,-1
	jmp	modeok
ratreg:
	mov	wrpflg,0
ratloop1:
	jmp	ratloop
qkey:	mov	ah,0
	int	16h
	cmp	al,1bh		; check for escape
	jz	ratloop2
	cmp	al,0dh		; check for return
	jnz	afterkey
	xor	wrpflg,-1
	jmp	afterkey
ratloop2:

IF qmode EQ 0
	mov	ax,3
	int	10h
	mov	ax,warpframes
	mov	si,offset @dataseg:kbuf
	call	words_to_dec
	call	put_str
	call	get_chr
ENDIF

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
