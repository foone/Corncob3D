
	mov	bx,offset @dataseg:norot
	mov	si,offset @dataseg:rvec
	mov	dx,[bx+6]
	mov	ax,[bx]
	or	dh,dh		; test x,y to see if they are big enough
	jz	ysmal
	cmp	dh,-1
	jnz	ynsml
ysmal:	or	ah,ah
	jz	xsmal
	cmp	ah,-1
	jnz	ynsml
xsmal:				; x and y are too small to get a good angle	
	mov	ax,[bx+12]	; look at sign of z
	mov	dx,16384	; put a 90 degree angle into dx
	mov	cpa,0		; set up cosine and sign of them
	mov	cya,32767
	mov	spa,-32767
	mov	sya,0		; for zero yaw, but heavy pitch, man
	or	ax,ax		; test sign of z to determine sign of dx
	js	zpos
	neg	dx
	neg	spa		; reverse signs which need reversing
zpos:	mov	[si+2],dx	; set pitch angle to +- 90 deg
	mov	word ptr [si],0		; reset the yaw angle
	jmp	getrol		; now get the roll angle
ynsml:	push	si
	push	bx
	call	atn2
	pop	bx
	pop	si
	mov	[si],ax
	push	si
	call	ssin
	mov	sya,ax
	pop	si
	hmul	ax,[bx+6]
	push	dx
	push	si
	mov	ax,[si]
	call	scos
	mov	cya,ax
;	neg	ax
	pop	si
	hmul	ax,[bx]
	pop	ax
	add	ax,dx

	mov	dx,[bx+12]
	push	si
	push	bx
	call	atn2
	pop	bx
	pop	si
	neg	ax
	mov	[si+2],ax
getrol:	hmul	[bx+2],cya	;a 12

	push	dx
	hmul	[bx+8],sya	;a22
	pop	ax
	add	ax,dx		; now the y comp of y' axis is un yawed
	mov	xtemp,ax
	hmul	[bx+2],sya	; now do the x comp
	neg	dx
	push	dx
	hmul	[bx+8],cya
	pop	ax
	add	ax,dx		; now the x and y components are unyawed
	mov	ytemp,ax
	mov	ax,[si+2]	; get the pitch
	push	si
	call	scos		; get sign of pitch angle
	mov	cpa,ax
	pop	si
	hmul	ax,[bx+14]	; a32 * cos pitch
	mov	ax,dx
	call	wword
	push	dx
	mov	ax,[si+2]
	push	si
	call	ssin		; get sin
	mov	spa,ax
	pop	si
	hmul	ax,xtemp	; sin*x coord calced above
	mov	ax,dx
	call	wword
	pop	ax
	add	dx,ax		; this should be the new z coord height
	mov	ax,ytemp	; now we can calc the damn angle
	push	si
	call	atn2		; get the angle
	pop	si
	mov	[si+4],ax	; save the angle
