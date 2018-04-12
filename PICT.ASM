	title 'pict'
_MODEL	equ	<SMALL>
;include f3dequ.inc
include model.inc

	public	pict	; entry point
;
.extrn	dec_to_word:auto,dec_to_dword:auto
.extrn	put_str:auto,put_chr:auto,put_newline:auto
.extrn	far_malloc:auto,far_free:auto
.extrn	str_cpye:auto,get_chr:auto
.extrn		open_h:auto,close_h:auto,read_h:auto,hget_str:auto
.extrn	hwword:auto,cecode:byte,kbuf:byte
.extrn	str_skipw:auto,put_beep:auto
;.extrn	goto_xy:auto
.extrn	missionstatus:word,nfdest:word,deathcode:word,patchcrash:word

; definition of mission status:
;
; bit 15 
; bit 14 abort via cntl-c
; bit 13 invincible plane
; bit 12 
; bit 11 killed bye an object
; bit 10 lost in space
; bit 9 crshlnded home
; bit 8 rescued
; bit 7 hit a building
; bit 6 crashlanded not home
; bit 5 ejected
; bit 4 homeflag
; bit 3 captured
; bit 2 landed at home
; bit 1 killed
; bit 0 abort in air


; pictnumber
; 0 happy landing
; 1 rescue
; 2 crsh not home
; 3 crsh home
; 4 flyby
; 6 brig
; 7 dead fall
; 8 captured
; 9 unknown not in plane
; 10 unknown in plane
; 11 corpse aa shell
; 12 corpse kla
; 13 corpse BB,crater


.dataseg
grflag		db	0
xoff		dw	0
pictnumber	dw	0
dispcolor	dw	15
nlines		dw	0
;hellomsg	db	'hi there, dickhead!  Select a HL screen 0-9: ',0
emegs		db	'read error',0
;pictname	db	'pcors3a.vga',0
pictname	db	64 dup(?)
pictdatname	db	'pict.dat',0
dfhandl		dw	0
pichandl		dw	0
ndmsg		db	'error: no pict.dat file found',0
				; warning, program assumes following two
				; words are sequential in memory
pxsz		dw	0
pysz		dw	0
pictseg		dw	0

.ends

.codeseg
	;assume cs:@codeseg,
	assume ds:@dataseg

.proc	grmode	auto
	mov	ax,13h		; use mode 10h
	int	10h
	mov	grflag,-1	; show we are in graphics mode
	ret
.endp

.proc	txmode	auto
	mov	ax,3h		; use mode 10h
	int	10h
	ret
.endp
 
;.proc	fillscr	auto
;	mov	ax,argx1
;	push	ax
;	mov	ax,0a000h
;	mov	es,ax
;	mov	cx,7000h
;	xor	si,si
;	pop	ax
;	rep	stosb
;	ret
;.endp


;            WRTGLINE(xsize,startoffset, dataptr );
; xsize is size in bytes of image line to draw
; startoffset is the offset into the video buffer to begin the write
; dataptr is a near pointer to the raw 8-bit screen data


;.proc	wrtgline	auto
;	mov	cx,argx1
;	mov	ax,0a000h
;	mov	es,ax
;	mov	si,argx2
;	mov	di,argy1
;	rep	movsb
;	ret
;.endp

;            FARWRTGLINE(xsize,startoffset, dataptr );
; xsize is size in bytes of image line to draw
; startoffset is the offset into the video buffer to begin the write
; dataptr is a far pointer to the raw 8-bit screen data
;
; asm adaption:
;  cx=xsize
;  si= source offset
;  di= dest offset
;  es= source segment

.proc	farwrtgline	auto
	push	ds
;	mov	cx,argx1
	mov	ax,es
	mov	ds,ax
	mov	ax,0a000h
	mov	es,ax
;	mov	si,argx2
;	mov	di,argy1
;	mov	ax,argy2
;	mov	ax,argy2
	rep	movsb
	pop	ds
	ret
.endp

.proc	delayit	auto
	push	ax
	mov	ax,1010h
	mul	ah
	pop	ax
	ret
.endp

.proc	readword	auto		; reads a line, returns dec number
			mov	bx,dfhandl
			mov	cx,12	; read file size
			mov	si,offset @dataseg:kbuf
			call	hget_str
			mov	si,offset @dataseg:kbuf
			call	str_skipw	; skip leading blanks or tabs
			call	dec_to_word
			ret
.endp

.proc	skippic	auto		; skips over a picture 
rnotherline:
			mov	bx,dfhandl
			mov	cx,40	; read file size
			mov	si,offset @dataseg:kbuf
			call	hget_str
			jc	breakout
			ja	breakout
			cmp	kbuf,0ch	; looking for ^L
			jnz	rnotherline
			clc
			ret
breakout:
			stc
			ret
.endp


.proc	readpict	auto
					; open pict file
			mov	si,offset @dataseg:pictdatname
			mov	ax,0000h
			call	open_h
			mov	dfhandl,bx
			jnc	datfile
			mov	si,offset @dataseg:ndmsg
			call	put_str
			call	get_chr
			stc
			ret
datfile:
			mov	cx,pictnumber
			or	cx,cx
			jz	noskippic
skippiclp:
			push	cx
			call	skippic
			pop	cx
			jc	noskippic
			ja 	noskippic
			loop	skippiclp

noskippic:
			call	readword	; get number
			mov	nlines,ax
			call	readword	; get number
;			call	wword
			mov	xoff,ax
			call	readword	; get number
			mov	bx,320
			mul	bx
			add	xoff,ax		; make a starting offset
;			call	wword
			mov	bx,dfhandl
			mov	cx,64	; read file size
			mov	si,offset @dataseg:pictname
			call	hget_str
;			call	put_str

			call	disppic		; put up image

			call	readword	; get color for display
			mov	dispcolor,ax

			mov	cx,nlines	; loop thru lines of text
			or	cx,cx
			jz	nolines
lineslp:
			push	cx
			call	readword
			push	ax
			call	readword
			pop	dx
			mov	dh,dl
			mov	dl,al		; set up dx with row/column
;			call	goto_xy
			mov	bx,dfhandl
			mov	cx,50	; read file size
			mov	si,offset @dataseg:kbuf
			call	hget_str
			mov	ax,ds
			mov	es,ax
			xor	al,al
			mov	bx,dispcolor
			mov	bp,si
			mov	ah,13h
			int	10h		; bios write to screen
			pop	cx
			loop	lineslp
nolines:

;			call	get_chr
			mov	bx,dfhandl
			call	close_h
			ret
.endp

.proc	disppic	auto		; throws up an image
			mov	si,offset @dataseg:pictname
			mov	ax,0000h
			call	open_h
			mov	pichandl,bx
			jc	nocmdfile
			mov	cx,4	; read file size
			mov	si,offset @dataseg:pxsz
			call	read_h
			jc	nocmdfile
			inc	pxsz
			inc	pysz		; take care of incompatibility
			mov	ax,pxsz
			or	ax,ax
			jz	nocmdfile
			js	nocmdfile
			cmp	ax,320
			jg 	nocmdfile
			mov	bx,pysz
			or	bx,bx
			jz	nocmdfile
			js	nocmdfile
			cmp	bx,200
			jg 	nocmdfile
			mul	bx		; get image size

;	mov	dx,1			; request 64k space
;	xor	ax,ax

	call	far_malloc
	mov	ax,es		; get memory segment pointer
	mov	pictseg,ax	; save
	jnc	nomaerror
	mov	cs:cecode,90
	ret		; leave immediately with error
nocmdfile:
	stc
			mov	cs:cecode,100
	ret
nomaerror:
	xor	di,di
	mov	cx,pysz
readlp:
	push	cx
			mov	bx,pichandl
			mov	cx,pxsz	; read file size
			mov	si,offset @dataseg:kbuf
			call	read_h
			mov	ax,pictseg
			mov	es,ax
			mov	si,offset @dataseg:kbuf
			mov	cx,pxsz
			rep	movsb
	pop	cx
	loop	readlp

	mov	ax,pxsz
	add	ax,7
	and	ax,NOT 7	; find nearest multiple of 8
	sub	ax,pxsz		; find difference
	mov	bx,pysz		; find #bytes to skip over before pallette
				; data is read
	mul	bx		; ax will now contain #junk bytes


;	call	wword
;	call	wword
;	push	ax
;	call	get_chr
;	pop	ax

	add	ax,2
	
	or	ax,ax
	jz	skipjunk	; no junk around
	mov	cx,ax
junklp:
	push	cx
	mov	cx,1
	mov	bx,pichandl
	mov	si,offset @dataseg:kbuf
	call	read_h
	pop	cx
	loop	junklp

skipjunk:


	mov	cx,256		; now read damn pallete
pallp:
	push	cx
	mov	cx,3
	mov	bx,pichandl
	mov	si,offset @dataseg:kbuf
	call	read_h
	pop	cx
	jc	rerror
	mov	ax,256
	sub	ax,cx
	mov	dx,3c8h
	out	dx,al
	call	delayit
	inc	dx
	mov	al,kbuf
	out	dx,al
	call	delayit
	mov	al,kbuf+1
	out	dx,al
	call	delayit
	mov	al,kbuf+2
	out	dx,al
	call	delayit
	loop	pallp
	jmp	norerror
rerror:
	mov	si,offset @dataseg:emegs
	call	put_str
	call	get_chr
norerror:


	mov	bx,pichandl
	call	close_h

	mov	cx,pysz
	xor	si,si
	mov	di,xoff			; start picture at desired offset
displp:
	push	cx
	mov	cx,pxsz
	push	si
	push	di
	mov	ax,pictseg
	mov	es,ax
	call	farwrtgline
	pop	di
	add	di,320
	pop	si
	add	si,pxsz
	pop	cx
	loop	displp
skipdsp:
	
	mov	ax,pictseg
	mov	es,ax
	call	far_free		; free the nice allocated ram

	ret
.endp

.proc	qgetch	auto
	cmp	grflag,0
	jz	stilltext
	call	get_chr
stilltext:
	ret
.endp


.proc	guykilled	auto
	mov	pictnumber,7
	cmp	deathcode,0
	jz	showkill
	mov	pictnumber,10
	cmp	deathcode,22
	jz	showkill
	mov	pictnumber,11
	cmp	deathcode,24
	jz	showkill
	mov	pictnumber,12
	cmp	deathcode,32
	jz	showkill
	mov	pictnumber,13
showkill:
	call	qgetch
	call	grmode
;	mov	grflag,-1
	call	readpict
	ret
.endp

; pict puts the video system in mode 13, and plops up the appropriate image
; specified by the attribute bits.
; pict takes a far pointer in es:si to buffer where data can be kept

.proc	pict	auto
;	mov	si,offset hellomsg
;	call	put_str
;	call	get_chr
;	sub	al,30h
;	js	fuck
;	cmp	al,0ah
;	jae	fuck
;	xor	ah,ah
;	mov	pictnumber,ax
	mov	ax,missionstatus
	mov	bx,ax
	test	ax,4000h
	jz	nofuck			; skip process if cntl-c
fuckjump:
	jmp	fuck
nofuck:
	test	ax,400h			; did we end up lost in space?
	jz	nospace			; no
	mov	pictnumber,14
	call	grmode
	call	readpict
	jmp	pictdone




nospace:
	test	ax,800h			; nulify next two lines if killed out
	jnz	skipn2
	test	ax,8			; if captured, don't bother with
	jnz	pict1			; crashland screen
	test	ax,2			; make sure didn't crash later
	jnz	pict2
skipn2:

	test	ax,40h			; crshlnd not home?
	jz	pict0
	test	ax,100h		; if rescued, then show pic
	jnz	pict1a
	test	ax,10h		; if not home, then skip cause drunk
	jz	pict1	
pict1a:
	mov	pictnumber,2		; show crshlnd pic
	call	grmode
;	mov	grflag,-1
	call	readpict
	jmp	pict1

pict2:	test	ax,20h		; have we ejected ?
	jnz	showcorpse	; if yes, then guy hit ground too hard
	mov	pictnumber,4
	call	grmode
;	mov	grflag,-1
	call	readpict
	jmp	pictdone

pict0:
	test	ax,200h
	jz	pict1
	mov	pictnumber,3		; show crshlnd pic
	call	grmode
;	mov	grflag,-1
	call	readpict
pict1:
	mov	ax,missionstatus
	test	ax,8			; captured?
	jz	pict3
	call	qgetch
	mov	pictnumber,8		; show crshlnd pic
	call	grmode
	call	readpict
	jmp	pictdone
pict3:
	test	ax,100h			; rescued?
	jz	pict4
	call	qgetch
	mov	pictnumber,1
	call	grmode
;	mov	grflag,-1
	call	readpict
	jmp 	pict8

pict4:
	test	ax,800h
	jz	pict5
	call	guykilled
	jmp	pictdone
showcorpse:
	call	qgetch
	mov	pictnumber,7
	call	grmode
;	mov	grflag,-1
	call	readpict
	jmp	pictdone
pict5:
	mov	bx,ax
	and	bx,16+4
	cmp	bx,16+4		; are we home and landed home?
	jnz	pict6
	test	ax,40h+200h	; did we already crashland?
	jnz	pict6
	test	ax,1
	jnz	pict8		; get out if abort
	call	qgetch
	mov	pictnumber,0
	call	grmode
;	mov	grflag,-1
	call	readpict
	jmp	pict8

pict6:	
	test	ax,10h		; did we end up at home?
	jnz	pict7
	test	ax,1
	jnz	pict8		; get out if abort
	call	qgetch
	mov	pictnumber,9
	call	grmode
;	mov	grflag,-1
	call	readpict
	jmp	pict8
pict7:
	test	ax,20h+200h	; are we still in our plane? no homecrshlnd?
	jnz	pict8		; no, so it isn't a flyby
	test	ax,1
	jnz	pict8		; get out if abort
	call	qgetch
	mov	pictnumber,5
	call	grmode
;	mov	grflag,-1
	call	readpict
	jmp	pict8

pict8:	mov	ax,nfdest
	or	ax,ax
	jz	pictdone
	call	qgetch
	mov	pictnumber,6
	call	grmode
;	mov	grflag,-1
	call	readpict
	jmp	pictdone

pictdone:
	cmp	grflag,0
	jnz	fuck		; if never switched to grmode, sw to txt mode
	call	txmode

;	call	get_chr
;	call	txmode
;	mov	ax,missionstatus
;	call	hwword
;	call	put_newline
fuck:
	ret
	.endp
.ends
	end


