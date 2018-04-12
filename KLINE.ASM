	title 'ega-line'

				; this subroutine plots a line on an ega
				; screen
				; This code is lifted from the book
				; 'Programmer's guide to PC, and PS/2
				; Video systems by Richard Wilton
_MODEL	equ	<SMALL>
include model.inc
include	extrns.inc		; get extrnals
include 3dvid.inc
include	pixaddr1.inc


	public	kline		; the entry point into subroutine
	public	horline		; makes nice horizontal line
	public	clhorline		; makes nice horizontal line

	extrn	pixeladdr10:near	; address routine for pixel
	.extrn	put_str:auto
;	.extrn	dline:auto
	.extrn	put_chr:auto
	.extrn	words_to_dec:auto
	.extrn	egaline:auto
;.extrn		dotflg:byte

.dataseg
npxps		dw	0      ; number of pixels in x per y pt
smladd		dw	0	;
bigadd		dw	0
ynpts		dw	0	;
bigbits		dw	0	;
smlbits		dw	0
wnbig		dw	0
wnsml		dw	0
nbig		db	0
nsml		db	0
lincr		dw	?
kbuf		db	128 dup(?)
npts		dw	0
.ends

.codeseg
;assume		cs:@codeseg, 
	assume	ds:@dataseg, es:@dataseg

.proc	wsp	auto
	push	ax
	mov	al,20h
	call	put_chr
	pop	ax
	ret
.endp

.proc	wword	auto
	push	si
	push	ax
	mov	si,offset @dataseg:kbuf
	call	words_to_dec
	call	put_str
	call	wsp
	pop	ax
	pop	si
	ret
	.endp

.proc	kline	auto
;	IF vgmode NE 10h
;	  call	egaline
;	  ret
;	ENDIF

;	cmp	dotflg,0
;	jz	klstrt
;	jmp	dline

;	mov	ax,argx1
;	call	wword
;	mov	ax,argy1
;	call	wword
;	mov	ax,argx2
;	call	wword
;	mov	ax,argy2
;	call	wword
;	call	wsp
;	call	wsp
;	call	wsp
;	call	wsp
;	call	wsp
;	mov	al,0dh
;	call	put_chr
klstrt:	
	mov	lincr,bpl
	mov	ax,argx2	; get del y and del x
	sub	ax,argx1
	jns	ordrigt		; order is already right
	neg	si
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
	jnz	ynzero		; check for horizontal line
	jmp	horline
ynzero:	jns	yposit
	neg	lincr
	neg	bx
yposit:
	jz	goegl		; check for zero slope
slpnzr:	
;	mov	dx,ax
;	sar	dx,1		; if slope > .5 then egaline
	cmp	bx,ax		; check for small slope
	js	slopok		; ok for now
goegl:	jmp	egaline		; if slope is 1 or greater, then use old
				; routine
slopok:	
	cmp	ax,30		; see if small line
	js	goegl
	xor	dx,dx
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
;	call	pixeladdr10	; get the starting address
	pixadd
	sub	cl,7
	neg	cl
	xchg	di,bx		; put that in dx
	xor	ch,ch		; cx has x pixel #
	xor	si,si
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
;	jmp	ldone
	mov	ch,8
	mov	dx,bigadd
	mov	bp,smladd
bbyte:
	mov	ax,bigbits	; get mask
	shr	ax,cl		; shift in proper direction
	add	cl,nbig		; add to position
	xchg	es:[di],ah		; write latches
	or	al,al		; more pixels?
	jz	skp2
	inc	di
	xchg	es:[di],al		; write the second byte
	dec	di
skp2:	add	di,lincr
	test	cl,ch		; see if we need to proceed to next byte
	jz	skp3		; not yet
	sub	cl,ch
	inc	di
skp3:	dec	bx
	jz	ldone
	add	si,dx	; add a negative value
	jns	bbyte		; do we need another biggie?

sbyte:
	mov	ax,smlbits	; get mask
	shr	ax,cl		; shift in proper direction
	add	cl,nsml		; add to position
	xchg	es:[di],ah		; write latches
	or	al,al		; more pixels?
	jz	sskp2
	inc	di
	xchg	es:[di],al		; write the second byte
	dec	di
sskp2:	add	di,lincr
	test	cl,ch		; see if we need to proceed to next byte
	jz	sskp3		; not yet
	sub	cl,ch
	inc	di
sskp3:	dec	bx
	jz	ldone
	add	si,bp	; add a positive value
	jns	bbyte		; do we need another biggie?
	jmp	sbyte

ldone:	
	mov	dx,3ceh		; dx := graphics controller port addr
	mov	ax,5
	out	dx,ax		; write mode 0
	xor	ax,ax
	out	dx,ax
	inc	ax
	out	dx,ax
	ret
	mov	ax,si
	call	wword
	call	wsp
	mov	ax,smladd
	call	wword
	call	wsp
	mov	ax,bigadd
	call	wword
	call	wsp
	mov	ax,smlbits
	call	wword
	mov	ax,bigbits
	call	wword
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
	out	dx,ax		; put color selection in set/reset reg
	mov	ax,0f01h
	out	dx,ax		; put 0fh in bit plane enable
	mov	ah,0
	mov	al,3
	out	dx,ax		; 0 for the RWM bits of the ALU
	mov	ax,0305h	; write mode 3 select
	out	dx,ax
	mov	ax,argy1
	mov	bx,argx1
;	call	pixeladdr10	; get the starting address
	pixadd
	sub	cl,7
	neg	cl
	xchg	di,bx		; put that in dx
	pop	ax
	xchg	ah,al
	shr	ax,cl		; shift in proper direction
	xchg	es:[di],ah		; write latches
	or	al,al		; more pixels?
	jz	ssskp2
	inc	di
	xchg	es:[di],al		; write the second byte
ssskp2:
	mov	dx,3ceh		; dx := graphics controller port addr
	mov	ax,5
	out	dx,ax		; write mode 0
	xor	ax,ax
	out	dx,ax
	inc	ax
	out	dx,ax
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
	mov	dx,bigadd
	mov	bp,smladd
	mov	di,bx		; save line count
	mov	ax,argy1
	mov	bx,argx1
;	call	pixeladdr10	; get the starting address
	pixadd
	sub	cl,7
	neg	cl
	xchg	di,bx		; put that in dx
	xor	ch,ch		; cx has x pixel #
lbbyte:
	mov	al,-1		; make custom mask
	shr	al,cl
	xchg	es:[di],al	; write  it to screen
	inc	di
	mov	al,-1		; prepare for repeated write
	add	cx,wnbig		; now prepare count for repeated writes
bdylp:	sub	cx,8		; decrement bits to go count
	js	tail
	or	es:[di],al	; write another block
	inc	di
	jmp	short bdylp	; another one?
tail:	
	add	cl,8		; recharge cl for positive count
	xor	ch,ch		; make ch positive again.
	mov	ah,al
	mov	al,ch
	shr	ax,cl		; make tail mask
	xchg	es:[di],al	; write data
segdn:	add	di,lincr
	dec	bx
	jz	lldone
	add	si,dx	; add a negative value
	jns	lbbyte		; do we need another biggie?

lsbyte:
;	push	dx
;	mov	dx,3ceh		; dx := graphics controller port addr
;	mov	ah,11
;	xor	al,al
;	out	dx,ax		; put color selection in set/reset reg
	mov	al,-1		; make custom mask
	shr	al,cl
	xchg	es:[di],al	; write  it to screen
;	mov	ah,n
;	xor	al,al
;	out	dx,ax		; put color selection in set/reset reg
	inc	di
	mov	al,-1		; prepare for repeated write
	add	cx,wnsml		; now prepare count for repeated writes
sbdylp:	sub	cx,8		; decrement bits to go count
	js	stail
	or	es:[di],al	; write another block
	inc	di
	jmp	short sbdylp	; another one?
lldone:	jmp	ldone		; jump to other ldone, it's the same
stail:	
	add	cl,8		; recharge cl for positive count
;	mov	ah,9
;	xor	al,al
;	out	dx,ax		; put color selection in set/reset reg
	mov	ah,al
	xor	ch,ch		; make ch positive again.
	mov	al,ch
	shr	ax,cl		; make tail mask
	xchg	es:[di],al	; write data
;	mov	ah,n
;	xor	al,al
;	out	dx,ax		; put color selection in set/reset reg
;	pop	dx
ssegdn:	add	di,lincr
	dec	bx
	jz	lldone
	add	si,bp	; add a negative value
	js	lsbyte		; do we need another biggie?
	jmp	lbbyte
.endp

.proc	clhorline	auto
	mov	ax,argy1
	cmp	ax,[si+2]
	js	clfail
	cmp	ax,[si+6]
	jns	clfail
	mov	ax,argy2
	cmp	ax,[si+2]
	js	clfail
	cmp	ax,[si+6]
	jns	clfail
	mov	ax,argx1
	mov	bx,argx2
	cmp	bx,ax
	jns	cdd5
	xchg	ax,bx
cdd5:	cmp	ax,[si]	; see if less than xmin
	jns	cdd2
	mov	ax,[si]
cdd2:	cmp	bx,[si]
	js	clfail		; if xmax<wxmin, fail line
	cmp	ax,[si+4]
	jns	clfail		; if xmin > wxmax, fail line
	cmp	bx,[si+4]
	js	cdd3
	mov	bx,[si+4]
cdd3:	
	mov	argx1,ax
	mov	argx2,bx
	sub	bx,ax
	jz	clfail
	jmp	horline
clfail:	stc
	ret
.endp

.proc	horline	 auto	; makes fast horizontal lines
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
	mov	ax,argx2	; check for x2>x1
	sub	ax,argx1
	jnz	dd0
	jmp	hordone	; if there is no line to draw, skip it
dd0:	jns	dd1	; reverse x2,x1 if reversed
	neg	ax
	mov	bx,argx1
	xchg	bx,argx2
	mov	argx2,bx
dd1:	
	mov	cx,ax	; see what scale we're talking, here
	sub	cx,8
	jg	dd2	; if bigger than 8, skip ahead
	mov	cx,ax	; put count in ax
	dec	cx
	mov	ax,08000h ; make mask
	sar	ax,cl
	mov	di,ax	; save mask in di
	mov	ax,argy1
	mov	bx,argx1
	pixadd
	mov	ax,di	; restore bit mask
	mov	di,bx	; set address
	neg	cl	; xlate  count
	add	cl,7
	shr	ax,cl
	xchg	es:[di],ah
	inc	di
	xchg	es:[di],al
	jmp	hordone

dd2:	cmp	cx,8		; is npts > 16?
	jg	dd3		; yes, continue with other code
	mov	ax,0ff00h	; make big bit mask
	sar	ax,cl		; ax will hold upto 16 bit mask
	mov	di,ax
	mov	ax,argy1
	mov	bx,argx1
	pixadd
	mov	ax,di		; restore bit mask
	mov	di,bx		; put address in proper register
	xor	ch,ch
	neg	cx		; adjust bit count
	xor	dx,dx		; prepare for mask shifting
	add	cx,7
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
	mov	ax,argy2
	mov	bx,argx1
	pixadd
	mov	di,bx
	neg	cl
	add	cl,7
	xor	ch,ch
	add	npts,cx
	mov	al,-1
	shr	al,cl
	xchg	al,es:[di]
	inc	di
	mov	cx,npts
	shr	cx,1		; how many bytes to write?
	shr	cx,1
	shr	cx,1
;	cmp	cx,9
;	js	dd7
;	mov	ax,-1
;	test	di,1		; see if on even or odd addr
;	jz	dd8		; if even, jump ahead
;	stosb
;	dec	cx
;dd8:	shr	cx,1		; now write words
;	rep	stosw
;	jnc	dd9		; if cx was even, then we're done
;	stosb			; if odd, then do last byte
;	jmp	dd9
;
dd7:	mov	al,-1
	cld
	rep stosb
dd9:	mov	cx,npts
	and	cl,7
	mov	ax,0ff00h
	shr	ax,cl
	xchg	al,es:[di]


hordone:
	mov	dx,3ceh		; dx := graphics controller port addr
	mov	ax,5
	out	dx,ax		; write mode 0
	xor	ax,ax
	out	dx,ax
	inc	ax
	out	dx,ax
	clc			; give no error flag
	ret
.endp

.ends
	end

