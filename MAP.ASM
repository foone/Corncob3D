
	title 'map'
_MODEL	equ	<SMALL>
include model.inc
include	imath.INC
include f3dequ.inc
include	extrns.inc		; get extrnals
include 3dvid.inc
include	pixaddr1.inc		; pixel address routine
include		3dmac.inc
include ka.inc

IF slalom
mapmbflag equ 0
ELSE
IF mbflag
mapmbflag equ 1
ELSE 
mapmbflag equ 0
ENDIF
ENDIF


hmul	macro	var1,var2
	local	fxup
	mov	ax,var1
	mov	dx,var2
	imul	dx
	cmp	dx,8000h
	jnz	fxup
	mov	ah,-1
fxup:	shl	ax,1
	rcl	dx,1
	endm

madd	macro
	local	paxok,paxdn
	sar	ax,1
	sar	dx,1
	add	ax,dx
	cmp	ax,16383
	js	paxok
	mov	ax,16383
	jmp	short paxdn
paxok:	cmp	ax,-16383
	jns	short paxdn
	mov	ax,-16383
paxdn:	rol	ax,1
	endm

mmul	macro	var1,var2
	mov	ax,var1
	mov	dx,var2
	imul	dx
;	rol	dx,1
	endm
.public getfromtemplate
.public	maploop,bumpangles,mapobjbuf
IF mapmbflag EQ 1
.public mbdrawscene
.public	nomoveflag,mbptr
.public	letx,lety,letter,drawletter
ENDIF
	.extrn	xvec:word
;
.extrn		ox:word,oy:word,oz:word
.extrn		brdrcnt:word
	.extrn	wword:auto,decwword:auto,dwword:auto
	.extrn	wsp:auto
	.extrn	cecode:byte
	.extrn	words_to_dec:auto
	.extrn	get_chr:auto
	.extrn	put_str:auto
	.extrn	put_chr:auto
	.extrn	randr_w:auto,rand_w:auto
	.extrn	byte_to_hex:auto
	.extrn	word_to_dec:auto
	.extrn	dwords_to_dec:auto
	.extrn	muls_qw:auto
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	.extrn	egaline:auto
	.extrn	argx1:word,argx2:word,argy1:word,argy2:word
	ENDIF
	IF vgmode EQ 81h
	.extrn	hgcline:auto
	ENDIF
	.extrn	kline:auto
	.extrn	clhorline:auto
	.extrn	regal:near
	.extrn	words_to_dec:auto
.extrn		regflg:byte
.extrn	ssin:auto,scos:auto,csqrt:auto
.extrn	invincible:byte
.extrn	pgflg:byte	; flag which tells which video page is active
.extrn	divs_dw:auto	; double precision divide
.extrn	div_dw:auto
.extrn	hrobj:word
.extrn	hrwr1:word
.extrn	atn2:auto
.extrn	gwinr:word
.extrn	ptrgwinf:word
.extrn	ptrgwint:word
.extrn	gwinl:word
.extrn	hrflg:byte
.extrn	fillflg:byte
.extrn	gndcolor:byte
.extrn	hline:auto
IF vgmode EQ 81
.extrn	hgcline:auto
ENDIF
.extrn	clrup:byte
.extrn	clrdn:byte
.extrn	exit_ok:auto
.extrn	orvec:word
.extrn	crshflg:byte
.extrn	ejectflag:byte
.extrn	onrunwayflag:byte
.extrn	rtopv:word
.extrn	damageplane:auto
.extrn	dsqrt:auto
.extrn	objflt1mis:word,objflt1bomb:word
.extrn	objbsph:word,deathcode:word
.extrn	divs_qd:auto
.extrn	shakecnt:byte
.extrn	obj5d:word
.extrn	divrs_dw:auto
.extrn	divrs_qd:auto
.extrn		dxvec:word
.extrn	oticks:word
.extrn	totaldamage:word
.extrn	objtimtable:word
.extrn	memseg:word
.extrn	findexp:auto
.extrn	templatetable:word,ntemplates:word,extendedtypetbl:word
.extrn	missionstatus:word
.extrn	objman1:word,getkbit:auto,joytd:auto

.extrn	muls_dw:auto

.extrn	calcsin:auto,calcmat:auto,ncalcmat:auto,calcsin:auto,modhr:auto
.extrn	d3dobj:auto,drawmap:auto,flipage:auto
.extrn	epage:auto,flushtiles:auto,dotiles:auto


IF mapmbflag EQ 1
.extrn	tblist:word
.extrn	nulobj:word
.extrn	mbdrawnear:auto,drawnear:auto
.extrn	tbadd:auto
.extrn	expmov:auto
.extrn	copytable:auto,drawmemseg:auto
.extrn	kbuf:byte
.extrn	otopv:word,surfacev:word
.extrn	moveobs:auto
.extrn	matvmul:auto
.extrn	objcursor:word
;.extrn	lastdrawn:word
ENDIF
.extrn	youarehere:word,yahclr:byte

.extrn	orot:word,norot:word,scncode:byte,frmticks:word,ofrmticks:word
.extrn	z0:word,ticksf:word,maxofrm:word,minofrm:word
.extrn	memobjbuf:word
.extrn		far_malloc:auto
.extrn	wcr:auto
.extrn	curtilex:word,curtiley:word
.extrn	drawgs:auto
.extrn	putbackintable:auto
.extrn	viewkludge:word
.extrn	clrhq:byte,changewallobjs:auto,framecount:word
.extrn	desireflag:byte,recalcmats:auto,gbflg:byte
.extrn	survclr:byte


.dataseg
modeflag	db	0
mapobjbuf	db	nbytexp dup (?)
mbptr	dw	?
coordsave	dw	9 dup (?)
presenttype	dw	?
presentqual	db	?
nclosest	dw	0
stepsz	dw	50
nomoveflag	db	0
olddesireflag	db	0
IF mapmbflag EQ 1
mbdefclr	db	15
nbytelet	equ	32
nlet		equ	12

letter		dw	0
letx		dw	0
lety		dw	0
mbdefz		dw	-1,-1			; default height


numx 	db	2,7,7,8,8,8,8,7,7,2,2,1,1,1,1,2,16 dup(0),2,6,4,4,4,3,26 dup(0)
     	db	8,1,1,8,8,8,8,6,6,3,3,1,20 dup(0)
     	db	1,6,6,8,8,8,8,6,6,2,2,8,8,1,18 dup(0)
     	db	8,8,8,1,1,3,26 dup(0)
     	db	1,6,6,8,8,8,8,6,6,1,1,1,1,8,18 dup(0)
     	db	7,3,3,1,1,1,1,3,3,6,6,8,8,8,8,6,6,4,4,1,12 dup(0)
     	db	2,8,8,8,8,2,26 dup(0)
     	db	3,6,6,8,8,8,8,6,6,3,3,1,1,1,1,3,6,8,8,8,8
     	db	6,6,3,3,1,1,1,1,3,2 dup(0)
     	db	1,6,6,8,8,8,8,6,6,3,3,1,1,1,1,3,3,6,6,8,12 dup(0)
     	db	5,5,3,8,28 dup(0)
     	db	2,8,30 dup(0)
     	db	4,5,5,5,5,4,4,4,24 dup(0)
     	db	8,1,1,1,1,8,1,6,24 dup(0)

numy 	db	1,1,1,2,2,12,12,13,13,13,13,12,12,2,2,1,16 dup(0),1,1,1,13
     	db	13,12,26 dup(0)
     	db	1,1,1,7,7,10,10,13,13,13,13,11,20 dup(0)
     	db	1,1,1,3,3,6,6,8,8,8,8,13,13,13,18 dup(0)
     	db	1,13,8,8,8,13,26 dup(0)
     	db	1,1,1,3,3,6,6,8,8,8,8,13,13,13,18 dup(0)
     	db	13,13,13,10,10,3,3,1,1,1,1,3,3,6,6,8,8,8,8,6,12 dup(0)
     	db	13,13,13,10,10,1,26 dup(0)
     	db	1,1,1,3,3,5,5,7,7,7,7,5,5,3,3,1,7,9,9,11,11
     	db	13,13,13,13,11,11,9,9,7,2 dup(0)
     	db	1,1,1,3,3,11,11,13,13,13,13,11,11,9,9,7,7,7,7,8,12 dup(0)
     	db	2,12,7,7,28 dup(0)
     	db	7,7,30 dup(0)
     	db	1,1,1,2,2,2,2,1,24 dup(0)
     	db	1,1,1,13,13,13,7,7,24 dup(0)
ENDIF

.ends

.codeseg

;assume		cs:@codeseg, 
	assume ds:@dataseg, es:@dataseg
IF mapmbflag EQ 1
.proc	mbdrawscene	auto
	mov	ax,cs:frmticks
	mov	cl,3
	shr	ax,cl
	bndck	maxofrm,minofrm		; don't allow divide by zero, or
					; too lengthy frames
	mov	ofrmticks,ax
	mov	cs:frmticks,0		; clear frame counter
	cmp	nomoveflag,0
	jnz	skipcrap
	call	epage			; erase messy borders on page
	mov	ax,orvec+2
	mov	viewkludge,ax
	call	modhr
	mov	hrflg,-1		; turn on fills
	mov	si,offset @dataseg:hrobj
	call	d3dobj
	mov	hrflg,0			; turn off fills
skipcrap:
	call	drawmemseg		; let objects flow into the tables
	call	expmov
	call	mbdrawnear
;	call	drawnear
	call	copytable		; and let them flow back into memseg?
	call	dotiles
	call	flipage
	ret
.endp

.proc	savethemz2	auto
	mov	si,mbptr
	mov	ax,ds
	mov	es,ax
	mov	cx,4
	mov	di,offset @dataseg:coordsave
	cld
	rep	movsw			; save coords of object in buffer
	ret
.endp

.proc	restorethemz2	auto
	mov	ax,ds
	mov	es,ax
	mov	cx,4
	mov	si,offset @dataseg:coordsave
	mov	di,mbptr
	cld
	rep	movsw			; save coords of object in buffer
	ret
.endp

.proc	savethem	auto
	mov	si,offset @dataseg:ox
	mov	ax,ds
	mov	es,ax
	mov	cx,9
	mov	di,offset @dataseg:coordsave
	cld
	rep	movsw			; save coords of object in buffer
	ret
.endp

.proc	restorethem	auto
	mov	ax,ds
	mov	es,ax
	mov	cx,9
	mov	si,offset @dataseg:coordsave
	mov	di,offset @dataseg:ox
	cld
	rep	movsw			; save coords of object in buffer
	ret
.endp

IF 1 EQ 0
.proc	closeup	auto		; brings object up for a closeup
	mov	di,offset @dataseg:kbuf
	push	si
	mov	cx,nbytexp
	mov	ax,ds
	mov	es,ax
	cld
	rep	movsb
	mov	si,offset @dataseg:kbuf
	mov	ax,ox
	mov	dx,ox+2
	mov	[si],ax
	mov	[si+2],dx
	mov	ax,oy
	mov	dx,oy+2
	mov	[si+4],ax
	mov	[si+6],dx
	mov	dx,oz+2
	mov	ax,oz
	sub	ax,32000
	sbb	dx,0
	mov	[si+10],dx
	mov	[si+8],ax
	push	si
	call	d3dobj
	pop	si
	call	flipage
	call	d3dobj
	pop	si
	mov	dx,cs:oticks
waitloop:
	mov	ax,cs:oticks
	sub	ax,dx
	test	ax,1024
	jz	waitloop
	ret
.endp
ENDIF

.proc	getstepsz	auto
	mov	al,scncode
	and	al,7fh
	cmp	al,11
	ja	nostepszchange
	cmp	al,1
	jbe	nostepszchange
	mov	bl,al
	mul	bl
	mov	bx,400
	mul	bx
	mov	stepsz,ax
	mov	scncode,0
nostepszchange:
	ret
.endp

.proc	onestep	auto
	mov	ax,stepsz
	cwd
	dwtadj
	push	dx
	push	ax
	.abs_d	dx,ax
	shl	ax,1
	rcl	dx,1
	or	dx,dx
	pop	ax
	pop	dx
	jnz	clipstepsz
	jmp	stepszfine
clipstepsz:
	mov	ax,32767
	or	dx,dx
	jns	stepszfine
	neg	ax
stepszfine:
	mov	xvec,ax	; move forward
	mov	xvec+2,0
	mov	xvec+4,0
	mov	si,offset @dataseg:xvec
	mov	bx,offset @dataseg:norot
	mov	di,offset @dataseg:surfacev
	call	matvmul
	call	moveobs
	ret
.endp

.proc	otopvtombptr	auto
	mov	si,offset @dataseg:xvec
	mov	bx,offset @dataseg:norot
	mov	di,offset @dataseg:surfacev
	call	matvmul
	mov	si,mbptr
	xor	bx,bx
	mov	ax,surfacev
	cwd
	add	[si],ax
	adc	[si+2],dx
	mov	ax,surfacev+2
	cwd
	add	[si+4],ax
	adc	[si+6],dx
	mov	ax,surfacev+4
	cwd
	add	[si+8],ax
	adc	[si+10],dx
	ret
.endp

.proc	showcursor	auto	;
	mov	si,offset @dataseg:ox
	mov	di,mbptr
	cmp	word ptr [di+24],0
	jz	turncursoron
	ret
turncursoron:
	mov	cx,9
	mov	ax,ds
	mov	es,ax
	cld
	rep	movsw		; mov coords of cursor to our view position
	xor	ax,ax
	mov	xvec,32767
	mov	xvec+2,ax
	mov	xvec+4,ax	; we will put the cursor this far ahead of us
	call	otopvtombptr
	mov	word ptr [si+24],1		; turn object on
	mov	bx,si
	mov	si,tblist	; now prepare to add this to the table
	call	tbadd
	ret
.endp

.proc	hidecursor	auto
	mov	word ptr [si+24],0
	ret
.endp

.proc	movcursor	auto
	mov	ax,orvec+2		; save current pitch on stack
	push	ax
	mov	orvec+2,0		; set to zero
	mov	bx,offset @dataseg:orvec
	call	calcsin
	mov	si,offset @dataseg:orot
	call	calcmat
	mov	si,offset @dataseg:norot
	call	ncalcmat


	mov	si,mbptr		; point at our z coord
	mov	ax,[si+8]		; make sure this can't change z coord
	push	ax
	mov	ax,[si+10]
	push	ax
;	call	joytd
;	sub	ax,200h			; center it
;	sub	bx,200h			; center it
	call	getjoy
	neg	ax
	neg	bx
	push	bx
	mov	cl,5
	sal	ax,cl
	mov	bx,stepsz
	sal	bx,1
	imul	bx
	mov	xvec+2,dx
	pop	ax
	mov	cl,5
	sal	ax,cl
	mov	bx,stepsz
	sal	bx,1
	imul	bx
	mov	xvec,dx
	mov	xvec+4,0
	call	otopvtombptr
	mov	si,mbptr
	pop	ax			; restore old z coord
	mov	[si+10],ax
	pop	ax			; restore old z coord
	mov	[si+8],ax
	pop	ax
	mov	orvec+2,ax			; restore our old angles

	call	pgupanddown		; apply pg up and down keys to z coord

	mov	bx,offset @dataseg:orvec
	call	calcsin
	mov	si,offset @dataseg:orot
	call	calcmat
	mov	si,offset @dataseg:norot
	call	ncalcmat
	ret
.endp

.proc	getclosest	auto
	mov	si,mbptr
	cmp	word ptr [si+24],0
;	jnz	cursoristhere
	jmp	cursoristhere
	
noneareclose:
	stc
	ret
cursoristhere:
	call	savethem		; save our present coords
	mov	si,mbptr
	mov	di,offset @dataseg:ox
	mov	ax,ds
	mov	es,ax
	cld
	mov	cx,9
	rep	movsw
	mov	nomoveflag,-1
	mov	cx,3
crapllop:
	push	cx
	call	mbdrawscene
	pop	cx
	loop	crapllop
	mov	nomoveflag,0
	call	restorethem
	mov	si,tblist
	mov	ax,[si]		; get number of objects in near table
	or	ax,ax
	jz	noneareclose
	sub	ax,nclosest	; there must be at least this many in table
	ja	plentyofclose
	mov	nclosest,0
plentyofclose:
	add	ax,ax
	add	si,2
	add	si,ax
	mov	bx,mbptr
	cmp	[si],bx
	jnz	foundone
	cmp	ax,2
	jbe	noneareclose
	sub	si,2
foundone:
	clc
	mov	si,[si]
;	mov	lastdrawn,si
	ret			; return with object in [si]
.endp	

.proc	setqualcode	auto
	mov	si,mbptr
	mov	cl,4
	and	ax,7		; just to be sure
	ror	ax,cl
	and	word ptr [si+24],NOT 07000h
	or	word ptr [si+24],ax
	ret
.endp

.proc	qualcodescan	auto
	mov	si,mbptr
	cmp	word ptr [si+24],0
	jnz	reallydosetcode
	ret
bagit:
	cmp	al,9
	jnz	bagit2
	mov	si,mbptr
	xor	word ptr [si+24],200h	; toggle cmplt bit
	mov	scncode,0
bagit2:
	ret
bagitl:
	cmp	al,8
	jnz	bagit
	mov	si,mbptr
	xor	word ptr [si+24],800h	; toggle special bit
	mov	scncode,0
	ret
reallydosetcode:
	mov	al,scncode
	or	al,al
	jns	bagit
	and	al,7fh
	sub	al,3bh
	js	bagit
	cmp	al,8
	jae	bagitl
	mov	scncode,0
	xor	ah,ah
	mov	presentqual,al
	call	setqualcode
	ret
.endp

.proc	getqualcode	auto
	mov	si,mbptr
	mov	ax,word ptr [si+24]
	mov	cl,4
	rol	ax,cl
	and	al,7
;	mov	presentqual,al
	ret
.endp

IF 1 EQ 0
.proc	mbptrsearch	auto		; searches near table for object
					; pointed to by near table
	mov	si,tblist
	mov	cx,[si]
	or	cx,cx
	jz	didntfind
	add	si,4			; point to first entry in table
mbsrch:
	mov	ax,[si]			; compare to mbptr
	cmp	ax,mbptr
	jz	matchfound
	add	si,2
	loop	mbsrch
didntfind:
	stc
	ret
matchfound:
	clc
	ret				; if found, table address given in si
.endp
ENDIF

.proc	mbnumbers	auto
	mov	si,mbptr
	cmp	si,offset @dataseg:objcursor
	jnz	drawonyoungman
	cmp	word ptr [si+24],0
	jnz	drawonyoungman
	ret				; don't draw numbers for no object
drawonyoungman:
	mov	letx,10
	mov	lety,340
	mov	dx,[si+2]
	mov	ax,[si]
	call	drawdword
	mov	letx,130
	mov	lety,340
	mov	dx,[si+6]
	mov	ax,[si+4]
	call	drawdword
	mov	letx,250
	mov	lety,340
	mov	dx,[si+10]
	mov	ax,[si+8]
	cmp	ax,mbdefz		; if set at default ht, make ht bleed
	jnz	nobleed
	cmp	dx,mbdefz+2
	jnz	nobleed
	mov	mbdefclr,0
nobleed:
	call	drawdword

	mov	mbdefclr,15
	mov	letx,310
	mov	lety,340
	mov	dx,0
	mov	ax,[si+12]
	call	drawdword

	mov	mbdefclr,15
	mov	letx,380
	mov	lety,340

	test	word ptr [si+24],0800h
	jz	nospecbitset
	mov	mbdefclr,0dh		; light purp
nospecbitset:
	test	word ptr [si+24],0200h
	jz	nocmpltbitset
	test	cs:oticks,512+256	; hmm
	jnz	nocmpltbitset
	mov	mbdefclr,1		; dark blue if completed
nocmpltbitset:
	call	getqualcode
	xor	ah,ah
	inc	al
	call	drawword
	mov	mbdefclr,15
	mov	letx,580
	mov	lety,340
	mov 	ax,[si+72]
	call	drawword
	ret
.endp

	
	
.proc	mbguts	auto
	mov	mbptr,offset @dataseg:objcursor
	mov	objcursor+24,0		; turn cursor off
	mov	scncode,82h		; simulate selection of speed 1
	call	getstepsz
mbmainloop:
	cmp	cs:cecode,0
	jnz	zowerror

	mov	si,mbptr
	cmp	word ptr [si+24],0
	jz	justdrawasshole
	cmp	scncode,23h+80h
	jnz	nolockht
	mov	scncode,0
	mov	al,38h		; check status of alt
	call	getkbit
	or	al,al
	jz	nolockht1
setmbdefz:
	mov	ax,[si+8]	; put current object height into defz
	mov	mbdefz,ax
	mov	ax,[si+10]	; put current object height into defz
	mov	mbdefz+2,ax
	jmp	nolockht
nolockht1:
	mov	ax,mbdefz	; move object to the set coords
	mov	[si+8],ax
	mov	ax,mbdefz+2
	mov	[si+10],ax
nolockht:
	or	word ptr [si+24],400h
justdrawasshole:
	call	mbdrawscene
	mov	si,mbptr
	and	word ptr [si+24],NOT 400h

	call	mbnumbers
	cmp	scncode,1+80h
	jnz	bannanflap
	jmp	mapmode1
zowerror:
	stc
	ret
bannanflap:
	cmp	scncode,22h+80h
	jnz	nokllk
	xor	ax,ax
	mov	scncode,al
	mov	objcursor+8,ax
	mov	objcursor+10,ax
nokllk:
	call	qualcodescan

	mov	ax,nclosest
	cmp	scncode,4ah+80h
	jnz	nokplus
	mov	scncode,0
	inc	ax
nokplus:
	cmp	scncode,4eh+80h
	jnz	nokminus
	mov	scncode,0
	dec	ax
	jns	nokminus
	xor	ax,ax
nokminus:
	cmp	ax,nclosest
	jz	farmfresh
	mov	nclosest,ax
	jmp	intocloseest
farmfresh:


	cmp	scncode,39h+80h
	jnz	nospcbar
cursortoclosest:
	mov	scncode,0
	mov	nclosest,0
intocloseest:
	mov	si,mbptr
	cmp	si,offset @dataseg:objcursor
	jz	cursorthere
	mov	si,offset @dataseg:objcursor
	cmp	word ptr [si+24],0
	jnz	beepclosest1
	mov	word ptr [si+24],1
	mov	mbptr,si
	mov	bx,si
	mov	si,tblist	; now prepare to add this to the table
	call	tbadd
cursorthere:
	call	getclosest
	jc	beepclosest
	mov	mbptr,si
	mov	bx,[si+72]	; get object type
	mov	presenttype,bx
	mov	word ptr objcursor+24,0		; remove cursor
	jmp	nospcbar
beepclosest:
	mov	al,7
	call	put_chr
	mov	cs:cecode,70
	jmp	zowerror
beepclosest1:
	mov	cs:cecode,71
	mov	al,7
	call	put_chr
	jmp	zowerror
	mov	si,offset @dataseg:objcursor
	cmp	si,mbptr
	jz	nospcbar
	mov	mbptr,si
	cmp	word ptr [si+24],0
	jnz	nospcbar
	call	showcursor
nospcbar:
	mov	ax,cs:oticks
	mov	bx,32
	mul	bx
	mov	objcursor+12,ax
	mov	ax,cs:oticks
	mov	bx,10
	mul	bx
	mov	objcursor+14,ax
	mov	ax,cs:oticks
	mov	bx,6
	mul	bx
	mov	objcursor+16,ax

	mov	al,1eh			; skip moving if a key is held down
	call	getkbit
	or	al,al
	jz	moveusaround		; if a key up, then move us around
	jmp	steadyasshegoes

moveusaround:
	mov	al,38h
	call	getkbit
	or	al,al
	jz	doourangles
	call	movcursor
	jmp	skipourangles
doourangles:

	call	joytd
	sub	ax,200h			; center it
	sub	bx,200h			; center it
	mov	cx,ax
	neg	cx
	neg	bx
	call	bumpangles

skipourangles:
	mov	bx,offset @dataseg:orvec
	call	calcsin
	mov	si,offset @dataseg:orot
	call	calcmat
	mov	si,offset @dataseg:norot
	call	ncalcmat

	mov	si,offset @dataseg:ox
	call	pgupanddown
	cmp	oz+2,10
	jl	steadyasshegoes
	mov	oz+2,9
	mov	oz,-1

steadyasshegoes:

	call	getstepsz
	mov	al,3ah+80h
	cmp	scncode,al
	jnz	noinstalevel
	xor	ax,ax
	mov	scncode,al
	mov	orvec+2,ax
	mov	orvec+4,ax
noinstalevel:
	mov	al,4ch
	call	getkbit
	or	al,al
	jz	noonestep
	mov	ax,stepsz
	.abs_w	ax
	mov	stepsz,ax
	call	onestep
noonestep:
	mov	al,52h
	call	getkbit
	or	al,al
	jz	noonestep1
	mov	ax,stepsz
	.abs_w	ax
	mov	stepsz,ax
	neg	stepsz
	call	onestep
	mov	ax,stepsz
	.abs_w	ax
	mov	stepsz,ax
noonestep1:

	cmp	scncode,2ah+80h
	jnz	noshift
	mov	scncode,0
	mov	si,offset @dataseg:objcursor
	mov	ax,si
	sub	ax,mbptr		; if already on cursor, skip this
	jnz	noshift0
	cmp	word ptr [si+24],0
	jnz	noshift
noshift0:
	mov	mbptr,si
	call	showcursor
noshift:
	cmp	scncode,1dh+80h
	jnz	noshift1
	mov	scncode,0
	mov	si,offset @dataseg:objcursor
	cmp	si,mbptr		; is cursor on?
	jnz	noshift1
	mov	mbptr,si
	call	hidecursor
noshift1:
	cmp	scncode,20h+80h
	jnz	noshift2
	mov	scncode,0
	mov	si,mbptr
	cmp	si,offset @dataseg:objcursor
	jz	noshift2
	mov	word ptr [si+24],0
	mov	di,offset @dataseg:objcursor
	mov	ax,ds
	mov	es,ax
	cld
	mov	cx,6
	rep	movsw
	mov	si,offset @dataseg:objcursor
	mov	mbptr,si
	mov	word ptr [si+24],1
	mov	bx,si
	mov	si,tblist
	call	tbadd
noshift2:
	cmp	scncode,2eh+80h
	jz	noshift3a
	jmp	noshift3
noshift3a:
	mov	scncode,0
	cmp	mbptr,offset @dataseg:objcursor
	jz	createproceed1

	mov	si,offset @dataseg:objcursor
	cmp	word ptr [si+24],0
	jnz	beepclosest2
	mov	word ptr [si+24],1
	mov	mbptr,si
	mov	bx,si
	mov	si,tblist	; now prepare to add this to the table
	call	tbadd
	jmp	createproceed

beepclosest2:
	mov	al,7
	call	put_chr
	jmp	noshift3

createproceed1:
	mov	si,mbptr
	cmp	word ptr [si+24],0
	jnz	createproceed
	call	showcursor		; turn on cursor first
	call	mbdrawscene
	call	mbdrawscene
createproceed:
	mov	si,offset @dataseg:mapobjbuf		; point to memory
	mov	bx,ntemplates
	shr	bx,1
	mov	bx,presenttype			; assume same as last time
	call	getfromtemplate
	jnc	notemperr
	mov	cs:cecode,62
	jmp	zowerror
notemperr:
	mov	di,offset @dataseg:mapobjbuf		; point to memory
	mov	si,offset @dataseg:objcursor
	mov	ax,ds
	mov	es,ax
	cld
	mov	cx,6
	rep	movsw
	mov	objcursor+24,0		; turn off cursor

	mov	si,offset @dataseg:mapobjbuf		; point to memory
	call	putbackintable			; start as a timed object
	mov	mbptr,si
	mov	al,presentqual
	call	setqualcode			; give the default quality
noshift3:
	cmp	mbptr,offset @dataseg:objcursor
	jz	mbloop2

	mov	si,mbptr
	mov	bx,[si+72]	; fetch object code
	mov	presenttype,bx

	mov	dx,0
	cmp	scncode,0dh+80h
	jnz	notminus
	mov	scncode,0
	inc	bx
	mov	dx,1
notminus:
	cmp	scncode,0ch+80h
	jnz	notplus
	mov	scncode,0
	dec	bx
	mov	dx,-1
notplus:

	or	dx,dx		; has a change been requested?
	jz	mbloop2		; no, so don't try to change it!

chktypebounds:
	or	bx,bx
	jns	notplus1
	mov	bx,ntemplates
notplus1:
	cmp	bx,ntemplates	; check against number of templates
	jbe	notminus1	; panic, bad encode
	mov	bx,0
notminus1:
	cmp	presenttype,bx
	jz	mbloop2
	push	dx
	mov	si,mbptr
	call	validatetype
;	clc
	pop	dx
	jnc	typeok
	add	bx,dx		; continue in same direction we were going
	jmp	chktypebounds
typeok:
	call	savethemz2
	mov	si,mbptr
	call	getfromtemplate
	jnc	notbadencode
	mov	cs:cecode,65
	jmp	zowerror
notbadencode:
	mov	si,mbptr
	call	restorethemz2
mbloop2:


	mov	al,1eh			; change objects orientation if a
					; key is held down
	call	getkbit
	or	al,al
	jz	skipobjang

	call	getjoy			; read joystick 

	mov	cx,ax
	neg	cx
	neg	bx
	call	bumpobjangles
	mov	al,4ch			; slap angles to nearest axis if numpad
	call	getkbit			; 5 is pressed
	or	al,al
	jz	skipobjang
	mov	si,mbptr
	add	word ptr [si+12],03fffh	; add some, so it make slap centered
	and	word ptr [si+12],0c000h	; slapit to closest angle
	add	word ptr [si+14],03fffh	; add some, so it make slap centered
	and	word ptr [si+14],0c000h	; slapit to closest angle
	add	word ptr [si+16],03fffh	; add some, so it make slap centered
	and	word ptr [si+16],0c000h	; slapit to closest angle

skipobjang:

	cmp	scncode,32h+80h
	jz	mapmode1
	jmp	mbmainloop
mapmode1:
	mov	scncode,0
	xor	ax,ax
	mov	surfacev,ax
	mov	surfacev+2,ax
	mov	surfacev+4,ax
	mov	objcursor+24,0		; turn off cursor
	call	mbdrawscene
	call	flushtiles		; flush all info back into tiles
	clc
	ret
.endp

.proc	validatetype auto
	or	bx,bx
	js	badencode2
	cmp	bx,ntemplates	; check against number of templates
	ja	badencode2	; panic, bad encode
	push	si		; prepare for copying
	mov	si,bx
	add	si,bx		; double it to get offset into table
	add	si,offset @dataseg:extendedtypetbl
	mov	ax,[si]		; make si point at the base of template
	shr	ax,1
	rcr	ax,1		; put carry = that bit in extendedtype
	pop	si
	ret
badencode2:
	stc
	ret
.endp

.proc	getfromtemplate auto
	cmp	bx,ntemplates	; check against number of templates
	ja	badencode1	; panic, bad encode
	push	si		; prepare for copying
	push	di
	push	es
	mov	ax,ds
	mov	es,ax		; prepare segment register
	cld
	mov	di,si		; make our target targetted for movsw
	mov	si,bx
	add	si,bx		; double it to get offset into table
	add	si,offset @dataseg:templatetable
	mov	si,[si]		; make si point at the base of template
	mov	cx,nbytexp	
	rep	movsb		; move all the bytes in a flash!

	pop	es
	pop	di
	pop	si
	clc
	ret
badencode1:
	stc
	ret
.endp
ENDIF

IF slalom
.proc	getfromtemplate auto
	cmp	bx,ntemplates	; check against number of templates
	ja	badencode1	; panic, bad encode
	push	si		; prepare for copying
	push	di
	push	es
	mov	ax,ds
	mov	es,ax		; prepare segment register
	cld
	mov	di,si		; make our target targetted for movsw
	mov	si,bx
	add	si,bx		; double it to get offset into table
	add	si,offset @dataseg:templatetable
	mov	si,[si]		; make si point at the base of template
	mov	cx,nbytexp	
	rep	movsb		; move all the bytes in a flash!

	pop	es
	pop	di
	pop	si
	clc
	ret
badencode1:
	stc
	ret
.endp
ENDIF


.proc	mapkey	auto
IF mapmbflag EQ 1
	cmp	scncode,30h+80h
	jnz	nombmode
	mov	scncode,0
	call	mbguts
	jnc	nombmode
	ret
nombmode:
ENDIF
	mov	al,47h
	call	getkbit
	or	al,al
	jz	nohomekey
	mov	dx,oz+2
	mov	ax,oz
	push	dx
	push	ax
	call	restoreox	; get back original coords
	xor	ax,ax
	mov	orvec,ax
	mov	orvec+2,16384
	mov	orvec+4,ax
	call	recalcmats
	pop	ax
	pop	dx
	mov	oz+2,dx
	mov	oz,ax
nohomekey:
	mov	al,2ah
	call	getkbit
	or	al,al
	jnz	mapxlat1

;	mov	al,1dh
;	call	getkbit
;	or	al,al
;	jz	donuttin
	jmp	mapxlat
mapxlat1:

	call	joytd
	sub	ax,200h			; center it
	sub	bx,200h			; center it
	mov	cx,ax
	neg	cx
	neg	bx
	call	bumpangles

	mov	bx,offset @dataseg:orvec
	call	calcsin
	mov	si,offset @dataseg:orot
	call	calcmat
	mov	si,offset @dataseg:norot
	call	ncalcmat
donuttin:
	clc
	ret
mapxlat:
	mov	si,offset @dataseg:ox
	call	kinetic
	clc
	ret
.endp


.proc	pgupanddown	auto
	mov	al,51h
	xor	bx,bx
	push	bx
	call	getkbit
	pop	bx
	or	al,al
	jz	nomapup1
	mov	ax,oz+2
	cmp	ax,210
	jae	nomapup1
	mov	bx,200h*2
nomapup1:
	mov	al,49h
	push	bx
	call	getkbit
	pop	bx
	or	al,al
	jz	nomapup
	mov	ax,oz+2
	jz	nomapup
	mov	bx,-200h*2
nomapup:
	cmp	bx,0
	jz	nomapupult
	mov	dx,oz+2
	mov	ax,oz
	rept	4
	shr	dx,1
	rcr	ax,1
	endm
	add	ax,40			; don't let it go below 4
	adc	dx,0
	call	muls_dw
	mov	bx,200h*2
	call	divs_dw	
	dwtadj
	push	ax
	push	dx
	mov	al,1fh			; look for s key for slow
	call	getkbit
	jz	noslow
	pop	dx
	pop	ax
	or	dx,dx
	js	sunpop
	mov	ax,1000
	mov	dx,0
	jmp	reunpop
sunpop:
	mov	ax,-1000
	mov	dx,-1
	jmp	reunpop
noslow:
	pop	dx
	pop	ax
reunpop:
	add	[si+8],ax
	adc	[si+10],dx
nomapupult:
	mov	ax,[si+10]		; don't let z drop below zero
	or	ax,ax
	jns	abovefine
	xor	ax,ax
	mov	[si+10],ax
	mov	[si+8],ax
abovefine:
	ret
.endp

.proc	getjoy	auto		; gets some joystick info, clips small
				; movements
	push	si
	call	joytd
	pop	si
	sub	ax,200h			; center it
	sub	bx,200h			; center it
	push	ax
	.abs_w	ax		; let's see if close to center
	cmp	ax,20h
	ja	skipaxgb
	pop	ax
	xor	ax,ax		; then force it to be centerd
	push	ax
skipaxgb:
	pop	ax
	push	ax
	push	bx
	mov	ax,bx
	.abs_w	ax		; let's see if close to center
	cmp	ax,20h
	ja	skipaxgb1
	pop	ax
	xor	ax,ax		; then force it to be centerd
	push	ax
skipaxgb1:
	pop	bx
	pop	ax
	ret
.endp
	

.proc	kinetic	auto
			; moves coords pointed to by [si]
	call	getjoy
	neg	ax
	neg	bx
	xchg	ax,bx
	push	bx
	mov	bx,ax
	mov	dx,oz+2
	mov	ax,oz
	rept	4
	shr	dx,1
	rcr	ax,1
	endm
	call	muls_dw
	mov	bx,200h*2
	call	divs_dw	
	dwtadj
	add	[si],ax
	adc	[si+2],dx
	pop	bx
	mov	dx,oz+2
	mov	ax,oz
	rept	4
	shr	dx,1
	rcr	ax,1
	endm
	call	muls_dw
	mov	bx,200h*2
	call	divs_dw	
	dwtadj
	add	[si+4],ax
	adc	[si+6],dx
	call	pgupanddown
	ret
.endp


.proc	setyah	auto
	mov	si,offset @dataseg:ox
	mov	di,offset @dataseg:youarehere
	mov	cx,9
	mov	ax,ds
	mov	es,ax
	cld
	rep	movsw
	ret
.endp

.proc	drawyah	auto
	mov	yahclr,0
	mov	ax,cs:oticks
	test	ax,512
	jz	noyah
	mov	yahclr,15
noyah:
	mov	bx,z0
	shr	bx,1
	shr	bx,1
	mov	ax,oz+2
	cmp	ax,bx
	jb	dyret
	mov	si,offset @dataseg:youarehere
	call	d3dobj
dyret:
	clc
	ret
.endp

.proc	mapnumbers	auto
IF mapmbflag
	mov	letx,10
	mov	lety,340
	mov	dx,ox+2
	mov	ax,ox
	call	drawdword
	mov	letx,130
	mov	lety,340
	mov	dx,oy+2
	mov	ax,oy
	call	drawdword
	mov	letx,250
	mov	lety,340
	mov	dx,oz+2
	mov	ax,oz
	call	drawdword
	mov	letx,370
	mov	lety,340
	mov	dx,0
	mov	ax,orvec
	mov	mbdefclr,12
	call	drawdword
	mov	mbdefclr,15
ENDIF
	ret
.endp

.proc	maploop	auto
	mov	al,0
	xchg	desireflag,al
	mov	olddesireflag,al
	mov	framecount,0
	call	changewallobjs
	mov	clrhq,0

	mov	si,offset @dataseg:ox
	mov	di,offset @dataseg:obj5d
	cmp	ejectflag,0
	jz	nolittleman
	mov	di,offset @dataseg:objman1
nolittleman:
	mov	cx,9
	mov	ax,ds
	mov	es,ax
	cld
	rep	movsw
	call	setyah
	mov	oz,0
	mov	oz+2,210
	mov	z0,35
	mov	orvec+2,16384
	mov	orvec+4,0
	mov	orvec,0
	mov	bx,offset @dataseg:orvec
	call	calcsin
	mov	si,offset @dataseg:orot
	call	calcmat
	mov	si,offset @dataseg:norot
	call	ncalcmat
maplp:
	mov	survclr,0eh
	mov	ax,cs:oticks
	test	ax,1024
	jz	svblinkoff
	mov	survclr,0
svblinkoff:
	mov	ax,cs:frmticks
	mov	cl,3
	shr	ax,cl
	bndck	maxofrm,minofrm		; don't allow divide by zero, or
					; too lengthy frames
	mov	ofrmticks,ax
	mov	cs:frmticks,0		; clear frame counter
	call	epage			; erase messy borders on page
	mov	ax,orvec+2
	mov	viewkludge,ax
	call	modhr
	mov	hrflg,-1		; turn on fills
	mov	si,offset @dataseg:hrobj
	call	d3dobj
	mov	hrflg,0			; turn off fills
	call	drawmap
IF mapmbflag EQ 1
	cmp	modeflag,0
	jz	noblinkon
	test	cs:oticks,256
	jz	noblinkon
	mov	si,offset @dataseg:mapobjbuf
	call	d3dobj			; draw the object
noblinkon:
ENDIF
	mov	si,offset @dataseg:obj5d
	cmp	ejectflag,0
	jz	nolittleman2
	mov	si,offset @dataseg:objman1
nolittleman2:
	call	d3dobj			; draw ourself, or our plane
	call	drawyah
	call	drawgs
IF mapmbflag EQ 1
	call	mapnumbers
ENDIF
	call	flipage
	call	mapkey
	jnc	nomberr
	ret
nomberr:
	cmp	cs:cecode,0
	jnz	mapexit
	mov	al,scncode
	xor	al,80h
	cmp	al,1
	jz	mapexit
	cmp	al,1ch
	jz	mapexit
	cmp	al,32h
	jz	mapexit
	cmp	al,39h
	jz	mapexit
	jmp	maplp

mapexit:
	mov	scncode,0
	mov	z0,0
	call	restoreox	; get back original coords
	mov	al,olddesireflag
	mov	desireflag,al
	clc
	ret
.endp

.proc	restoreox	auto
	mov	di,offset @dataseg:ox
	mov	si,offset @dataseg:obj5d
	cmp	ejectflag,0
	jz	nolittleman1
	mov	si,offset @dataseg:objman1
nolittleman1:
	mov	cx,9
	mov	ax,ds
	mov	es,ax
	cld
	rep	movsw
	call	recalcmats
	ret
.endp

.proc	bumpobjangles	auto		; bump angles in orvec
					; bx has pitch, cx has yaw
	mov	si,mbptr
	mov	ax,bx			; make angle indep of cpu
	sar	ax,1
	wtadj
	sal	ax,1
	add	[si+14],ax		; pitch
	mov	ax,cx
	sar	ax,1
	wtadj
	sal	ax,1
	add	[si+12],ax
	ret
.endp

.proc	bumpangles	auto		; bump angles in orvec
					; bx has pitch, cx has yaw
	mov	ax,bx			; make angle indep of cpu
	sar	ax,1
	wtadj
	sal	ax,1
	add	orvec+2,ax		; pitch
	mov	ax,cx
	sar	ax,1
	wtadj
	sal	ax,1
	add	orvec,ax
	ret
.endp
IF mapmbflag EQ 1

.proc	drawletter	auto
	mov	ax,letter
	cmp	ax,nlet
	jb	letoklb
	mov	cs:cecode,82
	ret
letoklb:
	mov	bx,nbytelet
	mul	bx
	mov	si,ax
	mov	cx,15
drawletloop:
	push	cx
	mov	al,[si+offset @dataseg:numx]
	mov	bl,[si+offset @dataseg:numx+1]
	xor	ah,ah
	xor	bh,bh
	add	ax,letx
	add	bx,letx
	mov	argx1,ax
	mov	argx2,bx
	sub	ax,bx
	mov	dx,ax
	mov	al,[si+offset @dataseg:numy]
	mov	bl,[si+offset @dataseg:numy+1]
	xor	ah,ah
	xor	bh,bh
	push	ax
	push	bx
	shr	ax,1
	shr	bx,1
	neg	ax
	neg	bx
	add	ax,lety
	add	bx,lety
	mov	argy1,ax
	mov	argy2,bx
	pop	bx
	pop	ax
	sub	ax,bx
	or	dx,ax
	jz	skipthispt
	mov	al,mbdefclr
	mov	n,al
	push	si
	call	egaline
	pop	si
skipthispt:
	add	si,2
	pop	cx
	loop	drawletloop
	add	letx,11
	ret
.endp

.proc	drawstring	auto
	mov	cx,32			; 32 letters in string maximum
drawsloop:
	mov	al,[si]
	or	al,al
	jz	enddrawstr
	cmp	al,2dh
	jnz	notaminus
	mov	ax,11		; letter # 10 is a minus sign
	jmp	drawslb1
notaminus:
	sub	al,30h
	js	drawstrerr
	cmp	al,9
	ja	drawstrerr
	xor	ah,ah
drawslb1:
	mov	letter,ax
	push	cx
	push	si
	call	drawletter
	pop	si
	inc	si
	pop	cx
	loop	drawsloop
	mov	cs:cecode,84	; more than 32 letters is an error!
enddrawstr:
	ret
drawstrerr:
	mov	cs:cecode,83
	ret
.endp


.proc	drawword	auto
	push	si
	mov	bx,letx
	push	bx
	mov	si,offset @dataseg:kbuf
	call	word_to_dec
	call	drawstring

	call	flipage
	pop	bx
	push	bx
	mov	letx,bx
	mov	si,offset @dataseg:kbuf
	call	drawstring
	call	flipage

	pop	bx
	mov	letx,bx
	pop	si
	ret
.endp

.proc	drawdword	auto
	push	si
	mov	bx,letx
	push	bx
	mov	si,offset @dataseg:kbuf
	call	dwords_to_dec
	call	drawstring

	call	flipage
	pop	bx
	push	bx
	mov	letx,bx
	mov	si,offset @dataseg:kbuf
	call	drawstring
	call	flipage

	pop	bx
	mov	letx,bx
	pop	si
	ret
.endp

ENDIF

.ends

	end

