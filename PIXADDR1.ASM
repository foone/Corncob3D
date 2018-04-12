	title 'pixeladdr10'
;
;	this routine returns the pixel addr for ega modes
;	when given x and y coords
;
;	caller: 		ax = y-coordinate
;				bx = x-cooordintat
;	
;	returns:		ah = bit mask
;				bx = byte offset in buffer
;				cl = number of bits to shift left
;				es = video buffer segment
;
_MODEL	equ	<SMALL>
include c:\sa\model.inc
include 3dvid.inc

	public	pixeladdr10	; entry point
;
	.extrn	vboff:word
.dataseg
.ends

.codeseg
	assume cs:@codeseg,ds:@dataseg
pixeladdr10	proc	near
IF	(vgmode EQ 10h) OR (vgmode EQ 0dh)
;	mov	dx,ax		; multiply y by 80
;	shl	ax,1		; mult by 4
;	shl	ax,1		; mult by 4
;	add	ax,dx		; not it's by 5
;	mov	cl,4		; now by 16
;	shl	ax,cl
	push	dx
	mov	dx,bpl		; bytes per line
	mul	dx
	mov	cl,3
	mov	dx,bx		; save old x low part
	shr	bx,cl
	add	bx,vboff	; add in offset
	add	bx,ax		; add in y offset
	mov	cx,dx
	and	cl,7
	xor	cl,7
	mov	ax,vgseg	; load es with proper segment
	mov	es,ax
	mov	ah,1
	pop	dx
ENDIF
	ret
pixeladdr10	endp
.ends
	end

