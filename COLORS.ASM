
.dataseg
groundcolors	db	0,42,0
skycolors	db	21,63,63
colors	db	16 dup(0,0,0,0)		; memory for color registers
rescolors	db	16 dup(0,0,0,0)
haluclrs	dw	0,0,0		; present biases for halucinatory clrs
.ends

.codeseg
.proc	shiftcbits	auto	; shifts the damn suckers down
	mov	cx,6
sftclp:
	shr	dx,1
	rcr	bx,1
	rcr	ah,1
	loop	sftclp
	mov	al,ah
	shr	al,1
	shr	al,1		; mov bits to the rightmost position
	ret
.endp

.proc	unpackbits	auto	; unpacks colorbits into sky and ground clrs
	mov	dh,colorbits
	mov	dl,colorbits+1
	mov	bh,colorbits+2
	mov	bl,colorbits+3
	mov	ah,colorbits+4
	xor	cx,cx		; verify that these bits are non-zero
	or	cx,dx
	or	cx,bx
	or	cl,ah
	jz	nounpack

	mov	al,ah
	shr	al,1
	shr	al,1		; mov bits to the rightmost position
	mov	groundcolors+2,al

	call	shiftcbits
	mov	groundcolors+1,al

	call	shiftcbits
	mov	groundcolors,al

	call	shiftcbits
	mov	skycolors+2,al

	call	shiftcbits
	mov	skycolors+1,al

	call	shiftcbits
	mov	skycolors,al
nounpack:
	ret
.endp

.proc	ushiftcbits	auto	; shifts the damn suckers down
	mov	ah,al
	shl	ah,1		; shift up so bits are fresh
	shl	ah,1		; shift up so bits are fresh
	mov	cx,6
usftclp:
	shl	ah,1
	rcl	bx,1
	rcl	dx,1
	loop	usftclp
	ret
.endp

.proc	packbits	auto	; unpacks colorbits into sky and ground clrs
	mov	al,skycolors
	call	ushiftcbits
	mov	al,skycolors+1
	call	ushiftcbits
	mov	al,skycolors+2
	call	ushiftcbits
	mov	al,groundcolors
	call	ushiftcbits
	mov	al,groundcolors+1
	call	ushiftcbits
	mov	ah,groundcolors+2
	shl	ah,1		; shift up so bits are fresh
	shl	ah,1		; shift up so bits are fresh

	mov	colorbits,dh
	mov	colorbits+1,dl
	mov	colorbits+2,bh
	mov	colorbits+3,bl
	mov	colorbits+4,ah
	ret
.endp

.proc	setskygnd	auto			; makes sky and ground
						; official base colors
	mov	si,offset @dataseg:colors
	mov	al,groundcolors
	mov	byte ptr [si+(4*2)+1],al
	mov	al,groundcolors+1
	mov	byte ptr [si+(4*2)+2],al
	mov	al,groundcolors+2
	mov	byte ptr [si+(4*2)+3],al
	mov	al,skycolors
	mov	byte ptr [si+(4*11)+1],al
	mov	al,skycolors+1
	mov	byte ptr [si+(4*11)+2],al
	mov	al,skycolors+2
	mov	byte ptr [si+(4*11)+3],al
	ret
.endp


.proc	readcolors	auto	; fades colors by a little
	mov	cx,16		; 16 palette registers
	mov	si,offset @dataseg:colors
rdcloop:
	mov	dx,3dah
	in	al,dx		; reset flip flop
	mov	dx,3c0h
	mov	al,cl
	neg	al
	add	al,16		; 16-1 to 0-15
	out	dx,al		; set address
	inc	dx		; read from 3c1h port
	in	al,dx
	mov	[si],al		; put in first element of array
	inc	si
	mov	dx,03c7h	; prepare to read from vga
	out	dx,al		; set address of color reg desired
	mov	dx,03c9h	; point to data register
rept	3
	in	al,dx
	mov	[si],al
	inc	si
endm
	loop	rdcloop		; get next
	call	unpackbits	; get colors from universe data

				; now distort colors as requested
	call	setskygnd
	ret
.endp	

.proc	workonclr	auto
	mov	al,[si]		; get next color value
	add	al,bl		; add a number to cycle through palette
	test	al,40h		; going frontward, or backward?
	jnz	gbackw
	and	al,3fh
	jmp	dclrok1
gbackw:
	and	al,3fh
	neg	al
	add	al,3fh
dclrok1:
	mov	[si+(rescolors-colors)],al	; keep track of current colors
	ret
.endp

.proc	distcolors	auto	; takes a mul factor in al, divides down
	mov	bl,al		; distorts all colors by factor
	mov	cx,16		; 16 palette registers
	mov	si,offset @dataseg:colors
dwdcloop:
	mov	al,[si]		; get palette value to change
	inc	si
	mov	dx,03c8h	; prepare to read from vga
	out	dx,al		; set address of color reg desired
	mov	dx,03c9h	; point to data register
	mov	bl,byte ptr haluclrs+1
	call	workonclr
	out	dx,al
	inc	si
	mov	bl,byte ptr haluclrs+3
	call	workonclr
	out	dx,al
	inc	si
	mov	bl,byte ptr haluclrs+5
	call	workonclr
	out	dx,al
	inc	si
	loop	dwdcloop		; get next
	ret
				; the colors
.endp


.proc	setcolors	auto	; takes a mul factor in al, divides down
	mov	bl,al
	mov	cx,16		; 16 palette registers
	mov	si,offset @dataseg:colors
wdcloop:
	mov	al,[si]		; get palette value to change
	inc	si
	mov	dx,03c8h	; prepare to read from vga
	out	dx,al		; set address of color reg desired
	mov	dx,03c9h	; point to data register
rept	3
	mov	al,[si]
	mul	bl
	mov	al,ah
	out	dx,al
	inc	si
endm
	loop	wdcloop		; get next
	ret
				; the colors
.endp
.ends




