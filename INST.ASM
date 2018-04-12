	title 'inst'

_MODEL	equ	<SMALL>
include model.inc
include	imath.INC
include f3dequ.inc
include 3dvid.inc
include		pixaddr1.inc
include ka.inc

IF (vgmode EQ 10h) OR (vgmode EQ 81h)
gsz	equ	12
gsz23	equ	8
gsz2323	equ	5
thxmin	equ	481
thxmax	equ	629
thy	equ	246
ENDIF
IF vgmode EQ 0dh
gsz	equ	8
thxmin	equ	240
thxmax	equ	315
thy	equ	141
ENDIF

IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
doline	macro
	call	egaline
	endm
ENDIF
IF vgmode EQ 81h
doline	macro
	call	hgcline
	endm
ENDIF

.extrn	scos:auto,ssin:auto,atn2:auto
.extrn	oz:word
.extrn	divs_dw:auto,div_qw:auto
.extrn	argx1:word,argy1:word,argx2:word,argy2:word,n:byte
.extrn	xc:word,yc:word,xw:word,drawdisc:auto
.extrn	drawpt:auto
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	.extrn	egaline:auto
	ENDIF
	IF vgmode EQ 81h
	.extrn	hgcline:auto
	ENDIF
.extrn	pgflg:byte
.extrn	topv:word
.extrn	rtopv:word
.extrn	rpmx:word
.extrn	rpm:word
.extrn	orvec:word
.extrn	etemp:word
.extrn	opres:word
.extrn	win0:word
.extrn	frmnum:word
.extrn	vboff:word
.extrn		instflag:byte,rawhlinebit:auto,rawhline:auto,oticks:word
.extrn	ptrgwinf:word	
.extrn	hmin:word,thrtmult:word
.extrn	obj5dbits:word

.public	oprclr1

ballymin	equ	195

;
.dataseg
IF (vgmode EQ 10h) OR (vgmode EQ 81h)
IF protection
ballx	dw	21
bally	dw	ballymin/2
vballx	dw	5
vbally	dw	-12
ballgrv	dw	2
ENDIF

altxc	dw	43
altyc	dw	267
altxsz1	dw	23*2
altysz1	dw	16*2
altold1	dw	?,?
alt1ld1	dw	?,?
altclr1	db	8
altxc2	dw	43
altyc2	dw	267
altxsz2	dw	14*2
altysz2	dw	10*2
altold2	dw	?,?
alt1ld2	dw	?,?
altclr2	db	9
altxc3	dw	43
altyc3	dw	267
altxsz3	dw	12*2
altysz3	dw	8*2
altold3	dw	?,?
alt1ld3	dw	?,?
altclr3	db	7
aspxc	dw	116
aspyc	dw	267
aspxsz1	dw	23*2
aspysz1	dw	16*2
aspold1	dw	?,?
asp1ld1	dw	?,?
aspclr1	db	8
clmxc	dw	43
clmyc	dw	267+51
clmxsz1	dw	23*2
clmysz1	dw	16*2
clmold1	dw	?,?
clm1ld1	dw	?,?
clmclr1	db	8
rlixc	dw	116
rliyc	dw	267+51
rlixsz1	dw	23*2
rliysz1	dw	16*2
rliold1	dw	?,?
rli1ld1	dw	?,?
rliclr1	db	8
rlixc2	dw	116
rliyc2	dw	267+51
rlixsz2	dw	10
rliysz2	dw	7
rliold2	dw	?,?
rli1ld2	dw	?,?
rliclr2	db	8
tmpxc	dw	32
tmpyc	dw	232
tmpxsz1	dw	20*2
tmpysz1	dw	14*2
tmpold1	dw	?,?
tmp1ld1	dw	?,?
tmpclr1	db	8
oprxc	dw	79
opryc	dw	224
oprxsz1	dw	20
oprysz1	dw	14
oprold1	dw	79,224
opr1ld1	dw	79,224
oprclr1	db	0dh
cmpxc	dw	127
cmpyc	dw	224
cmpxsz1	dw	20
cmpysz1	dw	14
cmpold1	dw	?,?
cmp1ld1	dw	?,?
cmpclr1	db	8
pitxc	dw	174
pityc	dw	224
pitxsz1	dw	30
pitysz1	dw	21
pitold1	dw	?,?
pit1ld1	dw	?,?
pitclr1	db	8
pitxc2	dw	174
pityc2	dw	224
pitxsz2	dw	10
pitysz2	dw	7
pitold2	dw	?,?
pit1ld2	dw	?,?
pitclr2	db	8
mdsxc	dw	559
mdsyc	dw	298
mdsxsz1	dw	10
mdsysz1	dw	7
mdsold1	dw	?,?
mds1ld1	dw	?,?
mdsclr1	db	12
ENDIF
IF vgmode EQ 0dh
altxc	dw	43/2-2
altyc	dw	267*20/35
altxsz1	dw	23
altysz1	dw	16*2*20/35
altold1	dw	?,?
alt1ld1	dw	?,?
altclr1	db	8
altxc2	dw	43/2-2
altyc2	dw	267*20/35
altxsz2	dw	14
altysz2	dw	10*2*20/35
altold2	dw	?,?
alt1ld2	dw	?,?
altclr2	db	9
altxc3	dw	43/2-2
altyc3	dw	267*20/35
altxsz3	dw	12
altysz3	dw	8*2*20/35
altold3	dw	?,?
alt1ld3	dw	?,?
altclr3	db	7
aspxc	dw	116/2-2
aspyc	dw	267*20/35
aspxsz1	dw	23
aspysz1	dw	16*2*20/35
aspold1	dw	?,?
asp1ld1	dw	?,?
aspclr1	db	8
clmxc	dw	43/2-2
clmyc	dw	(267+51)*20/35
clmxsz1	dw	23
clmysz1	dw	16*2*20/35
clmold1	dw	?,?
clm1ld1	dw	?,?
clmclr1	db	8
rlixc	dw	116/2-2
rliyc	dw	(267+51)*20/35
rlixsz1	dw	23
rliysz1	dw	16*2*20/35
rliold1	dw	?,?
rli1ld1	dw	?,?
rliclr1	db	8
rlixc2	dw	116/2-2
rliyc2	dw	(267+51)*20/35
rlixsz2	dw	5
rliysz2	dw	7*20/35
rliold2	dw	?,?
rli1ld2	dw	?,?
rliclr2	db	8
tmpxc	dw	32/2-2
tmpyc	dw	(232)*20/35
tmpxsz1	dw	20
tmpysz1	dw	14*2*20/35
tmpold1	dw	?,?
tmp1ld1	dw	?,?
tmpclr1	db	8
oprxc	dw	79/2-2
opryc	dw	(224)*20/35
oprxsz1	dw	10
oprysz1	dw	14*20/35
oprold1	dw	?,?
opr1ld1	dw	?,?
oprclr1	db	8
cmpxc	dw	62
cmpyc	dw	128
cmpxsz1	dw	10
cmpysz1	dw	8
cmpold1	dw	?,?
cmp1ld1	dw	?,?
cmpclr1	db	8
pitxc	dw	85
pityc	dw	128
pitxsz1	dw	15
pitysz1	dw	12
pitold1	dw	?,?
pit1ld1	dw	?,?
pitclr1	db	8
pitxc2	dw	87
pityc2	dw	128
pitxsz2	dw	5
pitysz2	dw	4
pitold2	dw	?,?
pit1ld2	dw	?,?
pitclr2	db	8
mdsxc	dw	279
mdsyc	dw	170
mdsxsz1	dw	5
mdsysz1	dw	4
mdsold1	dw	?,?
mds1ld1	dw	?,?
mdsclr1	db	12
ENDIF
pargx2	dw	?
pargy2	dw	?
throld1	dw	?,?
throld2	dw	?,?
thrwin	dw	thxmin,thy-3,thxmax,thy+3,100,100
temp	dw	?,?,?,?
;oticks	dw	?,?
;	dw	?,?				; 4 words for page0 and 1
pgadd	dw	0
drawtbl	dw	l03,l03,l08,l08,l05,l05,l01,l01,l08,l08,l05,l05,l01,l01
erastbl	dw	el03,el03,el08,el08,el05,el05
	dw	el01,el01,el08,el08,el05,el05,el01,el01
autodata	dw	205,209,248,218	
holddata	dw	205,219,248,228	
flapdata	dw	205,229,248,241	
stalldata	dw	443,209,484,219
ejectdata	dw	443,220,484,230
cmpltdata	dw	443,231,484,241
bomb1data	dw	492,209,517,218
bomb2data	dw	492,219,517,228
bomb3data	dw	492,229,517,238
lowdata		dw	279,216,324,229
tensdata	dw	52,251,61,262
		dw	59,256,68,267
helpdata	dw	267,231,336,241
damndata	dw	524,208,629,238
IF slalom
sl1data		dw	495,214,501,222
sl2data		dw	502,214,508,222
sl3data		dw	509,214,515,222
sl4data		dw	495,225,501,233
sl5data		dw	502,225,508,233
sl6data		dw	509,225,515,233
ENDIF
sl7data		dw	492,209,517,233

ndbars	equ	13
clrseq	db	0ah,0ah,09h,09h,09h,09h,0eh,0eh,0eh,0eh,0ch,0ch


edata	dw	536,213,0,0,0
wdata	dw	536,219,0,0,0
cdata	dw	536,226,0,0,0
rdata	dw	536,233,0,0,0

.ends

;.public	aspdraw,asperase,clmdraw,clmerase,drawndles,drawgs
.public	drawndles,drawgs
.public	erasndles
.public	drawthrt
.public	radardot
.public drawbutton,drawdamage,flashdamage,damindicinit
.public	drawairtick,clearticks,drawelvtick,drawrdrtick,mdsclr1
IF protection
.public	drawball,ballx,bally,vbally
ENDIF

.codeseg
;assume		cs:@codeseg, 
	assume ds:@dataseg, es:@dataseg
.proc	altcrd1	auto			; endpoint of needle on altimeter
	mov	ax,oz			; results left in argx2,argy2
	mov	dx,oz+2			; get the altitude
	sub	ax,hmin
	sbb	dx,0			; subtract minimun height from alt
					; reading
	or	dx,dx			; make sure altitude is positive
	jns	altpos
	xor	dx,dx
	xor	ax,ax
altpos:	
	mov	temp+6,0
	mov	temp+4,dx		; store in a quad word
	mov	temp+2,ax
	mov	temp,0



	mov	di,offset @dataseg:temp	; pointer to quad word
	mov	bx,3050			; conversion from cm to 100ft
	call	div_qw
	mov	ax,temp			; this is the angle
	mov	si,offset @dataseg:altxc	; make si point to data area
	ret
.endp

.proc	altcrd2	auto
	mov	di,offset @dataseg:temp	; pointer to quad word
	mov	bx,10			; conversion from cm to 100ft
	call	div_qw
	mov	ax,temp			; this is the angle
	push	ax			; save for x coord part
	call	scos			; get cosine
	neg	ax			; make negative cause scrn org at top
	mov	dx,altysz2		; scale needle size by cosine
	imul	dx			; 
	shl	ax,1			; round result
	adc	dx,0			; add to good part
	mov	ax,dx			; take upper part
	add	ax,altyc		; now add in the coord of meter ctr
	mov	argy2,ax		; prepare for line
	mov	bx,offset @dataseg:altold2
	add	bx,pgadd		; make it point to old storage
	mov	[bx+2],ax		; also save for erase time
	pop	ax			; retrieve angle
	call	ssin
	mov	dx,altxsz2		; do the same as above
	imul	dx
	shl	ax,1			; round result
	adc	dx,0			; add to good part
	mov	ax,dx			; take upper part
	add	ax,altxc
	mov	argx2,ax
	mov	[bx],ax
	ret
.endp

.proc	altcrd3	auto
	mov	di,offset @dataseg:temp	; pointer to quad word
	mov	bx,10			; conversion from cm to 100ft
	call	div_qw
	mov	ax,temp			; this is the angle
	push	ax			; save for x coord part
	call	scos			; get cosine
	neg	ax			; make negative cause scrn org at top
	mov	dx,altysz3		; scale needle size by cosine
	imul	dx			; 
	shl	ax,1			; round result
	adc	dx,0			; add to good part
	mov	ax,dx			; take upper part
	add	ax,altyc		; now add in the coord of meter ctr
	mov	argy2,ax		; prepare for line
	mov	bx,offset @dataseg:altold3
	add	bx,pgadd		; make it point to old storage
	mov	[bx+2],ax		; also save for erase time
	pop	ax			; retrieve angle
	call	ssin
	mov	dx,altxsz3		; do the same as above
	imul	dx
	shl	ax,1			; round result
	adc	dx,0			; add to good part
	mov	ax,dx			; take upper part
	add	ax,altxc
	mov	argx2,ax
	mov	[bx],ax
	ret
.endp

.proc	clmcrd1	auto			; endpoint of needle on clmimeter
	xor	ax,ax
	mov	dx,rtopv+4		; get the clmitude
;	add	dx,402		; this should center it
	add	dx,804		; this should center it
	or	dx,dx			; make sure clmitude is positive
	jns	clmpos
	xor	dx,dx
clmpos:	
;	cmp	dx,804
	cmp	dx,1608
	js	cmpsok
;	mov	dx,803
	mov	dx,1607
cmpsok:
;	mov	bx,1207		; conversion from cm to 100ft
	mov	bx,2414
	div	bx			; unsigned divide
	add	ax,27306		; shift zero angle to lower left
	mov	si,offset @dataseg:clmxc	; point ptr to proper thing
	ret
.endp

.proc	aspcrd1	auto			; endpoint of needle on aspimeter
;	xor	ax,ax
;	mov	dx,topv			; get the aspitude
	mov	ax,topv			; get the aspitude
	xor	dx,dx
	test	obj5dbits,2000h		; is it the super plane?
	jz	notsuperspd
	REPT	2
	shl	ax,1
	rcl	dx,1
	ENDM
notsuperspd:
	mov	bx,39297/2
	div	bx
	xor	ax,ax			; remainder 0-(39297/2) in dx
	cmp	dx,39297/2
	js	aspok			; make sure airspeed not too great
	sub	dx,39297/2
aspok:
	or	dx,dx			; make sure aspitude is positive
	jns	asppos
	xor	dx,dx
asppos:	
	mov	bx,39297/2		; conversion from cm to 100ft
	div	bx			; unsigned divide
	mov	si,offset @dataseg:aspxc	; set ptr
	ret
.endp

.proc	rlicrd1	auto			; endpoint of needle on aspimeter
	mov	ax,orvec+4		; get the aspitude
	mov	si,offset @dataseg:rlixc	; set ptr
	push	ax			; save for x coord part
	push	si
	call	ssin			; get cosine
	pop	si
	mov	dx,[si+6]		; scale needle size by cosine
	imul	dx			; 
	shl	ax,1			; round result
	adc	dx,0			; add to good part
	mov	ax,dx			; take upper part
	add	ax,[si+2]		; now add in the coord of meter ctr
	mov	argy2,ax		; prepare for line
	mov	ax,[si+2]
	sub	ax,dx			; get lower part
	mov	argy1,ax
	pop	ax			; retrieve angle
	push	si
	call	scos
	pop	si
	mov	dx,[si+4]		; do the same as above
	imul	dx
	shl	ax,1			; round result
	adc	dx,0			; add to good part
	mov	ax,dx			; take upper part
	add	ax,[si]
	mov	argx2,ax
	mov	ax,[si]
	sub	ax,dx
	mov	argx1,ax
	mov	bx,si
	add	bx,8			; make bx point to altold1
	add	bx,pgadd		; make it point to old storage
	mov	ax,argy2
	mov	[bx+2],ax		; also save for erase time
	mov	ax,argx2
	mov	[bx],ax
	mov	al,[si+16]		; now put in draw color
	mov	n,al
	doline
	ret
.endp

.proc	pitcrd1	auto			; endpoint of needle on aspimeter
	mov	ax,orvec+2		; get the aspitude
	neg	ax			; reverse direction
	mov	bx,orvec+4
	add	bx,16384
	jns	upside
	neg	ax			; subtract from 180
	add	ax,32768
upside:	
	mov	si,offset @dataseg:pitxc	; set ptr
	push	ax			; save for x coord part
	push	si
	call	ssin			; get cosine
	pop	si
	mov	dx,[si+6]		; scale needle size by cosine
	imul	dx			; 
	shl	ax,1			; round result
	adc	dx,0			; add to good part
	mov	ax,dx			; take upper part
	add	ax,[si+2]		; now add in the coord of meter ctr
	mov	argy2,ax		; prepare for line
	mov	pargy2,ax		; prepare for line
	mov	ax,[si+2]
	sub	ax,dx			; get lower part
	mov	argy1,ax
	pop	ax			; retrieve angle
	push	si
	call	scos
	pop	si
	mov	dx,[si+4]		; do the same as above
	imul	dx
	shl	ax,1			; round result
	adc	dx,0			; add to good part
	mov	ax,dx			; take upper part
	add	ax,[si]
	mov	argx2,ax
	mov	pargx2,ax
	mov	ax,[si]
	sub	ax,dx
	mov	argx1,ax
	mov	bx,si
	add	bx,8			; make bx point to altold1
	add	bx,pgadd		; make it point to old storage
	mov	ax,argy2
	mov	[bx+2],ax		; also save for erase time
	mov	ax,argx2
	mov	[bx],ax
	mov	al,[si+16]		; now put in draw color
	mov	n,al
	doline
	ret
.endp

.proc	rlicrd2 auto		; calc meter angle for temp gauge
	mov	si,offset @dataseg:rlixc2
	mov	ax,orvec+4	; get roll
	ret
.endp

.proc	pitcrd2 auto		; calc meter angle for temp gauge
	mov	si,offset @dataseg:pitxc2
	mov	ax,pargx2	; get end point
	mov	[si],ax		; set center wrong
	mov	ax,pargy2	;
	mov	[si+2],ax
	mov	ax,orvec+2		; get the aspitude
	neg	ax			; reverse direction
	mov	bx,orvec+4
	add	bx,16384
	jns	upside1
	neg	ax			; subtract from 180
	add	ax,32768
upside1:	
	ret
.endp	

.proc	eraspit2 auto		; erases a line, ptr in [si]
	mov	si,offset @dataseg:pitxc	; set ptr
	mov	bx,si
	add	bx,8			; make bx point to altold1
	add	bx,pgadd		; make it point to old storage
	mov	ax,[bx]
	mov	argx1,ax		; put old needle endpoint in line coord
	mov	ax,[bx+2]
	mov	argy1,ax
	mov	si,offset @dataseg:pitxc2	; set ptr
	mov	bx,si
	add	bx,8			; make bx point to altold1
	add	bx,pgadd		; make it point to old storage
	mov	ax,[bx]
	mov	argx2,ax		; put old needle endpoint in line coord
	mov	ax,[bx+2]
	mov	argy2,ax
	mov	al,0		; now put in draw color
	mov	n,al
	doline
	ret
.endp

.proc	tmpcrd1 auto		; calc meter angle for temp gauge
	mov	ax,etemp
	mov	bx,3	
	xor	dx,dx
	div	bx
	sub	ax,5400
	mov	si,offset @dataseg:tmpxc
	ret
.endp

.proc	flashdamage	auto	; flashes damage on indicators
	mov	si,ptrgwinf	; get address of window
	cmp	word ptr [si+6],210	; if full window, then don't do this
	jb	screenok
	ret
screenok:
	mov	si,offset @dataseg:edata
	mov	ax,10
	mul	bx		; get address of table
	add	si,ax		; as indexed by bx
	cmp	word ptr [si+8],0	; solid?
	jz	noflashtoday
	mov	dx,cs:oticks	; get timer count
	sub	dx,[si+6]	; subtract our bias
	mov	bx,[si+8]	; get which bit to follow for flash
	mov	ah,0eh		; assume it will be yellow
	test	dx,bx
	jnz	yellowitis	; yup, leave as yellow
	mov	ah,0ch		; no, leave as red
yellowitis:
	mov	n,ah
	jmp	dosolid		; just jump into the other procedure
noflashtoday:
	ret
.endp



.proc	drawdamage	auto	; this routine draws damage indication on
				; the instrument panel
	mov	si,ptrgwinf	; get address of window
	cmp	word ptr [si+6],210	; if full window, then don't do this
	jb	screenok1
	ret
screenok1:
	mov	si,offset @dataseg:edata
	mov	ax,10
	mul	bx		; get address of table
	add	si,ax		; as indexed by bx
	cmp	word ptr [si+8],0	; are we still in the solid
					; section of bar?
	jz	dosolid		; yes
	cmp	word ptr [si+8],256	; see if we are already at max display 
	jb	erailed		; damage already railed
	shr	word ptr [si+8],1	; if not, just increase the flash rate
erailed:
	ret
dosolid:
	mov	ax,[si+4]	; get damage line number
;	cmp	ax,4
;	jae	strtdflash	; if we are on the last damageline, flash it
	mov	bx,6		; calclate x begining
	mul	bx
	add	ax,[si]		; add in the original x offset of damage
	mov	argx1,ax
	add	ax,5		; now get coords for ends of line
	mov	argx2,ax	; it is 14 pixels long
	mov	bx,[si+2]	; get ymin
	mov	argy1,bx
	mov	argy2,bx
	mov	ax,80		; get start address of line in di
	mul	bx
	mov	di,ax
	mov	bx,[si+4]	; get index
	add	bx,offset @dataseg:clrseq	; point to color to use
	mov	ah,[bx]
	cmp	word ptr [si+8],0	; find out if called from flash
	jz	noisflash
	mov	ah,n			; if so, get color from variable
noisflash:

;	mov	n,ah
;	jmp	ship

	mov	dx,3ceh		; dx := graphics controller port addr
	xor	al,al
	out	dx,ax		; put color selection in set/reset reg
	mov	ax,0f01h
	out	dx,ax		; put 0fh in bit plane enable
	mov	ah,0		; no rotate, no xor
	mov	al,3
	out	dx,ax		; 0 for the RWM bits of the ALU
	mov	ax,0305h	; write mode 3 select, read mode 0
	out	dx,ax
ship:
	mov	ax,vgseg	; seg up video segment!
	mov	es,ax
	push	si		; save si incase something destroys it
	push	di		; do twice
	call	rawhline
;	call	egaline
	pop	di
	xor	vboff,7e00h	; switch write pages
	call	rawhline
;	call	egaline
	xor	vboff,7e00h	; switch write pages
	pop	si		; save si incase something destroys it
	mov	dx,3ceh		; dx := graphics controller port addr
	mov	ax,5
	out	dx,ax		; write mode 0
	xor	ax,ax
	out	dx,ax
	mov	ax,[si+4]	; check to see if that was the last one
	inc	ax
	mov	[si+4],ax	
	cmp	ax,ndbars-1	; see what now
	jg	strtdflash	; start the flashing
	mov	[si+4],ax	
	ret
strtdflash:
	mov	word ptr [si+4],ndbars-1	; keep it pointed here
	cmp	word ptr [si+8],0	; are we flashing?
	jnz	dontrestart	; yes, so we must have been called by 
				; flashdamage, so exit
	mov	ax,cs:oticks	; keep our own sync
	mov	[si+6],ax	; so they all don't flash in unison
	mov	word ptr [si+8],512	; set flashing rate to low
dontrestart:
	ret			; wer	
.endp

.proc	damindicinit	auto	; initializes a damage indicator
	mov	si,offset @dataseg:edata
	mov	ax,10
	mul	bx		; get address of table
	add	si,ax		; as indexed by bx
	mov	cx,[si+4]	; return present damage in cx
	xor	ax,ax
	mov	[si+4],ax
	mov	[si+6],ax
	mov	[si+8],ax
	ret
.endp

.proc	clearticks auto		; clears tickmarks from current page
	mov	argx1,360
	mov	argx2,430
	mov	ax,vgseg	; seg up video segment!
	mov	es,ax
	mov	di,212*80
	mov	cx,237-212	; number of lines
	mov	dx,3ceh		; dx := graphics controller port addr
	mov	ah,0		; write zero to this bit
	xor	al,al
	out	dx,ax		; put color selection in set/reset reg
	mov	ax,0f01h
	out	dx,ax		; put 0fh in bit plane enable
	mov	ah,0		; no rotate, no xor
	mov	al,3
	out	dx,ax		; 0 for the RWM bits of the ALU
	mov	ax,0305h	; write mode 3 select, read mode 0
	out	dx,ax
				; write only to bit 3
	mov	dx,3c4h			; address of seq
	mov	al,2			; index of map mask register
	out	dx,al			; select map mask register
	inc	dx			; now access map mask register
	mov	al,8			; only allow bit one access
	out	dx,al

drudgeloop3:
	push	cx		; save cx
	push	di		; and di
	call	rawhline	; make the line
	pop	di		; advance to the next line
	add	di,bpl
	pop	cx
	loop	drudgeloop3

	mov	dx,3c4h			; address of seq
	mov	al,2			; index of map mask register
	out	dx,al			; select map mask register
	inc	dx			; now access map mask register
	mov	al,0fh			; allow free access to all bit planes
	out	dx,al

	mov	dx,3ceh		; dx := graphics controller port addr
	mov	ax,5
	out	dx,ax		; write mode 0
	xor	ax,ax
	out	dx,ax
	ret
.endp

.proc	drawelvtick	auto
	neg	ax			; up is negative, or is it neg?
	add	ax,200h
	mov	bx,237-212		; find width of airelon thing
	imul	bx			; take into 0-length
	mov	bx,400h
	idiv	bx
	add	ax,212
	mov	argy1,ax
	mov	argy2,ax		; vertical line
	mov	argx1,368-3
	mov	argx2,368+3
	mov	n,8			; white mark
	jmp	drawtickline
.endp

.proc	drawrdrtick	auto
	neg	ax			; the sign is never right the 1st
					; time, is it?
	add	ax,200h
	mov	bx,429-385		; find width of airelon thing
	imul	bx			; take into 0-length
	mov	bx,400h
	idiv	bx
	add	ax,385
	mov	argx1,ax
	mov	argx2,ax		; vertical line
	mov	argy1,216-2
	mov	argy2,216+2
	mov	n,8			; white mark
	jmp	drawtickline
.endp

.proc	drawairtick	auto
	add	ax,200h
	mov	bx,429-385		; find width of airelon thing
	imul	bx			; take into 0-length
	mov	bx,400h
	idiv	bx
	add	ax,385
	mov	argx1,ax
	mov	argx2,ax		; vertical line
	mov	argy1,232-2
	mov	argy2,232+2
	mov	n,8			; white mark
drawtickline:	
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	mov	dx,3c4h			; address of seq
	mov	al,2			; index of map mask register
	out	dx,al			; select map mask register
	inc	dx			; now access map mask register
	mov	al,8			; only allow bit one access
	out	dx,al
	ENDIF
	doline
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	mov	dx,3c4h			; address of seq
	mov	al,2			; index of map mask register
	out	dx,al			; select map mask register
	inc	dx			; now access map mask register
	mov	al,0fh			; allow free access to all bit planes
	out	dx,al
	ENDIF
	ret
.endp

.proc	drawbutton	auto	; this routine draws a button on the inst
				; panel.  It replaces all colors in the 
				; button of color (al) with color (ah) 
				; bx has a code for which button to change
				; bx=0 means autodata, bx=1 means holddata
				; the desired color should be in ah,
				; keep in mind that it must be 7h, or 0fh
				; for this to work
	mov	si,ptrgwinf	; get address of window
	cmp	word ptr [si+6],210	; if full window, then don't do this
	jb	screenok3
	ret
screenok3:
	mov	cl,3		; get the table address from code in bx
	shl	bx,cl		; eight bytes per table entry
	mov	si,offset @dataseg:autodata
	add	si,bx		; reference into table
	mov	dx,3ceh		; dx := graphics controller port addr
	push	ax		; save ah for the color compare reg
;	mov	ah,8		; the data should be 8, to reverse msb
	xor	al,al
	out	dx,ax		; put color selection in set/reset reg
	mov	ax,0f01h
	out	dx,ax		; put 0fh in bit plane enable
;	mov	ah,18h		; xor in the rwm bits
	mov	ah,0		; no rotate, no xor
	mov	al,3
	out	dx,ax		; 0 for the RWM bits of the ALU
	mov	ax,0b05h	; write mode 3 select, read mode 1
	out	dx,ax
	mov	ax,0f07h	; select 0f for the color don't care
	out	dx,ax
	pop	ax
	mov	ah,al		; get search color from ax, to set background
	mov	al,02h
				; IE look for the color we aren't writing!
;	mov	ax,0702h	; select 07 for the color compare register
	out	dx,ax

	mov	ax,vgseg	; seg up video segment!
	mov	es,ax
	mov	ax,[si]		; get original x and y from table
	mov	argx1,ax	; rawhline assumes argx1<argx2
	mov	ax,[si+4]		; get original x and y from table
	mov	argx2,ax	; rawhline assumes argx1<argx2
	mov	bx,[si+2]	; get ymin
	mov	ax,80		; get start address of line in di
	mul	bx
	mov	di,ax
	mov	cx,[si+6]	; now we need the number of lines
	sub	cx,bx		; ie ymax-ymin
	add	cx,1		; add one to be inclusive
				; set up video controller

	.push	cx,di		; save data, cause we have to do it for
				; each video frame

drudgeloop:
	push	cx		; save cx
	push	di		; and di
	call	rawhlinebit	; make the line
	pop	di		; advance to the next line
	add	di,bpl
	pop	cx
	loop	drudgeloop

	.pop	cx,di

	xor	vboff,7e00h	; switch write pages
	
drudgeloop1:
	push	cx		; save cx
	push	di		; and di
	call	rawhlinebit	; make the line
	pop	di		; advance to the next line
	add	di,bpl
	pop	cx
	loop	drudgeloop1

	xor	vboff,7e00h	; switch write pages back to original

	mov	dx,3ceh		; dx := graphics controller port addr
	mov	ax,5
	out	dx,ax		; write mode 0
	xor	ax,ax
	out	dx,ax
	ret
.endp


.proc	drawthrt auto	; draw a sphere at the proper throttle point
	mov	ax,rpm
	mov	dx,thxmax-thxmin
	mul	dx
	mov	bx,rpmx
	div	bx	; scale throttle into thxmax-thxmin
	add	ax,thxmin
	sub	ax,3	; don't let it go off totally
	mov	xc,ax	; x center is ready
	mov	bx,offset @dataseg:throld1
	add	bx,pgadd		; make it point to old storage
	mov	[bx],ax

	mov	yc,thy	; y center is constant
	mov	xw,5	; diameter of 5
	mov	si,offset @dataseg:thrwin
	mov	n,8
	call	drawdisc
	ret
.endp

IF protection
.proc	drawball	auto
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	mov	dx,3c4h			; address of seq
	mov	al,2			; index of map mask register
	out	dx,al			; select map mask register
	inc	dx			; now access map mask register
	mov	al,8			; only allow bit one access
	out	dx,al
	ENDIF

	mov	ax,bally
	mov	yc,ax	; y center is constant
	mov	ax,ballx
	mov	xc,ax
	mov	xw,9	; diameter of 5
	mov	si,ptrgwinf
	mov	n,0
	xor	vboff,7e00h	; switch write pages
	call	drawdisc
	xor	vboff,7e00h	; switch write pages
	mov	si,ptrgwinf
	call	drawdisc

	mov	ax,bally
	cmp	ax,ballymin
	jl	nobbounce
	mov	bally,ballymin	; clip ball height
	mov	ax,vbally
	.abs_w	ax
	sal	ax,1
	sal	ax,1
	cwd
	mov	bx,5
	div	bx
	neg	ax
	mov	vbally,ax
nobbounce:
	mov	ax,bally
	cmp	ax,10
	jns	ynobb1
	mov	bally,10	; clip ball height
	mov	ax,vbally
	.abs_w	ax
	sal	ax,1
	sal	ax,1
	cwd
	mov	bx,5
	div	bx
	mov	vbally,ax
ynobb1:
	mov	ax,ballx
	cmp	ax,630
	jl	xnobbounce
	mov	ballx,630	; clip ball height
	mov	ax,vballx
	.abs_w	ax
	neg	ax
	mov	vballx,ax
xnobbounce:
	mov	ax,ballx
	cmp	ax,10
	jns	xnobb1
	mov	ballx,10	; clip ball height
	mov	ax,vballx
	.abs_w	ax
	mov	vballx,ax
xnobb1:
	mov	ax,vballx
	add	ballx,ax
	mov	ax,vbally
	add	bally,ax
	mov	ax,ballgrv
	add	vbally,ax

	mov	ax,bally
	mov	yc,ax	; y center is constant
	mov	ax,ballx
	mov	xc,ax
	cmp	ax,10
	jnz	justchecking
	jmp	justnodisc
justchecking:
	mov	xw,9	; diameter of 5
	mov	si,ptrgwinf
	mov	n,8
	xor	vboff,7e00h	; switch write pages
	call	drawdisc
	xor	vboff,7e00h	; switch write pages
	mov	si,ptrgwinf
	call	drawdisc
justnodisc:
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	mov	dx,3c4h			; address of seq
	mov	al,2			; index of map mask register
	out	dx,al			; select map mask register
	inc	dx			; now access map mask register
	mov	al,0fh			; allow free access to all bit planes
	out	dx,al
	ENDIF
	ret
.endp

ENDIF

.proc	drawmds	auto		; draw needle stick sphere
	mov	ax,topv
	mov	dx,topv+4
	call	atn2
	neg	ax		; reverse angle for meter
	add	ax,5400
	jns	dm1
	xor	ax,ax
dm1:	cmp	ax,10800
	js	dm2
	mov	ax,10799
dm2:	mov	bx,110
	mul	bx
	mov	bx,10800
	div	bx
	sub	ax,55
	add	ax,mdsyc	; add center coords
	mov	yc,ax
	mov	bx,offset @dataseg:mdsold1
	add	bx,pgadd		; make it point to old storage
				; do the same for x
	mov	[bx+2],ax
	mov	ax,topv
	mov	dx,topv+2
	call	atn2
	add	ax,5400
	jns	dm3
	xor	ax,ax
dm3:	cmp	ax,10800
	js	dm4
	mov	ax,10799
dm4:	mov	bx,160
	mul	bx
	mov	bx,10800
	div	bx
	sub	ax,80
	add	ax,mdsxc	; add center coords
	mov	xc,ax
	mov	bx,offset @dataseg:mdsold1
	add	bx,pgadd		; make it point to old storage
	mov	[bx],ax
	mov	xw,6
	mov	al,mdsclr1
	mov	n,al
	mov	si,offset @dataseg:win0
	call	drawdisc
	mov	si,offset @dataseg:win0
	mov	ax,[si+16]
	sub	ax,2
	mov	argx1,ax
	mov	ax,[si+18]
	mov	argy1,ax
	mov	n,7
	call	drawpt
	add	argx1,4
	call	drawpt
	sub	argx1,2
	dec	argy1
	call	drawpt
	add	argy1,3
	call	drawpt
	ret
	sub	ax,9
	mov	argx1,ax
	add	ax,18
	mov	argx2,ax
	mov	ax,[si+18]
	mov	argy1,ax
	mov	argy2,ax
	doline
	sub	argy1,6
	add	argy2,6
	mov	si,offset @dataseg:win0
	mov	ax,[si+16]
	mov	argx1,ax
	mov	argx2,ax
	doline
	ret
.endp

.proc	radardot	auto	; draws a radar dot on the screen
				; ax= distance 0-255
				; bx=angle 0-65535
	mov	si,ptrgwinf	; get address of window
	cmp	word ptr [si+6],210	; if full window, then don't do this
	jb	screenok2
	ret
screenok2:
	push	bx		; save angle
	push	ax		; save this distance
	mov	dx,win0+8	; get xsize
	mul	dx		; scale distance into 0-xsz
	mov	al,ah		; divide by 256
	mov	ah,dl
	push	ax		; save for later
	mov	ax,bx		; now do angular stuff
	call	ssin		; get sin of angle
	neg	ax
	pop	bx		; calculate x coord
	imul	bx		; ax will have x-coord
	add	dx,win0+16	; add the center coord
	mov	argx1,dx	; here it is!
	mov	xc,dx	; here it is!
	pop	ax
	pop	bx
	mov	dx,win0+10	; get ysize
	mul	dx		; scale distance into 0-ysz
	mov	al,ah		; divide by 256
	mov	ah,dl
	push	ax		; save for later
	mov	ax,bx		; now do angular stuff
	call	scos		; get sin of angle
	neg	ax
	pop	bx		; calculate y coord
	imul	bx		; ax will have y-coord
	add	dx,win0+18	; add the center coord
	mov	argy1,dx	; here it is!
	mov	yc,dx	; here it is!
	mov	si,offset @dataseg:win0		; make bx point to window
	mov	xw,3
	call	drawdisc	; draw the darn point, assume n has color
	ret
	mov	dx,win0+8	; get xsize
	imul	dx		; scale distance into 0-xsz
	sar	dx,1
	rcr	ax,1
	mov	al,ah		; divide by 256
	mov	ah,dl
	add	ax,win0+16	; add the center coord
	mov	xc,ax	; here it is!

	mov	ax,bx		; now do y
	mov	dx,win0+10	; get xsize
	imul	dx		; scale distance into 0-xsz
	sar	dx,1
	rcr	ax,1
	mov	al,ah		; divide by 256
	mov	ah,dl
	add	ax,win0+18	; add the center coord
	mov	yc,ax	; here it is!
	mov	si,offset @dataseg:win0		; make bx point to window
	mov	xw,3
	call	drawdisc	; draw the darn point, assume n has color
	ret
.endp

.proc	drawgs	auto		; draws gunsight on window
;	cmp	instflag,0		; are we drawing instruments?
;	jnz	yes2
;	ret				; no
yes2:
	mov	n,7		; gunsight is grey
	mov	bx,gsz
	mov	si,ptrgwinf
	mov	ax,[si+16]
	sub	ax,bx
	mov	argx1,ax
	push	ax
	push	bx
	add	ax,gsz23
	mov	argx2,ax
	mov	ax,[si+18]
	mov	argy1,ax
	mov	argy2,ax
	doline
	inc	argy1
	inc	argy2
	doline
	pop	bx
	pop	ax
	add	ax,bx
	add	ax,bx
	inc	ax			; move one more pixel to the right
	mov	argx1,ax
	sub	ax,gsz23
	mov	argx2,ax
	dec	argy1
	dec	argy2
	doline
	inc	argy1
	inc	argy2
	doline
	mov	si,ptrgwinf
	mov	bx,gsz23
	mov	ax,[si+16]
	mov	argx1,ax
	mov	argx2,ax
	mov	ax,[si+18]
	sub	ax,bx
	mov	argy1,ax
	push	ax
	push	bx
	add	ax,gsz2323
	mov	argy2,ax
	doline
	inc	argx1
	inc	argx2
	doline
	pop	bx
	pop	ax
	add	ax,bx
	add	ax,bx
	inc	ax
	mov	argy2,ax
	sub	ax,gsz2323
	mov	argy1,ax
	dec	argx1
	dec	argx2
	doline
	inc	argx1
	inc	argx2
	doline
	ret
.endp

.proc	erasthr	auto
	mov	bx,offset @dataseg:throld1
	add	bx,pgadd		; make it point to old storage
	mov	ax,[bx]
	mov	xc,ax		; put old needle endpoint in line coord
	mov	xw,5
	mov	yc,thy
	mov	n,0
	mov	si,offset @dataseg:thrwin
	call	drawdisc
	ret
.endp

.proc	erasmds	auto		; erases mds stuff
	mov	dx,3ceh		; dx := graphics controller port addr
	mov	ah,0
	xor	al,al
	out	dx,ax		; put color selection in set/reset reg
	mov	ax,0f01h
	out	dx,ax		; put 0fh in bit plane enable
	mov	ah,0
	mov	al,3
	out	dx,ax		; 0 for the RWM bits of the ALU
	mov	ax,0305h	; write mode 3 select
	out	dx,ax
	mov	si,offset @dataseg:win0
	mov	ax,[si]		; find xmin
	dec	ax		; we want to take care of x mod 8=0 case
	mov	cl,3
	shr	ax,cl		; divide by 8
	add	al,1		; now al contains the byte offset
	xor	ah,ah		; zero upper half
;	push	ax
	mov	cl,3		; find the starting address for the xfer
	shl	ax,cl		; now ax has the byte aligned x-coord
	mov	bx,ax
	mov	ax,[si+2]	; get y coord
	sub	ax,4		; erase starting 4 lines back
	pixadd			; get screen address for window in bx
	mov	di,bx		; save address for stosb
	mov	ax,[si+8]	; get the size of the window 
	add	ax,1		; take care of 2^n-1 case
	mov	cl,3
	shr	ax,cl		; divide by 8
	mov	dl,al		; save for later
	xor	dh,dh		; zero upper half
	mov	cx,[si+10]	; get number of y lines
	add	cx,4		; add 4 extra lines down
	mov	al,-1
weraslp:
	push	cx
	push	di
	mov	cx,dx		; get number of bytes to write
	rep	stosb
	pop	di
	add	di,lconst	; advance to next line
	pop	cx
	loop	weraslp		; go back to do next line
	mov	dx,3ceh		; dx := graphics controller port addr
	mov	ax,5
	out	dx,ax		; write mode 0
	xor	ax,ax
	out	dx,ax
	ret

	xor	dh,dh


	mov	bx,offset @dataseg:mdsold1
	add	bx,pgadd		; make it point to old storage
	mov	ax,[bx]
	mov	xc,ax		; put old needle endpoint in line coord
	mov	ax,[bx+2]
	mov	yc,ax
	mov	xw,6
	mov	n,0
	mov	si,offset @dataseg:win0
	call	drawdisc
	ret
.endp

.proc	oprcrd1 auto		; calc meter angle for temp gauge
	mov	ax,opres
	mov	bx,3	
	xor	dx,dx
	div	bx
	shl	ax,1
	shl	ax,1
	sub	ax,32767-5400
	mov	si,offset @dataseg:oprxc
	ret
.endp

.proc	cmpcrd1 auto		; calc meter angle for compass
	mov	ax,orvec
	neg	ax		; make meter travel in correct direction
	mov	si,offset @dataseg:cmpxc
	ret
.endp

.proc	erasrli	auto		; erases a line, ptr in [si]
	mov	si,offset @dataseg:rlixc	; set ptr
	mov	bx,si
	add	bx,8			; make bx point to altold1
	add	bx,pgadd		; make it point to old storage
	mov	ax,[bx]
	mov	argx2,ax		; put old needle endpoint in line coord
	sub	ax,[si]
	neg	ax
	add	ax,[si]			; reverse end
	mov	argx1,ax
	mov	ax,[bx+2]
	mov	argy2,ax
	sub	ax,[si+2]
	neg	ax
	add	ax,[si+2]
	mov	argy1,ax
	mov	al,0		; now put in draw color
	mov	n,al
	doline
	ret
.endp

.proc	eraspit	auto		; erases a line, ptr in [si]
	mov	si,offset @dataseg:pitxc	; set ptr
	mov	bx,si
	add	bx,8			; make bx point to altold1
	add	bx,pgadd		; make it point to old storage
	mov	ax,[bx]
	mov	argx2,ax		; put old needle endpoint in line coord
	sub	ax,[si]
	neg	ax
	add	ax,[si]			; reverse end
	mov	argx1,ax
	mov	ax,[bx+2]
	mov	argy2,ax
	sub	ax,[si+2]
	neg	ax
	add	ax,[si+2]
	mov	argy1,ax
	mov	al,0		; now put in draw color
	mov	n,al
	doline
	ret
.endp


IF 1 EQ 0
.proc	clmdraw	auto			; draws needle on altimeter
	call	clmcrd1			; get coords of end of needle
	mov	ax,clmxc		; put center in argx1,argy1
	mov	argx1,ax
	mov	ax,clmyc
	mov	argy1,ax
	mov	al,clmclr1		; now put in draw color
	mov	n,al
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	mov	dx,3c4h			; address of seq
	mov	al,2			; index of map mask register
	out	dx,al			; select map mask register
	inc	dx			; now access map mask register
	mov	al,8			; only allow bit one access
	out	dx,al
	ENDIF
	doline
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	mov	dx,3c4h			; address of seq
	mov	al,2			; index of map mask register
	out	dx,al			; select map mask register
	inc	dx			; now access map mask register
	mov	al,0fh			; allow free access to all bit planes
	out	dx,al
	ENDIF
	ret
.endp

.proc	aspdraw	auto			; draws needle on altimeter
	call	aspcrd1			; get coords of end of needle
	mov	ax,aspxc		; put center in argx1,argy1
	mov	argx1,ax
	mov	ax,aspyc
	mov	argy1,ax
	mov	al,aspclr1		; now put in draw color
	mov	n,al
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	mov	dx,3c4h			; address of seq
	mov	al,2			; index of map mask register
	out	dx,al			; select map mask register
	inc	dx			; now access map mask register
	mov	al,8			; only allow bit one access
	out	dx,al
	ENDIF
	doline
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	mov	dx,3c4h			; address of seq
	mov	al,2			; index of map mask register
	out	dx,al			; select map mask register
	inc	dx			; now access map mask register
	mov	al,0fh			; allow free access to all bit planes
	out	dx,al
	ENDIF
	ret
.endp
ENDIF

.proc	altdraw	auto			; draws needle on altimeter
	call	altcrd2			; get coords of end of needle
	mov	ax,altxc		; put center in argx1,argy1
	mov	argx1,ax
	mov	ax,altyc
	mov	argy1,ax
	mov	al,altclr2		; now put in draw color
	mov	n,al
	doline
	call	altcrd3			; get coords of end of needle
	mov	ax,altxc		; put center in argx1,argy1
	mov	argx1,ax
	mov	ax,altyc
	mov	argy1,ax
	mov	al,altclr3		; now put in draw color
	mov	n,al
	doline
	ret
.endp

IF 1 EQ 0
.proc	alterase	auto			; draws needle on altimeter
	mov	pgadd,0
	cmp	pgflg,0
	jz	isp3			; check which animation page
	add	pgadd,4
isp3:
	mov	bx,offset @dataseg:altold1
	add	bx,pgadd
	mov	ax,[bx]
	mov	argx2,ax		; put old needle endpoint in line coord
	mov	ax,[bx+2]
	mov	argy2,ax
	mov	ax,altxc		; put center in argx1,argy1
	mov	argx1,ax
	mov	ax,altyc
	mov	argy1,ax
	mov	al,0		; now put in draw color
	mov	n,al
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	mov	dx,3c4h			; address of seq
	mov	al,2			; index of map mask register
	out	dx,al			; select map mask register
	inc	dx			; now access map mask register
	mov	al,8			; only allow bit one access
	out	dx,al
	ENDIF
	doline
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	mov	dx,3c4h			; address of seq
	mov	al,2			; index of map mask register
	out	dx,al			; select map mask register
	inc	dx			; now access map mask register
	mov	al,0fh			; allow free access to all bit planes
	out	dx,al
	ENDIF
	mov	bx,offset @dataseg:altold2
	add	bx,pgadd
	mov	ax,[bx]
	mov	argx2,ax		; put old needle endpoint in line coord
	mov	ax,[bx+2]
	mov	argy2,ax
	mov	ax,altxc		; put center in argx1,argy1
	mov	argx1,ax
	mov	ax,altyc
	mov	argy1,ax
	mov	al,0		; now put in draw color
	mov	n,al
	doline
	mov	bx,offset @dataseg:altold3
	add	bx,pgadd
	mov	ax,[bx]
	mov	argx2,ax		; put old needle endpoint in line coord
	mov	ax,[bx+2]
	mov	argy2,ax
	mov	ax,altxc		; put center in argx1,argy1
	mov	argx1,ax
	mov	ax,altyc
	mov	argy1,ax
	mov	al,0		; now put in draw color
	mov	n,al
	doline
	ret
.endp

.proc	clmerase	auto			; draws needle on altimeter
	mov	pgadd,0
	cmp	pgflg,0
	jz	isp5			; check which animation page
	add	pgadd,4
isp5:
	mov	bx,offset @dataseg:clmold1
	add	bx,pgadd
	mov	ax,[bx]
	mov	argx2,ax		; put old needle endpoint in line coord
	mov	ax,[bx+2]
	mov	argy2,ax
	mov	ax,clmxc		; put center in argx1,argy1
	mov	argx1,ax
	mov	ax,clmyc
	mov	argy1,ax
	mov	al,0		; now put in draw color
	mov	n,al
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	mov	dx,3c4h			; address of seq
	mov	al,2			; index of map mask register
	out	dx,al			; select map mask register
	inc	dx			; now access map mask register
	mov	al,8			; only allow bit one access
	out	dx,al
	ENDIF
	doline
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	mov	dx,3c4h			; address of seq
	mov	al,2			; index of map mask register
	out	dx,al			; select map mask register
	inc	dx			; now access map mask register
	mov	al,0fh			; allow free access to all bit planes
	out	dx,al
	ENDIF
	ret
.endp

.proc	asperase	auto			; draws needle on altimeter
	mov	pgadd,0
	cmp	pgflg,0
	jz	isp1			; check which animation page
	add	pgadd,4
isp1:
	mov	bx,offset @dataseg:aspold1
	add	bx,pgadd
	mov	ax,[bx]
	mov	argx2,ax		; put old needle endpoint in line coord
	mov	ax,[bx+2]
	mov	argy2,ax
	mov	ax,aspxc		; put center in argx1,argy1
	mov	argx1,ax
	mov	ax,aspyc
	mov	argy1,ax
	mov	al,0		; now put in draw color
	mov	n,al
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	mov	dx,3c4h			; address of seq
	mov	al,2			; index of map mask register
	out	dx,al			; select map mask register
	inc	dx			; now access map mask register
	mov	al,8			; only allow bit one access
	out	dx,al
	ENDIF
	doline
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	mov	dx,3c4h			; address of seq
	mov	al,2			; index of map mask register
	out	dx,al			; select map mask register
	inc	dx			; now access map mask register
	mov	al,0fh			; allow free access to all bit planes
	out	dx,al
	ENDIF
	ret
.endp
ENDIF

.proc	angtocord	auto		; takes angle in ax
					; stows x,y in argx2, argy2
	push	ax			; save for x coord part
	push	si
	call	scos			; get cosine
	pop	si
	neg	ax			; make negative cause scrn org at top
	mov	dx,[si+6]		; scale needle size by cosine
	imul	dx			; 
	shl	ax,1			; round result
	adc	dx,0			; add to good part
	mov	ax,dx			; take upper part
	add	ax,[si+2]		; now add in the coord of meter ctr
	mov	argy2,ax		; prepare for line
	pop	ax			; retrieve angle
	push	si
	call	ssin
	pop	si
	mov	dx,[si+4]		; do the same as above
	imul	dx
	shl	ax,1			; round result
	adc	dx,0			; add to good part
	mov	ax,dx			; take upper part
	add	ax,[si]
	mov	argx2,ax
	ret
.endp

.proc	drawneed	auto		; draws a needle pted to by [si]
	mov	bx,si
	add	bx,8			; make bx point to altold1
	add	bx,pgadd		; make it point to old storage
	mov	ax,argy2
	mov	[bx+2],ax		; also save for erase time
	mov	ax,argx2
	mov	[bx],ax
	mov	ax,[si]		; put center in argx1,argy1
	mov	argx1,ax
	mov	ax,[si+2]
	mov	argy1,ax
	mov	al,[si+16]		; now put in draw color
	mov	n,al
	doline
	ret
.endp

.proc	erasneed	auto		; erases a line, ptr in [si]
	mov	bx,si
	add	bx,8			; make bx point to altold1
	add	bx,pgadd		; make it point to old storage
	mov	ax,[bx]
	mov	argx2,ax		; put old needle endpoint in line coord
	mov	ax,[bx+2]
	mov	argy2,ax
	mov	ax,[si]		; put center in argx1,argy1
	mov	argx1,ax
	mov	ax,[si+2]
	mov	argy1,ax
	mov	al,0		; now put in draw color
	mov	n,al
	doline
	ret
.endp

.proc	drawndles	auto		; draw needles on instruments
	cmp	instflag,0		; are we drawing instruments?
	jnz	yes
	ret				; no
yes:
	mov	pgadd,0
	cmp	pgflg,0
	jz	isp0			; check which animation page
	add	pgadd,4
isp0:
					; set controller to only write
					; msb of pixels, so that the needles
					; pass over the numerals
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	mov	dx,3c4h			; address of seq
	mov	al,2			; index of map mask register
	out	dx,al			; select map mask register
	inc	dx			; now access map mask register
	mov	al,8			; only allow bit one access
	out	dx,al
	ENDIF

l00:	call	altcrd1			; get coords of end of needle
	call	angtocord
	call	drawneed
	call	clmcrd1
	call	angtocord
	call	drawneed
	call	rlicrd2
	call	angtocord
	call	drawneed
	call	rlicrd1			; draw rli needle
	
	mov	ax,frmnum		; get timer number
;	mov	bx,pgadd
;	mov	[bx+offset @dataseg:oticks],ax		; save for erase code
	xor	dx,dx
	mov	bx,14
	div	bx
	add	dx,dx
	mov	bx,dx
	jmp	[bx+offset @dataseg:drawtbl]	; jump to routine

l01:	call	aspcrd1
	call	angtocord
	call	drawneed
	jmp	ext

l03:	call	tmpcrd1
	call	angtocord
	call	drawneed
	jmp	ext

l05:
	call	cmpcrd1
	call	angtocord
	call	drawneed
	jmp	ext
l08:
	call	pitcrd1			; draw rli needle
	call	pitcrd2
	call	angtocord
	call	drawneed

ext:	
	call	drawthrt
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	mov	dx,3c4h			; address of seq
	mov	al,2			; index of map mask register
	out	dx,al			; select map mask register
	inc	dx			; now access map mask register
	mov	al,0fh			; allow free access to all bit planes
	out	dx,al
	ENDIF
	call	oprcrd1
	call	angtocord
	call	drawneed
	call	altdraw			; draw other needles
	call	drawmds
	ret
.endp

.proc	erasndles	auto		; draw needles on instruments
	cmp	instflag,0		; are we drawing instruments?
	jnz	yes1
	ret				; no
yes1:
	mov	pgadd,0
	cmp	pgflg,0
	jz	isp7			; check which animation page
	add	pgadd,4
isp7:
					; set controller to only write
					; msb of pixels, so that the needles
					; pass over the numerals
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	mov	dx,3c4h			; address of seq
	mov	al,2			; index of map mask register
	out	dx,al			; select map mask register
	inc	dx			; now access map mask register
	mov	al,8			; only allow bit one access
	out	dx,al
	ENDIF

	mov	si,offset @dataseg:altxc	; make si point to data area
	call	erasneed
	mov	si,offset @dataseg:clmxc	; point ptr to proper thing
	call	erasneed
	mov	si,offset @dataseg:rlixc2
	call	erasneed
	call	erasrli

	mov	ax,frmnum		; get timer number
;	mov	bx,pgadd			; set up for proper page
;	mov	ax,[bx+offset @dataseg:oticks]
	xor	dx,dx
	mov	bx,14
	div	bx
	add	dx,dx
	mov	bx,dx
	jmp	[bx+offset @dataseg:erastbl]	; jump to routine


el01:	mov	si,offset @dataseg:aspxc	; set ptr
	call	erasneed
	jmp	eext
el03:
	mov	si,offset @dataseg:tmpxc
	call	erasneed
	jmp	eext
el05:
	mov	si,offset @dataseg:cmpxc
	call	erasneed
	jmp	eext
el08:
	call	eraspit
	call	eraspit2

eext:	
	call	erasthr
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	mov	dx,3c4h			; address of seq
	mov	al,2			; index of map mask register
	out	dx,al			; select map mask register
	inc	dx			; now access map mask register
	mov	al,0fh			; allow free access to all bit planes
	out	dx,al
	ENDIF
					; now erase lines which have different
					; colors
	mov	si,offset @dataseg:altxc2
	call	erasneed
	mov	si,offset @dataseg:altxc3
	call	erasneed
	mov	si,offset @dataseg:oprxc
	call	erasneed
	call	erasmds
	ret
.endp

.ends
	end

