
	title 'hgcpixad'
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

	public	hgcpixad	; entry point
;
	.extrn	vboff:word
.dataseg
.ends

.codeseg
	assume cs:@codeseg,ds:@dataseg
hgcpixad	proc	near
IF vgmode EQ 81h
	mov	cl,bl
	shr	ax,1
	rcr	bx,1
	shr	ax,1
	rcr	bx,1
	shr	bx,1
	mov	ah,bpl
	mul	ah
	add	bx,ax
	add	bx,vboff
	mov	ax,vgseg
	mov	es,ax
	and	cl,7
	xor	cl,7
	mov	ah,1
ENDIF
	ret
hgcpixad	endp
.ends
	end

