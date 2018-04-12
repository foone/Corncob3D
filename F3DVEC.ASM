
	title 'f3dvec'
qslow	equ	0
qmul	equ	1
polydiag	equ	0
cdct	equ	1
copydiag	equ	0
rundf equ 1
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
include model.inc
include	imath.INC
include f3dequ.inc
include	extrns.inc		; get extrnals
include 3dvid.inc
include	pixaddr1.inc		; pixel address routine
include ka.inc

IF slalom
mapmbflag	equ	0
ELSE
IF mbflag
mapmbflag	equ	1
ELSE
mapmbflag	equ	0
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

	public	pzmax
	public	pzmin
	public	pzminbx
	public	tmpbuf
	public	tmp2buf
	public	testpoly
	public	pixeladdr10	; entry point
	public	f3dline		;
	public	calcsin	; calculates sins and cosines for matrix stuff
	public	negsin	; negates the sins to reverse angle of rotation
	public	calcmat	; calculates up a rotation matrix
	public	ncalcmat	; calculates inverse matrix
	public	matvmul	; multiplies a matrix times a vector
	public	mat2mul	; multiplies a matrix times a vector
	public	rotfrm	; rotates a frame of line coords
;	public	rotobj	; rotates the coordinates of an object
	public	drrobj	; draws a object rotated by matrix in [bx]
	public	wrtvec	; writes a vector
	public	wrtmat
	public	rfwait	; waits for the next vertical sync
	public	flipage	; flips to the other page
	public	drawpt	; draws a point on the screen
	public	drawdisc	; draws a disc
	public	drawpoly	; draws a poly
	public	drpoly	; draws a 3d poly rotated 
	public	f3dpoly		; tries to draw a 3d poly
	public	rel3d	; finds vector to plane
	public	relobj5d	; finds vector to plane
	public	d3dobj	; draws a 3d object
	public	drawdirect	; draws a 3d object
	public	drawrdirect	; draws a 3d object
	public	g3dobj	; draws a ground point
	public	xc
	public	yc
	public	xw
	public	orot
	public	norot
	public	omat
	public	tmat
	public	ysign
;	public	matdet
;	public	det
	public	modhr
	public	z0a13
	public	z0a33
	public	tbadd
;	public	tbrmv
	public	drawnear
	.public	copytable,drawmemseg
	public	tblist
	public	scrfbx
	public	strtadr
	public	tbrmv
	public	slam
	public	qcollis
	public	qcrash
	public	qtimed
	public	vmag
	public	x1vec
	public	x2vec
	public	x1mag
	public	x2mag
	public	xdot
	public	xdots
	public	xvx
	public	brdrclr
	.public	rawhlinebit
	.public	rawhline
	.public	nsides
	.public	epage
	.public	readcolors,setcolors,distcolors,setskygnd
	.public	colors,rescolors,packbits
	.public groundcolors,skycolors
.public	orotptr,norotptr
.public	memobjbuf
.public	encodeobj,decodeobj,bringmemseg,farmmemseg
IF getunivbin
.public	tomemseg,tileptr,tobjcount,qintile,fdexpobj
ENDIF
.public	curtilex,curtiley,getctstatusptr,gettileadr
.public	universex,universey
.public	ctx,cty,flushtiles,ctiles,updatect,changethem
.public	dotiles,copyuniv
.public	putbackintable
.public	z0,z0factor,drawmap
.public	header,headerx,headery,headersz,colorbits
.public fillheader,getheader
.public	temp1,temp2,ardvark,temp4
.public	haluclrs,building
.public	disteval
IF mapmbflag EQ 1
.public	tobjdist,distseg,distptr
.public	mbdrawnear
ENDIF
IF printflag
.public	printtables,printobj,printctstatus
.public	dotpoly,randlegalpoly
.public	polylegal
ENDIF
.public	deathcoords


	.extrn	xvec:word
;
.extrn	shutdown:auto
IF errortrap
.extrn	fillscr:auto
ENDIF
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
	.extrn	muls_qw:auto
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	.extrn	egaline:auto
	ENDIF
	IF vgmode EQ 81h
	.extrn	hgcline:auto
	.extrn	clip:auto
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
.extrn	crshflg:byte,haltflag:byte,fadecolor:byte,capturedflag:byte
.extrn	ejectflag:byte,remoteflag:byte
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
.extrn		dxvec:word
.extrn	oticks:word
.extrn	totaldamage:word
.extrn	objtimtable:word
.extrn	memseg:word
.extrn	findexp:auto
.extrn	templatetable:word,ntemplates:word,extendedtypetbl:word
.extrn	missionstatus:word
IF printflag
.extrn	lastdrawn:word
.extrn	lastdrawncx:byte
.extrn	getkbit:auto
.extrn	printexp:auto
.extrn	expsrmvd:word
ENDIF
IF mapmbflag EQ 1
.extrn	nomoveflag:byte
ENDIF
.extrn	drawmemflag:byte
.extrn	viewkludge:word
.extrn	cleanexp:auto
;,tempsum:word
.extrn	zground:word,myzground:word
.extrn	jumpflag:byte,jumpvalue:word
.extrn	frmnum:word
.extrn	maxobjcount:word
IF qrocket
.extrn	rocketflag:byte
ENDIF

IF soundflag EQ 0
.extrn	adldelay:auto,adlwdelay:auto,adldelayinit:auto,adlwrt:auto
.extrn	adlseq:auto,adlreginit:auto,voiceon:auto
.extrn	voiceoff:auto,engineinit:auto,guninit:auto,boominit:auto
.extrn	snareinit:auto,initsound:auto
.extrn	bassinit:auto,snaresnd:auto
.extrn	makeboom:auto
.extrn	b3laminit:auto,b3oominit:auto,blamtick:word
ENDIF

xmin	equ	[si+wxmin]
ymin	equ	[si+wymin]
xmax	equ	[si+wxmax]
ymax	equ	[si+wymax]

.dataseg
objtype		dw	0
extendedtype	dw	0
groundcolors	db	0,42,0
skycolors	db	21,63,63
colors	db	16 dup(0,0,0,0)		; memory for color registers
rescolors	db	16 dup(0,0,0,0)
haluclrs	dw	0,0,0		; present biases for halucinatory clrs
walldamtick	dw	0
orotptr	dw	@dataseg:orot		; pointer to observer's rotation
norotptr	dw	@dataseg:norot		; pointer to observer's rotation
z0		dw	0		; if nonzero, puts limit on zdistance
z0factor	dw	0		; scale factor for multiplication
tempsum		dw	0
					; of object
IF printflag
ptablesmsg	db	0dh,0ah,'Now printing table: ',0
emptytblmsg	db	0dh,0ah,'Empty table',0
ENDIF
temp1		dw	0
temp2		dw	0
temp4		dw	0
ndepth		equ	4

deathcoords	dw	6 dup(0)
ctx		dw	?
cty		dw	?
ctiles		dw	ndepth*2 dup (?)
ctileoffs	dw	0,0,0,-1,-1,0,-1,-1

univoffs	dw	2,2,2,4,2,6
		dw	4,2,4,6
		dw	6,2,6,4,6,6

ctstatus	db	64 dup (0)
bogus		db	0

curtilex	dw	?		; tile coord 0-maxtilex
curtiley	dw	?		; tile coord 0-maxtiley
universex	dw	-128		; the origin of the current universe
universey	dw	-128		; the origin of the current universe
majorx		dw	?
majory		dw	?

IF mapmbflag EQ 1
tobjdist	dw	?,?
tobjcode	db	4
distseg		dw	?
distptr		dw	?
distcx		dw	?
distcy		dw	?
ENDIF

header	db	'Pie',0
headerx	dw	?
headery	dw	?
headersz	dw	0
nstorageplanes	db	0
colorbits	db	5 dup (0)
;colorbits	db	21,240,100,200,91

	dw	3 dup (?)


exptr	dw	0
fdexpobj	dw	?

tileptr	dw	0
tileseg	dw	0
tobjcount	dw	0

building	dw	0
objfail	db	0
linefail	db	0
y_up	dw	?
y_down	dw	?
bkclrs		db	0,0,44h,0ffh,0,0,0,055h,0,-1,-1,-1,-1,-1,-1,-1
bkbits		db	0
orot	dw	32767,0,0
	dw	0,32767,0
	dw	0,0,32767
norot	dw	32767,0,0
	dw	0,32767,0
	dw	0,0,32767
omat	dw	32767,0,0
	dw	0,32767,0
	dw	0,0,32767
tmat	dw	9 dup(?)
x1vec	dw	3 dup(?)
x2vec	dw	3 dup(?)
x1mag	dw	?
x2mag	dw	?
xdot	dw	?,?,0,0
xdots	dw	0,0
xvx	dw	5,5,5
numtbl	dw	0
qctblptr	dw	?
tmpvec	dw	6 dup(?)
ysign	dw	?
gflag	db	?
cwin	dw	?
rdf	db	0
dvflg	db	0
objptr	dw	?
lineptr	dw	?
xtemp	dw	?
ytemp	dw	?
vtemp	dw	?,?

z0a13	dw	?
z0a33	dw	?

vertincr	dw	0
incr1		dw	0
incr2		dw	0
routine		dw	0
code1	db	0
code2	db	0
delx	dw	0
dely	dw	0
comma	db	', ',0
yw	dw	?
xc	dw	?
yc	dw	?
xw	dw	?
xwt	dw	?
tempv	dw	0,0,0
drwvec	dw	14 dup(?)
orgptr	dw	@dataseg:tempv
sya	dw	?
cya	dw	?
spa	dw	?
cpa	dw	?
sra	dw	?
cra	dw	?
tempvct	dw	6 dup(?)
fbxindx	dw	?
cbuf	db	128 dup (?)

ysfl	dw	?
ysfh	dw	?
ysfig	dw	?
yline	dw	?
tyline	dw	?
nbits	dw	?
npts	dw	?

objcount	dw	0

brdrclr	db	7

IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
c2000h	equ	0
ENDIF
IF vgmode EQ 81h
c2000h	equ	0
ENDIF

memobjbuf	dw	nbytexp/2+1 dup (5)	; buffer for drawing objects
						; which are spirited away into
						; another segment


cir0	dw	1
	dw	0,080h
cir1	dw	1
	dw	0,080h
cir2	dw	2
	dw	-lconst,080h
	dw	0,0c0h
cir3	dw	3
	dw	-lconst,180h
	dw	0,1c0h
	dw	lconst,080h
cir4	dw	3
	dw	 -lconst,0180h
	dw	0,3c0h
	dw	lconst,180h
cir5	dw	4
	dw	-2*lconst,1c0h
	dw	-lconst,3e0h
	dw	0,3e0h
	dw	lconst,1c0h
cir6	dw	5
	dw	-2*lconst,3c0h
	dw	-lconst,7e0h
	dw	0,7e0h
	dw	lconst,7e0h
	dw	2*lconst,3c0h
cir7	dw	6
	dw	-3*lconst,1c0h
	dw	-2*lconst,7f0h
	dw	-lconst,7f0h
	dw	0,7f0h
	dw	lconst,7f0h
	dw	2*lconst,1c0h
cir8	dw	7
	dw	-3*lconst,3c0h
	dw	-2*lconst,07e0h
	dw	-lconst,0ff0h
	dw	0,0ff0h
	dw	lconst,0ff0h
	dw	2*lconst,7e0h
	dw	3*lconst,3c0h
cir9	dw	7
	dw	-3*lconst,03e0h
	dw	-2*lconst,07f0h
	dw	-lconst,0ff8h
	dw	0,0ff8h
	dw	3*lconst,03e0h
	dw	2*lconst,07f0h
	dw	lconst,0ff8h
cir10	dw	7
	dw	-3*lconst,07e0h
	dw	-2*lconst,0ff0h
	dw	-lconst,1ff8h
	dw	0,1ff8h
	dw	3*lconst,07e0h
	dw	2*lconst,0ff0h
	dw	lconst,1ff8h
cir11	dw	8
	dw	-4*lconst,03e0h
	dw	-3*lconst,0ff8h
	dw	-2*lconst,1ffch
	dw	-lconst,1ffch
	dw	0,1ffch
	dw	lconst,1ffch
	dw	2*lconst,0ff8h
	dw	3*lconst,03e0h
cir12	dw	8
	dw	-4*lconst,07e0h
	dw	-3*lconst,1ff8h
	dw	-2*lconst,3ffch
	dw	-lconst,3ffch
	dw	0,3ffch
	dw	lconst,3ffch
	dw	2*lconst,1ff8h
	dw	3*lconst,07e0h
cir13	dw	9
	dw	-4*lconst,03e0h
	dw	-3*lconst,0ff8h
	dw	-2*lconst,1ffch
	dw	-lconst,3ffeh
	dw	0,3ffeh
	dw	lconst,3ffeh
	dw	2*lconst,1ffch
	dw	3*lconst,0ff8h
	dw	4*lconst,03e0h
cir14	dw	10
	dw	-5*lconst,07e0h
	dw	-4*lconst,1ff8h
	dw	-3*lconst,3ffch
	dw	-2*lconst,7ffeh
	dw	-lconst,7ffeh
	dw	0,7ffeh
	dw	lconst,7ffeh
	dw	2*lconst,3ffch
	dw	3*lconst,1ff8h
	dw	4*lconst,07e0h
cir15	dw	11
	dw	-5*lconst,03e0h
	dw	-4*lconst,0ff8h
	dw	-3*lconst,3ffeh
	dw	-2*lconst,3ffeh
	dw	-lconst,7fffh
	dw	0,7fffh
	dw	lconst,7fffh
	dw	5*lconst,03e0h
	dw	4*lconst,0ff8h
	dw	3*lconst,3ffeh
	dw	2*lconst,3ffeh
cir16	dw	11
	dw	-5*lconst,07e0h
	dw	-4*lconst,1ff8h
	dw	-3*lconst,7ffeh
	dw	-2*lconst,7ffeh
	dw	-lconst,0ffffh
	dw	0,0ffffh
	dw	lconst,0ffffh
	dw	5*lconst,07e0h
	dw	4*lconst,1ff8h
	dw	3*lconst,7ffeh
	dw	2*lconst,7ffeh
	
cirtbl	dw	@dataseg:cir0
	dw	@dataseg:cir1
	dw	@dataseg:cir2
	dw	@dataseg:cir3
	dw	@dataseg:cir4
	dw	@dataseg:cir5
	dw	@dataseg:cir6
	dw	@dataseg:cir7
	dw	@dataseg:cir8
	dw	@dataseg:cir9
	dw	@dataseg:cir10
	dw	@dataseg:cir11
	dw	@dataseg:cir12
	dw	@dataseg:cir13
	dw	@dataseg:cir14
	dw	@dataseg:cir15
	dw	@dataseg:cir16

oscale	dw	1500,0
cmpjtbl	dw	@codeseg:drwnul
	dw	@codeseg:drwfrm
	dw	@codeseg:drwcld
	dw	@codeseg:drwsph
	dw	@codeseg:drwply


tblist	dw	@dataseg:neartbl	; table of table start addresses
	dw	@dataseg:medtbl
	dw	@dataseg:medtbl		; for reference
	dw	@dataseg:medtbl
	
	.public	neartbl
neartbl	dw	0
tblmx	dw	600
	dw	600 dup(?)

medtbl	dw	0
	dw	128
	dw	128 dup(?)
;medftbl	dw	0
;	dw	256
;	dw	256 dup(?)
;fartbl	dw	0
;	dw	16
;	dw	16 dup(?)

tblen	dw	?
tbstrt	dw	@dataseg:neartbl
odcode	dw	0	; old distance code


lindex	dw	?
rindex	dw	?
ldeltaxh	dw	?
ldeltaxl	dw	?
rdeltaxh	dw	?
rdeltaxl	dw	?
nsides		dw	3
nside4		dw	4
xl1	dw	0
yl1	dw	0
xl2	dw	0
yl2	dw	0
xr1	dw	0
yr1	dw	0
xr2	dw	0
yr2	dw	0
polywin	dw	0
polyobj	dw	0
argx1low	dw	?
argx2low	dw	?
levelcnt	db	?
direction	db	0
testpoly	dw	20*4 dup(?)
tmpbuf	dw	20*6 dup(?)
tmp2buf	dw	20*6 dup(?)
polyptr	dw	0
pxmin	dw	0
pymin	dw	0
pxmax	dw	0
pymax	dw	0
pzmin	dw	0
pzmax	dw	0
pzminbx	dw	0
pzcount	dw	0
nside6	dw	0
pzypln	dw	200
polyymax	dw	0
polyymin	dw	0
hlinemask	db	-1
bhlinemask	dw	-1

IF polydiag
ladvmsg	db	0dh,0ah,'ladvance: ',0
radvmsg	db	0dh,0ah,'radvance: ',0
ENDIF


ardvark		dw	0
.ends

.codeseg

;assume		cs:@codeseg, 
assume ds:@dataseg, es:@dataseg

.proc	f3dpt	auto		; this draws a 3d point on the display

				; this code assumes [si] points to a 3dim
				; vector xyz, x,y,z are signed 16bit values
				; bx points to a window structure as defined
				; in f3dequ.inc
	mov	di,[si]	; get z coordinate
	or	di,di		; check to make sure it is positive
	js	plfail1		; fail the line if z negative
	mov	cx,[bx+zxpln]	; get the zplane dist for x calcs
	cmp	cx,di		; make sure point is far enough away
	jns	plfail1		; if too close, fail the line
	mov	ax,[si+2]		; get the x coord of point
	neg	ax
	imul	cx		; now find x projection onto plane
	idiv	di		; using linear approximation
	add	ax,[bx+wxctr]	; recenter the data in the window
	mov	argx1,ax	; save result in memory location
	mov	cx,[bx+zypln]	; get the zplane dist for y calcs
	cmp	cx,di		; make sure point isn't too close
	jns	plfail1
	mov	ax,[si+4]	; get the y coord of point
	neg	ax
	imul	cx		; now find the y projection onto plane
	idiv	di		;
	add	ax,[bx+wyctr]	; recenter the data in the window
	mov	argy1,ax	; save result in memory location
	push	si
	mov	si,bx
	call	drawpt		; draw the point on the display
	pop	si
	ret
plfail1:
	stc
	ret			; fail the point
.endp

.proc	f3ddsc	auto		; this draws a 3d point on the display

				; this code assumes [si] points to a 3dim
				; vector xyz, x,y,z are signed 16bit values
				; bx points to a window structure as defined
				; in f3dequ.inc
	mov	di,[si]	; get z coordinate
	or	di,di		; check to make sure it is positive
	js	dlfail1		; fail the line if z negative
	mov	cx,[bx+zxpln]	; get the zplane dist for x calcs
	cmp	cx,di		; make sure point is far enough away
	jns	dlfail1		; if too close, fail the line
	mov	ax,[si+2]		; get the x coord of point
	neg	ax
	imul	cx		; now find x projection onto plane
	idiv	di		; using linear approximation
	add	ax,[bx+wxctr]	; recenter the data in the window
	mov	xc,ax	; save result in memory location
	mov	ax,xw		; get the x coord of point
	imul	cx		; now find x projection onto plane
	idiv	di		; using linear approximation
	mov	xw,ax
	mov	cx,[bx+zypln]	; get the zplane dist for y calcs
	cmp	cx,di		; make sure point isn't too close
	jns	dlfail1
	mov	ax,[si+4]	; get the y coord of point
	neg	ax
	imul	cx		; now find the y projection onto plane
	idiv	di		;
	add	ax,[bx+wyctr]	; recenter the data in the window
	mov	yc,ax	; save result in memory location
	
	push	si
	mov	si,bx
	call	drawdisc	; draw the point on the display
	pop	si
	ret
dlfail1:
	stc
	ret			; fail the point
.endp

.proc	polyhell	auto	; this routine takes care of the case where
				; the polygon is under the observer
				; and the poly must be clipped
	mov	cx,nsides	; first we must extend the list of z coords
	mov	ax,6		; so that the list appears to start with the
	mul	cx		; minimum entry
	mov	nside6,ax	;   this points at end of list
	mov	ax,ds		; prepare for xfer of rest of polygon
	mov	es,ax
	mov	si,offset @dataseg:tmpbuf	; point a beginning
	mov	di,si
	add	di,nside6	; point di to end of current polygon
	mov	cx,pzminbx	; this points at the minimum z point in poly
	add	cx,6		; transfer at least one xyz coord point
	cld
	rep	movsb		; bang!, it's moved

	mov	si,offset @dataseg:tmpbuf	; point to data
	mov	bx,pzminbx	; point to point with smallest z
	mov	ax,nsides
	inc	ax		; give the benefit of a doubt
	mov	pzcount,ax 	; keep track of how many points we've done

zneglp:
	add	bx,6		; advance to next point in ring
	dec	pzcount		; make sure we haven't screwed up here
	jz	phellfail	; yup, so abort with error
	mov	ax,pzypln	; check out for too close
	cmp	[si+bx],ax	; check z coordinate
	jl	zneglp		; if this point is too small also, then skip

	add	si,bx		; make si point to previous point
	sub	si,6		; to init the xfer of data
	mov	di,offset @dataseg:tmp2buf	; start writing the data
	mov	cx,6		; mov two vectors worth
	rep	movsw
	mov	si,offset @dataseg:tmp2buf	; start writing the data
	push	bx		; save our place while in choplin
	mov	bx,polywin	; restore window info pointer
	mov	lineptr,si	; save si in a variable for choplin
	call	choplin		; chop the damn line!
	pop	bx		; restore
	jc	phellfail	; was the line un choppable?
	mov	lindex,12	; now point to place of updation
zposlp:				; now we want to loop whilst waiting for neg
	add	bx,6		; advance bx again
	dec	pzcount		; make sure we don't go over our bounds
	jz	phellfail
	mov	si,offset @dataseg:tmpbuf
	add	si,bx		; make si point to our current location
	mov	di,offset @dataseg:tmp2buf
	add	di,lindex	; di to point at destination
	mov	cx,6		; we will copy two vectors
	rep	movsw
	mov	si,offset @dataseg:tmpbuf
	mov	ax,pzypln	; restore our si, and then look for neg z
	cmp	[si+bx],ax
	jl	rumper		; yes, then make final point via choplin
	add	lindex,6	; no, just advance destination ptr, try again
	jmp	zposlp

phellfail:
	stc
	ret

rumper:
	sub	lindex,6
	mov	si,offset @dataseg:tmp2buf
	add	si,lindex	; di to point at destination
	push	bx		; save our place while in choplin
	mov	bx,polywin	; restore window info pointer
	mov	lineptr,si	; save si in a variable for choplin
	call	choplin		; chop the damn line!
	pop	bx		; restore
	jnc	rumper1
	mov	ax,lindex
	mov	tmp2buf+2,ax
	stc
	ret
	jc	phellfail	; was the line un choppable?
				; now we must reverse the last two vectors
rumper1:
	mov	si,offset @dataseg:tmp2buf
	add	si,lindex
	mov	di,offset @dataseg:tempv
	push	si
	mov	cx,3
	rep	movsw
	pop	di
	mov	cx,3
	rep	movsw
	mov	si,offset @dataseg:tempv
	mov	cx,3
	rep	movsw
	mov	ax,lindex	; now find how many points in new polygon
	mov	bl,6		; by dividing lindex by 6
	div	bl
	xor	ah,ah		; don't let the high byte bite us!
	inc	ax		; sides equals n+1
	inc	ax		; sides equals n+2
	mov	nsides,ax	; revise the number of sides
	mov	cx,ax		; set it up for f3dpoly
	mov	si,offset @dataseg:tmp2buf
	mov	lindex,0	; another thing that f3dpoly likes....
	clc			; go back to f3dpoly with new si
	ret
.endp
	
.proc	dud1	auto
pplfail1:
	pop	cx		; release the thing from the stack
pplfail0:
	stc
	ret			; fail the point
.endp


.proc	f3dpoly	auto		; draw a rotated polygon
	mov	polywin,bx	; save the window info right away
	mov	polyobj,si	; save the start addr of the info
	mov	ax,32767	; the first task is to find the minimum
	mov	pxmin,ax
	mov	pymin,ax
	neg	ax
	mov	pxmax,ax
	mov	pymax,ax
	mov	cx,nsides	; prepare for xlation loop
	mov	lindex,0
	mov	ax,[bx+zxpln]	; is the poly under us?
	mov	pzypln,ax	; save cutoff distance required
	mov	dx,pzmax	; get max z
	or	dx,dx
	js	pplfail0	; don't accept negative zmaxes
	cmp	ax,dx	; is whole poly out of range?
	jge	pplfail0
	cmp	ax,pzmin	; 
	jle	polyxlp		; no, so just treat as a normal polygon
	call	polyhell	; call polyhell to clip poor polygon
	jc	pplfail0	; if chop failed, fail poly

polyxlp:
	push	cx		; save loop counter
	mov	bx,polywin	; restore window pointer
				; this code assumes [si] points to a 3dim
				; vector xyz, x,y,z are signed 16bit values
				; bx points to a window structure as defined
				; in f3dequ.inc
	mov	pzminbx,-1
	mov	di,[si]	; get z coordinate
	or	di,di		; check to make sure it is positive
	mov	pzminbx,-2
	js	pplfail1		; fail the line if z negative
	mov	cx,[bx+zxpln]	; get the zplane dist for x calcs
	cmp	rdf,0		; don't check if object is far away
	jnz	f3plb1
	cmp	cx,di		; make sure point is far enough away
	mov	pzminbx,-3
	jns	pplfail1		; if too close, fail the line
f3plb1:
	mov	ax,[si+2]		; get the x coord of point
	neg	ax
	imul	cx		; now find x projection onto plane
	idiv	di		; using linear approximation
	add	ax,[bx+wxctr]	; recenter the data in the window
	mov	argx1,ax	; save result in memory location
IF polydiag EQ 1
	call	wcr
	call	decwword
ENDIF
	mov	cx,[bx+zypln]	; get the zplane dist for y calcs
	cmp	rdf,0		; don't check if object is far away
	jnz	f3plb2
	cmp	cx,di		; make sure point isn't too close
	mov	pzminbx,-4
	js	f3plb2
	jmp	pplfail1
f3plb2:
	mov	ax,[si+4]	; get the y coord of point
	neg	ax
	imul	cx		; now find the y projection onto plane
	idiv	di		;
	add	ax,[bx+wyctr]	; recenter the data in the window
;	mov	argy1,ax	; save result in memory location
IF polydiag EQ 1
	call	decwword
ENDIF
	cmp	ax,pymin	; adjust min and max type things
	jge	plylb1
	mov	pymin,ax
plylb1:	cmp	ax,pymax
	jle	plylb2
	mov	pymax,ax
plylb2:
	mov	dx,argx1
	cmp	dx,pxmin	; adjust min and max type things
	jge	plxlb1
	mov	pxmin,dx
plxlb1:	cmp	dx,pxmax
	jle	plxlb2
	mov	pxmax,dx
plxlb2:
	mov	bx,lindex	; get index into our little table
	add	bx,offset @dataseg:testpoly	; point at the temp space
	mov	[bx],dx		; save x and y in there
	mov	[bx+2],ax
	add	lindex,4		; advance to next item in table
	add	si,6			; point to next xyz coord
	pop	cx		; restore the loop counter
	loop	polyxlp1
	mov	bx,polywin	; now examin poly to see if it is a no-draw
IF polydiag EQ 1
	call	wcr
	mov	ax,pxmin
	call	decwword
	mov	ax,[bx+4]
	call	decwword
	mov	ax,pxmax
	call	decwword
	mov	ax,[bx]
	call	decwword
	mov	ax,pymin
	call	decwword
	mov	ax,[bx+6]
	call	decwword
	mov	ax,pymax
	call	decwword
	mov	ax,[bx+2]
	call	decwword
ENDIF
	mov	ax,pxmax
	cmp	ax,[bx]		; is max x less than the window's xmin?
	mov	pzminbx,-6
	jle	fpfail2
	mov	ax,pxmin
	cmp	ax,[bx+4]	; is min x greater than the window's xmax?
	mov	pzminbx,-7
	jge	fpfail2
	mov	ax,pymax
	cmp	ax,[bx+2]		; is max x less than the window's xmin?
	mov	pzminbx,-8
	jle	fpfail2
	mov	ax,pymin
	cmp	ax,[bx+6]	; is min x greater than the window's xmax?
	mov	pzminbx,-9
	jge	fpfail2
	mov	si,offset @dataseg:testpoly	; prepare for drawing the suckr
	xchg	si,bx				; window in si, poly in bx
IF polydiag EQ 0
	call	drawpoly			; whew!
ENDIF
						; draw poly can leave carry set
	clc
	ret
polyxlp1:
	jmp	polyxlp
fpfail2:
	stc
	ret
.endp
	
.proc	choplin	auto		; this chops a line if one z is less than
				; zypln
	mov	ax,[si]	; get first z coord
	mov	dx,[bx+zxpln]	; test for out of bounds
	sub	ax,dx
	mov	cx,[si+6]	; get second z coord
	sub	cx,dx
	test	ax,cx		; are both negative?
	js	clfail2		; both negative, fail line
	or	ax,cx		; are both positive?
	jns	cloksf		; yes, then don't persecute
	mov	si,lineptr	; restore line address
	mov	ax,[si]	; get first z coord
	mov	dx,[si+6]	; get second z coord
	cmp	ax,dx		; which is bigger?
	js	csiorok		; order ok
	mov	ax,ds		; this next code switches vectors
	mov	es,ax		; so that z0 is smaller than z1
	mov	di,offset @dataseg:tempv
	mov	cx,3
	rep	movsw
	mov	di,lineptr
	mov	cx,3
	rep	movsw
	mov	si,offset @dataseg:tempv
	mov	cx,3
	rep	movsw
csiorok:	
	mov	si,lineptr	; get address of vectors in si
	mov	di,[si]	; get z0
	mov	ax,[si+6]	; get z1
	mov	dx,[bx+zxpln]	; get zxplane
	cmp	dx,ax		; see if second line is less too,
	js	coneok		; nope, one of the endpoints is ok
clfail2:	stc
	ret
coneok:	sub	dx,di
	js	clfail2
	mov	bp,ax		; save z1 for now
	push	dx		; save zp-z0 for y calc
	mov	ax,[si+8]	; get x1
	sub	ax,[si+2]		; subtract x0
	imul	dx
	mov	cx,bp		; restore z1 to ax
	sub	cx,di		;
	idiv	cx		; now divide
	add	[si+2],ax		; add in x0, 
	mov	ax,[bx+zxpln]	; get new z coord
	inc	ax		; add one just to be sure
	mov	[si],ax
	mov	ax,[si+10]	; get y1
	sub	ax,[si+4]	; subtract y0
	pop	dx		; dx has zp-z0
	imul	dx		; y1-y0 * zp-z0
	idiv	cx		; divide by z1-z0
	add	[si+4],ax	; update y coordinate
	jmp	cloksf		; jump back into code

cloksf:	clc
	ret
.endp


.proc	f3dline	auto
	mov	lineptr,si	; save addr of line ptr
	mov	ax,[si]	; get first z coord
	mov	dx,[bx+zxpln]	; test for out of bounds
	sub	ax,dx
	mov	cx,[si+6]	; get second z coord
	sub	cx,dx
	test	ax,cx		; are both negative?
	js	lfail2		; both negative, fail line
	or	ax,cx		; are both positive?
	jns	loksf		; yes, then don't persecute
	mov	si,lineptr	; restore line address
	mov	ax,[si]	; get first z coord
	mov	dx,[si+6]	; get second z coord
	cmp	ax,dx		; which is bigger?
	js	siorok		; order ok
	mov	ax,ds		; this next code switches vectors
	mov	es,ax		; so that z0 is smaller than z1
	mov	di,offset @dataseg:tempv
	mov	cx,3
	rep	movsw
	mov	di,lineptr
	mov	cx,3
	rep	movsw
	mov	si,offset @dataseg:tempv
	mov	cx,3
	rep	movsw
siorok:	
	mov	si,lineptr	; get address of vectors in si
	mov	di,[si]	; get z0
	mov	ax,[si+6]	; get z1
	mov	dx,[bx+zxpln]	; get zxplane
	cmp	dx,ax		; see if second line is less too,
	js	oneok		; nope, one of the endpoints is ok
lfail2:	stc
	ret
oneok:	sub	dx,di
	js	lfail2
	mov	bp,ax		; save z1 for now
	push	dx		; save zp-z0 for y calc
	mov	ax,[si+8]	; get x1
	sub	ax,[si+2]		; subtract x0
	imul	dx
	mov	cx,bp		; restore z1 to ax
	sub	cx,di		;
	idiv	cx		; now divide
	add	[si+2],ax		; add in x0, 
	mov	ax,[bx+zxpln]	; get new z coord
	inc	ax		; add one just to be sure
	mov	[si],ax
	mov	ax,[si+10]	; get y1
	sub	ax,[si+4]	; subtract y0
	pop	dx		; dx has zp-z0
	imul	dx		; y1-y0 * zp-z0
	idiv	cx		; divide by z1-z0
	add	[si+4],ax	; update y coordinate
	jmp	loksf		; jump back into code

lfail1:	stc			; show error
	ret
loksf:
				; this code assumes [si] points to a 3dim
				; vector xyz, x,y,z are signed 16bit values
				; bx points to a window structure as defined
				; in f3dequ.inc
	mov	di,[si]	; get z coordinate
	or	di,di		; check to make sure it is positive
	js	lfail1		; fail the line if z negative
	jz	lfail1
	mov	cx,[bx+zxpln]	; get the zplane dist for x calcs
	cmp	rdf,0
	jnz	f3dlb0
	cmp	cx,di		; make sure point is far enough away
	jns	lfail1		; if too close, fail the line
f3dlb0:	mov	ax,[si+2]		; get the x coord of point
	neg	ax
	imul	cx		; now find x projection onto plane
	idiv	di		; using linear approximation
	add	ax,[bx+wxctr]	; recenter the data in the window
	mov	argx1,ax	; save result in memory location
	mov	cx,[bx+zypln]	; get the zplane dist for y calcs
	cmp	rdf,0
	jnz	f3dlb1
	cmp	cx,di		; make sure point isn't too close
	jns	lfail1
f3dlb1:	mov	ax,[si+4]	; get the y coord of point
	neg	ax
	imul	cx		; now find the y projection onto plane
	idiv	di		;
	add	ax,[bx+wyctr]	; recenter the data in the window
	mov	argy1,ax	; save result in memory location
	add	si,nbytvec	; advance to next vector coordinates
	mov	di,[si]	; get z coordinate
	or	di,di		; check to make sure it is positive
	js	lfail1		; fail the line if z negative
	jz	lfail1
	mov	cx,[bx+zxpln]	; get the zplane dist for x calcs
	cmp	rdf,0
	jnz	f3dlb2
	cmp	cx,di		; make sure point is far enough away
	jns	lfail1		; if too close, fail the line
f3dlb2:	mov	ax,[si+2]		; get the x coord of point
	neg	ax
	imul	cx		; now find x projection onto plane
	idiv	di		; using linear approximation
	add	ax,[bx+wxctr]	; recenter the data in the window
	mov	argx2,ax	; save result in bp
	mov	cx,[bx+zypln]	; get the zplane dist for y calcs
	cmp	rdf,0
	jnz	f3dlb3
	cmp	cx,di		; make sure point isn't too close
	jns	lfail1
f3dlb3:	mov	ax,[si+4]	; get the y coord of point
	neg	ax
	imul	cx		; now find the y projection onto plane
	idiv	di		;
f3dlb4:	add	ax,[bx+wyctr]	; recenter the data in the window
	mov	argy2,ax	; save result in variable
;	call	wrtem
	mov	cx,[bx+wymin]	; for speedy access
	mov	bp,[bx+wxmax]
	mov	di,[bx+wymax]	; xmin,ymin,xmax,ymax
	xor	dl,dl		; code1 is in dl
	mov	ax,argx1
	cmp	ax,[bx]		; is the argx1 less than xmin?
	jns	fl01
	or	dl,1
fl01:	cmp	ax,bp
	js	fl02
	jz	fl02
	or	dl,4
fl02:	mov	ax,argy1
	cmp	ax,cx
	jns	fl03
	or	dl,2
fl03:	cmp	ax,di
	js	fl04
	jz	fl04
	or	dl,8
fl04:	
;	mov	al,dl
;	call	wcr
;	call	wbyte
	xor	dh,dh		; dh is code2
	mov	ax,argx2
	cmp	ax,[bx]		; is the argx1 less than xmin?
	jns	fll01
	or	dh,1
fll01:	cmp	ax,bp
	js	fll02
	jz	fll02
	or	dh,4
fll02:	mov	ax,argy2
	cmp	ax,cx
	jns	fll03
	or	dh,2
fll03:	cmp	ax,di
	js	fll04
	jz	fll04
	or	dh,8
fll04:	
;	mov	al,dh
;	call	wcr
;	call	wbyte
	mov	ax,dx		; copy codes for perusal
	or	al,ah		; are all bits zero?
	jz	nclip		; if so, no clipping needed
	mov	ax,dx		; copy codes for perusal
	and	al,ah		; are any bits common?
	jz	lll0
	stc
	ret
lll0:
	mov	si,bx		; set up for call to clip
	mov	code1,dl	; init the proper locations
	mov	code2,dh
	call	oclip		; call the old clip routine
	jnc	nclip
	ret			; the line doesn't need to be drawn
; routine for verical lines
nclip:
	mov	al,hrflg	;
	and	al,fillflg	; both need to be set for horizon fill
	jnz	damnh		; check horizon flag.
	call	kline
	clc
	ret
damnh:	
	call	hline		; make filled horizon
	ret
.endp

scode1	proc	near		; sets the xcode
	mov	code1,0
	mov	ax,argx1
	cmp	ax,xmin		; is the argx1 less than xmin?
	jns	l01
	or	code1,1
l01:	cmp	ax,xmax
	js	l02
	jz	l02
	or	code1,4
l02:	mov	ax,argy1
	cmp	ax,ymin
	jns	l03
	or	code1,2
l03:	cmp	ax,ymax
	js	l04
	jz	l04
	or	code1,8
l04:	ret
scode1	endp

scode2	proc	near		; sets the xcode
	mov	code2,0
	mov	ax,argx2
	cmp	ax,xmin		; is the argx1 less than xmin?
	jns	ll01
	or	code2,1
ll01:	cmp	ax,xmax
	js	ll02
	jz	ll02
	or	code2,4
ll02:	mov	ax,argy2
	cmp	ax,ymin
	jns	ll03
	or	code2,2
ll03:	cmp	ax,ymax
	js	ll04
	jz	ll04
	or	code2,8
ll04:	ret
scode2	endp
csetup	proc	near		; sets up some values
	mov	ax,argx2
	sub	ax,argx1
	mov	delx,ax		; save delta-x
	mov	ax,argy2
	sub	ax,argy1
	mov	dely,ax
	ret
csetup	endp

yline1	proc	near		; clips y(x) line
	sub	ax,argx1
	mov	bx,dely
	imul	bx
	mov	bx,delx
	idiv	bx
	add	ax,argy1
	ret
yline1	endp

xline	proc	near		; clips x(y) line
	sub	ax,argy1
	mov	bx,delx
	imul	bx
	mov	bx,dely
	idiv	bx
	add	ax,argx1
	ret
xline	endp

fixx1a	proc	near		; fixes x1
	call	csetup		; calc delta x and dely
	test	code1,1		; is x1 too small?
	jz	fx1
	mov	ax,xmin
	call	yline1		; get intersection of line and x=xmin
	mov	argy1,ax
	mov	ax,xmin
	mov	argx1,ax
fx1:	test	code1,4		; see if too big
	jz	fx3
	mov	ax,xmax
	call	yline1
	mov	argy1,ax
	mov	ax,xmax
	mov	argx1,ax
fx3:	ret
fixx1a	endp

fixx1b	proc	near		; fixes x1
	call	csetup		; calc delta x and dely
	test	code1,2		; is x1 too small?
	jz	fx2
	mov	ax,ymin
	call	xline		; get intersection of line and x=xmin
	mov	argx1,ax
	mov	ax,ymin
	mov	argy1,ax
fx2:	test	code1,8		; see if too big
	jz	fx4
	mov	ax,ymax
	call	xline
	mov	argx1,ax
	mov	ax,ymax
	mov	argy1,ax
fx4:	ret
fixx1b	endp

fixx2a	proc	near		; fixes x1
	call	csetup		; calc delta x and dely
	test	code2,1		; is x1 too small?
	jz	fx5
	mov	ax,xmin
	call	yline1		; get intersection of line and x=xmin
	mov	argy2,ax
	mov	ax,xmin
	mov	argx2,ax
fx5:	test	code2,4		; see if too big
	jz	fx7
	mov	ax,xmax
	call	yline1
	mov	argy2,ax
	mov	ax,xmax
	mov	argx2,ax
fx7:	ret
fixx2a	endp

fixx2b	proc	near		; fixes x1
	call	csetup		; calc delta x and dely
	test	code2,2		; is x1 too small?
	jz	fx6
	mov	ax,ymin
	call	xline		; get intersection of line and x=xmin
	mov	argx2,ax
	mov	ax,ymin
	mov	argy2,ax
fx6:	test	code2,8		; see if too big
	jz	fx8
	mov	ax,ymax
	call	xline
	mov	argx2,ax
	mov	ax,ymax
	mov	argy2,ax
fx8:	ret
fixx2b	endp

	assume	ds:@dataseg
oclip	proc	near		; clips line 
	call	fixx1a		; try fixing x coords
	call	fixx2a
; now try again, maybe all the clipping is done..
	call	scode1		; get code1
	call	scode2
	mov	al,code1	; see if line requires clipping at all
	or	al,code2
	clc
	jz	noclip		; if zero, no clipping needed!
	mov	al,code1
	and	al,code2	; if non-zero, no line needed!
	stc
	jnz	noclip
	call	fixx1b		; try fixing y coords
	call	fixx2b
	clc
noclip:	ret
oclip	endp

.proc	wcr	auto
	push	ax
	mov	al,0dh
	call	put_chr
	mov	al,0ah
	call	put_chr
	pop	ax
	ret
.endp

IF	(vgmode EQ 10h) or (vgmode EQ 81h)
	brthk	equ 4
ENDIF
IF	vgmode EQ 0dh
	brthk	equ 2
ENDIF


.proc	thckbar	auto		; draws a vertical bar 1 byte wide
				; di=start addr cx= ysize
				; assumes controller in wrt mode 3
	mov	al,-1
	add	di,vboff	; start in correct page
thckbl:	stosb
	add	di,bpl-1		; 80 -1 for stosb advance
	loop	thckbl
	ret
.endp

.proc	fillbx	auto		; fill a box with data
	mov	fbxindx,bx	; save box vertical size
	add	di,vboff	; add offset of current buffer
	mov	bx,di		; save start addr
	mov	si,cx		; save count
fbxlp:	rep	stosw		; write bar
	mov	cx,si		; restore count
	add	bx,lconst	; goto next line
	mov	di,bx
	dec	fbxindx		; decrement box count size
	jnz	fbxlp
	ret
.endp

.proc	scrfbx	auto		; do above, but set controller registers
		mov	ax,vgseg
		mov	es,ax
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	mov	dx,3ceh		; dx := graphics controller port addr
	mov	ah,n		; set color to n
	xor	al,al
	out	dx,ax		; put color selection in set/reset reg
	mov	ax,0f01h
	out	dx,ax		; put 0fh in bit plane enable
	mov	ah,0
	mov	al,3
	out	dx,ax		; 0 for the RWM bits of the ALU
	mov	ax,0305h	; write mode 3 select
	out	dx,ax
	mov	ax,-1		; set bits
	ENDIF
	IF vgmode EQ 81h
	mov	dl,al
	mov	al,n
	xor	ah,ah
	mov	bx,offset @dataseg:bkclrs
	xlat
	mov	bkbits,al
	ENDIF
	call	fillbx		; call real routine
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	mov	dx,3ceh		; dx := graphics controller port addr
	xor	ax,ax
	out	dx,ax		; write mode 0
	inc	ax
	out	dx,ax
	mov	al,3
	out	dx,ax
	mov	ax,5
	out	dx,ax		; write mode 0
	mov	ax,0ff08h
	out	dx,ax
	ENDIF
	ret
.endp


.proc	epage	auto		; erases the page pointed to by bx
	IF vgmode EQ 81h
	ret
	ENDIF
	push	dx
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
		mov	ax,vgseg
		mov	es,ax
		mov	di,vboff
		mov	cx,8000
	mov	ax,-1
;	rep	stosw
	mov	bx,95
	mov	cx,19
	mov	di,20341
;	call	fillbx		; erase contents of other window
	mov	ah,brdrclr	; make these bars grey
	xor	al,al
	out	dx,ax		; put color selection in set/reset reg
	mov	si,ptrgwinf	; load window info
;	mov	di,gfymin*bpl		; make a vertical bar
	mov	di,[si+20]	; mininmum
	dec	di		; take off the stupid offset
	mov	cx,[si+10]	; gfymax-gfymin
	call	thckbar		; do it up!
	mov	si,ptrgwinf	; load window info
;	mov	di,gfymin*bpl+bpl-1

	mov	di,[si+20]	; mininmum
	dec	di		; take off the stupid offset
	add	di,bpl-1	; add enough  to pt to eol
;	mov	cx,gfymax-gfymin
	mov	cx,[si+10]	; gfymax-gfymin
	call	thckbar		; do it up!

	cmp	jumpflag,0	; are we charging up for a jump?
	jz	nojump
	push	dx
	mov	ax,[si+10]	; gfymax-gfymin
	mov	dx,jumpvalue	; load the jumpvalue 0-1024
	mul	dx
	mov	bx,jumpmax	; now divide by 1024
	div	bx		; scale size of jump bar
	mov	dx,[si+10]	; gfymax-gfymin
	sub	dx,ax		; find how many lines to start down from the
				; top of the screen
	mov	cx,ax		; cx now has number of lines
	mov	ax,dx		; now find #bytes to skip till beginning of
	mov	dx,bpl		; the jumpbar
	mul	dx
	mov	di,[si+20]	; mininmum
	dec	di		; take off the stupid offset
	add	di,bpl-1	; add enough  to pt to eol
	add	di,ax		; add jump flag start offset
	mov	dx,3ceh		; dx := graphics controller port addr
	mov	ah,5		; use magenta for the bar
	xor	al,al
	out	dx,ax		; put color selection in set/reset reg
	call	thckbar		; do it up!
				
				; restore proper color
	mov	dx,3ceh		; dx := graphics controller port addr
	mov	ah,brdrclr	; use brdrclr for the bar
	xor	al,al
	out	dx,ax		; put color selection in set/reset reg

	pop	dx
	



nojump:
	mov	ax,-1
	mov	di,vboff
	mov	cx,brthk*bpl
	rep	stosw		; write horiz bar at top
	mov	di,vboff
;	add	di,15920	; write horiz bar at bottom of main window
	mov	si,ptrgwinf	; load window info
;	add	di,gfymax*bpl
	add	di,[si+22]	; get the data
	mov	cx,brthk*bpl
;	mov	cx,200
	rep	stosw

	cmp	ptrgwint,0
	jz	nolowfrm
;	mov	di,20020	; write one horiz for left win
	mov	di,gtmnb-(brthk*bpl)-1-bpl
;	mov	cx,20
	mov	cx,(gtxmax-gtxmin+1)/16+1
	mov	bx,brthk+1
	call	fillbx
;	mov	di,27540	; bottom of rear window
	mov	di,((vysiz-brthk-1)*bpl)+(gtxmin/8)-bpl-1

;	mov	cx,20
	mov	cx,(gtxmax-gtxmin+1)/16+1
	mov	bx,brthk+1
	call	fillbx
;	IF vgmode EQ 10h
;	jmp	nolowfrm
;	ENDIF
;	mov	di,20340
	mov	di,gtmnb-1
;	mov	cx,96
	mov	cx,gtymax-gtymin+1
	call	thckbar
;	mov	di,20379
	mov	di,gtmnb+(gtxmax-gtxmin+1)/8
;	mov	cx,96
	mov	cx,gtymax-gtymin+1
	call	thckbar

nolowfrm:
	mov	dx,3ceh		; dx := graphics controller port addr
	mov	ax,5
	out	dx,ax		; write mode 0
	xor	ax,ax
	out	dx,ax
	pop	dx
	ret
.endp	


.proc	dot2	auto		; finds dot product, and places in [di]
				; vec1 in [si] vec2 pointed by bx
	mov	ax,[si]
	mov	dx,[bx]
	imul	dx
	mov	vtemp,ax
	mov	vtemp+2,dx	; keep dot product in double format until
				; end, then xlat to single
	mov	ax,[si+6]
	mov	dx,[bx+2]
	imul	dx
	add	vtemp,ax
	adc	vtemp+2,dx
	mov	ax,[si+12]
	mov	dx,[bx+4]
	imul	dx
	add	ax,vtemp
	adc	dx,vtemp+2
	cmp	dx,16383
	jl	dhghlim
	mov	dx,16382
dhghlim:	
	cmp	dx,-16383
	jg	dlowlim
	mov	dx,-16382
dlowlim:
	shl	ax,1
	rcl	dx,1
	mov	[di],dx
	ret


;	hmul	[si],[bx]
;	mov	[di],dx
;	hmul	[si+6],[bx+2]
;	add	[di],dx
;	hmul	[si+12],[bx+4]
;	add	[di],dx
;	ret
.endp

.proc	primdot	auto		; primitive dot, built for speed
	mov	ax,[si]
	mov	dx,[bx]
	imul	dx
	rol	dx,1		; shift left one to set right
	mov	[di],dx
	mov	ax,[si+2]
	mov	dx,[bx+2]
	imul	dx
	rol	dx,1		; shift left one to set right
	add	[di],dx
	mov	ax,[si+4]
	mov	dx,[bx+4]
	imul	dx
	rol	dx,1		; shift left one to set right
	add	[di],dx
	ret
.endp

.proc	dot	auto		; finds dot product, and places in [di]
				; vec1 in [si] vec2 pointed by bx
	hmul	[si],[bx]
	mov	[di],dx
	hmul	[si+2],[bx+2]
	mov	ax,[di]
	madd
	mov	[di],ax
	hmul	[bx+4],[si+4]
	mov	ax,[di]
	madd
	mov	[di],ax
	ret
.endp

.proc	mat2mul	auto
	call	dot2
	add	bx,6		; do first row of matrix
	add	di,6		; and now advance to next row
	call	dot2
	add	bx,6
	add	di,6
	call	dot2
	ret
.endp

.proc	pmvmul	auto
	call	primdot
	add	bx,6		; do first row of matrix
	add	di,2		; and now advance to next row
	call	primdot
	add	bx,6
	add	di,2
	call	primdot
	ret
.endp

.proc	matvmul	auto
	call	dot
	add	bx,6		; do first row of matrix
	add	di,2		; and now advance to next row
	call	dot
	add	bx,6
	add	di,2
	call	dot
	ret
.endp

.proc	cpyvec	auto		; copies a vector from one place to another
				; [si] to [di]
	mov	cx,3
	mov	ax,ds
	mov	es,ax
	rep	movsw		; mov 3 words
	ret
.endp

.proc	addvec	auto		; adds vectors [si] and [di]
	mov	ax,ds
	mov	es,ax
	mov	ax,[si]
	add	[di],ax
	mov	ax,[si+2]
	add	[di+2],ax
	mov	ax,[si+4]
	add	[di+4],ax
	ret
.endp

.proc	rotwire	auto		; rotates a wire list of coordinates
	push	si
	mov	cx,[si]		; get line count
	inc	cx		; add one, #coords = nlines + 1
	add	si,2		; advance past count
rwlp:	push	cx
	push	bx
	push	si
	mov	di,offset @dataseg:tempv	; pt to temp vec for result
	call	matvmul		; rotate the vecotr
	mov	si,offset @dataseg:tempv	; pt to temp vec for result
	pop	di
	push	di
	call	cpyvec		; copy temp to current vector
	mov	si,orgptr	; get origin coords from object header
	pop	di
	push	di		; set di to vector offset
	call	addvec		; add origin to object coords
	pop	si
	add	si,6		; advance to next wire
	pop	bx
	pop	cx
	loop	rwlp
	pop	si
	ret
.endp

.proc	drwire	auto			; draws a 3d continous rotated
					; wire frame
	push	dx
	push	si
	mov	cx,[si]			; get count of lines in wire
	push	bx
	mov	bx,[si+2]
	mov	al,bl
	or	bh,bh			; check for color as immediate
	jz	drwl1
	mov	al,[bx]
drwl1:	mov	n,al
	pop	bx
	add	si,4			; advance past the count
drwlp:	push	cx
	push	bx
	push	dx
	push	si
	push	bx
	IF qslow
	mov	di,offset @dataseg:tempv	; pt to temp vec for result
	call	matvmul		; rotate the vecotr
	mov	si,offset @dataseg:tempv	; pt to temp vec for result
	mov	di,offset @dataseg:drwvec
	call	cpyvec		; copy temp to current vector
	mov	si,orgptr	; get origin coords from object header
	mov	di,offset @dataseg:drwvec
	call	addvec		; add origin to object coords
	ELSE
	mov	ax,ds
	mov	es,ax		; copy segment register
	cmp	rdf,0
	jz	f3dlb5
	mov	cl,rdf
	lodsw			; get coords, but divide by 256
	sar	ax,cl
	mov	dx,ax
	lodsw	
	sar	ax,cl
	mov	bp,ax
	lodsw	
	sar	ax,cl
	jmp	short f3dlb6

f3dlb5:	lodsw			; get coords into registers
	mov	dx,ax
	lodsw	
	mov	bp,ax
	lodsw	
f3dlb6:	mov	si,orgptr
	mov	di,offset @dataseg:drwvec
	mov	cx,3
	rep movsw		; copy origin into destination coords
	mov	di,ax		; restore di to be z-coord
	mov	si,bx		; get matrix coords addr into si
	mov	bx,offset @dataseg:drwvec
	mov	cx,dx		; get xcoord in correct place
	lodsw	
	imul	cx
	rol	dx,1
	add	[bx],dx
	lodsw	
	imul	bp
	rol	dx,1
	add	[bx],dx
	lodsw	
	imul	di
	rol	dx,1
	add	[bx],dx
	add	bx,2		; advance to next vector coordinate
	lodsw	
	imul	cx
	rol	dx,1
	add	[bx],dx
	lodsw	
	imul	bp
	rol	dx,1
	add	[bx],dx
	lodsw	
	imul	di
	rol	dx,1
	add	[bx],dx
	add	bx,2		; advance to next vector coordinate
	lodsw	
	imul	cx
	rol	dx,1
	add	[bx],dx
	lodsw	
	imul	bp
	rol	dx,1
	add	[bx],dx
	lodsw	
	imul	di
	rol	dx,1
	add	[bx],dx
	ENDIF
	pop	bx
	pop	si
	push	si
	add	si,6
	IF qslow
	mov	di,offset @dataseg:tempv	; pt to temp vec for result
	call	matvmul		; rotate the vecotr
	mov	si,offset @dataseg:tempv	; pt to temp vec for result
	mov	di,offset @dataseg:drwvec+6
	call	cpyvec		; copy temp to current vector
	mov	si,orgptr	; get origin coords from object header
	mov	di,offset @dataseg:drwvec+6
	call	addvec		; add origin to object coords
;	call	get_chr
	ELSE
	cmp	rdf,0
	jz	f3dlb7
	mov	cl,rdf
	lodsw			; get coords, but divide by 256
	sar	ax,cl
	mov	dx,ax
	lodsw	
	sar	ax,cl
	mov	bp,ax
	lodsw	
	sar	ax,cl
	jmp	short f3dlb8

f3dlb7:	lodsw			; get coords into registers
	mov	dx,ax
	lodsw	
	mov	bp,ax
	lodsw	
f3dlb8:	mov	si,orgptr
	mov	di,offset @dataseg:drwvec+6
	mov	cx,3
	rep movsw		; copy origin into destination coords
	mov	di,ax		; restore di to be z-coord
	mov	si,bx		; get matrix coords addr into si
	mov	bx,offset @dataseg:drwvec+6
	mov	cx,dx		; get xcoord in correct place
	lodsw	
	imul	cx
	rol	dx,1
	add	[bx],dx
	lodsw	
	imul	bp
	rol	dx,1
	add	[bx],dx
	lodsw	
	imul	di
	rol	dx,1
	add	[bx],dx
	add	bx,2		; advance to next vector coordinate
	lodsw	
	imul	cx
	rol	dx,1
	add	[bx],dx
	lodsw	
	imul	bp
	rol	dx,1
	add	[bx],dx
	lodsw	
	imul	di
	rol	dx,1
	add	[bx],dx
	add	bx,2		; advance to next vector coordinate
	lodsw	
	imul	cx
	rol	dx,1
	add	[bx],dx
	lodsw	
	imul	bp
	rol	dx,1
	add	[bx],dx
	lodsw	
	imul	di
	rol	dx,1
	add	[bx],dx
	ENDIF
	pop	si
	pop	dx
	push	si
	mov	si,offset @dataseg:drwvec
	push	bx
	push	dx
	mov	bx,dx		; retrieve window information
;	call	f3dline			; draw a line
	call	viewln
	cmp	linefail,1
	jbe	onelinemadeit	; did the line fail in both windows?
	inc	objfail
onelinemadeit:
;	stc			;remove this line!
	pop	dx
	pop	bx
	pop	si
	pop	bx
	add	si,6
	pop	cx
	loop	dr1wlp
	pop	si
	pop	dx
	ret
dr1wlp:	jmp	drwlp
.endp	

.proc	xvect	auto		; rotates vector for tail view
	mov	ax,[bx]
	cmp	hrflg,0		; if it's the horizon, don't reverse
	jz	leavx		; the x coord
;	neg	ax
	mov	[si],ax
	mov	ax,[bx+2]
	mov	[si+2],ax
	mov	ax,[bx+4]
	neg	ax
	mov	[si+4],ax
	ret
leavx:	neg	ax
	mov	[si],ax
	mov	ax,[bx+2]
	neg	ax
	mov	[si+2],ax
	mov	ax,[bx+4]
	mov	[si+4],ax
	ret
.endp

.proc	xvecl	auto		; now rotate for left hand view
	mov	ax,[bx]
	neg	ax
	mov	[si+2],ax
	mov	ax,[bx+2]
	mov	[si],ax
	mov	ax,[bx+4]
	mov	[si+4],ax
	ret
.endp

.proc	xvecr	auto
	mov	ax,[bx]
	mov	[si+2],ax
	mov	ax,[bx+2]
	neg	ax
	mov	[si],ax
	mov	ax,[bx+4]
	mov	[si+4],ax
	ret
.endp

.proc	viewln	auto		; shows lines in four windows
	push	di
	push	si
	mov	ax,ds
	mov	es,ax
	mov	di,offset @dataseg:tempvct
	mov	cx,6
	rep	movsw		; save vector
	pop	si
	push	si		; restore precious si vector
	mov	linefail,0	; line error code is innocent until proven
	mov	bx,ptrgwinf	; forward view window
	call	f3dline				; draw lines
	jnc	vwl2
	mov	linefail,2	; say failure
	cmp	hrflg,0		; check if we must fill horizon
	jz	vwl2		; no
	pop	si
	push	si
	mov	bl,clrdn	; check sign of z 
	mov	al,dvflg	; see if we are diving
	or	al,al
	js	bclok
	mov	bl,clrup
bclok:	mov	n,bl
	push	si
	mov	si,ptrgwinf	; get window info
	mov	bx,[si+10]	; ysize
	mov	cx,[si+8]	; xsize in pixels
	inc	cx		; add one for good measure
	rept	4
	shr	cx,1		; divide by 16
	endm
;	mov	cx,(gfxmax-gfxmin+1)/16
;	mov	di,gfmnb
	mov	di,[si+20]
	pop	si
	IF vgmode EQ 81h
	mov	ax,gfymin
	mov	bx,gfxmin
	pixadd
	mov	di,bx		; move offset into correct place
	ENDIF
	call	scrfbx		; erase contents of other window
vwl2:	
	cmp	ptrgwint,0	; see if tail window is on
	jz	vwl1
	shr	linefail,1	; divide 2 down to one if first line failed
	pop	si
	push	si
	mov	bx,offset @dataseg:tempvct
	call	xvect
	add	si,6
	add	bx,6
	call	xvect		; xlate lines for rear view
	sub	si,6
	mov	bx,ptrgwint	; forward view window
	call	f3dline				; draw lines
	jnc	vwl1
	inc	linefail			; set failed flag
	cmp	hrflg,0		; check if we must fill horizon
	jz	vwl1		; no
	pop	si
	push	si
	mov	bl,clrup	; check sign of z 
	mov	al,dvflg	; see if we are diving
	or	al,al
	js	bclrok
	mov	bl,clrdn
bclrok:	mov	n,bl
	mov	bx,gtymax-gtymin
	mov	cx,(gtxmax-gtxmin+1)/16
	mov	di,gtmnb
	IF vgmode EQ 81h
	mov	ax,gfymin
	mov	bx,gfxmin
	pixadd
	mov	di,bx		; move offset into correct place
	ENDIF
	call	scrfbx		; erase contents of other window
vwl1:	
	pop	si
;	push	si
;	mov	bx,offset @dataseg:tempvct
;	call	xvecl
;	add	si,6
;	add	bx,6
;	call	xvecl		; xlate lines for rear view
;	sub	si,6
;	mov	bx,offset @dataseg:gwinl	; forward view window
;	call	f3dline				; draw lines
;	pop	si
;	push	si
;	mov	bx,offset @dataseg:tempvct
;	call	xvecr
;	add	si,6
;	add	bx,6
;	call	xvecr		; xlate lines for rear view
;	sub	si,6
;	mov	bx,offset @dataseg:gwinr	; forward view window
;	call	f3dline				; draw lines
;	pop	si
	pop	di
	ret
.endp

.proc	viewpoly	auto		; shows poly in four windows
	push	di
	push	si
	mov	bx,ptrgwinf	; forward view window
	call	f3dpoly
	jnc	pllksok		; point looks ok
;	inc	objfail			; set flag for failed object
pllksok:
	cmp	ptrgwint,0
	jz	vpl1
	pop	si
	push	si
	mov	bx,si
	mov	cx,nsides	; will have to do all sides of poly
	mov	pzmin,32767		; init zmin to large number
	mov	pzmax,-32767
	mov	polyptr,0
vwpolylp:
	call	xvect
	mov	ax,[bx]		; get z value and update zminimum
	cmp	ax,pzmax
	jle	vnozmax
	mov	pzmax,ax
vnozmax:
	cmp	ax,pzmin
	jge	vnozmin
	mov	pzmin,ax
	mov	ax,polyptr	; get offset from tmpbuf
	mov	pzminbx,ax
vnozmin:				;
	add	polyptr,6
	add	si,6		; skip to next vector
	add	bx,6
	loop	vwpolylp
	pop	si
	push	si		; reload si with data
	mov	bx,ptrgwint	; forward view window
	call	f3dpoly				; draw lines
	jnc	pllkok		; point looks ok
;	inc	objfail			; set flag for failed object
pllkok:
vpl1:	pop	si
	pop	di
	ret
.endp

.proc	viewpt	auto		; shows points in four windows
	push	di
	push	si
	mov	bx,ptrgwinf	; forward view window
	call	f3dpt				; draw lines
	jnc	ptlksok		; point looks ok
	inc	objfail			; set flag for failed object
ptlksok:
	cmp	ptrgwint,0
	jz	vpt1
	pop	si
	push	si
	mov	bx,si
	call	xvect
	mov	bx,ptrgwint	; forward view window
	call	f3dpt				; draw lines
	jnc	ptlkok		; point looks ok
	inc	objfail			; set flag for failed object
ptlkok:
vpt1:	pop	si
	pop	di
	ret
.endp

.proc	viewdsc	auto		; shows points in four windows
	push	di
	push	si
	mov	bx,ptrgwinf	; forward view window
	call	f3ddsc				; draw lines
	jnc	dscok
	inc	objfail	; set flag to indicate draw failure
dscok:
	cmp	ptrgwint,0
	jz	vdsc1
	pop	si
	push	si
	mov	bx,si
	call	xvect
	mov	bx,ptrgwint	; forward view window
	call	f3ddsc				; draw lines
	jnc	dscok1
	inc	objfail	; set flag to indicate draw failure
dscok1:
vdsc1:	pop	si
	pop	di
	ret
.endp

.proc	drpoly	auto			; draws a rotated poly
	push	dx
	push	si
	mov	cx,[si]			; get count of lines in wire
	mov	nsides,cx
	push	bx
	mov	bx,[si+2]
	mov	al,bl
	or	bh,bh			; check for color as immediate
	jz	pdrwl1
	mov	al,[bx]
pdrwl1:	mov	n,al
	pop	bx
	add	si,4			; point to data
	mov	polyptr,0		; point to begining of buffer
	mov	pzmin,32767		; init zmin to large number
	mov	pzmax,-32767
	or	cx,cx
	jnz	prdwlp
	pop	si
	pop	dx
	ret

prdwlp:	push	cx
	push	bx
	push	si
	push	dx
	push	bx
;	mov	di,offset @dataseg:tempv	; pt to temp vec for result
;	call	matvmul		; rotate the vecotr
;	mov	si,offset @dataseg:tempv	; pt to temp vec for result
;	mov	di,offset @dataseg:drwvec
;	call	cpyvec		; copy temp to current vector
;	mov	si,orgptr	; get origin coords from object header
;	mov	di,offset @dataseg:drwvec
;	call	addvec		; add origin to object coords
	mov	ax,ds
	mov	es,ax		; copy segment register
	cmp	rdf,0
	jz	f3dpb5
	mov	cl,rdf
	lodsw			; get coords, but divide by 256
	sar	ax,cl
	mov	dx,ax
	lodsw	
	sar	ax,cl
	mov	bp,ax
	lodsw	
	sar	ax,cl
	jmp	short f3dpb6

f3dpb5:	lodsw			; get coords into registers
	mov	dx,ax
	lodsw	
	mov	bp,ax
	lodsw	
f3dpb6:	mov	si,orgptr
	mov	di,offset @dataseg:tmpbuf
	add	di,polyptr
	mov	cx,3
	rep movsw		; copy origin into destination coords
	mov	di,ax		; restore di to be z-coord
	mov	si,bx		; get matrix coords addr into si
	mov	bx,offset @dataseg:tmpbuf
	add	bx,polyptr
	mov	cx,dx		; get xcoord in correct place
	lodsw	
	imul	cx
	rol	dx,1
	add	[bx],dx
	lodsw	
	imul	bp
	rol	dx,1
	add	[bx],dx
	lodsw	
	imul	di
	rol	dx,1
	add	[bx],dx
	mov	ax,[bx]		; get z value and update zminimum
	cmp	ax,pzmax
	jle	nozmax
	mov	pzmax,ax
nozmax:
	cmp	ax,pzmin
	jge	nozmin
	mov	pzmin,ax
	mov	ax,polyptr	; get offset from tmpbuf
	mov	pzminbx,ax
nozmin:				;
	add	bx,2		; advance to next vector coordinate
	lodsw	
	imul	cx
	rol	dx,1
	add	[bx],dx
	lodsw	
	imul	bp
	rol	dx,1
	add	[bx],dx
	lodsw	
	imul	di
	rol	dx,1
	add	[bx],dx
	add	bx,2		; advance to next vector coordinate
	lodsw	
	imul	cx
	rol	dx,1
	add	[bx],dx
	lodsw	
	imul	bp
	rol	dx,1
	add	[bx],dx
	lodsw	
	imul	di
	rol	dx,1
	add	[bx],dx
	pop	bx
	pop	dx
	push	dx
	mov	bx,dx
	mov	si,offset @dataseg:tmpbuf
	add	si,polyptr
IF polydiag EQ 1
	call	wcr
	mov	ax,polyptr
	call	decwword
	mov	ax,[si]
	call	decwword
	mov	ax,[si+2]
	call	decwword
	mov	ax,[si+4]
	call	decwword
ENDIF
	add	polyptr,6		; advance to next output vector
	pop	dx
	pop	si
	pop	bx
	add	si,6
	pop	cx
	loop	prdwcp
	push	bx
	push	dx
	mov	bx,dx			; get window info
	mov	si,offset @dataseg:tmpbuf	; point to created area
;	call	f3dpoly				; draw a rotated polygon
	call	viewpoly
	pop	dx
	pop	bx
	pop	si
	pop	dx
	ret
prdwcp:	jmp	prdwlp
.endp	

.proc	drawrcld	auto			; draws a rotated point cloud
	push	dx
	push	si
	mov	cx,[si]			; get count of lines in wire
	add	si,2			; advance past the count
	or	cx,cx
	jnz	rdwlp
	pop	si
	pop	dx
	ret

rdwlp:	push	cx
	push	bx
	push	si
	push	dx
	push	bx
	push	bx
	mov	bx,[si+6]	; get color of dot
	mov	al,bl
	or	bh,bh
	jz	drcll0
	mov	al,[bx]
drcll0:	
	pop	bx
	mov	n,al
;	mov	di,offset @dataseg:tempv	; pt to temp vec for result
;	call	matvmul		; rotate the vecotr
;	mov	si,offset @dataseg:tempv	; pt to temp vec for result
;	mov	di,offset @dataseg:drwvec
;	call	cpyvec		; copy temp to current vector
;	mov	si,orgptr	; get origin coords from object header
;	mov	di,offset @dataseg:drwvec
;	call	addvec		; add origin to object coords
	mov	ax,ds
	mov	es,ax		; copy segment register
	cmp	rdf,0
	jz	f3dcb5
	mov	cl,rdf
	lodsw			; get coords, but divide by 256
	sar	ax,cl
	mov	dx,ax
	lodsw	
	sar	ax,cl
	mov	bp,ax
	lodsw	
	sar	ax,cl
	jmp	short f3dcb6

f3dcb5:	lodsw			; get coords into registers
	mov	dx,ax
	lodsw	
	mov	bp,ax
	lodsw	
f3dcb6:	mov	si,orgptr
	mov	di,offset @dataseg:drwvec
	mov	cx,3
	rep movsw		; copy origin into destination coords
	mov	di,ax		; restore di to be z-coord
	mov	si,bx		; get matrix coords addr into si
	mov	bx,offset @dataseg:drwvec
	mov	cx,dx		; get xcoord in correct place
	lodsw	
	imul	cx
	rol	dx,1
	add	[bx],dx
	lodsw	
	imul	bp
	rol	dx,1
	add	[bx],dx
	lodsw	
	imul	di
	rol	dx,1
	add	[bx],dx
	add	bx,2		; advance to next vector coordinate
	lodsw	
	imul	cx
	rol	dx,1
	add	[bx],dx
	lodsw	
	imul	bp
	rol	dx,1
	add	[bx],dx
	lodsw	
	imul	di
	rol	dx,1
	add	[bx],dx
	add	bx,2		; advance to next vector coordinate
	lodsw	
	imul	cx
	rol	dx,1
	add	[bx],dx
	lodsw	
	imul	bp
	rol	dx,1
	add	[bx],dx
	lodsw	
	imul	di
	rol	dx,1
	add	[bx],dx
	pop	bx
	pop	dx
	push	dx
	mov	bx,dx
	mov	si,offset @dataseg:drwvec
;	call	f3dpt			; draw a line
	call	viewpt
	pop	dx
	pop	si
	pop	bx
	add	si,8
	pop	cx
	loop	rdwcp
	pop	si
	pop	dx
	ret
rdwcp:	jmp	rdwlp
.endp	

.proc	drawrdsc	auto			; draws a rotated point cloud
	push	dx
	push	si
	mov	cx,[si]			; get count of lines in wire
	add	si,2			; advance past the count
	or	cx,cx
	jnz	drdwlp
	pop	si
	pop	dx
	ret
drdwlp:	push	cx
	push	bx
	push	si
	push	dx

	push	bx
	mov	ax,[si+6]		; get the size of the sphere
	mov	cl,rdf			; cut down size of spheres
	shr	ax,cl
	mov	xw,ax
	push	bx
	mov	bx,[si+8]	; get color of dot
	mov	al,bl
	or	bh,bh
	jz	drsll0
	mov	al,[bx]
drsll0:	
	pop	bx
	mov	n,al
;	mov	di,offset @dataseg:tempv	; pt to temp vec for result
;	call	matvmul		; rotate the vecotr
;	mov	si,offset @dataseg:tempv	; pt to temp vec for result
;	mov	di,offset @dataseg:drwvec
;	call	cpyvec		; copy temp to current vector
;	mov	si,orgptr	; get origin coords from object header
;	mov	di,offset @dataseg:drwvec
;	call	addvec		; add origin to object coords
	mov	ax,ds
	mov	es,ax		; copy segment register
	cmp	rdf,0
	jz	f3dsb5
	mov	cl,rdf
	lodsw			; get coords, but divide by 256
	sar	ax,cl
	mov	dx,ax
	lodsw	
	sar	ax,cl
	mov	bp,ax
	lodsw	
	sar	ax,cl
	jmp	short f3dsb6

f3dsb5:	lodsw			; get coords into registers
	mov	dx,ax
	lodsw	
	mov	bp,ax
	lodsw	
f3dsb6:	mov	si,orgptr
	mov	di,offset @dataseg:drwvec
	mov	cx,3
	rep movsw		; copy origin into destination coords
	mov	di,ax		; restore di to be z-coord
	mov	si,bx		; get matrix coords addr into si
	mov	bx,offset @dataseg:drwvec
	mov	cx,dx		; get xcoord in correct place
	lodsw	
	imul	cx
	rol	dx,1
	add	[bx],dx
	lodsw	
	imul	bp
	rol	dx,1
	add	[bx],dx
	lodsw	
	imul	di
	rol	dx,1
	add	[bx],dx
	add	bx,2		; advance to next vector coordinate
	lodsw	
	imul	cx
	rol	dx,1
	add	[bx],dx
	lodsw	
	imul	bp
	rol	dx,1
	add	[bx],dx
	lodsw	
	imul	di
	rol	dx,1
	add	[bx],dx
	add	bx,2		; advance to next vector coordinate
	lodsw	
	imul	cx
	rol	dx,1
	add	[bx],dx
	lodsw	
	imul	bp
	rol	dx,1
	add	[bx],dx
	lodsw	
	imul	di
	rol	dx,1
	add	[bx],dx
	pop	bx
	pop	dx
	push	dx
	mov	bx,dx


	mov	si,offset @dataseg:drwvec
	call	viewdsc
;	call	f3ddsc
	pop	dx
	pop	si
	pop	bx
	add	si,10
	pop	cx
	loop	rdwsp
	pop	si
	pop	dx
	ret
rdwsp:	jmp	drdwlp
.endp	

.proc	drrfrm	auto		; draws a wire frame object pted to by si
	mov	cx,[si]
	add	si,2
	or	cx,cx
	jz	nofrmh		; no frame here
drflp:	push	cx
	push	si
	push	dx
	mov	si,[si]		; get address of frame
	call	drwire		; dcall	drawire		; draw the wire segment
	pop	dx
	pop	si
	add	si,2		; point to the next wire to draw
	pop	cx
	loop	drflp
nofrmh:	
;	cmp	hrflg,0
;	jnz	maybefail	; only fail horizon line: what a kludge!
	mov	objfail,0	; can't fail damn frame
maybefail:
	ret
.endp

.proc	rotfrm	auto		; rotates the coords in a frame by matrix
				; specified by [bx].  Frame in [si]
	mov	cx,[si]
	add	si,2
rflp:	push	cx
	push	si
	mov	si,[si]		; get address of wire
	push	dx
	push	bx
	pop	bx
	call	rotwire
	pop	dx
	pop	si
	add	si,2		; point to the next wire to draw
	pop	cx
	loop	rflp
	ret
.endp

IF 1 EQ 0
.proc	rotobj	auto		; rotates the coords contained in an object
				; object pointed to by si
	mov	orgptr,si	; save initial pointer
	push	si
	mov	si,[si+6]	; get address of frame
	call	rotfrm		; rotate and translate it
	pop	si		; restore object address
	ret
.endp
ENDIF

.proc	drrobj	auto		; rotates the coords contained in an object
				; object pointed to by si
	push	dx
	push	bx
	push	si
	mov	si,offset @dataseg:xvec
	mov	bx,offset @dataseg:tmat
	mov	ysign,0
	hmul	[si],[bx]
	mov	cx,dx
	hmul	[si+2],[bx+6]
	add	cx,dx
	hmul	[si+4],[bx+12]
	add	cx,dx
	shl	cx,1
	rcl	ysign,1
	hmul	[si],[bx+2]
	mov	cx,dx
	hmul	[si+2],[bx+8]
	add	cx,dx
	hmul	[si+4],[bx+14]
	add	cx,dx
	shl	cx,1
	rcl	ysign,1
	hmul	[si],[bx+4]
	mov	cx,dx
	hmul	[si+2],[bx+10]
	add	cx,dx
	hmul	[si+4],[bx+16]
	add	cx,dx
	shl	cx,1
	rcl	ysign,1
	pop	si
	mov	orgptr,si	; save ptr to relative coordinate of ctr
	mov	ax,[si+6]	; get number of components in object
	mov	cx,ax		; save in cx
	mov	dx,ysign	; get quadrant # in dx
	mul	dl		; put unsigned result in ax
	add	ax,ax		; multiply ax by 2
	add	ax,ax		; multiply ax by 2
	add	ax,8		; skip xyz coords, and N
	add	si,ax		; point to beginning of component lists
	pop	bx
	pop	dx
	or	cx,cx		; check for zero components in object
	jz	cdrdn		; don't try to draw if zero objects
cdrwlp:	push	cx		; save the loop count
	push	si
	mov	objfail,0	; clear object failed flag
	mov	ax,[si+2]	; get address of component
	mov	cx,si
	mov	si,[si]		; get code 0,2,4,6,8 for access into jmp tbl
	or	si,si
	jns	cdrlb1
	or	cs:cecode,5
	jmp	cdrwdn
cdrlb1:	cmp	si,9
	js	cdrlb2
cdrer1:	or	cs:cecode,6
	jmp	cdrwdn
cdrlb2:	
	test	si,1
	jnz	cdrer1
	and	si,0eh
	add	si,offset @dataseg:cmpjtbl 
	jmp	[si]		; jump into neverland!
cdrwdn:	
	cmp	rdf,0		; is the object distant?
	jz	dckobj		; yes, then don't check object
	cmp	ptrgwint,0	; is the rear view on?
	jnz	rwdwon
	cmp	objfail,0	; has the object failed to be drawn?
	jnz	drrabt		; yes, then abort this drawing
rwdwon:	
	cmp	objfail,2
	jz	drrabt		; if objfailed both front and back, forget it!
dckobj:	pop	si		; restore venerable registers
	pop	cx
	add	si,4		; advance to next component
	loop	cdrwlp
cdrdn:	
	ret
drrabt:	pop	si
	pop	cx
	stc
	ret			; abort the whole drawing

drwfrm:	mov	si,ax		; set address
	call	drrfrm		; draw the frame
drwnul:	jmp	cdrwdn
drwcld:	mov	si,ax		; set address
	call	drawrcld		; draw the frame
	jmp	cdrwdn
drwsph:	mov	si,ax		; set address
	call	drawrdsc		; draw the frame
	jmp	cdrwdn
drwply:	mov	si,ax		; set addr
	call	drpoly		; draw the polygon
	jmp	cdrwdn

	push	dx
;	mov	dx,3ceh		; dx := graphics controller port addr
;	mov	ax,0f01h
;	out	dx,ax
;	mov	ah,0
;	mov	al,3
;	out	dx,ax
	pop	dx
	mov	orgptr,si	; save initial pointer
	push	si		; save address of object
	mov	si,[si+6]	; get address of frame
	call	drrfrm		; rotate and translate it
	pop	si
	push	si
	mov	si,[si+8]	; get address of cloud
	call	drawrcld
	pop	si
	push	si
	mov	si,[si+10]
	call	drawrdsc
	pop	si
;	mov	dx,3ceh		; dx := graphics controller port addr
;	xor	ax,ax
;	out	dx,ax
;	inc	ax
;	out	dx,ax
;	mov	al,3
;	out	dx,ax
;	mov	ax,0ff08h
;	out	dx,ax
	ret
.endp

.proc	calcsin	auto		; calculates rotation sin&cosines
				; assumes angles yaw,pitch,roll in [bx]
	mov	ax,[bx]		; get yaw
	push	ax		; save
	call	ssin
	mov	sya,ax		; save sin
	pop	ax		; now get cos
	call	scos
	mov	cya,ax
	mov	ax,[bx+2]		; get pitch
	push	ax		; save
	call	ssin
	mov	spa,ax		; save sin
	pop	ax		; now get cos
	call	scos
	mov	cpa,ax
	mov	ax,[bx+4]		; get roll
	push	ax		; save
	call	ssin
	mov	sra,ax		; save sin
	pop	ax		; now get cos
	call	scos
	mov	cra,ax
	ret
.endp

.proc	negsin	auto				; reverses sign of sins
	neg	sya				; negate sins of angles
	neg	spa				; for reversing rot of matrix
	neg	sra
	ret
.endp

.proc	calcmat	auto		; calculates rotation matrix 
	hmul	cya,cpa
	mov	[si],dx		; first term is harmless enough!
	hmul	cpa,sya
	mov	[si+2],dx
	mov	ax,spa
	neg	ax
	mov	[si+4],ax
	hmul	sra,spa
	hmul	dx,cya
	push	dx
	hmul	cra,sya
	pop	ax
	neg	dx
	madd
;	sub	ax,dx
	mov	[si+6],ax
	hmul	sra,spa
	hmul	dx,sya
	push	dx
	hmul	cra,cya
	pop	ax
	madd
;	add	ax,dx
	mov	[si+8],ax
	hmul	cpa,sra
	mov	[si+10],dx
	hmul	cra,spa
	hmul	dx,cya
	push	dx
	hmul	sra,sya
	pop	ax
	madd
;	add	ax,dx
	mov	[si+12],ax
	hmul	cra,spa
	hmul	dx,sya
	push	dx
	hmul	sra,cya
	pop	ax
	NEG	DX
	madd
;	sub	ax,dx
	mov	[si+14],ax
	hmul	cpa,cra
	mov	[si+16],dx
	ret
.endp

.proc	ncalcmat	auto	; calclates inverse matrix
	call	negsin		; negate angles
	hmul	cya,cpa
	mov	[si],dx
	hmul	cya,spa
	mov	cx,dx		; save this item
	hmul	dx,sra
	push	dx
	hmul	sya,cra
	pop	ax
	madd
;	add	ax,dx
	mov	[si+2],ax	; element a12
	hmul	cx,cra
	push	dx
	hmul	sya,sra
	pop	ax
	neg	ax
	xchg	ax,dx
	madd
;	sub	dx,ax
	mov	[si+4],ax	; element a13
	hmul	sya,cpa
	neg	dx
	mov	[si+6],dx	; element a21
	hmul	sya,spa
	mov	cx,dx
	hmul	dx,sra
	push	dx
	hmul	cya,cra
	pop	ax
	neg	ax
	xchg	ax,dx
	madd
;	sub	dx,ax
	mov	[si+8],ax	; element a22
	hmul	cx,cra
	push	dx
	hmul	cya,sra
	pop	ax
	madd
;	add	ax,dx
	mov	[si+10],ax	; element a23
	mov	ax,spa
	mov	[si+12],ax	; element a31
	hmul	cpa,sra
	neg	dx
	mov	[si+14],dx	; element a32
	hmul	cpa,cra
	mov	[si+16],dx	; element a33
	ret
.endp

.proc	rfwait	auto		; waits for refresh of video
	mov	dx,03dah	; address of status register
wtlp1:	in	al,dx		; get the status
	and	al,08h		; and out unused bits
	jnz	wtlp1
wtlp2:	in	al,dx		; try again
	and	al,08h
	jz	wtlp2		; now we know where we stand
	ret
.endp

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





.proc	strtadr	auto		; sets the start address of the ega to an adr
	IF vgmode EQ 81h
	ret
	ENDIF
	push	dx		; given in ax
	push	ax
	mov	ax,40h		; bios segment
	mov	es,ax
	pop	ax
	mov	es:[4eh],ax
	mov	dx,3d4h		; point to the address register
	cli			; turn off ints to stop tsrs
	mov	al,0ch
	out	dx,al		; select the start addr high register
 	inc	dx		; now point to the data register
	mov	al,ah
	out	dx,al		; change the register value
	sti			; re-enable ints
	mov	dx,3d4h		; point to the address register
	cli			; turn off ints to stop tsrs
	mov	al,0dh
	out	dx,al		; select the start addr high register
 	inc	dx		; now point to the data register
	mov	al,bl
	out	dx,al		; change the register value
	sti			; re-enable ints
	pop	dx
	ret
.endp


.proc	qstopblam	auto
IF soundflag EQ 0
	push	bx		; save screen shake info
	cmp	shakecnt,0
	jnz	nostopblam
	cmp	blamtick,-1
	jz	blamoff1
	jmp	nostopblam
blamoff1:
	mov	bl,2
	mov	ax,10h
	call	voiceoff
	mov	ax,cs:oticks
	mov	blamtick,ax
nostopblam:
	pop	bx
ENDIF
	ret
.endp

.proc	flipage	auto		; flips the page of the board
;	call	rfwait		; wait for the next refresh
	IF vgmode EQ 81h
	ret
	ENDIF
	cmp	brdrcnt,0	; are we displaying madness?
	jz	nomadness
	mov	al,brdrclr
	xor	al,0bh		; reverse some bits
	mov	brdrclr,al
	dec	brdrcnt
nomadness:
	xor	bl,bl		; wow!
IF qrocket
	cmp	rocketflag,0
	jnz	shakeitup1
ENDIF
	cmp	ejectflag,0	; if ejected, don't shake
	jz	noshake1
	mov	brdrclr,7	; leave border color alone after ejecting
	mov	brdrcnt,0
	mov	shakecnt,0
	jmp	noshake
shakeitup1:
	mov	bx,80*256
	cmp	ejectflag,0	; if ejected, don't shake
	jnz	noshake
	jmp	shakeitup
noshake1:
	cmp	shakecnt,0	; should we shake the screen?
	jz	noshake
	dec	shakecnt
;	jnz	stillshakin
;IF shareflag EQ 0
;	cmp	blamtick,-1
;	jz	blamoff1
;	jmp	stillshakin
;blamoff1:
;	mov	bl,2
;	mov	ax,10h
;	call	voiceoff
;	mov	ax,cs:oticks
;	mov	blamtick,ax
;ENDIF
stillshakin:
	mov	bh,241
shakeitup:
	mov	bl,byte ptr frmnum
	and	bl,1
	jz	labelc
	mov	bl,bh
labelc:
noshake:
	call	qstopblam
	xor	pgflg,-1	; invert all the bits in pageflag
	jz	flpbk		; flip back to original
	mov	vboff,0		; change to other page 
	mov	ah,7eh		; display other page
	mov	al,bl
	call	strtadr
	ret
flpbk:	mov	vboff,07e00h	; now draw in page 2
	xor	ah,ah		; while we display page 1
	mov	al,bl
	call	strtadr
	ret
.endp

IF 1 EQ 0
.proc	flipage	auto		; flips the page of the board
;	call	rfwait		; wait for the next refresh
	IF vgmode EQ 81h
	ret
	ENDIF
	cmp	brdrcnt,0	; are we displaying madness?
	jz	nomadness
	mov	al,brdrclr
	xor	al,0bh		; reverse some bits
	mov	brdrclr,al
	dec	brdrcnt
	cmp	ejectflag,0	; if ejected, don't shake
	jnz	noshake2
	xor	bl,bl
	jmp	noshake1
nomadness:
IF qrocket
	cmp	rocketflag,0
	jnz	shakeitup1
ENDIF
noshake2:
	xor	bl,bl
	mov	brdrclr,7	; leave border color alone after ejecting
	mov	brdrcnt,0
	mov	shakecnt,0
	jmp	noshake
shakeitup1:
	mov	bh,80
	jmp	shakeitup
noshake1:
	cmp	shakecnt,0	; should we shake the screen?
	jz	noshake
	dec	shakecnt
;	jnz	shake3
;IF shareflag EQ 0
;	push	bx
;	cmp	blamtick,-1	; is blam active?
;	jz	blamoff2
;	jmp	stills1
;blamoff2:
;		mov	bl,2
;		mov	ax,10h
;		call	voiceoff	; turn voice off
;	mov	ax,cs:oticks
;	mov	blamtick,ax
;stills1:
;	pop	bx
;ENDIF
shake3:
	mov	bh,241
shakeitup:

	mov	bl,byte ptr frmnum
	and	bl,1
	jz	labelc
	mov	bl,bh
labelc:
noshake:
	call	qstopblam	; check for stop of blam voice

	xor	pgflg,-1	; invert all the bits in pageflag
	jz	flpbk		; flip back to original
	mov	vboff,0		; change to other page 
	mov	ah,7eh		; display other page
	mov	al,bl
	call	strtadr
	ret
flpbk:	mov	vboff,07e00h	; now draw in page 2
	xor	ah,ah		; while we display page 1
	mov	al,bl
	call	strtadr
	ret
.endp
ENDIF


pixeladdr10	proc	near
	mov	cl,bl
	push	dx
	mov	dx,bpl		; #bytes per line
	mul	dx
	pop	dx
	shr	bx,1
	shr	bx,1
	shr	bx,1
	add	bx,ax
	add	bx,vboff	; figure in the byte offset
	mov	ax,vgseg	; video segment
	mov	es,ax
	and	cl,7
	xor	cl,7
	mov	ah,1
	ret
pixeladdr10	endp

.proc	drawpt auto
	mov	ax,argx1	; first verify that this pixel can be drawn
	cmp	ax,xmin
	js	poob		; pixel out of bounds
	cmp	ax,xmax
	jns	poob
	jz	poob
	mov	ax,argy1
	cmp	ax,ymin
	js	poob
	cmp	ax,ymax
	jns	poob
	jz	poob
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	mov	dx,3ceh		; dx := graphics controller port addr
	mov	ah,n
	xor	al,al
	out	dx,ax
	mov	ax,0f01h
	out	dx,ax
	mov	ah,0
	mov	al,3
	out	dx,ax
	ENDIF
	mov	ax,argy1
	mov	bx,argx1
	pixadd
	shl	ah,cl
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	mov	al,8
	out	dx,ax
	ENDIF
; draw the line
	IF vgmode EQ 81h
	push	bx
	mov	dl,al
	mov	al,n
	xor	ah,ah
	mov	bx,offset @dataseg:bkclrs
	xlat
	mov	bkbits,al
	or	al,al
	jnz	biton
	not	dl
	and	es:[bx],dl
	clc	
	ret
biton:
	pop	bx
	ENDIF
	or 	es:[bx],al	;set pixel


	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	xor	ax,ax
	out	dx,ax
	inc	ax
	out	dx,ax
	mov	al,3
	out	dx,ax
	mov	ax,0ff08h
	out	dx,ax
	ENDIF
	clc
	ret
poob:	stc
	ret
	.endp

.proc	rawhlinewin	auto
	cmp	di,[si+20]	; see if di below max
	jge	rhl0
	jmp	hordone
rhl0:	cmp	di,[si+22]	; make sure we're less than maximum
	jl	rhl1
bagit:	jmp	hordone
rhl1:
	add	di,vboff	; switch for proper animation frame
	mov	ax,argx2	; check for x2>x1
	mov	bx,argx1	; do the same sort of checks with x1
	cmp	ax,bx
	jge	x2bigger	; do we reverse the order?
	xchg	ax,bx
x2bigger:
	cmp	ax,[si]	; see if line not in window
	jl	bagit
	cmp	ax,[si+4]	; see if extends past window
	jl	rhl2
	mov	ax,[si+4]	; yes, then limit max x
rhl2:
	cmp	bx,[si+4]	; is there any work to do here?
	jge	bagit
	cmp	bx,[si]		; keep in window
	jge	rhl3
	mov	bx,[si]
rhl3:
	sub	ax,bx
	jz	bagit		; bag lines of zero length
dd1:	
	mov	cx,ax	; see what scale we're talking, here
	sub	cx,8
	jg	dd2	; if bigger than 8, skip ahead
	mov	cx,ax	; put count in ax
	dec	cx
	mov	ax,08000h ; make mask
	sar	ax,cl
	mov	dx,bx
	mov	cl,3
	shr	bx,cl
	and	dx,7
	mov	cx,dx
	add	di,bx

	
	shr	ax,cl
	and	ax,bhlinemask
	xchg	es:[di],ah
	inc	di
	xchg	es:[di],al
	jmp	hordone

dd2:	cmp	cx,8		; is npts > 16?
	jg	dd3		; yes, continue with other code
	mov	ax,0ff00h	; make big bit mask
	sar	ax,cl		; ax will hold upto 16 bit mask

	mov	dx,bx
	mov	cl,3
	shr	bx,cl
	add	di,bx
	mov	cx,dx
	xor	dx,dx
	and	cx,7

	jz	dd4		; don't shift once if count=0
dd5:	shr	ax,1		; shift mask to starting position
	rcr	dx,1
	loop	dd5
	and	ax,bhlinemask
	and	dh,hlinemask
dd4:	xchg	es:[di],ah	;
	inc	di
	xchg	es:[di],al
	inc	di
	xchg	es:[di],dh
	jmp	hordone

dd3:	mov	npts,cx	; save number of points - 8
	mov	dx,bx
	mov	cl,3
	shr	bx,cl
	add	di,bx
	mov	cx,dx
	xor	dx,dx
	and	cx,7

	add	npts,cx
	mov	al,hlinemask
	shr	al,cl
	xchg	al,es:[di]
	inc	di
	mov	cx,npts
	shr	cx,1		; how many bytes to write?
	shr	cx,1
	shr	cx,1

dd7:	mov	al,hlinemask
	cld
	rep stosb
dd9:	mov	cx,npts
	and	cl,7
	xor	al,al
	mov	ah,hlinemask
	shr	ax,cl
	xchg	al,es:[di]
hordone:
	clc
	ret
.endp

.proc	rawhlinebit	auto	; writes a raw hline, but affects only
				; specified bit.  Video controller registers
				; are assumed to be already set to write mode
	add	di,vboff	; switch for proper animation frame
	mov	ax,argx2	; check for x2>x1
	sub	ax,argx1
	mov	cx,ax	; see what scale we're talking, here
	sub	cx,8
	
	mov	npts,cx	; save number of points - 8
	mov	bx,argx1
	mov	dx,bx
	mov	cl,3
	shr	bx,cl
	add	di,bx
	mov	cx,dx
	xor	dx,dx
	and	cx,7
	add	npts,cx
	mov	al,hlinemask
	shr	al,cl
	mov	ah,es:[di]	; read which bits are the letters
	and	ah,al		; mask only our bits of interest
	mov	es:[di],ah	; write out the bits in the new color
	inc	di
	mov	cx,npts
	shr	cx,1		; how many bytes to write?
	shr	cx,1
	shr	cx,1
	mov	al,hlinemask
	cld
				; here we have to be stupid instead of 
				; smart, cause we have to write the same
				; bit plane that we read
				; ie we cant use stosb anymore
;	rep stosb
	or	cx,cx
	jz	skipslowlp
slowlp:
	mov	ah,es:[di]	; read which bits are the letters
	and	ah,al		; mask only our bits of interest
	mov	es:[di],ah	; write out the bits in the new color
	inc	di		; advance
	loop	slowlp
skipslowlp:

	mov	cx,npts
	and	cl,7
	mov	ax,0ff00h
	shr	ax,cl
	mov	ah,es:[di]	; read which bits are the letters
	and	ah,al		; mask only our bits of interest
	mov	es:[di],ah	; write out the bits in the new color
	ret
.endp

.proc	rawhline	auto	; writes a raw hline, but affects only
				; specified bit.  Video controller registers
				; are assumed to be already set to write mode
	add	di,vboff	; switch for proper animation frame
	mov	ax,argx2	; check for x2>x1
	mov	bx,argx1
;	sub	ax,argx1
	jmp	rhl3		; jump into rawhline1, we can't go wrong!
.endp

pupring	macro			; xlates bx up on ring
	local	up1
	add	bx,4
	cmp	bx,nside4
	jb	up1
	xor	bx,bx		; point back to begining if go off end
up1:
endm

pdnring	macro			; xlates bx up on ring
	local	dn1
	sub	bx,4
	jns	dn1
	mov	bx,nside4
	sub	bx,4		; point to last item
dn1:
endm

upring	macro
	local	up2,up3,up1,dn1
	cmp	direction,0
	jnz	up2
	add	bx,4
	cmp	bx,nside4
	jb	up1
	xor	bx,bx		; point back to begining if go off end
up1:
	jmp	up3
up2:	
	sub	bx,4
	jns	dn1
	mov	bx,nside4
	sub	bx,4		; point to last item
dn1:
up3:
endm

dnring	macro
	local	up2,up3,up1,dn1
	cmp	direction,0
	jz	up2
	add	bx,4
	cmp	bx,nside4
	jb	up1
	xor	bx,bx		; point back to begining if go off end
up1:
	jmp	up3
up2:	
	sub	bx,4
	jns	dn1
	mov	bx,nside4
	sub	bx,4		; point to last item
dn1:
up3:
endm


IF printflag

.proc	randpoly	auto	; makes a random polygon
	mov	ax,3		; upto 3 sides
	mov	nsides,ax
	mov	cx,ax
	mov	si,offset @dataseg:testpoly
	mov	bx,639
	call	randr_w
	mov	dx,ax
	mov	bx,349
	call	randr_w
	mov	di,ax
randplp:
	mov	bx,63
	call	randr_w
	add	ax,dx
	mov	[si],ax
	mov	bx,34
	call	randr_w
	add	ax,di
	mov	[si+2],ax
	add	si,4
	loop	randplp
	mov	si,offset @dataseg:testpoly
	ret
.endp

.proc	randlegalpoly	auto
dumlp:	call	randpoly
;	call	polylegal
;	jc	dumlp
	ret
.endp

;zzz
.proc	polylegal	auto	; returns code if poly is legal
	mov	cx,nsides	; number of sides
	or	cx,cx		; max sure nsides is pos, 
	js	polyfail1
	jz	polyfail1
	cmp	cx,20		; max number of sides
	jbe	nsidesok
polyfail1:
	stc
	ret
nsidesok:
	mov	direction,0	; go in proper direction
	mov	ax,cx		; calculate nsides*4 for ring up down traversal
	shl	ax,1
	shl	ax,1
	mov	nside4,ax	; save in variable
	xor	bx,bx		; start with begining point
polyllp:
	push	cx
	call	anglelegal
	pop	cx
	jc	polyfail1	; fail poly if bad news
	upring			; march slowly up the ring....
	loop	polyllp
	clc	
	ret
.endp

.proc	anglelegal	auto	; returns code if angle is legal
				; bx shows point in question
				; all internal angles must be less than 180 deg
;	xor	bx,bx		; start at poly 0 0 coord
	mov	ax,[si+bx]	; load x and y values
	mov	xl1,ax
	mov	ax,[si+bx+2]	; load x and y values
	mov	yl1,ax
	push	bx		; save ptr
	upring
	mov	ax,[si+bx]	; load x and y values
	sub	ax,xl1		; get delta x
	mov	xl2,ax
	mov	ax,[si+bx+2]	; load x and y values
	sub	ax,yl1		; get delta y
	mov	yl2,ax
	pop	bx
	push	bx
	dnring
	mov	ax,[si+bx]	; load x and y values
	sub	ax,xl1		; get delta x
	mov	xr2,ax
	mov	ax,[si+bx+2]	; load x and y values
	sub	ax,yl1		; get delta y
	mov	yr2,ax
	mov	ax,xl2		; get angle
	mov	dx,yl2
	push	si
	call	atn2
	pop	si
	push	ax
	mov	ax,xr2		; get angle
	mov	dx,yr2
	push	si
	call	atn2
	pop	si
	pop	dx
	mov	cx,ax
	sub	ax,dx		; this is the difference angle
	jns	angleok1
;	js	aaaaa
;	jmp	angleok1
;aaaaa:
	pop	bx
	stc
	ret
;	mov	ax,bx
;	call	wword
;	upring
;	mov	ax,bx
;	call	wword
;	mov	ax,cx
;	call	wword
;	mov	ax,dx
;	call	wword
;	call	wcr
;	push	si
;	mov	si,offset @dataseg:radvmsg
;	call	put_str
;	pop	si
;	mov	ax,xl1
;	call	wword
;	mov	ax,yl1
;	call	wword
;	mov	ax,xl2
;	call	wword
;	mov	ax,yl2
;	call	wword
;	mov	ax,xr2
;	call	wword
;	mov	ax,yr2
;	call	wword
;	call	wcr
angleok1:
	pop	bx
	clc
	ret
.endp
ENDIF

IF printflag

.proc	dotpoly	auto		; prints polygon on display
	push	si
	mov	cx,nsides
dotplp:
	call	wcr
	mov	ax,[si]	; get first x
	call	decwword
	mov	ax,[si+2]
	call	decwword
	add	si,4
	loop	dotplp
	pop	si
	ret
.endp


ENDIF

.proc	radvance	auto
; advance to next point on the ring, since we've gone as high as we can
; with this one
	mov	levelcnt,1
xfercoord1:
	mov	ax,xr2		; transfer coords
	mov	xr1,ax
	mov	argx2,ax
	mov	ax,yr2
	mov	yr1,ax		; mov coordinate to new line beg
	mov	bx,rindex
	pdnring			; march up the ring
	mov	rindex,bx	; save ring progress
	mov	ax,[si+bx]
	mov	xr2,ax		; init the starters
	mov	ax,[si+bx+2]
	mov	yr2,ax
IF polydiag EQ 1
	push	si
	mov	si,offset @dataseg:radvmsg
	call	put_str
	pop	si
	mov	ax,xr1
	call	decwword
	mov	ax,yr1
	call	decwword
	mov	ax,xr2
	call	decwword
	mov	ax,yr2
	call	decwword
	call	wcr
ENDIF
				; now check for polygon finished

	mov	bx,yr2		; now calculate delta-x
	sub	bx,yr1		; what is change in y?
	js	rdvfail	; crazy polygon, undrawable!
	jnz	posdely1
	dec	levelcnt	; if we have more that 3 points level, abort
	jns	xfercoord1	; if they are the same height, then just
				; go the the next point
	jmp	rdvfail
posdely1:
	mov	ax,xr2		; get change in x
	sub	ax,xr1
	cwd			; make into a double
	xchg	ax,dx		; with dx having the most fun

	call	divrs_dw	; divide by delta y, leave double result
	mov	rdeltaxh,dx	; save in variable
	mov	rdeltaxl,ax	; save in variable
	mov	argx2low,7fffh	; start at an average place
ldvdone1:
	clc
	ret
rdvfail:
	stc
	ret
.endp

.proc	ladvance	auto
; advance to next point on the ring, since we've gone as high as we can
; with this one
	mov	levelcnt,1
xfercoord:
	mov	ax,xl2		; transfer coords
	mov	xl1,ax
	mov	argx1,ax
	mov	ax,yl2
	mov	yl1,ax		; mov coordinate to new line beg
	mov	bx,lindex
	pupring			; march up the ring
	mov	lindex,bx	; save ring progress
	mov	ax,[si+bx]
	mov	xl2,ax		; init the starters
	mov	ax,[si+bx+2]
	mov	yl2,ax
IF polydiag EQ 1
	push	si
	mov	si,offset @dataseg:ladvmsg
	call	put_str
	pop	si
	mov	ax,xl1
	call	decwword
	mov	ax,yl1
	call	decwword
	mov	ax,xl2
	call	decwword
	mov	ax,yl2
	call	decwword
	call	wcr
ENDIF
				; now check for polygon finished
;	mov	ax,yr2		; have we arrived at end of poly?
;	cmp	yl1,ax
;	jz	ldvdone	; yes, we are done!

	mov	bx,yl2		; now calculate delta-x
	sub	bx,yl1		; what is change in y?
	js	ldvfail	; crazy polygon, undrawable!
	jnz	posdely
	dec	levelcnt	; if we have more that 3 points level, abort
	jns	xfercoord	; if they are the same height, then just
				; go the the next point
	jmp	ldvfail
posdely:

	mov	ax,xl2		; get change in x
	sub	ax,xl1
	cwd			; make into a double
	xchg	ax,dx		; with dx having the most fun

	call	divrs_dw	; divide by delta y, leave double result
	mov	ldeltaxh,dx	; save in variable
	mov	ldeltaxl,ax	; save in variable
	mov	argx1low,7fffh	; start at an average place
ldvdone:
	clc
	ret
ldvfail:
	stc
	ret
dpolyfail:
;	stc
	clc
	jmp	polydone
.endp

.proc	drawpoly	auto	; draws a polygon pointed to by [bx]
				; assumes #sides in variable nsides,
				; the color must be in variable n
	mov	polywin,si	; save window in variable
	mov	ax,[si+6]	; get ymax
	mov	polyymax,ax	; save for later
	mov	ax,[si+2]
	mov	polyymin,ax
	mov	si,bx		; call with bx 
	mov	direction,0	; 0 means upring incrs bx, dnring decrs bx
	xor	bx,bx		; init ptr
	mov	argy1,-32768
	mov	cx,nsides	; number of sides
	or	cx,cx		; max sure nsides is pos, 
	js	dpolyfail
	jz	dpolyfail
	cmp	cx,20		; max number of sides
	ja	dpolyfail
	mov	ax,cx		; calculate nsides*4 for ring up down traversal
	shl	ax,1
	shl	ax,1
	mov	nside4,ax	; save in variable
	mov	ax,32767	; find the minimum y
	mov	dx,ax		; find maximum also
	neg	dx
	
findsmlp:
	cmp	[si+bx+2],ax	; what the is smallest y?
	jg	notsmaller	; this isn't the smallest!
	mov	ax,[si+bx+2]	; make this the new smallest
	mov	lindex,bx	; now find which ring direction is left,right
notsmaller:
	cmp	[si+bx+2],dx	; what the is smallest y?
	jl	notbigg	; this isn't the smallest!
	mov	dx,[si+bx+2]	; make this the new smallest
notbigg:
	add	bx,4
	loop	findsmlp
	mov	pymax,dx	; put maximum y in variable
	mov	argy1,ax	; save minimum y in argy1
	mov	dx,80		; get start address of line in di
	imul	dx
	mov	di,ax		; save the address in di for y

;	pupring
;	mov	ax,[si+bx]	; get upring x coord
;	mov	bx,lindex	; now find which ring direction is left,right
;	pdnring
;	mov	dx,[si+bx]	; get dnring x coord
;	cmp	ax,dx		; which will be left, and which will be right?
;	jl	upsmaller	; the up the ring leads to smaller x values
;;	jz	dpolyfail	; lets not deal with edge on polys yet
;				; that leave us with up the ring going smaller
;	dec	direction	; reverse the effect of upring and dnring
;	jmp	upsmaller	; pretend all is normal
;	ret
	mov	bx,lindex	; set up bx properly
	mov	rindex,bx	; now find which ring direction is left,right
upsmaller:
	mov	bx,lindex
	mov	ax,[si+bx]	; init the starters
	mov	xl2,ax
	mov	argx1,ax
	mov	argx2,ax
	mov	ax,[si+bx+2]
	mov	yl2,ax
	call	ladvance	; get slope and stuff for left side line
pfail2:	jc	dpolyfail1
	mov	bx,rindex
	mov	ax,[si+bx]	; init the starters
	mov	xr2,ax
	mov	ax,[si+bx+2]
	mov	yr2,ax

	call	radvance	; get slope and stuff for right side line
	jc	dpolyfail1
IF polydiag EQ 0
	mov	dx,3ceh		; dx := graphics controller port addr
	mov	ah,n		; write zero to this bit
	cmp	ah,15		; do we make a screen?
	jbe	normalcolor	; yes
	and	ah,15
	call	rand_w
	and	al,55h
	mov	ah,al
	mov	hlinemask,al
	mov	bhlinemask,ax
normalcolor:	
	xor	al,al
	out	dx,ax		; put color selection in set/reset reg
	mov	ax,0f01h
	out	dx,ax		; put 0fh in bit plane enable
	mov	ah,0		; no rotate, no xor
	mov	al,3
	out	dx,ax		; 0 for the RWM bits of the ALU
	mov	ax,0305h	; write mode 3 select, read mode 0
	out	dx,ax
	mov	ax,0a000h
	mov	es,ax
ENDIF

biggerloop:
	mov	ax,argy1	
	cmp	yl2,ax
	jg	nobigdeal	; no, but check other side

; advance to next point on the ring, since we've gone as high as we can
; with this one
	call	ladvance
	jnc	advok
dpolyfail1:
;	stc
	clc
	jmp	polydone
advok:
;	mov	ax,yr2		; have we arrived at end of poly?
;	cmp	yl1,ax
;	clc			; get ready to leave nice flag
;	jz	polydone1
	mov	ax,yl1
	cmp	pymax,ax
	clc
	jle	polydone1	; yes, we are done!

nobigdeal:
	mov	ax,argy1	
	cmp	yr2,ax		; is this point exhausted?
	jg	nobigdeal1	; no, but check other side
	call	radvance
	jc	dpolyfail1
nobigdeal1:
	mov	ax,argy1	
;	or	ax,ax		; if argy1 is neg, skip whole business
	cmp	ax,polyymin
;	js	skipdrwl
	jl	skipahead	; go ahead by leaps and bounds
	cmp	ax,polyymax	; if greater than screen, skip
	jl	noabovedone	; if we are already out of the window, abort
	clc			; say no error
	jmp	polydone
noabovedone:
	mov	ax,argy1
	cmp	ax,polyymin
;	or	ax,ax		; if di negative, skip the line
	jl	skipdrwl
;	mov	ax,argx1
;	sub	ax,argx2	; if zero size, do at least on pt
;	jnz	nonzhline	; it's already non-zero
;	inc	argx2		; make it a non-zero line
;nonzhline:
	cmp	hlinemask,-1
	jz	leavenice
	and	ah,15
	call	rand_w
	and	al,55h
	mov	ah,al
	mov	hlinemask,al
	mov	bhlinemask,ax
leavenice:



	push	di		; save di
IF polydiag EQ 0
	push	si
	mov	si,polywin	; load window info for the line drawer
	call	rawhlinewin	; draw the line on the video
	pop	si
ENDIF
	pop	di
skipdrwl:
	add	di,bpl		; advance to next line
	inc	argy1		; admit advancing to the next line
	mov	ax,ldeltaxl	; advance endpoints of right and left lines
	add	argx1low,ax
	mov	ax,ldeltaxh
	adc	argx1,ax

	mov	ax,rdeltaxl	; advance endpoints of right and left lines
	add	argx2low,ax
	mov	ax,rdeltaxh
	adc	argx2,ax

IF polydiag EQ 1

	mov	ax,argy1
	call	decwword
	mov	ax,argx1
	call	decwword
	mov	ax,argx2
	call	decwword
	call	wcr
ENDIF
	
	jmp	biggerloop


polydone:	
	clc
polydone1:
IF polydiag EQ 0
	mov	dx,3ceh		; dx := graphics controller port addr
	mov	ax,5
	out	dx,ax		; write mode 0
	xor	ax,ax
	out	dx,ax
	mov	hlinemask,-1
	mov	bhlinemask,-1
ENDIF
	ret			; 

skipahead:
IF polydiag EQ 1
	call	wcr
	call	decwword
	mov	ax,polyymin
	call	decwword
	mov	ax,yl2		; chose closer destination to skip to
	call	decwword
	mov	ax,yr2
	call	decwword
ENDIF
	mov	ax,yl2		; chose closer destination to skip to
	cmp	ax,yr2		; 
	jle	l2smaller	; leave smaller in ax?
	mov	ax,yr2
	cmp	ax,polyymin
	jle	notadv1
	jmp	advboth		; no, then advance both to border
notadv1:
	call	radvance	; so skip to the next right point
	jc	polydone	; abort if error
	mov	ax,yr1
	cmp	pymax,ax
	clc
	jle	polydone1	; yes, we are done!
	mov	ax,xr1
	mov	argx2,ax	; update present right side

	mov	bx,yr1		; get our new present y value
	mov	ax,argy1	; get argy1 before we nuke it
	mov	argy1,bx	; advance naked y
	sub	bx,ax	; get y distance to advance y line
	js	polydone	; look for failure
	mov	dx,ldeltaxh	; do this by multiplying delta
	mov	ax,ldeltaxl	; by this distance
	.muls_dw	bx,cx	; do a dword multiplication
	add	argx1low,ax	; apply to argx1
	adc	argx1,dx
	jmp	skipadone	; we are done!
polydone3:	jmp	polydone2
l2smaller:
	mov	ax,yl2
	cmp	ax,polyymin
	jg	advboth		; no, then advance both to border
	call	ladvance	; so skip to the next right point
	jc	polydone3	; abort if error
	mov	ax,yl1
	cmp	pymax,ax
	clc
	jle	polydone3	; yes, we are done!
	mov	ax,xl1
	mov	argx1,ax	; update present right side

	mov	bx,yl1		; get our new present y value
	mov	ax,argy1	; get argy1 before we nuke it
	mov	argy1,bx	; advance naked y
	sub	bx,ax	; get y distance to advance y line
	js	polydone2	; look for failure
	mov	dx,rdeltaxh	; do this by multiplying delta
	mov	ax,rdeltaxl	; by this distance
	.muls_dw	bx,cx	; do a dword multiplication
	add	argx2low,ax	; apply to argx1
	adc	argx2,dx
	jmp	skipadone	; we are done!
advboth:
	mov	bx,polyymin
	sub	bx,argy1	; get distance to y
	js	skipadone	; abort if it was somehow positive
	mov	ax,polyymin	; bring it up to snuff
	mov	argy1,ax	; bring us right up to speed
	push	bx		; save for other one
	mov	dx,ldeltaxh	; do this by multiplying delta
	mov	ax,ldeltaxl	; by this distance
	.muls_dw	bx,cx	; do a dword multiplication
	add	argx1low,ax	; apply to argx1
	adc	argx1,dx
	pop	bx		; restore for other side
	mov	dx,rdeltaxh	; do this by multiplying delta
	mov	ax,rdeltaxl	; by this distance
	.muls_dw	bx,cx	; do a dword multiplication
	add	argx2low,ax	; apply to argx1
	adc	argx2,dx
skipadone:
	mov	ax,argy1	; save minimum y in argy1
	mov	dx,80		; get start address of line in di
	imul	dx
	mov	di,ax		; save the address in di for y
	jmp	noabovedone	; jump right back into code above
polydone2:
	stc
	ret	
.endp


.proc	drawdisc	auto		; draws a damn disc
	mov	bx,yc			; check out possibilities
	mov	ax,xw
	cmp	ax,1024			; make x size allowed today
	jl	ddlm2
	mov	ax,1023
ddlm2:
	push	ax
	mov	dx,45397		; has to do with aspect ratio
	mul	dx
	mov	yw,dx			; set actual y size
	pop	ax
	sar	dx,1			; divide diameter by 2
	sub	bx,dx
	cmp	bx,[si+6]		; see if no way sphere can be drawn
	jg	ddbag
	mov	bx,yc
	add	bx,dx
	cmp	bx,[si+2]
	jl	ddbag
	or	ax,ax			; check size
	jns	ddlm1			; do bounds check
ddbag:	ret
ddbagp:	
	jmp	ddbagp1
ddlm1:
	cmp	ax,17
	jns	ddl0
	jmp	smldisc			; if small, go to small code
ddl0:	
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	mov	dx,3ceh		; dx := graphics controller port addr
	mov	ah,n
	xor	al,al
	out	dx,ax		; put color selection in set/reset reg
	mov	ax,0f01h
	out	dx,ax		; put 0fh in bit plane enable
	mov	ah,0
	mov	al,3
	out	dx,ax		; 0 for the RWM bits of the ALU
	mov	ax,0305h	; write mode 3 select
	out	dx,ax
	ENDIF	
	mov	ax,yc		; get basic di address
;	mov	bx,0		;
;	pixadd			; get bx with proper value
;	mov	cx,ax		; multiply y by 80
;	shl	ax,1		; mult by 4
;	shl	ax,1		; mult by 4
;	add	ax,cx		; not it's by 5
;	mov	cl,4		; now by 16
;	shl	ax,cl
;	add	bx,ax		; add in y offset
	mov	dx,bpl		; do signed multiply
	imul	dx
	mov	bx,ax		; leave result in bx
	.abs_d	dx,ax
	or	dx,dx
	jnz	ddbagp		; sph ctr tooo far away
	or	tempsum,ax	; fakey fakey
	mov	ax,vgseg	; load es with proper segment
	mov	es,ax

	mov	yline,bx	; put in variables
	mov	tyline,bx	; put in variables

	mov	bx,xw			; set up a mult
;	inc	bx
	mov	dx,2936			; now we calculate ysf
	xor	ax,ax
	call	div_dw			; ysf=2048/(yw+1)
	mov	ysfl,ax			; save in double variable
	mov	ysfh,dx
	mov	cx,4			; now mult by 32 for x calcs
dsl1:	shl	ax,1
	rcl	dx,1
	loop	dsl1
	mov	ysfig,dx		; save  for later
	mov	ax,xw			; write out first line
	mov	bx,ax			; make copy
	shr	ax,1			; do the rigamorole
	inc	bx
	shr	bx,1
	add	bx,xc
	neg	ax
	add	ax,xc			; get x coords of center line
	mov	argx1,ax
	inc	bx			; make up for n-1 line problem
	mov	argx2,bx
	IF (vgmode EQ 81h)
	mov	ax,yc			; get y coord of center
	mov	argy1,ax
	mov	argy2,ax
	mov	y_up,ax
	mov	y_down,ax
	call	clip
	call	hgcline
	ENDIF
;	mov	yline,ax
;	mov	tyline,ax
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	mov	di,yline		; set up start address
	call	rawhlinewin			; draw center line
	ENDIF
	xor	ax,ax			; prepare for awesome loop
	push	ax
	push	ax			; start with variable =0
	mov	cx,yw			; get bumber of lines
	inc	cx			; to go in the downward direction
	shr	cx,1
	jz	cbtlpd			; ctr line already drawn. 
cbtlp:	
	pop	ax			; get scaled y coord rel to center
	pop	dx
	add	ax,ysfl			; move down by 1 notch
	adc	dx,ysfh			; 32bit add for dramaticks
	push	dx
	push	ax
;	shl	ax,1			; round ax value
;	adc	dx,0
	mov	di,yline
	add	di,bpl
	cmp	di,[si+22]		; are we less than the max?
	jl	ylnok			; yes, then continue on
	sub	di,bpl
ylnok:
	IF (vgmode EQ 81h)
	dec	y_up
	inc	y_down
	ENDIF
;	inc	ax
	mov	yline,di
;	mov	argy1,ax
;	mov	argy2,ax
	mov	ax,dx			; only the high word matters
;	call	wword
;	call	wcr
	push	si
	call	csqrt			; xlate this to x
	pop	si
	push	cx
	mov	cl,5			; mult by 32
	shl	ax,cl
	mov	bx,ysfig		; get pre-multed ysf
	xor	dx,dx
	div	bx			; xlate scale to our scale
;	sub	dx,bx
;	jns	dls2
;	inc	ax			; round value
;dls2:
	push	ax			; now do the n, n+1 dance
	inc	ax
	shr	ax,1
	add	ax,xc
	inc	ax			; make up for early end of line
	mov	argx2,ax		; set up right coord
	pop	ax			; now do left coord
	shr	ax,1			; note no inc ax before this one
	neg	ax
	add	ax,xc			; finalize the left x coord
	mov	argx1,ax
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	call	rawhlinewin			; finally write the darn line!
	ENDIF
	IF (vgmode EQ 81h)
	mov	ax,y_up			; get y coord of center
	mov	argy1,ax
	mov	argy2,ax
	call	clip
	call	hgcline
	ENDIF
	mov	di,tyline
;	dec	ax
	sub	di,bpl
	jns	tylnok
	add	di,bpl
tylnok:
	mov	tyline,di
;	mov	argy1,ax
;	mov	argy2,ax
	IF (vgmode EQ 81h)
	mov	ax,y_down		; get y coord of center
	mov	argy1,ax
	mov	argy2,ax
	call	clip
	call	hgcline
	ENDIF
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	call	rawhlinewin			; finally write the darn line!
	ENDIF
	pop	cx
	loop	cbtlp			; do another line
cbtlpd:	pop	ax
	pop	ax			; bag two useless items
ddbagp1:
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	mov	dx,3ceh		; dx := graphics controller port addr
	mov	ax,5
	out	dx,ax		; write mode 0
	xor	ax,ax
	out	dx,ax
	inc	ax
	out	dx,ax
	ENDIF
	clc			; give no error flag
smlbag:	ret

smldisc:
	mov	ax,yc		; set up for correct pixel address
	mov	bx,xc
	cmp	bx,[si]		; see if in window
	js	smlbag		; out of window, forget disc
	cmp	bx,[si+4]
	jns	smlbag
	cmp	ax,[si+2]
	js	smlbag
	cmp	ax,[si+6]
	jns	smlbag
	pixadd
smld1:
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	mov	dx,3ceh		; dx := graphics controller port addr
	mov	ah,n
	xor	al,al
	out	dx,ax		; put color selection in set/reset reg
	mov	ax,0f01h
	out	dx,ax		; put 0fh in bit plane enable
	mov	ah,0
	mov	al,3
	out	dx,ax		; 0 for the RWM bits of the ALU
	mov	ax,0305h	; write mode 3 select
	out	dx,ax
	ENDIF
	IF vgmode EQ 81h
	push	bx
	push	ax
	push	dx
	mov	al,n
	xor	ah,ah
	mov	bx,offset @dataseg:bkclrs
	xlat
	mov	bkbits,al
	pop	dx
	pop	ax
	pop	bx
	ENDIF
	dec	bx		; start back 1 byte assume not left edge
	mov	di,bx		; of screen
	xor	ch,ch		; convert cx to properness
	neg	cx
	add	cx,7
	mov	nbits,cx	; and store
	mov	bx,xw		; now use number of x bits to examine
				; table
	shl	bx,1
	add	bx,offset @dataseg:cirtbl
;	mov	bx,5555h
;	mov	bx,offset @dataseg:cirtbl
	mov	si,[bx]	; get address of table
;	mov	si,offset @dataseg:cir0
	mov	cx,[si]		; get vertical size count
	mov	ax,cx
;	call	wword
	add	si,2		; incr pointer
ddl6:	mov	bx,[si]		; get offset into bx
	mov	ax,[si+2]
	add	si,4
	xor	dx,dx		; prepare for shifting operation
	push	cx
	mov	cx,nbits	; save cx, and replace cx with nbits
	or	cx,cx		; verify cx not zero
	jz	ddl7
ddl8:	shr	ax,1		; shift bit mask to line up with xc
	rcr	dx,1		; copy bits into dh
	loop	ddl8
ddl7:	pop	cx
	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)
	xchg	es:[di+bx],ah	; write 3 bytes of data
	xchg	es:[di+bx+1],al	; write 3 bytes of data
	xchg	es:[di+bx+2],dh	; write 3 bytes of data
	ENDIF
	IF vgmode EQ 81h
	not	ah		; clear out writable bits
	and	es:[di+bx],ah
	not	ah
	and	ah,bkbits
	or	es:[di+bx],ah
	not	al		; clear out writable bits
	and	es:[di+bx+1],al
	not	al
	and	al,bkbits
	or	es:[di+bx+1],al
	not	dh		; clear out writable bits
	and	es:[di+bx+2],dh
	not	dh
	and	dh,bkbits
	or	es:[di+bx+2],dh
	ENDIF
	loop	ddl6


	IF (vgmode EQ 10h) OR (vgmode EQ 0dh)

	mov	dx,3ceh		; dx := graphics controller port addr
	mov	ax,5
	out	dx,ax		; write mode 0
	xor	ax,ax
	out	dx,ax
	inc	ax
	out	dx,ax
	ENDIF
	ret

.endp

.proc	srel3d	auto		; this proc will find the rel xyz
				; coords pted to by es:[si], relative
				; to ox,oy,oz double observer coords
				; cx has out of bounds information
				; si is NOT conserved
	mov	di,offset dxvec	; load address for destination coords
	cld			; clear direction flag
	mov	ax,es:[si]		; get low part
	mov	dx,ax
	mov	ax,es:[si+2]
	.subs_dd	ax,dx,ox+2,ox	; find relative double x
	mov	dl,dh
	mov	dh,al
	mov	al,ah
	cbw 			; divide by 256 and get sign right
	mov	[di],dx		; write low part out
	mov	[di+2],ax
	.abs_d	ax,dx		; save high part
	shl	dx,1		; this is a silly sign thing!
	rcl	ax,1		; it is to isolate the sign bit
	mov	cx,ax		; IE, 65535 is NOT a good x coord!
	mov	ax,es:[si+4]			; get low part
	mov	dx,ax
	mov	ax,es:[si+6]
	.subs_dd	ax,dx,oy+2,oy	; find relative double x
	mov	dl,dh
	mov	dh,al
	mov	al,ah
	cbw 			; divide by 256 and get sign right
	mov	[di+4],dx		; write low part out
	mov	[di+6],ax
	.abs_d	ax,dx		; save high part
	shl	dx,1		; this is a silly sign thing!
	rcl	ax,1		; it is to isolate the sign bit
	or	cx,ax		; IE, 65535 is NOT a good x coord!
	mov	ax,es:[si+8]	; get low part
	mov	dx,ax
	mov	ax,es:[si+10]
	.subs_dd	ax,dx,oz+2,oz	; find relative double x
	mov	dl,dh
	mov	dh,al
	mov	al,ah
	cbw 			; divide by 256 and get sign right
	mov	[di+8],dx		; write low part out
	mov	[di+10],ax
	.abs_d	ax,dx		; save high part
	shl	dx,1		; this is a silly sign thing!
	rcl	ax,1		; it is to isolate the sign bit
	or	cx,ax		; IE, 65535 is NOT a good x coord!
	ret
.endp	

.proc	grel3d	auto		; this proc will find the rel xyz
				; coords pted to by es:[si], relative
				; to ox,oy,oz double observer coords
				; cx has out of bounds information
				; si is NOT conserved
	mov	di,offset dxvec	; load address for destination coords
	cld			; clear direction flag
	mov	ax,es:[si]		; get low part
	mov	dx,ax
	mov	ax,es:[si+2]
	.subs_dd	ax,dx,ox+2,ox	; find relative double x
	mov	[di],dx		; write low part out
	mov	[di+2],ax
	.abs_d	ax,dx		; save high part
	shl	dx,1		; this is a silly sign thing!
	rcl	ax,1		; it is to isolate the sign bit
	mov	cx,ax		; IE, 65535 is NOT a good x coord!
	mov	ax,es:[si+4]			; get low part
	mov	dx,ax
	mov	ax,es:[si+6]
	.subs_dd	ax,dx,oy+2,oy	; find relative double x
	mov	[di+4],dx		; write low part out
	mov	[di+6],ax
	.abs_d	ax,dx		; save high part
	shl	dx,1		; this is a silly sign thing!
	rcl	ax,1		; it is to isolate the sign bit
	or	cx,ax		; IE, 65535 is NOT a good x coord!
	mov	ax,es:[si+8]	; get low part
	mov	dx,ax
	mov	ax,es:[si+10]
	.subs_dd	ax,dx,oz+2,oz	; find relative double x
	mov	[di+8],dx		; write low part out
	mov	[di+10],ax
	.abs_d	ax,dx		; save high part
	shl	dx,1		; this is a silly sign thing!
	rcl	ax,1		; it is to isolate the sign bit
	or	cx,ax		; IE, 65535 is NOT a good x coord!
	ret
.endp	

;.proc	dwword	auto
;	push	ax
;	mov	ax,dx
;	call	wword
;	pop	ax
;	call	wword
;	ret
;.endp


.proc	g3dobj	auto	; evaluates the distance for the dots
	mov	ax,es:[si+12]	; get fixed flag
	mov	xtemp,ax
	jnc	normgndpt
	call	srel3d
	jmp	normspt
normgndpt:
	call	grel3d		; 
normspt:
;	mov	ax,dxvec
;	mov	dx,dxvec+2
;	call	dwword
;	mov	ax,dxvec+4
;	mov	dx,dxvec+6
;	call	dwword
;	mov	ax,dxvec+8
;	mov	dx,dxvec+10
;	call	dwword
;	call	wcr
;	call	exit_ok
	or	ch,ch		; see if way far away
	jnz	gdistl0
	test	cl,0f0h		; are we medium far?
	jz	qmedf		; maybe medium far
	mov	rdf,8		; so it looks like we have rdf=8
	mov	si,offset dxvec	; get vector
	mov	ax,ds		; set up segment
	mov	es,ax
	lodsw
	mov	dl,ah
	lodsw	
	mov	dh,al		; get dxvec/8
	sar	dx,1
	mov	xvec,dx		; save in xvec, which will be our 3d coord
	lodsw
	mov	dl,ah
	lodsw	
	mov	dh,al		; get dxvec/8
	sar	dx,1
	mov	xvec+2,dx	; save in xvec, which will be our 3d coord
	lodsw
	mov	dl,ah
	lodsw	
	mov	dh,al		; get dxvec/8
	sar	dx,1
	mov	xvec+4,dx	; save in xvec, which will be our 3d coord
g3dlb1:	mov	ax,offset tmpvec
	mov	objptr,ax	; dumb temporary vector
	mov	si,offset xvec	; prepare for rotation
;	mov	ax,[si]
;	call	wword
;	mov	ax,[si+2]
;	call	wword
;	mov	ax,[si+4]
;	call	wword
;	call	wcr
;	call	exit_ok
	call	gnrlrot		; rotate that darn little vector
	mov	al,gndcolor	; set color
	mov	n,al
	mov	si,objptr
	mov	bx,ptrgwinf	; forward view window
	cmp	xtemp,0
	jz	frntv
	call	viewpt		; make a point on the display
	ret
frntv:	call	f3dpt
	ret
gdistl0:	
	stc
	ret
qclosef:
	jmp	qclsf
qmedf:
	test	cl,0fh		; are we medium far?
	jz	qclosef		; maybe medium far
	mov	rdf,4		; reduction factor equals four!
	mov	si,offset dxvec	; get vector
	mov	ax,ds
	mov	es,ax
	lodsw
	mov	dx,ax		; get dxvec/4
	lodsw	
	rept	4
	rcr	ax,1
	rcr	dx,1
	endm
	sar	dx,1
	mov	xvec,dx		; save in xvec, which will be our 3d coord
	lodsw
	mov	dx,ax		; get dxvec/4
	lodsw	
	rept	4
	rcr	ax,1
	rcr	dx,1
	endm
	sar	dx,1
	mov	xvec+2,dx	; save in xvec, which will be our 3d coord
	lodsw
	mov	dx,ax		; get dxvec/4
	lodsw	
	rept	4
	rcr	ax,1
	rcr	dx,1
	endm
	sar	dx,1
	mov	xvec+4,dx	; save in xvec, which will be our 3d coord
	jmp	g3dlb1
qclsf:
	mov	si, offset dxvec	; point to the magic vector
	mov	ax,[si]
	sar	ax,1
	mov	xvec,ax
	mov	ax,[si+4]
	sar	ax,1
	mov	xvec+2,ax
	mov	ax,[si+8]
	sar	ax,1
	mov	xvec+4,ax
	jmp	g3dlb1
.endp

.proc	relobj5d	auto		; this proc find relative xyz coords
				; obj pted to by [si], carry shows out of 
				; bounds, ch has medium range status
	mov	ax,ds		; set up segment for stosw
	mov	es,ax
	mov	di,offset @dataseg:dxvec
	mov	ax,[si]		; get object position
	mov	dx,[si+2]
	.subs_dd dx,ax,obj5d+2,obj5d	; find the relative x coord i
	stosw			; save low order word or rel position
	xchg	ax,dx
	stosw			; save high part
	.abs_d	ax,dx
	shl	dx,1
	rcl	ax,1		; shift up so we can see the sign bit
	mov	cx,ax
	mov	ax,[si+4]		; get object position
	mov	dx,[si+6]
	.subs_dd dx,ax,obj5d+6,obj5d+4	; find the relative x coo
	stosw			; save low order word or rel position
	xchg	ax,dx
	stosw			; save high part
	.abs_d	ax,dx
	shl	dx,1
	rcl	ax,1		; shift up so we can see the sign bit
	or	cx,ax
	mov	ax,[si+8]		; get object position
	mov	dx,[si+0ah]
	.subs_dd dx,ax,obj5d+10,obj5d+8	; find the relative 
	stosw			; save low order word or rel position
	xchg	ax,dx
	stosw			; save high part
	.abs_d	ax,dx
	shl	dx,1
	rcl	ax,1		; shift up so we can see the sign bit
	or	cx,ax
	clc			; show that object is in range
	ret
obj5fl:	stc
	ret			; fail call, object too far away
	.endp


.proc	reducedword	auto	; reduces dword in [si] by factor in bx,
				;  and leaves
				; result in [si], 4 scrap locations needed 
				; in [di]
	mov	ax,[si+2]
	mov	[di+2],ax
	cwd
	mov	[di+4],dx
	mov	[di+6],dx
	mov	ax,[si]
	mov	[di],ax
	call	muls_qw
	mov	dx,[di+4]
	mov	ax,[di+2]
	push	dx
	shl	ax,1
	rcl	dx,1
	mov	[si],ax
	mov	[si+2],dx
	pop	dx
	.abs_w	dx
	or	cx,dx
	ret
.endp

.proc	reducecoords	auto	; reduces the doubleword vector dxvec by
				; the scalefactor in z0factor
				; leave cx with or'ed high parts
	push	di
	push	si
	mov	di, offset @dataseg:cbuf
	mov	si, offset @dataseg:dxvec
	mov	bx,z0factor
	xor	cx,cx
	call	reducedword
	add	si,4
	call	reducedword
	add	si,4
	call	reducedword
	pop	si
	pop	di
	ret
.endp

.proc	rel3d	auto		; this proc find relative xyz coords
				; obj pted to by [si], carry shows out of 
				; bounds, ch has medium range status
	mov	ax,ds		; set up segment for stosw
	mov	es,ax
	mov	di,offset @dataseg:dxvec
	mov	ax,[si]		; get object position
	mov	dx,[si+2]
	.subs_dd dx,ax,ox+2,ox	; find the relative x coord in double format
	stosw			; save low order word or rel position
	xchg	ax,dx
	stosw			; save high part
	.abs_d	ax,dx
	shl	dx,1
	rcl	ax,1		; shift up so we can see the sign bit
	mov	cx,ax
edgl1:	mov	ax,[si+4]		; get object position
	mov	dx,[si+6]
	.subs_dd dx,ax,oy+2,oy	; find the relative x coord in double format
	stosw			; save low order word or rel position
	xchg	ax,dx
	stosw			; save high part
	.abs_d	ax,dx
	shl	dx,1
	rcl	ax,1		; shift up so we can see the sign bit
	or	cx,ax
edgl2:	mov	ax,[si+8]		; get object position
	mov	dx,[si+0ah]
	.subs_dd dx,ax,oz+2,oz	; find the relative x coord in double format
	stosw			; save low order word or rel position
	xchg	ax,dx
	stosw			; save high part
	.abs_d	ax,dx
	shl	dx,1
	rcl	ax,1		; shift up so we can see the sign bit
	or	cx,ax
edgl3:	
	mov	bx,z0
	cmp	bx,0		; should we limit appearant distance?
	jz	nodistancelim
;	mov	cs:cecode,45
	mov	ax,dxvec+10	; get high part of z distance
	neg	ax		; only consider objects below us
	js	nodistancelim	;
;	mov	cs:cecode,46
	cmp	ax,bx		; are we higher than z0?
	jbe	nodistancelim	; no
;	mov	cs:cecode,47
	mov	dx,dxvec+10
	mov	ax,dxvec+8
	.abs_d	dx,ax
rept	4
	shl	ax,1
	rcl	dx,1
	shl	bx,1
endm
	cmp	dx,bx
	jbe	nodistancelim
;	mov	cs:cecode,48
	xchg	dx,bx
	xor	ax,ax
	div	bx		; divide double by our little bx
	shr	ax,1		; divide by two to make into signed 0-.999 #
	mov	z0factor,ax	; save mult factor
	call	reducecoords	; reduce the coords in dxvec by sf
;	mov	cs:cecode,49
nodistancelim:
	clc			; show that object is in range
	ret
	.endp

.proc	relrot	auto		; Rotates center of object by the observers
				; viewing angles in orot matrix
				; si points to 3dobj
	push	si
	lea	bx,[si+0ch]	; get pointer to angles of internal rotation
	call	calcsin		; prepare to generate object rotation mat
	IF qmul
	mov	si,offset @dataseg:tmat
	ELSE	
	mov	si,offset @dataseg:omat
	ENDIF
	call	ncalcmat		; calculate matrix
	mov	di,objptr	; get pointer to object origin coords
;	mov	bx,offset @dataseg:orot		; matrix of observer
	mov	bx,orotptr			; just in case observer isn't
						; looking forward
	mov	si,offset @dataseg:xvec		; get coords to rotate
	call	matvmul		; rotate them
	IF	qmul
	call	matmul
	ENDIF
	pop	si		; restore pointer
	ret
	.endp

.proc	gnrlrot	auto		; Rotates center of object by the observers
				; viewing angles in orot matrix
				; si points to 3dobj
				; as above, but here no internal rotation 
				; wanted
	push	si
	mov	di,objptr	; get pointer to object origin coords
;	mov	bx,offset @dataseg:orot		; matrix of observer
	mov	bx,orotptr			; just in case observer isn't
						; looking forward
	mov	si,offset @dataseg:xvec		; get coords to rotate
	call	pmvmul		; rotate them
	pop	si		; restore pointer
	ret
	.endp

.proc	nrelrot	auto		; Rotates center of object by the observers
				; viewing angles in orot matrix
				; si points to 3dobj
				; as above, but here no internal rotation 
				; wanted
	push	si
	mov	di,offset @dataseg:omat		; no rotation, so just pass
						; orot to omat
	mov	ax,ds				; set up boring segment
	mov	es,ax
	cld
	mov	si,offset @dataseg:orot
	mov	cx,9
	rep	movsw		; mov matrix
	mov	di,objptr	; get pointer to object origin coords
;	mov	bx,offset @dataseg:orot		; matrix of observer
	mov	bx,orotptr			; just in case observer isn't
						; looking forward
	mov	si,offset @dataseg:xvec		; get coords to rotate
	call	matvmul		; rotate them
	pop	si		; restore pointer
	ret
	.endp

.proc	drawdirect	auto	; draws a object on the screen directly,
				; without putting the object in 3 space
				; si hold address of drawing, IE sunobj
				; dx holds the window address
				; xvec must be set to the desired coords
				; in the sun's case, 0,0,500
	mov	objptr,si	; save si for nrelrot
	call	nrelrot		; rotate the coords, and set up omat
;	mov	dx,cwin		; set up registers for drrobj call
;	mov	si,objptr	; point to object shape
	mov	bx,offset @dataseg:omat		; pt to local rotation
	call	drrobj		; draw the object on the screen
	ret
.endp

.proc	drawrdirect	auto	; draws a object on the screen directly,
				; without putting the object in 3 space
				; si hold address of drawing, IE sunobj
				; dx holds the window address
				; xvec must be set to the desired coords
				; in the sun's case, 0,0,500
	mov	rdf,0		; assume object is close
	push	si		; save correct si for rotation
	add	si,40		; point to near shape
	mov	ax,[si]
	mov	objptr,ax	; save si for nrelrot
	pop	si
	call	relrot		; rotate the coords, and set up omat
;	mov	dx,cwin		; set up registers for drrobj call
	mov	si,objptr
	mov	bx,offset @dataseg:omat		; pt to local rotation
	call	drrobj		; draw the object on the screen
	ret
.endp


.proc	matmul	auto		; multiplies two matrices
	mov	si,offset @dataseg:tmat		; now multiply matrices
	mov	di,offset @dataseg:omat
;	mov	bx,offset @dataseg:orot		; matrix of observer
	mov	bx,orotptr			; just in case observer isn't
						; looking forward
	call	mat2mul
;	mov	bx,offset @dataseg:orot		; matrix of observer
	mov	bx,orotptr			; just in case observer isn't
						; looking forward
	sub	di,10
	add	si,2
	call	mat2mul
;	mov	bx,offset @dataseg:orot		; matrix of observer
	mov	bx,orotptr			; just in case observer isn't
						; looking forward
	add	si,2
	sub	di,10
	call	mat2mul
	ret
	.endp

IF 1 EQ 0
.proc	matdet	auto		; calculates the determinant of a matrix
	xor	cx,cx		; sum
	mov	det,cx
	mmul	[bx+08],[bx+16]
	mov	cx,dx
	mmul	[bx+14],[bx+10]
	sub	cx,dx
	mmul	[bx+00],cx
	add	det,dx
	mmul	[bx+06],[bx+16]
	mov	cx,dx
	mmul	[bx+12],[bx+10]
	sub	cx,dx
	mmul	[bx+02],cx
	sub	det,dx
	mmul	[bx+06],[bx+14]
	mov	cx,dx
	mmul	[bx+12],[bx+08]
	sub	cx,dx
	mmul	[bx+04],cx
	add	det,dx
	ret
.endp
ENDIF

.proc	disteval	auto	; evaluates distance from origin
	call	rel3d		; fill dxvec with data, and cx with range
				; bits
	or	ch,ch		; see if high order bits set
	jz	notfar		; not too far...
	mov	byte ptr [si+18],3	; leave code for way far, man
	stc
	ret
notfar:	test	cl,0f0h		; test higher order bits of cl
	jz	nomfar		; these are zero too? must be closer...
	mov	byte ptr [si+18],2	; leave code for med-far
	mov	dx,dxvec+2	; load up on data
	mov	ax,dxvec
	mov	al,ah		; now rotate by 8 bits
	mov	ah,dl
	.abs_w	ax		; take absolute value
	mul	ax		; square
	mov	[si+20],ax	; put result into distance
	mov	[si+22],dx
	mov	dx,dxvec+6	; load up on data
	mov	ax,dxvec+4
	mov	al,ah		; now rotate by 8 bits
	mov	ah,dl
	.abs_w	ax		; take absolute value
	mul	ax		; square
	add	[si+20],ax	; put result into distance
	adc	[si+22],dx
	mov	dx,dxvec+10	; load up on data
	mov	ax,dxvec+8
	mov	al,ah		; now rotate by 8 bits
	mov	ah,dl
	.abs_w	ax		; take absolute value
	mul	ax		; square
	add	[si+20],ax	; put result into distance
	adc	[si+22],dx
	clc
	ret
nomfar:	cmp	cl,0		; see if whole byte zero,
	jz	qnear		; maybe actually near.
	mov	byte ptr [si+18],1
	mov	dx,dxvec+2	; load up on data
	mov	ax,dxvec
	rept	4
	  shr	dx,1
	  rcr	ax,1
	endm
	.abs_w	ax		; take absolute value
	mul	ax		; square
	mov	[si+20],ax	; put result into distance
	mov	[si+22],dx
	mov	dx,dxvec+6	; load up on data
	mov	ax,dxvec+4
	rept	4
	  shr	dx,1
	  rcr	ax,1
	endm
	.abs_w	ax		; take absolute value
	mul	ax		; square
	add	[si+20],ax	; put result into distance
	adc	[si+22],dx
	mov	dx,dxvec+10	; load up on data
	mov	ax,dxvec+8
	rept	4
	  shr	dx,1
	  rcr	ax,1
	endm
	.abs_w	ax		; take absolute value
	mul	ax		; square
	add	[si+20],ax	; put result into distance
	adc	[si+22],dx
	clc
	ret
qnear:	mov	byte ptr [si+18],0	; it's theoretically near
	mov	ax,dxvec
	.abs_w	ax
	mul	ax
	mov	[si+20],ax
	mov	word ptr [si+22],dx
	mov	ax,dxvec+4
	.abs_w	ax
	mul	ax
	add	[si+20],ax
	adc	word ptr [si+22],dx
	mov	ax,dxvec+8
	.abs_w	ax
	mul	ax
	add	[si+20],ax
	adc	word ptr [si+22],dx
	clc	
	ret
.endp


.proc	d3dobj	auto		; draw a 3d object
				; takes [si] as pointer to 3dobj data strut
				; and dx has window address info
	mov	ax,[si+24]	; get object type code
	or	ax,ax		; set flags
	jnz	obalv		; object alive and well
	or	tempsum,ax	; fake some activity for the object
	ret
obalv:
	mov	cwin,dx		; save window in ram loc
	call	disteval	; get coords relative to viewer coords
	jc	d3fl		; abort if too far away
	cmp	byte ptr [si+18],0	; see if object is not near
	jz	d3dlb0
	jmp	d3md		; jmp to medium distance code
d3dlb2:	jmp	fd3md
d3dlb0:	
	mov	dx,[si+22]	; get distance into registers
	mov	ax,[si+20]
	.cmp_dd	dx,ax,[si+30],[si+28]	; compare to near bkpt
	ja	d3dlb2		; if too large a dist, then do medium algo
d3dlb1:	mov	rdf,0		; clear the long distance flag
	mov	ax,dxvec	; get x coord
	mov	dx,dxvec+2	; get high order part
	rcr	dl,1
	rcr	ax,1
	mov	xvec,ax		; save it
	mov	ax,dxvec+4
	mov	dx,dxvec+6
	rcr	dl,1
	rcr	ax,1
	mov	xvec+2,ax
	mov	ax,dxvec+8
	mov	dx,dxvec+10
	rcr	dl,1
	rcr	ax,1
	mov	xvec+4,ax	; now dxvec has been xlated into xvec
	mov	ax,[si+40]	; get ptr to object to draw
	mov	objptr,ax	; save in RAM
d3dpr:	
	mov	al,[si+18]	; see if we're close enough in to rotate
	sub	al,[si+26]	; by compareing dist code to rot code
	jns	tstrot		; looks not good for a rotation
	call	relrot		; rotate that body!
	jmp	tstrot1
tstrot:	call	nrelrot		; rotate the coords, and set up omat
tstrot1:
	mov	dx,cwin		; set up registers for drrobj call
	mov	si,objptr	; point to object shape
	mov	bx,offset @dataseg:omat		; pt to local rotation
	call	drrobj		; draw the object on the screen
	mov	rdf,0
	ret
d3fl:
	ret
fd3md:	mov	rdf,4		; force medium, don't check distance,
				; cause we got sent here from near
	mov	ax,[si+42]	; get ptr to object to draw
	mov	objptr,ax	; save in RAM, assume med until proven g
	jmp	d3md1		; jump into mainstream code

d3md:	
	mov	rdf,4		; set the reduction flag
	mov	ax,[si+42]	; get ptr to object to draw
	mov	objptr,ax	; save in RAM, assume med until proven g
	cmp	byte ptr [si+18],1
	jnz	qd3u8		; for sure it's too big for near
	mov	dx,[si+22]
	mov	ax,[si+20]
	.cmp_dd	dx,ax,[si+34],[si+32]	; are we too far for med near?
	ja	d3u8		; too big for med near
	jmp	d3md1		; just right, said the momma bear!

qd3u8:	mov	dx,[si+22]	; but is it too far for med far?
	mov	ax,[si+20]
	.cmp_dd	dx,ax,[si+38],[si+36]
	ja	d3fl		; forget the whole thing!


d3u8:	
	cmp	z0,0		; are we in map mode?
	jz	d3u8a
	test	word ptr [si+24],100h
	jnz	d3u8a
	mov	ax,z0
	cmp	oz+2,ax
	jg	d3fl		; if in map mode and far, only draw wall type
d3u8a:	
	mov	rdf,8
	mov	ax,[si+44]	; get ptr to object to draw
	mov	objptr,ax	; save in RAM, here it's proven med far
d3md1:	mov	ax,dxvec	; get xcoord
	mov	dx,dxvec+2	; get high part of xcoord
	mov	cl,rdf
	xor	ch,ch
	inc	cx
d3md2:	rcr	dx,1		; get sign bit
	rcr	ax,1
	loop	d3md2
	mov	xvec,ax
	mov	ax,dxvec+4	; get xcoord
	mov	dx,dxvec+6	; get high part of xcoord
	xor	ch,ch
	mov	cl,rdf
	inc	cx
d3md3:	
	rcr	dx,1		; get sign bit
	rcr	ax,1
	loop	d3md3
	mov	xvec+2,ax
	mov	ax,dxvec+8	; get xcoord
	mov	dx,dxvec+10	; get high part of xcoord
	xor	ch,ch
	mov	cl,rdf
	inc	cx
d3md4:
	rcr	dx,1		; get sign bit
	rcr	ax,1
	loop	d3md4
	mov	xvec+4,ax
	jmp	d3dpr		; proceed with drawing
	.endp


.proc	modhr	auto		; modifies the object hrobj to update
				; the coords to create a horizon
				; takes [bx] is the window information
				;
	mov	si,norotptr	; get start addr of rot mat
	hmul	1300,[si+6]	; z0 times a13
	mov	z0a13,dx	; save
	mov	ax,dx
	cwd			; put sign of ax into dx
	add	ax,ox+4	; now add to 
	mov	hrobj+4,ax
	adc	dx,ox+6	; take care of high part
	mov	hrobj+6,dx
	hmul	1300,[si]	; z0 times a33
	mov	z0a33,dx
	mov	ax,dx
	cwd			; put sign of ax into dx
	add	ax,ox	; now add to 
	mov	hrobj,ax
	adc	dx,ox+2	; take care of high part
	mov	hrobj+2,dx
	mov	ax,ox+8	; now add to 
	mov	hrobj+8,ax
	mov	dx,ox+10	; take care of high part
	mov	hrobj+10,dx

	mov	ax,z0a13	; now calc object coords for line endpts
	mov	hrwr1+10,ax
	neg	ax
	mov	hrwr1+4,ax
	mov	ax,z0a33
	mov	hrwr1+6,ax
	neg	ax
	mov	hrwr1+12,ax
;	mov	ax,[si+12]	; if negative,then diving
	mov	ax,viewkludge	; get pitch
	sar	ah,1		; to take care of -32768 case
	neg	ah
	mov	dvflg,ah 
	ret
.endp

.proc	tbadd	auto		; adds a table entry to the table
	mov	tbstrt,si	; save table address
	mov	cx,[si]		; get present length
	add	si,4		; mov ptr to beginning of data
	mov	al,[bx+18]	; get distance code
	or	al,al
	jns	dcodeok
	xor	al,al
	mov	[bx+18],al
dcodeok:
	and	byte ptr [bx+18],3
	mov	byte ptr odcode,al
	mov	dx,[bx+22]	; high part
	mov	ax,[bx+20]	; of distance sqrd, for comparison
tbaddl1:
	or	cx,cx		; check for empty table
	jz	tbapnd		; if empty, then put right into table
	mov	di,[si]		; now, find proper entry point for new
	push	ax
	mov	al,byte ptr odcode
	cmp	al,[di+18]	; who has a bigger distance code?
	pop	ax
	ja	tbins
	jb	tbelow		; if too small, skip following comparision
	cmp	dx,[di+22]	; try to just compare high byte of dsqrd
	ja	tbins		; if above, then this where to insert new
	jnz	tbelow		; if below, keep on trucking thru list
	.cmp_dd	dx,ax,[di+22],[di+20]	; do a full 16bit compare
	jae	tbins
tbelow:	dec	cx		; keep track of count
	js	fuck
	add	si,2		; advance to next item
	jmp	tbaddl1		; do another iteration
fuck:	
;	mov	xdnm,cx
	mov	cs:cecode,14
	ret
tbins:
	jnz	normtbins
	cmp	bx,di		; is this a dup?
	jnz	normtbins
	mov	cs:cecode,28
IF printflag
	call	shutdown
	mov	ax,di
	call	wword
	call	wcr
	mov	si,di
	call	printobj
	call	wcr
	call	get_chr
	call	get_chr
	call	printtables
	mov	bp,5555h	; this is to identify what junk is on the stack
IF errortrap
	call	fillscr
ENDIF
	mov	al,1
	jmp	exit_ok
ENDIF
normtbins:
	mov	ax,ds		; set up segment for movsw
	mov	es,ax
	std
	or	cx,cx		; check for empty table
	jz	taddemp		; if so, skip the moving stuff
	push	si
	mov	ax,cx		; set up si,di for fast unsquench to make room
	add	ax,cx		; ax= 2*cx
	mov	di,si		; let di point to loc 1 word past tble end
	add	di,ax
	mov	si,di		; then start si at current table end
	sub	si,2		; now make source point to table end
;	mov	xdnm,cx
;	mov	cs:cecode,13
	rep	movsw		; Flash!
	cld
	pop	si		; restore address for insertion of new addr
taddemp:
tbapnd:
	mov	[si],bx		; put new object in table
	mov	si,tbstrt	; restore ptr to table beginning
	inc	word ptr [si]		; advance # items in table
	mov	ax,[si]	; check bounds of table
	cmp	ax,[si+2]
	jns	tberr1		; uh, oh, out of space
	ret
tberr1:	mov	cs:cecode,10
	ret
.endp

.proc	tbsort auto		; sorts the objects in table by distance
	mov	tbstrt,si	; get table beginning pointer
tbsrtl0:
	xor	di,di		; reset flag which indicates swap occured
	mov	si,tbstrt	; and start addr
	mov	cx,[si]	; our old friend #items
	add	si,4		; advance pointer to data area
	or	cx,cx		; check for empty table
	jz	tbsrtdn		; if so, then can't sort
	cmp	cx,1		; similar case for count = 1
	jz	tbsrtdn
	dec	cx		; deck the damn count with balls of holly

	mov	bx,[si]		; get first object address
	mov	al,[bx+18]	; get distance code
	mov	byte ptr odcode,al

	mov	bx,[si]		; get first object address
	mov	dx,[bx+22]	; get the distance squared
	mov	ax,[bx+20]	; into registers for easy access
tbsrtl1:
	push	ax
	mov	al,byte ptr odcode
	mov	bx,[si+2]	; get next entry in table
	mov	ah,[bx+18]	; get other distance code
	cmp	al,ah
	pop	ax
	ja	tbsrtl2		; don't	 even bother if distance codes are
				; different
	jb	tbsrtl3
	cmp	dx,[bx+22]	; is one clearly larger than the other?
	ja	tbsrtl2		; if above, then items are in proper order
	jb	tbsrtl3		; if below, then swap required
	.subs_dd	dx,ax,[bx+22],[bx+20]	; do 32-bit check
	jae	tbsrtl2
tbsrtl3:
	mov	bx,[si]		; xchg items in list
	xchg	[si+2],bx
	mov	[si],bx
	inc	di		; set flag, indicating a sort
tbsrtl2:
	mov	al,[bx+18]	; get distance code
	mov	byte ptr odcode,al
	mov	dx,[bx+22]	; set registers for next loop
	mov	ax,[bx+20]
	add	si,2		; advance to next position
	loop	tbsrtl1
	or	di,di		; if there hasn't been an xchg, loop thru agn
	jnz	tbsrtl0
tbsrtdn:	ret
	.endp


.proc	tbrmv	auto		; this proc removes an entry from the table
	mov	tbstrt,si	; set up point to beginning of table
	mov	cx,[si]	; set up registers
	add	si,4		; advance ptr to data area of table
tbrmvl1:
	or	cx,cx		; check for empty table, generate error if so
	jz	ernfnd
tbrmvl2:
	cmp	bx,[si]		; is element = to target address?
	jz	tbfnd		; yes, then remove this
	add	si,2		; advance to next entry
	loop	 tbrmvl2	;
ernfnd:	mov	cs:cecode,11	; report evil error message
	ret

tbfnd:	
	mov	byte ptr [bx+18],-1	; flag as really removed from table
	dec	cx		; now remove this unwanted object address
	mov	di,si		; set up addresses
	cld
	add	si,2		; goint up the side of the mountain
	mov	ax,ds		; set segment up
	mov	es,ax
	rep	movsw
	mov	si,tbstrt	; make ptr point back to table origin
	dec	word ptr [si]		; update length
	ret
.endp


.proc	slam	auto		; objects have collided, so destroy them
;	cmp	byte ptr [di+27],0	; is the other object destroyed?
;	jz	slnotim2		; then don't cancel us
;	test	word ptr [si+24],16	; is this a timed object ?
;	jz	slnotim2
;;	mov	word ptr [si+52],0		; at least stop object
;slnotim2:
	test	word ptr [si+24],8	; see if the destructable bit is set
	jz	ckoth
IF cdct EQ 1
	push	bx
	mov	bx,[si+72]	; get addr in table to look up
	add	bx,bx		; make into word address
	stc			; identify as explosion time
	call	[bx+offset @dataseg:objtimtable] ; call destructo routine
	pop	bx
ELSE
	stc			; identify as explosion time
	call	[si+72]
ENDIF
ckoth:
;	cmp	byte ptr [si+27],0	; is the other object destroyed?
;	jz	slnotim1		; then don't cancel us
;	test	word ptr [di+24],16	; is this a timed object ?
;	jz	slnotim1
;	mov	word ptr [di+52],0		; at least stop object
;slnotim1:
	test	word ptr [di+24],8
	jz	cknoth		; forget it if it won't blow up
	xchg	si,di
IF cdct EQ 1
	push	bx
	mov	bx,[si+72]	; get addr in table to look up
	add	bx,bx		; make into word address
	stc			; identify as explosion time
	call	[bx+offset @dataseg:objtimtable] ; call destructo routine
	pop	bx
ELSE
	stc			; identify as explosion time
	call	[si+72]
ENDIF
cknoth:
	ret
.endp

.proc	oldqcollis	auto		; looks between objects si, and [[bx+2]]
				; for possible collision
				; this check goes by xyz coords, not by radius
gonbull:
	push	si		; save si
	push	cx
	xor	cx,cx
	mov	bx,[di+66]	; find largest criteria
	or	bx,bx		; is zero?
	jz	movon
	mov	ax,[si+66]
	or	ax,ax
	jz	movon
	add	bx,ax
	adc	cx,0
	mov	ax,[si]
	mov	dx,[si+2]
	.subs_dd	dx,ax,[di+2],[di]
	.abs_d	dx,ax
	.subs_dd	dx,ax,cx,bx
;	cmp	ax,bx		; now check against criteria
	jae	movon
	xor	cx,cx
	mov	bx,[di+68]	; find largest criteria
	add	bx,[si+68]
	adc	cx,0
	mov	ax,[si+4]
	mov	dx,[si+6]
	.subs_dd	dx,ax,[di+6],[di+4]
	.abs_d	dx,ax
;	cmp	ax,bx		; now check against criteria
	.subs_dd	dx,ax,cx,bx
	jae	movon
	xor	cx,cx
	mov	bx,[di+70]	; find largest criteria
	add	bx,[si+70]
	adc	cx,0
	mov	ax,[si+8]
	mov	dx,[si+10]
	.subs_dd	dx,ax,[di+10],[di+8]
	.abs_d	dx,ax
;	cmp	ax,bx
	.subs_dd	dx,ax,cx,bx
	jae	movon
	call	slam
	clc
	pop	cx
	pop	si
	ret
movon:
	stc		; leave flag to try next thing
	pop	cx
	pop	si
	ret
.endp

.proc	qcollis	auto	
	cmp	word ptr [si+72],21	; a missle?
	jz	fastitem
;	cmp	word ptr [si+40],offset @dataseg:objflt1bomb	; a missle?
;	jz	fastitem
	cmp	word ptr [si+72],30	; a bullet?
	jz	fastitem
	jmp	normck
fastitem:
	cmp	word ptr [si+24],0
	jz	qclsdb
	cmp	word ptr [si+52],0
	jz	qclsdb
qmislp:
	sub	bx,2
	mov	ax,tbstrt		; check to make sure we are not
	add	ax,4
	cmp	bx,ax
	js	qclsdb
	mov	di,[bx]	; load di with alternative object 2
	push	bx
	mov	al,[si+19]		; see if things have the same drawing
	cmp	al,[di+19]
	jz	novelon			; like objects don't collide
	cmp	word ptr [di+24],0
	jz	novelon
	push	si
	mov	ax,[si+24]
	or	ax,[di+24]		; are either a wall segment?
	test	ax,100h
	jz	smalltarget	; standard is a small target
	push	di
	call	oldqcollis
	pop	di
	jmp	aftertarget
smalltarget:
	call	qvelon		; is dump in same direction as the missle?
aftertarget:
	pop	si
	jc	novelon
	pop	bx		; if that failed, then we have farther to go
	ret
novelon:
	pop	bx
	jmp	qmislp		; try the next object in table
	ret
	
normck:
	mov	di,[bx+2]	; load di with alternative object 2
	mov	al,[si+19]	; are they the same class of object?
	cmp	al,[di+19]
	jz	qclsdb		; yes!  Too like objects can't collide
	call	qcollis1
qclsdb:	ret
.endp

.proc	qcollis1	auto
				; looks between objects si, and [[bx+2]]
				; for possible collision
	mov	ax,[si+24]	; make sure at least one of them will blow
	or	ax,[di+24]
	test	ax,8
	jnz	qgoahd1		; ok, go ahead, make a day!
	ret
qgoahd1:
	test	ax,100h		
	jz	nowalls
	jmp	oldqcollis	; just call the old system for walls!
nowalls:
	push	si		; save si
	push	cx
	mov	bx,[di+66]	; find largest criteria
	or	bx,bx		; is it zero?
	jz	movon1		; yes, no explosion
	mov	ax,[si+66]
	or	ax,ax
	jz	movon1
	cmp	bx,ax
	jae	qclb01
;	mov	bx,[si+66]	; use other criteria, since it is bigger
	add	bx,[si+66]	; make criteria the sum of the two
qclb01:
	call	getx1
	jc	movon1		; forget it if too far off
	mov	ax,x1mag	; compare magnitude of vector to criteria
	cmp	ax,bx
;	jae	movon4
	jae	movon1
nomissl:
	call	slam
movon1:
	pop	cx
	pop	si
	ret
movon4:
	cmp	word ptr [si+40],offset @dataseg:objbsph	; a missle?
	jz	fastcheck		; check for fastmoving object
	cmp	word ptr [si+40],offset @dataseg:objflt1mis	; a missle?
	jnz	movon1
fastcheck:
	call	qthru
	jmp	movon1
.endp

.proc	getx1	auto		; gets vector between missle [si], and dump
	mov	ax,[si]		; and places result in x1vec, and x1mag vars
	mov	dx,[si+2]
	.subs_dd	dx,ax,[di+2],[di]
	mov	x1vec,ax	; save in vector
	.abs_d	dx,ax
	or	dx,dx		; higher order byte must be zero
	jnz	movon5
	or	ax,ax		; see if high bit is low
	js	movon5
	mov	ax,[si+4]
	mov	dx,[si+6]
	.subs_dd	dx,ax,[di+6],[di+4]
	mov	x1vec+2,ax	; save in vector
	.abs_d	dx,ax
	or	dx,dx		; higher order byte must be zero
	jnz	movon5
	or	ax,ax		; see if high bit is low
	js	movon5
	mov	ax,[si+8]
	mov	dx,[si+10]
	.subs_dd	dx,ax,[di+10],[di+8]
	mov	x1vec+4,ax	; save in vector
	.abs_d	dx,ax
	or	dx,dx		; higher order byte must be zero
	jnz	movon5
	or	ax,ax		; see if high bit is low
	js	movon5
	push	bx		; save the radius of explosion
	push	si
	push	di
	mov	si,offset @dataseg:x1vec
	call	vmag
	mov	x1mag,ax
	pop	di
	pop	si
	pop	bx
	clc
	ret
movon5:	
	stc
	ret
.endp

.proc	qvelon	auto		; checks to see if x1vec dot velocity is
				; close to one, in order to see if the missle
				; is pointed toward the object at [di]
	
	test	word ptr [di+24],8
	jnz	qgoahd2		; ok, go ahead, make a day!
failrn:	stc			; say object failed
	ret
albang3:
;	mov	cs:cecode,17
albang:
	pop	di
	pop	si
	call	slam
	clc
	ret			; and return to caller with success
qgoahd2:
	call	getx1		; get x1 vector and magnitude
	jc	failrn		; fail right now!
	mov	bx,[di+66]	; find largest criteria
	cmp	bx,[si+66]
	jae	qclb02
	mov	bx,[si+66]	; use other criteria, since it is bigger
qclb02:
	push	si
	push	di
	cmp	bx,x1mag	; is it already a collision?
	jae	albang		; yes, bang it up!
;	cmp	bx,x1mag	; is it already a collision?
;	jae	albang3		; yes, bang it up!
	add	si,46		; point to velocity vector
	push	di
	call	vmag		; get magnitude of velocity
	mov	x2mag,ax	; save magnitude in x2mag
	pop	di
	mov	di,si		; make di point to the velocity vector
	mov	ax,[si]
	mov	x2vec,ax
	mov	ax,[si+2]
	mov	x2vec+2,ax
	mov	ax,[si+4]
	mov	x2vec+4,ax
	mov	si,offset @dataseg:x1vec
	mov	ax,[si]		; form dot product of x1 & x2
	mov	dx,[di]
	imul	dx
	mov	xdot+4,ax
	mov	xdot+6,dx
	mov	ax,[si+2]		; form dot product of x1 & x2
	mov	dx,[di+2]
	imul	dx
	.add_dd	xdot+6,xdot+4,dx,ax
	mov	ax,[si+4]		; form dot product of x1 & x2
	mov	dx,[di+4]
	imul	dx
	.add_dd	xdot+6,xdot+4,dx,ax
	mov	ax,xdot+6
	mov	xdots+2,ax
	mov	ax,xdot+4
	mov	xdots,ax
	mov	ax,x1mag		; now form denominator
	mov	dx,x2mag
	mul	dx			; dx,ax has x1 * x2 (magnitude)
	mov	cx,dx			; set up for divide
	mov	bx,ax
	mov	di,offset @dataseg:xdot
	call	divs_qd			; do the division
;	jae	kdkdkk
;	mov	cs:cecode,18
;	jmp	linupfl
;kdkdkk:
	test	xdot+6,8000h		; check sign of result
	jz	linupfl
	mov	dx,xdot+2
	mov	ax,xdot
	.neg_d	dx,ax			; take negative value it
	cmp	xdot+4,-1		; 
	jnz	albang4			; check for cosine > +1
	cmp	dx,45000		; how large is cos
	jae	albang4
linupfl:
	pop	di
	pop	si
	stc				; failed to line up
	ret
albang1:
;	mov	cs:cecode,16
	jmp	albang		; slam the opposing forces
albang4:
	mov	ax,x1mag	; compare distance from tick to velocity mag
	shr	ax,1		; divide distance by two
	cmp	ax,x2mag
	jbe	albang5
	clc
	pop	di
	pop	si
	ret	
albang5:
;	mov	cs:cecode,19
	jmp	albang		; slam the opposing forces
movon2:
	ret
.endp

.proc	qthru	auto		; see if missle has gone through the object
	mov	ax,[si]
	mov	dx,[si+2]
	add	ax,[si+46]	; subtract one velocity point
	adc	dx,0
	.subs_dd	dx,ax,[di+2],[di]
	mov	x2vec,ax	; save in vector
	.abs_d	dx,ax
	or	dx,dx		; higher order byte must be zero
	jnz	movon2
	or	ax,ax		; see if high bit is low
	js	movon2
	mov	ax,[si+4]
	mov	dx,[si+6]
	add	ax,[si+48]	; subtract one velocity point
	adc	dx,0
	.subs_dd	dx,ax,[di+6],[di+4]
	mov	x2vec+2,ax	; save in vector
	.abs_d	dx,ax
	or	dx,dx		; higher order byte must be zero
	jnz	movon2
	or	ax,ax		; see if high bit is low
	js	movon2
	mov	ax,[si+8]
	mov	dx,[si+10]
	add	ax,[si+50]	; subtract one velocity point
	adc	dx,0
	.subs_dd	dx,ax,[di+10],[di+8]
	mov	x2vec+4,ax	; save in vector
	.abs_d	dx,ax
	or	dx,dx		; higher order byte must be zero
	jnz	movon2
	or	ax,ax		; see if high bit is low
	js	movon2
	mov	ax,[si+46]
	mov	xvx,ax
	mov	ax,[si+48]
	mov	xvx+2,ax
;	mov	ax,[si+50]
	mov	ax,5555
	mov	xvx+4,ax
	push	bx		; save the radius of explosion
	push	si
	push	di
	mov	si,offset @dataseg:x2vec
	call	vmag
	mov	x2mag,ax
	mov	si,offset @dataseg:x1vec
	mov	di,offset @dataseg:x2vec
	mov	ax,[si]		; form dot product of x1 & x2
	mov	dx,[di]
	imul	dx
	mov	xdot+4,ax
	mov	xdot+6,dx
	mov	ax,[si+2]		; form dot product of x1 & x2
	mov	dx,[di+2]
	imul	dx
	.add_dd	xdot+6,xdot+4,dx,ax
	mov	ax,[si+4]		; form dot product of x1 & x2
	mov	dx,[di+4]
	imul	dx
	.add_dd	xdot+6,xdot+4,dx,ax
	mov	ax,x1vec
	xor	ax,x2vec
	test	ax,08000h
	jz	cecold
	mov	cs:cecode,16
cecold:
	mov	ax,xdot+6
	mov	xdots+2,ax
	mov	ax,xdot+4
	mov	xdots,ax
	mov	ax,x1mag		; now form denominator
	mov	dx,x2mag
	mul	dx			; dx,ax has x1 * x2 (magnitude)
	mov	cx,dx			; set up for divide
	mov	bx,ax
	mov	di,offset @dataseg:xdot
	call	divs_qd			; do the division
	mov	cs:cecode,16
	or	xdot+6,0		; check sign of result
	jns	movon3			; if result is positive, no collis
	mov	ax,xdot+2		; xdot must be less than 1,
					; so this will tell
	add	ax,40000		; is cos(theta) less than -.61?
	jns	movon3			; no, then didn't travel through
	pop	di
	pop	si
	pop	bx
	call	slam
	ret
movon3:
	pop	di
	pop	si
	pop	bx
.endp


.proc	vmag	auto		; takes a vector in [si], returns mag in ax
				; (unsigned int)
	mov	ax,[si]
	mov	dx,ax
	imul	dx		; find squares of components
	mov	bx,dx
	mov	cx,ax		; save sum
	mov	ax,[si+2]
	mov	dx,ax
	imul	dx
	.add_dd	bx,cx,dx,ax
	mov	ax,[si+4]
	mov	dx,ax
	imul	dx
	.add_dd	bx,cx,dx,ax
	mov	dx,bx		; now set up for dsqrt
	mov	ax,cx
	call	dsqrt
justreturn:
	ret
.endp

.proc	fuckyou auto
	push	si
	push	di
	mov	si,offset dxvec
	mov	di,offset deathcoords
	mov	cx,6
	push	ds
	pop	es
	rep	movsw
	pop	di
	pop	si
	ret
.endp


.proc	qwalk	auto		; sees if person has collided with an object

	mov	ax,[si+24]
	mov	objtype,ax
	push	si
	mov	ax,[si+72]	; get object type to chech extended table
	add	ax,ax		; make into a word address
	mov	si,offset @dataseg:extendedtypetbl
	add	si,ax
	mov	ax,[si]		; check save bit
	mov	extendedtype,ax
	pop	si
	cmp	rdf,0		; must be right close
	jz	oiclose1		; object is close
qcrsend1:
	ret
oiclose1:	
	call	rel3d
	or	ch,ch
	jnz	qcrsend1	; make sure we have the current coords
	mov	ax,extendedtype	; make sure at least one of them will blow
	test	ax,64+128+512	; is object walkable, killable, or capture?
	jz	qcrsend1	; this object has some balls!
	mov	dx,dxvec+2	; load x distance
	mov	ax,dxvec
	.abs_d	dx,ax
	or	dx,dx
	jnz	qcrsend1
	mov	bx,[si+66]	; use other criteria, since it is bigger
	cmp	ax,bx
	jae	qcrsend1
	mov	dx,dxvec+6	; load x distance
	mov	ax,dxvec+4
	.abs_d	dx,ax
	or	dx,dx
	jnz	qcrsend1
	mov	bx,[si+68]	; use other criteria, since it is bigger
	cmp	ax,bx
	jae	qcrsend1
	mov	dx,dxvec+10	; load x distance
	mov	ax,dxvec+8
	.abs_d	dx,ax
	or	dx,dx
	jnz	qcrsend1
	mov	bx,[si+70]	; use other criteria, since it is bigger
	cmp	ax,bx
	jae	qcrsend1
	test	extendedtype,128	; does it kill us?
	jz	nokilledus
	cmp	invincible,0
qcrs2:	jnz	qcrsend1	; we can't be killed or captured
	mov	ax,[si+72]		; get type number of object which
					; killed us
	mov	deathcode,ax
	mov	crshflg,10		; we died from an object
	or	missionstatus,800h	; set the killed by an object flag
	call	fuckyou
	ret
nokilledus:
	test	extendedtype,512	; does it kill us?
	jz	nocapturedus
	cmp	invincible,0
	jnz	qcrs2	; we can't be killed or captured
	mov	ax,[si+72]		; get type number of object which
					; captured us
	mov	deathcode,ax
	mov	capturedflag,-1		; set captured flag
	ret
nocapturedus:
				; if both 128 and 512 bits are false, the
				; the 64 bit must have been set
	
				; so at this point, we have collided with the
				; mysterious object
	mov	ax,[si+8]	; get object's height
	mov	dx,[si+10]
	test	extendedtype,256	; do we include the object's extent?
	jz	noextentinc
	add	ax,[si+70]	; add in objects vertical size
	adc	dx,0		; don't forget the carry
	sub	ax,ehmin+1	; make it a little lower than actual, so we
	sbb	dx,0		; are in constant collision when standing
noextentinc:
	mov	bx,oz
	mov	cx,oz+2		; get height
	add	bx,ehmin		; give benifit of a doubt
	adc	cx,0
	sub	bx,ax		; make sure we are above what were standing on
	sbb	cx,dx
	js	notaboveit	; let us fall if we are too far below surface
	mov	myzground,ax	; put into variables
	mov	myzground+2,dx
notaboveit:
	ret
.endp


.proc	qcrash	auto		; sees if plane has collided with an object

	mov	ax,[si+24]
	mov	objtype,ax
	mov	ax,[si+72]	; get object type to chech extended table
	cmp	ax,28		; don't collide with object5d
;	jz	noqcrash
	jz	qcrsend
	push	si
	add	ax,ax		; make into a word address
	mov	si,offset @dataseg:extendedtypetbl
	add	si,ax
	mov	ax,[si]		; check save bit
	mov	extendedtype,ax
	pop	si

	mov	ax,[si+66]	; watch for object with neg collision radius
	or	ax,ax
	jns	regisok
	mov	ah,al
	mov	al,80
	add	al,17
	cmp	ah,-2		; was it a too-good violation?
	jnz	nonotoogood
	inc	al		; make error 98 be no-not-too-good
nonotoogood:
	mov	bx,offset @codeseg:cecode-10
	mov	cs:[bx+10],al	; set cecode to violation of registration
	mov	ax,[si+72]
	cmp	ax,31
	jz	oknotk
	mov	cs:cecode,59	; weird error code
oknotk:
	mov	temp1,ax
	mov	ejectflag,-1	; just pop you out of the plane

regisok:

	cmp	ejectflag,0
	jz	donormalcrash
	cmp	obj5d+24,0	; is the plane around?
	jz	qcrsend		; no, so don't have it hit
	push	si
	call	relobj5d
	pop	si
	jc	qcrsend		; too far away
	or	ch,ch			; if cx is zero, then too far
	jnz	qcrsend
	and	cl,0f0h			; now check for still too far
	jnz	qcrsend	;
	jmp	oiclose		; now pretend it is us!
donormalcrash:
	cmp	rdf,0		; must be right close
	jz	oiclose		; object is close
qcrsend:
	ret
oiclose:	
	mov	ax,objtype	; make sure at least one of them will blow
	test	ax,20h		; is object crashable?
	jnz	meatyobj	; this object has some balls!
	test	extendedtype,16		; the only object with these attribs is
	jz	qcrsend		; a runway piece
meatyobj:
	mov	dx,dxvec+2	; load x distance
	mov	ax,dxvec
	.abs_d	dx,ax
	or	dx,dx
	jnz	qcrsend
	mov	bx,[si+66]	; use other criteria, since it is bigger
	cmp	ax,bx
	jae	qcrsend
	mov	dx,dxvec+6	; load x distance
	mov	ax,dxvec+4
	.abs_d	dx,ax
	or	dx,dx
	jnz	qcrsend
	mov	bx,[si+68]	; use other criteria, since it is bigger
	cmp	ax,bx
	jae	qcrsend
	mov	dx,dxvec+10	; load x distance
	mov	ax,dxvec+8
	.abs_d	dx,ax
	or	dx,dx
	jnz	qcrsend
	mov	bx,[si+70]	; use other criteria, since it is bigger
	cmp	ax,bx
	jae	qcrsend
	mov	ax,extendedtype	; the only object with these attribs is
	test	ax,16
	jz	notrunway
;	mov	al,[si+19]	; set flag equal to object class, so we can
;				; tell unfriendly landing strips from friendly
;				; ones
	mov	al,1		; all are friendly !
	mov	onrunwayflag,al	; say we are on the runway!
	mov	ax,[si+8]	; set up zground
	mov	zground,ax
	mov	ax,[si+10]	; set up zground
	mov	zground+2,ax
	jmp	nostjudam	; skip the damage deal if on nice runway
notrunway:
;	inc	crshflg		; increment the crash flag to crash the plane
;	test	word ptr [di+24],8
;	jz	cknoth1		; forget it if it won't blow up
;	mov	si,di
;	stc			; identify as explosion time
;	push	si
;	call	[si+72]
;	pop	si
	test	extendedtype,20h	; is it a portal?
	jnz	qcustom			; then of course, we will have custom
	test	word ptr objtype,8
	jz	cknoth1		; don't destroy indestructable object
qcustom:
	test	extendedtype,4		; check save bit
	jnz	customdestroy


	mov	word ptr [si+52],0	; cancel object
	jmp	cknoth1
customdestroy:
	push	cx
	push	si
	push	di
	mov	di,-1		; set flag showing we are a plane
	mov	bx,[si+72]	; get addr in table to look up
	add	bx,bx		; make into word address
	stc				; tell routine to destroy!
	call	[bx+offset @dataseg:objtimtable] ; call destructo routine
	pop	di
	pop	si
	pop	cx

cknoth1:
	mov	cx,1		; default is 1 damage unit to plane
	mov	ax,objtype	; see how much damage object causes plane
	test	ax,40h		; does it do a 6 pack of damage?
	jz	only1unit	; no, only 1 unit of damage
	mov	cx,6		; or a six pack!
	mov	brdrcnt,8
	cmp	brdrclr,4	; see if already terminally damaged
	jz	stilljust1
	mov	brdrclr,7	; insure it will end on the correct color
only1unit:	
	test	ax,80h		; are we talking instant destruction?
	jz	stilljust1
	mov	cx,75		; 25 units of damage will bring down this sucker
	mov	ax,totaldamage	; if plane is already damaged, just let fall
	cmp	ax,cx
	ja	nostjudam
	mov	brdrclr,4	; give warning of destruction
	mov	brdrcnt,0
;	jmp	planebounce	; bounce plane off object
;planebounce:
	mov	ax,rtopv	; reverse direction of motion
	neg	ax
	sar	ax,1
	mov	rtopv,ax
	mov	ax,rtopv+2	; reverse direction of motion
	neg	ax
	sar	ax,1
	mov	rtopv+2,ax
	or	missionstatus,80h	; leave flag that idiot hit structure
	mov	ax,[si+72]		; get the type of object it was
	mov	building,ax

stilljust1:
	test	word ptr extendedtype,8	; is it a wall?
	jz	stju1
	mov	ax,cs:oticks
	sub	ax,walldamtick
	cmp	ax,200		; every 800 ticks, cause damage
	jb	nostjudam
	mov	ax,cs:oticks
	mov	walldamtick,ax
	add	cx,cx		; double damage
stju1:
	xor	al,al
	cmp	remoteflag,al
	jnz	makeblam
	cmp	ejectflag,al
	jnz	makeaboom	
makeblam:
IF soundflag EQ 0
		call	b3laminit
		mov	bl,2
		mov	ax,10h
		call	voiceon
ENDIF
	call	damageplane	; cause damage to plane
nostjudam:
	ret
makeaboom:
	mov	ax,[si+72]		; get the type of object it was
	mov	ardvark,ax
IF soundflag EQ 0
	call	makeboom
ENDIF
	call	damageplane	; cause damage to plane
	ret
.endp

	

.proc	qtimed	auto		; runs timed object code
	test	word ptr [si+24],16	; is this a timed object ?
	jz	nottim		; nope,
	push	si
	push	bx		; save bx, it's important!
	push	cx		; save cx too
IF cdct EQ 1
	mov	bx,[si+72]	; get addr in table to look up
	add	bx,bx		; make into word address
	clc			; identify as timed object code
	call	[bx+offset @dataseg:objtimtable] ; call destructo routine
ELSE
	clc			; identify as timed object code
	call	[si+72]
ENDIF
	pop	cx		; save cx too
	pop	bx
	pop	si
nottim:	ret
.endp


.proc	removedups	auto	; removes duplicate objects from universe
	push	di
	mov	di,[bx+2]	; get next item in list
	cmp	di,si		; does it have the same address?
	jnz	nodupshere	; guess it isn't a dup
	push	si
	push	bx
	push	cx
	mov	di,bx
	mov	si,bx
	add	si,2
	dec	cx		; me must remove the duplicate from the damn
				; table
	mov	ax,ds
	mov	es,ax
	cld
	rep	movsw		; this will scrunch up the table
	pop	cx
	pop	bx
	pop	si
	pop	di
	stc			; report removal of duplicate
	ret
nodupshere:
	pop	di
	clc			; leave flag saying no dups found
	ret
.endp

IF rundf EQ 1
.proc	checkforrunway	auto	; checks for a drawable first runway piece
				; the jz if not, jnz if should be drawn first
	mov	ax,[si+8]	; make sure it is based on the ground
	or	ax,[si+10]
	jz	sfsg1		; so far so good, object is on ground
	xor	ax,ax		; reverse meaning of flag
	ret
sfsg1:
	push	si
	mov	ax,[si+72]	; get object type to chech extended table
	add	ax,ax		; make into a word address
	mov	si,offset @dataseg:extendedtypetbl
	add	si,ax
	mov	ax,[si]		; check save bit
	mov	extendedtype,ax
	pop	si
	test	extendedtype,16
	ret
.endp
ENDIF

.proc	drawnear	auto	; draws all the objects in the near table
				; and then sorts table
	mov	objcount,0
IF rundf EQ 1
	mov	bx,tblist	; point to first item in table
	mov	cx,[bx]		; get length
	add	bx,4		; point to start of data
	or	cx,cx		; make sure table isn't empty
	jz	norundraw
runwdloop:			; now loop thru looking for runways
	push	cx
	push	bx
	mov	si,[bx]
	cmp	word ptr [si+24],0	; is item alive?
	jz	runwdskip
	inc	objcount
	call	checkforrunway	; is it a piece we should draw first?
	jz	runwdskip	; no!
	push	si
	call	d3dobj		; yes, draw it!
	pop	si
	cmp	ejectflag,0	; if we are not in plane, check for possible
	jz	nosetmyzg
	call	qwalk		; amended walking height
nosetmyzg:
	call	qcrash		; see if we are on runway
runwdskip:
	pop	bx
	pop	cx
	add	bx,2		; advance to next item in table
	loop	runwdloop
norundraw:
	mov	ax,objcount
	cmp	ax,maxobjcount
	jbe	notobjmax
	mov	maxobjcount,ax
notobjmax:
ENDIF
drwnrl0:
	mov	cx,1		; draw all four tables, yes, include fartble
	mov	si,offset @dataseg:tblist
;	add	si,6		; point to far table first
listlp:	push	cx		; save loop index
	push	si
	mov	si,[si]		; get list address
	mov	tbstrt,si	; save table origin in variable
	mov	cx,[si]		; standard length 
	mov	bx,tbstrt	; start of table
	add	bx,4		; make bx point to data area
	or	cx,cx		; check for empty table
	jnz	drwnrlp
	jmp	drwnrdn		; if so, then were already done
drwnrlp:
	mov	si,[bx]		; get start address of object
	mov	al,[si+18]	; get present distance near/far code
	xor	ah,ah
	mov	odcode,ax
	push	bx		; save all crap
	push	cx
	push	si
	call	qtimed		; try a timed object call
	cmp	cx,1		; is there another object left in table?
	jbe	nocols		; no object to collide with!

	jmp	nodupsfound

	call	removedups	; remove duplicate objects from universe
	jnc	nodupsfound
	mov	si,tbstrt	; decrement # objects in table
	dec	word ptr [si]
	pop	si
	pop	cx		; now change our object count, cause we don't
	dec	cx		; want to have troubles at the end of this
				; loop
	push	cx
	push	si
nodupsfound:
	cmp	word ptr [si+24],0	; is it wrecked already?
	jz	donotd3d	; then don't draw
	call	qcollis		; look for a collision
nocols:	
IF rundf EQ 1
	call	checkforrunway	; is it a piece we don't have to draw?
	jz	donotd3d1	; yes, don't draw it, it has already been drawn
	mov	al,[si+18]	; use old distance code
	mov	rdf,al
	jmp	donotd3d2
ENDIF
donotd3d1:
	call	d3dobj		; draw the object
	pop	si
	push	si
	cmp	ejectflag,0	; if we are not in plane, check for possible
	jz	nosetmyzg1
	call	qwalk		; amended walking height
donotd3d:
nosetmyzg1:
	call	qcrash
donotd3d2:
	pop	si
	cmp	word ptr [si+24],0  ; see if object is active
	jnz	obact		; it is
IF printflag
	inc	expsrmvd
ENDIF
	mov	bx,si		; this points to our object
	push	bx		; save current ptr
	mov	si,tbstrt	; save current tbstrt
	push	si
	call	tbrmv		; remove object from this table
	pop	si
	mov	tbstrt,si
	pop	si
	pop	cx
	pop	bx
	jmp	sameol1
	
obact:	
	jmp	sameole

	mov	ax,odcode
	cmp	[si+18],al	; compare old dcode to new one
	jz	sameole		; same old distance code, so continue
				
				; now the object needs to be removed from
				; the current list, and placed in the new
				; list
	mov	bx,si		; this points to our object
	push	bx		; save current ptr
	mov	si,tbstrt	; save current tbstrt
	push	si
	push	bx		; save object address
	call	tbrmv		; remove object from this table
	pop	bx		; restore object address
	push	ax
	mov	al,[bx+18]	; find out which list it wants to be on
	cmp	al,4
	js	toofarpanic	; if wants to go into fourth list, panic
	jmp	toofarpanic1
toofarpanic:
	xor	ah,ah
	mov	di,ax
	add	di,di		; make it 0,2,4,6
	pop	ax
	mov	si,[di+offset @dataseg:tblist]	; get proper list
	call	tbadd		; add it to this list
	pop	si		; restore list info
	mov	tbstrt,si
	pop	si		; restore si pointer

	pop	cx
	pop	bx		; do same stuff as sameole, but don't advance
				; to next pointer entry
	jmp	sameol1
drwnrlp1:
	jmp	drwnrlp
sameole:
	pop	cx
	pop	bx
	add	bx,2
sameol1:
	loop	drwnrlp1
	mov	si,tbstrt
	call	tbsort
drwnrdn:
	pop	si
	sub	si,2		; advance to next table in list
	pop	cx		; get list count
	loop	listflp
	ret
listflp:	jmp	listlp

toofarpanic1:
	mov	cs:cecode,26
	pop	ax
	pop	si
	pop	si
	pop	cx
	pop	bx
	jmp	sameol1
.endp

.proc	copytable	auto	; copies data from med far table into
				; the far memory data storage, to be farmed
				; out to the disk when it is time

	mov	cx,1		; draw all four tables, yes, include fartble
	mov	si,offset @dataseg:tblist
;	add	si,4		; point to med far table first
clistlp:
	mov	si,[si]		; get list address
	mov	tbstrt,si	; save table origin in variable
	mov	cx,[si]		; standard length 
	mov	bx,tbstrt	; start of table
	add	bx,4		; make bx point to data area
	or	cx,cx		; check for empty table
	jnz	cdrwnrlp2
	jmp	cdrwnrdn		; if so, then were already done
cdrwnrlp2:
cdrwnrlp:
	push	cx
	push	si
	mov	si,[bx]		; get start address of object
	push	bx
	mov	al,[si+18]	; get present distance near/far code
	cmp	al,2	; take only items which belong in the far table
	jb	ignoreitem
	mov	fdexpobj,si	; make variable point to object
	push	si
	mov	ax,[si+72]	; get object type to chech extended table
	add	ax,ax		; make into a word address
	mov	si,offset @dataseg:extendedtypetbl
	add	si,ax
	test	word ptr [si],1		; check save bit
	clc
	jnz	skipsavit	; skip saving it, we don't have to save these
	call	tomemseg	; place in the med far segment storage
skipsavit:
	pop	si
	push	si
	jc	msegfull	; uh oh, memseg is full
	mov	word ptr [si+24],0	; kill it as a timed object, free up space
	mov	bx,si		; get address we want to pick out of table
	mov	si,tbstrt	; point to beginning of table
	call	tbrmv		; remove from table
keeptry:
	pop	si
ignoreitem:
	pop	bx
;	add	bx,2
	pop	si
	pop	cx
	loop	cdrwnrlp	; get next item in table
cdrwnrdn:
	ret
msegfull:
	mov	cs:cecode,37
	jmp	keeptry
.endp

.proc	wrtvec	auto
	mov	ax,[si]
	push	si
	mov	si,offset @dataseg:cbuf
	call	words_to_dec
	call	put_str
	mov	si,offset @dataseg:comma
	call	put_str
	pop	si
	mov	ax,[si+2]
	push	si
	mov	si,offset @dataseg:cbuf
	call	words_to_dec
	call	put_str
	mov	si,offset @dataseg:comma
	call	put_str
	pop	si
	mov	ax,[si+4]
	push	si
	mov	si,offset @dataseg:cbuf
	call	words_to_dec
	call	put_str
	mov	si,offset @dataseg:comma
	call	put_str
	pop	si
	ret
	.endp

.proc	wrtmat	auto
	mov	ax,0dh
	call	put_chr
	mov	al,0ah
	call	put_chr
	mov	cx,3
wrmlp:	
	call	wrtvec
	add	si,6
	mov	ax,0dh
	call	put_chr
	mov	al,0ah
	call	put_chr
	loop	wrmlp
	mov	ax,0dh
	call	put_chr
	mov	al,0ah
	call	put_chr
	ret
.endp


.proc	findmem	auto		; finds next avail bullet in system
	mov	ax,memseg	; point to good location
	mov	es,ax
	mov	si,exptr	; get current pointer
	mov	cx,nmaxmedfar	; don't loop thru more than once
	mov	si,0		; start of buffer is zero
fexpl1:	cmp	word ptr es:[si+24],0	; see if this bullet is active
	jz	expfree		; found one!
	add	si,nbytexp	; if not, goto next bullet
	cmp	si,mseptrmx
				; but be careful not to go off the end
	jb	eptrok		; looks ok from here...
	jz	eptrok
	mov	si,0		; start of buffer is zero
eptrok:	
	loop	fexpl1		; try again
	stc			; set error flag
	ret
expfree:
	mov	exptr,si	; save back into variable
	clc			; reset error flag
	ret
	.endp

.proc	tomemseg	auto
	call	findmem		; try to find bullet
	jnc	nexpero		; error, no free bullets
	stc
expero:	ret
nexpero:
	mov	ax,memseg	; select the free segment
	mov	es,ax
	mov	di,si
	mov	cx,nbytexp	; number of bytes to move
	push	si		; save ptr to object
	mov	si,fdexpobj	; load source of object template address
	cld			; make sure direction flag is correct
;	push	ds
;	mov	ax,memseg
;	mov	ds,ax
	rep	movsb
;	pop	ds
	pop	si
	clc
	ret
.endp

.proc	frommemseg	auto
				; moves object from the memseg area to the
				; buffer memobjbuf
				; si will have the offset into memseg desired
				; di must be set to the buffer in the data
				; segment where you want the object placed
	mov	ax,ds
	mov	es,ax
	mov	cx,nbytexp	; number of bytes to move
	push	si		; save ptr to object
	cld			; make sure direction flag is correct
	push	ds
	mov	ax,memseg	; select the free segment
	mov	ds,ax
	rep	movsb
	pop	ds
	pop	si
	clc
	ret
.endp

.proc	drawmemseg	auto	; draws all the data in mseg on screen
	mov	ax,memseg	; point to good location
	mov	es,ax
	mov	si,exptr	; get current pointer
	mov	cx,nmaxmedfar	; don't loop thru more than once
	mov	si,0		; start of buffer is zero
dfexpl1:	cmp	word ptr es:[si+24],0	; see if this bullet is active
	jz	dexpfree		; found one!
	push	cx
	push	es
	push	si
	mov	di,offset @dataseg:memobjbuf
	call	frommemseg
	cmp	drawmemflag,0
	jnz	reallydrawem
	call	disteval	; just evaluate distance for table xfer
	jmp	afterdraw
reallydrawem:
	mov	si,offset @dataseg:memobjbuf
	mov	dx,ptrgwinf
	call	d3dobj				; draw the object
afterdraw:
	pop	si
	mov	ax,memobjbuf+18		; get distance code for just drawn
	cmp	al,2			; has this object gotten closer?
	jae	memnocloser
	push	si
	mov	si,offset @dataseg:memobjbuf
	call	putbackintable
	pop	si
	pop	es
	mov	word ptr es:[si+24],0		; remove from our memseg buffer
	push	es			; don't screw up stack
memnocloser:
	pop	es
	pop	cx
dexpfree:
	add	si,nbytexp	; if not, goto next bullet
	cmp	si,mseptrmx
				; but be careful not to go off the end
	jb	deptrok		; looks ok from here...
	jz	deptrok
	mov	si,0		; start of buffer is zero
deptrok:	
	cmp	cs:cecode,0
	jnz	demerg
	loop	dfexpl1		; try again
demerg:
	stc			; set error flag
	ret
	.endp

.proc	putbackintable	auto		; put object back into table, 
					; and remove from this membuf
	or	[si+24],8000h	; set bit requesting to be added to table
;	mov	byte ptr [si+18],0	; put to near
	mov	fdexpobj,si		; save ptr to current object
	call	findexp
	jc	pbitfail
IF printflag
		mov	al,2bh			; see if control key is down
		call	getkbit
		or	al,al
		jnz	pbitfail
ENDIF
	mov	ax,ds		; transfer from chosen object
	mov	es,ax
	push	si
	mov	di,si
	mov	cx,nbytexp	; number of bytes to move
	mov	si,fdexpobj	; load source of object template address
	cld			; make sure direction flag is correct
;	push	ds
;	mov	ax,memseg
;	mov	ds,ax
	rep	movsb
;	pop	ds
	pop	si		; leave si with addr into timed object
	clc			; no hits, no errors
	ret
pbitfail:
	mov	cs:cecode,63	; error, out of space for new timed objects
IF printflag
	call	printexp
	call	printtables	; printout all objects in object space
ENDIF
	ret
.endp	

.proc	decodeobj	auto	; unpacks an encoded tile from a coded tile
				; encoded tile addr  es:[di]
				; target object addr ds:[si]
	mov	ax,es:[di+11]	; get type of object
	or	ax,ax
	jnz	nodecodefail	; if no object there, fail it
	stc
	ret
badencode:
	mov	cs:cecode,39	; leave error code
	stc
	ret
nodecodefail:
	mov	[si+24],ax	; well, this one was easy!
				; the following code moves the template
				; for the object to the target, so all
				; fields not filled by the encoded source
				; get the default values from the template
	mov	bx,es:[di+21]	; type of object 0-30 something
	mov	[si+72],bx	; last word in object!
	cmp	bx,ntemplates	; check against number of templates
	ja	badencode	; panic, bad encode
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


	mov	ax,es:[di+2]	; get lower part of x coord
	mov	[si],ax	
	mov	ax,curtilex	; get current x coord of tile
	mov	dx,tileszx	; multiply to get x bias on unverse
	mul	dx
	add	ax,universex	; now add the universe center coords
	mov	dx,es:[di]	; get compacted bits
	and	dx,tileszx-1	; strip off unwanted dumb bits
	add	ax,dx
	mov	[si+2],ax	; xcoord

	mov	ax,es:[di+4]	; get lower part of y coord
	mov	[si+4],ax	

	mov	ax,curtiley	; get current x coord of tile
	mov	dx,tileszy	; multiply to get x bias on unverse
	mul	dx
	add	ax,universey	; now add the universe center coords
	mov	dx,es:[di]	; get compacted bits
	mov	cl,5		; shift that sucker down
	ror	dx,cl		; so that now the y bits are lsbits
	and	dx,tileszy-1	; strip off unwanted dumb bits
	add	ax,dx
	mov	[si+6],ax	; ycoord

	mov	ax,es:[di+6]	; do the z too, except no universe bias,
	mov	[si+8],ax
	mov	ax,es:[di]	; get compacted bits
	mov	cl,10		; shift that sucker down
	ror	ax,cl		; so that now the y bits are lsbits
	and	ax,tileszy-1	; strip off unwanted dumb bits
	mov	[si+10],ax	; xcoord

	mov	ah,es:[di+8]	; yaw
	xor	al,al
	mov	[si+12],ax
	mov	ah,es:[di+9]	; pitch
	xor	al,al
	mov	[si+14],ax
	mov	ah,es:[di+10]	; roll
	xor	al,al
	mov	[si+16],ax

	mov	ax,es:[di+13]	; xvel
	mov	[si+46],ax
	mov	ax,es:[di+15]	; yvel
	mov	[si+48],ax
	mov	ax,es:[di+17]	; zvel
	mov	[si+50],ax

	mov	ax,es:[di+19]	; get timed object time value
	mov	[si+52],ax	; place in target
	mov	ax,es:[di+11]	; update object type
	mov	[si+24],ax

	clc
	ret
.endp

.proc	encodeobj	auto	; encodes an obj into compressed format
				; si is source, es:[di] is the target
	mov	ax,[si]	
	mov	es:[di+2],ax	; get lower part of x coord
	mov	ax,curtilex	; get current x coord of tile
	mov	dx,tileszx	; multiply to get x bias on unverse
	mul	dx
	add	ax,universex	; now add the universe center coords
	mov	bx,[si+2]	; get real xyz coords
;	mov	cx,[si]
;	sub	cx,ax		; we need only the difference
;	sbb	bx,dx
	sub	bx,ax
	and	bx,tileszx-1	; strip off any accidental bits
	mov	es:[di],bx
	mov	ax,[si+4]	
	mov	es:[di+4],ax	; get lower part of x coord
	mov	ax,curtiley	; get current x coord of tile
	mov	dx,tileszy	; multiply to get x bias on unverse
	mul	dx
	add	ax,universey	; now add the universe center coords
	mov	bx,[si+6]	; get real xyz coords
;	mov	cx,[si+4]
;	sub	cx,ax		; we need only the difference
;	sbb	bx,dx
	sub	bx,ax
	and	bx,tileszy-1	; strip off any accidental bits
	mov	cl,5
	rol	bx,cl
	or	es:[di],bx	; or in more bits

	mov	ax,[si+8]	; xfer lower part of z coord
	mov	es:[di+6],ax
	mov	bx,[si+10]	; get real xyz coords
	and	bx,tileszy-1	; strip off any accidental bits
	mov	cl,10
	rol	bx,cl
	or	es:[di],bx	; or in more bits

	mov	ax,[si+12]	; get rol pitch and yaw
				; but only make semi-accurate
	mov	es:[di+8],ah
	mov	ax,[si+14]	; get rol pitch and yaw
				; but only make semi-accurate
	mov	es:[di+9],ah
	mov	ax,[si+16]	; get rol pitch and yaw
				; but only make semi-accurate
	mov	es:[di+10],ah

	mov	ax,[si+24]	; get type info
	mov	es:[di+11],ax	; can't compact these bits

	mov	ax,[si+46]	; get velocities
	mov	es:[di+13],ax
	mov	ax,[si+48]	; get velocities
	mov	es:[di+15],ax
	mov	ax,[si+50]	; get velocities
	mov	es:[di+17],ax

	mov	ax,[si+52]	; get time left
	mov	es:[di+19],ax

	mov	ax,[si+72]	; get object type
	cmp	ax,ntemplates
	ja	encodepanic
	mov	es:[di+21],ax
	clc
	ret
encodepanic:
	mov	cs:cecode,40
	stc	
	ret
.endp

.proc	gettileadr	auto	; sets es:[di] to point to current tile
	mov	ax,curtiley
	mov	dx,nparaline
	mul	dx
	mov	bx,ax
	mov	ax,curtilex
	mov	dx,nparatile
	mul	dx
	add	ax,bx
	add	ax,memsegskip	; skip over the memseg area used by
				; the memseg med far table
	add	ax,memseg	; off course, add in memseg ptr itself
	mov	es,ax
	xor	di,di
	ret
.endp



.proc	qintile	auto		; this routinnce checks to see if
				; the object at [si] is within the tile
				; by curtilex and curtiley
	mov	dx,[si+2]	; get high part of x coord
	mov	ax,curtilex
	mov	cl,5
	sal	ax,cl
	add	ax,universex	; add in the origin of the universe
	sub	dx,ax		; subtract off tile beginning coord
	js	notintile
	sub	dx,32
	jns	notintile

	mov	dx,[si+6]	; get high part of y coord
	mov	ax,curtiley
	mov	cl,5
	sal	ax,cl
	add	ax,universey	; add in the origin of the universe
	sub	dx,ax		; subtract off tile beginning coord
	js	notintile
	sub	dx,32
	jns	notintile
	clc			; leave flag saying we are in like flynn
	ret
notintile:
	stc
	ret
.endp

IF 0
	.proc	prtcrds
	mov	ax,[si+24]
	call	wword
	mov	ax,si
	call	wword
	mov	ax,[si]
	mov	dx,[si+2]
	call	dwword
	mov	ax,[si+4]
	mov	dx,[si+6]
	call	dwword
	mov	ax,[si+8]
	mov	dx,[si+10]
	call	dwword
	mov	al,2dh
	call	put_chr
	ret
	.endp
ENDIF

.proc	farmmemseg	auto	; farms out all the 
				; appropriate data in mseg on screen
	call	gettileadr	; get address for start of tile in RAM
	mov	tileptr,di
	mov	ax,es
	mov	tileseg,ax
	xor	ax,ax
;  this caused loss of objects
;	mov	es:[di+11],ax	; in case there are no objects, zero 1st item
	mov	tobjcount,ax	; make sure we don't overload table
	mov	ax,memseg	; point to good location
	mov	es,ax
	mov	si,exptr	; get current pointer
	mov	cx,nmaxmedfar	; don't loop thru more than once
	mov	si,0		; start of buffer is zero
ffexpl1:	cmp	word ptr es:[si+24],0	; see if this bullet is active
	jz	fexpfree		; found one!
	push	cx
	push	es
	push	si
	mov	di,offset @dataseg:memobjbuf
	call	frommemseg
	mov	si,offset @dataseg:memobjbuf
IF 0
	mov	ax,[si+72]
	add	al,20h
	call	put_chr
ENDIF
	call	qintile	; is this object part of the current tile?
	mov	al,0
	jc	thisnot		; this one isn't, so skip it
	inc	tobjcount	; get count
	cmp	tobjcount,nobjtile-1	; have we filled the tile?
	jb	tcountfine	; no, we have room
	dec	tobjcount
	mov	al,1
	jmp	thisnot		; abort rest of whatever we do
tcountfine:
	mov	si,offset @dataseg:memobjbuf
	mov	di,tileptr	; reinstate tile ptr and seg
	mov	ax,tileseg
	mov	es,ax
	mov	word ptr es:[di+nbyteobj+11],0	; zero the next object
	call	encodeobj	; now encode the object
	jnc	noencerr
	mov	cs:cecode,41	; if error, reportit
	mov	al,2
	jmp	thisnot		; abort rest of whatever we do
	jmp	thisnot
noencerr:
	add	tileptr,nbyteobj	; advance tileptr
	pop	si
	pop	es
	mov	word ptr es:[si+24],0	; remove object from memseg table
	pop	cx
	jmp	fexpfree	; jump back into loop
thisnot:
IF 0
	add	al,78h
	call	put_chr
	call	prtcrds
ENDIF
	pop	si
	pop	es
	pop	cx
fexpfree:
	add	si,nbytexp	; if not, goto next bullet
	cmp	si,mseptrmx
				; but be careful not to go off the end
	jb	feptrok		; looks ok from here...
	jz	feptrok
	mov	si,0		; start of buffer is zero
feptrok:	
	loop	ffexpl2		; try again
	stc			; set error flag
	ret
ffexpl2:
	jmp	ffexpl1
	.endp

.proc	bringmemseg	auto	
	call	gettileadr	; get address for start of tile in RAM
	mov	tileptr,di
	mov	ax,es
	mov	tileseg,ax
	mov	tobjcount,0	; make sure we don't overload table
	mov	ax,memseg	; point to good location
	mov	es,ax
	mov	si,exptr	; get current pointer
	mov	cx,nmaxmedfar	; don't loop thru more than once
	mov	si,0		; start of buffer is zero
bfexpl1:	cmp	word ptr es:[si+24],0	; see if this bullet is active
	jnz	fnexpfree		; found one!
	cmp	tobjcount,nobjtile	; have we filled the tile?
	jae	bringinend		; yes, then end this sherade!
	push	cx
	push	es
	push	si
	mov	si,offset @dataseg:memobjbuf
	mov	di,tileptr	; reinstate tile ptr and seg
	mov	ax,tileseg
	mov	es,ax
	call	decodeobj	; now encode the object
	jnc	notendbring
	pop	si
	pop	es
	pop	cx
	jmp	bringinend
notendbring:
	add	tileptr,nbyteobj	; advance tileptr
	inc	tobjcount
	pop	si
	pop	es			; now point again to memseg med buf
	push	es
	push	si
	mov	di,si			; and move object into table
	mov	si,offset @dataseg:memobjbuf
	mov	cx,nbytexp		; prepare for string move
	cld
	rep	movsb
	pop	si
	pop	es
	pop	cx
fnexpfree:
	add	si,nbytexp	; if not, goto next bullet
	cmp	si,mseptrmx
				; but be careful not to go off the end
	jb	beptrok		; looks ok from here...
	jz	beptrok
	mov	si,0		; start of buffer is zero
beptrok:	
	loop	bfexpl1		; try again
	stc			; set error flag
	ret
bringinend:
	clc
	ret
.endp

.proc	updatect	auto	; this routine updates ctx & cty, the center
				; coords of the 4 square tyrst.  
	mov	ax,ox+2		; use ox, the x coord of the observer
	sub	ax,universex	; remove center offset from the tile calc 
	add	ax,tileszx/2	; to get average, add 1/2 first
	cwd	
	mov	bx,tileszx
	idiv	bx
	mov	ctx,ax		; oy+2/32 is the tile coordinate

	mov	ax,oy+2		; use ox, the x coord of the observer
	sub	ax,universey	; remove center offset from the tile calc 
	add	ax,tileszy/2	; to get average, add 1/2 first
	cwd	
	mov	bx,tileszy
	idiv	bx
	mov	cty,ax		; oy+2/32 is the tile coordinate
	ret
.endp

IF getunivbin
.public	gettilecrds
.proc	gettilecrds	auto	; this routine updates ctx & cty, the center
				; coords of the 4 square tyrst.  
	mov	ax,ox+2		; use ox, the x coord of the observer
	sub	ax,universex	; remove center offset from the tile calc 
	cwd	
	mov	bx,tileszx
	idiv	bx
	mov	curtilex,ax		; oy+2/32 is the tile coordinate

	mov	ax,oy+2		; use ox, the x coord of the observer
	sub	ax,universey	; remove center offset from the tile calc 
	cwd	
	mov	bx,tileszy
	idiv	bx
	mov	curtiley,ax		; oy+2/32 is the tile coordinate
	ret
.endp
ENDIF ; getunivbin

.proc	qtilefar	auto	; looks at the current tile (ctilex,ctiley)
				; to see if it is too far from cty,cty
				; carry is set if too far.
	mov	ax,ctx
	sub	ax,curtilex
	and	ax,0fffeh	; anything but 0 or 1 says too far!
	jnz	qtoofar
	mov	ax,cty
	sub	ax,curtiley
	and	ax,0fffeh	; anything but 0 or 1 says too far!
	jnz	qtoofar
	clc			; looks good
	ret
qtoofar:
	stc
	ret
.endp

.proc	getctstatusptr	auto	; gets a pointer to the correct byte in
				; the sector read array into bx

	mov	ax,curtilex
	or	ax,ax		; check for tile out of bounds
	js	givebogus
	cmp	ax,ntilesx
	jge	givebogus

	mov	ax,curtiley
	or	ax,ax		; check for tile out of bounds
	js	givebogus
	cmp	ax,ntilesy
	jge	givebogus

	mov	ax,curtiley
	mov	dx,ntilesx
	mul	dx
	add	ax,curtilex
	add	ax,offset @dataseg:ctstatus
	mov	bx,ax
	ret
givebogus:
	mov	bx,offset @dataseg:bogus
	mov	cs:cecode,42		; report violation
	ret
.endp

.proc	farmthem	auto	; check for need to flush tiles out to
				; the far field, and do so to those tiles
				; which need it.
	mov	si,offset @dataseg:ctiles	; point to table of cur tiles
	mov	cx,ndepth	; depth of table, set to four
farmthemloop:
	push	cx
	push	si

	mov	ax,[si]		; read curtilex
	mov	curtilex,ax
	or	ax,ax		; check for tile out of bounds
	js	tileclose
	cmp	ax,ntilesx
	jge	tileclose

	mov	ax,[si+2]		; read curtiley
	mov	curtiley,ax
	or	ax,ax		; check for tile out of bounds
	js	tileclose
	cmp	ax,ntilesy
	jge	tileclose

	call	qtilefar	; is this tile too far out?
	jnc	tileclose	; no, it is fine, ignore
	call	farmmemseg	; yes, then farm out to big memory
	call	getctstatusptr
	mov	byte ptr [bx],0	; and report the sector read status as cleared
tileclose:
	pop	si
	add	si,4
	pop	cx
	loop	farmthemloop
	ret
.endp


.proc	changethem	auto	; update the coords in ctiles to reflect
				; our possibly new coordinates
	mov	si,0		; use as a pointer to both tables
	mov	cx,ndepth	; depth of table, set to four
changethemloop:
	mov	ax,ctx		; this is the center of our 4 square tyrst
	add	ax,[si+offset @dataseg:ctileoffs]	; get offset
	mov	[si+offset @dataseg:ctiles],ax		; update ctiles array
	mov	ax,cty
	add	ax,[si+offset @dataseg:ctileoffs+2]	; get offset
	mov	[si+offset @dataseg:ctiles+2],ax	; update ctiles array
	add	si,4
	loop	changethemloop
	ret
.endp


.proc	bringthem	auto	; brings new tiles into memory as needed
	mov	si,offset @dataseg:ctiles	; point to table of cur tiles
	mov	cx,ndepth	; depth of table, set to four
bringthemloop:
	push	cx
	push	si

	mov	ax,[si]		; read curtilex
	mov	curtilex,ax
	or	ax,ax		; check for tile out of bounds
	js	alreadyreadin
	cmp	ax,ntilesx
	jge	alreadyreadin

	mov	ax,[si+2]		; read curtiley
	mov	curtiley,ax
	or	ax,ax		; check for tile out of bounds
	js	alreadyreadin
	cmp	ax,ntilesy
	jge	alreadyreadin

	call	getctstatusptr	; make sure the tile is read into memory
	mov	al,[bx]
	or	al,al
	jnz	alreadyreadin
				; uh oh, we need to read in this tile!
	push	bx
	call	bringmemseg	; bring in that tile!
	pop	bx
	mov	byte ptr [bx],-1	; say that we have read it
alreadyreadin:
	pop	si
	add	si,4
	pop	cx
	loop	bringthemloop
	ret
.endp


.proc	dotiles	auto		; this is the main routine to handle the
				; bringing and farming of tiles.
	call	updatect	; first check for perhaps new tile coords
	call	farmthem	; then check if we need to flush old tiles
	call	changethem	; now see about new coords for tyrst
	call	bringthem	; if any need to be read in, then do it
	ret
.endp

IF printflag
.proc	printctstatus	auto
	mov	cx,ntilesy
pctlpy:
	push	cx
	mov	ax,cx
	neg	ax
	add	ax,ntilesy
	mov	curtiley,ax
	call	wcr
	mov	al,53h
	call	put_chr
	call	wcr
	mov	cx,ntilesx
pctlpx:
	push	cx
	mov	ax,cx
	neg	ax
	add	ax,ntilesx
	mov	curtilex,ax
	call	getctstatusptr
	mov	al,[bx]
	xor	ah,ah
	call	wword
	pop	cx
	loop	pctlpx

	pop	cx
	loop	pctlpy
	call	wcr
	ret
.endp
ENDIF

IF printflag
.proc	printobj	auto
	call	wcr
	cmp	word ptr [si+24],0	; is object there
	jz	pobjmissing
	mov	ax,[si+72]
	call	wword
	mov	ax,[si]
	mov	dx,[si+2]
	call	dwword
	mov	ax,[si+4]
	mov	dx,[si+6]
	call	dwword
	mov	ax,[si+8]
	mov	dx,[si+10]
	call	dwword
	mov	ax,si
	call	wword
	mov	ax,[si+24]
	call	wword
	mov	al,[si+18]
	xor	ah,ah
	call	wword
	ret
pobjmissing:
	mov	al,4dh
	call	put_chr
	ret	
.endp
ENDIF


IF printflag
.proc	printtables	auto	; this routine flushes a tile, taking the
				; data from all tables, near med near, med
				; and far.  The data will go to the segemnt
				; and addr in tileseg, and tileptr.  This
				; routine will NOT empty the table of items
				; taken from it.
;	mov	cx,1		; draw all four tables, yes, include fartble
	mov	cx,4		; draw all four tables, yes, include fartble
	mov	si,offset @dataseg:tblist
;	add	si,2		; point to far table first
	add	si,6		; point to far table first
pflushlp:	push	cx		; save loop index
	call	wcr
	push	si
	mov	si,offset @dataseg:ptablesmsg
	call	put_str
	pop	si
	mov	ax,cx
	neg	ax
	add	ax,6
	call	wword
	call	wcr
	push	si
	mov	si,[si]		; get list address
	mov	tbstrt,si	; save table origin in variable
	mov	cx,[si]		; standard length 
	mov	bx,tbstrt	; start of table
	add	bx,4		; make bx point to data area
	or	cx,cx		; check for empty table
	jnz	pfldrwnrlp
	push	si
	mov	si,offset @dataseg:emptytblmsg
	call	put_str
	pop	si
	jmp	pfldrwnrdn		; if so, then were already done
pfldrwnrlp:
	push	bx
	push	cx
	mov	si,[bx]		; get start address of object
	call	printobj
	pop	cx
	pop	bx
	add	bx,2
	loop	pfldrwnrlp
pfldrwnrdn:
	pop	si
	sub	si,2		; advance to next table in list
	pop	cx		; get list count
	loop	pflushlp
	ret
.endp
ENDIF

.proc	flushtile	auto	; this routine flushes a tile, taking the
				; data from all tables, near med near, med
				; and far.  The data will go to the segemnt
				; and addr in tileseg, and tileptr.  This
				; routine will NOT empty the table of items
				; taken from it.
	mov	cx,1		; draw all four tables, yes, include fartble
	mov	si,offset @dataseg:tblist
;	add	si,6		; point to far table first
flushlp:	push	cx		; save loop index
	push	si
	mov	si,[si]		; get list address
	mov	tbstrt,si	; save table origin in variable
	mov	cx,[si]		; standard length 
	mov	bx,tbstrt	; start of table
	add	bx,4		; make bx point to data area
	or	cx,cx		; check for empty table
	jnz	fldrwnrlp
	jmp	fldrwnrdn		; if so, then were already done
fldrwnrlp:
	push	bx
	push	cx
	mov	si,[bx]		; get start address of object
	cmp	word ptr [si+24],0	; is object there
	jz	objmissing
	mov	ax,[si+72]	; get object type to chech extended table
	add	ax,ax		; make into a word address
	push	si
	mov	si,offset @dataseg:extendedtypetbl
	add	si,ax
	test	word ptr [si],1		; check save bit
	pop	si
	jnz	objmissing	; skip saving it, we don't have to save these
	cmp	tobjcount,nobjtile-1	; have we filled the tile?
	jae	objmissing		; yes, then end this sherade!
	inc	tobjcount
	call	qintile			; verify that this object is in
	jc	objmissing		; this tile
	push	si			; save original object address
	mov	ax,tileseg	; get address of tile into es:[di]
	mov	es,ax
	mov	di,tileptr
	mov	word ptr es:[di+nbyteobj+11],0	; clear object after this
	call	encodeobj	; encode it into the nice space
	add	tileptr,nbyteobj
	pop	si
	mov	word ptr [si+24],0	; remove object from timed object table

;  The following line was commented out for reasons I don't understand
; I'm going to bring it back in to stop these terrible failures

	mov	byte ptr [si+18],-1	; mark as fully flushed
objmissing:
	pop	cx
	pop	bx
	add	bx,2
	loop	fldrwnrlp
fldrwnrdn:
	pop	si
	sub	si,2		; advance to next table in list
	pop	cx		; get list count
	loop	flushlp
	ret
.endp



.proc	flushtiles	auto	; this routine will flush all the object
				; tables to the big memseg area
				
	call	updatect
	call	changethem	; point to current neighboring towelheads
	mov	si,offset @dataseg:ctiles	; point to table of cur tiles
	mov	cx,ndepth	; depth of table, set to four
flushthemloop:
	push	cx
	push	si

	mov	ax,[si]		; read curtilex
	mov	curtilex,ax
	or	ax,ax		; check for tile out of bounds
	js	fltileclose
	cmp	ax,ntilesx
	jge	fltileclose

	mov	ax,[si+2]		; read curtiley
	mov	curtiley,ax
	or	ax,ax		; check for tile out of bounds
	js	fltileclose
	cmp	ax,ntilesy
	jge	fltileclose

	call	farmmemseg	; flush the memseg med table

	call	flushtile	; flush this current tile

	call	getctstatusptr	; get the address of the status of tile
	mov	byte ptr [bx],0	; show this tile as written out

fltileclose:
	pop	si
	add	si,4
	pop	cx
	loop	flushthemloop
	mov	si,offset @dataseg:tblist
	mov	bx,[si]		; get starting address of all tables
	mov	word ptr [bx],0		; put number of elements to zero
;	call	cleanexp		; empty out the timed object table
;	mov	bx,[si+2]		; get starting address of all tables
;	mov	word ptr [bx],0		; put number of elements to zero
;	mov	bx,[si+4]		; get starting address of all tables
;	mov	word ptr [bx],0		; put number of elements to zero
;	mov	bx,[si+6]		; get starting address of all tables
;	mov	word ptr [bx],0		; put number of elements to zero
	ret
.endp

.proc	copytile	auto		; copies a tile from on place to 
					; another
					; ax has source segment address
					; bx has target segment address
	push	ds
	mov	ds,ax
	mov	es,bx
	xor	di,di
	xor	si,si
	mov	cx,nobjtile*nbyteobj
	cld	
	rep movsb
	pop	ds
	ret
.endp

.proc	copy4tiles	auto		; copies 4 tiles
	mov	si,offset @dataseg:ctileoffs
	mov	cx,4
	mov	ax,curtilex
	mov	bx,curtiley
copyloop:
	push	si
	push	ax
	push	bx
	push	cx
	mov	curtilex,ax	
	mov	curtiley,bx	
IF copydiag EQ 1
	call	wcr
	mov	al,24h
	call	put_chr
ENDIF
	mov	ax,[si]
	add	curtilex,ax
IF copydiag EQ 1
	mov	ax,curtilex
	call	wword
ENDIF
	mov	ax,[si+2]
	add	curtiley,ax
IF copydiag EQ 1
	mov	ax,curtiley
	call	wword
ENDIF
	call	gettileadr
	mov	ax,es
	mov	tileseg,ax
;	call	getctstatusptr
;	mov	byte ptr [bx],-1		; mark as un-updated

	mov	ax,majorx
	add	ax,[si]
	mov	curtilex,ax
IF copydiag EQ 1
	call	wword
ENDIF
	mov	ax,majory
	add	ax,[si+2]
	mov	curtiley,ax
IF copydiag EQ 1
	call	wword
ENDIF
	call	gettileadr
	mov	ax,es
	mov	bx,ax
	mov	ax,tileseg
	call	copytile
	call	getctstatusptr
	mov	byte ptr [bx],0		; mark as updated

	pop	cx
	pop	bx
	pop	ax
	pop	si
	add	si,4
	loop	copyloop
	mov	curtilex,ax
	mov	curtiley,bx
	ret
.endp

.proc	copyuniv	auto
	mov	ax,ctx
	mov	curtilex,ax
	mov	ax,cty
	mov	curtiley,ax
	mov	si,offset @dataseg:univoffs
	mov	cx,8
cpunivlp:
	push	si
	push	cx
IF copydiag EQ 1
	call	wcr
	mov	al,4dh
	call	put_chr
ENDIF
	mov	ax,[si]
	mov	majorx,ax
IF copydiag EQ 1
	call	wword
ENDIF
	mov	ax,[si+2]
	mov	majory,ax
IF copydiag EQ 1
	call	wword
ENDIF
call	copy4tiles
	pop	cx
	pop	si
	add	si,4
	loop	cpunivlp
	ret
.endp

.proc	drawmap	auto	; brings new tiles into memory as needed
IF mapmbflag EQ 1
	mov	tobjdist+2,3fffh	; make a real big number
	mov	distseg,0		; guard against no close items
ENDIF
	mov	cx,ntilesy
dmyloop:
	push	cx
	mov	ax,cx
	neg	ax
	add	ax,ntilesy
	mov	curtiley,ax
	mov	cx,ntilesx
dmxloop:
	push	cx
	mov	ax,cx
	neg	ax
	add	ax,ntilesx
	mov	curtilex,ax
	call	gettileadr	; get address for start of tile in RAM
	mov	ax,es
	mov	tileseg,ax
	mov	tileptr,di

	mov	cx,nobjtile
innerdloop:
	push	cx

	mov	si,offset @dataseg:memobjbuf
	mov	di,tileptr	; reinstate tile ptr and seg
	mov	ax,tileseg
	mov	es,ax
	call	decodeobj	; now encode the object
	jc	endoftile		; endoftile
	mov	si,offset @dataseg:memobjbuf
	call	d3dobj		; draw object
	add	tileptr,nbyteobj
	pop	cx
	loop	innerdloop
backintoloop:
	pop	cx
	loop	dmxloop
	pop	cx
	loop	dmyloop
	ret
endoftile:
	pop	cx
	jmp	backintoloop
.endp

.proc	gettilesize	auto		; finds number of objects in tile
					; and leaves, pointing to the first
					; empty tile with es:[di]
					; nobjects is left in headersz var
	mov	headersz,0
	mov	cx,nobjtile-1
ptllp:
	cmp	word ptr es:[di+11],0
	jz	skipthis
	inc	headersz
	add	di,nbyteobj
	loop	ptllp
skipthis:
	ret
.endp

.proc	fillheader	auto
	mov	ax,curtilex
	mov	headerx,ax
	mov	ax,curtiley
	mov	headery,ax
	call	gettileadr
	call	gettilesize
	ret
.endp

.proc	getheader	auto
	mov	ax,word ptr header
	cmp	ax,06950h		; check for Pie embedded in header
	mov	ax,word ptr header+2
	cmp	ax,00065h
	jnz	headererr
	mov	ax,headerx
	mov	curtilex,ax
	mov	ax,headery
	mov	curtiley,ax
	clc
	ret
headererr:
	stc
	ret
.endp

IF mapmbflag EQ 1
.proc	mbdrawnear	auto	; draws all the objects in the near table
				; and then sorts table
	mov	cx,1		; draw all four tables, yes, include fartble
	mov	si,offset @dataseg:tblist
;	add	si,6		; point to far table first
mblistlp:	push	cx		; save loop index
	push	si
	mov	si,[si]		; get list address
	mov	tbstrt,si	; save table origin in variable
	mov	cx,[si]		; standard length 
	mov	bx,tbstrt	; start of table
	add	bx,4		; make bx point to data area
	or	cx,cx		; check for empty table
	jnz	mbdrwnrlp
	jmp	mbdrwnrdn		; if so, then were already done
mbdrwnrlp:
	mov	si,[bx]		; get start address of object
	mov	al,[si+18]	; get present distance near/far code
;	mov	lastdrawncx,al
	xor	ah,ah
	mov	odcode,ax
	push	bx		; save all crap
	push	cx
	push	si
;	call	qtimed		; try a timed object call
	test	word ptr [si+24],400h
	jz	justdrawobj
	test	cs:oticks,512
	jz	skipdrawobj
justdrawobj:
	cmp	nomoveflag,0	; do we really draw it?
	jz	oktodraw
	call	disteval	; get coords relative to viewer coords
	jmp	skipdrawobj
oktodraw:
	call	d3dobj		; draw the object
skipdrawobj:
	pop	si


	cmp	word ptr [si+24],0  ; see if object is active
	jnz	mbobact		; it is

	mov	bx,si		; this points to our object
	push	bx		; save current ptr
	mov	si,tbstrt	; save current tbstrt
	push	si
	call	tbrmv		; remove object from this table
	pop	si
	mov	tbstrt,si
	pop	si
	pop	cx
	pop	bx
	jmp	mbsameol1
	
mbobact:
	jmp	mbsameole
;	cmp	nomoveflag,0
;	jnz	mbsameole

	mov	ax,odcode
	cmp	[si+18],al	; compare old dcode to new one
	jz	mbsameole		; same old distance code, so continue
	mov	ah,[si+18]
;	mov	lastdrawncx+1,ah
;	mov	lastdrawn,si
				
				; now the object needs to be removed from
				; the current list, and placed in the new
				; list
	mov	bx,si		; this points to our object
	push	bx		; save current ptr
	mov	si,tbstrt	; save current tbstrt
	push	si
	push	bx		; save object address
	call	tbrmv		; remove object from this table
	pop	bx		; restore object address
	push	ax
	mov	al,[bx+18]	; find out which list it wants to be on
	cmp	al,4
	js	mbtoofarpanic	; if wants to go into fourth list, panic
	jmp	mbtoofarpanic1
mbtoofarpanic:
	xor	ah,ah
	mov	di,ax
	add	di,di		; make it 0,2,4,6
	pop	ax
	mov	si,[di+offset @dataseg:tblist]	; get proper list
	call	tbadd		; add it to this list
	pop	si		; restore list info
	mov	tbstrt,si
	pop	si		; restore si pointer

	pop	cx
	pop	bx		; do same stuff as sameole, but don't advance
				; to next pointer entry
	jmp	mbsameol1
mbdrwnrlp1:
	jmp	mbdrwnrlp
mbsameole:
	pop	cx
	pop	bx
	add	bx,2
mbsameol1:
	loop	mbdrwnrlp1

	mov	si,tbstrt
	call	tbsort
mbdrwnrdn:
	pop	si
	sub	si,2		; advance to next table in list
	pop	cx		; get list count
	loop	mblistflp
	ret
mblistflp:	jmp	mblistlp
mbtoofarpanic1:
	mov	cs:cecode,26
	pop	ax
	pop	si
	pop	si
	pop	cx
	pop	bx
	jmp	mbsameol1
.endp
ENDIF

.ends
	end

