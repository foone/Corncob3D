	title 'ega-line'

				; this subroutine plots a line on an ega
				; screen
				; This code is lifted from the book
				; 'Programmer's guide to PC, and PS/2
				; Video systems by Richard Wilton
_MODEL	equ	<SMALL>
include c:\sa\model.inc
include	extrns.inc		; get extrnals
include 3dvid.inc
include pixaddr1.inc


	public	dline		; the entry point into subroutine

	extrn	pixeladdr10:near	; address routine for pixel
	.extrn	put_str:auto
	.extrn	put_chr:auto
	.extrn	words_to_dec:auto
	.extrn	egaline:auto
	.extrn	wword:auto

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
.ends

.codeseg
assume		cs:@codeseg, ds:@dataseg, es:@dataseg
.proc	dline	auto
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
	
	mov	lincr,80
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
	jns	yposit
	neg	lincr
	neg	bx
yposit:
;	jnz	slpnzr		; check for zero slope
	
slpnzr:	
	cmp	bx,ax		; check for small slope
	js	slopok		; ok for now
	jz	slopok		; check if line is zero long
	cmp	bx,4
	js	goegl
	jmp	vertl
goegl:	jmp	egaline		; if slope is 1 or greater, then use old
				; routine
slopok:	
	cmp	ax,4		; see if small line
	js	goegl
	xor	dx,dx
	xchg	ax,bx		; wow!
	mov	cl,3		; multiply delta y by 8
	sal	ax,cl
	idiv	bx		; get the slope
slpfin:	mov	npxps,ax	; save this min xpix per y
	mov	wnsml,ax
	inc	ax
	mov	wnbig,ax
	xor	ax,ax		; now get fractional part
	sar	dx,1		; by dividing the remainder
	idiv	bx
	mov	cl,3
	sar	bx,cl		; divide count by 8
	jnc	rndb2
	inc	bx		; round bx up
rndb2:
	jnz	incrok		; make sure count isn't zero!
	mov	bx,1
incrok:
	mov	di,bx		; save for later
	mov	smladd,ax	; here is the fractional part
	sub	ax,08000h
	mov	bigadd,ax	; here is the fractional part minus 1
	mov	cx,npxps
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
	mov	ax,argy2
	mov	bx,argx2
;	call	pixeladdr10	; get the starting address
	pixadd
	shl	ah,cl		; prepare to write pixel
	xchg	es:[bx],ah	; write final pixel
	mov	ax,argy1
	mov	bx,argx1
;	call	pixeladdr10	; get the starting address
	pixadd
	sub	cl,7
	neg	cl
	xchg	di,bx		; put that in dx
	xor	ch,ch		; cx has x pixel #
;	jmp	ldone
	mov	ch,8
	mov	ax,lincr	; get line incr, plus or minus
	mov	dl,al
	mov	ax,wnsml	; get small y incr
	imul	dl		; mul by bytes per line
	inc	ax
	mov	bp,ax		; save for later
	xor	si,si
	add	ax,lincr
	mov	dx,ax		; save big yincr in dx
	mov	al,80h
	shr	al,cl
	xor	si,si
bbyte:
	mov	ah,es:[di]	; latch bits 
	mov	es:[di],al	; write new bits
	add	di,dx		; go to next byte
	dec	bx		; check for complete
	jz	ldone
	add	si,bigadd	; proceed
	jns	bbyte		; do we need another biggie?
sbyte:
	mov	ah,es:[di]	; latch bits 
	mov	es:[di],al	; write new bits
	add	di,bp		; go to next byte
	dec	bx		; check for complete
	jz	ldone
	add	si,smladd	; proceed
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

;	mov	ax,si
;	call	wword
;	call	wsp
;	mov	ax,smladd
;	call	wword
;	call	wsp
;	mov	ax,bigadd
;	call	wword
;	call	wsp
;	mov	ax,smlbits
;	call	wword
;	mov	ax,bigbits
;	call	wword

	ret

vertl:	xor	dx,dx
	mov	cl,3		; multiply delta x by 8
	sal	ax,cl
	idiv	bx		; get the slope
	mov	npxps,ax	; save this min ypix per x
	mov	nsml,al
	inc	ax
	mov	nbig,al
	xor	ax,ax		; now get fractional part
	sar	dx,1		; by dividing the remainder
	idiv	bx
	mov	cl,3
	sar	bx,cl		; divide count by 8
	jnc	rndb1
	inc	bx		; round bx up
rndb1:
	jnz	iicrok		; make sure count isn't zero!
	mov	bx,1
iicrok:
	mov	di,bx		; save for later
	mov	smladd,ax	; here is the fractional part
	sub	ax,08000h
	mov	bigadd,ax	; here is the fractional part minus 1
	mov	cx,npxps
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
	mov	ax,argy2
	mov	bx,argx2
;	call	pixeladdr10	; get the starting address
	pixadd
	shl	ah,cl
	xchg	es:[bx],ah	; write original pixel
	mov	ax,argy1
	mov	bx,argx1
;	call	pixeladdr10	; get the starting address
	pixadd
	sub	cl,7
	neg	cl
	xchg	di,bx		; put that in dx
	xor	ch,ch		; cx has x pixel #
;	jmp	ldone
	mov	ch,8
	mov	ax,lincr
	mov	dl,8
	imul	dl
	mov	bp,ax
	mov	ax,8000h
	shr	ax,cl
	xor	si,si
vbbyte:
	mov	cl,nbig		; get big # to shift
	mov	dl,es:[di]	; latch bits 
	mov	es:[di],ah	; write new bits
	ror	ax,cl		; shift bit to the right by big amount
	or	ah,ah		; see if it's time to move on
	jnz	vskip1		; not yet
	inc	di		; advance to next byte
	xchg	ah,al		; bring us back into current byte
vskip1:
	add	di,bp	; go to next byte
	dec	bx		; check for complete
	jz	bldone
	add	si,bigadd	; proceed
	jns	vbbyte		; do we need another biggie?
vsbyte:
	mov	cl,nsml		; get big # to shift
	mov	dl,es:[di]	; latch bits 
	mov	es:[di],ah	; write new bits
	ror	ax,cl		; shift bit to the right by big amount
	or	ah,ah		; see if it's time to move on
	jnz	svskip1		; not yet
	inc	di		; advance to next byte
	xchg	ah,al		; bring us back into current byte
svskip1:
	add	di,bp	; go to next byte
	dec	bx		; check for complete
	jz	bldone
	add	si,smladd	; proceed
	jns	vbbyte		; do we need another biggie?
	jmp	vsbyte

bldone:	
	mov	dx,3ceh		; dx := graphics controller port addr
	mov	ax,5
	out	dx,ax		; write mode 0
	xor	ax,ax
	out	dx,ax
	inc	ax
	out	dx,ax
	ret

;	mov	ax,si
;	call	wword
;	call	wsp
;	mov	ax,smladd
;	call	wword
;	call	wsp
;	mov	ax,bigadd
;	call	wword
;	call	wsp
;	mov	ax,smlbits
;	call	wword
;	mov	ax,bigbits
;	call	wword
;	ret

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



.ends
	end

