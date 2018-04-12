	title 'ega-line'

				; this subroutine plots a line on an ega
				; screen
				; This code is lifted from the book
				; 'Programmer's guide to PC, and PS/2
				; Video systems by Richard Wilton
_MODEL	equ	<SMALL>
include	model.inc
include	imath.INC
include	extrns.inc		; get extrnals
include 3dvid.inc


	public	hline		; the entry point into subroutine
	public	clrup		; sky color
	public	clrdn		; ground color

	extrn	pixeladdr10:near	; address routine for pixel
	.extrn	put_str:auto
	.extrn	put_chr:auto
	.extrn	words_to_dec:auto

wxmin	equ	0
wymin	equ	2
wxmax	equ	4
wymax	equ	6
wxsiz	equ	8
wysiz	equ	10
zxpln	equ	12
zypln	equ	14
wxctr	equ	16
wyctr	equ	18

nxtlin	macro	
local	noinc
	add	di,c2000h
	jns	noinc
	add	di,lincr
	and	di,7fffh
noinc:
	endm

.dataseg
npxps		dw	0      ; number of pixels in x per y pt
smladd		dw	0	;
bigadd		dw	0
ynpts		dw	0	;
bigbits		dw	0	;
smlbits		dw	0
wnbig		dw	0
wnsml		dw	0
offl		dw	0
offr		dw	0
nleft		dw	0
nright		dw	0
nbig		db	0
nsml		db	0
lincr		dw	?
c2000h		dw	?
dotflg		db	0
clrup		db	0bh
clrdn		db	02h
clrrgt		db	?
clrlft		db	?
clrbot		db	?
clrtop		db	?
ylmin		dw	?
ylmax		dw	?
wxbytes		dw	?
	IF	vgmode EQ 81h
bkclrs		db	0,0,44h,0ffh,0,0,0,055h,0,-1,-1,-1,-1,-1,-1,-1
bkbits		db	0
ENDIF
distsum		dw	0
.ends

.codeseg
;assume		cs:@codeseg, 
	assume ds:@dataseg, es:@dataseg


.proc	hline	auto
	IF	vgmode EQ 81h
	mov	c2000h,2000h	; set line scatter stuff
	ENDIF
	mov	lincr,bpl	; number of bytes per line
klstrt:	
	mov	bx,[si+wxsiz]	; get x size of window in pixels
	dec	bx		; try to get boudary right
	shr	bx,1		; divide by eight
	shr	bx,1		; divide by eight
	shr	bx,1		; divide by eight
	inc	bx		; at least I'm trying!
	mov	wxbytes,bx
	mov	cl,clrup
	mov	dl,clrdn	; set up default colors
	mov	clrbot,cl	; set up some colors
	mov	clrtop,dl
	mov	clrlft,dl
	mov	clrrgt,cl
	mov	ax,argy2
	mov	ylmax,ax
	mov	bx,argy1	; set up default min and maxes
	mov	ylmin,bx
	sub	ax,bx		; is y2 > y1?
	jns	ynorml		; yes, don't reverse colors
	mov	clrrgt,dl
	mov	clrlft,cl
	mov	di,ylmin	; if y2<y1, exchange our assumed
	xchg	di,ylmax	; ylmin and ylmax
	mov	ylmin,di
ynorml:
	.abs_w	ax
	mov	distsum,ax	; keep track of line length
	mov	bx,argx1	; assume argx1 is less than argx2
	mov	ax,argx2	; now check on the x coords
	sub	ax,bx		; for color changes
	jns	xnorml		; everything ok?
	mov	bx,argx2	; I guess argx2 is smallest after all
	mov	clrbot,dl
	mov	clrtop,cl	; reverse up/down colors
xnorml:
	.abs_w	ax
	add	ax,distsum
	cmp	ax,8
	jg	linelong	; line is long enough for a valid slope
	stc
	ret
linelong:
	sub	bx,[si+wxmin]	; get distance from side
	shr	bx,1		; divide by 8
	shr	bx,1
	shr	bx,1
	mov	nleft,bx	; xmin is horray for whores!
	mov	ax,wxbytes	; get xsize in bytes
	sub	ax,nleft
	dec	ax
	mov	nright,ax	; this should be number of bytes to right

				; now fill the top and bottom of window
				; with the appropriate solid color
	mov	ax,[si+wymin]	; get the address of the lower right hand
	mov	bx,[si+wxmin]	; of the window
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	call	pixeladdr10	;
	ENDIF
	IF vgmode EQ 81h
	call	hgcpixad
	ENDIF
	mov	di,bx		; do it up!
	mov	cx,ylmin	; now find how many lines to write
	sub	cx,[si+wymin]
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	mov	dx,3ceh		; dx := graphics controller port addr
	mov	ah,clrbot	; set color
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
	mov	al,clrbot
	xor	ah,ah
	mov	bx,offset @dataseg:bkclrs
	xlat
	mov	bkbits,al
	pop	bx
	ENDIF
	mov	bx,wxbytes	; x size of window in bytes
	cld			; make sure we go forward
	or	cx,cx		; make sure we have some to do
	jz	nobot		; none to do, go ahead
	js	nobot		; this should never happen.....
	inc	cx		; do n+1 lines just to be sure
botlp:	push	cx		; now we are into the meat
	mov	cx,bx		; get line count in bytes
	mov	al,-1		; set all pixels per byte
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	rep	stosb
	sub	di,bx		; go to next line
	add	di,lconst	; number of bytes per lienb
	ENDIF
	IF vgmode EQ 81h
	and	al,bkbits
	rep	stosb
	sub	di,bx		; go to next line
	nxtlin
	ENDIF	
	pop	cx		; check line count
	loop	botlp		; go back for more punishment

nobot:	mov	cx,[si+wymax]	; get window max
	sub	cx,ylmax	; how many we'll have to do at the top
	jz	notop		; abort if no top writes needed
	js	notop		; again, this should never happen....
	mov	bp,cx		; save count
	xchg	bx,di
	mov	ax,ylmax	; start address at ylmax
	mov	bx,[si+wxmin]	;
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	call	pixeladdr10
	ENDIF
	IF vgmode EQ 81h
	call	hgcpixad
	ENDIF
	xchg	bx,di
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	mov	dx,3ceh		; dx := graphics controller port addr
	mov	ah,clrtop	; set color
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
	mov	al,clrtop
	xor	ah,ah
	mov	bx,offset @dataseg:bkclrs
	xlat
	mov	bkbits,al
	pop	bx
	ENDIF
	mov	cx,bp		; restore cx
toplp:	push	cx		; now we are into the meat
	mov	cx,bx		; get line count in bytes
	mov	al,-1		; set all pixels per byte
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	rep	stosb
	sub	di,bx		; go to next line
	add	di,lconst	; number of bytes per lienb
	ENDIF
	IF vgmode EQ 81h
	and	al,bkbits
	rep	stosb
	sub	di,bx		; go to next line
	nxtlin
	ENDIF	
	pop	cx		; check line count
	loop	toplp		; go back for more punishment
notop:
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	mov	dx,3ceh		; dx := graphics controller port addr
	mov	ax,5
	out	dx,ax		; write mode 0
	xor	ax,ax
	out	dx,ax
	inc	ax
	out	dx,ax
	ENDIF


	mov	ax,argx2	; get del y and del x
	sub	ax,argx1
	jns	ordrigt		; order is already right
	neg	ax
	mov	bx,argx2
	xchg	bx,argx1
	mov	argx2,bx
	mov	bx,argy2
	xchg	bx,argy1
	mov	argy2,bx
ordrigt:
	mov	si,ax		; save delta-x
	mov	bx,argy2
	sub	bx,argy1
	jns	yposit
	neg	lincr
	IF	vgmode EQ 81h
	neg	c2000h		; reverse direction of line scatter also
	ENDIF
	neg	bx
yposit:
	inc	bx		; give extra line for top and bottom
slpnzr:	
	cmp	bx,ax		; check for small slope
	js	slopok		; ok for now
	jz	slopok		; ignore slope =1 for now
	jmp	steep		; go to routine for steep lines

slopok:	
	or	ax,ax		; is delta-x zero?  If so, dx=dy=0
	jnz	nonz		; and there is no line to draw
	stc
	ret
nonz:	or	bx,bx		; check for horiz line
	jnz	nonhorz		; not horizontal, continue
	inc	bx		; give a delta y of at least 1
nonhorz:	xor	dx,dx
	idiv	bx		; get the slope
	cmp	ax,8		; make sure slope isn't too small
	js	slpfin
	jmp	smlslp		; small, slope.  Go to optimized routine
slpfin:	mov	npxps,ax	; save this min xpix per y
	xor	ax,ax		; now get fractional part
	sar	dx,1		; by dividing the remainder
	idiv	bx
	mov	smladd,ax	; here is the fractional part
	sub	ax,08000h
	mov	bigadd,ax	; here is the fractional part minus 1
	mov	cx,npxps
	mov	ax,0ff00h		; set up masks
	shr	ax,cl
	mov	dh,al
	xor	dl,dl
	mov	smlbits,dx
	shr	ax,1
	mov	ah,al
	xor	al,al
	mov	bigbits,ax
	mov	nbig,cl
	inc	nbig
	mov	nsml,cl
	mov	di,bx		; save line count
	mov	ax,argy1
	mov	bx,argx1
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	call	pixeladdr10
	ENDIF
	IF vgmode EQ 81h
	call	hgcpixad
	ENDIF
	sub	cl,7
	neg	cl
	xchg	di,bx		; put that in dx
	xor	ch,ch		; cx has x pixel #
	xor	si,si
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	mov	dx,3ceh		; dx := graphics controller port addr
	mov	ax,0f01h
	out	dx,ax		; put 0fh in bit plane enable
	mov	ah,0
	mov	al,3
	out	dx,ax		; 0 for the RWM bits of the ALU
	mov	ax,0305h	; write mode 3 select
	out	dx,ax
	ENDIF
;	jmp	ldone
	mov	ch,8
	mov	bp,smladd
	mov	ah,clrrgt
	xor	al,al
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	out	dx,ax
	ENDIF
	IF vgmode EQ 81h
	push	bx
	mov	al,ah
	xor	ah,ah
	mov	bx,offset @dataseg:bkclrs
	xlat
	mov	bkbits,al
	pop	bx
	ENDIF
bbyte:
	mov	ax,-1	; get mask
	shr	ax,cl		; shift in proper direction
	add	cl,nbig		; add to position
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	mov	es:[di],ah		; write latches
	ENDIF
	IF vgmode EQ 81h
	not	ah		; clear out writable bits
	and	es:[di],ah
	not	ah
	and	ah,bkbits
	or	es:[di],ah
	ENDIF
	push	ax
	push	cx
	push	di
	mov	cx,nright	; blast away to the right
	mov	al,-1
	inc	di
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	rep	stosb
	ENDIF
	IF vgmode EQ 81h
	and	al,bkbits
	rep	stosb
	ENDIF	
	mov	cx,nleft
	pop	di
	push	di
	std
	dec	di
	mov	ah,clrlft
	xor	al,al
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	out	dx,ax
	ENDIF
	IF vgmode EQ 81h
	push	bx
	mov	al,ah
	xor	ah,ah
	mov	bx,offset @dataseg:bkclrs
	xlat
	mov	bkbits,al
	pop	bx
	ENDIF
	mov	al,-1
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	rep	stosb
	ENDIF
	IF vgmode EQ 81h
	and	al,bkbits
	rep	stosb
	ENDIF	
	cld
	pop	di
	pop	cx
	pop	ax
	xor	ah,-1
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	xchg	es:[di],ah
	ENDIF
	IF vgmode EQ 81h
	push	ax
	not	ah		; clear out writable bits
	and	es:[di],ah
	not	ah
	and	ah,bkbits
	or	es:[di],ah
	pop	ax
	ENDIF
;	or	al,al		; more pixels?
;	jz	skp2
;	inc	di
;	xchg	es:[di],al		; write the second byte
;	dec	di
skp2:	
	IF (vgmode EQ 0dh) OR (vgmode EQ 10h)
	add	di,lincr
	ENDIF
	IF	vgmode EQ 81h
	nxtlin
	ENDIF
	mov	ah,clrrgt
	xor	al,al
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	out	dx,ax
	ENDIF
	IF vgmode EQ 81h
	push	bx
	mov	al,ah
	xor	ah,ah
	mov	bx,offset @dataseg:bkclrs
	xlat
	mov	bkbits,al
	pop	bx
	ENDIF
	test	cl,ch		; see if we need to proceed to next byte
	jz	skp3		; not yet
	sub	cl,ch
	inc	di
	dec	nright
	inc	nleft
skp3:	dec	bx
	jnz	jl449
	jmp	ldone
jl449:
	add	si,bigadd	; add a negative value
	js	jl451
	jmp	bbyte		; do we need another biggie?
jl451:

sbyte:
	mov	ax,-1	; get mask
	shr	ax,cl		; shift in proper direction
	add	cl,nsml		; add to position
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	mov	es:[di],ah		; write latches
	ENDIF
	IF vgmode EQ 81h
	push	ax
	not	ah		; clear out writable bits
	and	es:[di],ah
	not	ah
	and	ah,bkbits
	or	es:[di],ah
	pop	ax
	ENDIF
	push	ax
	push	cx
	push	di
	inc	di
	mov	cx,nright	; blast away to the right
	mov	al,-1
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	rep	stosb
	ENDIF
	IF vgmode EQ 81h
	and	al,bkbits
	rep	stosb
	ENDIF	
	mov	cx,nleft
	pop	di
	push	di
	std
	dec	di
	mov	ah,clrlft
	xor	al,al

	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	out	dx,ax
	ENDIF
	IF vgmode EQ 81h
	push	bx
	mov	al,ah
	xor	ah,ah
	mov	bx,offset @dataseg:bkclrs
	xlat
	mov	bkbits,al
	pop	bx
	ENDIF
	mov	al,-1
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	rep	stosb
	ENDIF
	IF vgmode EQ 81h
	and	al,bkbits
	rep	stosb
	ENDIF	
	cld
	pop	di
	pop	cx
	pop	ax
	xor	ah,-1
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	xchg	es:[di],ah
	ENDIF
	IF vgmode EQ 81h
	push	ax
	not	ah		; clear out writable bits
	and	es:[di],ah
	not	ah
	and	ah,bkbits
	or	es:[di],ah
	pop	ax
	ENDIF
;	or	al,al		; more pixels?
;	jz	sskp2
;	inc	di
;	xchg	es:[di],al		; write the second byte
;	dec	di
sskp2:	
	IF (vgmode EQ 0dh) OR (vgmode EQ 10h)
	add	di,lincr
	ENDIF
	IF	vgmode EQ 81h
	nxtlin
	ENDIF
	mov	ah,clrrgt
	xor	al,al
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	out	dx,ax
	ENDIF
	IF vgmode EQ 81h
	push	bx
	mov	al,ah
	xor	ah,ah
	mov	bx,offset @dataseg:bkclrs
	xlat
	mov	bkbits,al
	pop	bx
	ENDIF
	test	cl,ch		; see if we need to proceed to next byte
	jz	sskp3		; not yet
	sub	cl,ch
	inc	di
	dec	nright
	inc	nleft
sskp3:	dec	bx
	jnz	jl552
	jmp	ldone
jl552:
	add	si,bp	; add a positive value
	jns	jl558
	jmp	sbyte		; do we need another biggie?
jl558:
	jmp	bbyte

ldone:	
	mov	dx,3ceh		; dx := graphics controller port addr
	mov	ax,5
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	out	dx,ax		; write mode 0
	xor	ax,ax
	out	dx,ax
	inc	ax
	out	dx,ax
	ENDIF
	clc
	ret

smlslp:	
	cmp	si,8		; check for small line
	jns	notsml		; not small enough
	mov	cx,si		; get count in cl
	mov	ax,0ff00h		; make mask
	shr	ax,cl
	xor	ax,ax
	push	ax
	mov	dx,3ceh		; dx := graphics controller port addr
	mov	ah,n
	xor	al,al
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	out	dx,ax		; put color selection in set/reset reg
	mov	ax,0f01h
	out	dx,ax		; put 0fh in bit plane enable
	mov	ah,0
	mov	al,3
	out	dx,ax		; 0 for the RWM bits of the ALU
	mov	ax,0305h	; write mode 3 select
	out	dx,ax
	ENDIF
	mov	ax,argy1
	mov	bx,argx1
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	call	pixeladdr10
	ENDIF
	IF vgmode EQ 81h
	call	hgcpixad
	ENDIF
	sub	cl,7
	neg	cl
	xchg	di,bx		; put that in dx
	pop	ax
	xchg	ah,al
	shr	ax,cl		; shift in proper direction
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	xchg	es:[di],ah
	ENDIF
	IF vgmode EQ 81h
	push	ax
	not	ah		; clear out writable bits
	and	es:[di],ah
	not	ah
	and	ah,bkbits
	or	es:[di],ah
	pop	ax
	ENDIF
	or	al,al		; more pixels?
	jz	ssskp2
	inc	di
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	xchg	es:[di],al
	ENDIF
	IF vgmode EQ 81h
	xchg	ah,al
	push	ax
	not	ah		; clear out writable bits
	and	es:[di],ah
	not	ah
	and	ah,bkbits
	or	es:[di],ah
	pop	ax
	ENDIF
ssskp2:
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	mov	dx,3ceh		; dx := graphics controller port addr
	mov	ax,5
	out	dx,ax		; write mode 0
	xor	ax,ax
	out	dx,ax
	inc	ax
	out	dx,ax
	ENDIF
	clc
	ret
notsml:	mov	npxps,ax	; save this min xpix per y
	sub	ax,8
	mov	wnsml,ax
	inc	ax
	mov	wnbig,ax
	xor	ax,ax		; now get fractional part
	sar	dx,1		; by dividing the remainder
	idiv	bx
	mov	smladd,ax	; here is the fractional part
	sub	ax,08000h
	mov	bigadd,ax	; here is the fractional part minus 1
	xor	si,si
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
	mov	di,bx		; save line count
	mov	ax,argy1
	mov	bx,argx1
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	call	pixeladdr10
	ENDIF
	IF vgmode EQ 81h
	call	hgcpixad
	ENDIF
	sub	cl,7
	neg	cl
	mov	bp,smladd
	xchg	di,bx		; put that in dx
	xor	ch,ch		; cx has x pixel #
	mov	ah,clrrgt
	xor	al,al
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	out	dx,ax
	ENDIF
	IF vgmode EQ 81h
	push	bx
	mov	al,ah
	xor	ah,ah
	mov	bx,offset @dataseg:bkclrs
	xlat
	mov	bkbits,al
	pop	bx
	ENDIF
lbbyte:
	mov	al,-1		; make custom mask
	shr	al,cl
	mov	ah,es:[di]
	mov	es:[di],al	; write  it to screen
	push	ax
	push	cx
	push	di
	mov	cx,nright	; blast away to the right
	mov	al,-1
	inc	di
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	rep	stosb
	ENDIF
	IF vgmode EQ 81h
	and	al,bkbits
	rep	stosb
	ENDIF	
	mov	cx,nleft
	pop	di
	push	di
	std
	dec	di
	mov	ah,clrlft
	xor	al,al

	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	out	dx,ax
	ENDIF
	IF vgmode EQ 81h
	push	bx
	mov	al,ah
	xor	ah,ah
	mov	bx,offset @dataseg:bkclrs
	xlat
	mov	bkbits,al
	pop	bx
	ENDIF
	mov	al,-1
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	rep	stosb
	ENDIF
	IF vgmode EQ 81h
	and	al,bkbits
	rep	stosb
	ENDIF	
	cld
	pop	di
	pop	cx
	pop	ax
	xor	al,-1
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	xchg	es:[di],al
	ENDIF
	IF vgmode EQ 81h
	xchg	al,ah
	push	ax
	not	ah		; clear out writable bits
	and	es:[di],ah
	not	ah
	and	ah,bkbits
	or	es:[di],ah
	pop	ax
	ENDIF
	inc	di
	inc	nleft
	dec	nright
;	mov	al,-1		; prepare for repeated write
	add	cx,wnbig		; now prepare count for repeated writes
bdylp:	sub	cx,8		; decrement bits to go count
	js	tail
;	or	es:[di],al	; write another block
	inc	di
	inc	nleft
	dec	nright
	jmp	short bdylp	; another one?
tail:	
	add	cl,8		; recharge cl for positive count
	xor	ch,ch		; make ch positive again.
;	mov	ah,al
;	mov	al,ch
;	shr	ax,cl		; make tail mask
;	xchg	es:[di],al	; write data
segdn:
	IF (vgmode EQ 0dh) OR (vgmode EQ 10h)
	add	di,lincr
	ENDIF
	IF	vgmode EQ 81h
	nxtlin
	ENDIF
	
	mov	ah,clrrgt
	xor	al,al
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	out	dx,ax
	ENDIF
	IF vgmode EQ 81h
	push	bx
	mov	al,ah
	xor	ah,ah
	mov	bx,offset @dataseg:bkclrs
	xlat
	mov	bkbits,al
	pop	bx
	ENDIF
	dec	bx
	jz	lldone
	add	si,bigadd	; add a negative value
	js	jl808
	jmp	lbbyte		; do we need another biggie?
jl808:

lsbyte:
	mov	al,-1		; make custom mask
	mov	ah,es:[di]
	shr	al,cl
	mov	es:[di],al	; write  it to screen
	push	ax
	push	cx
	push	di
	mov	cx,nright	; blast away to the right
	mov	al,-1
	inc	di
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	rep	stosb
	ENDIF
	IF vgmode EQ 81h
	and	al,bkbits
	rep	stosb
	ENDIF	
	mov	cx,nleft
	pop	di
	push	di
	std
	dec	di
	mov	ah,clrlft
	xor	al,al

	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	out	dx,ax
	ENDIF
	IF vgmode EQ 81h
	push	bx
	mov	al,ah
	xor	ah,ah
	mov	bx,offset @dataseg:bkclrs
	xlat
	mov	bkbits,al
	pop	bx
	ENDIF
	mov	al,-1
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	rep	stosb
	ENDIF
	IF vgmode EQ 81h
	and	al,bkbits
	rep	stosb
	ENDIF	
	cld
	pop	di
	pop	cx
	pop	ax
	xor	al,-1
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	xchg	es:[di],al
	ENDIF
	IF vgmode EQ 81h
	push	ax
	not	ah		; clear out writable bits
	and	es:[di],ah
	not	ah
	and	ah,bkbits
	or	es:[di],ah
	pop	ax
	ENDIF
	inc	di
	inc	nleft
	dec	nright
	mov	al,-1		; prepare for repeated write
	add	cx,wnsml		; now prepare count for repeated writes
sbdylp:	sub	cx,8		; decrement bits to go count
	js	stail
	inc	di
	inc	nleft
	dec	nright
	jmp	short sbdylp	; another one?
lldone:	jmp	ldone		; jump to other ldone, it's the same
stail:	
	add	cl,8		; recharge cl for positive count
	mov	ah,al
	xor	ch,ch		; make ch positive again.
;	mov	al,ch
;	shr	ax,cl		; make tail mask
;	xchg	es:[di],al	; write data
ssegdn:	
	IF (vgmode EQ 0dh) OR (vgmode EQ 10h)
	add	di,lincr
	ENDIF
	IF	vgmode EQ 81h
	nxtlin
	ENDIF
	mov	ah,clrrgt
	xor	al,al
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	out	dx,ax
	ENDIF
	IF vgmode EQ 81h
	push	bx
	mov	al,ah
	xor	ah,ah
	mov	bx,offset @dataseg:bkclrs
	xlat
	mov	bkbits,al
	pop	bx
	ENDIF
	dec	bx
	jnz	lj913
	jmp	lldone
lj913:	
	add	si,bp	; add a negative value
	jns	jl923
	jmp	lsbyte		; do we need another biggie?
jl923:
	jmp	lbbyte



steep:	
	or	ax,ax		; is line vertical?
	jnz	notvert		; no
	inc	ax		; if so, then pretend it isn't quite vertical
notvert:	xor	dx,dx
	xchg	ax,bx		; wow!
	idiv	bx		; get the slope
	mov	npxps,ax	; save this min xpix per y
	mov	wnsml,ax
	inc	ax
	mov	wnbig,ax
	xor	ax,ax		; now get fractional part
	sar	dx,1		; by dividing the remainder
	idiv	bx
	or	bx,bx		; check for delta-x equal to zero
	jnz	incrok		; make sure count isn't zero!
	inc	bx	
incrok:
	mov	di,bx		; save for later
	mov	smladd,ax	; here is the fractional part
	sub	ax,08000h
	mov	bigadd,ax	; here is the fractional part minus 1
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	mov	dx,3ceh		; dx := graphics controller port addr
	mov	ax,0f01h
	out	dx,ax		; put 0fh in bit plane enable
	mov	ah,0
	mov	al,3
	out	dx,ax		; 0 for the RWM bits of the ALU
	mov	ax,0305h	; write mode 3 select
	out	dx,ax
	ENDIF
	mov	ax,argy1
	mov	bx,argx1
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	call	pixeladdr10
	ENDIF
	IF vgmode EQ 81h
	call	hgcpixad
	ENDIF
	add	cl,-7		; reverse direction of shift
	neg	cl
	mov	al,-1		; prepare mask
	shr	al,cl		
	xchg	di,bx		; put that in dx
	xor	ch,ch		; cx has x pixel #
	mov	bp,smladd		; save for later
	xor	si,si
bvbyte:
	mov	cx,wnbig		; number of y points to do
bigl:	
	push	ax
	mov	ah,clrrgt
	xor	al,al
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	out	dx,ax
	ENDIF
	IF vgmode EQ 81h
	push	bx
	mov	al,ah
	xor	ah,ah
	mov	bx,offset @dataseg:bkclrs
	xlat
	mov	bkbits,al
	pop	bx
	ENDIF
	pop	ax
	IF vgmode EQ 10h
	mov	ah,es:[di]	; read latches
	mov	es:[di],al	; write bit
	ENDIF
	IF vgmode EQ 81h
	push	ax
	xchg	al,ah
	not	ah		; clear out writable bits
	and	es:[di],ah
	not	ah
	and	ah,bkbits
	or	es:[di],ah
	pop	ax
	ENDIF
	push	ax
	push	cx
	push	di
	mov	cx,nright	; blast away to the right
	mov	al,-1
	inc	di
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	rep	stosb
	ENDIF
	IF vgmode EQ 81h
	and	al,bkbits
	rep	stosb
	ENDIF	
	mov	cx,nleft
	pop	di
	push	di
	std
	dec	di
	mov	ah,clrlft
	xor	al,al

	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	out	dx,ax
	ENDIF
	IF vgmode EQ 81h
	push	bx
	mov	al,ah
	xor	ah,ah
	mov	bx,offset @dataseg:bkclrs
	xlat
	mov	bkbits,al
	pop	bx
	ENDIF
	mov	al,-1
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	rep	stosb
	ENDIF
	IF vgmode EQ 81h
	and	al,bkbits
	rep	stosb
	ENDIF	
	cld
	pop	di
	pop	cx
	pop	ax
	mov	ah,al
	xor	ah,-1
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	xchg	es:[di],ah
	ENDIF
	IF vgmode EQ 81h
	push	ax
	not	ah		; clear out writable bits
	and	es:[di],ah
	not	ah
	and	ah,bkbits
	or	es:[di],ah
	pop	ax
	ENDIF
	IF (vgmode EQ 0dh) OR (vgmode EQ 10h)
	add	di,lincr
	ENDIF
	IF	vgmode EQ 81h
	nxtlin
	ENDIF
	loop	jbigl
	shr	al,1
				; done, so rotate bit to next position
	or	al,al
	jnz	skdinc		; check for incr to next byte over
	inc	di		; move to the right
	inc	nleft
	dec	nright
	mov	al,-1
skdinc:
	dec	bx		; are we finished yet?
	jnz	jl1061
	jmp	bvdone
jbigl:	jmp	bigl
jl1061:
	add	si,bigadd
	js	svbyte
	jmp	bvbyte
svbyte:
	mov	cx,wnsml		; number of y points to do
smll:	
	push	ax
	mov	ah,clrrgt
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	xor	al,al
	out	dx,ax
	ENDIF
	IF vgmode EQ 81h
	push	bx
	mov	al,ah
	xor	ah,ah
	mov	bx,offset @dataseg:bkclrs
	xlat
	mov	bkbits,al
	pop	bx
	ENDIF
	pop	ax
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	mov	ah,es:[di]	; read latches
	mov	es:[di],al	; write bit
	ENDIF
	IF vgmode EQ 81h
	push	ax
	xchg	al,ah
	not	ah		; clear out writable bits
	and	es:[di],ah
	not	ah
	and	ah,bkbits
	or	es:[di],ah
	pop	ax
	ENDIF
	push	ax
	push	cx
	push	di
	mov	cx,nright	; blast away to the right
	mov	al,-1
	inc	di
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	rep	stosb
	ENDIF
	IF vgmode EQ 81h
	and	al,bkbits
	rep	stosb
	ENDIF	
	mov	cx,nleft
	pop	di
	push	di
	std
	dec	di
	mov	ah,clrlft
	xor	al,al

	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	out	dx,ax
	ENDIF
	IF vgmode EQ 81h
	push	bx
	mov	al,ah
	xor	ah,ah
	mov	bx,offset @dataseg:bkclrs
	xlat
	mov	bkbits,al
	pop	bx
	ENDIF
	mov	al,-1
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	rep	stosb
	ENDIF
	IF vgmode EQ 81h
	and	al,bkbits
	rep	stosb
	ENDIF	
	cld
	pop	di
	pop	cx
	pop	ax
	mov	ah,al
	xor	ah,-1
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	xchg	es:[di],ah
	ENDIF
	IF vgmode EQ 81h
	push	ax
	not	ah		; clear out writable bits
	and	es:[di],ah
	not	ah
	and	ah,bkbits
	or	es:[di],ah
	pop	ax
	ENDIF
	IF (vgmode EQ 0dh) OR (vgmode EQ 10h)
	add	di,lincr
	ENDIF
	IF	vgmode EQ 81h
	nxtlin
	ENDIF
	loop	jsmll
	shr	al,1		; done, so rotate bit to next position
	or	al,al
	jnz	skvinc		; check for incr to next byte over
	inc	di		; move to the right
	inc	nleft
	dec	nright
	mov	al,-1
skvinc:
	dec	bx		; are we finished yet?
	jz	jl1175
	jmp	jl1160
jsmll:	jmp	smll
jl1175:
	jmp	bvdone
jl1160:
	add	si,smladd
	jns	jl1183
	jmp	svbyte
jl1183:
	jmp	bvbyte
.endp

bvdone:	jmp	ldone		; reset video registers, and return

.ends
	end

