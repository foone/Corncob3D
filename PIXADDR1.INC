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
IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
pixadd	macro
	push	dx
	mov	dx,bpl		; bytes per line
	mul	dx
	mov	cl,3
	pop	dx
	mov	ch,bl		; save old x low part
	shr	bx,cl
	add	bx,vboff	; add in offset
	add	bx,ax		; add in y offset
	mov	cl,ch
	and	cl,7
	xor	cl,7
	mov	ax,vgseg	; load es with proper segment
	mov	es,ax
	mov	ah,1
	endm
ENDIF
IF vgmode EQ 81h
pixadd	macro
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
	endm
ENDIF
