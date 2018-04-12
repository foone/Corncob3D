
MVPCD	equ	0

soundflag	equ	0		; =0 means sound enabled
leftmarg	equ	20
printflag	equ	0
testerflag	equ	1
qrocket	equ	1
protection	equ	0
errortrap	equ	1
getunivbin	equ	1	; set to one to include univbin data

demover	equ	0

wxmin	equ	0
wymin	equ	2
wxmax	equ	4
wymax	equ	6
wxsiz	equ	8
wysiz	equ	10
zxpln	equ	12
zypln	equ	14
wxctr	equ	16
wyctr	equ	18
ymindi	equ	20
ymaxdi	equ	22

x	equ	0
y	equ	2
z	equ	4

vysfn	equ	350
yysfd	equ	454

xpix	equ	640
ypix	equ	350
xpixm1	equ	xpix-1
ypixm1	equ	ypix-1

nbytvec	equ	6
nbuls	equ	32		; maximum number of bullets possible
nbytebul	equ	74
bmtime	equ	5
exptime	equ	180
expdisp	equ	20
expdamp	equ	16000
exptick	equ	254
mistime	equ	100
bombtime	equ	3200
nexps	equ	320		; maximum number of explosiv pieces 
nbytexp	equ	74
dballtime	equ	24000
dballrest	equ	100
aashelltime	equ	150
aashelltime2	equ	30
dbrestspin	equ	12000
dballtime2	equ	dballtime-dballrest
omnitime	equ	18
dbsz	equ	400
dbsz2	equ	dbsz/2
dbsz13	equ	dbsz*13/15
roadx	equ	-10


l	equ	60
l2	equ	l/2
lo2	equ	l/2
lo6	equ	l/6
l4	equ	l*4
ls6	equ	l*20/23
lw	equ	l*2
lu	equ	3*l/2

w	equ	2000

xgmx	equ	3100
xgmx2	equ	xgmx/2
xgmx4	equ	xgmx/4
xgmx2a	equ	xgmx*5/12
xgmx8	equ	1819
ngmo	equ	15
nbgm	equ	74

wallsz	equ	16383
wallsz2	equ	wallsz/2

vesz	equ	750
vesz2	equ	vesz/2
vesz86	equ	vesz*13/15
veszht	equ	vesz2*4/7
veszwh	equ	vesz*4/7

p	equ	4*l/2
pl	equ	4*l

ltw	equ	900
ltwl	equ	ltw*3
ltwl2	equ	ltwl/2
ltwlo2	equ	ltwl/2
ltwl86	equ	ltwl/2*13/15	; .86666
ltwla	equ	ltw*3*4/3
ltwlo2a	equ	ltwl/2*4/3
ltwl86a	equ	ltwl/2*13/15*4/3	; .86666

twsz	equ	1000
twszl	equ	8000

lhq	equ	2800
lhql	equ	lhq*3
lhqlo2	equ	lhql/2
lhql86	equ	lhql/2*13/15	; .86666
lhqla	equ	lhq*3*4/3
lhqlo2a	equ	lhql/2*4/3
lhql86a	equ	lhql/2*13/15*4/3	; .86666

epitchmin	equ	-1500

nmaxmedfar	equ 	884
mseptrmx	equ	nbytexp*nmaxmedfar


ntilesx	equ	8
ntilesy	equ	8
maxtilex	equ	ntilesx-1
maxtiley	equ	ntilesy-1
tileszx	equ	32
tileszy	equ	32

nbyteobj	equ	23
nobjtile	equ	150
nparatile	equ	(nbyteobj*nobjtile+15)/16
nparaline	equ	nparatile*ntilesx
memsegskip	equ	(nbytexp*nmaxmedfar+15)/16
nheaderbytes	equ	16


ehmin		equ	4*3*l		; lowest that plane can be
bbsize	equ	16383
bbsize2	equ	bbsize/2

morttime	equ	10000
mortrechargetime	equ	6

ethstal	equ	2912
ethstl2	equ	ethstal*2
efthstal	equ	2912*4/3
efthstl2	equ	efthstal*2
ethrtsf		equ	450		; scale factor for throttle thrust
edthrtsf	equ	350		; give us much less engine power
bmrhits		equ	50

bomblst	equ	6000
hqhits	equ	65
jumpmax		equ	1024		; two seconds of jump charging

DUPPERLEFT	equ	201
DTOP		equ	205
DUPPERRIGHT	equ	187
DLEFT		equ	186
DRIGHT		equ	186
DLOWERLEFT	equ	200
DBOTTOM		equ	205
DLOWERRIGHT	equ	188

