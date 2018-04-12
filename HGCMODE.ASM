
IF vgmode EQ 81h
crtparm	db	00h,35h			; horizontal total: 54 characters
	db	01h,2dh			; horizontal displayed 45 chars
	db	02h,2eh			; horiz sync pos: at 46th char
	db	03h,07h			; horiz scan width: 7char clks
	db	04h,5bh			; vertical total 92 chars
	db	05h,02h			; vert adj: 2 scan lines
	db	06h,57h			; vert displayed: 87 char rows
	db	07h,57h			; vert sync pos: after 87th char row
	db	09h,03h			; max scan line : 4 scan lines per ch
crtplen	equ	($-crtparm)/2

biosdata	db	7		; crtmode
		dw	80		; crt_cols
		dw	8000h		; crt_len
		dw	0		; cur start
		dw	8 dup(0)	; cursor posn
		dw	0		; cursor mode
		db	0		; active page
crtcaddr	dw	3b4h		; addr 6845
crtmode		db	0ah		; CRT_MODE_SET value for port 3B8h
		db	0		; crt palletee
bioslen		equ	$-biosdata
ENDIF


IF vgmode EQ 81h
hgcmode	proc	near			; sets mode of herc to 720x348
	push	bp			; preserve caller regs
	mov	bp,sp
	push	si
	push	di
; update video bios area with reasonable values
	mov	ax,040h
	mov	es,ax
	mov	di,49h			; es:di = 0040:0049 Bios Data Area
	mov	si,offset biosdata
	mov	cx,bioslen
	rep	movsb
; set configuration switch
	mov	dx,3bfh			; dx = config switch port
	mov	al,1
	out	dx,al			; al bit 0 = 1 (allow graphics mode)
; blank the screen to avoid interference
	mov	dx,3b8h			; dx := crtc mode control reg
	xor	al,al
	out	dx,al
; program the crtc
	sub	dl,4			; dx := crtc addr reg port
	mov	si,offset crtparm
	mov	cx,crtplen
l01:	lodsw				; al= crtc reg#, ah=data for reg
	out	dx,ax
	loop	l01
; set graphics mode
	add	dl,4			; dx := 3b8h
	mov	al,crtmode		; al bit 1 = 1 (enable graphics mode)
					; al bit 3 = 1 (enable video )
	out	dx,al
	pop	di
	pop	si
	mov	sp,bp
	pop	bp
	ret
hgcmode	endp
ENDIF
