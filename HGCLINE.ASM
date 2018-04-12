
	title 'hgcline'

				; this subroutine plots a line on an ega
				; screen
				; This code is lifted from the book
				; 'Programmer's guide to PC, and PS/2
				; Video systems by Richard Wilton
_MODEL	equ	<SMALL>
include c:\sa\model.inc
include 3dvid.inc
include	pixaddr1.inc


	public	hgcline		; the entry point into subroutine

	extrn	hgcpixad:near	; address routine for pixel



.extrn	argx1:word
.extrn	argy1:word
.extrn	argx2:word
.extrn	argy2:word
.extrn	n:byte
.extrn	put_beep:auto



.dataseg
varleafincr	dw	?
varincr1	dw	?
varincr2	dw	?
varroutine	dw	?
propix		db	0,0,44h,0ffh,0,0,0,055h,0,-1,-1,-1,-1,-1,-1,-1
argn		db	0
.ends

byteoffsetshift	equ	3

.codeseg

assume		cs:@codeseg, ds:@dataseg, es:@dataseg
.proc	hgcline auto
IF	vgmode EQ 81h
	mov	bx,offset propix
	mov	al,n
	xlat
	mov	argn,0
	or	al,al
	jz	leaveoff
	mov	argn,1
leaveoff:
	mov	si,2000h
	mov	di,90-8000h
	mov	 cx,argx2
	sub	cx,argx1
	jz	vertlinehgc

; force x1 < x2

	jns	l01
	neg	cx
	mov	bx,argx2
	xchg	bx,argx1
	mov	argx2,bx
	mov	bx,argy2
	xchg	bx,argy1
	mov	argy2,bx

l01:	mov	bx,argy2
	sub	bx,argy1
	jnz	nohoriz
	jmp	horizlinehgc
nohoriz:
	jns	l03
	neg	bx
	neg	si
	neg	di

; select routine fro slope of line

l03:	mov	varleafincr,di
	mov	varroutine,offset loslopelinehgc
	cmp	bx,cx
	jle	l04
	mov	varroutine,offset hislopelinehgc
	xchg	bx,cx

; calc initial decision variable

l04:	shl	bx,1
	mov	varincr1,bx
	sub	bx,cx
	mov	di,bx
	sub	bx,cx
	mov	varincr2,bx

; calculate first pixel address
	push	cx
	mov	ax,argy1
	mov	bx,argx1
	call	hgcpixad
	mov	al,argn
	shl	ax,cl
	mov	dx,ax
	not	dh
	pop	cx
	inc	cx
	jmp	varroutine

; routine for vertical lines

vertlinehgc:	mov	ax,argy1
	mov	bx,argy2
	mov	cx,bx
	sub	cx,ax
	jge	l31
	neg	cx
	mov	ax,bx
l31:	inc	cx
	mov	bx,argx1
	push	cx
	call	hgcpixad
	mov	al,argn
	shl	ax,cl
	not	ah
	pop	cx

; draw the line
	test 	al,al
	jz 	l34
l32:	or 	es:[bx],al
	add	bx,si
	jns	l33
	add	bx,di
l33:	loop	l32
	jmp	short l36
l34:	and 	es:[bx],ah
	add	bx,si
	jns	l35
	add	bx,di
l35:	loop	l34
l36:	jmp 	lexit

; routine for hoiezontal lines slope = 1

horizlinehgc:	mov	 ax,argy1
	mov	bx,argx1
	call	hgcpixad
	mov	di,bx
	mov	dh,ah
	not	dh
	mov	dl,0ffh
	shl	dh,cl
	not	dh
	mov	cx,argx2
	and	cl,7
	xor	cl,7
	shl	dx,cl

; determine byte offset of first and last pixel in the line

	mov	ax,argx2
	mov	bx,argx1
	mov	cl,byteoffsetshift
	shr	ax,cl
	shr	bx,cl
	mov	cx,ax
	sub	cx,bx

; propagate pixel value throughout byte

	mov	bx,offset propix
	mov	al,n
	xlat

; set pixels in leftmost byte of the line

	or	 dh,dh
	js 	l43
	or 	cx,cx
	jnz	l42
	and	dl,dh
	jmp	short l44
l42:	mov	ah,al
	and	ah,dh
	not	dh
	and	es:[di],dh
	or	es:[di],ah
	inc	di
	dec	cx

; use a fast 8086 machine instruction to draw the remainder of the line

l43:	rep	stosb

; set pixels in the rightmost byte of the line

l44:	and	al,dl
	not	dl
	and	es:[di],dl
	or	es:[di],al
	jmp	lexit

; routine for dy <= dx

loslopelinehgc:
l10:	mov	ah,es:[bx]
l11:	and	ah,dh
	or	ah,dl
	ror	dl,1
	ror	dh,1
	jnc	l14

; bit mask not shifted out

	or	di,di
	jns	l12
	add	di,varincr1
	loop	l11
	mov	es:[bx],ah
	jmp	short lexit

l12:	add	di,varincr2
	mov	es:[bx],ah
	add	bx,si
	jns	l13
	add	bx,varleafincr
l13:	loop	l10
	jmp	short lexit

; bit mask shifted out

l14:	mov	es:[bx],ah
	inc	bx
	or 	di,di
	jns	l15
	add	di,varincr1
	loop	l10
	jmp	short lexit

l15:	add	di,varincr2
	add	bx,si
	jns	l16
	add	bx,varleafincr
l16:	loop	l10
	jmp	short	lexit
	
; routine for dy > dx

hislopelinehgc:
l21:	and	es:[bx],dh
	or	es:[bx],dl
	add	bx,si
	jns	l22
	add	bx,varleafincr
l22:	or	di,di
	jns	l23
	add	di,varincr1
	loop	l21
	jmp	short lexit

l23:	add	di,varincr2
	ror	dl,1
	ror	dh,1
	cmc
	adc	bx,0
	loop	l21

lexit:	
ELSE
	call	put_beep
ENDIF
	ret
.endp
.ends

	end
