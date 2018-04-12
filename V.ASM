	title 'vga13'

;* include g:\pc\pcmac.asm */
include c:\powerc\pcmac.asm
modbeg vga13




;         mov    register,word ptr [bp+(number*2+4)]
;.dataseg
;vertincr	dw	0
;incr1		dw	0
;incr2		dw	0
;routine		dw	0
;rflag		db	0
;argx2		dw	0
;argx1		dw	0
;argy1		dw	0
;argy2		dw	0
;n		db	15
;vboff		dw	0
;.ends
argx1	equ	[bp+(1*2+4)]
argy1	equ	[bp+(2*2+4)]
argx2	equ	[bp+(3*2+4)]
argy2	equ	[bp+(4*2+4)]
n	equ	[bp+(5*2+4)]
vertincr	equ	[bp-6]
incr1		equ	[bp-8]
incr2		equ	[bp-10]
routine		equ	[bp-12]

procbeg	pixel13
	sub	sp,14		; make a clear stack frame for temp vars
	mov	bx,argx1
	mov	ax,argy1
	xchg	ah,al
	shr	ax,1
	shr	ax,1
	add	bx,ax
;	add	bx,origin offset
	mov	ax,bx
procend	pixel13


procbeg	grmode
	mov	ax,13h		; use mode 10h
	int	10h
procend	grmode

procbeg	txmode
	mov	ax,3h		; use mode 10h
	int	10h
procend	txmode
 
procbeg	fillscr
	mov	ax,argx1
	push	ax
	mov	ax,0a000h
	mov	es,ax
	mov	cx,7000h
	xor	si,si
	pop	ax
	rep	stosb
procend	fillscr


;            WRTGLINE(xsize,startoffset, dataptr );
; xsize is size in bytes of image line to draw
; startoffset is the offset into the video buffer to begin the write
; dataptr is a near pointer to the raw 8-bit screen data


procbeg	wrtgline
	mov	cx,argx1
	mov	ax,0a000h
	mov	es,ax
	mov	si,argx2
	mov	di,argy1
	rep	movsb
procend	wrtgline

;            FARWRTGLINE(xsize,startoffset, dataptr );
; xsize is size in bytes of image line to draw
; startoffset is the offset into the video buffer to begin the write
; dataptr is a far pointer to the raw 8-bit screen data

procbeg	farwrtgline
	push	ds
	mov	cx,argx1
	mov	ax,0a000h
	mov	es,ax
	mov	si,argx2
	mov	di,argy1
	mov	ax,argy2
	mov	ds,ax
	mov	ax,argy2
	rep	movsb
	pop	ds
procend	farwrtgline

procbeg	mmodfarwrtgline
	push	ds
	

	mov	cx,argx1
	mov	ax,0a000h
	mov	es,ax
	mov	si,argx2
	mov	bx,argy1
	mov	ax,argy2
	mov	ds,ax
	mov	ax,argy2
	mov	dx,03c4h
mfwglp:
	push	cx
	mov	ax,bx
	shr	ax,1
	shr	ax,1
	add	ax,n	; relatavise to correct buffer
	mov	di,ax
	mov	ax,bx
	and	ax,03h	; find which bit plane
	mov	cx,ax
	mov	al,1
	shl	al,cl
	mov	ah,al
	mov	al,2	; set the proper bit plane
	out	dx,ax
;	movsb		; mov a byte of data
			; get data from source array
	mov	al,[si]

	cmp	al,64	; see if this byte is a background color
	jb	gotone
	cmp	al,79
	ja	gotone
	jmp	gotnone	; leave this pixel alone!
gotone:
	mov	es:[di],al	; write over this pixel with source
gotnone:
	inc	bx
	inc	si

	cmp	ah,08h	; see if time to inc pointers
	jnz	noincrptr
	inc	di
noincrptr:
	pop	cx
	loop	mfwglp	; get next byte of data
	
	pop	ds
procend	mmodfarwrtgline

procbeg	scrollup
	push	ds
	mov	cx,64000-(320*4)
	mov	si,320*4
	mov	di,0
	mov	ax,0a000h
	mov	es,ax
	mov	ds,ax
	rep	movsb
	pop	ds
procend scrollup

offs	equ	[bp+(1*2+4)]
srcsize	equ	[bp+(2*2+4)]
ovlsize	equ	[bp+(3*2+4)]
obufptr	equ	[bp+(4*2+4)]
srcptr	equ	[bp+(5*2+4)]
srcseg	equ	[bp+(6*2+4)]
ovlptr	equ	[bp+(7*2+4)]
ovlseg	equ	[bp+(8*2+4)]

procbeg mergeline
	push	ds
	pop	es
	push	ds
	mov	ax,obufptr
	mov	di,ax
	mov	ax,srcptr
	mov	si,ax
	mov	ax,srcseg
	mov	ds,ax
	mov	cx,offs
	or	cx,cx
	jz	skipoffmov
	rep	movsb
skipoffmov:
	mov	cx,ovlsize
	or	cx,cx
	jz	mergfinish
	mov	bx,ovlptr
	mov	dx,ovlseg
cmploop:
	push	es
	mov	ax,dx
	mov	es,ax
	mov	al,es:[bx]
	inc	bx
	pop	es
	cmp	al,64
	jb	mgotone
	cmp	al,79
	ja	mgotone
	movsb
clcont:
	loop	cmploop
	jmp	mergfinish

mgotone:
	mov	es:[di],al
	inc	di
	inc	si
	jmp	clcont

mergfinish:
	mov	ax,srcsize
	sub	ax,offs
	sub	ax,ovlsize
	js	mergdone
	jz	mergdone
	mov	cx,ax
	rep	movsb
mergdone:
noovl:
	pop	ds
procend	mergeline

procbeg	modgrmode
	mov	ax,0013h
	int	10h
	mov	dx,3c4h
	mov	al,4
	out	dx,al
	inc	dx
	in	al,dx
	and	al,not 08h
	or	al,4h
	out	dx,al

	mov	dx,3ceh
	mov	al,5
	out	dx,al
	inc	dx
	in	al,dx
	and	al,not 10h
	out	dx,al
	dec	dx

	mov	al,6
	out	dx,al
	inc	dx
	in	al,dx
	and	al,not 02h
	out	dx,al

	mov	dx,3c4h
	mov	ax,0f02h		; enable all bit planes
	out	dx,ax

	mov 	ax,0a000h
	mov	es,ax
	xor	di,di
	mov	cx,8000h
	cld
	rep	stosw

; tweak the mode 320x400 256 color mode by not scanning each line twice
	mov	dx,3d4h
	mov	al,9
;	out	dx,al
	inc	dx
;	in	al,dx
	and	al,not 1fh
;	out	dx,al
	dec 	dx

;
; change the scanning from doubleword mode to byte mode, aloowing the
; crtc to scane more than 64k of video data.

	mov	al,14h
	out	dx,al
	inc	dx
	in	al,dx
	and	al,not 40h
	out	dx,al
	dec	dx
	mov	al,17h
	out	dx,al
	inc	dx
	in	al,dx
	or	al,40h	; turn on the byte mode bit, so mem is
                         ; scanned for video data in a purely
			; linear way, just as in modes 10h, and 12h
	out	dx,al
procend	modgrmode

procbeg	fmodfarwrtgline
	push	ds
	

	mov	ax,0a000h
	mov	es,ax
	mov	si,argx2
	mov	ax,argy2
	mov	ds,ax
	mov	ax,argy2
	mov	dx,03c4h

	mov	di,argy1
	mov	cx,argx1
	mov	ax,0102h
	out	dx,ax		; select only first bit plane
	rep	movsb		; write plane

	mov	di,argy1
	mov	cx,argx1
	mov	ax,0202h
	out	dx,ax		; select only second bit plane
	rep	movsb		; write plane

	mov	di,argy1
	mov	cx,argx1
	mov	ax,0402h
	out	dx,ax		; select only second bit plane
	rep	movsb		; write plane

	mov	di,argy1
	mov	cx,argx1
	mov	ax,0802h
	out	dx,ax		; select only second bit plane
	rep	movsb		; write plane
	pop	ds
procend	fmodfarwrtgline

procbeg	setstartadr
	mov	dx,3d4h
	mov	bx,argx1
	mov	ah,bh
	mov	al,0ch
	out	dx,ax
	mov	ah,bl
	mov	al,0dh
	out	dx,ax
procend	setstartadr

procbeg	imagemov
	push	ds
	mov	ax,0a000h
	mov	es,ax
	mov	ds,ax
	mov	cx,argx1
	mov	di,argy1
	mov	si,argx2
	mov	dx,3c4h
	mov	ax,0f02h		; enable all bit planes
	out	dx,ax
	mov	dx,03ceh		; set bit mask register to zero
					; to take all pixels from latches
	mov	ax,08h
	out	dx,ax
	rep	movsb

	mov	ax,0ff08h		; set bit mask register back to
	out	dx,ax			; writing to all bits

	pop	ds
procend	imagemov

procbeg	wrtplane
	push	ds
	mov	cx,argx1
	mov	ax,0102h
	shl	ah,cl
	mov	dx,03c4h
	out	dx,ax		; select only first bit plane

	mov	ax,0a000h
	mov	es,ax
	mov	si,argy2
	mov	ax,n
	mov	ds,ax

	mov	di,argy1
	mov	cx,argx2
	rep	movsb		; write plane

	pop	ds
procend	wrtplane


modend vga13
