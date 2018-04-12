	title 'ega-line'

				; this subroutine plots a line on an ega
				; screen
				; This code is lifted from the book
				; 'Programmer's guide to PC, and PS/2
				; Video systems by Richard Wilton
_MODEL	equ	<SMALL>
include c:\sa\model.inc
include	extrns.inc		; get extrnals

assume		cs:@codeseg, ds:@dataseg, es:@dataseg

	public	egaline		; the entry point into subroutine

	extrn	pixeladdr10:near	; address routine for pixel

.dataseg
vertincr	dw	0
incr1		dw	0
incr2		dw	0
routine		dw	0
.ends

.codeseg
egaline	proc	near		; the actual routine
	mov	dx,3ceh		; dx := graphics controller port addr
	mov	ah,n
	xor	al,al
	out	dx,ax
	mov	ax,0f01h
	out	dx,ax
	mov	ah,0
	mov	al,3
	out	dx,ax
	mov	si,80		; number of bytes per line
	mov	cx,argx2
	sub	cx,argx1
	jz	vertline10	; do vertical line if delta-x is zero
; force x1<x2
	jns	l01
	neg	cx
	mov	bx,argx2
	xchg	bx,argx1
	mov	argx2,bx
	mov	bx,argy2
	xchg	bx,argy1
	mov	argy2,bx
; calculate dy = abs(y2-y1)
l01:	mov	bx,argy2
	sub	bx,argy1
	jz	horizline10
	jns	l03
	neg	bx
	neg	si
;select appropriate routine for slope of line
l03:	mov	vertincr,si
	mov	routine,offset loslopeline
	cmp	bx,cx
	jle	l04
	mov	routine,offset hislopeline
	xchg	bx,cx			; exchange dy and dx
; calculate initial decision variable and increments
l04:	shl	bx,1
	mov	incr1,bx
	sub	bx,cx
	mov	si,bx
	sub	bx,cx
	mov	incr2,bx
; calculate first pixel address
	push	cx
	mov	ax,argy1
	mov	bx,argx1
	call	pixeladdr10
	mov	di,bx
	shl	ah,cl
	mov	bl,ah
	mov	al,8
	pop	cx
	inc	cx
	jmp	routine
; routine for verical lines
vertline10:	mov	ax,argy1
	mov	bx,argy2
	mov	cx,bx
	sub	cx,ax
	jge	l31
	neg	cx
	mov	ax,bx
l31:	inc	cx
	mov	bx,argx1
	push	cx
	call	pixeladdr10
; set up graphics controller
	shl	ah,cl
	mov	al,8
	out	dx,ax
	pop	cx
; draw the line
l32:	or 	es:[bx],al	;set pixel
	add	bx,si		; incr to next line
	loop	l32
	jmp	lexit

; routine for horizontal lines
horizline10:
	push	ds
	mov	ax,argy1
	mov	bx,argx1
	call	pixeladdr10
	mov	di,bx
	mov	dh,ah
	not	dh
	shl	dh,cl
	not	dh
	mov	cx,argx2
	and	cl,7
	xor	cl,7
	mov	dl,0ffh
	shl	dl,cl
	mov	ax,argx2
	mov	bx,argx1
	mov	cl,3
	shr	ax,cl
	shr	bx,cl
	mov	cx,ax
	sub	cx,bx
; get graphics controller port address into dx
	mov	bx,dx
	mov	dx,3ceh
	mov	al,8
; make video buffer addressable through ds:si
	push	es
	pop	ds
	mov	si,di
; set pixels in leftmost byte of the line
	or	bh,bh
	js	l43
	or	 cx,cx
	jnz	l42
	and	bl,bh
	jmp	short l44
l42:	mov	ah,bh
	out	dx,ax
	movsb	
	dec	cx
; use a fast 8086 machine intruction to draw the remainder of the line
l43:	mov	ah,-1
	out	dx,ax
	rep	movsb
; set pixels in the rightmost byte of the line
l44:	mov	ah,bl
	out	dx,ax
	movsb
	pop	ds
	jmp	short lexit
; routine for dy >= dx		; es:di -> video buffer
				; al = bit mask register #
				; bl = bit mask for 1st pixel
				; cx = #pixels to draw
				; dx = graphics controller port addr
				; si = decision variable
loslopeline:
l10:	mov	ah,bl		; 
l11:	or	ah,bl
	ror	bl,1
	jc	l14
; bit mask not shifted out
	or	si,si
	jns	l12
	add	si,incr1
	loop	l11
	out	dx,ax
	or	es:[di],al
	jmp	short lexit
l12:	add	si,incr2
	out	dx,ax
	or	es:[di],al
	add	di,vertincr
	loop	l10
	jmp	short	lexit
; bit mask shifted out
l14:	out	dx,ax
	or	es:[di],al
	inc	di
	or	si,si
	jns	l15
	add	si,incr1
	loop	l10
	jmp	short lexit
l15:	add	si,incr2
	add	di,vertincr
	loop	l10
	jmp	short lexit
; routine for dy > dx
hislopeline:
	mov	bx,vertincr
l21:	out	dx,ax
	or	es:[di],al
	add	di,bx
l22:	or	si,si
	jns	l23
	add	si,incr1
	loop	l21
	jmp	short lexit
l23:	add	si,incr2
	ror	ah,1
	adc	di,0
	loop	l21
; restore default graphics controller state and return to caller
lexit:	xor	ax,ax
	out	dx,ax
	inc	ax
	out	dx,ax
	mov	al,3
	out	dx,ax
	mov	ax,0ff08h
	out	dx,ax
	ret
egaline	endp
.ends
	end

