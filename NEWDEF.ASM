
IF newthtflag
IF xlatflag EQ 0
	push	di
	mov	cx,headersz	; loop through all the objects in the tile
	or	cx,cx
	jz	nonewtlp
newtlp:
	mov	ax,es:[di+21]	 ; [di] points to 1st byte of compressed object
	xor	ax,es:[di+4]	 ; xor the object type number with x&y low order
	xor	ax,es:[di+2]	 ; bits to decode proper object type number
	mov	es:[di+21],ax	 ; write back into object
	add	di,nbyteobj	 ; go to next object in tile
	loop	newtlp			; decode all the tiles
nonewtlp:
	pop	di
ENDIF
ENDIF
