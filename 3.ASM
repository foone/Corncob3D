

avgthrot	equ	1

jdiag		equ	1
qtables	equ	1
dampflag	equ	0
demorec	equ	1
delomegflag	equ	0
fadeflag	equ	1
finalscreen	equ	0
larryflag	equ	0
stestflag	equ	0
xlatflag	equ	0
leavegraf	equ	0		; ieee! turn this off!
diagflag	equ	0
fptrdiag	equ	0
simpflag	equ	1
chopchop	equ	0
sofsrc		equ	1
userflag	equ	0


IF shareflag EQ 0
newthtflag	equ	0
nodemo		equ	0
ELSE
newthtflag	equ	1
nodemo		equ	1
ENDIF

xrv	equ	3
lrv	equ	3

;FILE:	ITHINK.ASM
;
;DESC:	Sample program from page 30 of the manual.
;
;NOTES:	Created using the MAIN.XXX skeleton file.
;=============================================================================

_MODEL	equ	<SMALL>

include		MODEL.INC
include		imath.INC
include		f3dequ.inc
include		3dvid.inc
include		pixaddr1.inc
include		3dmac.inc
include		usermac.inc
include		3macs.inc

include		ka.inc
;slalom		equ	1
;guns		equ	0    ; no guns when 0


IF slalom
mapmbflag	equ	0
ELSE
IF mbflag
mapmbflag	equ	1
ELSE
mapmbflag	equ	0
ENDIF
ENDIF

dbndck	macro	high,low
	local	lok1,lok2
	cmp	dx,high
	js	lok1
	mov	dx,high
lok1:	cmp	dx,low
	jns	lok2
	mov	dx,low
lok2:
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

tickpower	equ	8		; 2**8 is 256
tickfactor	equ	64		; 256 x normal timer tick rate
tickf4		equ	tickfactor/4
tickf16		equ	tickfactor/16
tickdiv		equ	16384/tickf4



;.codeseg	lib
.extrn		start:AUTO, exit:AUTO, exit_ok:AUTO
.extrn		open_h:auto,close_h:auto,write_h:auto,read_h:auto
.extrn		lseekbof_h:auto
.extrn		get_ecode:auto
.extrn		tmr_read:auto,tmr_reset:auto
.extrn		get_version:auto,arg_count:auto
.extrn		get_chr:auto
.extrn		words_to_dec:auto
.extrn		dword_to_dec:auto
.extrn		dwords_to_dec:auto
.extrn		word_to_hex:auto,word_to_dec:auto
.extrn		put_str:AUTO,put_chr:auto,check_key:auto,put_newline:auto
.extrn		init_msec:auto,sleep_msec:auto
;.extrn		set_timer0:auto,reset_timer0:auto,
.extrn		get_timer0mode:auto
.extrn		sound_beep:auto
.extrn		far_init:auto,far_malloc:auto,far_free:auto,far_avail:auto
.extrn		rand_init:auto,randr_w:auto,rand_w:auto
.extrn		rand_seed:word
.extrn		shrink_prog:auto
.extrn		exec_prog:auto,dword_to_asc:auto
.extrn		get_adapter:auto
.extrn		flush_keys:auto
.extrn		divrs_dw:auto
.extrn		tmr_read:auto	; gets msec timer info
.extrn		tmr_reset:auto	; begins a new timing sequence
.extrn		calcsin:auto	; calcs angles for matrix calculation
.extrn		negsin:auto	; reverses angle of rotation sins
.extrn		calcmat:auto	; calcs a rotation matrix
.extrn		ncalcmat:auto	; calcs the inverse of a rot matrix
.extrn		wrtmat:auto	; writes a matrix on screen
.extrn		wrtvec:auto	; guess, Einstein!
;.extrn		rotobj:auto	; rotates the coords of an object
.extrn		flipage:auto	; flips to the alternate page of video
.extrn		get_vect:auto	; gets interupt vect
.extrn		set_vect:auto
IF getunivbin
.extrn	gettilecrds:auto
.extrn	tileptr:word,tobjcount:word
.extrn	bringmemseg:auto
.extrn	tomemseg:auto
.extrn	farmmemseg:auto,qintile:auto,fdexpobj:word
.extrn	putbackintable:auto
.extrn	getfromtemplate:auto
ENDIF
.extrn		sin:auto	; calculates sin
.extrn		cos:auto	; calculates sin
.extrn		ssin:auto	; calculates signed sin
.extrn		scos:auto	; calcs signed cos
.extrn		negflg:byte	; sign of result
.extrn		d3dobj:auto	; draws a 3d object
.extrn		drawdirect:auto	; draws a object, in space directly
.extrn		drawrdirect:auto	; draws a object, rotated directly
.extrn		g3dobj:auto	; draws a 3d object
.extrn		rel3d:auto	; find vector from object to plane
.extrn		atn:auto
.extrn		atn2:auto
.extrn		orot:word
.extrn		orotptr:word
.extrn		norotptr:word
.extrn		norot:word
.extrn		omat:word
;.extrn		matdet:auto
.extrn		modhr:auto
.extrn		getang:auto
.extrn		rolpln:auto
.extrn		epage:auto
.extrn		matvmul:auto
.extrn		divs_dw:auto,muls_dw:auto
.extrn		rolmat:word
;.extrn		rimg:auto,rimgall:auto
.extrn		cmdline:auto
.extrn		drawndles:auto,erasndles:auto,drawgs:auto
.extrn		ysign:word
.extrn		drawnear:auto,copytable:auto,drawmemseg:auto
.extrn		tbadd:auto
.extrn		tblist:word
.extrn		scrfbx:auto
.extrn		f3dline:auto
.extrn		strtadr:auto
.extrn		dsqrt:auto
IF vgmode EQ 81h
.extrn		hgcline:auto
ENDIF
.extrn		vmag:auto
.extrn		x1vec:word
.extrn		x2vec:word
.extrn		x1mag:word
.extrn		x2mag:word
.extrn		xdot:word
.extrn		xdots:word
.extrn		xvx:word
IF slalom
.extrn		incondest:auto
ENDIF
.extrn		pufftim:auto,boomtim:auto,mistim:auto,dballtim:auto,flttim:auto
.extrn		strtpuff:auto,strtflt:auto,strtdball:auto,strtmis:auto
.extrn		strtperm:auto
.extrn		strtdbst:auto,strtvech:auto,strtvest:auto
.extrn		strtbomb:auto,bombtim:auto,strtshard:auto,strtbomb1:auto
.extrn		strtboom:auto,objmov:auto,expmov:auto,aatim:auto,strtaa:auto
.extrn		strtperm:auto
.extrn		radardot:auto,aashelltim:auto
.extrn		drawbutton:auto,drawdamage:auto,flashdamage:auto
.extrn		damindicinit:auto	
.extrn		drawairtick:auto,clearticks:auto,drawelvtick:auto
.extrn		drawrdrtick:auto,drawpoly:auto
IF printflag
.extrn		exps:word
.extrn	expsrmvd:word
.extrn		neartbl:word
.extrn		polylegal:auto
.extrn		randlegalpoly:auto,dotpoly:auto
ENDIF
.extrn		f3dpoly:auto
.extrn		drpoly:auto
.extrn		nsides:word
.extrn		sunsz1:word,sunsz2:word,sunclr:byte
.extrn		pzmax:word,pzmin:word,tmpbuf:word,tmp2buf:word,pzminbx:word
.extrn		testpoly:word
.extrn		plnplyobj:word,propobj:word,objsun:word,hqobj:word
.extrn		plnplyobjsm:word
.extrn		rdrobj:word,twobj:word
.extrn	roadobj:word
.extrn	manobj:word,maxndballs:word,dmanobj:word
.extrn	curndballs:word
.extrn	haltox:word,haltflag:byte,rescueflag:byte
.extrn	saucerdist:word,ssfreq:byte
.extrn	orbdist:word,orbfreq:byte,kladist:word,klaqual:byte
.extrn	readcolors:auto,setcolors:auto,distcolors:auto,setskygnd:auto
.extrn	packbits:auto
.extrn	objwallx:word,objwally:word,objwallz:word
.extrn	initialqual:word
.extrn	maxnvechs:word,nvechs:word
.extrn	objflt1dball:word,lobjflt1dball:word,sobjflt1dball:word
.extrn	objflt1boom:word
.extrn	objflt2boom:word
.extrn	objflt3boom:word
.extrn	clrf1:byte,clrf2:byte,clrd1:byte,clrd2:byte,clrd3:byte,clrd4:byte
.extrn	clrtwr:byte,clrhq:byte,sunclr:byte
.extrn	sdsph:word,sdsph1:word,smsph1:word,smsph:word
.extrn	flsmph1:word,flsmph:word
.extrn	bullets:word,bptrmx:word,gms:word
.extrn	odest:auto
.extrn	obj5d:word,objprop:word
.extrn	funeral5d:auto,evaldist:auto
.extrn	initperms:auto
.extrn	decodeobj:auto,encodeobj:auto,memobjbuf:word,bringmemseg:auto
.extrn	farmmemseg:auto
.extrn	curtilex:word,curtiley:word,getctstatusptr:auto,gettileadr:auto
.extrn	ctx:word,cty:word,flushtiles:auto,updatect:auto,changethem:auto
.extrn	ctiles:word,dotiles:auto,universex:word,universey:word
.extrn	copyuniv:auto
.extrn	z0:word,z0factor:word,drawmap:auto,objman1:word
.extrn	header:byte,headerx:word,headery:word,headersz:word
.extrn	fillheader:auto,getheader:auto
.extrn	initnumbers:auto,mdsclr1:byte
.extrn	dec_to_dwords:auto,str_skipw:auto
.extrn	egaline:auto

IF printflag
.extrn	printobj:auto,printtables:auto
.extrn	printctstatus:auto
ENDIF

IF mapmbflag EQ 1

.extrn	distseg:word,distptr:word
ENDIF
.extrn	temp1:word,temp2:word,ardvark:word,temp4:word


;IF 1 EQ 0
.extrn	fltsm1:word,fltsm2:word,fltsm1boom:word,fltsm1dball:word
.extrn	fltsm1aa:word,fltsm1aashell:word
.extrn	fltsm1mis:word,fltsm1puff:word,fltsm1bomb:word
.extrn	objhq:word,sunobj:word
.extrn	obj5da:word
.extrn	objtw:word,objrdr:word,tower:word
.extrn	roadpiece:word
.extrn	objman:word
.extrn	maploop:auto,bumpangles:auto
;ENDIF
.extrn	cleanexp:auto
.extrn	ndeadhqs:word,curndeadhqs:word
.extrn	printexp:auto,nflt:word
.extrn	rescuestart:auto,maxnrvs:word
.extrn	bdest:auto
.extrn	dballlock:word,expobj:word,xpflag:byte
.extrn	ntets:word,haluclrs:word,tripflag:byte
.extrn	building:word,brdrclr:byte
IF protection
.extrn	drawball:auto,ballx:word,bally:word,vbally:word
ENDIF
.extrn	nbmrs:word,nbmrst:word
.extrn	hashregcode:auto,unhashregcode:auto
.extrn	colors:byte,rescolors:byte
.extrn	groundcolors:byte,skycolors:byte
.extrn	dballprog:word,aaprog:word,rollprog:word,nkillmetough:word
.extrn	deathcoords:word

.extrn	oprclr1:byte

IF soundflag EQ 0
.extrn	adldelay:auto,adlwdelay:auto,adldelayinit:auto,adlwrt:auto
.extrn	adlseq:auto,adlreginit:auto,voiceon:auto
.extrn	voiceoff:auto,engineinit:auto,guninit:auto,boominit:auto
.extrn	snareinit:auto,initsound:auto,blaminit:auto
.extrn	bassinit:auto,snaresnd:auto,scrapeinit:auto
.extrn	windinit:auto,windflag:byte,initvoices:auto,nwait:word
.extrn	bigboom:auto,screechinit:auto,saucerinit:auto,orbinit:auto
ENDIF

IF MVPCD EQ 1
.extrn	str_cat:auto
.extrn	str_cpy:auto
ENDIF

.extrn	pict:auto

	public	brdrcnt
	public	ox
	public	oy
	public	oz
	public	orvec
	public	oxeff
	public	oyeff
	public	ozeff
	public	orveceff
	public	argx1		; this are the x1,y1,x0,y0 input coords
	public	argy1
	public	argx2
	public	argy2
	public	n
	public	vboff
	public	pgflg		; which flag is it?
	public	regflg
	public	hrobj
	public	hrflg		; flag for are we drawing horizon
	public	fillflg
	public	gndcolor
	public	hrwr1
	public	gwinr
	public	gwinl
	public	ptrgwinf
	public	ptrgwint
	public	topv
	public	rtopv
	public	rpmx
	public	rpm
	public	dxvec	; distance away of ground point
	public	xvec	; coordinates for a drawdirect call
	public	xvec1	; coordinates for a drawdirect call
	public	etemp
	public	opres
	public	win0
	public	dticks
	public	frmnum
	public	cecode
	public	wword
	public	hwword
	public	decwword
	public	wsp
	public	crshflg
	.public	ejectflag,onrunwayflag,closetowerflag,groundflag,newguyflag
	.public	redamageflag,intowerflag,drawmemflag,demoflag,advflag
	.public	exitflag,remoteflag
	public	damage
.public		omniflag
.public		objdisp,tckgrav,objdamp,ndballs
.public	dorot
.public	dnrot
.public	ndest,nfdest
.public	nplaneslost,ndballsdest,naasdest,nvechsdest,nsitesdest,nhqsdest
.public	norbsdest,patchcrash
.public	maxaaonme,maxdbonme
.public	missionstatus
.public	ondest
.public	bulyoff,misyoff,ctopv,dtopv,ofrmticks,ticksf,frmticks,scncode
;.public	soundtick
.public	deathcode
.public	damageplane,shakecnt,instflag,oticks
;	public	dotflg		; 0=solid line -1=dotted line
IF slalom
	.public	radarstat,oldradarstat
ENDIF
.public	nnzmat,nzmat
.public	joyflag,keyflag,easyflag,diagflg,invincible,jctrflag
.public	actionflag,slowflag,readfileflag,chainflag,rundemoflag,aceflag
IF getunivbin
.public gubflag
ENDIF
.public	aeroflag,rmsgflag
.public	totaldamage,qtimeinc
.public	naas,nvest,ndbst,qualaa,qualvest,qualdbst
.public	kbuf,hmin
.public	freezeflag,grand
.public	memseg,memsegtotal,diaglb8
.public	dwword
.public	joytd,getkbit
.public	moveobs,otopv,surfacev
.public	maxofrm,minofrm,wcr
.public	startcoords,getinplane,lastplaneflown,zground,myzground
.public	curtower
IF printflag
.public	lastdrawn
.public	lastdrawncx
ENDIF
.public viewkludge,desireflag,cmpltflag
.public fadecolor
.public	shutdown,recalcmats,nregcode,nregcodeh,tempsum
.public	clnregcode,clnregcodeh
IF errortrap
public	fillscr
ENDIF
public	thrtmult
public	obj5dbits,haluclrate
public	tempindex
.public	jumpflag,jumpvalue,gbflg,capturedflag
IF shareflag EQ 0
.public	lettercheck1,lettercheck2
ENDIF
IF soundflag EQ 0
.public	b3laminit,blamtick,b3oominit
ENDIF
.public	cleardamage,restoreview
IF qrocket
.public	rocketflag
ENDIF
.public	sndflg

.public	rmsgqueue,cmpltrmsg,cmpltdmsg
	
xmin0	equ	10
xmax0	equ	xpix-15
ymin0	equ	15
ymax0	equ	ypix-10


w1xs	equ	512
w1ys	equ	390		;w1xs*1000/vysf


gnpts	equ	80
gsize	equ	6
ssize	equ	16384
gchnc	equ	65535/gnpts/9


gscum	segment	para 'horseshit'
;.fardataseg	gscum
ngpts	dw	gnpts
gpts	dw	0,0, 0,0, 0,0, 0
	dw	0,4000, 0,0, 0,0, 0
	dw	gnpts dup (0,0,0,0,0,0,0)
fgpts	dw	0,0, 0,0, 0,0, 0
	dw	0,4000, 0,0, 0,0, 0
	dw	gnpts dup (0,0,0,0,0,0,0)
sgpts	dw	0,0, 0,0, 0,0, 0
	dw	0,4000, 0,0, 0,0, 0
	dw	2*gnpts dup (0,0,0,0,0,0,0)
;.ends
gscum	ends


.dataseg
IF MVPCD EQ 1
		public	wpath
spacewpath	db	" "
wpath		db	".\",0
		db	38 dup(0)
vresfname	db	'3.res',0
vunivname	db	'3univ.dat',0
resfname	db	40 dup(?)
univname	db	40 dup(?)
IF nodemo EQ 0
vdemoname	db	'3demo.dat',0
demoname	db	40 dup(?)
ENDIF
IF demover EQ 0
vfname	db	'3d.cfg',0
fname	db	40 dup(?)
ENDIF

twrdatname	db	'towers.dat',0

ELSE

tname		db	'towers.dat',0
resfname	db	'3.res',0
univname	db	'3univ.dat',0
IF nodemo EQ 0
demoname	db	'3demo.dat',0
ENDIF
IF getunivbin
gubname	db	'univbin.dat',0
gubobjbuf	db	nbytexp dup (?)
ENDIF
sname	db	'startloc.dat',0
shandl	dw	?
IF demover EQ 0
fname	db	'3d.cfg',0
ENDIF
ENDIF ; MVPCD

IF avgthrot
throtfrq	dw	40h
ENDIF

wrferrmsg	db	0dh,0ah,'write error, file: ',0
notumsg		db	0dh,0ah,0ah,'Sorry, inflight theater detailed info not available in this version',0
noismsg		db	0dh,0ah,0ah,'Sorry, inflight score not available in this version',0
IF larryflag EQ 1
hellomsg	db	0dh,0ah,'Larry, we are test point 1, press any key',0dh,0ah,0
hellomsg1	db	0dh,0ah,'Larry, we are test point 2, press any key',0dh,0ah,0
hellomsg2	db	0dh,0ah,'Larry, we are test point 3, press any key : ',0dh,0ah,0
ENDIF
IF shareflag EQ 0
IF MVPCD
sharemsg	db	0dh,0ah,0
ELSE
sharemsg	db	0dh,0ah,'This program is not shareware nor public domain.'
		db	0dh,0ah,'  Copying this program for use by persons other than'
		db	0dh,0ah,'the person named above is a violation of the copyright.'
		db	0dh,0ah,0ah,0
ENDIF ; MVPCD
ENDIF
fferrmsg	db	0dh,0ah,'Error: far_free failure',0dh,0ah,0
badadaptmsg	db	0dh,0ah,'Error: video adapter must be COLOR VGA',0dh,0ah,0
;towermsg	db	'                 WELCOME TO 3! ',0
IF finalscreen
toykmsg	db	0dh,0ah,'Press almost any key to continue ',0
crshmsg		db	0dh,0ah,'You crashed and burned.  Code : ',0
nummsg		db	0dh,0ah,'Number of objects in tables : ',0
ENDIF

timermsg	db	0dh,0ah,0ah,'Error! Timer mode reset retries : ',0
frameratemsg	db	0dh,0ah,'Effective frame rate *10 : ',0
ruerrmsg	db	0dh,0ah,0ah,'Error while attempting to read'
		db	' universe file : ',0
;ferrmsg	db	0dh,0ah,'Error while accessing 3d.cfg or 3.res'
;	db	0dh,0ah,0
maerrmsg	db	0dh,0ah,'3 Error: Could not allocate extra RAM'
		db	0dh,0ah,0
errerrmsg	db	0dh,0ah,'decode error ',0dh,0ah,0
IF printflag
ptilemsg	db	0dh,0ah,'Tile at : ',0
expmsg		db	0dh,0ah,'Exp at ',0
ENDIF
fhandl	dw	?
;wrtuniverrmsg	db	0dh,0ah,0ah,'Error while writing universe data'
;		db	' file : ',0
sjdrvr		db	'Joystick driver found',0

mxrv		db	xrv		; hook to see the exe and link version
mlrv		db	lrv		; hook to see the exe and link version

totaldamage	dw	0		; total damage to current plane
escwaitflag	db	0
intowerflag	db	0	; non zero means man is in the tower
curtower	dw	0
omniflag	db	0	; 0= explosion out top, non-0= omni explsn
objdisp	dw	0	; dispersion of object
objdamp	dw	4320	; damping constant of air resistance
tckgrav	dw	54	; 54 cm/tick acceleration due to gravity
IF shareflag EQ 0
mlettercheck1		; call lettercheck1 macro
ENDIF
IF soundflag EQ 0
klaloud		dw	63
oldkladist	dw	0
realklafreq	dw	0
blamtick	dw	0
ENDIF
ndballs		dw	0		; number of active dballs
obj5dbits	dw	0		; home and crashland bits for obj5d
nstartplanes	dw	0		; how many planes are on runway?

IF xrv EQ 0
mdata1
ENDIF
patchcrash	dw	-1		; code for fixing up killmetouch penalty

nresbytes	equ	70*2		; eighteen bytes to store in file
;nresbytes	equ	58*2		; eighteen bytes to store in file
missionstatus	dw	1		; leave aborted flag there
deathcode	dw	0		; code of object which kill/capted me
nplaneslost	dw	0
ndest	dw	0
ndballsdest	dw	8 dup(0)
naasdest	dw	8 dup(0)
nvechsdest	dw	8 dup(0)
nsitesdest	dw	8 dup(0)
nhqsdest	dw	0
nfdest	dw	0
maxtotaldamage		dw	0
maxaaonme	dw	8 dup(0)
maxdbonme	dw	8 dup(0)
etime		dw	0
elapsedtime	dw	0
norbsdest	dw	8 dup(0)
hashedcode	dw	0,0ff00h		; make number negative until
						; registration complete
errcode		 dw	0
scncode	db	?
scnflg	db	0				; non-zero means change

ptrhashedcode	dw	@dataseg:hashedcode-(112+xrv)
;norbsdest	dw	8 dup(0)
fadecolorl	db	0		; lower part of fadeout
IF fadeflag
fadecolor	db	1		; start with intensity at a min
ELSE
fadecolor	db	255		; start with intensity at a max
ENDIF
faderate	dw	60		; rate of fade out
ptrhashcodeptr	dw	112+xrv

haluclrate	dw	1550/5,933/5,1211/5
IF shareflag EQ 0
mlettercheck2
ENDIF
starheight	dw	3600		; thirty thousand feet default
	public	maxobjcount
maxobjcount	dw	0
sunangle	dw	8192
homeangle	dw	?
arrowflag	db	?
tempstart	dw	3000,roadx-3
		dw	0,0
		dw	ehmin,0
		dw	-8000,epitchmin,0
arrowbuf	dw	3000,roadx-3
		dw	0,0
		dw	ehmin,0
		dw	-8000,epitchmin,0

startcoords	dw	3000,roadx-3
		dw	0,0
		dw	ehmin,0
		dw	-8000,epitchmin,0
zground		dw	0,0		; this is the height of the ground
myzground	dw	0,0

old9	dw	0,0				; old int vector
kbdtbl	db	16 dup(0)			; table for key presses

keytable	dw 256*4 dup(0)

oldmode	db	?



IF xrv EQ 1
mdata1
ENDIF

helpflashflag	db	-1

IF protection

weltableindex	db	0
weltablemaxi	equ	8

welcometable	db	14
		dw	nulcrit
		db	2
		dw	delay4crit
		db	3
		dw	airspeedcrit
		db	4
		dw	altcrit
		db	5
		dw	delay5crit
		db	7
		dw	delay5crit
		db	8
		dw	delay5crit
		db	9
		dw	delay5crit
		db	10
		dw	delay5crit
ENDIF

weltime		dw	0

;blowflg	db	0
IF printflag
ttticks	dw	0,0
toticks	dw	0,0
dnticks	dw	0,0
gdticks	dw	0,0
epticks	dw	0,0
hrticks	dw	0,0
inticks	dw	0,0
ENDIF

ballticks	dw	0
windtick	dw	?	; random time variable for wind gusts

oldbuts	db	0		; old button status

IF shareflag EQ 0
musername			; macro to insert user name
ENDIF

curattr		db	0h
caddr		dw	0
tvseg	equ	0b800h	; video segment
keyflag	db	0
numlock	db	-1
easyflag	db	0
invincible	db	0
IF testerflag
cheatflag	db	0
ENDIF
radarstat	db	0
oldradarstat	db	0
actionflag	db	0
IF getunivbin
gubflag		db	0
ENDIF
advflag		db	0
chainflag	db	0
rundemoflag	db	0
aceflag		db	0
aeroflag	db	0
rmsgflag	db	0
mapwantedflag	db	0
slowflag	db	0
readfileflag	db	0
capturedflag	db	0	; non-zero means captured
oldxrailflag	db	0
altmsgflag	db	-1
jctrflag	db	0
joyflag	db	-1		; flag for joystick enable

jleft	dw	12		; count at leftmost joystick postion
regflag	db	0		; 0 means not registered
jrght	dw	668		; the next two should be obvious!
ejectflag	db	0		; non-zero means ejected
jcntr	dw	225
jmax	dw	213		; the magnitude of +- motion of joystick
jup	dw	11
jdown	dw	654
ox	dw	?,?
oy	dw	?,?
oz	dw	?,?
orvec	dw	-8000,epitchmin,0
jrght1	dw	668
jvctr	dw	245
jvmax	dw	234
jinit	dw	1
nregcode	dw	1234
nregcodeh	dw	4333
guardb	dw	20		; the guardband of joystick IE 'center' wdth
randwords	dw	2 dup (?)
	dw	7777h
gbflg	db	0		; flag for joystick near ctr

ncfgbytes	dw	gbflg-jleft


maxcurhelpindex	equ	9
mincurhelpindex	equ	0

curhelpindex	db	mincurhelpindex

helpimgtable	db	2,6,13,9,8,7,4,3,5,10

jimsg	db	0dh,'Calibrating joystick.  Hit esc to exit program.  ',0
jlfstr	db	0dh,'Move joystick to upper left corner, then press button',0
jrtstr	db	0dh,'Move joystick to lower rght corner, then press button',0
jctstr	db	0dh,'Let joystick flop to the center, then press button   ',0
joyemsg	db	0dh,'Bad joystick value, please try again',0
joyamsg	db	0dh,'Escape detected, aborting program.'
	db	0dh,0ah,0ah,0
waitmsg	db	0dh,'Please wait one moment.....',0
IF slalom
oldox	dw	0,0
slalflag	dw	0	; 0=slalom not started n=passed n points
ENDIF

joyax	dw	?
joybx	dw	?

lastdrawn	dw	?
lastdrawncx	dw	?
rimgemsg	db	'Error: could not execute rimg.exe',0dh,0ah,0

rtemsg	db	'Error: could not execute tower.exe',0dh,0ah,0
rtmsg1	db	'Error within tower.exe program',0dh,0ah,0
c3oname	db	'score.exe',0
towername	db	'tower.exe',0
scorename	db	'iscore.exe',0
intname	db	'tu.exe',0
starsname	db	'srats.exe',0
rimgname	db	'rimg.exe',0
envstr		db	'-_- '
		db	50 dup(?)

;diagmsg	db	0dh,0ah,'Diag arrived OK toadaoo',0
IF diagflag
diagm1	db	0dh,0ah,'before grab',0
diagm2	db	0dh,0ah,'after grab, but before set timer0',0
ENDIF

IF xrv EQ 2
mdata1
ENDIF
jdrvrflag	db	0	; non zero means parallel game port used.

;dotflg		db	0
bhighflag	db	0
pgflg	db	0	; 0= use page zero for draw
memseg		dw	?		; memory segment for med far objs
memsegtotal	dw	?
cemsg		db	0dh,0ah,'Critical Error Occurred: ',0
timsg		db	0dh,0ah,'Time elapsed : ',0
notdmsg		db	0dh,0ah,'This program cannot be run directly, it must be called by other programs.'
		db	0dh,0ah,'To play Corncob 3d, just type corncob',0
;frmsg		db	0dh,0ah,'Total frames : ',0
;repsmsg		db	0dh,0ah,0ah,'Hit space to view/add to high score list',0
allocmsg1	db	0dh,0ah,0ah,'Error: Amount of RAM received : ',0
allocmsg2	db	' Amount of RAM requested : ',0
brdrcnt	dw	0
altlighton	db	0
helpreqflag	db	0
escwarnflag	db	0
steporvec	dw	100
steptick	dw	0
lastbombtick	dw	0
nbombs		db	3
bombwait	dw	540		; wait this long for a bomb
maxofrm		dw	35		; this won't let the action speed
					; up due to extremely low frame rate
minofrm		dw	2		; minimum frame rate 
addvalue	db	50h

newmissflag	db	0		; non-zero means jump to new location

instflag	db	-1		; non-zero means we want instruments
crshflg		db	0
autoflag	db	0		; non-zero means autopilot engaged
lockflag	db	0		; non-zero means altidute locked
anglockflag	db	0		; this means that the angle has been
lockvmax	equ	15600		; this is 400 knots
lockvmax10	equ	lockvmax/10

locktable	dw	-2109		; these angles are for locking alt
		dw	-1507
		dw	-1005
		dw	-772
		dw	-671
		dw	-571
		dw	-500
		dw	-450
IF xrv EQ 9
mdata1
ENDIF


ndbst		dw	0
nvest		dw	0
naas		dw	0
qualdbst	dw	-1		; -1 means random
qualvest	dw	-1
qualaa		dw	-1

IF xrv EQ 3
mdata1
ENDIF

					; set
lockheightl	dw	0		; this is the height we are locked to
lockheighth	dw	0		; this is the height we are locked to
tripflag1	db	0
newguyflag	db	-1		; non-zero means just entered game
bossflag	db	0		; oh no! the boss just walked in!
drawmemflag	db	-1		; non-zero means draw med far objects
stepoutflag	db	0		; non-zero means guy stepped out of pln
redamageflag	db	0
outfromflag	db	0		; non-zero means I have walked away
;fateofplane	db	0		; zero means fate of plane unknown
closetowerflag	db	0		; non-zero means on friendly territory
onrunwayflag	db	0		; non-zero means on a runway piece
remoteflag	db	0		; remotely flying?
homeflag	db	0		; are we home yet?
neverleftflag	db	-1		; we have never left homebase?
homenowflag	db	-1		; are we home yet?
homelandflag	db	0		; and did we land?
flapflag	db	0		; non-zero means flaps up
hlow		dw	4*13*l/2		; wing height
hmin		dw	ehmin		; lowest that plane can be
zspr		equ	ehmin/2
zspr2		equ	zspr/2
zspr4		equ	zspr/4
maxzspr		equ	3*zspr/2
kspr		equ	24*1000/zspr4
maxpitch	dw	10000
maxroll		dw	10000
nwheels		db	2		; two wheels?
wingvec		dw	0,0,0		; vector to show where wing is
smallth		dw	120		; if ang is small, lower thrdot effect
stepsz		dw	800
avgzvel		dw	0		; keep track of the average vel
IF fadeflag
avgdvelh	dw	61		; keep track of plane's wing load
ELSE
avgdvelh	dw	0		; keep track of plane's wing load
ENDIF
avgdvell	dw	0		; keep track of plane's wing load
navgdvel	dw	200		; to make g factor for brown out
pitchmin	dw	epitchmin		; 8 degrees of pitch at rest
groundflag	db	1		; non-zero means on ground
oldgflag	db	1		; ground flag
standingflag	db	0		; non-zero means standing on the ground
crshlndflag	db	0		; non-zero means crash landing
freezeflag	db	1		; non-zero means no motion of plane
jumpflag	db	0		; non-zero means charging up for jump
jumpvalue	dw	0		; this is how much we have charged up

IF xrv EQ 4
mdata1
ENDIF

rmsgqueue	dw	0
saveadr		dw	?
hitf2rmsg	dw	19,4*12,42-2,60+12	; xy box
		dw	20,4*12+6,40-2,60	; xy box
		db	21,5,20h,' Press F2 to select your mission',0
		db	21,6,20h,' or fly there from here directly',0
		db	-1

trainrmsg	dw	19,4*12,42-2,60+12	; xy box
		dw	20,4*12+6,40-2,60	; xy box
		db	21,5,20h,' Your mission is 10 miles North',0
		db	21,6,20h,'   Hit F4 for inflight help',0
		db	-1

cmpltrmsg	dw	19-10,4*12,42-2+20,96+12	; xy box
		dw	20-10,4*12+6,40-2+20,96	; xy box
		db	21-10,5,20h,'  Congratulations for completing a mission objective!',0
		db	21-10,7,20h,' Follow the homing pointer which runs along the bottom',0
		db	21-10,8,20h,' of your viewscreen to your airstrip to get credit; Or',0
		db	21-10,9,20h,' go for the points by selecting another mission via F2',0
		db	-1

cmpltdmsg	dw	19-10,4*12,42-2+20,108+12	; xy box
		dw	20-10,4*12+6,40-2+20,108	; xy box
		db	21-10,5,20h,'  Congratulations for completing a mission objective!',0
		db	21-10,7,20h,' Follow the homing pointer which runs along the bottom',0
		db	21-10,8,20h,' of your viewscreen to your airstrip to get credit; If',0
		db	21-10,9,20h,' your plane is badly damaged, use the emergency rocket',0
		db	21-10,10,20h,' booster to gain altitude and airspeed',0
		db	-1

cantf2rmsg	dw	19,4*12,42-2,60+12	; xy box
		dw	20,4*12+6,40-2,60	; xy box
		db	21,5,20h,' Your plane has too much damage',0
		db	21,6,20h,'   to teleport to new mission.',0
		db	-1

maprmsg1	dw	19,4*12,42-2,60+12	; xy box
		dw	20,4*12+6,40-2,60	; xy box
		db	21,5,20h,'   Map mode not available in',0
		db	21,6,20h,'       training missions.',0
		db	-1

maprmsg		dw	19-10,4*12-16,42-2+20+2,108+12+16+8	; xy box
		dw	20-10,4*12+6-16,40-2+20+2,108+16+8	; xy box
		db	21-10,3,20h,'                   Map mode instructions',0
		db	21-10,5,20h,'   The map view looks down from a height of 65 miles.',0
		db	21-10,6,20h,' The big blinking white dot is your plane.  The smaller',0
		db	21-10,7,20h," blinking dots are survey markers.  Most objects aren't",0
		db	21-10,8,20h," visible from 65 mi, so move down with keypad 9, and",0
		db	21-10,9,20h," use keypad 3 to move up.  The keypad arrow keys move",0
		db	21-10,10,20h," you around as expected.  Exit map mode with space.",0
		db	21-10,11,20h,'                  Press space to continue',0
		db	-1

hitrmsg	dw	19-10,4*12,42-2+20,108+12+24	; xy box
		dw	20-10,4*12+6,40-2+20,108+24	; xy box
		db	21-10,5,20h,'             Low Altitude Warning!!!!! ',0
		db	21-10,7,20h,' Your plane is lower than 150 feet from the ground.',0
		db	21-10,8,20h,' You are in great danger of slamming into the turf.',0
		db	21-10,9,20h,' Level your plane out, and pull back on the stick,',0
		db	21-10,10,20h," or press the keypad '2' key to pull your nose up.",0
		db	21-10,12,20h,"  Press enter to continue,  'o' to turn off msgs",0
		db	-1


escwarningrmsg	dw	19-10,4*12,42-2+20,108+24+12	; xy box
		dw	20-10,4*12+6,40-2+20,108+24	; xy box
		db	21-10,5,20h,'      Premature End of Mission Warning!!!!! ',0
		db	21-10,7,20h,' You must return to your airstrip to avoid a low score',0
		db	21-10,8,20h,' and a lost plane.  You can find the airstrip by',0
		db	21-10,9,20h,' following the homing pointer on the bottom of your',0
		db	21-10,10,20h,' view screen.  The radar dish blinks when you are',0
		db	21-10,11,20h,' close enough to home.  Cntl-c cancels entire mission.',0
;		db	21-10,12,20h," home.  Or, control-c cancels entire mission.",0
		db	-1

escgwarningrmsg	dw	19-10,4*12,42-2+20,108+24+12	; xy box
		dw	20-10,4*12+6,40-2+20,108+24	; xy box
		db	21-10,5,20h,'      Premature End of Mission Warning!!!!! ',0
		db	21-10,7,20h," You must call the rescue van with the 'v' key to",0
		db	21-10,8,20h," avoid a low score.  The van will approach from",0
		db	21-10,9,20h,' direction of the homing pointer on the bottom of your',0
		db	21-10,10,20h,' view screen.  It is your responsibility to ensure',0
		db	21-10,11,20h,' the van has a clear path.  Cntl-c cancels mission.',0
		db	-1

rudrmsg	dw	19-10,4*12,42-2+20,96+12	; xy box
		dw	20-10,4*12+6,40-2+20,96	; xy box
		db	21-10,5,20h,' On the ground, you must steer your plane with the',0
		db	21-10,6,20h,' rudder.   To control the rudder, use the x and z',0
		db	21-10,7,20h,' keys, or the keypad 7 and 9 keys.  To stop, apply',0
		db	21-10,8,20h,' brakes with keypad 0, or left shift for joystick',0
		db	21-10,9,20h,' users.    Press o to turn off these messages.',0
		db	-1


ssdist		dw	0
ssmag		dw	0
sauceronflag	db	0
saucerflag	db	0
orbonflag	db	0
orbflag	db	0

qtimeinc	dw	0		; 0=no qtimeinc setting
crshvel		dw	5000		;
lastroll	dw	0

ethmaxadj	dw	16000		; defaults for the below

ezveldiv	dw	13
ezveldivmin	dw	9
emaxdepth	dw	ehmin*2		; max depth for wheel to sink into 
enavgzvel	dw	10		; how many old samples to average
eavgzvelcutoff	dw	10*16		; this avg vel qualifies as a landing
etakeoffvel	dw	12		; plus 300 on the old velocity counts
ecrashlzvel	dw	200		; this speed qualifies as a crash
ecrashzvel	dw	400		; this speed qualifies as a crash


thmaxadj	dw	16000		; maximum adjustment of thrdot

maxdepth	dw	l		; max depth for wheel to sink into 
navgzvel	dw	10		; how many old samples to average
avgzvelcutoff	dw	1		; this avg vel qualifies as a landing
takeoffvel	dw	400		; plus 300 on the old velocity counts
zveldiv		dw	13		; divisor for zvel bounces
crashlzvel	dw	800		; this speed qualifies as a crash
crashzvel	dw	1600		; this speed qualifies as a crash
crashxvel	dw	10000		; this speed qualifies as a crash
oldzvel		dw	0		; just another pretty face, autopilot

freefallgrav	equ	50		; constant for how fast we fall
freetermvel	equ	16*300		; maximum speed of free fall
chutetermvel	equ	3*300		; maximum speed of fall w/ chute

;chutedrag	equ	chutetermvel/freefallgrav
;freedrag	equ	termvel/freefallgrav
					; as a take off
swingmx		equ	500		; how long to swing
swingcount	dw	0		; this is responsible for swinging
exitflag	db	0		; non-zero means exit needed
abortflag	db	0		; exit with extreme prejudice
pullstrflag	db	0
chutedamp	dw	31000		; how fast one slows after ejection
termvel	dw	freetermvel

IF qrocket
rocketflag	db	0
rockettick	dw	2184
lrockettick	dw	0
ENDIF
damage		dw	0

lastplaneflown	db	0		; wierd id number of last plane flown

thrdam		dw	0
yawdam		dw	0
stabdam		dw	0
wingloss	dw	0

thrdamunit		dw	40
yawdamunit	dw	5
winglossunit	dw	3
;stabunit	dw	20
stabunit	dw	15
engdam		dw	0
;engdamunit	dw	930		; 800/1000 fraction applied to rpmx
engdamunit	dw	950		; 950/1000 fraction applied to rpmx
shakecnt	db	0
damtable	dw	@codeseg:engdamage
	dw	@codeseg:wingdam
	dw	@codeseg:stabdamage
	dw	@codeseg:yawdamage
	dw	@codeseg:stabdamage
nframes		dw	0
score		dw	0
kbuf		db	320 dup(?)
sxtemp		db	0dh,0ah,'xtemp : ',0
sytemp		db	0dh,0ah,'ytemp : ',0
IF xrv EQ 8
mdata1
ENDIF

spcr	db	'   ',0dh,0
spncr	db	'   : ',0
IF diagflag
testmsg	db	0dh,0ah,'argx1 y1 x2 y2',0dh,0ah,0
testbuf	dw	-1599,798,-12,498,-1599,-12
ENDIF
ticksf	dw	tickf16*4/3
ondest	dw	0
argx1	dw	?
argy1	dw	?
argx2	dw	?
argy2	dw	?
n	db	?
clnregcode	dw	-1
clnregcodeh	dw	-1
vboff	dw	?
xang	dw	?
yang	dw	?
rdrang	dw	?
yraild	dw	?		; non zero if joystick at extreme position
oyrail	dw	?
oldang	dw	?
oldyaw	dw	?
oldpit	dw	?
oldrol	dw	?
rotang	dw	?
IF xrv EQ 5
mdata1
ENDIF

otime	dw	?
;zero	dw	0
regflg	db	0
hrflg	db	0	; flag for are we drawing horizon
rejoyflag	db	0	; rejoice! rejoice!
diagflg	db	0

gdflg	db	-1	; flag for display of grid
starsflag	db	0	; flag for if stars in theater
gndcolor	db	0	; color of ground dots
fillflg	db	-1	; is horizon filled?
IF (vgmode EQ 10h) OR (vgmode EQ 81h)
win0	dw	496,259,615,327,120,76,76,59,561,295,255*80,335*80
ENDIF
IF vgmode EQ 0dh
win0	dw	250,145,311,195,127,92,76,59,280,170,255*80,342*80
ENDIF
frmnum	dw	0

gwinl	dw	8,4,159,115,152,111,300,200,84,60,4*80+1,115*80
gwinr	dw	480,4,631,115,152,111,76,59,556,60
;gwinf	dw	8,4,631,199,622,193,300,200,320,102,4*80,199*80
;gwint	dw	168,254,471,344,303,95,150,100,320,297,254*80,344*80
	mgwins	; let macro from 3dvid.inc do the window definitions
ptrgwinf	dw	@dataseg:gwinf
ptrgwint	dw	@dataseg:gwint
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
clr0	db	15
clr1	db	15
clr2	db	9
clr3	db	9
clr4	db	9
clr5	db	0ah
clr6	db	12
clr7	db	5
clr8	db	0
clr9	db	14
clra	db	15
clrb	db	15
clrc	db	15
clrd	db	15
clrf	db	15
clrt	db	?
clrn	db	1
clre	db	2
clrs	db	6
clrw	dw	4


rx	equ	1000
ry	equ	250
rza	equ	-80
rzb	equ	80
ytemp	dw	?
y1temp	dw	?
x1temp	dw	?
xtemp	dw	?
ztemp	dw	?
cya	dw	?
sya	dw	?
tempindex	dw	0
tempsum	dw	0
ncyl	dw	0
cpa	dw	?
spa	dw	?



hrobj	dw	2000,0		; 32 bit xyz coordinates
	dw	0,0
	dw	0,0
	dw	0		; yaw, pitch, and roll
	dw	0
	dw	0

	dw	0		; distance default, 0=near

	dw	9612,244	; 32-bit distance squared

	dw	1		; object type 0= no-draw
	dw	1		; rotflg, 0= no rotation
	dd	977625289	; breakpoint for near dist squared
	dd	1067541266	; bkpt for med near dist sqrd
	dd	1067541266	; bkpt for med far dist sqrd
	dw	phrobj		; address of near object
	dw	phrobj		; address of med object
	dw	phrobj		; address of far object, usually point

bulptr	dw	@dataseg:bullets
bultick	dw	0
bulrate	dw	2
bulavg	dw	0

misavg	dw	0
mistick	dw	0
misrate	dw	2

phrobj	dw	0,0,0
	dw	1
	dw	2,hrfrm
	dw	2,hrfrm
	dw	2,hrfrm
	dw	2,hrfrm
	dw	2,hrfrm
	dw	2,hrfrm
	dw	2,hrfrm
	dw	2,hrfrm

hrfrm	dw	1
	dw	hrwr1
hrwr1	dw	1,dkred
	dw	0,-1000,0
	dw	0,1000,0
hrcld	dw	1
	dw	0,0,50,ltpurp

cldpt	dw	1
	dw	0,0,0,clr1

;cyan	dw	3
;ltblue	dw	9
;dkblue	dw	1
;ltred	dw	12
dkred	dw	4
;ltgrn	dw	10
;dkgrn	dw	2
;yellow	dw	14
;brown	dw	6
ltpurp	dw	13
;dkpurp	dw	5

IF xrv EQ 6
mdata1
ENDIF

ebulyoff	equ	3*l4
bulyoff	dw	3*l4
ammoleft	dw	0
abombsleft	db	0
misyoff	dw	l4
zxlt	macro	argx,argy,argz
	dw	-1*(argz),argx,argy
	endm

xvec	dw	-5338,27312,-435
xvec1	dw	-5338,27312,-435	 ; temp storage
rmat	dw	9 dup(0)
zmat	dw	9 dup(0)
nzmat	dw	9 dup(0)
nnzmat	dw	9 dup(0)
dorot	dw	9 dup(0)
dnrot	dw	9 dup(0)
rvec	dw	24809,-14154,19645
;orvec	dw	8000,8000,8000
oorvec	dw	0,0,0
tmbvec	dw	0,0,0
dvel	dw	0
orvel	dw	400
	dw	4 dup(0)
topv	dw	0,0,0
otopv	dw	0,0,0
surfacev	dw	100,0,0
geardamp	dw	0
bounceheight	dw	0
springforce	dw	0
oldrtopv4	dw	0
acctop	dw	0,0,0
racctop	dw	0,0,0
rtopv	dw	100,0,0
ctopv	dw	10,0,0
dtopv	dw	100,0,0
ovelvec	dw	0,0,0
nticks	dw	16

grvsf	dw	-48
sssin	dw	?
sscos	dw	?
rpm	dw	20
rpmx	dw	200
currpmx	dw	200
;thrsf	dw	300
;thrsf	dw	430
thrsf	dw	600
thrtsf	dw	ethrtsf
vstall	dw	231
vstal2	dw	300
qstald	dw	0
;oldqstald	dw	0
mvstal2	dw	-300
pitsf	dw	125
rpitsf	dw	225
pitmi	dw	10
pitdotl	dw	0
pitdoth	dw	0
thrdotl	dw	0
thrdoth	dw	0
thrmi	dw	8
yawdotl	dw	0
yawdoth	dw	0
ctydoth	dw	0
ctydotl	dw	0
yawmi	dw	10
yawsf	dw	125
sidef	dw	0
thstal	dw	ethstal
thstl2	dw	ethstl2
almthstald	dw	2912*7/8
lfsf	dw	7*18*16
stlfsf	dw	98*18*16
rho0	dw	5957			; max air pressure at sea level
rho0z	dw	5957			; maximum linear height of air
rhotop	dw	5957
rho02	dw	5957*2/3
thrtmult	dw	-1
idsf	dw	763*18
oidsf	dw	76*18
ridsf	dw	?
isdsf	dw	763*18/10		; sideways drag 10x frontal drag
oisdsf	dw	76*18/10
risdsf	dw	?
dvspd	dw	1390
alpha	dw	?
oldalpha	dw	?
stallprotflag	db	0
mopitdoth	dw	0
IF soundflag
sndflg	db	0
ELSE
sndflg	db	-1
ENDIF


bulvel	dw	4400
bullife	dw	96		; stay alive for 18 frames
buldisp	dw	40
tmpsum	dw	?,?
explf	dw	0

IF xrv EQ 7
mdata1
ENDIF


rollmx	dw	4096
rolln	dw	3
yawmx	dw	4096
yawn	dw	15
vpxp	dw	?
vpxpmx	dw	1041
vpzp	dw	?
thrdot	dw	0
yawdot	dw	0
etemp	dw	16000
opres	dw	0
ofrmticks	dw	0
realofrmticks	dw	0
;soundtick	dw	0

screechtime	dw	0
.ends


IF NOT __TINY__
.stackseg
		db	512 dup(?)	;define a 128 byte stack
.ends
ENDIF


;=============================================================================
;FUNC:	MAIN
;
;DESC:	Main body of program.
;
;IN:	DX		segment address of PSP
;
;ASUMS:	DS,ES		@DATASEG  (same as @CODESEG in TINY model)
;	SS		@STACKSEG (same as @CODESEG in TINY model)
;=============================================================================

.codeseg

IF __TINY__
assume		cs:@codeseg, ds:@dataseg, es:@dataseg, ss:@dataseg
ELSE
;assume		cs:@codeseg
assume		 ds:@dataseg 
assume 		es:@dataseg
assume 		 ss:@stackseg
ENDIF
	db	xrv,lrv

old08	dw	0,0
old00	dw	0,0
ticks	dw	?
dticks	dw	?,?
tdticks	dw	?,?
frmticks	dw	?
oticks	dw	?
bsyflg	db	-1
tbsyflg	db	-1
defseg	dw	?				; data segment storage


IF xrv EQ 7
cecode	db	0
mnew08
mwelcomewagon
mnew9
mdolandinggear
ENDIF

include	settmr0.inc				; get the timer routine

.proc	wcr	auto
	push	ax
	mov	al,0dh
	call	put_chr
	mov	al,0ah
	call	put_chr
	pop	ax
	ret
.endp

.proc	wsp	auto
	push	ax
	mov	al,20h
	call	put_chr
	pop	ax
	ret
.endp

.proc	cleargetkey	auto		; clears the kbd table
	mov	di,offset @dataseg:kbdtbl
	mov	cx,16
	mov	ax,ds
	mov	es,ax
	xor	ax,ax
	cld
	rep	stosb
.endp

setkbit	proc	near			; sets key bit as pressed bit in DL
	mov	cl,al
	and	cl,07h			; strip off all but lower 3 bits
	shr	al,1
	shr	al,1
	shr	al,1			; get byte offset of word
	mov	bl,al
	xor	bh,bh
	mov	al,[bx+offset kbdtbl] 	; get byte of keyboard info
;	or	cl,cl			; is cl zero?
;	jz	noshft
	rol	al,cl
	and	al,0feh			; clear the bit
	or	al,dl			; set the bit
	ror	al,cl			; set back to the proper bit
	mov	[bx+offset kbdtbl],al
	ret
setkbit	endp

getkbit	proc	near			; sets key bit as pressed bit in DL
	mov	cl,al
	and	cl,07h			; strip off all but lower 3 bits
	shr	al,1
	shr	al,1
	shr	al,1			; get byte offset of word
	mov	bl,al
	xor	bh,bh
	mov	al,[bx+offset kbdtbl] 	; get byte of keyboard info
;	or	cl,cl			; is cl zero?
;	jz	noshft
	rol	al,cl
	and	al,01			; isolate the bit
	ret
getkbit	endp

grab9	proc	near				; this grabs int 9
	mov	ax,ds
	mov	cs:defseg,ax
	push	ds
	mov	ax,3509h			; set sys call to get old vec
	int	21h
	mov	ax,es
	mov	old9,ax				; save old vector in ram
	mov	old9+2,bx
	mov	dx,offset new9			; get new9 addr ready to pass
	mov	ax,cs
	mov	ds,ax				; set up the proper segment
	mov	ax,2509h
	int	21h				; reset the vector
	pop	ds
	ret
grab9	endp

reset9	proc	near				; reset original int vector
	mov	dx,old9+2			; get old offset
	mov	ax,old9				; get old segment
	mov	cx,ax
	or	cx,dx
	jz	r09ret
	push	ds
	mov	ds,ax
	mov	ax,2509h
	int	21h
	pop	ds
r09ret:
	ret
reset9	endp

.proc	readkey	auto		; reads in how long a key has been down
				; since the last read
				; get address
				; call with al=scan code of key
				; returns ax=#ticks elapsed where key was
				; down since last read
				; bx= #ticks since last read
	mov	bl,8
	mul	bl
	mov	si,offset @dataseg:keytable	; point to key table
	add	si,ax				; 
	cmp	word ptr [si],0
	jz	readkeyup
	cli					; clear ints to avoid trble
	mov	ax,cs:oticks			; get current tick value
	mov	bx,ax
	sub	ax,[si+2]			; get progress since record
	add	ax,[si+4]			; read progress
	mov	word ptr [si+4],0		; and clear results
	mov	[si+2],bx			; let int9 contunue to
						; count where we left off
	mov	dx,[si+6]			; get timer counnt since
						; last read
	mov	[si+6],bx
	sub	bx,dx				; now bx has elapsed ticks
						; since last read
	sti					; renable ints
	ret
readkeyup:
	mov	ax,[si+4]			; just read what int9 left
	mov	word ptr [si+4],0		; put zero in for next read
	mov	bx,cs:oticks			; get current tick value
	mov	dx,[si+6]			; get timer counnt since
						; last read
	mov	[si+6],bx
	sub	bx,dx				; now bx has elapsed ticks
	ret
.endp
IF xrv EQ 6
mdolandinggear
mnew08
cecode	db	0
mnew9
mwelcomewagon
ENDIF

IF 1 EQ 0
.proc	drawb	auto		; draws border around window
	mov	argx1,0
	mov	argy1,0
	mov	argx2,xpix-1
	mov	argy2,0
	mov	n,7
	doline
	mov	argx1,0
	mov	argy1,0
	mov	argx2,0
	mov	argy2,ypix-1
	mov	n,7
	doline
	mov	argx1,0
	mov	argy1,ypix-1
	mov	argx2,xpix-1
	mov	argy2,ypix-1
	mov	n,7
	doline
	mov	argx1,xpix-1
	mov	argy1,ypix-1
	mov	argx2,xpix-1
	mov	argy2,0
	mov	n,7
	doline
	ret
.endp
ENDIF

.proc	dwword	auto
	push	si
	push	ax
	mov	si,offset @dataseg:kbuf
	call	dwords_to_dec
	call	put_str
	call	wsp
	pop	ax
	pop	si
	ret
	.endp

.proc	decwword	auto
	push	si
	push	ax
	mov	si,offset @dataseg:kbuf
	call	words_to_dec
	call	put_str
	call	wsp
	pop	ax
	pop	si
	ret
	.endp

.proc	hwword	auto
	push	si
	push	ax
	mov	si,offset @dataseg:kbuf
	call	word_to_hex
	call	put_str
	call	wsp
	pop	ax
	pop	si
	ret
	.endp


.proc	wword	auto
	push	si
	push	ds
	push	ax
	mov	ax,@dataseg
	mov	ds,ax
	pop	ax
	push	ax
	mov	si,offset @dataseg:kbuf
	call	words_to_dec
	call	put_str
	call	wsp
	pop	ax
	pop	ds
	pop	si
	ret
	.endp

.proc	joybtn	auto			; waits for button on joystick

	mov	dx,201h
jblp2:	
	cmp	jdrvrflag,0
	jz	joybutnorm
	push	dx
	mov	ah,84h			; get info from BIOS
	mov	dx,0			; read switches
	int	15h
	pop	dx
;	xor	ah,ah
;	call	wword
;	call	wcr
	jmp	afternormj
joybutnorm:

	in	al,dx			; must wait for buttons to be
afternormj:
	and	al,030h			; released before waiting for a press
	cmp	al,030h
	jnz	jblp2			; wait for those buttons...
	mov	ax,80			; wait twenty milliseconds to 
	call	sleep_msec		; debounce switch
	mov	dx,201h
jblp1:	
	cmp	jinit,0
	jz	nokeyck			; don't check for escape
	call	check_key
	je	abjoyb
nokeyck:
	cmp	jdrvrflag,0
	jz	j1oybutnorm
	push	dx
	mov	ah,84h			; get info from BIOS
	mov	dx,0			; read switches
	int	15h
	pop	dx
;	xor	ah,ah
;	call	wword
;	call	wcr
	jmp	a1fternormj
j1oybutnorm:
	in	al,dx
a1fternormj:
	not	al			; if either are zero, then btn dwn
	and	al,030h			; look for either button
	jz	jblp1			; wait till it is up
	clc
	ret
abjoyb:	stc
	ret
.endp

.proc	spke	auto			; scales joystick parameter
	or	ax,ax			; displacement from ctr in ax
	jns	spk1			; max displacement in cx
	xor	ax,ax			; check bounds
spk1:	cmp	ax,cx			; not < 0 not > cx
	jbe	spk2
	mov	ax,cx			; just clip if out of bounds
spk2:	mov	bx,205h			; now scale parabolically into 0-20
	mul	bx	
	cmp	dx,cx
	jb	spkedok
	mov	dx,cx
	dec	dx
spkedok:
	div	cx			; now is in range 0-200h
	mul	ax			; now is squared
	mov	bx,200h			; now divide into 0-20
	cmp	dx,bx
	jb	spkedok1
	mov	dx,bx
	dec	dx
spkedok1:
	div	bx
	ret
.endp

.proc	checkjoyexist	auto		; checks for existance of joystick

	mov	ah,84h			; call bios to check for joystick
	mov	dx,3
	int	15h
	cmp	ax,0534ah		; look for 'SJ' in ax meaning
					; driver is loaded
	jnz	nojdrvr

	mov	si,offset @dataseg:sjdrvr
	mov	addvalue,0
	mov	caddr,160*17+leftmarg
	call	wchstring

	mov	jdrvrflag,-1
	jmp	joystickok
nojdrvr:
	mov	dx,201h			; joystick in/out port addr
	out	dx,al
	mov	ax,75			; hang out for 1/4 of a second
	call	sleep_msec
	in	al,dx
	and	al,3			; are both bits high?
	jnz	joystickbroke

	call	joyx			; joyx returns with zero flag set
					; if joystick never responded
	jnz	joystickok
joystickbroke:
	stc
	ret
joystickok:
	clc
	ret
.endp
;IF 1 EQ 0
.proc	joyx	auto			; gets the joystick x coordinate
	.push	cx,dx,si,di

	cmp	jdrvrflag,0
	jz	normjoy			; do normal joystick code
	mov	ah,84h		; bios joystick routine
	mov	dx,8		; get damn values
	int	15h
	mov	bx,dx		; xfer second value from dx to bx for compat
	jmp	joypoprtn
normjoy:
	xor	cx,cx
	mov	si,cx
	mov	di,cx
	mov	dx,201h			; joystick in/out port addr

	mov	ah,01			; quicker to store the byte in ax
	out	dx,al			; start joystick timing cycle
	cli				; turn off pesky ints
	xor	ah,ah
jylp1:	in	al,dx
	and	al,3
	jz	jylp1dn
	mov	bx,ax
	shr	al,1
	and	al,1
	add	si,ax
	and	bx,1
	add	di,bx
	loop	jylp1
jylp1dn:
	sti
	mov	ax,di
	mov	bx,si
	clc	
	or	cx,cx
	jz	joyxerr
joypoprtn:
	.pop	cx,dx,si,di
	ret
joyxerr:
	stc
	jmp	joypoprtn
.endp
;ENDIF

IF 1 EQ 0	
.proc	joyx	auto			; gets the joystick x coordinate
	xor	bx,bx
	xor	cx,cx
	mov	dx,201h			; joystick in/out port addr

	mov	ah,01			; quicker to store the byte in ax
	out	dx,al			; start joystick timing cycle
	cli				; turn off pesky ints
jxlp1:	in	al,dx
	test	al,ah
	jz	jxdn			; when the bit drops, the measurement
	inc	bx
	loop	jxlp1
jxdn:
	sti
	push	bx
	push	cx
	xor	bx,bx
	xor	cx,cx
	out	dx,al			; start joystick timing cycle
	mov	ah,02			; quicker to store the byte in ax
	cli
jxlpy:	in	al,dx
	test	al,ah
	jz	jydn			; when the bit drops, the measurement
	inc	bx
	loop	jxlpy
jydn:
	pop	ax
	or	ax,cx			; had either count run down?
	sti				; renable ints
	pop	ax
	ret
.endp
ENDIF

.proc	setjrght	auto		; sets jrght without disturbing
					; the trial period code
	push	bx
	push	ax			; save enduser's jrght
	mov	ax,jrght
	sub	ax,jrght1
	shr	ax,1
	mov	dx,ax
	pop	bx
	add	ax,bx
	mov	jrght,ax		; store it for later
	sub	bx,dx
	mov	jrght1,bx		; keep it hashin'
	pop	bx
	ret
.endp

.proc	erasejmsg	auto
	mov	di,160*19+leftmarg	; clear the joystick messages from scrn
	mov	ax,tvseg
	mov	es,ax
	mov	cx,80
clrjmsglp1:
	and	byte ptr es:[di+1],NOT 80h	; clear high intensity bits
	add	di,2			; write all the letters to spaces
	loop	clrjmsglp1
	mov	cx,58
clrjmsglp:
	mov	byte ptr es:[di],20h
	and	byte ptr es:[di],NOT 80h	; clear high intensity bits
	add	di,2			; write all the letters to spaces
	loop	clrjmsglp
	ret
.endp


.proc	nwjctr	far			; this will replace the time wait
	mov	si,offset @dataseg:jimsg
	mov	caddr,160*19+leftmarg
	mov	addvalue,0
	mov	curattr,80h		; make blink
	call	wchstring
	mov	curattr,0fh		; make not blink
	mov	jinit,1
joybeg:
	mov	ax,1			; set joystick # to 1
	mov	addvalue,0
	mov	caddr,160*20+leftmarg
	mov	si,offset @dataseg:jlfstr	; offset of new string
	call	wchstring
	call	joybtn
	jnc	jnab1
	call	get_chr
	cmp	al,1bh
	jnz	jnab1
	jmp	joyabt
jnab1:
	call	joyx			; get the xcoord of joystick
; call wword
	mov	jleft,ax		; store it for later
; mov ax,bx
; call wword
; call wcr
	mov	jup,bx			; get up data
  
	call	erasejmsg
	mov	ax,500
	call	sleep_msec
	mov	si,offset @dataseg:jrtstr	; offset of new string
	mov	addvalue,0
	mov	caddr,160*20+leftmarg
	call	wchstring
	call	joybtn
	jnc	jnab2
	call	get_chr
	cmp	al,1bh
	jnz	jnab2
	jmp	joyabt
jnab2:

	call	joyx			; get the xcoord of joystick
; push ax
; call wword
; mov ax,bx
; call wword
; call wcr
; pop ax
	call	setjrght
	mov	jdown,bx
;	shr	ax,1			; divide by two
	sub	ax,20
	cmp	ax,jleft		; make sure jright is >2*jleft
	jg	joyok1
	jmp	joyerr
joyok1:
;	shr	bx,1			; divide by two
	sub	bx,20
	cmp	bx,jup		; make sure jright is >2*jleft
	jg	joyok2
	jmp	joyerr
joyok2:
	call	erasejmsg
	mov	ax,500
	call	sleep_msec
	mov	si,offset @dataseg:jctstr	; offset of new string
	mov	addvalue,0
	mov	caddr,160*20+leftmarg
	call	wchstring
	call	joybtn
	call	joyx			; get the xcoord of joystick
; push ax
; call wword
; mov ax,bx
; call wword
; call wcr
; pop ax
	mov	jcntr,ax		; store it for later
	mov	jvctr,bx
					; now check for invalid entry
;	shr	ax,1			; divide by two
	sub	ax,10
	cmp	ax,jleft		; make sure jright is >2*jleft
	jg	joyok3
	jmp	joyerr
joyok3:
;	shr	bx,1			; divide by two
	sub	bx,10
	cmp	bx,jup		; make sure jright is >2*jleft
	jg	joyok4
	jmp	joyerr
joyok4:
	mov	ax,jrght
	add	ax,jrght1
	shr	ax,1
	shr	ax,1
	shr	ax,1
	shr	ax,1

	mov	bx,jrght
	add	bx,jrght1
	shr	bx,1
	shr	ax,1
	sub	bx,ax

	cmp	bx,jcntr		; make sure jright is >2*jleft
	jg	joyok5
	jmp	joyerr
joyok5:
	mov	ax,jup
	shr	ax,1
	shr	ax,1
	shr	ax,1
	mov	bx,jup
	sub	bx,ax
	cmp	bx,jvctr		; make sure jright is >2*jleft
	jl	joyok6
	jmp	joyerr
joyok6:
				;
					; now we have the joystick coords
					; lets now calculate the relevant items
	mov	bx,jvctr		; center pos
	sub	bx,jup		; 
	mov	ax,jdown
	sub	ax,jvctr		; now ax and bx have the joystick mags
	cmp	ax,bx
	jle	nbatch
	mov	ax,bx
nbatch:	mov	jvmax,ax

	mov	bx,jcntr		; center pos
	sub	bx,jleft		; 
	mov	ax,jrght
	add	ax,jrght1
	shr	ax,1
	sub	ax,jcntr		; now ax and bx have the joystick mags
	cmp	ax,bx			; take the smaller difference as the
	jle	noxch			; max displacement from center
	mov	ax,bx
noxch:	mov	jmax,ax			; save max in variable
	mov	jinit,0			; to joybtn not to check for keys
	mov	curattr,0		; make not blink
	call	erasejmsg
	clc
	ret
joyerr:	
	call	erasejmsg
	mov	ax,500
	call	sleep_msec
	mov	si,offset @dataseg:joyemsg	
	mov	addvalue,0
	mov	caddr,160*20+leftmarg
	call	wchstring
	mov	ax,2000
	call	sleep_msec
	jmp	joybeg
joyabt:	

	mov	si,offset @dataseg:joyamsg
	mov	addvalue,0
	mov	caddr,160*20+leftmarg
	call	wchstring
	mov	cs:cecode,93		; leave error flag for joystick abort
	mov	curattr,0h		; make not blink
	stc
	ret
.endp

.proc	scalekey	auto		; scales key reading in 0-200
	call	readkey			; get key info
	or	bx,bx			; make sure measurement time is pos
	jz	falsekey		; if so, return zero
	js	falsekey
;	mov	dx,200h			; mult by 200h
	mov	dx,cx			; mult by 200h
	mul	dx
	cmp	dx,bx
	jae	skovfl			; avoid overflows
	div	bx
;	cmp	ax,200h			; check for out of bounds
	cmp	ax,cx			; check for out of bounds
	jb	thisisfine
;	mov	ax,200h
skovfl:
	mov	ax,cx
thisisfine:
	ret
falsekey:
	xor	ax,ax
	ret
.endp

IF xrv EQ 5
mdolandinggear
mnew08
mwelcomewagon
cecode	db	0
mnew9
ENDIF

IF demover
.proc	joytd	auto		; do nothing at all if demo version
	mov	ax,200h
	mov	bx,200h
	ret
.endp
ELSE
.proc	joytd	auto			; this subr gets joystick xcoord,
					; and scales it into 0-40
;	mov	ax,cs:old08
;	or	ax,cs:old08+2
;	jz	nttrap
	xor	ax,ax
	xor	bx,bx
	cmp	desireflag,0		; are we looking at views?
	jnz	nokeysinput
	mov	cx,200h			; scale factor for keyboard users
	mov	ax,200h
	mov	bx,ax
	mov	al,4bh			; left arrow key
	call	scalekey		; get 0-200h for left arrow
	neg	ax
	push	ax
	mov	al,4dh			; get right arrow key
	call	scalekey
	pop	bx
	add	ax,bx
	push	ax
	mov	al,48h			; left arrow key
	call	scalekey		; get 0-200h for left arrow
	neg	ax
	push	ax
	mov	al,50h			; get right arrow key
	call	scalekey
	pop	bx
	add	bx,ax
	pop	ax
nokeysinput:

	mov	dx,ax
	or	dx,bx
	add	ax,200h			; recenter
	add	bx,200h
	cmp	joyflag,0		; is the joystick enabled?
	jnz	fakein			; get info collected by int 8
	ret
fakein:
	or	dx,dx			; did someone hit an arrow key?
	jz	noarrowkey
	ret				; yes, then just use arrow keys
					; ignore joystick
noarrowkey:
;	mov	ax,joyax
;	mov	bx,joybx
;	jmp	fakeout			; pretend we just got this info
nttrap:	
	call	joyx			; get the x coord
fakeout:
	push	bx
	cmp	ax,jcntr		; which side of center?
	jbe	lfsd			; lft side
	mov	cx,jrght		; now set up parameters for call
	add	cx,jrght1
	shr	cx,1			; get unhashed jrght
	sub	cx,jcntr		; to scale into 0-20
	sub	ax,jcntr		; get difference from center
	call	spke			; make the call
	add	ax,200h			; do it up!
	jmp	short jytd1
lfsd:	mov	cx,jcntr		; same sort of thing for the left
	sub	cx,jleft		; this is the max deflection from ctr
	mov	bx,ax			; now find deflection from ctr
	mov	ax,jcntr
	sub	ax,bx
	call	spke			; normalize it
	sub	ax,200h			; now flip it, so the direction is 
	neg	ax			; correct.
jytd1:	mov	gbflg,0			; clear gbflag 
	mov	bx,ax			; save copy
	sub	bx,jcntr		; get difference
	jns	jtd1			; take abs value
	neg	bx
jtd1:	cmp	bx,guardb		; is difference from center> guard?
	ja	jtd2			; if > guardb, then wheel is turned
	dec	gbflg
jtd2:	
	or	ax,ax			; now check for health min&max
	jns	jyd1
	mov	ax,0
jyd1:	cmp	ax,400h			; is it above 40?
	jle	jyd2
	mov	ax,400h			; yup, so max it out!
jyd2:	
	pop	bx
	push	ax
	mov	ax,bx
	cmp	ax,jvctr		; which side of center?
	jbe	lfsdy			; lft side
	mov	cx,jdown		; now set up parameters for call
	sub	cx,jvctr		; to scale into 0-20
	sub	ax,jvctr		; get difference from center
	call	spke			; make the call
	add	ax,200h			; do it up!
	jmp	short jytd1y
lfsdy:	mov	cx,jvctr		; same sort of thing for the left
	sub	cx,jup		; this is the max deflection from ctr
	mov	bx,ax			; now find deflection from ctr
	mov	ax,jvctr
	sub	ax,bx
	call	spke			; normalize it
	sub	ax,200h			; now flip it, so the direction is 
	neg	ax			; correct.
jytd1y:	
;	mov	gbflg,0			; clear gbflag 
	mov	bx,ax			; save copy
	sub	bx,jvctr		; get difference
	jns	jtd1y			; take abs value
	neg	bx
jtd1y:	cmp	bx,guardb		; is difference from center> guard?
	ja	jtd2y			; if > guardb, then wheel is turned
	dec	gbflg
jtd2y:	
	or	ax,ax			; now check for health min&max
	jns	jyd1y
	mov	ax,0
jyd1y:	cmp	ax,400h			; is it above 40?
	jle	jyd2y
	mov	ax,400h			; yup, so max it out!
jyd2y:	
	pop	bx
	xchg	ax,bx
	ret				; ax has our wheel position
.endp
ENDIF



IF 1 EQ 0
.proc	tjoyx	auto			; gets the joystick x coordinate
	push	ax
	push	bx
	push	cx
	push	dx
	push	ds
	mov	ax,@dataseg
	mov	ds,ax
	xor	bx,bx
	mov	dx,201h			; joystick in/out port addr
	xor	cx,cx
	mov	ah,03h
tjxlp0:	in	al,dx			; check to make sure it's finished
	test	al,ah			; make sure both x&y are done
	jnz	tjxlp0
	out	dx,al			; start joystick timing cycle
	mov	ah,01			; quicker to store the byte in ax
	xor	cx,cx
tjxlp1:	in	al,dx
	test	al,ah
	jz	tjxdn			; when the bit drops, the measurement
	inc	bx
	loop	tjxlp1
tjxdn:
	test	al,03h
	jnz	tjxlp1
	mov	joyax,bx
	xor	bx,bx
	out	dx,al			; start joystick timing cycle
	mov	ah,02			; quicker to store the byte in ax
	xor	cx,cx
tjxlpy:	in	al,dx
	test	al,ah
	jz	tjydn			; when the bit drops, the measurement
	inc	bx
	loop	tjxlpy
tjydn:
	test	al,03h
	jnz	tjxlpy
	mov	joybx,bx
ttest:	pop	ds
	pop	dx
	pop	cx
	pop	bx
	pop	ax
	ret
.endp

ENDIF
.proc	grmode	auto		; put in graphics mode and arrange pointer
				; to correct font
	mov	ax,vgmode	; set graphics mode
	int	10h
	mov	ax,1122h	; function to set correct font
	mov	bl,1		; 14 rows per character
	int	10h		; set font
	ret
.endp

.proc	blackbox	auto

	push	si
	cli
	call	rest08		; unhook timer int
	call	reset_ticks		; stop timer from racing, so we
					; don't run into trouble
;	call	reset9
;	call	cleargetkey		; clear the keyboard table
	call	addtoetime		; add elapsed time to variable
	pop	si

	mov	saveadr,si
	mov	ax,vboff
	push	ax
	mov	vboff,0
	xor	ax,ax
	xor	bx,bx
	call	strtadr
	mov	ax,[si+2]	; y coord in line #
	mov	dx,BPL
	mul	dx
	mov	di,ax
	add	di,[si]		; x coord in byte #
	mov	cx,[si+4]
	shr	cx,1		; divide by 2
	mov	bx,[si+6]
	mov	n,4
	call	scrfbx		; fill in a nice box

	mov	si,saveadr
	add	si,8		; advance to next box
	mov	ax,[si+2]	; y coord in line #
	mov	dx,BPL
	mul	dx
	mov	di,ax
	add	di,[si]		; x coord in byte #
	mov	cx,[si+4]
	shr	cx,1		; divide by 2
	mov	bx,[si+6]
	mov	n,0
	call	scrfbx		; fill in a nice box

	

	mov	di,saveadr
	mov	si,di
	add	si,8+8
rmsgloop:
	mov	al,[si]
	or	al,al
	js	rmsgdone
	mov	saveadr,si
	add	si,2
	mov	cx,80
plnlop:
	push	cx
	lodsb
	or	al,al
	jz	lndone

	mov	di,saveadr
	mov	dh,[di+1]
	mov	dl,[di]
	add	dl,80
	sub	dl,cl
	xor	bx,bx
	mov	ah,2
	int	10h		; set cursor location

	mov	cx,1
	mov	ah,9h
	mov	bx,07h
	int	10h		; write the line of text
	pop	cx
	loop	plnlop
	jmp	lndone1
lndone:
	pop	cx
lndone1:
	jmp	rmsgloop

rmsgdone:
;	mov	ax,1000
;	call	sleep_msec
;	call	flush_keys

;	call	get_chr

;	call	grab9
	mov	escwaitflag,-1	; wait for the escape key release if one
	call	tmr_reset		; restart time accounting
	cli
	mov	al,6			; set timer mode 3
	mov	cx,tickdiv		; reload value is much smaller
	call	set_timer0
	cli
	call	grab08			; regrab timer ints
	sti				; reable ints

	mov	scnflg,0		; clear key-ready flag
	mov	ax,cs:oticks		; get timer ticks
timeupwait:
	mov	bx,cs:oticks
	sub	bx,ax
	cmp	bx,100			; wait for 100 ticks
	jb	timeupwait

waitforpress:
	cmp	scnflg,0
	jz	waitforpress
	test	scncode,80h
	jnz	waitforpress		; wait for keypress down before 
					; proceeding

		mov	al,scncode
		mov	ah,al
		and	ah,07fh
;	cmp	ah,1ch	; carriage return?
;	jz	getusout
	cmp	ah,4eh
	jz	getusout
;	cmp	joyflag,0		; if keyboard user, ignore space
;	jz	skipspst
;
;	cmp	ah,039h
;	jz	getusout


skipspst:
	mov	scncode,0	; clear any code which may be there
	mov	scnflg,0	; clear any code which may be there

waiteotime:



		cmp	scnflg,0
		jz	waiteotime
		mov	al,scncode
		cmp	al,4eh
		jz	getusout
		test	al,80h
		jz	waiteotime
	mov	ah,al
	and	ah,7fh
	cmp	ah,3ch	; F2?
	jnz	getusout2
	mov	intowerflag,1
	jmp	getusout
getusout2:
	cmp	ah,3eh	; F4?
	jnz	getusout
	mov	helpreqflag,-1		; request help
nogetusout1:

getusout:
	mov	al,scncode
	and	al,7fh
	cmp	al,18h			; check for o
	jnz	noaltoff
	mov	altmsgflag,0
noaltoff:
	mov	scncode,0		; remove keypress from variable
getusout1:

	pop	ax
	mov	vboff,ax
	test	ah,70h	
	jnz	adrok
	mov	ax,7e00h		; display other page
	xor	bx,bx
	call	strtadr
adrok:
	ret
.endp

IF guns
.proc	findbul	auto		; finds next avail bullet in system
	mov	si,bulptr	; get current pointer
	mov	cx,nbuls	; don't loop thru more than once
fbull1:	cmp	word ptr [si+24],0	; see if this bullet is active
	jnz	notbulfree		; found one!
	mov	al,byte ptr [si+18]
	or	al,al
	js	bulfree
;	inc	byte ptr [si+18]
notbulfree:
	add	si,nbytebul	; if not, goto next bullet
	cmp	si,offset @dataseg:bptrmx
				; but be careful not to go off the end
	js	bptrok		; looks ok from here...
	mov	si,offset @dataseg:bullets
bptrok:	
	loop	fbull1		; try again
	stc			; set error flag
	ret
bulfree:
	mov	bulptr,si	; save back into variable
	clc			; reset error flag
	ret
	.endp

.proc	clearbullets	auto
	mov	si,offset @dataseg:bullets
	mov	bulptr,si
	mov	cx,nbuls
cbulp:
	mov	word ptr [si+24],0
	mov	byte ptr [si+18],-1
	add	si,nbytebul	; if not, goto next bullet
	loop	cbulp
	ret
.endp


.proc	bulstrt	auto
	mov	bulmatptr,offset @dataseg:nnzmat
	mov	bulorgptr,offset @dataseg:oxeff
	cmp	bulyoff,0
	jnz	arbitrat
	mov	bulyoff,ebulyoff
arbitrat:
	cmp	ejectflag,0
	jz	normbullets
	cmp	remoteflag,0
	jnz	normbullets
	mov	bulmatptr,offset @dataseg:norot
	mov	bulorgptr,offset @dataseg:ox
	mov	bulyoff,0
	mov	bulavg,33
	dec	ammoleft
	jns	normbullets
	mov	ammoleft,0
	ret
normbullets:
IF soundflag EQ 0
		mov	bl,1		; make bullet sound
		call	voiceoff
		mov	bl,1
		mov	ax,200h
		call	voiceon
ENDIF
	
	call	findbul		; try to find bullet
	jnc	nbulero		; error, no free bullets
bulero:	ret
nbulero:
	mov	bx,si
	mov	si,bulmatptr
	mov	ax,ctopv
	add	ax,bulvel
	mov	di,ax
	hmul	di,[si]
	mov	[bx+46],dx
	hmul	di,[si+6]
	mov	[bx+48],dx
	hmul	di,[si+12]
	mov	[bx+50],dx
	mov	ax,bullife		; set lifetime at nbuls
	uwtadj				; relativise for machine speed
	mov	[bx+52],ax
	xor	ax,ax			; set distance to near
	mov	[bx+18],al
	mov	cx,6
	mov	ax,ds
	mov	es,ax
	mov	di,bx
	mov	si,bulorgptr
	rep	movsw
;	mov	ax,bulyoff		; make bullets come from wings
	mov	si,bulmatptr
	hmul	bulyoff,[si+2]
	mov	ax,dx
	cwd
	add	[bx],ax
	adc	[bx+2],dx
	hmul	bulyoff,[si+8]
	mov	ax,dx
	cwd
	add	[bx+4],ax
	adc	[bx+6],dx
	hmul	bulyoff,[si+14]
	mov	ax,dx
	cwd
	add	[bx+8],ax
	adc	[bx+10],dx
	neg	bulyoff
	mov	word ptr [bx+24],9
	cmp	ejectflag,0
	jz	bulletsdest
	cmp	remoteflag,0
	jz	bulletsdest
	mov	word ptr [bx+24],1	; destructable bullets
bulletsdest:
	mov	si,offset @dataseg:tblist
	mov	si,[si]			; add to near table list
	call	tbadd
	inc	bulavg			; add 2 to bullavg
	inc	bulavg
	ret
.endp

.proc	bobjmov	auto			; moves an object pointed to by
					; si
;	mov	ax,objdisp
;	call	wword
;	mov	ax,objdamp
;	call	wword
;	mov	ax,tckgrav
;	call	wword
;	call	exit_ok
	mov	bx,objdisp
	call	randr_w
	shr	bx,1
	sub	ax,bx
	add	ax,[si+46]
	mov	[si+46],ax
	cwd
	dwtadj
	add	[si],ax
	adc	[si+2],dx
	mov	bx,objdisp
	call	randr_w
	shr	bx,1
	sub	ax,bx
	add	ax,[si+48]
	mov	[si+48],ax
	cwd
	dwtadj
	add	[si+4],ax
	adc	[si+6],dx
	mov	bx,objdisp
	call	randr_w
	shr	bx,1
	sub	ax,bx
	add	ax,[si+50]
	mov	[si+50],ax
	sub	ax,tckgrav		; subtract gravity effect
	cwd
	dwtadj
	add	[si+8],ax
	adc	[si+10],dx
;	jmp	obmlb3

	jns	tobmlb3
	xor	ax,ax
	mov	[si+8],ax
	mov	[si+10],ax
	push	cx
	push	di
	push	si
	call	strtpuff		; make a puff of smoke
	pop	si
	pop	di
	pop	cx
	mov	ax,ds
	mov	es,ax
	mov	di,si
	add	di,46
	push	cx
	mov	cx,4
	xor	ax,ax
	cld
	rep	stosw
	pop	cx
	stc
	ret				; set carry for error
tobmlb3:
	clc
	ret
.endp

.proc	bulmov	auto
	mov	si,offset @dataseg:bullets
	mov	cx,nbuls
	or	cx,cx
	jnz	bulsag
	or	tempsum,cx		; fake busyness
	jmp	nobuls
bulsag:	mov	ax,buldisp		; dispersion of bullet velocities
	mov	objdisp,ax
	mov	tckgrav,54
bulmlp:
	cmp	word ptr [si+52],0	; see if bullet has run out
	js	bulkil
	jz	bulkil
;	mov	di,offset @dataseg:obj5d
;	mov	ax,[si]
;	mov	dx,[si+2]
;	.subs_dd	dx,ax,[di+2],[di]
;	.abs_d	dx,ax
;	or	dl,ah
;	or	dx,dx
;	jnz	movon
;	mov	ax,[si+4]
;	mov	dx,[si+6]
;	.subs_dd	dx,ax,[di+6],[di+4]
;	.abs_d	dx,ax
;	or	dl,ah
;	or	dx,dx
;	jnz	movon
;	mov	ax,[si+4]
;	mov	dx,[si+6]
;	.subs_dd	dx,ax,[di+6],[di+4]
;	.abs_d	dx,ax
;	or	dx,dx
;	jnz	movon
;	cmp	ax,l4
;	jns	movon
;	mov	blowflg,-1
;movon:
	dec	word ptr [si+52]
	call	bobjmov			; move object
bulml0:	
	add	si,nbytebul
	loop	bulmlp
nobuls:	ret
bulkil:	mov	word ptr [si+24],0
	jmp	bulml0
	.endp
ENDIF ; guns

IF 0
.proc	evalgpt	auto		; see if a ground detail point is too far
	pushf			; save carry flag
	mov	ax,dxvec
	mov	dx,dxvec+2
	.abs_d	dx,ax
	mov	bx,dxvec+6
	mov	cx,dxvec+4
	.abs_d	bx,cx
	.cmp_dd	dx,ax,bx,cx
	jg	xbigr
	mov	dx,bx
	mov	ax,cx
xbigr:	mov	bx,oz+2
	mov	cx,oz
	rept	6
	shl	cx,1
	rcl	bx,1
	endm
	.cmp_dd	dx,ax,bx,cx
	jl	gpnfar		; ground point is not too far away
	popf
	stc			; leave flag to redo point
	pushf

gpnfar:
	popf
	ret
	.endp
ENDIF


.proc	grand	auto			; generates a double word random
					; number from +- gsize equate
	mov	bx,gsize
	call	randr_w		; get random top number
	mov	dx,ax
	call	rand_w		; get pure random bits
	sub	dx,gsize/2	; make centered around zero
	ret
.endp

.proc	drandr	auto		; gives a double random # in the range
				; 0-dx:ax
	push	dx
	push	ax
	push	ax
;	push	dx
	call	rand_w		; get random number
;	mov	dx,ax
;	mul	dx
;	mov	bx,dx
;	pop	dx
	mov	bx,ax
	pop	ax
	push	dx
	mul	bx
	pop	ax
	push	dx
	mul	bx
	pop	bx
	add	ax,bx
	adc	dx,0
	pop	cx
	pop	bx
	sar	bx,1
	rcr	cx,1
	.subs_dd dx,ax,bx,cx
	ret
.endp

.proc	grndpt	auto
;	mov	ax,oz
	mov	dx,oz+2		; check height, to see if we should make low
	or	dx,dx		; ground detail
	js	grpabt		; about if underground
;	mov	bx,300		; ramp the probability
;	div	bx		; from 0 to 50 percent
;	add	ax,1000		; heres the 50 percent bias
;	mov	xtemp,ax	; save for later
;	mov	dx,ax		; save it in dx
;	mov	dx,100
;	mov	bx,1000
;	call	randr_w
;	cmp	ax,dx	
	jmp	upclos		; make one up close if possible
fgrndpt:
	call	grand
;	add	ax,ox		; add in the current xy position of the plane
;	adc	dx,ox+2
	mov	es:[si],ax
	mov	es:[si+2],dx
	call	grand
;	add	ax,oy		; add in the current xy position of the plane
;	adc	dx,oy+2
	mov	es:[si+4],ax
	mov	es:[si+6],dx
	xor	ax,ax
	mov	es:[si+8],ax
	mov	es:[si+10],ax
	mov	es:[si+12],ax
grpabt:	ret
upclos:	
	mov	dx,oz+2		; get height
	mov	ax,oz
	rept	6
	shl	ax,1
	rcl	dx,1
	endm
	call	drandr		; get random 0 to oz
	add	ax,ox		; add in the current xy position of the plane
	adc	dx,ox+2
	mov	es:[si],ax
	mov	es:[si+2],dx

	mov	dx,oz+2		; get height
	mov	ax,oz
	rept	6
	shl	ax,1
	rcl	dx,1
	endm
	call	drandr		; get random 0 to oz
	add	ax,oy		; add in the current xy position of the plane
	adc	dx,oy+2
	mov	es:[si+4],ax
	mov	es:[si+6],dx
	xor	ax,ax
	mov	es:[si+8],ax
	mov	es:[si+10],ax
	mov	es:[si+12],ax
	ret
.endp


.proc	sgrndpt	auto
	mov	bx,ssize
	call	randr_w		; get random top number
	mov	dx,ax
	call	rand_w		; get pure random bits
	sub	dx,ssize/2	; make centered around zero
	mov	es:[si],ax
	mov	es:[si+2],dx
	mov	bx,ssize
	call	randr_w		; get random top number
	mov	dx,ax
	call	rand_w		; get pure random bits
	sub	dx,ssize/2	; make centered around zero
	mov	es:[si+4],ax
	mov	es:[si+6],dx
	xor	ax,ax
	mov	es:[si+8],ax
	mov	word ptr es:[si+10],ssize/8
	mov	es:[si+12],ax
	ret
.endp

.proc	crash	auto		; crashes plane
	cmp	invincible,0
	jz	killit
	jmp	bounceit
killit:
IF soundflag EQ 0
	call	scrapeinit		; change missle sound to scrape
	mov	windflag,0
	call	snaresnd		; make noise
		mov	bl,4
		mov	ax,10h
		call	voiceon		; make big boom
	mov	bl,3		; make a tiny screech
	mov	ax,300h
	call	voiceon
		mov	bl,2
		call	voiceoff
		call	b3laminit
		mov	bl,2
		mov	ax,10h
		call	voiceon
ENDIF

	and	missionstatus,0fffeh	; clear abort bit
	or	missionstatus,2		; set killed bit
	inc	nplaneslost
;	or	crshflg,-1
	cmp	vboff,0		; are we writing to video page 0?
	jz	crslb1
	call	flipage
crslb1:	
	mov	dx,3ceh		; dx := graphics controller port addr
	mov	ah,4
	xor	al,al
	out	dx,ax		; put color selection in set/reset reg
	mov	ax,0f01h
	out	dx,ax		; put 0fh in bit plane enable
	mov	ah,0
	mov	al,3
	out	dx,ax		; 0 for the RWM bits of the ALU
	mov	ax,0305h	; write mode 3 select
	out	dx,ax
	mov	cx,7e00h
	mov	di,0
	mov	ax,0a000h
	mov	es,ax
	mov	ax,-1
	rep	stosb
	mov	dx,3ceh		; dx := graphics controller port addr
	mov	ax,5
	out	dx,ax		; write mode 0
	xor	ax,ax
	out	dx,ax
	mov	cx,18
	mov	ah,110
crslp:	push	cx
	mov	bx,7eh
	call	randr_w
	xchg	ah,al
	call	strtadr
	mov	cs:ticks,0
crswlp:	
	cmp	cs:ticks,0
	jz	crswlp
	pop	cx
	loop	crslp
IF soundflag EQ 0
				; turn off scraping sound
	mov	al,20h
	mov	bl,0bdh
	call	adlwrt
ENDIF
	mov	ah,0
	call	strtadr
	mov	ax,750
	call	sleep_msec
	ret
bounceit:
	call	resetplane
;	mov	cs:cecode,79
	ret
.endp

.proc	resetplane	auto		; sets plane back up after fall
	mov	crshflg,0
	call	bouncevert
	mov	di,offset @dataseg:ox
	cmp	ejectflag,0
	jz	binplane
	mov	di,offset @dataseg:obj5d
binplane:
	mov	ax,hmin
	mov	[di+8],ax
	xor	ax,ax
	mov	[di+10],ax		; clear z, pitch and roll
	mov	[di+14],ax
	mov	[di+16],ax
	ret
.endp
.proc	runstars	auto		; jump to stars program
	mov	si,offset envstr+4
	mov	word ptr [si],0
	mov	ax,ds
	mov	es,ax
	mov	di,offset starsname
IF shareflag EQ 0
	mov	si,offset envstr
ELSE
	mov	si,offset envstr+4
ENDIF
	call	exec_prog
	jnc	srtmainl0
	mov	cs:cecode,61
srtmainl0:
	ret
.endp

.proc	runtower	auto			; runs c program for mission
						; briefings
	mov	ax,curtower
	cmp	bossflag,0			; is it the boss?
	jz	nottheboss
	mov	ax,-1
nottheboss:
IF soundflag EQ 0
		push	ax
		mov	bl,0		; turn off voice
		mov	ax,100h
		call	voiceoff
		mov	bl,2
		mov	ax,10h
		call	voiceoff	; turn voice off (blams)
		mov	bl,3
		mov	ax,10h
		call	voiceoff	; turn voice off (blams)
		mov	sauceronflag,0
		mov	orbonflag,0	; temp turn of saucer and orb noise
		pop	ax
ENDIF
	cmp	rejoyflag,0
	jz	skiprejoy
	call	nwjctr
	cmp	cs:cecode,93
	jnz	nojabort
	mov	cs:cecode,0
nojabort:
	mov	rejoyflag,0
	clc
	ret
skiprejoy:
	mov	si,offset envstr+4
	cmp	bossflag,07fh		; check for iscore request
	jnz	noiscore2
IF MVPCD
	push	si
	mov	di,si
	mov	si,offset @dataseg:wpath
	mov	ax,ds
	mov	es,ax
	call	str_cpy
	pop	si
ENDIF
	jmp	skipskiptu		; skip rest of cmd line bull
noiscore2:
	cmp	bossflag,07dh
	jnz	skiptu
	xor	ax,ax
	mov	curtilex,ax
	mov	curtiley,ax
	call	gettileadr
	mov	dx,es
	mov	ax,di
	mov	bx,16
	call	dword_to_asc

IF fptrdiag EQ 1
	call	put_newline
	call	put_str
	call	put_newline
	push	si
	mov	cx,256
poloop:
	mov	ax,cx
	and	ax,0fh
	jnz	noskipln
	call	put_newline
noskipln:
	mov	si,offset @dataseg:kbuf
	mov	ax,es:[di]
	call	word_to_hex
	call	put_str
	add	di,2
	loop	poloop
	pop	si
	call	put_newline
	call	get_chr
ENDIF
	jmp	skipskiptu
skiptu:
	call	word_to_dec

IF MVPCD
	mov	di,si		; cat on the file and path
	mov	si,offset @dataseg:spacewpath
	mov	ax,ds
	mov	es,ax
	mov	di,offset envstr+4
	call	str_cat
	mov	si,offset @dataseg:twrdatname
	mov	di,offset envstr+4
	call	str_cat
	mov	si,offset envstr+4
ENDIF
skipskiptu:
	mov	ax,ds
	mov	es,ax
	mov	di,offset towername
	cmp	bossflag,07fh
	jnz	nonoscore		; must want score
	mov	di,offset @dataseg:scorename
IF shareflag
	mov	si,offset @dataseg:noismsg
	call	put_str
	call	get_chr
	ret
ENDIF
nonoscore:
	cmp	bossflag,07dh
	jnz	skiptu2
IF shareflag
	mov	si,offset @dataseg:notumsg
	call	put_str
	call	get_chr
	ret
ENDIF
	call	flushtiles
	call	drawnear	; now let objects really die
	call	cleanexp	; clean out exp table thouroghly
IF guns
	call	clearbullets
ENDIF ; guns
	call	writeunivfile
	mov	ax,ds
	mov	es,ax
IF MVPCD			; only needed for CD, otherwise give empty
				; string
	mov	di,offset @dataseg:kbuf
	mov	si,offset @dataseg:univname
	call	str_cpy
	mov	si,offset @dataseg:kbuf
ELSE
	mov	si,offset @dataseg:kbuf
	mov	byte ptr [si],0
ENDIF
	mov	di,offset @dataseg:intname
	call	exec_prog
	jnc	rtmainl0
	jmp	rtmainl3a
skiptu2:
	mov	si,offset envstr
	call	exec_prog
	jnc	rtmainl0
rtmainl3a:
	mov	si,offset rtemsg
rtmainl3:	call	put_str
	mov	cs:cecode,61
	ret
rtmainl0:
	or	al,al
	jz	rtmainl1
	mov	si,offset rtmsg1
	jmp	rtmainl3
rtmainl1:	
	cmp	intowerflag,0		; was it tower.exe that was called?
	jz	nointower
	cmp	ejectflag,0
	jnz	nointower		; cant start in air with no plane!
	call	getstartfile		; read in starting file info
nointower:
	ret
.endp


.proc	donewmiss	auto	; if needed, reset plane position
	cmp	newmissflag,0
	jnz	isnewmiss
isnotnewm:
	ret

isnewmiss:
	cmp	totaldamage,16
	jb	damnsbad
	mov	newmissflag,0
	mov	rmsgqueue,offset @dataseg:cantf2rmsg
	jmp	isnotnewm
damnsbad:
	call	flushtiles	; before the xfer
	call	drawnear	; now let objects really die

	mov	si,offset @dataseg:tempstart
	mov	di,offset @dataseg:ox
	mov	ax,ds
	mov	es,ax
	mov	cx,8		; only change x,y,z,yaw
	cld
	rep	movsw


				; now redo the rotation matrices
		mov	bx,offset @dataseg:orvec
		call	calcsin
		mov	si,offset @dataseg:orot
		call	calcmat
		mov	si,offset @dataseg:nzmat
		call	calcmat
		mov	si,offset @dataseg:norot
		call	ncalcmat
		mov	si,offset @dataseg:norot
		mov	di,offset @dataseg:nnzmat	; save zrmat for later exam
		mov	cx,9
		mov	ax,ds
		mov	es,ax
		cld
		rep	movsw

		mov	si,offset @dataseg:topv
		mov	word ptr [si],5000
		xor	ax,ax
		mov	[si+2],ax
		mov	[si+4],ax

		mov	bx,offset @dataseg:nnzmat
		mov	di,offset @dataseg:rtopv
		call	matvmul
		mov	cl,4
		mov	ax,topv
		sar	ax,cl
		mov	ctopv,ax
		mov	ax,topv+2
		sar	ax,cl
		mov	ctopv+2,ax
		mov	ax,topv+4
		sar	ax,cl
		mov	ctopv+4,ax
			
	call	dotiles		; read the suckers back in
	xor	ax,ax
	mov	newmissflag,al
	mov	freezeflag,al
	mov	standingflag,al
	mov	groundflag,al
	mov	homenowflag,al
	mov	closetowerflag,al
	mov	homeflag,al
	mov	orbonflag,-1
	mov	ax,currpmx
	mov	rpm,ax		; advance throttle to maximum
		xor	ax,ax
		mov	dx,rpm				; calc max temperature
		shr	dx,1
		rcr	ax,1
		mov	bx,rpmx
		div	bx
		mov	dx,thrtmult
		mul	dx
		mov	ax,dx
		mov	opres,ax
	ret
.endp


IF protection
.proc	bounceimg	auto		; readimg but with bouncing ball
					; routine will not return until
					; ball is finished

	push	ax
	call	soundoff		; turn off sound
;	.push	ax,bx,cx,dx,si,di
	mov	fadecolor,255
	mov	avgdvelh,0	
	mov	al,255
	xor	ah,ah
	call	setcolors
;	.pop	ax,bx,cx,dx,si,di
	pop	ax

	mov	ballx,21
	mov	bally,100
	mov	vbally,-12

	call	readimg

bouncewait:
	mov	al,1ch
	call	getkbit
	push	ax
	mov	al,4ch
	call	getkbit
	pop	bx
	and	al,bl
	push	ax
	mov	al,1eh
	call	getkbit
	pop	bx
	and	al,bl
	jz	nokeysave
	mov	ballx,10
	mov	al,weltablemaxi		; compare to max allowable index
	mov	weltableindex,al
nokeysave:
	mov	ax,ballx
	cmp	ballx,10
	jz	balldrawdone
	mov	ax,cs:ticks
	cmp	ax,ballticks
	jz	noballdraw
	mov	ballticks,ax
	call	drawball
noballdraw:
	jmp	bouncewait
balldrawdone:
	mov	scncode,0		; clear buffer
spaceloop:
	cmp	scncode,39h+80h		; wait for space bar
	jnz	spaceloop
	mov	scncode,0		; clear buffer
	call	soundon
	
	ret
.endp
ENDIF

.proc	readimg	auto			; reads in image of inst panel to scrn
	mov	si,offset envstr+4
	mov	word ptr [si],0			; leave nothing in command line

	or	al,al			; is this the inst panel, or not?
	jz	isinstpanel

	xor	ah,ah
	call	word_to_dec			; put argument in cmd line
	jmp	noringcmdln		; skip this emptyness
isinstpanel:
	mov	n,0
	mov	bx,vysiz-gfymax
	mov	cx,40
	mov	di,gfmxb
	call	scrfbx		; erase contents of other window
	call	flipage
	mov	n,0
	mov	bx,vysiz-gfymax
	mov	cx,40
	mov	di,gfmxb
	call	scrfbx		; erase contents of other window
	call	flipage

noringcmdln:
	mov	si,offset envstr+4
	mov	ax,ds
	mov	es,ax
	mov	di,offset rimgname
	mov	si,offset envstr+4
	call	exec_prog
	or	al,al			; was rimg happy?
	jnz	mainlfu			; yes, leave with a smile
	jnc	mainl0r
mainlfu:
	mov	cs:cecode,40		; leave error code for messed up rimg
	stc
	ret
mainl0r:
	clc
	ret		; leave carry set if error
.endp


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
	mov	ax,vgseg		; set segment
	mov	es,ax
	mov	di,0
	mov	cx,32767
	mov	al,0
	cld
	rep 	stosb
	pop	di
	pop	si
	mov	sp,bp
	pop	bp
	ret
hgcmode	endp
ENDIF

IF xrv EQ 4
mnew08
mwelcomewagon
mdolandinggear
mnew9
cecode	db	0
ENDIF

.proc	damageplane	auto	; this routine damages plane in a random fashon
	cmp	invincible,0
	jnz	nodamage
	cmp	totaldamage,200
	ja	nodamage	; don't go overboard with the damage
	.push	si,di
pdamageloop:
	push	cx
	mov	shakecnt,6	; shake plane
	inc	totaldamage	; keep track of total damage to plane
	mov	bx,4		; four types of damage
	call	randr_w		; pick one
	add	ax,ax
	mov	si,offset @dataseg:damtable	; get address of damage
	add	si,ax
	call	[si]		; jump to that routine
	pop	cx
	loop	pdamageloop	; damage plane cx times
	.pop	si,di
	mov	ax,totaldamage
	cmp	maxtotaldamage,ax	; worst damage ever?
	jae	nodamage		; nope
	mov	maxtotaldamage,ax	; replace record damage
nodamage:
	ret
.endp


.proc	wingdam	auto	; damage to wing
	mov	ax,thrdam		; get total damage, to make sure 
					; too much will not occur
	.abs_w	ax
	cmp	ax,80*20		; no more than 20 hits worth
	ja	wdrtn
	
	mov	bx,1
	call	drawdamage		; draw damage on inst panel
	mov	ax,thrdamunit
	uwtadj				; lessen the effect on slower machines
	mov	dx,ax
	call	rand_w		; affect random wing
	or	ax,ax
	jns	leftwing
	neg	dx
leftwing:
	add	thrdam,dx
	mov	ax,winglossunit	; put hole in lift
	add	wingloss,ax
wdrtn:	ret
.endp

.proc	yawdamage	auto	; damage to wing
	mov	ax,yawdam		; get total damage, to make sure 
					; too much will not occur
	.abs_w	ax
	cmp	ax,15*20		; no more than 20 hits worth
	ja	ydrtn
	mov	bx,3
	call	drawdamage		; draw damage on inst panel
	mov	ax,yawdamunit
	uwtadj				; lessen the effect on slower machines
	mov	dx,ax
	call	rand_w		; affect random wing
	cmp	yawdam,0	; damage already?
	jz	noyawdamyet
	mov	ax,yawdam
noyawdamyet:
	or	ax,ax
	jns	leftrud
	neg	dx
leftrud:
	add	yawdam,dx
ydrtn:	ret
.endp

.proc	stabdamage	auto	; damage to wing
	mov	ax,stabunit
	uwtadj
	mov	dx,ax
	add	stabdam,dx
	mov	bx,2
	call	drawdamage		; draw damage on inst panel
	ret
.endp

.proc	engdamage	auto	; damages engine
	inc	engdam		; increment amount of damage to engine
	mov	ax,currpmx
	mov	dx,engdamunit	; how much damage?
	mul	dx
	mov	bx,1000
	div	bx
	cmp	ax,20		; lowest available throttle
	jb	nomoreedam
	mov	currpmx,ax
	cmp	ax,rpm		; if rpm is > max, then bring it down
	jae	rpmok
	mov	rpm,ax
rpmok:
	mov	bx,0		; point to engine damage indicator bar table
	call	drawdamage	; show damage
nomoreedam:
	ret
.endp

.proc	restoreview	auto		; tries to determine the current view
					; and restore you to it
	mov	ax,ptrgwinf		; check to see if full screen desired
	cmp	ax,offset @dataseg:gwinfs
	jnz	notfulls
	jmp	fullsize		; just make a fullsize parambulus
notfulls:
	cmp	ax,offset @dataseg:gwinf	; are we interior?
	jnz	uhohnotin

	call	interiorview
	call	damageinit
	call	redrawbuts		; redraw the buttons
	ret

uhohnotin:
	mov	cs:cecode,29
	ret
.endp

.proc	fullsize	auto		; goes to the fullsize main window
	mov	ax,ptrgwinf		; check to see if it's already up
	cmp	ax,offset @dataseg:gwinfs
	jz	ndonefs1		; do nothing if already up

	xor	ax,ax
	mov	ptrgwint,ax		; turn off rear window
	mov	instflag,al		; turn off instruments
	mov	ax,offset @dataseg:gwinfs
	mov	ptrgwinf,ax		; turn on full screen
ndonefs1:
	ret
.endp

.proc	swing	auto		; swing chute in the air
	call	joytd
	sub	ax,200h	
	sub	bx,200h	
	.abs_w	ax
	.abs_w	bx
	add	ax,bx
	cmp	ax,20h
	ja	stopswing
	mov	dx,oz+2
	mov	ax,oz
	sub	ax,myzground
	sbb	dx,myzground+2
	or	dx,dx
	jns	okbaby
	jnz	okbaby
	cmp	ax,hmin
	ja	okbaby
stopswing:
	mov	swingcount,0
	ret
okbaby:
	mov	ax,swingcount	; get time value
	cmp	ax,swingmx
	ja	noswingyet
	jz	swingnowrdy
	mov	bx,swingmx
	sar	bx,1
	sub	ax,bx
	jns	swingsok
	xor	ax,ax		; give zero if argument negative
swingsok:
	push	ax		; save count for later
	mov	bx,swingmx
	sar	bx,1
	sub	bx,ax		; make it zero on up
	mov	bx,900
	mul	bx
	call	scos		; get the angle
	pop	bx		; get count
	push	ax
	mov	ax,1
	mul	bx
	pop	bx
	imul	bx
	sal	dx,1		; this is the factor to add
	add	orvec+2,dx
	add	orvec+2,dx
	mov	ax,orvec+2
	neg	ax
	mov	cl,5
	sar	ax,cl
	add	orvec+2,ax
noswingyet:
	dec	swingcount
	ret
swingnowrdy:
	xor	ax,ax
	mov	tmbvec,ax
	mov	tmbvec+2,ax
	mov	si,offset @dataseg:oorvec
	mov	di,offset @dataseg:orvec
	mov	ax,ds
	mov	es,ax
	mov	cx,3
	rep	movsw
	dec	swingcount
	ret
.endp

.proc	bouncevert	auto	; bounces plane up when it hits the ground
	mov	ax,rtopv+4	; reverse velocity, and divide by two
	or	ax,ax		; make sure the vel is down
	jns	ralpos
	neg	ax		; reverse direction: bounce
	mov	bx,ax		; if we are going < 90 mph
	cmp	topv,3000	; if we are going slow, make shocks work better
	jb	dampout
	sar	bx,1
	sar	bx,1
dampout:
	sar	bx,1
	sub	ax,bx
	mov	rtopv+4,ax
ralpos:
	ret
.endp

.proc	killss	auto
	mov	topv+2,0		; kill side slip
	mov	si,offset @dataseg:topv
	mov	bx,offset @dataseg:nnzmat
	mov	di,offset @dataseg:rtopv
	call	matvmul
	ret
.endp


.proc	set5dbits	auto	; set crashland bits in obj5d bits
	test	obj5dbits,4
	jnz	hoogiewhatsit	; if crashland bit already set, don't bother
	mov	al,homeflag
	shl	al,1			; if only 1, then atleast shift bit up
	and	al,2		; isolate bit representing crashland
	jnz	nothomelost	; if not home, plane is a lost cause
	inc	nplaneslost
nothomelost:
	or	al,4		; set crashlanded bit
	xor	ah,ah
	or	obj5dbits,ax
	ret
.endp

.proc	qcrashland	auto	; checks for crashlanding, and takes action
	cmp	crshlndflag,0
	jz	nocrshlandyet
	cmp	ejectflag,0
	jz	hoogiewhatsit
	cmp	obj5d+24,0
	jz	hoogiewhatsit
	call	set5dbits
	mov	si,offset @dataseg:obj5d
	stc			; destroy plane
	call	odest
hoogiewhatsit:
	cmp	invincible,0
	jz	watchdie
	call	resetplane
;	mov	cs:cecode,78
	mov	crshlndflag,0	; turn off crash
	ret
watchdie:
	mov	rpm,20
	cmp	currpmx,0
	jz	nocrshlandyet	; don't bother if already crashed
IF soundflag EQ 0
	call	scrapeinit		; change missle sound to scrape
	mov	windflag,0
	call	snaresnd		; make noise
	mov	bl,3		; make a tiny screech
	mov	ax,300h
	call	voiceon
	call	b3laminit
		mov	bl,2	; make a blam
		mov	ax,10h
		call	voiceoff
		mov	bl,2	; make a blam
		mov	ax,10h
		call	voiceon
ENDIF
	
	mov	currpmx,0	; kill throttle during crash land
nocrshlandyet:
	ret
.endp

IF soundflag EQ 0
.proc	b3laminit	auto	; changes boom sound to blam
	call	blaminit
	mov	ax,-1
	mov	blamtick,ax
	ret
.endp

.proc	b3oominit	auto	; changes boom sound to blam
	call	boominit
	mov	blamtick,0	; reset boom voice flag
	ret
.endp
ENDIF
	
.proc	qhomebase	auto	; checks for being over home base
;	mov	homenowflag,0	; not home until proven home
;	mov	ax,oxeff+2
;	cmp	ax,roadx+1
;	jg	nothome
;	cmp	ax,roadx-4
;	jl	nothome
;	mov	dx,oyeff+2
;	mov	ax,oyeff
;	add	ax,2*w
;	adc	dx,0
;	js	nothome
;	jnz	nothome
;	cmp	ax,4*w
;	jg	nothome
;	mov	homeflag,-1	; yeah, we are home!
;	mov	homenowflag,-1	; yeah, we are home!
;nothome:
	mov	ah,homenowflag
	mov	al,closetowerflag
	mov	bl,al
	shr	bl,1
	or	ah,bl
	and	al,1
	and	ah,al
	mov	homenowflag,ah
	mov	homeflag,ah
	jz	nothome

;	mov	homenowflag,0	; not home until proven home
;	cmp	closetowerflag,0	; are we on a runway?
;	jz	nothome
;	mov	homeflag,-1
;	mov	homenowflag,-1	; yes, so set flag
nonothome:
	ret
nothome:
	cmp	frmnum,20		; don't try to not set this until
	jb	nonothome			; we've had a couple seconds to
					; think about it
	mov	neverleftflag,0		; now show that we have left home
	ret
.endp


.proc	brake	auto
	push	ax				; save 0-15 braking force
	mov	si,offset @dataseg:rtopv	; find mag and direction of
	call	vmag				; of velocity
	mov	si,ax				; hold onto this value
	pop	ax
;	mov	ax,15
	wtadj
	mov	cx,ax				; save
	mov	bx,rtopv			; brakes, for chrissakes!
	neg	bx
	imul	bx
	idiv	si				; this applies deceleration in
	add	rtopv,ax
	mov	ax,cx
	mov	bx,rtopv+2
	neg	bx
	imul	bx
	idiv	si				; this applies deceleration in
						; proper direction
	add	rtopv+2,ax
	ret
.endp
	

.proc	findheight	auto
				; adjusts velocity, and returns carry
				; if it's a crash
				; let's take a look a some key positions
	mov	crshflg,5
	mov	ax,orveceff+4	; are we inverted?
	.abs_w	ax
	cmp	ax,maxroll	;
	ja	death1		; wake up, it's time to die!
	mov	crshflg,7
	mov	ax,orveceff+2	; now check for insane pitch
	.abs_w	ax
	cmp	ax,maxpitch
	ja	death1
	jmp	lowplaneal	; low plane still alive!
death1:	
	stc
	ret
lowplaneal:
	xor	ax,ax		; generate a zero
	mov	crshflg,al
	mov	nwheels,al	; assume neither wheel hits ground
	mov	wingvec,ax
	mov	tmpsum,ax
	mov	tmpsum+2,ax
	mov	ax,hlow
	mov	wingvec+2,ax	; put coords of wheels into a vector
	mov	ax,hmin		; this is the coords of the height
	neg	ax		; wheels extend beneath the plane

	mov	wingvec+4,ax
	mov	bx,offset @dataseg:nnzmat	; get rotation matrix
	mov	si,offset @dataseg:wingvec
	mov	di,offset @dataseg:xvec		; destination
	call	matvmul
	mov	ax,xvec+4	; get depth of wheel
	neg	ax
	mov	tmpsum,ax	; save this depth for later
thiswheelup:
	mov	ax,hlow
	neg	ax		; now do other wheel
	mov	wingvec+2,ax	; put coords of wheels into a vector
	mov	bx,offset @dataseg:nnzmat	; get rotation matrix
	mov	si,offset @dataseg:wingvec
	mov	di,offset @dataseg:xvec		; destination
	call	matvmul
	mov	ax,xvec+4	; get depth of wheel
	neg	ax
	mov	tmpsum+2,ax	; save this depth for later
thatwheelup:
	mov	ax,tmpsum
	mov	bx,tmpsum+2
	cmp	ax,bx
	jg	heightfound
	xchg	ax,bx
heightfound:
	mov	bounceheight,ax
	clc
	ret
.endp

.proc	pitchlock	auto	; verifies that the pitch angle is locked
	mov	ax,rtopv+4
	.abs_w	ax		; get magnitude of up down velocity
	cmp	ax,150		; check for out-of-bounds zvalue
	jnb	noplockdone	; looks good, let's not interfere
plockdone:
	clc			; tell them we didn't do anything
	ret
noplockdone:
levelplane:
	mov	si,offset @dataseg:rtopv	; get magnitude of velocity
	call	vmag
	cmp	ax,3900		; check for speed to low
	jb	loselock	; turn off auto pilot, plane unflyable
	bndck	15500,3901	; force v to be in the autopilot's range
	mov	bx,8		; multiply by 8
	mul	bx		; then divide by max v to scale into table
	mov	bx,15591	; max velocity
	div	bx		; now ax has 0-7, dx has modulo for interpol
	sub	ax,2		; ax is now 0-5
	add	ax,ax		; ax is now 0-10 in steps of 2
	mov	bx,offset @dataseg:locktable
	add	bx,ax		; make bx point to correct table entry
	mov	ax,[bx+2]	; get table+1 value
	mov	bx,[bx]		; get table value
;	jmp	ship	

	sub	ax,bx		; get diff in table for interp
	imul	dx		; multiply by the modulo
	mov	di,15591	; divide by the divisor
	idiv	di		; now ax has the error from the table entries
	add	bx,ax		; now add the error to the base table 
				; so that ax holds the target orveceff+2	
ship:

	mov	ax,orveceff+2	; get current angle
	sub	ax,bx		; difference from desire angle
	bndck	3200,-2000	; this to stop from wanging the plane around
	cwd			; make it a double
	xchg	ax,dx		; but with the number on top
IF simpflag
	mov	bx,70
	cmp	autoflag,0
	jnz	useaval
	cmp	aeroflag,0
	jz	useaval
	cmp	qstald,0
	jnz	useaval		; if stalled, don't bother
	mov	bx,280
useaval:
ELSE
	mov	bx,70		; divide it up nicely
ENDIF
	call	divrs_dw	;
	add	pitdotl,ax
	adc	pitdoth,dx
	stc			; leave flag that pitch is not locked
	ret
loselock:
	mov	autoflag,0	; turn off the autopilot, no chance of auto
	stc
	ret
.endp
	

.proc	dohlock	auto		; locks autopilot to an altitude
	mov	ax,rtopv+4		; check on zvel
	.abs_w	ax			; are we approximately locked?
	cmp	rtopv+4,15
	ja	veltoobig		; if we are locked, then unlock
	cmp	lockflag,0		; determine if we were already locked
	jnz	alrlocked
	mov	lockflag,-1		; set locked flag
	mov	ax,ozeff
	mov	dx,ozeff+2
	mov	lockheightl,ax
	mov	lockheighth,dx		; save present height
	jmp	lockdone
alrlocked:
	mov	ax,ozeff			; get height change from lock
	mov	dx,ozeff+2
	sub	ax,lockheightl		; find error in height
	sbb	dx,lockheighth
	.neg_d	dx,ax
	mov	bx,655			; now mult error in distance
	.muls_dw bx,cx
	add	pitdotl,ax
	adc	pitdoth,dx		; apply to pitch
	jmp	lockdone
veltoobig:
	mov	lockflag,0		; unlock velocity
lockdone:
	ret
.endp

.proc	flashalt	auto		; flashes eject button
	mov	ax,0f00h
	mov	bx,9
	call	drawbutton
	test	cs:oticks,128
	jnz	lflash
	mov	ax,0f00h
	mov	bx,9
	call	drawbutton
	mov	ax,070eh		; load with funky value
	mov	bx,9
	call	drawbutton
	ret
lflash:
	mov	ax,000fh
	mov	bx,9
	call	drawbutton
	mov	ax,0e07h		; load with funky value
	mov	bx,9
	call	drawbutton
	ret
.endp

.proc	flasheject	auto		; flashes eject button
	mov	ax,0400h
	mov	bx,4
	call	drawbutton
	test	cs:oticks,512
	jnz	eflash
	mov	ax,0400h
	mov	bx,4
	call	drawbutton
	mov	ax,070fh		; load with funky value
	mov	bx,4
	call	drawbutton
	ret
eflash:
	mov	ax,0004h
	mov	bx,4
	call	drawbutton
	mov	ax,0f07h		; load with funky value
	mov	bx,4
	call	drawbutton
	ret
.endp

.proc	flashstall	auto	; flashes stall light when close to stal
	.push	ax,bx
	call	rand_w			; get a random number
	cmp	ax,16000
	ja	lightout		; leave light out most of the time

	mov	ax,070eh		; light up the stall idiot light
	mov	bx,3
	call	drawbutton
	mov	ax,000ch		; light up the stall idiot light
	mov	bx,3
	call	drawbutton
	jmp	lstald4
lightout:	
	mov	ax,0e07h		; light up the stall idiot light
	mov	bx,3
	call	drawbutton
	mov	ax,0c00h		; light up the stall idiot light
	mov	bx,3
	call	drawbutton
lstald4:
	.pop	ax,bx
	ret
.endp




.proc	step	auto		; take a step forward
	mov	ax,cs:oticks
	sub	ax,steptick
	.abs_w	ax
	cmp	ax,40
	jle	nostepnow
	mov	ax,cs:oticks
	mov	steptick,ax
	mov	ax,steporvec
	add	orvec,ax
	neg	steporvec
goodstep:	
	mov	ax,orvec+2
	push	ax
	mov	orvec+2,0
	mov	bx,offset @dataseg:orvec
	call	calcsin
	mov	si,offset @dataseg:dnrot
	call	ncalcmat
	pop	ax
	mov	orvec+2,ax
	mov	ax,stepsz
	mov	xvec,ax	; move forward
	mov	xvec+2,0
	mov	xvec+4,0
	mov	si,offset @dataseg:xvec
	mov	bx,offset @dataseg:dnrot
	mov	di,offset @dataseg:surfacev
	call	matvmul
	mov	surfacev+4,0	; no z motion
	call	moveobs
	xor	ax,ax
	mov	surfacev,ax
	mov	surfacev+2,ax
	mov	surfacev+4,ax
nostepnow:
	ret
.endp


.proc	moveobs	auto		; moves observer by surfacev
	mov	cl,4			; divide all velocities by 16
					; before applying to coords	
	mov	ax,surfacev
	sar	ax,cl
	cwd
	dwtadj
	add	ox,ax
	adc	ox+2,dx
	mov	ax,surfacev+2
	sar	ax,cl
	cwd
	dwtadj
	add	oy,ax
	adc	oy+2,dx
	mov	ax,surfacev+4
	sar	ax,cl
	cwd
	dwtadj
	add	oz,ax
	adc	oz+2,dx
	ret
.endp

.proc	divbycl	auto		; divides double number by 2**cl
	cmp	cl,2
	jz	only2
	sar	dx,1
	rcr	ax,1
	sar	dx,1
	rcr	ax,1
only2:
	sar	dx,1
	rcr	ax,1
	sar	dx,1
	rcr	ax,1
;	jnc	dbcret		; this is an attempt at rounding
;	add	ax,1
;	adc	dx,0	; inc the double number
;dbcret:
	ret
.endp


.proc	moveme	auto
					; apply velocity vector to 
					; ovec coords
	mov	cl,4			; divide all velocities by 16
					; before applying to coords	
	test	obj5dbits,2000h
	jz	skiphighspeed
	mov	cl,2			; put on the gas!
skiphighspeed:
	mov	ax,racctop		; get acceleration
;	wtadj				; these are removed cause already dn
	sar	ax,1			; /2 for 1/2at^2
	add	ax,rtopv
	cwd
	dwtadj
	call	divbycl
	add	ox,ax
	adc	ox+2,dx
	mov	ax,racctop+2		; get acceleration
;	wtadj
	sar	ax,1			; /2 for 1/2at^2
	add	ax,rtopv+2
	cwd
	dwtadj
	call	divbycl
	add	oy,ax
	adc	oy+2,dx
	mov	ax,racctop+4		; get acceleration
;	wtadj
	sar	ax,1			; /2 for 1/2at^2
	add	ax,rtopv+4
	cwd
	dwtadj
	call	divbycl
	add	oz,ax
	adc	oz+2,dx
	ret
.endp

IF xrv EQ 3
cecode	db	0
mwelcomewagon
mnew9
mnew08
mdolandinggear
ENDIF


.proc	erasewinf	auto	; erases front window
	mov	n,0		; I want to paint it black
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
	call	scrfbx		; erase contents of other window
aatofar:	
	stc
	ret
.endp

.proc	drawtodxvec	auto		; draws observers view to dxvec
	call	rel3d			; get dxvector to point the way
	jc	aatofar		; too far away
	or	ch,ch			; if cx is zero, then too far
	jnz	aatofar
	and	cl,0f0h			; now check for still too far
	jnz	aatofar		;
	mov	si,offset @dataseg:dxvec
	mov	ax,[si]		; load vector to handy location
	mov	dx,[si+2]
	rept	6
	shr	dx,1
	rcr	ax,1
	endm
	neg	ax			; changing sign as we go
	mov	xvec,ax
	mov	ax,[si+4]		; load vector to handy location
	mov	dx,[si+6]
	rept	6
	shr	dx,1
	rcr	ax,1
	endm
	neg	ax			; changing sign as we go
	mov	xvec+2,ax
	mov	ax,[si+8]		; load vector to handy location
	mov	dx,[si+10]
	rept	6
	shr	dx,1
	rcr	ax,1
	endm
	neg	ax			; changing sign as we go
	mov	xvec+4,ax

	mov	ax,xvec		; then find atn2(delta-y/delta-x)
	mov	dx,xvec+2
	call	atn2
	add	ax,32768	; make point in the opposite direction
	sub	ax,orvec		; difference is what we work on
	mov	cl,7
	cmp	haltflag,0
	jnz	notremoteop	; if being halted, slow down rate
	mov	cl,4		; otherwise, keep right on it
notremoteop:
	sar	ax,cl
	wtadj
	add	orvec,ax
	clc
	ret
.endp

.proc	dodvelavg	auto	; average the dvel to get g factor
	cmp	frmnum,3	; don't do until 3rd frame
	ja	allready
	ret			; just wait a minute!
allready:
	mov	ax,navgdvel
	uwtadj
	mov	bx,ax
	mov	dx,dvel+10	; get z acceleration velocity
	mov	ax,dvel+8
	cmp	ejectflag,0	; if we have ejected, we can't blackout
	jz	noaction1
	xor	ax,ax
	mov	dx,ax		; fade to normal if ejected
noaction1:
	sub	ax,avgdvell
	sbb	dx,avgdvelh
	call	divrs_dw	; divide by navg
	add	avgdvell,ax	; and add to avg
	adc	avgdvelh,dx
	mov	ax,avgdvelh
	bndck	100,-100	; rail it if needed
	mov	avgdvelh,ax
	.abs_w	ax		; either black or red out
	sub	ax,60		; we can take 30 g's, no problem
	js	noblkout
				; now ax is 0-70, which we will scale into
				; 255-0
	mov	bx,255
	mul	bx
	mov	bx,41
	div	bx
	neg	ax
	add	ax,255		; now we have done it!
	mov	fadecolor,al
	test	tripflag1,1	; if tripping, don't mess with palatte
	jnz	tripf2
	call	setcolors	; and make the fade!
tripf2:
noaction:
	ret
noblkout:
	cmp	fadecolor,255	; are we faded back?
	jz	werecool
	mov	fadecolor,255
	mov	al,fadecolor
	test	tripflag1,1	; if tripping, don't mess with palatte
	jnz	tripf3
	call	setcolors
tripf3:
werecool:
	ret
.endp

.proc	allocatemem
;	mov	ax,nmaxmedfar		; get # bytes needed for med far tble
;	mov	dx,nbytexp		; get # bytes per object
;	mul	dx			; find total bytes needed
;	mov	bx,16
;	div	bx
;
;	mov	bx,64
	mov	ax,nparatile		; get number of paragraphs required
	mov	dx,64
	mul	dx
	add	ax,memsegskip		; add in the paragraphs for med tble
	add	ax,1024			; add in some extra
	mov	memsegtotal,ax		; save number of paragraphs total
IF 0 EQ 1
	add	ax,(ntilesx*ntilesy*nobjtile*2+255)/16	; leave room for mb
ENDIF
	mov	cx,1024/16

;	call	wcr
;	call	wword

	call	far_init
IF 0 EQ 1
;	pushf
;	call	wword
;	popf
	sub	ax,(ntilesx*ntilesy*nobjtile*2+255)/16	; leave room for mb
ENDIF
	cmp	ax,memsegtotal		; did we get all the RAM requested?
	jz	wegotram
	mov	si,offset @dataseg:allocmsg1
	call	put_str
	call	decwword
	mov	si,offset @dataseg:allocmsg2
	call	put_str
	xchg	ax,memsegtotal
	call	decwword
	sub	ax,memsegtotal		; find out how many paragraphs short
					; we are
	mov	nplaneslost,ax		; leave in # planes lost
	mov	cs:cecode,90		; leave code for not enough ram avail
	jmp	alcmemerr		; send results to moag
wegotram:
;	call	wword
;	mov	ax,nmaxmedfar		; get # bytes needed for med far tble
;	mov	dx,nbytexp		; get # bytes per object
;	mul	dx			; find total bytes needed
;	xor	dx,dx
	mov	ax,memsegtotal		; allocate it all to us in one shot
	sub	ax,1024			; but leave that 1000 paragraphs
	mov	dx,16
	mul	dx
	mov	cx,1			; cx is number of objects=1
;	call	dwword
	call	far_malloc
	jnc	maerror
	mov	si,offset @dataseg:maerrmsg
	call	put_str
	mov	cs:cecode,90		; leave code for not enough ram avail
	jmp	alcmemerr		; send results to moag
maerror:
	mov	ax,es
	mov	memseg,ax
;	ret
;IF 1 EQ 0
	mov	cx,memsegtotal		; clear all the allocated RAM
	sub	cx,1025			; only clear exactly what we need
	mov	ax,memseg		; initialize memseg RAM to zero
	mov	es,ax
clrramlp:
	push	cx
	mov	cx,16
	xor	di,di
	xor	ax,ax
	cld
	rep	stosb
	pop	cx
	mov	ax,es
	inc	ax
	mov	es,ax
	loop	clrramlp
;	call	get_chr
	clc
	ret
alcmemerr:
	stc
	ret
;ENDIF
.endp

IF printflag
.proc	printtile	auto	
	mov	si,offset @dataseg:ptilemsg
	call	put_str
	mov	ax,curtilex
	call	wword
	mov	ax,curtiley
	call	wword
	call	wcr
	call	gettileadr
	mov	cx,150
ptllp:
	push	cx
	cmp	word ptr es:[di+11],0
	jz	skipthis
	mov	ax,cx
	neg	ax
	add	ax,151
	call	wcr
	call	wword
	mov	al,29h
	call	put_chr
	mov	ax,es:[di+21]
	call	wword
	mov	ax,curtilex	; get current x coord of tile
	mov	dx,tileszx	; multiply to get x bias on unverse
	mul	dx
	add	ax,universex	; now add the universe center coords
	mov	dx,es:[di]	; get compacted bits
	and	dx,tileszx-1	; strip off unwanted dumb bits
	add	dx,ax
	mov	ax,es:[di+2]
	call	dwword
	mov	ax,curtiley	; get current x coord of tile
	mov	dx,tileszy	; multiply to get x bias on unverse
	mul	dx
	add	ax,universey	; now add the universe center coords
	mov	dx,es:[di]	; get compacted bits
	mov	cl,5
	shr	dx,cl
	and	dx,tileszy-1	; strip off unwanted dumb bits
	add	dx,ax
	mov	ax,es:[di+4]
	call	dwword
	mov	dx,es:[di]	; get compacted bits
	mov	cl,10
	shr	dx,cl
	and	dx,31
	mov	ax,es:[di+6]
	call	dwword
	add	di,nbyteobj
	pop	cx
	loop	ptllp
	ret
skipthis:
	pop	cx
	ret
.endp
ENDIF

.proc	readuniv	auto		; read unvise to file
	mov	cx,ntilesy
rdmyloop:
	push	cx
	mov	ax,cx
	neg	ax
	add	ax,ntilesy
	mov	curtiley,ax
	mov	cx,ntilesx
rdmxloop:
	push	cx
	mov	ax,cx
	neg	ax
	add	ax,ntilesx
	mov	curtilex,ax

		mov	si,offset @dataseg:header
		mov	cx,nheaderbytes
		mov	bx,fhandl
		call	read_h
		jc	rerrorres3

	mov	ax,curtilex
	cmp	headerx,ax
	jnz	rerrorres3
	mov	ax,curtiley
	cmp	headery,ax
	jnz	rerrorres3
	call	getheader
	jc	rerrorres3
	call	gettileadr

	mov	ax,headersz	; get number of tile objects into cx
	mov	dx,nbyteobj
	mul	dx
	mov	cx,ax		; cx now hold number of bytes to write
	mov	bx,fhandl	; write to correct file

	push	ds
	mov	ax,es
	mov	ds,ax
	mov	si,di	; point ds:[si] to tile data
	call	read_h
	pop	ds
;		jc	rerrorres3	; handle an error

IF newthtflag
IF xlatflag EQ 0
	push	di
	mov	cx,headersz
	or	cx,cx
	jz	nonewtlp
newtlp:
	mov	ax,es:[di+21]
	xor	ax,es:[di+4]
	xor	ax,es:[di+2]
	mov	es:[di+21],ax
	add	di,nbyteobj
	loop	newtlp			; decode all the tiles
nonewtlp:
	pop	di
ENDIF
ENDIF

	pop	cx
	loop	rdmxloop
	pop	cx
	loop	rdmyloop
	mov	cx,12		; write twelve bytes of starting location
	mov	si,offset @dataseg:startcoords	; point ds:[si] to tile data
	mov	bx,fhandl	; write to correct file
	call	read_h
	jc	errorres7
	clc
	ret
rerrorres3:
	pop	cx
	pop	cx
errorres7:
	stc
	ret
.endp

IF getunivbin
.proc	xltgubcrd	auto	; translate 16bit int coord to 32b univ coord
	xor	dx,dx
	or	ax,ax	; check sign
	jns	xgbsok
	dec	dx	; dx now has -1
xgbsok:
xgblp1:
	shl	ax,1
	rcl	dx,1	; turn into true 32 bit coord
	loop	xgblp1
	ret
.endp
ENDIF
IF getunivbin
.proc	prtnewobj	auto
	call	put_newline
	push	si
	lodsw
	call	wword
	lodsw
	call	wword
	lodsw
	call	wword
	lodsw
	call	wword
	lodsw
	call	wword
	pop	si
	ret
.endp
ENDIF


;	and	word ptr [si+24],07fffh	; make into a real object
;	mov	al,byte ptr [si+18]	; get proper table to be in
;	and	ax,3			; dist code is zero thru 3
;	add	ax,ax			; form an address for table
;	push	si
;	push	cx
;	mov	bx,si			; prepare for tbadd call
;	mov	si,offset @dataseg:tblist
;	mov	si,[si]			; add to near table list
;	call	tbadd
;	pop	cx
;	pop	si

IF getunivbin

.proc	clearmemseg
	mov	ax,memseg
	mov	es,ax
	mov	cx,mseptrmx	
	cld
	xor	di,di
	xor	ax,ax
	rep	stosb
	ret
.endp
.proc	mergeunivbin	auto
			cmp	gubflag,0
			jnz	ggubcont
			jmp	skipmergeub
ggubcont:
			mov	ax,ds
			mov	es,ax
			mov	si,offset @dataseg:gubname
			mov	ax,0000h
			call	open_h
			mov	shandl,bx
			jnc	gubloop
			jmp	skipmergeub
gubloop:
			mov	cx,10			; read 5 ints
			mov	si,offset @dataseg:dxvec	; use as tmp buf
			mov	bx,shandl
			call	read_h
			mov	si,offset @dataseg:dxvec	; use as tmp buf
;			call	prtnewobj

;			mov	ax,@dataseg
;			mov	ds,ax

			mov	bx,dxvec		; get objdect type
			or	bx,bx			; check for last obj
			js	ubrqt1
			mov	si,offset @dataseg:gubobjbuf
			call	getfromtemplate		; read default into gubobjbuf
			jnc	nhne1
			mov	cs:cecode,3
ubrqt1:
			jmp	ubrqt
nhne1:

			lea	si,dxvec+2
			mov	bx,offset @dataseg:ox
			mov	di,offset @dataseg:gubobjbuf
			mov	ax,ds
			mov	es,ax
			cld
			mov	cx,2
gub2loop:
			push	cx
			lodsw
			mov	cx,9
			call	xltgubcrd
			stosw
			mov	[bx],ax
			inc	bx
			inc	bx
			mov	ax,dx
			stosw
			mov	[bx],ax
			inc	bx
			inc	bx
			pop	cx
			loop	gub2loop

			lodsw		; get z
			or	ax,ax		; see if z is zero
			jz	skipzxlt	; if so, just use template's

			mov	cx,4
			call	xltgubcrd
			stosw
			mov	[bx],ax
			inc	bx
			inc	bx
			mov	ax,dx
			stosw
			mov	[bx],ax		; put new z coord in.
			inc	bx
			inc	bx
			jmp	nskipzx

skipzxlt:
			add	bx,4
			add	di,4
nskipzx:
			lodsw
			neg	ax
			add	ax,16384	; translate from p angles to 3
			stosw
			mov	[bx],ax		; save

	mov	si,offset @dataseg:gubobjbuf
	call	put_newline
	mov	ax,[si+72]
	call	wword
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
	mov	ax,[si+12]
	call	wword
	mov	al,2eh
	call	put_chr

	call	gettilecrds	; get tile address of where we are
call put_newline
mov	ax,curtilex
call	wword
mov	ax,curtiley
call	wword
	call	qintile
	mov	ax,1
	jnc	eakam
	xor	ax,ax
eakam:
call	wword

	call	bringmemseg	; bring in data to memseg
mov	ax,tileptr
xor	dx,dx
mov	bx,nbyteobj
div	bx
call	wword
mov	ax,tobjcount
call	wword
	mov	si,offset @dataseg:gubobjbuf
	mov	fdexpobj,si
	call	tomemseg	; add into med far table
	call	farmmemseg	; write tile back out
mov	ax,tobjcount
call	wword
	call	clearmemseg


			cmp	cs:cecode,0
			jnz	ubrqt
			jmp	gubloop		; go back to get nxt object

ubrqt:
			mov	bx,shandl
			call	close_h
skipmergeub:
			ret
.endp
ENDIF ; getunivbin

.proc	writeuniv	auto		; write unvise to file
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

	call	fillheader
		mov	si,offset @dataseg:header
		mov	cx,nheaderbytes
		mov	bx,fhandl
		call	write_h
		jc	errorres3

	call	gettileadr

IF newthtflag
	push	di
	mov	cx,headersz
	or	cx,cx
	jz	nonewwtlp
newwtlp:
	mov	ax,es:[di+21]
	xor	ax,es:[di+2]
	xor	ax,es:[di+4]
	mov	es:[di+21],ax
	add	di,nbyteobj
	loop	newwtlp			; decode all the tiles
nonewwtlp:

	pop	di
ENDIF

	mov	ax,headersz	; get number of tile objects into cx
	mov	dx,nbyteobj
	mul	dx
	mov	cx,ax		; cx now hold number of bytes to write
	mov	bx,fhandl	; write to correct file

	push	ds
	mov	ax,es
	mov	ds,ax
	mov	si,di	; point ds:[si] to tile data
	call	write_h
	pop	ds
		jc	errorres3	; handle an error
IF shareflag EQ 0  ; only registered version needs reencoded data
IF newthtflag				; undecode them in memory
	push	di
	mov	cx,headersz
	or	cx,cx
	jz	none1wtlp
ne1wtlp:
	mov	ax,es:[di+21]
	xor	ax,es:[di+2]
	xor	ax,es:[di+4]
	mov	es:[di+21],ax
	add	di,nbyteobj
	loop	ne1wtlp			; decode all the tiles
none1wtlp:

	pop	di
ENDIF
ENDIF

	pop	cx
	loop	dmxloop
	pop	cx
	loop	dmyloop
	mov	cx,12		; write twelve bytes of starting location
	mov	si,offset @dataseg:startcoords	; point ds:[si] to tile data
	mov	bx,fhandl	; write to correct file
	call	write_h
	jc	errorres5
	clc
	ret
errorres3:
	pop	cx
	pop	cx
errorres5:
	stc
	ret
.endp

.proc	writeunivfile	auto		; writes the universe file out
		mov	si,offset @dataseg:univname
		mov	ax,0301h
		call	open_h
		mov	fhandl,bx
		jc	errorres4
		call	writeuniv		; write universe to file
		jnc	nowriteuniverr
errorres4:
		mov	cs:cecode,101
;		mov	si,offset @dataseg:wrtuniverrmsg
;		call	put_str
;		call	get_ecode
;		call	decwword
;		mov	al,1
;		jmp	exit
nowriteuniverr:
		mov	bx,fhandl
		call	close_h
		jc 	errorres4
		ret
.endp

.proc	getstartfile	auto	; gets starting file info
			mov	si,offset @dataseg:sname
			mov	ax,0000h
			call	open_h
			mov	shandl,bx
			jc	skipstrtfile	; forget it if no file
			mov	si,offset @dataseg:kbuf
			mov	cx,80
			mov	bx,shandl
			call	read_h
			mov	bx,shandl
			call	close_h
			mov	si,offset @dataseg:kbuf
			mov	di,offset @dataseg:tempstart
			call	str_skipw
			call	dec_to_dwords
			mov	[di],ax
			mov	[di+2],dx
			add	di,4
			call	str_skipw
			call	dec_to_dwords
			mov	[di],ax
			mov	[di+2],dx
			add	di,4
			call	str_skipw
			call	dec_to_dwords
			mov	[di],ax
			mov	[di+2],dx
			add	di,4
			call	str_skipw
			call	dec_to_dwords
			mov	[di],ax		; yaw angle for plane's pos
			mov	newmissflag,-1
skipstrtfile:
			ret
.endp

.proc	readunivparams	auto		; reads universe parameters
					; from tower file
			mov	si,offset @dataseg:kbuf
			inc	si	; skip over the 'X'
			call	str_skipw
			call	dec_to_dwords
			mov	sunangle,ax
			call	str_skipw
			call	dec_to_dwords
			mov	sunsz1,ax
			add	ax,5
			mov	sunsz2,ax
			call	str_skipw
			call	dec_to_dwords
			and	al,0fh
			mov	sunclr,al
							; get gravity sf
			call	str_skipw
			call	dec_to_dwords
							; check range
			cmp	ax,-15
			jl	gntsml
			mov	ax,-15
gntsml:
			cmp	ax,-100
			jg	gntbig
			mov	ax,-100
gntbig:
		mov	grvsf,ax
			call	str_skipw
			call	dec_to_dwords
			or	ax,ax
			js	skiprho
			cmp	ax,1000
			jl	skiprho
			cmp	ax,10000
			ja	skiprho

			mov	rho0,ax
			shl	ax,1
			cwd
			mov	bx,3
			div	bx
			mov	rho02,ax

skiprho:
			call	str_skipw
			call	dec_to_dwords
			mov	bx,ax
			and	bx,1
			mov	starsflag,bl

			call	str_skipw
			call	dec_to_dwords
			jc	skiprhoz		; check for valid
			or	ax,ax
			js	skiprhoz
			cmp	ax,256
			jb	skiprhoz		; keep rh0z in bounds
			mov	rho0z,ax
IF shareflag
			mov	dx,30
			mul	dx
			mov	bx,50
			div	bx
ELSE
			shr	ax,1
ENDIF
			mov	starheight,ax
skiprhoz:
		ret
.endp

.proc	readunivfile	auto		; reads in 3univ.dat file if desired
		mov	si,offset @dataseg:tname
		mov	ax,0000h
		call	open_h
		mov	fhandl,bx
		jc	forgettwr
		mov	cx,80
		mov	si,offset @dataseg:kbuf
		mov	ax,ds
		mov	es,ax
		mov	bx,fhandl
		call	read_h
		cmp	byte ptr kbuf,58h	; is first character 'X'?
		jnz	jcltwr
		call	readunivparams		; yes, read in universe params
jcltwr:
		mov	bx,fhandl
		call	close_h
forgettwr:


		mov	si,offset @dataseg:univname
		mov	ax,0102h
		call	open_h
		mov	fhandl,bx
		jc	ruerror
		call	readuniv	; read in all the tiles
		mov	bx,fhandl
		call	close_h
		jc	ruerror
		ret

ruerror:
	mov	si,offset @dataseg:ruerrmsg
	call	put_str
;	call	get_ecode
;	call	decwword
;	call	wcr
	mov	al,1
	jmp	exit
.endp
IF mapmbflag EQ 1
ENDIF

timerretries	dw	0

.proc	reset_ticks	auto	; resets and verifies timer
	cmp	qtimeinc,0
	jz	resettmrok
	ret			; do'nt mess with timer if q option
resettmrok:
	push	cx
	push	ax
	mov	cx,5		; don't try more than 5 times
resetloop:
	push	cx
;	call	reset_timer0
		mov	al,36h			;counter 0, mode 3, LSB/MSB
		xor	cx,cx			;reload=0 (64k)
		call	set_timer0
;	call	get_timer0mode
;	or	cx,cx
;	jnz	modefail
;	cmp	al,6
;	jnz	modefail
	pop	cx
	loop	resetloop
	pop	ax
	pop	cx
	ret
modefail:
	inc	cs:timerretries
	pop	cx
	loop	resetloop
	mov	cs:cecode,123		; leave error code that timer failed
	pop	ax
	pop	cx
	ret
.endp

.proc	cleardamage	auto
	xor	ax,ax
	mov	thrdam,ax
	mov	stabdam,ax
	mov	engdam,ax
	mov	yawdam,ax
	mov	wingloss,ax
	mov	totaldamage,ax
	mov	redamageflag,al		; do not use old damage
	mov	currpmx,200
	mov	brdrclr,7		; clear bordercolor
	ret
.endp

IF xrv EQ 2
mdolandinggear
cecode	db	0
mnew9
mwelcomewagon
mnew08
ENDIF
	
.proc	getinplane	auto		; gets us into a plane
					; from coords given to us in [si]
	cmp	ejectflag,0
	jz	cantgetin
	mov	redamageflag,0		; do not use old damage
	test	word ptr [si+24],104h	; is plane crashed?
	jz	thisplaneok
	mov	currpmx,0		; have it be dead

	jmp	maybenotok
cantgetin:
	mov	cs:cecode,77
	ret
thisplaneok:
	call	cleardamage
maybenotok:
	xor	ax,ax
	mov	avgzvel,ax
	mov	avgdvelh,ax
	mov	avgdvell,ax

leaveolddamage:
	push	si
	cmp	obj5d+24,0		; is the object being displayed?
	jz	wake
;	mov	ax,obj5d+10
;	cmp	ax,1
;	jae	kjllll
;	mov	bx,hmin
;	cmp	obj5d+8,bx
;	ja	kjllll
;	jmp	normalfuneral
;
;kjllll:
;	mov	si,offset @dataseg:obj5d
;	push	di
;	stc
;	call	odest
;	mov	deathcode,91
;	pop	di
;	jmp	wake
normalfuneral:
	cmp	obj5d+40,offset @dataseg:plnplyobjsm	; is plane smoking?
	stc
	jz	niceornasty
	clc				; say plane is ok
niceornasty:
	call	funeral5d		; kill what ever plane is left
wake:
	pop	si

	mov	ax,[si+24]
	and	ax,03106h		; set up the bits that matter
	mov	obj5dbits,ax		; set our upcoming bits up
	mov	di,offset @dataseg:ox
	mov	cx,9
	mov	ax,ds
	mov	es,ax
	cld
	rep	movsw		; mov us to orientation of the plane
	xor	ax,ax
	mov	di,offset @dataseg:rtopv
	mov	cx,3
	rep	stosw
	mov	di,offset @dataseg:ctopv
	mov	cx,3
	rep	stosw
	mov	di,offset @dataseg:topv
	mov	cx,3
	rep	stosw
	mov	pitdoth,ax
	mov	yawdoth,ax
	mov	thrdoth,ax


	call	interiorview	; put the inst panel back on
	cmp	currpmx,0
	jz	skipdminit
IF soundflag EQ 0
	call	snareinit	; turn missle abilities back on
	mov	windflag,0	; turnoff wind
ENDIF
	call	damageinit	; re-init the damage and bomb displays
skipdminit:
	mov	groundflag,-1
	xor	ax,ax
	mov	flapflag,al		; turn flaps off
	mov	rpm,20
	mov	autoflag,al		; turn auto pilot off
	mov	nbombs,3
	mov	freezeflag,-1		; keep plane from rolling
	mov	stepoutflag,al		;
	mov	ejectflag,al		; get us off the ground
	mov	standingflag,al		; clear the standing on groundflag
	mov	pullstrflag,al		; allow chute to work again
;	mov	fateofplane,al		; clear fate of plane flag
	mov	flapflag,al
	mov	autoflag,al		; turn off flaps and autopilot
	mov	al,joyflag		; turn views back on if in joystick
	mov	numlock,al
test5key:
	or	al,al			; if numlock on, wait for key to release
	jz	goddbb
	mov	al,04ch
	call	getkbit
	jmp	test5key
goddbb:
	and	ax,4			; is the crashlandbit set?
	mov	crshlndflag,al
	jz	skipdminit2
	mov	currpmx,0
skipdminit2:
	cmp	currpmx,0
	jnz	skipdminit1
	mov	instflag,0		; turn of instruments if plane dead
	mov	al,cmpltflag
	ror	al,1
	cbw
	mov	cmpltflag,ah		; if cmpltflag=1, make into -1
skipdminit1:
	mov	ax,offset @dataseg:plnplyobj
	mov	obj5d+40,ax
	mov	obj5d+42,ax
	ret
.endp


.proc	dotower	auto		; puts observer back into the tower 
	call	rest08		; unhook timer int
	call	reset_ticks		; stop timer from racing, so we
					; don't run into trouble
	call	reset9
	call	cleargetkey		; clear the keyboard table
	call	addtoetime		; add elapsed time to variable
	cmp	cs:cecode,0
	jz	tlr1
	jmp	talreadyint	; if reset failed, just get out
tlr1:
	mov	al,oldmode	; switch to text mode
	xor	ah,ah
	and	al,7fh		; clip off high bit to make sure palette
				; is reset
	int	10h

;	mov	al,oldmode
;	xor	ah,ah
;	call	decwword
;	call	get_chr

	call	writeresfile	; write out the current resfile
	call	runtower	; run tower program to report briefings
;	mov	si,offset @dataseg:towermsg
;	call	put_str
;	mov	ax,curtower
;	call	wword

	xor	al,al
	mov	cmpltflag,al
	mov	redamageflag,-1	; use old damage is default
	mov	scncode,al	; 
	cmp	ejectflag,al	; only move out of tower if needed
	jz	skipposreset

	cmp	bossflag,0
	jnz	skipposreset
	cmp	intowerflag,1
	jz	skipposreset	; if not entered tower, just leave angles
				; alone

	sub	oy,2000		; move out of tower
	sbb	oy+2,0
	mov	orvec,-16384	; point out of the tower
	call	recalcmats	; recalculate orot and such

	mov	si,offset @dataseg:obj5d
	cmp	word ptr [si+24],0
	jz	nochg5d
	mov	ax,offset @dataseg:plnplyobj
	mov	word ptr [si+24],1		; make object non-destructable
	mov	[si+40],ax
	mov	[si+42],ax
	mov	[si+44],ax
	mov	[si+14],epitchmin		; point nose correctly
	mov	ax,hmin
	mov	obj5d+8,ax	; drop the plane down to the ground
nochg5d:
	mov	crshlndflag,0	; clear the crash land flag
	call	cleardamage
	mov	ax,cs:ticks	; set rocket time up
	mov	lrockettick,ax	; make rocket powered up
	mov	rockettick,2184
	
	
skipposreset:
	mov	intowerflag,0	; tell flag this info

	call	grmode		; switch to graphics mode
	call	distortcolor
					; set up the nice colors
	mov	al,255
	xor	ah,ah
	call	setcolors

	test	tripflag1,1
	jz	tripf5
	call	distcolors
tripf5:
	call	grab9
	mov	escwaitflag,-1	; wait for the escape key release if one
	mov	scncode,0	; clear any code which may be there
	call	tmr_reset		; restart time accounting
	cli
	mov	al,6			; set timer mode 3
	mov	cx,tickdiv		; reload value is much smaller
	call	set_timer0
	cli
	call	grab08			; regrab timer ints
	sti				; reable ints
talreadyint:
	ret
.endp

.proc	interiorview	auto		; puts observer back into interior 
					; view
;	mov	si,ptrgwinf
;	cli
;	call	reset_ticks		; stop timer from racing, so we
;					; don't run into trouble
;	sti
	cmp	cs:cecode,0
	jnz	alreadyint	; if reset failed, just get out
	sti
	mov	ax,offset @dataseg:gwinf
	mov	ptrgwinf,ax	
	mov	ax,offset @dataseg:gwint
	mov	ptrgwint,ax	
	xor	al,al
	call	readimg			; read in image of inst panel
	mov	instflag,-1		; turn instrument panel back on
;	mov	al,6			; set timer mode 3
;	mov	cx,tickdiv		; reload value is much smaller
;	cli
;	call	set_timer0
;	sti				; reable ints
alreadyint:
	ret
.endp

.proc	damageinit	auto	 ; initializes bomb and damage indicators
				; the following inits the damage indicators
				; with green bars
	cmp	invincible,0
	jz	dontskipdami
	mov	bx,13		; white out damage
	mov	ax,0700h
	call	drawbutton
	jmp	bombonly	; don't do anything if invincible plane
dontskipdami:
	mov	cx,4
daminitloop:
	push	cx
	mov	bx,cx		; index = damage indicator 0-3
	dec	bx		; but index-1 !

	push	bx
	call	damindicinit	; re-init that damage indicator
	pop	bx
	cmp	redamageflag,0
	jnz	useolddam
	mov	cx,1		; show 1 count of damage
useolddam:
	or	cx,cx		; get amount of present damage
	jz	nodrawdam	; forget it if nonce
redamloop:
	push	cx
	push	bx
	call	drawdamage	; flash any damage indicators which need it
	pop	bx
	pop	cx
	loop	redamloop
nodrawdam:
	pop	cx
	loop	daminitloop

bombonly:

IF slalom EQ 0
	mov	cx,3		; initialize the nice bombs display buttons
bomblp:
	push	cx
	mov	bx,cx
	neg	bx
	add	bx,3		; make 3-1 goto 0-2
	add	bx,6
	mov	ax,0807h		; make bomb appear
	call	drawbutton	;
	pop	cx		; restore counter
	loop	bomblp
ENDIF
	ret
.endp

.proc	distortcolor	auto
	mov	dx,3dah
	in	al,dx
	mov	dx,3c0h
	mov	al,8
	out	dx,al
	mov	al,3fh			; turn color 8 into high white
	out	dx,al			; now the palette is modified
	mov	al,20h			; turn memory access back on
	out	dx,al
	mov	dx,3dah
	in	al,dx			; reset damn flip flop (stupid!)
	ret
.endp

.proc	shutdown	auto

		mov	al,oldmode
	xor	ah,ah
	and	al,7fh		; clip off high bit to make sure palette
				; is reset
		int	10h		
	call	soundoff
	call	rest08				; restore int 8 vector
	call	reset_ticks
IF errortrap
	call	rest00
ENDIF
	call	reset9
	ret
.endp

.proc	addtoetime	auto		; gets our elapsed time since mission
					; beginning
	call	tmr_read
	push	ax
	mov	al,dl
	mov	ah,60
	mul	ah
	pop	dx
	mov	dl,dh
	xor	dh,dh
	add	ax,dx
	add	etime,ax
	ret
.endp

.proc	drawflapbut	auto		; illuminates flap button
	mov	ax,0f07h		; turn letters white
	mov	bx,2
	call	drawbutton		
	mov	ax,0600h		; turn button brown
	mov	bx,2
	call	drawbutton		
	ret
.endp

.proc	drawautobut	auto		; draws autopilot button
	mov	ax,0f07h		; assume it is off, being turned on
	xor	bx,bx			; button 0
	call	drawbutton		; draw the block on the inst panel
	mov	ax,0100h		; search for black, replace with blue
	xor	bx,bx			; button 0
	call	drawbutton
	ret
.endp

IF slalom
.proc	drawslalbut	auto		; draws autopilot button
	mov	ax,0107h		; assume it is off, being turned on
	xor	bh,bh			; button 0
	add	bx,14
	push	bx
	call	drawbutton		; draw the block on the inst panel
	mov	ax,0c00h		; search for black, replace with blue
	pop	bx
	call	drawbutton
	ret
.endp
.proc	clrslalbut	auto		; draws autopilot button
	mov	ax,0701h		; assume it is off, being turned on
	xor	bh,bh			; button 0
	add	bx,14
	push	bx
	call	drawbutton		; draw the block on the inst panel
	mov	ax,000ch		; search for black, replace with blue
	pop	bx
	call	drawbutton
	ret
.endp
ENDIF

.proc	drawcmpltbut	auto		; illuminates flap button
	mov	ax,0f07h		; turn letters white
	mov	bx,5
	call	drawbutton		
	mov	ax,0900h		; turn button brown
	mov	bx,5
	call	drawbutton		
	ret
.endp

.proc	redrawbuts	auto		; draws the flap and autopilot buttons
					; again
	cmp	flapflag,0
	jz	noffyow
	call	drawflapbut
noffyow:
	cmp	autoflag,0
	jz	noafyow
	call	drawautobut
noafyow:
	cmp	cmpltflag,0
	jz	nocmyow
	call	drawcmpltbut
nocmyow:

IF guns
	mov	cl,3
	sub	cl,nbombs
	jz	dwabombs		; don't worry about bombs, there
					; are all there, so none be darkend
	xor	ch,ch
drwbmblp:
	push	cx
	mov	bl,3
	sub	bl,cl		; set bomb number
	xor	bh,bh		; point to correct button
	add	bx,6
	mov	ax,0708h	; make bomb disappear
	call	drawbutton	;
	pop	cx
	loop	drwbmblp
dwabombs:
ENDIF
	ret
.endp


IF 1 EQ 0
.proc	putaplane	auto	; moves an object 5d to a place on the
				; runway
	push	si
	mov	di,offset @dataseg:startcoords
	xchg	si,di
	mov	cx,9
	cld
	mov	ax,ds
	mov	es,ax
	rep	movsw
	pop	si
	mov	ax,nstartplanes
	mov	dx,-10000
	imul	dx
	add	[si],ax
	adc	[si+2],dx
	inc	nstartplanes
	ret
.endp
ENDIF

.proc	recalcmats	auto
	mov	bx,offset @dataseg:orvec
	call	calcsin
	mov	si,offset @dataseg:orot
	call	calcmat
	mov	si,offset @dataseg:norot
	call	ncalcmat
	ret
.endp

.proc	doxp	auto	; this code actually does the portal xfer
			; when dude flys through one
	mov	al,xpflag

	or	al,al
	jz	npng		; if zero then no teleport at all
				; at this pt, we know we are going bye bye
				; so lets flush all the current objects
	call	flushtiles	; before the xfer
	call	drawnear	; now let objects really die

	mov	al,xpflag
	or	al,al
	js	npng1

	mov	si,offset @dataseg:startcoords
	mov	di,offset @dataseg:ox
	mov	ax,ds
	mov	es,ax
	mov	cx,6		; only change x,y
	rep	movsw
	jmp	npng0
npng1:
	mov	bx,8*32
	call	randr_w		; get random number for coords
	sub	ax,4*32
	mov	ox+2,ax
	call	randr_w		; get random number for coords
	sub	ax,4*32
	mov	oy+2,ax
	call	rand_w
	mov	ox,ax
	call	rand_w
	mov	oy,ax
npng0:
	mov	oz,8000h	; si should now be pointing to oz
	mov	oz+2,3	; start you way up there
	call	dotiles	; now read in objects for new display
	and	tripflag,NOT 2	; clear horiz tripping bit
npng:
	mov	xpflag,0
	ret
.endp

.proc	turnoffbreaks	auto
	mov	ax,3301h
	xor	dl,dl		; dos call 33h, sub function 1
	int	21h		; turn off damn breaks!
	ret
.endp

.proc	hashcfg	auto		; hashes the data in the config file
	call	rand_w		; get a random number
	or	ax,5000h	; make sure not zero
	mov	bx,offset @dataseg:randwords+31
	mov	[bx-31],ax	; save a random number
	mov	bx,ax		; save this number
	call	rand_w		; get a random number
	mov	si,offset @dataseg:randwords+31
	mov	[si-31+2],ax	; save a random number
	mov	si,offset @dataseg:jleft-74
	add	si,74
	mov	cx,randwords-jleft	; number of words to hash
	shr	cx,1			; it's a word address
	mov	dl,cs:cecode		; check from rom cksum error
	sub	dl,7
hashloop:
	mov	ax,[si]
	cmp	dl,90
	jnz	rmckok
	xor	ax,ax			; make all zeros
rmckok:
	add	bx,ax
	mov	[si],bx		; replace number with sum of number + rand
	add	si,2
	loop	hashloop
	ret
.endp

.proc	unhashcfg	auto		; unhashes the data in the config file
	mov	si,offset @dataseg:jleft-74
	add	si,74
	mov	cx,randwords-jleft	; number of words to hash
	shr	cx,1			; it's a word address
	mov	bx,offset @dataseg:randwords+31
	mov	bx,[bx-31]
unhashloop:
	mov	ax,[si]
	push	ax
	sub	ax,bx
	pop	bx
	mov	[si],ax		; replace number with sum of number + rand
	add	si,2
	loop	unhashloop
	ret
.endp

.proc	nulcrit	auto
	stc
	ret
.endp

.proc	waitdelay	auto
	mov	ax,cs:ticks	; get number of ticks passed
	sub	ax,weltime	; this is # ticked since last picture
	cmp	ax,bx		; del 5 seconds
	jb	delayunfin
	stc
	ret
delayunfin:
	clc
	ret
.endp

.proc	delay4crit	auto
	mov	bx,8*18		; wait for about 5 seconds
	jmp	waitdelay
.endp

.proc	delay5crit	auto
	mov	bx,15*18
	jmp	waitdelay
.endp

.proc	airspeedcrit	auto	; gives ok when airspeed reaches 150 mph
	cmp	topv,16*300
	ja	fastenough
	clc
	ret
fastenough:
	stc
	ret
.endp

.proc	altcrit	auto
	mov	dx,oz+2
	mov	ax,oz
	sub	ax,8000
	sbb	dx,0
	jns	highenough
	clc
	ret
highenough:
	stc
	ret
.endp

.proc	takedrugs	auto
	mov	ax,haluclrate
	wtadj
	mov	haluclrate+2,ax
	mov	al,13h		; scan for R
	call	getkbit
	jz	noreds
	mov	ax,haluclrate+2
	add	haluclrs,ax
noreds:
	mov	al,22h		; scan for R
	call	getkbit
	jz	nogreens
	mov	ax,haluclrate+2
	add	haluclrs+2,ax
nogreens:
	mov	al,30h		; scan for R
	call	getkbit
	jz	noblues

	mov	ax,haluclrate+2
	add	haluclrs+4,ax
noblues:
	call	distcolors
	mov	al,2
	call	getkbit
	jz	noskyset
	call	setskyclr
noskyset:
	mov	al,2
	call	getkbit
	jnz	noskyset
	mov	al,3
	call	getkbit
	jz	nogndset
	call	setgndclr
nogndset:
	mov	al,3
	call	getkbit
	jnz	nogndset
	ret
.endp

.proc	setskyclr	auto	; set sky color
	mov	al,rescolors+(4*11+1)
	mov	skycolors,al
	mov	al,rescolors+(4*11+2)
	mov	skycolors+1,al
	mov	al,rescolors+(4*11+3)
	mov	skycolors+2,al
	call	setskygnd
	call	packbits		; make part of our universe header
	ret
.endp

IF xrv EQ 1
mnew08
mnew9
mdolandinggear
mwelcomewagon
cecode	db	0
ENDIF

.proc	setgndclr	auto	; set sky color
	mov	al,rescolors+(4*2+1)
	mov	groundcolors,al
	mov	al,rescolors+(4*2+2)
	mov	groundcolors+1,al
	mov	al,rescolors+(4*2+3)
	mov	groundcolors+2,al
	call	setskygnd
	call	packbits		; make part of our universe header
	ret
.endp

IF nodemo EQ 0
demouwtadj	macro
;	endm
;m2222	macro
	push	cx
	push	dx
	mov	cx,ticksf
	imul	cx
	mov	cx,10		; always use a ofrmticks of 10
	idiv	cx
	pop	dx
	pop	cx
	endm

.proc	demofixup	auto		; takes file coords into some real vars
	test	demobyte,32
	jz	dabdmfxup
	ret
dabdmfxup:
	cmp	ejectflag,0
	jz	dmfxpfine
	ret
dmfxpfine:
	mov	di,offset @dataseg:ox	; spread new coords and angles around
	mov	si,offset @dataseg:oxeff
	mov	cx,9
	mov	ax,ds
	mov	es,ax
	rep	movsw				; update effective coords

	mov	cl,4
	mov	ax,delox
	demouwtadj
	sal	ax,cl
	mov	rtopv,ax
	mov	ax,delox+4
	demouwtadj
	sal	ax,cl
	mov	rtopv+2,ax
	mov	ax,delox+8
	demouwtadj
	sal	ax,cl
	mov	rtopv+4,ax

	ret
.endp


.proc	fmaxacc	auto
	.abs_w	dx
	cmp	dx,maxacc
	jbe	nofmxac
	mov	maxacc,dx
	push	si
	push	di
	push	ax
	mov	si,offset @dataseg:delox
	mov	di,offset @dataseg:tempox
	mov	cx,6
	mov	ax,ds
	mov	es,ax
	rep	movsw
	pop	ax
	pop	di
	pop	si
nofmxac:
	ret
.endp

.proc	compactwrite	auto		; compresses position info, and
					; prepares for disk write
	or	demobyte,80h		; set bit for compacted
	mov	al,demobyte
	mov	kbuf,al			; use kbuf for our file buffer
	mov	ax,accelox
	mov	kbuf+1,al			; xfer bytes to buffer area
	mov	ax,accelox+2
	mov	kbuf+2,al
	mov	ax,accelox+4
	mov	kbuf+3,al
	mov	ax,orvec
	mov	kbuf+4,ah
	mov	cl,3*2
	rol	al,cl
	and	al,30h
	mov	kbuf+7,al
	mov	ax,orvec+2
	mov	kbuf+5,ah
	mov	cl,2*2
	rol	al,cl
	and	al,0ch
	or	kbuf+7,al
	mov	ax,orvec+4
	mov	kbuf+6,ah
	mov	cl,2
	rol	al,cl
	and	al,03h
	or	kbuf+7,al
		mov	si,offset @dataseg:kbuf
		mov	cx,8		; seven bytes vs 37 is the savings
	ret
.endp

.proc	compactread	auto		; reads compressed data
	mov	al,kbuf	; first verify demo byte
	cmp	al,-1
	jz	comprabort
;	mov	ah,al
;	and	ah,0fh
;	cmp	ah,8
	test	al,8
	jnz	kkkklll
	mov	cs:cecode,25
	ret
kkkklll:
	test	al,80h
	jnz	comprdok
	mov	si,offset @dataseg:kbuf+1
	mov	cx,ndemobytes-1
		mov	bx,fhandl
		call	read_h
	mov	si,offset @dataseg:kbuf
	mov	di,offset @dataseg:demobyte
	mov	ax,ds
	mov	es,ax
	mov	cx,ndemobytes
	cmp	ejectflag,0
	jnz	onlyonebyte
	test	kbuf,32	; look for eject
	jz	apppa
onlyonebyte:
	mov	cx,1	; don't mess with it
apppa:
	rep	movsb
	clc
	ret
comprabort:
	mov	demobyte,al
	mov	demoflag,0
	ret
comprdok:
	mov	demobyte,al	; save the demo byte
	mov	si,offset @dataseg:kbuf+1
	mov	cx,7
		mov	bx,fhandl
		call	read_h
	cmp	ejectflag,0
	jz	uncmpasn
	ret
uncmpasn:
	mov	di,offset @dataseg:oxeff
	mov	al,kbuf+1
	cbw
	mov	accelox,ax
	add	ax,delox
	mov	delox,ax
;		mov	ax,delox
	cwd
	add	[di],ax
	adc	[di+2],dx
	mov	al,kbuf+2
	cbw
	mov	accelox+2,ax
	add	ax,delox+4
	mov	delox+4,ax
;		mov	ax,delox+4
	cwd
	add	[di+4],ax
	adc	[di+6],dx
	mov	al,kbuf+3
	cbw
	cmp	ax,128
	jg	kkddll
	mov	accelox+4,ax
	add	ax,delox+8
	mov	delox+8,ax
;		mov	ax,delox+8
	cwd
	add	[di+8],ax
;	js	kkddll
	adc	[di+10],dx
	xor 	al,al
	mov	ah,kbuf+4
	mov	al,kbuf+7
	mov	cl,3*2
	ror	al,cl
	and	al,0c0h
	mov	orveceff,ax
	mov	ah,kbuf+5
	mov	al,kbuf+7
	mov	cl,2*2
	ror	al,cl
	and	al,0c0h
	mov	orveceff+2,ax
	mov	ah,kbuf+6
	mov	al,kbuf+7
	mov	cl,2
	ror	al,cl
	and	al,0c0h
	mov	orveceff+4,ax
	stc
	ret
kkddll:
	mov	cs:cecode,26
	ret
.endp
ENDIF

IF xrv EQ 0
mnew9
mnew08
cecode	db	0
mdolandinggear
mwelcomewagon
ENDIF


IF nodemo EQ 0
IF demorec
.proc	qwritedemo	auto 	;
	cmp	scncode,16h+80h			; are we ready to scan for it?
	jnz	nodemostrt
	mov	scncode,0
	cmp	demoflag,0
	jnz	turndemooff			; can't start if already on

	mov	demoflag,1
		mov	si,offset @dataseg:demoname
		mov	ax,0301h
		call	open_h
		mov	fhandl,bx
		jc	demoerr1
		mov	demobyte,8h+3	; verify expanded form
		mov	si,offset @dataseg:demobyte
		mov	cx,ndemobytes
		mov	bx,fhandl
		call	write_h		; write first block in file in exp form
		jc	demoerr1	; handle eek a mouse
		jmp	nodemostrt
demoerr1:
	mov	cs:cecode,49			; give cecode error
	mov	demoflag,0
turndemooff:				; if demo on, turn demo off
	mov	demoflag,0
	mov	demobyte,-1		; signify last byte
		mov	si,offset @dataseg:demobyte
		mov	cx,ndemobytes
		mov	bx,fhandl
		call	write_h
		jc	demoerr1	; handle eek a mouse
	mov	bx,fhandl
	call	close_h			; close the file

nodemostrt:

	cmp	demoflag,1
	jnz	norecordf


	mov	ax,maxacc		; is it within bounds for a relative
					; thingydo?
	cmp	ax,128
	jae	fullszwrite
	call	compactwrite		; compact the info and write it
	jmp	skipfullsw
fullszwrite:
	        and	demobyte,NOT 80h
		mov	si,offset @dataseg:demobyte
		mov	cx,ndemobytes
skipfullsw:
		or	demobyte,8
		or	kbuf,8
		mov	bx,fhandl
		call	write_h
		jc	demoerr1	; handle eek a mouse


norecordf:

		ret
.endp
ENDIF



IF demorec
.proc	updatedemo	auto
	cmp	demoflag,-1
	jz	skipdelstuff
	cmp	frmnum,6
	ja	lkskdjgb
skipdelstuff:
	jmp	nolkds
lkskdjgb:


	mov	si,offset @dataseg:delox
	mov	di,offset @dataseg:ox
	xor	bx,bx
	mov	maxacc,bx

	mov	ax,[di]
	sub	ax,[bx+offset @dataseg:oxeff]
	pushf
	mov	dx,ax
	sub	dx,[si]
	mov	accelox,dx
	call	fmaxacc
	popf
	mov	[si],ax

	mov	ax,[di+2]
	sbb	ax,[bx+offset @dataseg:oxeff+2]
	mov	[si+2],ax

	add	si,4
	add	di,4
	add	bx,4

	mov	ax,[di]
	sub	ax,[bx+offset @dataseg:oxeff]
	pushf
	mov	dx,ax
	sub	dx,[si]
	mov	accelox+2,dx
	call	fmaxacc
	popf
	mov	[si],ax
	mov	ax,[di+2]
	sbb	ax,[bx+offset @dataseg:oxeff+2]
	mov	[si+2],ax
	add	si,4
	add	di,4
	add	bx,4

	mov	ax,[di]
	sub	ax,[bx+offset @dataseg:oxeff]
	pushf
	mov	dx,ax
	sub	dx,[si]
	mov	accelox+4,dx
	call	fmaxacc
	popf
	mov	[si],ax
	mov	ax,[di+2]
	sbb	ax,[bx+offset @dataseg:oxeff+2]
	mov	[si+2],ax

nolkds:
	mov	ax,cs:frmticks
	push	ax
	call	qwritedemo
	pop	ax
	mov	cs:frmticks,ax
IF delomegflag
	mov	si,offset @dataseg:orvec	; and angles
	mov	di,offset @dataseg:delomeg	; set up delta angles
	mov	bx,offset @dataseg:orveceff
	mov	cx,3
delolp:
	mov	ax,[si]
	sub	ax,[bx]
	mov	[di],ax
	add	si,2
	add	di,2
	add	bx,2
	loop	delolp
ENDIF
	ret
.endp
ENDIF
ENDIF

.proc	drawabomb	auto	; draws bomb 0-2 given in bl register
	xor	bh,bh		; point to correct button
	add	bx,6
	dec	bx		; it was one too big
IF slalom
	mov	ax,0307h		; make bomb appear
ELSE
	mov	ax,0807h		; make bomb appear
ENDIF
	call	drawbutton	;
	ret
.endp

.proc	jumpadd	auto		; adds how long j key has been held down to
				; sum held in jumpvalue
	mov	al,24h	; see how long j has been held down
	call	readkey
	mov	bx,jumpvalue
	add	ax,bx		; add to sum
	bndck	jumpmax,0	; don't let jump add get negative
	mov	jumpvalue,ax
	ret
.endp

.proc	dampchute	auto
	mov	ax,otopv
	mov	bx,chutedamp		; slow us down
	imul	bx
	sal	dx,1
	mov	otopv,dx
	mov	ax,otopv+2
	mov	bx,chutedamp		; slow us down
	imul	bx
	sal	dx,1
	mov	otopv+2,dx

	mov	ax,otopv+4
	mov	dx,freefallgrav		; gravity matters in the terminal v
					; calculation
	imul	dx
	dwtadj				; the lower the frame rate, the higher
					; the drag
	mov	bx,termvel
	push	bx
	push	dx
	.abs_w	bx
	.abs_w	dx
	cmp	bx,dx
	pop	dx
	pop	bx
	ja	thisdivok
	mov	otopv+4,0		; just stop us (what else could we do?)
	mov	cs:cecode,99
	jmp	skipdragstuff
thisdivok:
	idiv	bx			; v = v -kv braking effect

;	mov	ax,termvel
;	uwtadj				; the more time, the more the drag
;	or	ax,ax			; verify drag is not infinite
;	jnz	noninfin
;	mov	ax,2			; this is the most drag possible
;noninfin:
;	mov	bx,ax
;	mov	ax,otopv+4
;	cwd
;	idiv	bx

	sub	otopv+4,ax		; damp velocity by -kv factor
skipdragstuff:
	ret
.endp

.proc	writeresfile	auto
		mov	si,offset @dataseg:resfname
		mov	ax,0301h
		call	open_h
		mov	fhandl,bx
		jnc	noreserr
errorres1:
		mov	ax,3
		int	10h
		mov	si,offset @dataseg:wrferrmsg
		call	put_str
		mov	si,offset @dataseg:resfname
		call	put_str
		
		call	get_ecode
		call	wword
		jmp	error
noreserr:
		mov	si,offset @dataseg:missionstatus
		mov	cx,nresbytes
		mov	bx,fhandl
		call	write_h
		jc	errorres1
		mov	bx,fhandl
		call	close_h
		jc 	errorres1
	ret
.endp

.proc	wch	auto
	push	es
	push	si
	push	ax
	mov	ax,tvseg		; video buffer segment
	mov	es,ax
	pop	ax
	mov	si,caddr		; get current video address
	cmp	al,0ah
	jnz	realchar
	add	caddr,160
	jmp	wchdone
realchar:
	cmp	al,0dh
	jnz	realchar1
	mov	ax,caddr
	mov	bl,160
	div	bl
	xor	al,al
	xchg	al,ah
	sub	caddr,ax		; carriage return
	add	caddr,leftmarg		; start offset from left
	jmp	wchdone
realchar1:
	mov	ah,curattr
	mov	es:[si],al
	or	es:[si+1],ah		; make blink if desired
	add	caddr,2			; advance to next character
wchdone:
	pop	si
	pop	es
	ret
.endp

.proc	wchstring	auto
	mov	cx,2000			; no more than 2000 characters
wchstrlp:
	mov	al,[si]
	add	al,addvalue
	jz	wchstrret	
	call	wch
	inc	si
	loop	wchstrlp
wchstrret:
	ret
.endp

IF xrv EQ 9
mnew08
cecode	db	0
mwelcomewagon
mdolandinggear
mnew9
ENDIF

.proc	soundoff	auto
IF soundflag EQ 0
	mov	cx,7
	mov	bl,0
soloop:
	push	cx
	mov	ax,100h
	push	bx
	call	voiceoff
	pop	bx
	inc	bl
	pop	cx
	loop	soloop
	call	adlreginit			; turn off all voices
ENDIF
	ret
.endp

.proc	soundon	auto
IF soundflag EQ 0
		mov	bl,0
		mov	ax,100h
		call	voiceoff
	call	initvoices
		mov	bl,0
		mov	ax,100h
		call	voiceoff
	cmp	ejectflag,0
	jz	nowindintr
	call	windinit
nowindintr:
;	cmp	saucerflag,0
;	jz	noscrintr
;	call	saucerinit
;noscrintr:
	mov	sauceronflag,0
	mov	orbonflag,0
	mov	oldkladist,64		; pretend no kla in sight
ENDIF
	ret
.endp


.public	main
	.proc	main	auto
IF larryflag EQ 1
		mov	si,offset @dataseg:hellomsg
		call	put_str
		call	get_chr
ENDIF
IF errortrap
		call	grab00
ENDIF
		mov	ax,5555h
		mov	ax,7777h
	;	mov	al,41h
	;	call	put_chr
		call	get_version
	;	mov	al,42h
	;	call	put_chr
		call	shrink_prog
	;	mov	al,43h
	;	call	put_chr

	;	call	console_init	; this has been removed due to possible
					; failure

	;	mov	al,44h
	;	call	put_chr
IF larryflag EQ 1
		mov	si,offset @dataseg:hellomsg1
		call	put_str
		call	get_chr
ENDIF



IF larryflag EQ 1
		mov	si,offset @dataseg:hellomsg2
		call	put_str
		mov	ax,nwait
		call	decwword
		call	get_chr
ENDIF
		mov	caddr,4*160+leftmarg
		mov	si,offset @dataseg:cpywmsg
		mov	addvalue,50h
		call	wchstring
	IF shareflag EQ 0
IF userflag
		mov	caddr,10*160+leftmarg
		mov	si,offset @dataseg:username
		mov	addvalue,50h
		call	wchstring
ENDIF
	ENDIF

	IF shareflag EQ 0
		mov	si,offset @dataseg:sharemsg
		mov	addvalue,0
		call	wchstring
	ENDIF
		call	get_adapter
		cmp	al,4			; is a vga system?
		jnz	isnotvga
		mov	ax,40h			; get controller address info from BIOS
		mov	es,ax
		cmp	byte ptr es:[63h],0d4h	; is color vga?
		jz	isvga			; yes, happy day!
	isnotvga:
		mov	si,offset @dataseg:badadaptmsg
		call	put_str
		call	get_chr
		mov	al,1
		call	exit
	isvga:
		call	cleanexp
		call	turnoffbreaks			; turn off cntl-break
 		call	rand_init
;		mov	ax,1111h
;		mov	rand_seed,ax
;		mov	rand_seed+2,ax	; init seed to preset value
		call	cmdline
		jnc	restart
		mov	cs:cecode,92
		jmp	preerror	; report bad command line
	restart:
		cmp	slowflag,0	; make sure -s is there
		jnz	runningok
		mov	si,offset @dataseg:notdmsg
		call	put_str
		mov	al,1
		call	exit
runningok:
					; get path set correctly for files
IF MVPCD EQ 1
		mov	ax,ds		; set up es
		mov	es,ax
		mov	si,offset @dataseg:wpath
		mov	di,offset @dataseg:resfname
		call	str_cpy		; put in pathname
		mov	si,offset @dataseg:vresfname
		mov	di,offset @dataseg:resfname
		call	str_cat		; put in pathname
		mov	si,offset @dataseg:wpath
		mov	di,offset @dataseg:univname	
		call	str_cpy		; put in pathname
		mov	si,offset @dataseg:vunivname	
		mov	di,offset @dataseg:univname	
		call	str_cat		; put in pathname
IF nodemo EQ 0
		mov	di,offset @dataseg:demoname	
		mov	si,offset @dataseg:wpath
		call	str_cpy		; put in pathname
		mov	si,offset @dataseg:vdemoname	
		mov	di,offset @dataseg:demoname	
		call	str_cat		; put in pathname
ENDIF
IF demover EQ 0
		mov	di,offset @dataseg:fname	
		mov	si,offset @dataseg:wpath
		call	str_cpy		; put in pathname
		mov	si,offset @dataseg:vfname	
		mov	di,offset @dataseg:fname	
		call	str_cat		; put in pathname
ENDIF
ENDIF 	; MVPCD

IF soundflag EQ 0
		cmp	rundemoflag,0
		jz	nosharesnd
		mov	sndflg,-1	; let them have sound
nosharesnd:

					; initialize sounds
		call	initsound
ENDIF

IF stestflag EQ 1
IF shareflag EQ 0
		call	scrapeinit
;		call	snareinit
snareloop:
		call	get_chr
		push	ax
		call	snaresnd
		pop	ax
		cmp	al,1bh
		jnz	snareloop
		jmp	stestdn


		call	orbinit
		push	ax
		xor	ax,ax
		mov	bl,06h
		call	voiceoff
		pop	ax
		xor	ah,ah
		shl	ax,1
		shl	ax,1
		mov	bl,06h
		call	voiceon
notherc:
		call	get_chr
		cmp	al,1bh
		jz	stestdn
		xor	ah,ah
		shl	ax,1
		shl	ax,1
		mov	bl,0a6h
		call	adlwrt
		jmp	notherc
stestdn:
ENDIF
ENDIF

	IF demover
		mov	joyflag,0	; refuse to accept joystick
	ENDIF
		call	allocatemem
		jnc	memsizeok
		jmp	preerror
	memsizeok:
		mov	al,joyflag
		mov	numlock,al

		jmp	mainer1

	cfrderr:	jmp	error

	mainer:	mov	si,offset @dataseg:xvec
		call	vmag
		call	wword
		call	get_chr
	mainer1:
	IF demover
		jmp	nocfg
	ENDIF

	IF demover EQ 0

IF jdiag
	mov	ax,101
	call	wword
ENDIF

					; open config file
			mov	si,offset @dataseg:fname
			mov	ax,0102h
			call	open_h
			mov	fhandl,bx
			jc	cfrderr
			mov	si,offset @dataseg:jleft
			mov	cx,ncfgbytes
			mov	bx,fhandl
			call	read_h
			cmp	cx,ncfgbytes
			jnz	cfrderr
IF jdiag
	mov	ax,102
	call	wword
ENDIF

		call	unhashcfg		; unhash the config data
IF jdiag
	mov	ax,103
	call	wword
ENDIF

IF diagflag
		cmp	diagflg,0
		jz	skipregrep
		mov	ax,nregcode
		call	wword
		mov	ax,nregcodeh
		call	wword
		call	wcr
		call	get_chr
ENDIF
	skipregrep:
IF jdiag
	mov	ax,104
	call	wword
ENDIF
		cmp	joyflag,0		; is the joystick truned on?
		jnz	arivi1
		jmp	nojoytobe
arivi1:
IF jdiag
	mov	ax,105
	call	wword
ENDIF

		call	checkjoyexist		; does joystick exist?
		jnc	joyisours
IF jdiag
	mov	ax,106
	call	wword
ENDIF

		mov	cs:cecode,91		; no joy detected, record error
		jmp	preerror

	joyisours:
IF jdiag
	mov	ax,107
	call	wword
ENDIF

		test	jctrflag,080h		; non-zero means force center
		jnz	nocfg
IF jdiag
	mov	ax,108
	call	wword
ENDIF
		test	jctrflag,1
		jnz	nojoytobe		; force no recenter
IF jdiag
	mov	ax,109
	call	wword
ENDIF

		mov	ax,75
		call	sleep_msec

		call	joyx
IF jdiag
	push	ax
	mov	ax,110
	call	wword
	pop	ax
ENDIF

		sub	ax,jcntr
		sub	bx,jvctr
		.abs_w	bx
		.abs_w	ax
		add	ax,bx
		cmp	ax,50
		js	nojoytobe
	ENDIF
	nocfg:		
IF jdiag
	push	ax
	mov	ax,111
	call	wword
	pop	ax
ENDIF
	IF demover
		jmp	joer
	ENDIF
		cmp joyflag,0
		jz	nojoytobe		; skip joystick
IF jdiag
	push	ax
	mov	ax,112
	call	wword
	pop	ax
ENDIF
			call	nwjctr		; get new joystick info
			jnc	joyaborted	; has user aborted?
			jmp	preerror	; abort! help! call 911!
	joyaborted:
	nojoytobe:
	cfgcls:					; close configuration file
			mov	bx,fhandl
			call	close_h
			jc 	error
			jmp	joer

	error:	
;			mov	si,offset @dataseg:ferrmsg
;			call	put_str
;			call	get_ecode
;			call	wword
;			call	wcr
;			stc
			mov	al,1
			jmp	exit	; leave bad exit code
	joer:
IF jdiag
	push	ax
	mov	ax,113
	call	wword
	pop	ax
ENDIF
		

		mov	ax,clnregcode		; has cmdline requested a code chng?
		mov	dx,clnregcodeh
		mov	bx,ax
		or	dx,dx
		js	nocmdlinec
		mov	nregcode,ax
		mov	nregcodeh,dx		; if so, abide by the rules!
	nocmdlinec:
	;	xor	ax,ax
	;	mov	oy,ax
	;	mov	oy+2,ax
	;	add	oy+2,64
	;	mov	oz+2,0
	;	mov	ax,hmin
	;	mov	oz,ax
	;	mov	ox,3000
	;	mov	ox+2,roadx-3
	;	sub	ox+2,64
		mov	ejectflag,0
		mov	si,offset @dataseg:startcoords
		mov	di,offset @dataseg:ox
		mov	cx,9
		cld
		mov	ax,ds
		mov	es,ax
		rep	movsw
IF slalom
		mov	ax,ox
		mov	oldox,ax ; keep track of old x coord
		mov	ax,ox+2
		mov	oldox+2,ax
ENDIF

		mov	onrunwayflag,-1		; start out on runway
		mov	closetowerflag,-1	; start out close to tower
		mov	ax,ds
		mov	es,ax
		cld
		mov	si,offset @dataseg:ox			; xfer info to ozeff
		mov	di,offset @dataseg:oxeff
		mov	cx,9				; 3 double word xyz+ 3 angles
		rep	movsw



IF diagflag
		cmp	diagflg,0
		jz	diaglb1
		mov	si,offset testmsg
		call	put_str
ENDIF
	diaglb1:
		mov	si,offset @dataseg:obj5d
		mov	ax,[si+62]
		mov	objdamp,ax
		mov	ax,[si+60]
		mov	objdisp,ax
		mov	ax,[si+64]
		mov	tckgrav,ax
		call	objmov


		assume	es:gscum
		mov	ax,gscum
		mov	es,ax
		mov	ax,es:ngpts
		assume	es:nothing
IF chopchop
		cmp	diagflg,0
		jz	diaglb2
		call	wword
		call	wcr
ENDIF
	diaglb2:
		assume	es:gscum
		mov	ax,gscum
		mov	es,ax
		mov	cx,es:ngpts
		mov	si,offset gscum:gpts
		add	si,14
	gloop1:	push	si
		push	cx
		mov	ax,es:gpts
		mov	ax,gscum
		mov	es,ax
		call	grndpt
		pop	cx
		pop	si
		add	si,14
		loop	gloop1
		mov	ax,gscum
		mov	es,ax
		mov	cx,es:ngpts
		mov	si,offset gscum:fgpts
		add	si,14
	gloop2:	push	si
		push	cx
		mov	ax,gscum
		mov	es,ax
		call	fgrndpt
		inc	ax
		mov	es:[si+12],ax
		pop	cx
		pop	si
		add	si,14
		loop	gloop2
		mov	ax,gscum
		mov	es,ax
		mov	cx,es:ngpts
		mov	si,offset gscum:sgpts
		add	si,14
	gloop3:	push	si
		push	cx
		mov	ax,gscum
		mov	es,ax
		call	sgrndpt
		inc	ax
		mov	es:[si+12],ax
		pop	cx
		pop	si
		add	si,14
		loop	gloop3

		assume	es:nothing
IF diagflag
		mov	bx,offset gwinf
		mov	si,offset testbuf
	;	call	f3dline
		cmp	diagflg,0
		jz	diaglb3
		mov	ax,argx1
		call	wword
		mov	ax,argy1
		call	wword
		mov	ax,argx2
		call	wword
		mov	ax,argy2
		call	wword
ENDIF
	diaglb3:
	;	call	exit_ok
	;	call	grab00
		call	tmr_reset			; start measuring time
		mov	bx,offset @dataseg:rvec
		call	calcsin
		mov	si,offset @dataseg:rmat
		call	calcmat
	nocalc:	
		call	recalcmats		; recalc orot, norot and stuff
		mov	si,offset @dataseg:norot
		mov	di,offset @dataseg:nnzmat	; save zrmat for later exam
		mov	cx,9
		mov	ax,ds
		mov	es,ax
		rep	movsw
		mov	bx,offset @dataseg:orvec
		call	calcsin
		mov	si,offset @dataseg:nzmat
		call	calcmat
		mov	si,offset @dataseg:zmat
		call	ncalcmat
		cmp	diagflg,0
		jz	diaglb5
IF diagflag
		mov	si,offset @dataseg:norot
		call	wrtmat
		mov	si,offset @dataseg:rvec
		call	wrtvec
		mov	al,41h
		call	put_chr
ENDIF
	diaglb5:
IF chopchop
		jmp	tgmode

	joylop:	call	joyx
		push	bx
		call	wword
		call	wsp
		pop	ax
		call	wword
		call	wsp
		call	joytd
		push	bx
		call	wword
		call	wsp
		pop	ax
		call	wword
		call	wcr
		mov	dx,201h		; joystick button port
		in	al,dx
		and	al,30h
		cmp	al,30h
		jz	joylop
	

ENDIF
	tgmode:	
	;	mov	si,offset @dataseg:diagmsg
	;	call	put_str
	;	call	get_chr

		cmp	readfileflag,0
		jz	noreaduniv1
		cmp	actionflag,0
		jnz	noreaduniv1
		call	readunivfile
;		call	getstartfile		; get possible starting loc
	noreaduniv1:
	mov	caddr,160*19+leftmarg
	mov	addvalue,0
	mov	curattr,80h		; make blink
	mov	si,offset @dataseg:waitmsg
	call	wchstring

IF sofsrc EQ 0
		mov	ax,1500
		call	sleep_msec
ENDIF
;IF shareflag EQ 0
;		mov	al,lettercheck1
;		xor	ah,ah
;		call	wword
;ENDIF
		
		mov	ax,0f00h
		int	10h
		and	al,07fh		; clear high bit
		mov	oldmode,al		; save old video mode
		call	grmode

		cmp	readfileflag,0
		jz	noreaduniv
		cmp	actionflag,0
		jnz	noreaduniv

		mov	si,offset @dataseg:startcoords
		mov	di,offset @dataseg:ox
		mov	cx,6
		cld
		mov	ax,ds
		mov	es,ax
		rep	movsw

		cmp	chainflag,0		; is an extra plane requested
		jz	icaresreaduniv
		mov	newguyflag,0		; don't count as a new guy
		or	obj5dbits,1000h		; set dumpy plane bit
		jmp	whocaresreaduniv	; if so, start user in a plane
	icaresreaduniv:	
		sub	oy,3000
		sbb	oy+2,0
		mov	ejectflag,-1
		mov	standingflag,-1
		mov	obj5d+24,0		; make sure that image is off
		call	fullsize		; goto full screen view
		mov	numlock,0		; default is views off
		jmp	whocaresreaduniv
	noreaduniv:

		mov	newguyflag,0		; don't count as a new guy
		call	initperms
		mov	si,offset @dataseg:ox
		add	word ptr [si+4],-w*4	; move out to beginning of runway
		adc	word ptr [si+6],-1
		mov	word ptr [si+12],0
		call	recalcmats
	whocaresreaduniv:
		call	readcolors		; read color registers
	IF fadeflag
		mov	al,1
	ELSE
		mov	al,255
	ENDIF
		xor	ah,ah
		call	setcolors
		xor	bx,bx
		mov	al,skycolors
		xor	ah,ah
		add	bx,ax
		mov	al,skycolors+1
		add	bx,ax
		mov	al,skycolors+2		; if sky is dark, make gdetail light
		add	bx,ax
		cmp	bx,30h
		ja	blkisfine		; if sky is light, then black is fine
		mov	gndcolor,0eh		; if dark, make gnd detail yellow
		mov	sunclr,15		; make sun into a moon
	blkisfine:

;		jmp	ship3			; ignore testing stuff

	ship3:

		mov	vboff,7e00h		; start video in right place
		mov	n,7
	;	call	rimgall
		xor	al,al
		call	readimg		; read in the instrument panel
		jnc	instreadok	; looks like the inst panel got read ok
		mov	al,oldmode
		xor	ah,ah
	and	al,7fh		; clip off high bit to make sure palette
				; is reset
		int	10h
		mov	si,offset @dataseg:rimgemsg
		call	put_str
		mov	al,-1
		jmp	exit		; abort program with passion

	instreadok:
		mov	al,instflag	; save status of instflag
		push	ax
		mov	instflag,-1	; make sure needles get drawn
		call	drawndles
		call	flipage
		call	drawndles
		call	flipage
		pop	ax
		mov	instflag,al

		call	flush_keys		; grab keys before those plusses hit
		call	grab9
IF diagflag
		mov	si,offset @dataseg:diagm1
		call	put_str
ENDIF
		call	grab08
IF diagflag
		mov	si,offset @dataseg:diagm2
		call	put_str
ENDIF
		mov	al,6			; set timer mode 3
		mov	cx,tickdiv		; reload value is much smaller
		call	set_timer0
		sti				; reable ints

		mov	al,43h
		call	put_chr
		call	distortcolor

		mov	redamageflag,0		; do not use old damage
		call	damageinit		; init damage and bomb displays
	;	mov	si,offset @dataseg:obj5d
	;	call	d3dobj
	;	mov	al,44h
	;	call	put_chr
;
;	ship6:
;		mov	al,45h
;		call	put_chr

		mov	scncode,0
		mov	scnflg,0


	sanml:	xor	cx,cx
	anml1:	
		inc	nframes
		xor	ax,ax
		mov	ax,cs:tdticks
		mov	dx,cs:tdticks+2
IF printflag
		add	ttticks,ax
		adc	ttticks+2,dx
ENDIF
	tmlp:	
		mov	ax,cs:frmticks
		cmp	qtimeinc,0		; are we in forced mode?
		jz	nofmode
		mov	ax,qtimeinc		; force time to be fixed
		add	cs:oticks,ax		; pretend oticks is running
nofmode:
		mov	cl,3
		shr	ax,cl
		bndck	maxofrm,minofrm		; don't allow divide by zero, or
						; too lengthy frames
		mov	advflag,0		; assume no advanced time
		mov	ofrmticks,ax
		mov	realofrmticks,ax
		mov	al,14h
		call	getkbit			; check for accerated time
		or	al,al
		jz	noaccel
		mov	ofrmticks,50

		mov	advflag,-1		; set advanced time mode
	noaccel:
IF nodemo EQ 0
		cmp	demoflag,-1	; if demo playback, force mcguire speed
		jnz	nodmpbspd
		mov	ofrmticks,10
		cmp	demorepflag,0
		jz	nodmpbspd
		mov	ofrmticks,20
	nodmpbspd:
ENDIF


	cmp	scncode,44h+80h
	jnz	noblack
	mov	rmsgqueue,offset @dataseg:cmpltrmsg
noblack:

	mov	si,rmsgqueue
	or	si,si
	jz	skiprmsg
	cmp	rmsgflag,0
	jz	skiprmsg
		call	blackbox
	mov	rmsgqueue,0
skiprmsg:
	IF demover EQ 0			; don't do tower stuff in demo
		cmp	demoflag,0
		jnz	forgettower	; if demo playback, no boss screen etc
		mov	al,bossflag		; if boss or in tower, call dotower
		or	al,intowerflag
		jz	forgettower
		call	dotower			; do stuff that happens when in
						; the tower
		mov	bossflag,0		; zero when done
		call	restoreview		; restore our view
	forgettower:				; leave label even if no demo
	ENDIF


	IF protection	; only do the bouncing ball if shareware version
	IF demover EQ 0				; only do bouncing ball if not demo
						; version

		call	welcomewagon
	ENDIF
	ENDIF
		cmp	helpreqflag,0
		jnz	queuehelpreq
		cmp	scncode,3eh+80h
		jnz	nohelpreq
queuehelpreq:
		mov	scncode,39h+80h		; push a space key into buf
		jmp	nopause1		; pretend pause key hit

nohelpreq:
		cmp	scncode,19h+80h
		jz	nopause1
	nopause2:
		jmp	nopause			; check for pause

	nopause1:
		mov	al,38h			; make sure alt key is up
		call	getkbit
		jnz	nopause2			; forget it, alt key is down
IF soundflag EQ 0
		mov	bl,0		; turn off voice
		mov	ax,100h
		call	voiceoff
		mov	bl,2
		mov	ax,10h
		call	voiceoff	; turn voice off (blams)
ENDIF

		cmp	helpreqflag,0
		jnz	skiprstsc
		cmp	scncode,39h+80h
		jz	skiprstsc	; if help requested, let it pass
		mov	scncode,0		; clear this code
skiprstsc:
		mov	helpreqflag,0
		mov	curhelpindex,mincurhelpindex
		cmp	groundflag,0
		jnz	noskiphelp1
		mov	curhelpindex,mincurhelpindex+1	; skip over intro
noskiphelp1:


		call	addtoetime		; keep track of time elapsed

		mov	ax,0f07h		; turn on hold button
		mov	bx,1
		call	drawbutton
		mov	ax,0500h
		mov	bx,1
		call	drawbutton
		mov	ax,070fh		; load with funky value
	waitforp:
	IF demover EQ 0			; help capability on in non-demo version
		push	ax
		cmp	scncode,39h+80h
		jnz	noswitchhelp
		mov	scncode,0
		mov	al,curhelpindex
		mov	bx,offset @dataseg:helpimgtable
		xlat				; pick out a nice help screen
		call	readimg			; read in help file
		inc	curhelpindex
		cmp	curhelpindex,maxcurhelpindex
		jbe	noswitchhelp
		mov	curhelpindex,mincurhelpindex
	noswitchhelp:

		pop	ax
	ENDIF

		test	cs:oticks,1023
		jnz	hflash
		xchg	al,ah			; make button flash
	hflash:
		push	ax
		mov	bx,1
		call	drawbutton
		pop	ax
		cmp	scncode,19h+80h		; now wait for another p
		jz	nowaitforp
		cmp	scncode,81h		; also accept escape
		jnz	waitforp
	nowaitforp:
		call	tmr_reset		; start time accounting again

		mov	scncode,0		; clear this code
		push	ax
		mov	ax,0005h		; turn off background of button
		mov	bx,1
		call	drawbutton
		pop	ax
		cmp	ah,0fh			; which way was it left?
		jnz	hflash2
		xchg	al,ah
		mov	bx,1
		call	drawbutton
	hflash2:

	nopause:
		mov	di,offset @dataseg:jrght-24
		mov	ax,[di+24]
		mov	bx,[di+(jrght1-jrght)+24]
		sub	ax,bx
		jnz	trialstuffndn
	

IF protection
		mov	si,offset @dataseg:weltableindex-80
						; has trial period stuff been done?
		mov	al,[si+80]
		cmp	al,weltablemaxi		; compare to max allowable index
		jbe	trialstuffndn
ENDIF

		cli
		add	[di+24],151h		; mark trial period as done
		sub	[di+(jrght1-jrght)+24],151h
		sti
	
	trialstuffndn:



					; does person want map?
		xor	ax,ax		; use al instead of zero immediate
		cmp	scncode,32h+80h
		jnz	nomapwanted
		mov	scncode,al
		mov	mapwantedflag,-1
		cmp	rmsgflag,al
		jz	nomapwanted	; dont require message if comment off
		mov	rmsgqueue,offset @dataseg:maprmsg
		cmp	readfileflag,al
		jnz	nomapwanted
		mov	rmsgqueue,offset @dataseg:maprmsg1
		mov	mapwantedflag,al
nomapwanted:
		cmp	mapwantedflag,al
		jz	nocopyt1
		cmp	rmsgflag,al
		jz	startmap
		cmp	rmsgqueue,ax
		jnz	nocopyt1	; if user hasn't read msg, delay map
startmap:
		mov	mapwantedflag,0	; got stuck in a horrible loop!

		mov	si,ptrgwinf		; are we cockpit, or fullscreen view?
		cmp	word ptr [si+6],gfymax
		ja	alreadyfscrn
		call	fullsize
		mov	orotptr,offset @dataseg:orot
		mov	norotptr,offset @dataseg:norot
		call	soundoff
		call	maploop
		jnc	noemergency
		jmp	donep33			; leave now!
	noemergency:
		call	soundon
		mov	redamageflag,-1		; use old damage

		call	interiorview
		call	damageinit
		call	redrawbuts		; redraw the buttons

		jmp	nocopyt1
	alreadyfscrn:
		call	maploop
	nocopyt1:




		mov	cs:frmticks,0
		mov	cs:dticks,0
		mov	cs:dticks+2,0
		mov	cs:tdticks,0
		mov	cs:tdticks+2,0
		inc	frmnum
		cmp	frmnum,16384		; if frame number getting up
						; there, reduce it again
		jb	frmnumok
		mov	frmnum,128		; don't let frame number roll
						; over!
frmnumok:
		call	epage			; erase messy borders on page

; calculate the direction of the home airport

		mov	si,offset @dataseg:startcoords
		mov	di,offset @dataseg:arrowbuf
		mov	cx,6
		mov	ax,ds
		mov	es,ax
		cld
		rep	movsw
		mov	si,offset @dataseg:arrowbuf
		mov	di,offset @dataseg:ox
		mov	ax,[si]
		mov	dx,[si+2]
		sub	ax,[di]
		sbb	dx,[di+2]
		sal	ax,1
		rcl	dx,1
		sal	ax,1
		rcl	dx,1
		sal	ax,1
		rcl	dx,1
		sal	ax,1
		rcl	dx,1
		push	dx
		add	di,4
		add	si,4
		mov	ax,[si]
		mov	dx,[si+2]
		sub	ax,[di]
		sbb	dx,[di+2]
		sal	ax,1
		rcl	dx,1
		sal	ax,1
		rcl	dx,1
		sal	ax,1
		rcl	dx,1
		sal	ax,1
		rcl	dx,1
		pop	ax
		mov	bx,ax
		.abs_w	bx
		mov	cx,dx
		.abs_w	cx
		add	bx,cx
		mov	arrowflag,1
		cmp	bx,10
		ja	arrowgood
		mov	arrowflag,0
arrowgood:
		
		call	atn2		; ax will now hold angle
;		add	ax,08000h	; reverse angle direction 180 deg
		sub	ax,orvec	; subtract current heading
		mov	homeangle,ax

		cmp	arrowflag,0
		jnz	arrowfine
		jmp	arrowbadt
arrowfine:
		mov	si,ptrgwinf		; are we cockpit, or fullscreen view?
		mov	ax,word ptr [si+6]	; gfymax
		add	ax,2
		mov	argy2,ax
		add	ax,6
		mov	argy1,ax
		mov	ax,homeangle
		sar	ax,1
		neg	ax
		bndck	4000,-4000
		mov	dx,310
		imul	dx
		mov	bx,4000
		idiv	bx
		add	ax,310
		mov	argx1,ax
		add	ax,2
		mov	argx2,ax
		mov	n,0
		call	egaline
		add	argx1,2*2	
		call	egaline

arrowbadt:
		mov	ax,cs:dticks
		mov	dx,cs:dticks+2
IF printflag
		add	epticks,ax
		adc	epticks+2,dx
		add	toticks,ax
		adc	toticks+2,dx
		mov	cs:dticks,0
		mov	cs:dticks+2,0
ENDIF
		call	erasndles
IF printflag
		mov	ax,cs:dticks
		mov	dx,cs:dticks+2
		add	inticks,ax
		adc	inticks+2,dx
		add	toticks,ax
		adc	toticks+2,dx
ENDIF
;		mov	dotflg,0
	;	mov	ax,gscum
	;	mov	es,ax
	;	mov	cx,es:ngpts
	;	mov	si,offset gscum:fgpts
	;gloop3:	
	;	push	cx
	;	push	si
	;	mov	ax,gscum
	;	mov	es,ax
	;	call	g3dobj		; plot the point
	;				; and watch it crash!
	;	pop	si
	;	pop	cx
	;	add	si,14
	;	loop	gloop3
	;

IF printflag
		mov	ax,cs:dticks
		mov	dx,cs:dticks+2
		add	gdticks,ax
		adc	gdticks+2,dx
		add	toticks,ax
		adc	toticks+2,dx
ENDIF

		assume	es:nothing

IF printflag
		mov	cs:dticks,0
		mov	cs:dticks+2,0
ENDIF

	;	jmp	ship5
		mov	ax,2
		uwtadj
		cmp	ax,2
		jae	tconstok		; relativise look thing to cpu speed
		mov	ax,2
	tconstok:
		mov	bx,ax

		mov	ax,desiredyaw
		sub	ax,curryaw
		jz	leaveoyaw
		cwd
		idiv	bx
		add	curryaw,ax
	leaveoyaw:
		mov	ax,desiredyaw+2
		sub	ax,curryaw+2
		jz	leaveoyaw1
		cwd
		idiv	bx
		add	curryaw+2,ax
	leaveoyaw1:

		cmp	desireflag,0
		jz	useorot
		mov	si,offset @dataseg:norot
		mov	di,offset @dataseg:curnmat
		mov	ax,ds
		mov	es,ax
		mov	cx,9
		cld
		rep	movsw
		mov	ax,curryaw+4
		mov	bx,curryaw+2
		mov	cx,curryaw
		mov	si,offset @dataseg:curnmat
		call	rolpln

		mov	bx,offset @dataseg:curnmat
		mov	si,offset @dataseg:obsangs
		call	getang

		mov	bx,offset @dataseg:obsangs
		call	calcsin
		mov	si,offset @dataseg:curmat
		call	calcmat

		mov	orotptr,offset @dataseg:curmat
		mov	norotptr,offset @dataseg:curnmat
	;	mov	ax,obsangs+2
	;	mov	viewkludge,ax
		jmp	useanything
	useorot:	
		mov	ax,orvec+2
		mov	viewkludge,ax
		mov	orotptr,offset @dataseg:orot
		mov	norotptr,offset @dataseg:norot
	useanything:
	ship5:
	;	call	dotiles

		mov	cs:dticks,0
		mov	cs:dticks+2,0
		call	modhr

		mov	hrflg,-1		; turn on fills
		mov	si,offset @dataseg:hrobj
		call	d3dobj
		mov	hrflg,0			; turn off fills

; old place where we used to draw objsun

IF printflag
		mov	ax,cs:dticks
		mov	dx,cs:dticks+2
		add	hrticks,ax
		adc	hrticks+2,dx
		add	toticks,ax
		adc	toticks+2,dx
		mov	cs:dticks,0
		mov	cs:dticks+2,0
ENDIF

		cmp	bhighflag,0	; are we way high?
		jz	drawingstuffskip1	; if so, don't draw any more objects
		jmp	drawingstuffskip
	drawingstuffskip1:
		cmp	gdflg,0
		jz	nogrdtd

		assume	es:gscum
		mov	ax,gscum
		mov	es,ax
		mov	cx,es:ngpts
		mov	si,offset gscum:gpts
	gloop:	
		push	cx
		push	si
		mov	ax,gscum
		mov	es,ax
		clc			; leave flag to tell it is a groundpt
		call	g3dobj		; plot the point
	;	call	evalgpt		; evaluate distance from us
					; and watch it crash!
		pop	si
		push	si
		jnc	gdspok
		mov	ax,gscum
		mov	es,ax
		call	grndpt
	gdspok:	
		call	rand_w
		cmp	ax,gchnc
		ja	noluck		; are we lucky enough to try a new point?
		mov	ax,gscum
		mov	es,ax
		call	grndpt
	noluck:	
		pop	si
		pop	cx
		add	si,14
		loop	gloop

		cmp	starsflag,0
		jz	nogrdtd
					; now do the star gpts
		assume	es:gscum
		mov	ax,gscum
		mov	es,ax
		mov	cx,es:ngpts
		mov	si,offset gscum:sgpts
		mov	al,gndcolor
		push	ax
		mov	gndcolor,15	; make stars white!
	sgloop:	
		push	cx
		push	si
		mov	ax,gscum
		mov	es,ax
		stc			; leave flag to tell it is a star
		call	g3dobj		; plot the point
		pop	si
		pop	cx
		add	si,14
		loop	sgloop
		pop	ax
		mov	gndcolor,al
	nogrdtd:

		test	obj5dbits,2000h		; no sun when in bomber
		jnz	skipsun
		mov	si,offset @dataseg:xvec
		xor	ax,ax
		mov	word ptr [si],ax
		mov	ax,sunangle
		call	ssin
		neg	ax
		hmul	ax,1000
		mov	word ptr [xvec+2],dx
		mov	ax,sunangle
		call	scos
		hmul	ax,1000
		mov	word ptr [xvec+4],dx
;		mov	bx,offset @dataseg:norot
;		mov	si,offset @dataseg:xvec1
;		mov	di,offset @dataseg:xvec
;		call	matvmul

		mov	si,offset @dataseg:objsun
		mov	dx,ptrgwinf
		call	drawrdirect

	skipsun:

	IF qtables EQ 1
		call	drawmemseg
		cmp	cs:cecode,0	; has there been a panic?
		jz	nodemerg
		jmp	donep33		; emergency disengage
	nodemerg:
	ENDIF
IF soundflag EQ 0
		mov	ax,orbdist
		cmp	orbonflag,0	; is orb already on?
		jnz	orbonstuff
		cmp	ax,63		; are we close?
		jae	checksauce	;
		mov	ax,0ffh
		mov	bl,3
		call	voiceoff
		call	orbinit
		mov	orbonflag,-1
		mov	al,orbfreq
		xor	ah,ah
		mov	bl,03h
		call	voiceon
		mov	ax,orbdist
orbonstuff:
		cmp	ax,63		; are we close?
		jae	orbshutdown	;
		sub	ax,13
		jns	minsound
		mov	ax,0
minsound:
		mov	bl,4bh
		call	adlwrt		; set sound
		mov	bl,48h
		call	adlwrt		; set sound
		mov	al,orbfreq
		mov	bl,0a3h
		call	adlwrt
		jmp	sacuerdone
orbshutdown:
		mov	bl,3
		mov	ax,10h
		call	voiceoff
		mov	sauceronflag,0	; note that saucer voice is off
		call	screechinit
		mov	orbonflag,0
checksauce:
		cmp	orbonflag,0
		jz	dosaucerstuff
		jmp	sacuerdone
dosaucerstuff:
		mov	ax,saucerdist
		mov	ssdist,ax
		cli			; don't let timer pick up here
		mov	saucerflag,0	; reset saucer flag=no saucer
		cmp	ax,255	; is there a close saucer?
		jae	scrtofar		; no
		not	saucerflag	; set saucerflag
		sti
		cmp	sauceronflag,0	; is saucer on?
		jnz	nonewscr	; yes, so it doesn't need on ness
		push	ax
		mov	bl,3
		call	voiceoff
		call	saucerinit

		mov	bl,3
		mov	ax,0ffh
		mov	sauceronflag,al	; note that saucer voice is on
		call	voiceon
		pop	ax
nonewscr:
;		cmp	ax,4096
;		ja	srcrlclose
;		mov	ax,4096		; set up loudest limit
;srcrlclose:
;		sub	ax,4096		; doesn't get any louder than this
		mov	cl,2		; divide by 1024
		shr	ax,cl
		mov	ssmag,ax
		mov	bl,4bh
		call	adlwrt		; set sound
		mov	al,ssfreq
		mov	bl,0a3h
		call	adlwrt
		jmp	sacuerdone
scrtofar:	
		sti	
		cmp	sauceronflag,0
		jz	sacuerdone
		mov	bl,3
		mov	ax,10h
		call	voiceoff
		mov	sauceronflag,0	; note that saucer voice is off
		call	screechinit
sacuerdone:
ENDIF
IF soundflag EQ 0
		xor	ah,ah	
		mov	al,klaqual	; get quality
		mov	cl,4
		shl	ax,cl
		add	ax,40		; keep away from zero frequency
		mov	bx,realklafreq
		sub	ax,bx		; find difference between desired
					; and current frequency
		sar	ax,1		; divide over next 4 frames
		sar	ax,1		; divide over next 4 frames
		add	ax,bx	;
		mov	realklafreq,ax	; make real
		mov	bl,0a4h		; set low part of frequency
		call	adlwrt
	
		mov	ax,kladist
		mov	bx,8	; make kla louder, but min atten is zero
		cmp	ax,8
		jbe	loudrailed
		mov	bx,ax	; use default
loudrailed:
		mov	klaloud,bx

		mov	ax,oldkladist
		cmp	ax,64
		jae	klaisoff  ; if not taken, then kla was on last time
		mov	ax,kladist	; is kkla on this time?
		cmp	ax,64
		jae	klsboff

		mov	ax,klaloud
		mov	bl,4ch	; turn up to correct volume
		call	adlwrt
		jmp	klasoundone	; that is all we have to do
klsboff:
		mov	ax,63
		mov	bl,4ch	; turn down to min volume
		call	adlwrt
		mov	bl,04h	; turn off voice
		call	voiceoff
		jmp	klasoundone

klaisoff:
		mov	ax,kladist	; is kkla on this time?
		cmp	ax,64
		jae	klasoundone	; is off, should be off, fine here!
				; if branch not taken, then should be on!

		mov	ax,klaloud
		mov	bl,4ch	; turn up to correct volume
		call	adlwrt
		xor	ah,ah	
		mov	al,klaqual	; get quality
		mov	cl,5
		shl	ax,cl
		mov	bl,04h		; turn voice on
		call	voiceon
		jmp	klasoundone

klasoundone:
		mov	ax,kladist
		mov	oldkladist,ax
ENDIF
		call	initnumbers	; limit dballs and vechs to number of active
					; sites

IF guns
		call	bulmov
ENDIF ; guns
		call	expmov

		mov	onrunwayflag,0	 ; this flag must be recalced every frame
		xor	ax,ax		; default ground height is zero
		mov	zground,ax
		mov	zground+2,ax
		mov	myzground,ax
		mov	myzground+2,ax
		call	drawnear	; draw all objects in universe

		call	doxp		; if a portal is requesting a xfer, do it now
		call	donewmiss	; if new mission selected, engage!

	IF qtables EQ 1
		call	copytable
		cmp	easyflag,0
		jz	nocopyt		; don't allow access to this w/o -e
		cmp	scncode,36h+80h
		jnz	nocopyt
		mov	scncode,0
		call	flushtiles
		call	copyuniv
	nocopyt:
		call	dotiles
	ENDIF
	drawingstuffskip:
		cmp	ejectflag,0
		jz	noplypln1
		cmp	remoteflag,0
		jnz	yesitpoly
	noplypln1:
		jmp	noplypln
	yesitpoly:
		mov	ax,ptrgwinf
		push	ax
		mov	ax,offset @dataseg:gwinl
		mov	ptrgwinf,ax
		call	erasewinf
		mov	xvec1,7000
		mov	xvec1+2,0
		mov	xvec1+4,0

		mov	bx,offset @dataseg:norot
		mov	si,offset @dataseg:xvec1
		mov	di,offset @dataseg:xvec
		call	matvmul

		mov	si,offset @dataseg:obj5d
		mov	dx,ptrgwinf
		call	drawrdirect
		pop	ax
		mov	ptrgwinf,ax

		mov	si,offset @dataseg:obj5d
		call	drawtodxvec		; draws observers view to dxvec
		jc	noplypln
						; dxvec now holds the magic vector
						; which points away from the plane
	noplypln:
		cmp	ejectflag,0
		jz	nohalt
		cmp	haltflag,0	; are we halted
		jz	nohalt
		mov	remoteflag,0	; take out of remote if in remote
		mov	si,offset @dataseg:haltox	; coordinates to look at
		call	drawtodxvec
		mov	ax,500
		wtadj
		mov	stepsz,ax

		call	goodstep	; step without shaking screen
		mov	al,haltflag	; only a positive haltflag can kill
		or	al,al
		js	nohalt

		mov	ax,faderate
		wtadj
		or	ax,ax
		jnz	nonzfade
		mov	ax,1
	nonzfade:
		mov	bx,ax
		mov	ax,word ptr fadecolorl
		xor	dx,dx
		sub	ax,bx
		sbb	dx,-1
		jns	fadepos
		xor	ax,ax
	fadepos:
		mov	word ptr fadecolorl,ax
		mov	al,ah
		xor	ah,ah
		test	tripflag1,1	; if tripping, don't mess with palatte
		jnz	tripf4
		call	setcolors			; fade it out!
	tripf4:

	nohalt:
		cmp	ejectflag,0
		jnz	noshowprop
		cmp	rpm,50
		jg	noshowprop
		cmp	currpmx,0
		jz	noshowprop
IF nodemo EQ 0
		cmp	demoflag,-1
		jz	noshowprop		; don't show prop if in demo mode
ENDIF
		mov	si,offset @dataseg:objprop	; display the prop
		mov	dx,ptrgwinf
		call	d3dobj
	noshowprop:
		cmp	ejectflag,0
		jz	yesdrawgs
		mov	al,4ch
		call	getkbit
		push	ax
		mov	al,52h
		call	getkbit
		pop	bx
		or	al,bl
		jnz	skipgs
	yesdrawgs:
		call	drawgs			; draw gunsight
	skipgs:
IF printflag
		mov	ax,cs:dticks
		mov	dx,cs:dticks+2
		add	dnticks,ax
		adc	dnticks+2,dx
		add	toticks,ax
		adc	toticks+2,dx
ENDIF

		mov	si,ptrgwinf	; get address of window
		cmp	word ptr [si+6],gfymax	; if full window, then don't do this
		jbe	screenok
		jmp	noinsttick
	screenok:
	
		call	clearticks
		mov	ax,xang
		call	drawairtick		; draw a nice tick on the panel
		mov	ax,yang
		call	drawelvtick
		mov	ax,rdrang
		call	drawrdrtick
		mov	cs:dticks,0
		mov	cs:dticks+2,0
		call	drawndles			; draw altimeter needle
	noinsttick:
	;	mov	n,15
	;	add	testang,345
	;	mov	ax,testang
	;	call	ssin
	;	mov	bx,511
	;	imul	bx
	;	push	dx
	;	mov	ax,testang
	;	call	scos
	;	neg	ax
	;	mov	bx,511
	;	imul	bx
	;	mov	bx,dx
	;	pop	ax
	;	mov	bx,testang
	;	mov	ax,240
	;	call	radardot

IF printflag
		mov	ax,cs:dticks
		mov	dx,cs:dticks+2
		add	inticks,ax
		adc	inticks+2,dx
		add	toticks,ax
		adc	toticks+2,dx
ENDIF
		call	flipage

		xor	ax,ax
		mov	dx,rpm				; calc max temperature
		shr	dx,1
		rcr	ax,1
		mov	bx,rpmx
		div	bx

;		mov	bx,7
;		mul	bx
;		mov	bx,6
;		div	bx

		mov	dx,thrtmult
		mul	dx
		mov	ax,dx
		sub	ax,opres
		cwd
		mov	bx,40
		idiv	bx
		add	opres,ax		; incr or decrement engine temp

IF soundflag EQ 0
		cmp	remoteflag,0
		jnz	yessound1
		cmp	ejectflag,0
		jnz	nosound1
yessound1:
		cmp	currpmx,0
		jnz	yessound2
		mov	ax,40h
		mov	bl,0
		call	voiceoff
		cmp	crshvel,0
		jz	nosound1
		jmp	skipwind
yessound2:	
		mov	ax,opres
;		shr	ax,1
		add	ax,30h*40
		xor	dx,dx
		mov	bx,topv
		or	bx,bx		; make sure velocity is positive
		js	skipwind
		add	ax,bx
		adc	dx,0		; add in velocity
		mov	bx,80
		div	bx
		bndck	400h,40h
IF avgthrot
		mov	cl,4
		shl	ax,cl
		mov	dx,throtfrq
		mov	bx,dx
		sub	ax,dx
		sar	ax,cl
		add	ax,bx
		mov	throtfrq,ax
		shr	ax,cl
ENDIF
		mov	bl,0
		call	voiceon
		mov	ax,engdam
		shl	ax,1
		js	skipwind
		sub	ax,16
		neg	ax
		jns	pwok
		mov	ax,0
pwok:
		mov	bl,40h		; write to adlib register
		call	adlwrt		; to make prop wash constant
		jmp	skipwind
ENDIF
nosound1:
IF soundflag EQ 0
		mov	ax,windtick
		cmp	ax,cs:oticks
		jns	nowtog
		neg	windflag	; if windflag 1, sound on, if -1, off
		js	wfneg
	mov	al,20h
	mov	bl,0bdh
	call	adlwrt
	jmp	winddone
wfneg:
	mov	al,28h			; turn on snare, leave mode alone
	mov	bl,0bdh
	call	adlwrt
winddone:
	mov	bx,4096			; 4 second median
	call	randr_w			; get random time for future event
	add	ax,cs:oticks		; specify time for next wind change
	mov	windtick,ax
nowtog:
skipwind:
ENDIF
		cmp	freezeflag,0
		jz	freeze1
		
		cmp	helpflashflag,0
		jz	freeze2a
		mov	ax,0701h		; load with funky value
		test	cs:oticks,1024+512
		jnz	helpflash

		mov	ax,0107h		; load with funky value
helpflash:
		mov	bx,12
		call	drawbutton
freeze2a:
		jmp	freeze2
	freeze1:
		mov	dx,rpm				; calc max temperature
		shr	dx,1
		rcr	ax,1
		mov	bx,rpmx
		div	bx
		sub	ax,etemp
		cwd
		mov	bx,180
		idiv	bx
		add	etemp,ax			; incr or decrement engine temp
		cmp	crshlndflag,0		; have we crash landed?
		jz	crshland1
		cmp	ejectflag,0
		jnz	crshlndej
		xor	ax,ax
		mov	orvec+2,ax
		mov	orvec+4,ax		; make plane be right side up
		mov	ax,crshvel
		add	orvec,ax		; make plane do a flat spin
		mov	ax,hmin			; leave plane on the ground
		mov	dx,0
		add	ax,zground
		adc	dx,zground+2
		mov	oz,ax
		mov	oz+2,dx
		jmp	crshland1
	crshlndej:
		xor	ax,ax
		mov	obj5d+14,ax
		mov	obj5d+16,ax		; make plane be right side up
		mov	obj5d+2,ax
		mov	ax,crshvel
		add	obj5d+12,ax		; make plane do a flat spin
		mov	ax,hmin			; leave plane on the ground
		mov	obj5d+8,ax
	crshland1:

		mov	bx,offset @dataseg:orvec
		cmp	ejectflag,0			; but are we ejected?
		jz	otherangles
		call	calcsin
		mov	si,offset @dataseg:orot
		call	calcmat
		mov	si,offset @dataseg:norot
		call	ncalcmat
		mov	bx,offset @dataseg:obj5d+12
	otherangles:
		mov	ax,[bx+2]
		mov	oldang,ax
		mov	ax,[bx]
		mov	oldyaw,ax
		mov	ax,[bx+2]
		mov	oldpit,ax
		mov	ax,[bx+4]
		mov	oldrol,ax

	
		call	calcsin
		mov	si,offset @dataseg:zmat
		call	ncalcmat

		cld
	;	mov	si,offset @dataseg:zmat
	;	mov	di,offset @dataseg:zrmat	; save zrmat for later exam
	;	mov	cx,9
	;	mov	ax,ds
	;	mov	es,ax
	;	rep	movsw
	freeze2:
		call	joytd
		sub	ax,200h			; center it
		sub	bx,200h			; center it
		cmp	ejectflag,0		; have we ejected?
		jnz	outahere		; we aren't in the plane anymore
	qrem:	jmp	stillcounts
	outahere:				; so use joystick to look around
		cmp	remoteflag,0
		jnz	qrem			; let user fly plane remotely if desired
		mov	cx,ax
		neg	cx
		neg	bx

		mov	ax,tmbvec
		mov	dx,9500
		imul	dx
		mov	di,10100
		idiv	di
		mov	tmbvec,ax
		mov	ax,tmbvec+2
		mov	dx,9500
		imul	dx
		mov	di,10100
		idiv	di
		mov	tmbvec+2,ax
		add	ax,tmbvec
		add	bx,tmbvec+2

		call	bumpangles		; adjust orvec angles a little
		mov	ax,orvec+4
		neg	ax
		mov	cl,6
		sar	ax,cl
		wtadj
		add	orvec+4,ax		; yaw
		cmp	swingcount,0
		jz	plnalive
		call	swing			; swing the chute
	plnalive:
		xor	ax,ax			; zeros for control
		xor	bx,bx
	stillcounts:
		cmp	freezeflag,0
		jz	freeze3
		jmp	freeze4
	freeze3:
		add	bx,5		; give a plus bias on the joystick pitch
		mov	xang,ax		; save old y rail
		mov	ax,yraild
		mov	oyrail,ax		; save old y rail flag
		mov	yang,bx
		mov	ax,bx
		bndck	220h,-220h		; test for railed
		sub	ax,bx
		mov	yraild,ax	; non-zero means joystick raild

		mov	ax,xang
		mov	bx,ax
		bndck	110h,-110h	; look for semi-railed x
		sub	ax,bx
		jz	xnotrailed
		xor	ax,ax
		cmp	groundflag,0
		jz	xnotrailed	; only interested when on the ground
		cmp	ejectflag,al
		jnz	xnotrailed	; don't bother unless in plane
		cmp	altmsgflag,al	; don't bother if low alt msg off
		jz	xnotrailed
		cmp	oldxrailflag,al
		jnz	xnot2
		mov	rmsgqueue,offset @dataseg:rudrmsg
		mov	oldxrailflag,1
		jmp	xnot2
xnotrailed:
		mov	oldxrailflag,0
xnot2:

		mov	ax,ctopv		; get forward veloctiy
		bndck	vstal2,mvstal2
		mov	vpxp,ax			; save for everybody
	;	mov	cl,5
	;	shr	ax,cl
	;	mov	dx,xang			; get joystick roll amount
	;	sar	dx,1			; divide by 2
	;	imul	dx			; make roll torque linear in vpxp
	;	hmul	ax,rollmx		; now scale into max roll speed
	;	mov	ax,thrdot		; and now add relaxation time
	;	sub	dx,ax			; torque = vpxp*joyroll-alpha*rollspd
	;	mov	ax,dx			; now add in the moment of intertia
	;	cwd				; prepare for division
	;	mov	cx,rolln			; effect
	;	idiv	cx
	;	add	thrdot,ax		; speed up or slow down the roll

						; make controls less sensitive at low
						; air pressure
		mov	dx,xang
		mov	ax,rhotop		; decrease with air pressure
		imul	dx
		mov	bx,rho0			; rho/rho0
		idiv	bx

						; now calculate pitch angle change

		mov	dx,vpxp			; get forward limited velocity
		imul	dx			; speed times stick position
		mov	bx,vpxp
		.muls_dw	bx,cx		; mult by vpxp squared
		mov	bx,300
		call	divs_dw			; divide by max vpxp allowed
		mov	bx,thrsf		; apply scale factor
		.muls_dw bx,cx			; leave in double int format
		push	ax
		push	dx
		mov	ax,thrdotl
		mov	dx,thrdoth
	;	dwtadj
	;	mov	bx,2
	;	.muls_dw	bx,cx		; multiply by 3 for faster damping
		mov	bx,dx
		mov	cx,ax
		add	cx,ax
		adc	bx,dx
		add	cx,ax
		adc	bx,dx			; mult by 3
		sar	bx,1
		rcr	cx,1			; divide by 2
	;	sub	ax,thrdotl		; make exponential fall off
	;	sbb	dx,thrdoth
		pop	dx
		pop	ax
		sub	ax,cx
		sbb	dx,bx
		mov	bx,thrmi		; now include moment of inertia
		call	divrs_dw
		add	thrdotl,ax		; update pitdot
		adc	thrdoth,dx
		mov	bx,thrdam
		or	bx,bx			; zero damage?
		jz	nothrdam
		mov	ax,thrdam
	;	wtadj
		cwd
		xchg	dx,ax
		sar	dx,1
		rcr	ax,1
		sar	dx,1
		rcr	ax,1
		sar	dx,1
		rcr	ax,1
						; reduce wing damage effect with
						; airspeed
		mov	bx,vpxp
		.muls_dw	bx,cx		; mult by vpxp squared
		mov	bx,300
		call	divs_dw			; divide by max vpxp allowed

		add	thrdotl,ax
		adc	thrdoth,dx
	nothrdam:


		cmp	autoflag,0		; is autopilot engaged?
		jz	noauto1
		mov	ax,orveceff+4		; look at roll
		neg	ax			; reverse feedbag
		bndck	25,-25			; set maximum auto pilot adjrate
		mov	dx,ax				; now shift into position
		sar	dx,1
		rcr	ax,1
		sar	dx,1
		rcr	ax,1
		add	thrdotl,ax
		adc	thrdoth,dx		; apply to pitch
	noauto1:


						; mess about
		mov	ax,topv			; get angle of side wind
		mov	dx,topv+2		;
		call	atn2			; and then limit it's extent
		mov	bx,ax			; keep copy
		bndck	150,-150
		cmp	ax,bx			; are they equal?
		jz	nasmal			; nice and small

		cwd
		sar	dx,1
		rcr	ax,1
		sar	dx,1
		rcr	ax,1
		sar	dx,1
		rcr	ax,1
		sar	dx,1
		rcr	ax,1
	;	xor	ax,ax
	;	xor	dx,dx
		mov	ctydoth,ax
		mov	ctydotl,dx
		jmp	short ruddr

	nasmal:
		mov	ax,topv
		mov	dx,topv+2
		mov	cl,4
		sal	dx,cl
		call	atn2
		bndck	150,-150
		cwd
		xchg	ax,dx
		mov	bx,16
		rept	4
		sar	dx,1
		rcr	ax,1
		endm
	bypass:
		xor	ax,ax
		xor	dx,dx
		mov	ctydoth,dx
		mov	ctydotl,ax

	ruddr:	
		mov	cx,200h			; set up proper scale factor
		mov	al,2ch			; get rudder key values
		call	scalekey
		mov	di,ax
		mov	al,2dh
		call	scalekey
		neg	ax			; sum them
		add	di,ax
		mov	al,47h			; get rudder key values
		call	scalekey
		add	di,ax
		mov	al,49h
		call	scalekey
		neg	ax			; sum them
		add	di,ax
		mov	dx,di			; put into correct register

	;	mov	dx,0			; assume rudder is zero
	;	mov	al,2ch
	;	call	getkbit			; get status of z key
	;	or	al,al
	;	jz	l0001			; left rudder?
	;	mov	dx,1ffh			; yes!
	;l0001:	mov	al,2dh			; check for right rudder
	;	call	getkbit
	;	or	al,al
	;	jz	l0002			; right rudder?
	;	sub	dx,1ffh			; yes!
	;l0002:
		mov	rdrang,dx		; save rudder position for tick
						; now calculate yaw angle change
		mov	bx,yawsf		; apply scale factor
		cmp	groundflag,0		; if on ground, make rudder do more
		jz	normrudder
		cmp	topv,1500		; but only on speeds < 50mph
		ja	normrudder
		sal	bx,1
		sal	bx,1
	normrudder:
		mov	ax,vpxp			; get forward limited velocity
		imul	dx			; speed times stick position
		.muls_dw bx,cx			; leave in double int format
		sub	ax,yawdotl		; make exponential fall off
		sbb	dx,yawdoth
		add	ax,ctydotl
		adc	dx,ctydoth
	;	jmp	short bpsidw		; bypass side wind
		push	dx			; now add in effect of side wind
		push	ax
		mov	ax,sidef
		neg	ax			; reverse sign for weathercock eff
		mov	dx,1053
		imul	dx
		pop	bx
		add	ax,bx
		pop	bx
		adc	dx,bx
	bpsidw:	mov	bx,yawmi		; now include moment of inertia
		call	divrs_dw
		add	yawdotl,ax		; update yawdot
		adc	yawdoth,dx
		mov	bx,yawdam
		or	bx,bx			; zero damage?
		jz	noyawdam
		mov	ax,yawdam
	;	wtadj
		cwd
		xchg	ax,dx
		sar	dx,1
		rcr	ax,1
		sar	dx,1
		rcr	ax,1
		sar	dx,1
		rcr	ax,1
						; reduce yaw damage effect with
						; airspeed
		mov	bx,vpxp
		.muls_dw	bx,cx		; mult by vpxp squared
		mov	bx,300
		call	divs_dw			; divide by max vpxp allowed
		add	yawdotl,ax
		adc	yawdoth,dx
	noyawdam:

						; now but in turning correction
						; for auto-ruddering turns
		hmul	sssin,sscos		; get angular info
		hmul	dx,3859		; scale factor involving g, pi, etc
		xor	ax,ax
		mov	bx,ctopv		; get xvelocity
		cmp	bx,30			; don't carry to extreme low speed
		jl	tooslow
		neg	bx			; get the sign right!
		call	divrs_dw			;
		add	yawdotl,ax
		adc	yawdoth,dx		; add to the angular stuff
	tooslow:
		mov	dx,yang
		mov	ax,rhotop		; decrease with air pressure
		imul	dx
		mov	bx,rho0			; rho/rho0
		idiv	bx

						; now calculate pitch angle change

		mov	dx,vpxp			; get forward limited velocity
		imul	dx			; speed times stick position

						; now calculate pitch angle change
		mov	bx,pitsf		; apply scale factor
		.muls_dw bx,cx			; leave in double int format
		sub	ax,pitdotl		; make exponential fall off
		sbb	dx,pitdoth
		mov	bx,pitmi		; now include moment of inertia
		call	divrs_dw
		add	pitdotl,ax		; update pitdot
		adc	pitdoth,dx

IF simpflag
		cmp	aeroflag,0
		jz	nonoselift
	cmp	qstald,0
	jnz	nonoselift		; if stalled, don't bother
		call	pitchlock
nonoselift:
ENDIF

		cmp	autoflag,0		; is autopilot engaged?
		jz	noauto
		call	pitchlock		; make sure angle is close to correct
		jc	noauto			; abort if pitch isn't locked yet
		mov	ax,topv+4		; now check on delta-zvel
		sub	ax,oldzvel
		bndck	150,-150
		mov	dx,ax				; now shift into position
		sar	dx,1
		rcr	ax,1
		sar	dx,1
		rcr	ax,1
		sar	dx,1
		rcr	ax,1
		mov	bx,dx
		mov	cx,ax
		push	bx
		mov	ax,rtopv+4		; look at roll
		neg	ax			; reverse feedbag
		bndck	50,-50			; set maximum auto pilot adjrate
		or	ax,ax
		mov	bx,ax
		jns	sgnfix
		neg	ax
	sgnfix:	imul	bx	
		mov	bx,20
		imul	bx
	;	idiv	bx				; scale 0-100**2 into 0-25
	;	mov	dx,ax				; now shift into position
	;	sar	dx,1
	;	rcr	ax,1
	;	sar	dx,1
	;	rcr	ax,1
		pop	bx
		add	ax,cx
		adc	dx,bx
		add	pitdotl,ax
		adc	pitdoth,dx		; apply to pitch
		call	dohlock			; do code for altitude locking
		mov	ax,topv+4
		mov	oldzvel,ax
	noauto:

		cmp	groundflag,0		; are we wheeling about?
		jz	inair2
		mov	ax,topv			; get xvel
		.abs_w	ax
		cmp	ax,2821
		ja	control
					; remove control of user below this vel
	stillrol:
		mov	ax,orveceff+2
		sub	ax,pitchmin
		cwd
		mov	dl,ah
		mov	ah,al
		dwtadj			; adjust for different machine speeds
		add	pitdotl,ax	; so there!
		adc	pitdoth,dx
		jmp	sothere
	inair2:	jmp	inair
	control:
		sub	ax,2821			; subtract some velocity
		neg	ax
		cwd
		sal	ax,1
		rcl	dx,1
		sal	ax,1
		rcl	dx,1
		sal	ax,1
		rcl	dx,1
		sal	ax,1
		rcl	dx,1
		sal	ax,1
		rcl	dx,1
	;	xor	al,al
	;	mov	ah,dl
	;	mov	dl,dh
	;	xor	dh,dh			; divide by 256
	;	.neg_d	dx,ax			; add negative to pitdot
		add	pitdotl,ax
		adc	pitdoth,dx
	sothere:
		mov	ax,orveceff+2		; check that pitch isn't too high
		cmp	ax,pitchmin		
		jge	ckpittloo
		mov	ax,pitdoth
		or	ax,ax
		js	inair		; don't bounce pitdot if in correct direction
		mov	ax,pitdotl		; bounce it off the ground
		mov	dx,pitdoth
		add	ax,1000
		adc	dx,0
	bouncepit:
		.neg_d	dx,ax
		sar	dx,1		; divide bounce by two
		rcr	ax,1
		mov	pitdotl,ax
		mov	pitdoth,dx
	ckpittloo:
		or	ax,ax		; is pitch less than zero
		js	inair
		mov	ax,pitdoth
		or	ax,ax
		jns	inair		; don't bounce pitdot if in correct direction
		mov	ax,pitdotl		; bounce it off the ground
		mov	dx,pitdoth
		add	ax,-1000
		adc	dx,-1
		jmp	bouncepit	; if so, reverse it

	inair:
		cmp	groundflag,0
		jnz	nonosedrop		; ignore the following if on ground

		cmp	qstald,0		; are we stalled?
		jz	nonosedrop		; no, then leave nose alone
		mov	ax,topv+4		; get zvel
		cwd				; convert to double
		rept	7
		sal	ax,1
		rcl	dx,1
		endm
		add	pitdotl,ax
		adc	pitdoth,dx
	nonosedrop:

		cmp	groundflag,0
		jnz	nstp1			; ignore the following if on ground

		mov	ax,thstal		; get stall angle
		mov	dx,58000
		mul	dx			; a little less than stall angle
		mov	ax,rhotop		; decrease with air pressure
		mul	dx
		mov	bx,rho0			; rho/rho0
		div	bx
		mov	almthstald,ax		; save in variable

		cmp	qstald,0		; are we stalled?
	nstp1:	jnz	nostallprt		; no, then leave nose alone

		mov	ax,alpha		; get angle of attack
		add	ax,ax			; double it
		sub	ax,oldalpha		; get projected future alpha
		.abs_w	ax			; take abs val
		mov	bx,ax			; save pristene copy
		cmp	stallprotflag,0		; did we have to protect last frame?
		jz	nolastime		; we must check it out then!
		mov	dx,pitdoth		; look at our present thrdot
		.abs_w	dx
		sub	dx,mopitdoth		; look at the previous thrdot mag
		jns	stallprt		; then you probably need us
		jmp	nostallprt		; or then again, maybe you don't
	nolastime:
		cmp	ax,almthstald		; compare to the almost stalled value
		jb	nostallprt		; looks like we are in no danger of
						; a stall
	stallprt:
		call	flashstall		; flash stall button
		mov	stallprotflag,1		; say we did
		mov	ax,pitdotl		; get attempted pitdot
		mov	dx,pitdoth
		call	divrs_dw		; divide by angles
		mov	bx,almthstald		; get stalling angle
		.muls_dw	bx,cx		; multiply it out
		mov	pitdotl,ax
		mov	pitdoth,dx
		mov	ax,dx			; now save magnitude in variable
		.abs_w	ax
		mov	mopitdoth,ax		; for comparison next time
		jmp	pitok			; we are done for now!

	nostallprt:
		mov	stallprotflag,0		; say we didn't
	pitok:

	;	cmp	crshlndflag,0		; have we crash landed?
	;	jnz	stabfine			; no, forget it
	;	mov	ax,crshvel		; scale down stablity with vel
	;	shr	ax,1
	;	shr	ax,1
	;	mov	stabdam,ax		; make some stability damage

		mov	ax,stabdam		; check for stability damage
		or	ax,ax
		jz	stabfine

		mov	dx,vpxp			; reduce stab damage by airspeed
		imul	dx
		mov	bx,300
		idiv	bx			; to make landing not impossible
		.abs_w	ax
		add	ax,2			; avoid negative roll over

		mov	bx,ax			; prepare for random attacks
		call	randr_w			; get noise for pitch
		mov	dx,bx
		shr	dx,1
		sub	ax,dx			; make it symmetric
		add	pitdoth,ax
		call	randr_w			; get noise for pitch
		mov	dx,bx
		shr	dx,1
		sub	ax,dx			; make it symmetric
		add	yawdoth,ax
		call	randr_w			; get noise for pitch
		mov	dx,bx
		shr	dx,1
		sub	ax,dx			; make it symmetric
		add	thrdoth,ax

	stabfine:



		mov	ax,pitdoth		; prepare for subroutine call
		bndck	3000,-3000
		mov	pitdoth,ax
		neg	ax
		wtadj
		mov	bx,ax
		mov	ax,yawdoth
		bndck	3000,-3000
		mov	yawdoth,ax
		wtadj
		mov	cx,ax
		mov	ax,thrdoth		; load the roll speed into ax
		bndck	3000,-3000
		mov	thrdoth,ax
		wtadj
		mov	si,offset @dataseg:zmat
		call	rolpln

		cmp	ejectflag,0		; ejected?
		jz	use5dang
		jmp	forgetuse5d

	use5dang:
		mov	bx,offset @dataseg:zmat
		mov	si,offset @dataseg:orvec
		call	getang

		cmp	groundflag,0		; if on ground, but not runway, shake
						; plane about
		jz	forgetuse5d
		cmp	onrunwayflag,0
		jnz	forgetuse5d		; if on runway, looks good
		mov	bx,201
		call	randr_w
		sub	ax,100
		add	orvec+4,ax		; cause some trouble
		mov	bx,241
		call	randr_w
		sub	ax,240/2
		add	orvec+2,ax		; cause some trouble
		jmp	imtired			; jump over ejected code

	forgetuse5d:
		mov	bx,offset @dataseg:zmat
		mov	si,offset @dataseg:obj5d+12
		call	getang

	imtired:
						; this code changes some constants
						; if the flaps are on

		cmp	flapflag,0
		jz	noflapson
		mov	ax,efthstal
		mov	thstal,ax
		mov	ax,efthstl2
		mov	thstl2,ax
		jmp	whocareflap
	noflapson:
		mov	ax,ethstal
		mov	thstal,ax
		mov	ax,ethstl2
		mov	thstl2,ax
	whocareflap:
		mov	thrtsf,ethrtsf		; assume in nice plane
		mov	mdsclr1,0ch		; red air ball
		test	obj5dbits,1000h		; are we in a dumpy plane?
		jz	goniceplane
		mov	mdsclr1,09h		; blue air ball
		mov	thrtsf,edthrtsf		; lower horsepower in dumpy plane
	goniceplane:

		mov	di,offset @dataseg:topv
		mov	bx,offset @dataseg:nzmat
		mov	si,offset @dataseg:rtopv
		call	matvmul
		mov	cl,4
		mov	ax,topv
		sar	ax,cl
		mov	ctopv,ax
	;	jns	signok
	;	mov	cecode,15
	;	jmp	donep33
	;signok:
		mov	ax,topv+2
		sar	ax,cl
		mov	ctopv+2,ax
		mov	ax,topv+4
		sar	ax,cl
		mov	ctopv+4,ax


		mov	si,offset @dataseg:nzmat	; basic rotation matrix

		mov	ax,grvsf
		mov	bx,ax
		mov	ax,[si+4]
		imul	bx
		mov	dvel,ax
		mov	dvel+2,dx		; add to veloctity

		mov	ax,[si+10]
		mov	sssin,ax		; save this quanity
		imul	bx
		mov	dvel+4,ax
		mov	dvel+6,dx		; add to veloctity

		mov	ax,[si+16]
		mov	sscos,ax		; save this too
		imul	bx
		mov	dvel+8,ax
		mov	dvel+10,dx		; add to veloctity

		mov	ax,[si+16]
		sar	ax,1
		.abs_w	ax
		cmp	ax,13000
		jb	noinverted
		mov	ax,[si+16]
		xor	ax,lastroll
		jns	noinverted
		mov	ax,[si+16]
		mov	lastroll,ax		; save for next time
		inc	rollprog
	noinverted:
		mov	thrtmult,0		; default is 0.0 multiplier
		mov	bx,rho0
		sub	bx,rho02
		mov	ax,rhotop
		sub	ax,bx
		js	toohigh
		mov	thrtmult,-1		; default is .999999 multiplier
		cmp	ax,rho02
		ja	toohigh			; too low?
		neg	ax			; now is 0 to -rho0/2
		mov	bx,rho02
		add	ax,bx
		mov	bx,20383		; scale into -4000 to 16383
		mul	bx
		mov	bx,rho02
		div	bx
		sub	ax,4000
		call	cos
		mov	thrtmult,ax		; leave factor in ax
	toohigh:
						; now calculate thrust
		mov	ax,rpm			; get rpm
		sub	ax,20			; 0 thrust at idle
		mov	dx,thrtsf
		mul	dx
		mov	bx,rpmx
		call	divrs_dw
IF qrocket
		cmp	rocketflag,0
		jz	norocket
		mov	ax,5			; drain away rockets quickly
		wtadj
		sub	rockettick,ax
		jns	notempty
		xor	ax,ax
		mov	rocketflag,al
		mov	rockettick,ax
notempty:
		add	ax,3*ethrtsf		; boost engine power by 3
norocket:
ENDIF
		cwd				; boost up by 65536
		xchg	ax,dx

		mov	ax,thrtmult		; degrade engine performance at alt.
		mul	dx
	;	cwd
	;	xchg	ax,dx

		mov	bx,ctopv		; check for low velocity
		cmp	bx,vstal2
		jns	anstal			; not low speed stalled
		mov	bx,vstal2		; replace speed with stall speed
	anstal:	call	divrs_dw			; divide by the speed
		mov	bx,nticks
		.muls_dw bx,cx
		add	dvel,ax
		adc	dvel+2,dx		; increase the speed


						; calculate the drag
		mov	dx,ozeff+2			; get the altidude
		mov	ax,ozeff
		mov	al,ah			; divide by 256
		mov	ah,dl
		mov	dx,rho0z		; make into air pressure variable
		or	ax,ax			; set flags!
		jns	lkjfla			; verfify positive air pressure
		xor	ax,ax
	lkjfla:
		sub	dx,ax
		jns	presok1
		xor	dx,dx
presok1:
		mov	ax,rho0			; scale airpress into 0-rho0
		mul	dx
		mov	cx,rho0z		; by multiplying by rho0/rho0z
		div	cx
		mov	dx,ax			; put in correct register
		mov	rhotop,dx		; save in variable for lift calcs
		mov	cl,4			; divide by 16
		sar	dx,cl
		push	dx
		mov	ax,ctopv 		; look at current x velocity
		mov	bx,idsf			; to determine if we are in the
		cmp	ax,dvspd		; the transonic range of velocity
		js	spdok
		mov	bx,oidsf
	spdok:	mov	ridsf,bx
		mov	dx,ax			; sqaure the veloctiy
		or	ax,ax			; check the sign of the velocity
		jns	vposit			; 
		neg	ax
	vposit:
		imul	dx
		pop	bx			; 
		.muls_dw bx,cx
		mov	bx,ridsf		; get the drag coeff
		cmp	flapflag,0		; are the flaps up?
		jz	noflap2
		sar	bx,1			; divide ridsf by 2 to incr drag
		sar	bx,1			; divide ridsf by 4 to incr drag
	noflap2:
		call	divrs_dw
		mov	bx,nticks
		neg	bx			; apply in negative direction
		.muls_dw bx,cx
		add	dvel,ax
		adc	dvel+2,dx


						; check sideways drag
		mov	dx,rhotop		; get air pressure
		mov	cl,4			; divide by 16
		sar	dx,cl
		push	dx
		mov	ax,ctopv+2 		; look at current y velocity
		mov	bx,idsf			; to determine if we are in the
		cmp	ax,dvspd		; the transonic range of velocity
		js	spkdok
		mov	bx,oisdsf
	spkdok:	mov	risdsf,bx
		mov	dx,ax			; sqaure the veloctiy
		or	ax,ax			; check the sign of the velocity
		jns	vpost			; 
		neg	ax
	vpost:
		imul	dx
		pop	bx			; 
		.muls_dw bx,cx
		mov	bx,risdsf		; get the drag coeff
		call	divrs_dw
		mov	bx,nticks
		neg	bx			; apply in negative direction
		.muls_dw bx,cx
		add	dvel+4,ax
		adc	dvel+6,dx
		push	dx
		push	ax			; now get lower part saved for yaw
		.abs_d	dx,ax			; take absoulute value
		rcl	ax,1			; look at sign bit
		pop	ax
		pop	dx
		jnc	ntofst			; in of bounds
		mov	ax,dx			; apply sign to word
		cwd
		mov	ax,dx			; put into ax
		xor	ax,07fffh		; make into +- infinity
	
	ntofst:	
		mov	sidef,ax		; in bounds

		cmp	groundflag,0		; are we on ground?
		jz	inair1
		xor	ax,ax
		mov	dvel+4,ax
		mov	dvel+6,ax		; no sideways mothion
		mov	topv+2,ax		; zero out current side motion
		mov	sidef,ax
	inair1:



						; calculate lift
		mov	ax,alpha		; save old alpha for stall prevention
		mov	oldalpha,ax		; calculations
		mov	ax,topv 		; get xveloctiy
		mov	dx,topv+4		; get z vel
		call	atn2			; determine angle of attack
		mov	alpha,ax		; save angle of attack
		mov	bx,stlfsf		; assume stalled
		mov	qstald,-1		; assume stalled
		add	ax,thstal
		js	lstald
		cmp	ax,thstl2		; is wing stalled?
		jns	lstald
		mov	bx,lfsf			; no, wing is fine
		cmp	flapflag,0		; are the flaps up?
		jz	noflap1
	;	mov	dx,bx
	;	sar	dx,1
	;	sar	dx,1
	;	sub	bx,dx			; decrease lfsf by 3/4 to increase lift
		sar	bx,1			; by 2 to increase lift by two
	noflap1:
		mov	qstald,0
	;	cmp	oldqstald,0
	;	jz	lstald1			; don't bother to write unless change
		.push	ax,bx
IF soundflag EQ 0
		mov	bl,5			; sound alarm
		mov	ax,200h
		call	voiceoff
ENDIF
		mov	ax,070eh		; light up the stall idiot light
		mov	bx,3
		call	drawbutton
		mov	ax,000ch		; light up the stall idiot light
		mov	bx,3
		call	drawbutton
		.pop	ax,bx
		jmp	lstald1
	lstald:	
	;	cmp	oldqstald,0
	;	jnz	lstald1			; don't bother to write unless change
		cmp	groundflag,0		; are we on ground?
		jnz	lstald1			; don't bother if on ground
IF soundflag EQ 0
		.push	ax,bx
		mov	bl,5			; sound alarm
		mov	ax,180h
		call	voiceon
		mov	ax,0e07h		; light up the stall idiot light
		mov	bx,3
		call	drawbutton
		mov	ax,0c00h		; light up the stall idiot light
		mov	bx,3
		call	drawbutton
		.pop	ax,bx
ENDIF
	lstald1:
	;	mov	ax,qstald		; save old stalled info
	;	mov	oldqstald,ax
		push	bx
		mov	ax,topv+4	; get z velocity
		mov	dx,ax
		or	ax,ax
		js	lkjiem		; check for negative
		imul	dx
		.neg_d	dx,ax
		jmp	lkjiem1
	lkjiem:
		imul	dx
	lkjiem1:
		mov	bx,16
		call	divrs_dw 
		pop	bx
		call	divrs_dw
		mov	bx, rhotop		; get pressure
		.muls_dw bx,cx
		mov	bx,nticks
		.muls_dw	bx,cx
		add	dvel+8,ax
		adc	dvel+10,dx
						; now apply delta-v to topv
						; and then rotate back to
						; the rtopv coords
		mov	dx,dvel+2
		mov	ax,dvel
;		mov	xtemp,dx
		dwtadj
		mov	ytemp,dx
		add	topv,dx
		mov	acctop,dx		; keep track of the acceleration

		mov	dx,dvel+6
		mov	ax,dvel+4
		dwtadj
		mov	ax,topv+2
		mov	acctop+2,dx		; keep track of the acceleration
		or	dx,dx
		jnz	sideslipfix1
		mov	bx,ax
		.abs_w	bx
		cmp	bx,200
		ja	sideslipfix1
		mov	ax,0
	sideslipfix1:
		add	ax,dx
		bndck	9500,-9500
		mov	topv+2,ax
	
		mov	dx,dvel+10
		mov	ax,dvel+8
		dwtadj
		mov	acctop+4,dx		; keep track of the acceleration
		mov	y1temp,ax
		mov	ax,topv+4
		add	ax,dx
		bndck	9600,-9600
		mov	topv+4,ax


		mov	si,offset @dataseg:acctop
		mov	bx,offset @dataseg:nnzmat
		mov	di,offset @dataseg:racctop
		call	matvmul

		mov	si,offset @dataseg:topv
		mov	bx,offset @dataseg:nnzmat
		mov	di,offset @dataseg:rtopv
		call	matvmul


		cmp	crshlndflag,0		; have we crash landed?
		jz	crshland2
		mov	ax,brdrcnt
		add	brdrcnt,2		; keep it shakin'
		xor	ax,ax		; clear zvelocity
		mov	rtopv+4,ax
		mov	ax,rtopv	; attenuate both x and y velocity
		mov	bx,30000
		imul	bx
		sal	dx,1
		mov	rtopv,dx
		mov	cx,dx
		mov	ax,rtopv+2	; attenuate both x and y velocity
		imul	bx
		sal	dx,1
		mov	rtopv+2,dx
		.abs_w	cx
		.abs_w	dx
		add	dx,cx
		mov	crshvel,dx
		cmp	dx,200
		ja	crshland2	; no
IF soundflag EQ 0
				; turn off scrape noise
	mov	al,20h
	mov	bl,0bdh
	call	adlwrt
ENDIF

		mov	brdrcnt,0	; stop the plane from shaking
		mov	freezeflag,-1	; stop motion of plane
		mov	currpmx,0	; kill throttle possibilities
		cmp	ejectflag,0	; if pilot ejected, don't freeze
		jz	crshland2
		stc			; mark plane as destroyed
		call	funeral5d	; switch objects from a 5d to a 5da
	crshland2:


		mov	dx,ozeff+2		; let's check for a low plane
		mov	ax,ozeff
		sub	ax,zground		; calculate (oz-zground)
		sbb	dx,zground+2
		jns	noinstcrash
		mov	crshflg,4
		jmp	instacrash
	;	js	instacrash		; if below ground, kill us now!
	noinstcrash:
		sub	ax,hlow
		sbb	dx,0
		sub	ax,hmin
		sbb	dx,0
		jns	planeishigh
		call	findheight
		jnc	planefine
	instacrash:
		cmp	ejectflag,0
		jnz	o5dcrash
		or	crshflg,1		; crash us bad
	planefine:
		call	dolandinggear
		jnc	planeabove
		cmp	ejectflag,0	; are we in plane?
		jz	yescrash
	o5dcrash:
		mov	crshflg,0
		test	obj5dbits,100h
		jnz	skip5bits
		inc	nplaneslost		; we definately lost a plane
		mov	al,homeflag		; merge homeflag with crashflag
		shl	al,1			; if only 1, then atleast shift bit up
		and	al,2
		mov	ah,1
		or	obj5dbits,ax
	skip5bits:
		mov	si,offset @dataseg:obj5d
		stc
		call	odest		; destroy plane
		mov	currpmx,0
		jmp	planeabove
	planeishigh:
		cmp	homeflag,0
		jnz	planestillnear
		and	missionstatus,NOT 4
planestillnear:
		mov	groundflag,0		; don't say we are on the ground
		jmp	planeabove

	yescrash:
		mov	crshflg,2
	planeabove:

		call	qcrashland	; set up stuff for crshlnding if so
		call	qhomebase	; set flag if we have passed over home base
		mov	cx,4
	flashdamloop:
		push	cx
		mov	bx,cx		; index = damage indicator 0-3
		dec	bx		; but index-1 !
		call	flashdamage	; flash any damage indicators which need it
		pop	cx
		loop	flashdamloop
		cmp	totaldamage,50
		jb	flyingplane
		call	flasheject
	flyingplane:
	freeze4:
		cmp	ejectflag,0		; have we bailed?
		jz	yesoxchange
		jmp	nooxchange
	yesoxchange:
		cmp	freezeflag,0
		jnz	nomoveme
		call	moveme			; apply velocity rtopv to ox,oy,oz
	nomoveme:
		call	qhomebase		; do home base stuff here if frozen
		mov	si,offset @dataseg:obj5d
	;	mov	ax,[si+62]
	;	mov	objdamp,ax
	;	mov	ax,[si+60]
	;	mov	objdisp,ax
	;	mov	ax,[si+64]
	;	mov	tckgrav,ax
	;	call	objmov
		jmp	oxchanged
	nooxchange:
		cmp	standingflag,0		; if we were standing but now were not!
		jz	nojumpcharge		; can't jump if we aren't standing
		mov	al,24h	; scan code for 'j' key to charge up a jump
		call	getkbit
		jz	nojumpcharge
		mov	jumpflag,-1		; show we are charging up for a jump
		call	jumpadd			; ever fill out a jump/add slip?
		jmp	nojumpatall		; play it cool
	nojumpcharge:
		cmp	jumpflag,0		; were we jumping before?
		jz	nojumpatall		; forget it if we hadn't been charging
		mov	jumpflag,0		; clear jumpflag, now that it is read
		call	jumpadd			; ever fill out a jump/add slip?
		mov	ax,jumpvalue		; so how high did we want to jump?
		mov	jumpvalue,0		; start all over again
		or	ax,ax
		jz	nojumpatall		; if no jump, no jump
		shl	ax,1
		shl	ax,1			; jump a little higher
		mov	otopv+4,ax		; give'em some jumpiness
		mov	pullstrflag,0
		mov	chutedamp,31000
		mov	termvel,freetermvel
		jmp	cripcrap		; let's jump right up into the air!
	nojumpatall:
		mov	al,12h	; scan code for 'e' key to drop through surface
		call	getkbit
		jz	cripcrap1	; whoa!
		xor	ax,ax
		mov	myzground,ax
		mov	myzground+2,ax
		jmp	cripcrap
	cripcrap1:
		mov	dx,oz+2
		mov	ax,oz
		sub	ax,ehmin
		sbb	dx,0
		sub	ax,myzground		; are we on the ground?
		sbb	dx,myzground+2
		js	onground1
		or	ax,dx
		jz	onground1
		jmp	cripcrap
	onground1:
		jmp	notoohard		; stop if we are on the ground
	cripcrap:
		mov	standingflag,0		; if we were standing but now were not!
		mov	cl,4			; divide all velocities by 16
						; before applying to coords	
		mov	ax,otopv
		sar	ax,cl
		cwd
		dwtadj
		add	ox,ax
		adc	ox+2,dx
		mov	ax,otopv+2
		sar	ax,cl
		cwd
		dwtadj
		add	oy,ax
		adc	oy+2,dx
		mov	ax,otopv+4
		sar	ax,cl
		cwd
		dwtadj
		add	oz,ax
		adc	oz+2,dx

		mov	ax,freefallgrav
		cmp	pullstrflag,0		; has the string been pulled?
		jz	nostring1
		mov	chutedamp,30000
		mov	termvel,chutetermvel
		mov	ax,freefallgrav
	nostring1:
		wtadj				; scale with machine speed
		sub	otopv+4,ax
	nogravity:
		cmp	standingflag,0
		jnz	notoohard	; clear the standingflag
		call	dampchute
		mov	dx,oz+2		; let's check for a low plane
		mov	ax,oz
		sub	ax,myzground
		sbb	dx,myzground+2
		sub	ax,hmin
		sbb	dx,0
		jns	aboveground
		mov	ax,otopv+4
		neg	ax
		cmp	ax,2*chutetermvel	; twice the chute terminal velocity
		jb	notoohard
		cmp	pullstrflag,0		; if string not pulled, use less
						; stringent algorithm
		jnz	nolessstrg
		cmp	ax,freetermvel*2/3	; were they near terminal velocity?
		jb	notoohard		; we can only hope....
	nolessstrg:
		cmp	invincible,0
		jnz	notoohard		; don't let the invinc man die.
		mov	crshflg,3	; uh, oh, we died
		jmp	aboveground
	notoohard:
		xor	ax,ax
		mov	swingcount,ax	; stop swinging
		mov	otopv+4,ax
		mov	dx,ax
		mov	ax,hmin
		add	ax,myzground
		adc	dx,myzground+2	; add in offset of whatever object we are on
		mov	oz+2,dx
		mov	oz,ax			; put just under the surface
		mov	standingflag,-1
		jmp	onground		; don't apply next stuff to us
	aboveground:
	onground:

		mov	ax,obj5d+10
		or	ax,ax
		jns	d5alive
		jmp	oxchanged		; if plane already crashed, don;t move
	d5alive:

		cmp	freezeflag,0
		jnz	dontmoveasshole

						; apply velocity vector to 
		cmp	currpmx,0
		jnz	crapper
	dontmoveasshole:
		jmp	oxchanged		; SKIP if crashlanded
	crapper:				; ovec coords

		mov	cl,4			; divide all velocities by 16
						; before applying to coords	
		mov	ax,rtopv
		sar	ax,cl
		cwd
		dwtadj
		mov	si,offset @dataseg:obj5d
	;	mov	bx,[si+10]
	;	or	bx,[si+8]
	;	jz	oxchanged
		add	obj5d,ax
		adc	obj5d+2,dx
		mov	ax,rtopv+2
		sar	ax,cl
		cwd
		dwtadj
		add	obj5d+4,ax
		adc	obj5d+6,dx
		mov	ax,rtopv+4
		sar	ax,cl
		cwd
		dwtadj
		add	obj5d+8,ax
		adc	obj5d+10,dx
		jns	oxchanged
		mov	si,offset @dataseg:obj5d
		stc
		call	odest
	oxchanged:
		cmp	pullstrflag,0		; has the string been pulled?
		jz	nostring
		js	nostring
		mov	swingcount,swingmx+8	; how long to swing in the breeze
		mov	pullstrflag,-1		; then free up angles
	nostring:
		cmp	crshlndflag,0
		jz	freeze4a
		mov	ax,40h			; default is lousy crshlnd bit
		cmp	homeflag,0		; are we at home?
		jz	yourcrapped
		mov	ax,200h			; nice crashland bit
	yourcrapped:
		or	missionstatus,ax	; set crashland bit

	freeze4a:
		mov	al,0
		cmp	homeflag,0
		jz	homempty
		test	cs:oticks,1024
		jz	homempty
		mov	al,15
	homempty:
		mov	clrtwr,al		; set color of home base blinking


		mov	al,clrf1		; echange red and yellow flame color
		xchg	al,clrf2
		mov	clrf1,al
		mov	al,clrd1		; echange red and yellow flame color
		xchg	al,clrd2
		mov	clrd1,al
		mov	al,clrd3		; echange red and yellow flame color
		xchg	al,clrd4
		mov	clrd3,al

		mov	bx,15
		call	randr_w
		mov	clrhq,al		; give headquarters a random color	


		mov	si,offset @dataseg:sdsph1
		mov	di,offset @dataseg:sdsph
		add	si,2
		add	di,2
		mov	cx,16
		mov	bx,l*5
	sdszlp:	
		rept	4
		call	randr_w
		add	ax,[si]
		mov	[di],ax
		add	si,2
		add	di,2
		endm
		add	bx,(2*pl)/16
		add	si,2
		add	di,2
		loop	sdszlp

		mov	si,offset @dataseg:smsph1
		mov	di,offset @dataseg:smsph
		add	si,2
		add	di,2
		mov	cx,16
		mov	bx,l
	smszlp:	
		rept	4
		call	randr_w
		add	ax,2*l
		add	ax,[si]
		mov	[di],ax
		add	si,2
		add	di,2
		endm
		add	bx,(2*l)/16
		add	si,2
		add	di,2
		loop	smszlp

		mov	si,offset @dataseg:flsmph1
		mov	di,offset @dataseg:flsmph
		add	si,2
		add	di,2
		mov	cx,3
		mov	bx,500
	fmszlp:	
		rept	4
		call	randr_w
		add	ax,2*500
		add	ax,[si]
		mov	[di],ax
		add	si,2
		add	di,2
		endm
		add	bx,(2*500)/16
		add	si,2
		add	di,2
		loop	fmszlp


		mov	bx,offset @dataseg:rvec
		call	calcsin
		mov	si,offset @dataseg:rmat
		call	calcmat
		cmp	ejectflag,0
		jnz	hardbargain1
		jmp	hardbargain
	hardbargain1:
		mov	bx,offset @dataseg:obj5d+12
		call	calcsin
		mov	si,offset @dataseg:nzmat
		call	calcmat
		mov	si,offset @dataseg:nnzmat
		call	ncalcmat
		mov	bx,offset @dataseg:orvec
		call	calcsin
		mov	si,offset @dataseg:orot
		call	calcmat
		mov	si,offset @dataseg:norot
		call	ncalcmat
		mov	si,offset @dataseg:obj5d	; xfer coords from plane to eff
		mov	di,offset @dataseg:oxeff
		mov	ax,ds
		mov	es,ax
		cld
		mov	cx,6
		rep	movsw
		mov	si,offset @dataseg:obj5d+12	; xfer coords from plane to eff
		mov	di,offset @dataseg:orveceff
		mov	cx,3
		rep	movsw				; update effective coords


IF nodemo EQ 0
	IF demorec
		cmp	demoflag,-1
		jz	skipslam
		call	updatedemo		; continue to update demo even after ej

	cmp	ejectflag,0
	jnz	skipxfer
	mov	si,offset @dataseg:ox
	mov	di,offset @dataseg:oxeff
	mov	cx,6
	rep	movsw				; update effective coords
skipxfer:

		jmp	skipslam1
	demoerr1c:
IF demorec
		jmp	demoerr1b
ENDIF
	stoprd1:
IF demorec
		jmp	stopdemoread
ENDIF
	skipslam:
			mov	si,offset @dataseg:kbuf
			mov	cx,1
			mov	bx,fhandl
			call	read_h
			jc	demoerr1c	; handle eek a mouse
			cmp	kbuf,-1
			jz	stoprd1
		test	kbuf,80h
		jnz	comprdok1
		mov	si,offset @dataseg:kbuf+1
		mov	cx,ndemobytes-1
			mov	bx,fhandl
			call	read_h
			jmp	skipslam1a
	comprdok1:
		mov	si,offset @dataseg:kbuf+1
		mov	cx,7
			mov	bx,fhandl
			call	read_h
	skipslam1a:
			mov	al,kbuf
			mov	demobyte,al
	skipslam1:
	ELSE
	cmp	ejectflag,0
	jnz	skipxfer
	mov	si,offset @dataseg:ox
	mov	di,offset @dataseg:oxeff
	mov	cx,6
	rep	movsw				; update effective coords
skipxfer:
	ENDIF
	ELSE
	cmp	ejectflag,0
	jnz	skipxfer
	mov	si,offset @dataseg:ox
	mov	di,offset @dataseg:oxeff
	mov	cx,6
	rep	movsw				; update effective coords
skipxfer:
	ENDIF

		jmp	thatsenough
	hardbargain:

IF nodemo EQ 0
	IF demorec
	;IF 1 EQ 0
		cmp	frmnum,6
		jae	notnodemoread
	nodemoread1:
		jmp	nodemoread
	notnodemoread:
		xor	al,al
		cmp	rundemoflag,al
		jnz	rundemobeg		; if command line requested, run demo
;		cmp	scncode,41h
;		jnz	nodemoread1
		jmp	nodemoread1		; don't allow demo reading
		xor	al,al
		mov	scncode,al
	rundemobeg:
		mov	freezeflag,al
		mov	rundemoflag,al
		cmp	demoflag,al
		jnz	stopdemoread
						; see if running on a way slow computer
		mov	ax,ofrmticks
		cmp	ax,18
		jbe	normalspd
		mov	demorepflag,-1		; set flag for reapeat stuff
	normalspd:
			mov	si,offset @dataseg:demoname
			mov	ax,0102h
			call	open_h
			mov	fhandl,bx
			jnc	demoreadok1
	demoerr1a:
		jmp	demoerr1
	demoreadok1:
		mov	demoflag,-1
		mov	ax,currpmx
		dec	ax		; not quite max!
		mov	rpm,ax
	;	jmp	nodemoread
					; read in start position
			mov	si,offset @dataseg:kbuf
			mov	cx,1
			mov	bx,fhandl
			call	read_h
			jc	demoerr1a	; handle eek a mouse
			call	compactread	; read and see if compacted
			cmp	demobyte,-1	; see if at end of file
			jz	stopdemoread
		call	demofixup
		mov	si,offset @dataseg:ox
		mov	di,offset @dataseg:startcoords
		mov	cx,6
		mov	ax,ds
		mov	es,ax
		rep	movsw		; copy ox to startcoords
		mov	xpflag,1	; and transfer us there
		mov	groundflag,0	; take us off the ground
		jmp	noreaddfrm	; skip over read frame part
	demoerr1b:
		jmp	demoerr1

	stopdemoread:
		mov	demoflag,0
		mov	bx,fhandl
		call	close_h			; close the file
		mov	exitflag,-1		; end the program
	nodemoread:

		cmp	demoflag,-1		; read in a frame of demo if needed
		jnz	noreaddfrm

			mov	si,offset @dataseg:kbuf
			mov	cx,1
			mov	bx,fhandl
			call	read_h
			jc	demoerr1a	; handle eek a mouse
			call	compactread	; read and see if compacted
			cmp	demobyte,-1	; see if at end of file
			jz	stopdemoread
		call	demofixup
		cmp	demorepflag,0		; do we show only everyother frame?
		jz	norepframe
			mov	al,demobyte
			mov	kbuf+40,al
			mov	si,offset @dataseg:kbuf
			mov	cx,1
			mov	bx,fhandl
			call	read_h
			jc	demoerr1b	; handle eek a mouse
			call	compactread	; read and see if compacted
			cmp	demobyte,-1	; see if at end of file
			jz	stopdemoread
		call	demofixup
			mov	al,kbuf+40	; what if bomb or missle req in other 
						; frame which we skipped?
			mov	ah,al
			or	ah,NOT 3
			and	demobyte,ah
			and	al,4+16+32	; bomb, flap, and eject bits
			or	demobyte,al
	norepframe:
	noreaddfrm:
	ENDIF
ENDIF



		mov	bx,offset @dataseg:orvec
		call	calcsin
		mov	si,offset @dataseg:orot
		call	calcmat
		mov	si,offset @dataseg:nzmat
		call	calcmat
		mov	si,offset @dataseg:norot
		call	ncalcmat
		mov	si,offset @dataseg:norot
		mov	di,offset @dataseg:nnzmat	; save zrmat for later exam
		mov	cx,9
		mov	ax,ds
		mov	es,ax
		cld
		rep	movsw

IF nodemo EQ 0
	IF demorec
		call	updatedemo

	ENDIF
ENDIF
	cmp	ejectflag,0
	jnz	skipxfer1
	mov	si,offset @dataseg:ox
	mov	di,offset @dataseg:oxeff
	mov	cx,6
	rep	movsw				; update effective coords
skipxfer1:


		mov	si,offset @dataseg:orvec	; and angles
		mov	di,offset @dataseg:orveceff
		mov	cx,3
		rep	movsw
	
	thatsenough:
		call	dodvelavg


	;	mov	al,16h
	;	call	getkbit
	;	jz	nograiny
	;	xor	al,al
	;	mov	byte ptr orvec,al
	;	mov	byte ptr orvec+2,al
	;	mov	byte ptr orvec+4,al
	;nograiny:


;	mov	dl,0
;	mov	dh,22
;	xor	bx,bx
;	mov	ah,2
;	int	10h		; set cursor location
;	mov	ax,xang
;	call	decwword
;	mov	ax,xtemp
;	call	decwword
;		mov	si,offset @dataseg:spncr
;		call	put_str

IF diagflag EQ 1
		jmp	wrtdn
		mov	ax,bulptr
		call	wword
		mov	si,offset @dataseg:spcr
		call	put_str
		mov	ax,obj5d+18
		call	wword
		mov	si,offset @dataseg:spcr
		call	put_str
		mov	ax,dvel+6
		call	wword
		mov	si,offset @dataseg:spncr
		call	put_str
		mov	ax,dvel+10
		call	wword
		mov	si,offset @dataseg:spncr
		call	put_str

		mov	ax,ctopv
		mov	si,offset @dataseg:kbuf
		call	word_to_dec
		call	put_str
		mov	si,offset @dataseg:spncr
		call	put_str
		mov	ax,ctopv+2
		call	wword
		mov	si,offset @dataseg:spncr
		call	put_str
		mov	ax,ctopv+4
		call	wword
		mov	si,offset @dataseg:spncr
		call	put_str
		mov	ax,alpha
		add	ax,thstal	
		call	wword
		mov	si,offset @dataseg:spncr
		call	put_str
		mov	ax,pitdoth
		call	wword
		mov	si,offset @dataseg:spcr
		call	put_str
		jmp	wrtdn
ENDIF
	wrtdn:

IF slalom
		cmp	readfileflag,0	; see if training mssion
		jnz	doradarstuff
		jmp	doslal
doradarstuff:
		mov	al,scncode
		xor	ah,ah
;		call	put_newline
;		call	wword

		cmp	al,27h+80h
		jnz	noincrdr	; make ';' key plant a bomb
		mov	scncode,0
		inc	radarstat
noincrdr:
		cmp	al,28h+80h
		jnz	nodncrdr	; make ';' key plant a bomb
		mov	scncode,0
		dec	radarstat
nodncrdr:

		mov	al,radarstat
		mov	ah,oldradarstat
		mov	bx,ax
		xor	bl,bh
		jz	nordar
 ;push	ax
 ;call put_newline
 ;xor	ah,ah
 ;call wword
 ;mov al,oldradarstat
 ;xor ah,ah
 ;call wword
 ;pop ax
		mov	bx,ax
		cmp	bl,bh
		js	goingaw
comingcl:
		cmp	bl,1		; see if in warning radius	
		jnz	rdn1
	mov	ax,0107h		; assume it is off, being turned on
	mov	bx,20
	call	drawbutton		; draw the block on the inst panel
	jmp	nordar
rdn1:
		cmp	bl,2		; see if in warning radius	
		jnz	rdn2
	mov	ax,0e01h		; assume it is off, being turned on
	mov	bx,20
	call	drawbutton		; draw the block on the inst panel
	jmp nordar
rdn2:
		cmp	bl,3		; see if in warning radius	
		jnz	nordar
	mov	ax,0c0eh		; assume it is off, being turned on
	mov	bx,20
	call	drawbutton		; draw the block on the inst panel
	jmp nordar
goingaw:
		cmp	bl,0		; see if in warning radius	
		jnz	rdnm0
	mov	ax,0701h		; assume it is off, being turned on
	mov	bx,20
	call	drawbutton		; draw the block on the inst panel
	jmp	nordar
rdnm0:
		cmp	bl,1		; see if in warning radius	
		jnz	rdnm1
	mov	ax,010eh		; assume it is off, being turned on
	mov	bx,20
	call	drawbutton		; draw the block on the inst panel
	jmp nordar
rdnm1:
		cmp	bl,2		; see if in warning radius	
		jnz	nordar
	mov	ax,0e0ch		; assume it is off, being turned on
	mov	bx,20
	call	drawbutton		; draw the block on the inst panel
	jmp nordar

nordar:
		mov	al,radarstat
		mov	oldradarstat,al	; update last radarstat
		jmp	slalomdone
doslal:
		cmp	homeflag,0	; see if we touch down
		jnz	skipgck
		cmp	groundflag,0	; erase slalom if touch grnd
		jz	skipgck
		jmp	resetslal
skipgck:
		mov	dx,oldox+2		; first find which tet
		sar	dx,1			; now tet # is in dx
		mov	ax,oxeff
		mov	bx,oxeff+2		; first find which tet
		or	bx,bx			; are we still x<0?
		js	wrongdir		; if so, forget this
		sar	bx,1			; now tet # is in bx
		mov	ax,bx			; no do comparions
		sub	ax,dx
		js	wrongdir		; going south?
		jz	wrongdir		; haven't passed a boundary

					; ok, now we know we've crossed a
					; boundary headed north
		cmp	bx,5		; see if we are past last marker
		ja	wrongdir	; past the last marker

		mov	ax,slalflag	; see if we are passing over next
					; boundary
		cmp	bx,ax		; are we passing first boundary?
		jnz	resetslal

		mov	dx,oyeff+2	; get the sidewaysness
		sub	dx,2		; translate origin
		test	ax,1		; even or odd?
		jz	ndsneg
		neg	dx
ndsneg:
		or	dx,dx		; did user go on correct side?
		js	resetslal	; guess not!
		

		call	drawslalbut
		cmp	slalflag,5	; are we done?
		jae	slalnd
		inc	slalflag	; advance to next boundary
		jmp	slalomdone

slalnd:
		call	incondest
		jmp	slalomdone
		
resetslal:
		mov	slalflag,0	;
		mov	bx,0
		mov	cx,6
clrsllop:
		push	cx
		push	bx
		call	clrslalbut
		pop	bx
		inc	bx
		pop	cx
		loop	clrsllop
wrongdir:
		jmp	slalomdone

notfirst:

slalomdone:
		mov	ax,oxeff		; update oldox variable
		mov	oldox,ax
		mov	ax,oxeff+2
		mov	oldox+2,ax

ENDIF

		mov	ax,ozeff
		mov	dx,ozeff+2
		cmp	dx,4
		jb	tensoff1
		ja	tenson
		mov	bx,30
		idiv	bx
		cmp	ax,10000
	tensoff1:
		mov	ax,0705h		; light up the stall idiot light
		jb	tensoff
	tenson:
		mov	ax,0507h		; light up the stall idiot light
	tensoff:
		mov	bx,10
		call	drawbutton
	notens:

		mov	ax,ozeff
		mov	dx,ozeff+2
		cmp	dx,9
		jb	twensoff1
		ja	twenson
		mov	bx,30
		idiv	bx
		cmp	ax,20000
	twensoff1:
		mov	ax,0705h		; light up the stall idiot light
		jb	twensoff
	twenson:
		mov	ax,0507h		; light up the stall idiot light
	twensoff:
		mov	bx,11
		call	drawbutton
	notwens:

IF shareflag
		mov	ax,obj5dbits
		and	ax,2000h
		jz	nodumpnow
ENDIF
		mov	ax,starheight
		cmp	oxeff+9,ax		; are we above 30000 ft?
		jl	nodumpnow
IF shareflag
		cmp	aceflag,0		; don't do it if not ace
		jz	nodumpnow
ENDIF
		mov	bhighflag,1		; lose control of plane
		call	flushtiles		; get rid of all the stuff
		call	drawnear	; now let objects really die
		call	erasndles	; kill instuments
		call	flipage
		call	erasndles
;		cli
;		call	reset_ticks		; stop timer from racing, so we
						; don't run into trouble
;		sti
		call	reset9
		call	cleargetkey		; clear the keyboard table
		call	addtoetime		; add elapsed time to variable

		call	runstars	; jump to high altitude stars program
		call	flush_keys		; Kill the escape which occurs
						; at exit time
		call	grab9
		call	tmr_reset		; restart time accounting
;		cli
;		mov	al,6			; set timer mode 3
;		mov	cx,tickdiv		; reload value is much smaller
;		call	set_timer0
;		sti				; reable ints
		mov	exitflag,-1
		or	missionstatus,400h	; sets lost in space flag
		jmp	donep33		; quit
	nodumpnow:
		mov	ax,haluclrs
		or	ax,haluclrs+2
		or	ax,haluclrs+4
		mov	tripflag1,0
		jz	notripping
		inc	tripflag1		; determine if pallete is tripping
	notripping:
		mov	al,23h
		call	getkbit		; have we taken hallucenigens?
		jz	nohalu
		call	takedrugs
	nohalu:
		cmp	ejectflag,0
		jz	howcouldi	; how could I get into a plane I'm flying?
		cmp	exitflag,0
		jnz	howcouldi	; don't get into a plane while we're exiting
		mov	si,offset @dataseg:obj5d
		cmp	word ptr [si+24],0	; is object drawn?
		jz	howcouldi		; no, so get lost
		call	evaldist
		jc	howcouldi
		cmp	ax,4000
		jbe 	havegone1	

	havegone:
		mov	outfromflag,-1	
		jmp	howcouldi

	havegone1:
		cmp	outfromflag,0	; have I gotten out of the plane yet?
		jz	howcouldi
		cmp	ax,2000
		ja	howcouldi
		call	interiorview	; put the inst panel back on
		mov	redamageflag,-1
		cmp	totaldamage,0	; if no damage, then init the indicators
		jnz	somedamage
		mov	redamageflag,0	; start fresh
	somedamage:
IF soundflag EQ 0
	call	snareinit	; turn missle sound abilities back on
	mov	windflag,0	; turnoff wind
ENDIF
		call	damageinit	; rewrite damage indicators
		call	redrawbuts
		mov	si,offset @dataseg:obj5d
		mov	di,offset @dataseg:ox
		mov	cx,9
		mov	ax,ds
		mov	es,ax
		cld
		rep	movsw		; mov us to orientation of the plane
		mov	obj5d+24,0	; remove from table
		mov	ejectflag,0
		mov	stepoutflag,0

	howcouldi:


		cmp	scncode,2fh+80h
		jnz	drawmemlabel
		mov	scncode,0
		cmp	ejectflag,0
		jz	drawmemlabel		; don't bother if still in plane
		cmp	standingflag,0
		jz	drawmemlabel
		cmp	maxnrvs,0
		jnz	drawmemlabel
		cmp	homeflag,0
		jnz	drawmemlabel		; can't call rv if already home
	;	xor	drawmemflag,-1
		call	rescuestart
	drawmemlabel:

		cmp	scncode,45h+80h
		jnz	nonumlock
		mov	scncode,0
		xor	numlock,-1
	nonumlock:
		mov	di,offset @dataseg:desiredyaw
		mov	cx,3
		mov	ax,ds
		mov	es,ax
		xor	ax,ax
		cld
		rep	stosw
		mov	desireflag,0		; assume no one wants a strange view

		mov	al,1dh			; see if control key is down
		call	getkbit
		or	al,al
		jz	yesviews1
		jmp	noviews1

	yesviews1:
		cmp	numlock,0
		jz	noviews
	noviews1:
		mov	desireflag,-1
		mov	desiredyaw,0
		mov	al,4bh
		call	getkbit
		or	al,al
		jz	yawnonz
		mov	desiredyaw,16380
	yawnonz:
		mov	al,4dh
		call	getkbit
		or	al,al
		jz	yawnonz1
		mov	desiredyaw,-16380
	yawnonz1:
		mov	al,48h
		call	getkbit
		or	al,al
		jz	yawnonz2
		mov	desiredyaw+2,-8192
	yawnonz2:
		mov	al,50h
		call	getkbit
		cmp	ejectflag,0
		jnz	yawnonz2a
		or	al,al
		jz	yawnonz3
		mov	desiredyaw+2,8192
		jmp	yawnonz3
	yawnonz2a:	
		or	al,al
		jz	yawnonz3
		mov	desiredyaw,32767
	yawnonz3:
		cmp	ejectflag,0
		jnz	yawnonz4
		mov	al,4ch
		call	getkbit
		or	al,al
		jz	yawnonz4
		mov	desiredyaw+2,16383
	yawnonz4:
		jmp	getonwithlife
	noviews:				; not everybody can be interested
						; in politics!
		mov	di,offset @dataseg:curryaw	; if no views, set yaw to orot
		mov	cx,3
		xor	ax,ax
		rep	stosw

	getonwithlife:

	propaliveok1:
		mov	si,offset @dataseg:ox	; move prop to correct loc
		mov	bx,offset @dataseg:norot
		mov	propvec+4,-900
		mov	di,offset @dataseg:objprop
		mov	cx,9				; 6words for dxvec position
		cld
		mov	ax,ds
		mov	es,ax				; set up the segment
		rep	movsw				; and 3 for angle
		mov	si,offset @dataseg:propvec
		mov	di,offset @dataseg:xvec
		call	matvmul
	;jmp	ship4	
		mov	ax,xvec
		cwd
		add	objprop,ax
		adc	objprop+2,dx
		mov	ax,xvec+2
		cwd
		add	objprop+4,ax
		adc	objprop+6,dx
		mov	ax,xvec+4
		cwd
		add	objprop+8,ax
		adc	objprop+10,dx

		mov	bx,rpm
		sub	bx,10
		sal	bx,1
		xor	dx,dx
		mov	ax,cs:oticks
		mul	bx
		neg	ax				; make rotate in proper dir
		mov	objprop+16,ax			; add the prop speed to angle
	noprop:

		mov	bulvel,4400
		mov	bulrate,2	; give slower rate
		mov	bullife,96	; stay alive for 18 frames
		cmp	ejectflag,0
		jnz	yescannons
		mov	al,2ah		; if alt is down, shoot cannons
		call	getkbit
		or	al,al
		jz	nocannons
	yescannons:
		mov	bulrate,1
		mov	bullife,48	; only half a life
		mov	bulvel,700
	nocannons:
		cmp	oz+2,0		; are we way high?
		jnz	altfine
		mov	bx,4500		; put some hysterisis in alt
		cmp	altlighton,0
		jz	acmp4500
		mov	bx,5000		; if light on, don't turn off until
					; significantly higher
acmp4500:
		xor	ax,ax
		cmp	oz,bx		; are we low?
		jae	altfine		; altidude is fine!
		cmp	groundflag,al
		jnz	altfine		; don't flash when on ground
		cmp	ejectflag,al
		jnz	altfine		; don't flash when not in plane
		call	flashalt	; flash the altimiter
		xor	ax,ax
		cmp	altmsgflag,al
		jz	noaltmsg
		cmp	closetowerflag,al
		jnz	noaltmsg	; if home, don't turn on msg
		cmp	altlighton,al	; check for 0 to 1 transistion
		jnz	noaltmsg
		cmp	oz,2000
		jb	noaltmsg	; this avoids message upon takeoff
		mov	rmsgqueue,offset @dataseg:hitrmsg
noaltmsg:
		mov	altlighton,-1	; flag says alt light on
		jmp	itflashed

	altfine:

		mov	altlighton,0	; flag says alt light off
		mov	ax,0f00h
		mov	bx,9
		call	drawbutton
		mov	ax,070eh		; load with funky value
		mov	bx,9
		call	drawbutton
	itflashed:
IF guns
		cmp	bultick,0	; bullet timer run down?
		jz	qbullet		; yes, then see if a bullet is desired
	nobul1:	jmp	nobulls		; nope, no bullet
	keybul:	
	;	cmp	bulvel,700	; have cannons been requested
	;	jz	bulreq		; if yes, then shoot them even w/o space bar
		cmp	ozeff+2,0	; are we low?
		jnz	nolow
		cmp	ozeff,2*ehmin	; are we really low?
		jb	skipcann
		cmp	homeflag,0	; are we home
		jz	nolow		; not home
		cmp	ozeff,15*ehmin	; are we really low?
		ja	nolow
		jmp	skipcann	; skip cannons is if low and home
nolow:
		mov	al,2ah		; if alt is down, shoot cannons
		call	getkbit
		jnz	bulreq		; cannons?
skipcann:
		mov	al,39h		; get space bar
		call	getkbit
		or	al,al
		jz	nobul1		; nope
		jmp	bulreq		; yes, request a bullet

	qbullet:
		mov	ax,bulrate	; rate at which bullets are fired
		mov	bultick,ax
		mov	bx,bulavg	;
		or	bx,bx
		jz	dontdec
		dec	bulavg
	dontdec:
		mov	bx,misavg	;
		or	bx,bx
		jz	dontdec1
		dec	misavg
	dontdec1:
IF nodemo EQ 0
		cmp	demoflag,-1	; if in demo mode, jump into bullet code with
					; guns blazing if desired
		jnz	bullsasusual
		mov	al,demobyte
		mov	cl,4
		shl	al,cl
		jmp	demobull
ENDIF
	bullsasusual:
		cmp	joyflag,0	; are we using the joystick?
		jz	keybul		; no, then get key stuff
		
		cmp	jdrvrflag,0
		jz	normjbut
		mov	dx,0
		mov	ah,84h		; prepare to call joy bios
		int	15h
		jmp	normjrej
normjbut:
		mov	dx,201h		; joystick button port
		in	al,dx
normjrej:
		cmp	demoflag,1	; are we recording?
		jnz	demobull	; no, leave alone
		mov	ah,al
		and	ah,030h		; check bits
		mov	cl,4
		shr	ah,cl
		and	demobyte,NOT 3
		or	demobyte,ah	; stuff bits into demobyte
	demobull:
		and	al,030h		; check bits
	;	cmp	al,030h		; see if both up
	;	jz	nobutts
		test	al,10h
		jnz	nobulls
	bulreq:
		cmp	bulavg,32	; 32 bullets out?
		ja	nobulls
	;	cmp	crshlndflag,0
	;	jnz	nobulls		; no bullets if you crashed
	;	mov	homeflag,0
		mov	homelandflag,0
		push	ax
		call	bulstrt
		pop	ax

ENDIF ; guns
	nobulls:
IF guns
		cmp	mistick,0	; bullet timer run down?
		jz	qmissle		; yes, then see if a bullet is desired
	nomis1:	jmp	nobutts		; nope, no bullet
	keymis:	mov	al,2eh		; get space bar
		call	getkbit
		jz	nomis1		; nope
		jmp	misreq		; yes, request a bullet

	qmissle:
		cmp	demoflag,-1	; if in demo mode, jump into bullet code with
					; guns blazing if desired
		jnz	misasusual
IF nodemo EQ 0
		mov	al,demobyte
		mov	cl,4
		shl	al,cl
		jmp	demomis
ENDIF
	misasusual:

		mov	ax,misrate	; rate at which missles are fired
		mov	mistick,ax
		cmp	joyflag,0
		jnz	joymis
		jmp	keymis
	joymis:
		mov	al,39h		; get space bar code
		call	getkbit
		or	al,al
		jnz	misreq
		cmp	jdrvrflag,0
		jz	normjbut2
		mov	dx,0
		mov	ah,84h		; prepare to call joy bios
		int	15h
		jmp	normjrej2
normjbut2:
		mov	dx,201h		; joystick button port
		in	al,dx
normjrej2:
	demomis:
		and	al,20h
		jnz	nobutts
	misreq:					; request a missle
IF nodemo EQ 0
		and	demobyte,NOT 2	; set bit
ENDIF
		cmp	misavg,16
		ja	nobutts
		cmp	crshlndflag,0
		jnz	misfail
	;	mov	homeflag,0		; clear flag that says were home
		mov	homelandflag,0
		cmp	ejectflag,0		; if not in plane, need caps lck
		jz	noclneed
		cmp	remoteflag,0
		jz	misfail			; don't throw missles
noclneed:
IF soundflag EQ 0
		call	snaresnd		; make a missile sound
ENDIF
		call	strtmis
		jc	misfail
		add	misavg,5
	misfail:
ENDIF ; guns
	nobutts:
		mov	oldbuts,al	; save old status of buttons

		cmp	scncode,1fh+80h
		jnz	ntog
		mov	scncode,0
		mov	al,sndflg
		xor	al,-1
		jnz	sbkon
		call	soundoff
		xor	sndflg,-1
		jmp	ntog
	sbkon:	
IF soundflag EQ 0		; don't let them turn on the sound
		mov	sndflg,al
		call	soundon
ENDIF
	ntog:

IF testerflag
		cmp	scncode,0ah+80h
		jnz	nocheat
		mov	cheatflag,-1
nocheat:
ENDIF
						; see if we're up for firing
						; the rear rocket
IF qrocket
		mov	al,1
		add	al,rocketflag
		mov	oprclr1,al
		mov	ax,cs:ticks
		mov	bx,ax
		sub	ax,lrockettick
		mov	cx,ofrmticks	; correct for advanced time
		mul	cx
		mov	cx,realofrmticks	; should be same
		cmp	dx,cx
		jae	timewrong
		div	cx		; but will be less with adv time
		mov	lrockettick,bx
		add	ax,rockettick
		cmp	ax,2184
		ja	rocketcharged
		mov	rockettick,ax		; let rocket charge
		jmp	nofirerocket		; don't let fire until ready
timewrong:
		mov	lrockettick,bx
		jmp	nofirerocket
rocketcharged:
		mov	oprclr1,0ah		; make needle green
		mov	al,38h
		call	getkbit
		jnz	nofirerocket		; don't fire rocket if alt
		cmp	ejectflag,0		; don't fire if ejected
		jz	canrocket
		cmp	remoteflag,0
		jz	nofirerocket
canrocket:
		cmp	scncode,17h+80h		; has rocket been ignited?
		jnz	nofirerocket
		mov	rocketflag,0bh		; fire rocket make display red
nofirerocket:	
ENDIF


IF guns
					; make a bomb if it is time
		cmp	nbombs,3
		jae	checkbombreq	; if we already have 3, ignore
		mov	ax,cs:ticks	; no, has enough time to produce a bomb passed?
		sub	ax,lastbombtick
		mov	cx,ax
		mov	bx,ofrmticks	; correct for advanced time
		mul	bx
		cmp	dx,bx
		jb	divwbok
		mov	ax,cx
		jmp	dontdiv
divwbok:
		mov	bx,realofrmticks	; should be same
		div	bx		; but will be less with adv time
dontdiv:
		cmp	ax,bombwait	; how long to wait for the next bomb
		jb	checkbombreq	; forget it for now
		mov	bl,nbombs
		inc	bl
		mov	nbombs,bl
		call	drawabomb
		mov	ax,cs:ticks	; write last bomb time down
		mov	lastbombtick,ax
	checkbombreq:
ENDIF ; guns
IF nodemo EQ 0
		cmp	demoflag,1
		jnz	skipbclr
		and	demobyte,NOT 4	; clear bomb bit
ENDIF
	skipbclr:
IF guns
IF nodemo EQ 0
		cmp	demoflag,-1	; are we playing back?
		jnz	nodemobomb
		test	demobyte,4	; check bomb byte
		jnz	yesdemobomb
ENDIF
ENDIF ; guns
	nodemobomb:

IF guns
		cmp	scncode,30h+80h
		jnz	nobomb
		mov	scncode,0
IF nodemo EQ 0
		or	demobyte,4	; set bomb bit
ENDIF
	yesdemobomb:
		mov	al,nbombs
		or	al,al
		jz	donthaveabomb	; yes, we have no bannanas!
		cmp	ejectflag,0	; but are we in the plane
		jz	ofcrsbomb	; yes, so it's ok to drop
		cmp	remoteflag,0	; no, are we in autoness?
		jz	donthaveabomb	; no, go to nobombland
ofcrsbomb:
		call	strtbomb
		mov	bl,nbombs
		dec	bl
		mov	nbombs,bl
		xor	bh,bh		; point to correct button
		add	bx,6
IF slalom
		mov	ax,0703h	; make bomb disappear
ELSE
		mov	ax,0708h	; make bomb disappear
ENDIF
		call	drawbutton	;
		mov	ax,cs:ticks	; write last bomb time down
		mov	lastbombtick,ax
	donthaveabomb:
ENDIF ; guns
	nobomb:
IF guns
		cmp	scncode,27h+80h
		jz	plantbomb	; make ';' key plant a bomb
		mov	al,38h
		call	getkbit
		jz	nobombplant	; if no alt key, forget it!
		cmp	scncode,17h+80h	; look for alt-i
		jnz	noinvinc
		mov	scncode,0	; clear scan code
IF shareflag				; if shareware, only one way toggle
		mov	invincible,0
ENDIF
		xor	invincible,-1
		jz	skipclrd	
		call	cleardamage	; set damage to zero
skipclrd:
		call	restoreview	; redraw instrument panel
	noinvinc:
		cmp	scncode,19h+80h	; look for a bomb plant
		jnz	nobombplant	; via alt-P
	plantbomb:
		mov	scncode,0
		cmp	ejectflag,0
		jz	nobombplant
		cmp	abombsleft,0
		jz	nobombplant

		mov	si,offset @dataseg:ox
		call	strtbomb1
		mov	si,expobj	; fix up a few things
		xor	ax,ax
		mov	[si+46],ax
		mov	[si+48],ax
		mov	[si+50],ax
		mov	[si+66],ax	; make blast radius zero
		mov	word ptr [si+14],-16384	; make bomb point up
		and	word ptr [si+24],NOT 8	; make bomb indestructable for now
		or	word ptr [si+24],804h	; make bomb sit on hold for a minute
		mov	byte ptr [si+19],0	; make bomb a class zero object
		dec	abombsleft
	nobombplant:
ENDIF ; guns

		cmp	scncode,3ah+80h	; toggle remote mode
		jnz	noremote
		mov	scncode,0
		xor	remoteflag,-1
	noremote:
		mov	ax,topv
		mov	cl,4
		sar	ax,cl
		sub	ax,231
		.abs_w	ax
		sar	ax,cl
		mov	dx,rpm
		sar	dx,1
		sar	dx,1
		add	ax,dx
		bndck	300h,80h		; keep in limits
		mov	bl,0


	valkey:	
		cmp	ejectflag,0
		jz	throttleactive
		cmp	remoteflag,0
		jnz	throttleactive
		jmp	mnlb01
throttleactive:
		mov	al,0dh			; see if + key hit
		call	getkbit
		push	ax
		mov	al,04eh
		call	getkbit
		pop	bx
		or	al,bl			; are either key down?
		jz	noplus
		test	obj5dbits,2000h		; is it the superplane?
		jz	notsppln
		cmp	aceflag,0
		jz	noplus
	notsppln:
		cmp	currpmx,0
		jnz	noplus1			; don't even bother
		test	obj5dbits,100h		; is plane crashed?
		jz	noplus
		cmp	ejectflag,0
		jnz	noplus			; don't blow up if we are out of plane
		mov	crshflg,8
		jmp	noplus
	noplus1:
		xor	al,al
		mov	freezeflag,al		; if plane is stopped, unfreeze motion
		mov	helpflashflag,al	; stop help from flashing
		mov	bx,12
		mov	ax,0107h
		call	drawbutton		; turn off blue letters
		add	rpm,20
		mov	ax,currpmx
		cmp	ax,rpm
		jns	noplus
		sub	ax,3		; set to currrpmx - 3
		mov	rpm,ax
	noplus:
		mov	al,0ch
		call	getkbit
		push	ax
		mov	al,04ah
		call	getkbit
		pop	bx
		or	al,bl
		jz	nominu
		sub	rpm,20
		cmp	rpm,20
		jns	nominu
		mov	rpm,20
	nominu:	
	mnlb01:
		cmp	crshflg,0
		jz	nopcrsh		; no plane crash
		call	crash
		cmp	invincible,0
		jnz	nopcrsh		; force no crash
		jmp	done4
	nopcrsh:
		cmp	scncode,0a2h
		jnz	nominu1
		mov	scncode,0
		xor	gdflg,-1
	nominu1:
		cmp	ejectflag,0
		jz	norun1		; ignor if we are on ground
		mov	al,4ch		; see if we are running
		call	getkbit
		or	al,al
		jz	norun1
		mov	ax,800
		wtadj
		mov	stepsz,ax
		call	step
	norun1:
		cmp	ejectflag,0
		jz	norun2		; ignor if we are on ground
		mov	al,52h		; see if we are running
		call	getkbit
		or	al,al
		jz	norun2
		mov	ax,-800	; take a step backward
		wtadj
		mov	stepsz,ax
		call	step
	norun2:	
	;	mov	al,4ch		; look for center button
	;	call	getkbit
	;	or	al,al
	;	jz	nocenterkey
	;	mov	bx,orvec+4	; get roll
	;	mov	ax,400
	;	wtadj
	;	imul	bx
	;	sub	thrdotl,ax
	;	sub	thrdoth,dx
	;nocenterkey:
;		mov	al,52h
;		call	getkbit
;		or	al,al
;		jz	nopitctr
;		call	levelplane
;	nopitctr:
IF nodemo EQ 0
		cmp	demoflag,-1
		jnz	skipdflap
		mov	al,demobyte
		and	al,16
		mov	flapflag,al
		jmp	injectflaps		; draw button properly
	skipdflap:
ENDIF
		cmp	scncode,021h+080h	; look for spacebar
		jnz	noflap3
		mov	scncode,0
		mov	ax,200
		xor	flapflag,-1		; reverse flapflag
	injectflaps:
		jz	flapper
		push	ax
		call	drawflapbut
		pop	ax
		neg	ax
		jmp	flapper1
	flapper:
		push	ax
		mov	ax,070fh		; turn letters white
		mov	bx,2
		call	drawbutton		
		mov	ax,0006h		; turn button brown
		mov	bx,2
		call	drawbutton		
		pop	ax
	flapper1:
IF nodemo EQ 0
	IF demorec
		push	ax
		mov	al,flapflag		; update flapper flag
		and	al,16
		mov	ah,demobyte
		and	ah,NOT 16
		or	al,ah
		mov	demobyte,al
		pop	ax
	ENDIF
ENDIF

		cmp	groundflag,0
		jnz	noflap3			; don't give a kick whilst on grnd
		add	pitdoth,ax		; kick in the pants
	noflap3:
		cmp	cmpltflag,0
		jns	nocmpltyet
		call	drawcmpltbut
		mov	cmpltflag,1
	nocmpltyet:
		cmp	scncode,0a1h
		jnz	nominu2
		mov	scncode,0
		xor	fillflg,-1
		mov	gndcolor,0
		jnz	nominu2
		mov	gndcolor,0ah
	nominu2:
		cmp	scncode,13h+080h
		jnz	ndone4
		cmp	ptrgwinf,offset @dataseg:gwinf
		jnz	ndone4		; only give rear window to interior view
		mov	scncode,0
		cmp	ptrgwint,0
		jz	anmle
		mov	n,0
		mov	bx,gtymax-gtymin
		mov	cx,(gtxmax-gtxmin+1)/16
		mov	di,gtmnb
		call	scrfbx		; erase contents of other window
		call	flipage
		mov	n,0
		mov	bx,gtymax-gtymin
		mov	cx,(gtxmax-gtxmin+1)/16
		mov	di,gtmnb
		call	scrfbx
		call	flipage
		xor	ax,ax
		jmp	short ndone5
	anmle:	mov	ax,offset @dataseg:gwint
	ndone5:	mov	ptrgwint,ax
	ndone4:
		cmp	scncode,1eh+80h
		jnz	noautokey
		mov	scncode,0		; pretend no key
		xor	autoflag,-1		; reverse state
		jnz	iwasright		; yup, go ahead as planned
		mov	ax,070fh			; told you so!
		xor	bx,bx			; button 0
		call	drawbutton
		mov	ax,0001h		; search for blue, replace w/ black
		xor	bx,bx			; button 0
		call	drawbutton
		jmp	noautokey
	iwasright:
		call	drawautobut		; draw the auto button
	noautokey:
IF nodemo EQ 0
		cmp	demoflag,-1		; are we playing back?
		jnz	noejdemo
		test	demobyte,32
		jnz	demoejinject
	noejdemo:
	IF demorec
		and	demobyte,NOT 32		; no eject until proven guilty
	ENDIF
ENDIF
		cmp	scncode,12h+80h
		jz	eject1
		jmp	noeject1
	eject1:
		mov	scncode,0
	demoejinject:
		cmp	ejectflag,0
		jz	noeject1not
		jmp	noeject1	; can't eject if you've already ejected

	noeject1not:
IF nodemo EQ 0
	IF demorec
		or	demobyte,32
	;	cmp	demoflag,-1	; are we in replay?
	;	jnz	dontstop
	;	mov	demoflag,0	; turn off replay
	dontstop:
	ENDIF
ENDIF
IF soundflag EQ 0
		mov	bl,0		; turn off voice
		mov	ax,100h
		call	voiceoff
		mov	bl,2
		mov	ax,10h
		call	voiceoff	; turn voice off (blams)
		mov	bl,5			; turn off stall warning
		mov	ax,200h
		call	voiceoff
		mov	bl,2			; turn off stall warning
		mov	ax,200h
		call	voiceoff
		mov	bl,3			; turn off stall warning
		mov	ax,200h
		call	voiceoff

		mov	windflag,1	; turn on wind
		call	windinit
ENDIF
	
		mov	ammoleft,20		; twenty shots of ammo is all we 
		mov	abombsleft,1		; give'em an assasin bomb
						; can carry
		mov	numlock,0		; turn views off
		mov	outfromflag,0		; don't let us in until we've gone out
		mov	redamageflag,-1		; use old damage
		mov	bx,offset @dataseg:obj5d	; start displaying obj5d
		mov	word ptr [bx+24],11h			; make object real
		mov	ax,obj5dbits
		or	word ptr [bx+24],ax
		mov	si,offset @dataseg:tblist
		mov	si,[si]
		call	tbadd
		inc	ejectflag	; set the flag
		mov	al,255
		mov	fadecolor,al
		test	tripflag1,1	; if tripping, don't mess with palatte
		jnz	tripf1
		call	setcolors	; if you were pulling g's, recover instantly
	tripf1:
		mov	di,offset @dataseg:obj5d
		mov	si,offset @dataseg:ox
		mov	ax,ds
		mov	es,ax
		mov	cx,6
		cld
		rep	movsw
		mov	si,offset @dataseg:orvec
		mov	cx,3
		rep	movsw
		mov	si,offset @dataseg:orvec
		mov	di,offset @dataseg:oorvec
		mov	cx,3
		rep	movsw
		cmp	crshlndflag,0
		jnz	ycrshlndexit
;		jnz	juststand
		cmp	groundflag,0
		jnz	juststand ; if on ground, just get out of the plane
	;	cmp	crshlndflag,0
		jmp	ncrshlndexit
ycrshlndexit:
		call	set5dbits	; if crashlanded, make sure bits reflect it
		mov	si,offset @dataseg:obj5d
		mov	word ptr [si+24],0e1h	; object type 0= no-draw bit 4=destructable
		mov	ax,obj5dbits	; transfer status of plane to obj 5d
		or	[si+24],ax	;
		mov	ax,offset @dataseg:plnplyobjsm
		and	word ptr [si+24],NOT 8		; make object non-destructable
		mov	[si+40],ax
		mov	[si+42],ax
		mov	[si+44],ax
		mov	ax,hmin
		shr	ax,1
		mov	obj5d+8,ax	; drop the plane down to the ground
		mov	obj5d+10,0
		mov	ax,zground
		add	obj5d+8,ax
		mov	ax,zground+2
		adc	obj5d+10,ax
		mov	freezeflag,-1
	juststand:
		mov	si,offset @dataseg:obj5d
		mov	ax,hmin		; get proper hieght
		xor	dx,dx
		mov	bx,zground
		mov	cx,zground+2	; if plane on suspended airstrip, so be it!
		add	ax,bx
		adc	dx,cx
		mov	myzground,bx
		mov	myzground+2,cx

		mov	oz,ax		; put at same height as plane
		mov	oz+2,dx		; put you on the ground
		and	word ptr [si+24],NOT 8		; make object non-destructable

		mov	stepoutflag,-1
		xor	ax,ax
		add	oy,2000		; get away from the plane
		adc	oy+2,ax
		mov	otopv,ax
		mov	otopv+2,ax
		mov	otopv+4,ax
		mov	standingflag,-1
		jmp	standnext	; stand next to the plane
	noeject1:	
		jmp	noeject
	ncrshlndexit:
		cmp	exitflag,0	; if we are exiting, ignore transgression
		jnz	skiplibel
		or	missionstatus,20h	; eject in air flag
	skiplibel:
		mov	standingflag,0	; we are not standing if plane twernt on ground
	;	mov	fateofplane,0	; we don't know the fate of the plane
		mov	si,offset @dataseg:rtopv
		mov	di,offset @dataseg:otopv
		mov	cx,3
		rep	movsw
		mov	bx,8192
		call	randr_w
		and	ax,0efffh
		or	ax,0800h		; make sure no magnitude is too small
		mov	tmbvec,ax
		call	randr_w
		and	ax,0efffh
		or	ax,0800h		; make sure no magnitude is too small
		mov	tmbvec+2,ax
	standnext:				; enter here if you just want to stand
		call	fullsize		; goto full size window
		mov	chutedamp,32000
	noeject:

IF nodemo EQ 0
		cmp	demoflag,0
		jz	skpdmtst
		test	demobyte,32
		jnz	demoplinject
ENDIF
	skpdmtst:
		cmp	scncode,0b9h	; look for spacebar
		jnz	nospace
		mov	scncode,0
	demoplinject:
	;	mov	homeflag,0
	;	mov	homelandflag,0
	;	call	strtmis
		cmp	ejectflag,0
		jz	nospace
		cmp	pullstrflag,0	; if already pulled, refuse to pull again
		jnz	nospace
		inc	pullstrflag	; pull chute string
	nospace:

		cmp	scncode,026h+80h
		jnz	ndonefs
		mov	scncode,0
		call	fullsize		; goto full size window
	ndonefs:
		cmp	scncode,3bh+80h
		jnz	noboss
		mov	scncode,0
		mov	bossflag,-1		; uh oh, the boss is here!
	noboss:
		cmp	scncode,40h+80h
		jnz	notur
		xor	al,al
		mov	scncode,al
		mov	bossflag,7dh
notur:
		cmp	scncode,3fh+80h
		jnz	norejoyc
		xor	al,al
		mov	scncode,al
		dec	al
		cmp	joyflag,0
		jnz	okhjoy		; it's ok, we have a joystick
		mov	ax,700		; make a beep
		mov	dx,25
		call	sound_beep
		jmp	norejoyc
okhjoy:
		mov	rejoyflag,al
		mov	bossflag,al
norejoyc:
;IF shareflag EQ 0
		cmp	scncode,3dh+80h
		jnz	noscorereprot
		mov	scncode,0
		mov	bossflag,07fh		; uh oh, the boss is here!
	noscorereprot:
;ENDIF
		cmp	frmnum,7		; are we ready for auto
						; mission select popup?
		jnz	nomspopup
		cmp	readfileflag,0
		jz	trainpopup
		cmp	rpm,20			; has user touched the throt?
		jnz	nomspopup
		mov	rmsgqueue,offset @dataseg:hitf2rmsg
		jmp	nomspopup
trainpopup:
		mov	rmsgqueue,offset @dataseg:trainrmsg
nomspopup:
		cmp	scncode,3ch+80h
		jnz	noboss1
forcetower:
		mov	scncode,0
		mov	intowerflag,1		; uh oh, need the intelligence info
	noboss1:
		mov	al,23h
		call	getkbit
		or	al,al
		jz	nodball
		cmp	ejectflag,0
		jz	nodball
		mov	haltflag,-1
	;	mov	bx,7
	;	mov	ax,0007		; make bomb disappear
	;	call	drawbutton	;
	nodball:


IF soundflag
IF nodemo EQ 0
		cmp	frmnum,12
		jb	nosoundprob
		mov	si,offset @dataseg:sndflg+10
		sub	si,10
		mov	al,[si]	; make sure sound is off
		or	al,al
		jz	nosoundprob
		mov	si,offset @dataseg:demoflag+12
		sub	si,12
		mov	al,[si]	; make sure sound is off
		or	al,al
		jnz	nosoundprob
		mov	ejectflag,-1	; don't let him in plane
nosoundprob:
ENDIF
ENDIF



		cmp	scncode,1+80h
		jz	donesc
escfalsealarm:
		cmp	exitflag,0
		jnz	done4

		mov	abortflag,-1	; assume abort
		mov	al,1dh		; if cntl is down, its time to leave
		call	getkbit
		push	ax
		mov	al,2eh		; check for cntl-c
		call	getkbit
		pop	bx
		and	al,bl
		jnz	done4
		mov	abortflag,0	; well, i guess it wasn't an abort

		or	cs:cecode,0
		jnz	done4
		cmp	rescueflag,0
		jnz	wearerescued
		cmp	capturedflag,0
		jz	bigloop

	;	cmp	haltflag,0	
	;	jz	bigloop
	;	cmp	fadecolor,0
	;	jnz	bigloop
		or	missionstatus,8		; set captured bit

		jmp	done4		; has the screen faded out?
	bigloop:
		jmp	anml1
	donesc:	
	cmp	rmsgflag,0
	jz	skiprmsg21
	cmp	closetowerflag,0
	jnz	skiprmsg21
	cmp	escwarnflag,0
	jnz	skiprmsg21
	mov	escwarnflag,-1
	mov	rmsgqueue,offset @dataseg:escwarningrmsg
	cmp	ejectflag,0
	jz	escfalsealarm
	mov	rmsgqueue,offset @dataseg:escgwarningrmsg
	jmp	escfalsealarm
skiprmsg21:
		jmp	done4
	wearerescued:
		mov	haltflag,0

	done4:	
		jmp	donep33
	donep33:
		cmp	abortflag,0
		jz	dontcrap
		or	missionstatus,4000h	; set abort bit
		jmp	getusoutnow
	dontcrap:
IF testerflag 	; don't set bit if in tester mode
		cmp	cheatflag,0
		jnz	dontcrap1
ENDIF
		cmp	invincible,0
		jz	dontcrap1
		or	missionstatus,2000h
	dontcrap1:
		cmp	exitflag,0
		jnz	ifexitflag		; avoid doing this twice
		xor	ax,ax			; tsk, tsk, random bits are bad
						; for business
		and	missionstatus,NOT 1	; clear abort bit
		cmp	homeflag,0
		jz	dontsethbit
		mov	ax,1			; set up to set abort bit
		cmp	neverleftflag,0
		jnz	dontsethbit			; don't count if never left
		xor	ax,ax
							; our own airspace
		or	missionstatus,010h		; set made it home bit
	dontsethbit:
		or	missionstatus,ax		; set abort bit
	;	cmp	homeflag,0			; if we made it back, clear
	;	jnz	clearcap
		cmp	rescueflag,0			; captured bit
		jz	norescue
		or	missionstatus,100h	; leave bit saying we were rescued
	clearcap:
		and	missionstatus,NOT 8h	; clear captured bit
	norescue:
		xor	ax,ax
		cmp	readfileflag,al		; did we read the results from a file?
		jz	ifexitflag
		cmp	bhighflag,al		; just get the hell out if high alt
		jnz	ifexitflag
		cmp	crshflg,al		; did we die in a crash?
		jnz	ifexitflag
		cmp	ejectflag,al		; were we out of the plane?
		jnz	ifexitflag		; yes, so the plane is drawn
		cmp	abortflag,al
		jnz	ifexitflag		; yes, get out on account of abort
		cmp	crshlndflag,al
		jnz	skpgrndck
		cmp	currpmx,ax		; if we are crashed, also don't check
		jz	skpgrndck
	skpgrndck:
		mov	exitflag,-1
		mov	scncode,0		; erase any pending escape
		jmp	noeject1not		; go back and eject before we leave
	ifexitflag:
			cmp	obj5d+24,0		; is object even on?
			jz	getusoutnow		; no, then skip it!
			mov	obj5d+72,2		; turn object into obj5da
			mov	ax,obj5dbits		; give it present attributes
			or	ax,10h			; make it a timed object
			or	obj5d+24,ax
			mov	obj5d+52,32000		; make time to last long
	;		add	obj5d,16000
	;		adc	obj5d+2,0
			call	drawnear		; sort and farm once more

	getusoutnow:
	mov	ax,cs:frmticks			; save speed info now
	mov	score,ax			; in unused leftover variable

;IF leavegraf EQ 0
;			mov	al,oldmode
;		xor	ah,ah
;			int	10h		
;ENDIF
		call	soundoff
	nmodes:	

		call	rest08				; restore int 8 vector
		call	reset_ticks
IF errortrap
		call	rest00
ENDIF
		call	turnoffbreaks			; turn off breaks just to be
							; sure
		call	reset9

IF soundflag EQ 0
		call	adlreginit			; shut down sound board
ENDIF
;IF leavegraf EQ 0
;		call	get_chr				; wait for a char
;			mov	al,oldmode
;		xor	ah,ah
;			int	10h		
;ENDIF
	IF finalscreen
	IF demover EQ 0
		call	wcr
		call	addtoetime
		mov	si,offset @dataseg:timsg
		call	put_str
		mov	ax,etime
		mov	si,offset @dataseg:kbuf
		call	word_to_dec
		call	put_str
		call	wcr
		mov	ax,tempsum
		mov	dx,tempsum+2
		call	hashregcode
		call	dwword
		mov	ax,nregcode
		mov	dx,nregcode+2
		call	dwword
		call	wcr
	
		mov	ax,dballprog
		mov	dx,dballprog+2
		call	dwword
		mov	ax,aaprog
		mov	dx,aaprog+2
		call	dwword
		mov	ax,rollprog
		call	wword
		mov	ax,obj5dbits
		call	hwword
		mov	ax,obj5d+24
		call	hwword

		call	wcr
		cmp	crshflg,0
		jz	notocrsh
		mov	si,offset @dataseg:crshmsg
		call	put_str
		mov	al,crshflg
		xor	ah,ah
		call	wword
		mov	ax,maxpitch
		call	wword
		mov	ax,maxroll
		call	wword
	notocrsh:
		mov	si,offset @dataseg:toykmsg
		call	put_str
		call	get_chr			; wait for a key
	ENDIF

	ENDIF
;	mov	si,offset @dataseg:frmsg
;	call	put_str
;	mov	ax,nframes
;	mov	si,offset @dataseg:kbuf
;	call	word_to_dec
;	call	put_str
;	call	wcr
;	mov	si,offset @dataseg:repsmsg
;	call	put_str
;	call	get_chr
;	call	wcr
	call	flush_keys		; flush keyboard buffer

IF demover EQ 0		; don't bother to write the file in demo mode
	call	hashcfg			; hash the config data
		mov	si,offset @dataseg:fname
		mov	ax,0102h
		call	open_h
		mov	fhandl,bx
		jc	errorjoy

		mov	bx,fhandl
		call	lseekbof_h	; point to file beginning
		mov	si,offset @dataseg:jleft
		mov	cx,ncfgbytes
		mov	bx,fhandl
		call	write_h
		jc	errorjoy

		mov	bx,fhandl
		call	close_h
		jc 	errorjoy
	call	unhashcfg			; hash the config data
ENDIF
	jmp	preerror

errorjoy:
	jmp	error
preerror:			; jump to here if and error occurred before
				; the meat of the code was run
	mov	al,cs:cecode
	xor	ah,ah
	mov	errcode,ax
	cmp	slowflag,0
	jnz	skipwscore		; if called by george's program
;	call	wscore			; write score to disk file
	jmp	skipresfile
skipwscore:
	mov	ax,nplaneslost		; fix up the nplanes lost variable
	sub	ax,nkillmetough
	jns	chkmt			; we couldn't have killmetoughed
	xor	ax,ax
chkmt:
	mov	nplaneslost,ax		; update nplanes lost
	mov	nkillmetough,0		; reset this so no way it done twice
	mov	ax,patchcrash
	and	missionstatus,ax
	
		call	writeresfile	; write out the result file

skipresfile:

	cmp	cs:cecode,93		; if joystick error, just leave
	jz	nferr

	cmp	readfileflag,0
	jz	skipthewrite		; don't write the file if we didn't
	cmp	cs:cecode,0		; if crit error, don't write univ
	jnz	skipthewrite
	call	flushtiles		; flush out the current objects into
					; file data space
IF getunivbin
	call	mergeunivbin		; add objects from peditor file
ENDIF
	call	writeunivfile		; write universe to disk file
skipthewrite:

checknextk:
	call	check_key		; empty the type ahead buffer
	jne	nokeyhere		; it is empty, continue
	call	get_chr			; eat a char
	mov	ax,300			; wait a minute for other keypresses
	jmp	checknextk

nokeyhere:


	mov	ax,memseg		; release far memory
	mov	es,ax
	call	far_free
	jnc	nferr
	mov	si,offset @dataseg:fferrmsg
	call	put_str
	call	get_chr
nferr:

IF 1 EQ 0
	mov	ax,3
	int	10h
	call	put_newline
	mov	ax,arrowbuf
	mov	dx,arrowbuf+2
	call	dwword
	mov	ax,arrowbuf+4
	mov	dx,arrowbuf+6
	call	dwword
	mov	ax,arrowbuf+8
	mov	dx,arrowbuf+10
	call	dwword
	mov	ax,arrowbuf+12
	mov	ax,homeangle
	call	wword
	mov	al,arrowflag
	xor	ah,ah
	call	wword
	call	get_chr
ENDIF
	call	put_newline
	mov	al,radarstat
	xor	ah,ah
	call	wword
	mov	al,oldradarstat
	xor	ah,ah
	call	wword
	call	put_newline

;	jmp	nfuckpict
	cmp	cs:cecode,0
	jnz	nfuckpict
IF leavegraf
	call	flush_keys
	call	get_chr
ENDIF
;	or	missionstatus,0400h
	call	pict



nfuckpict:

;	mov	al,shakecnt
;	xor	ah,ah
;	call	decwword
;	mov	ax,blamtick
;	call	decwword

;	mov	ax,3
;	int	10h
;	mov	ax,maxobjcount
;	call	decwword
;	call	put_newline
;	call	get_chr


	mov	ax,cs:timerretries
	or	ax,ax
	jz	timerok
	mov	si,offset @dataseg:timermsg
	call	put_str
	call	decwword
	call	wcr
	call	get_chr
timerok:



	cmp	diagflg,0
	jnz	diaglb8
	jmp	diaglb7
errorres2:
		jmp	error
diaglb8:
IF printflag
	call	printctstatus
;	call	get_chr
	call	printtables
;	call	get_chr
ENDIF
	jmp	ship7
IF printflag
	mov	ax,memseg
	call	hwword
	mov	ax,memseg
	add	ax,memsegskip
	call	hwword
	call	updatect
	call	changethem
	call	wcr
	mov	ax,ctiles
	mov	curtilex,ax
	call	wword
	mov	ax,ctiles+2
	mov	curtiley,ax
	call	wword
	call	updatect
	call	changethem
;	call	copyuniv
	mov	curtilex,ax
	call	wword
	mov	curtiley,ax
	call	wword
	call	get_chr

	mov	curtilex,4
	mov	curtiley,3
	call	printtile
	mov	curtilex,4
	mov	curtiley,4
	call	printtile
	call	get_chr
	mov	curtilex,5
	mov	curtiley,3
	call	printtile
	mov	curtilex,5
	mov	curtiley,4
	call	printtile
	mov	curtilex,6
	mov	curtiley,3
	call	printtile
	mov	curtilex,6
	mov	curtiley,4
	call	printtile
	jmp	ship7

	mov	ax,ctiles+4
	mov	curtilex,ax
	call	wword
	mov	ax,ctiles+6
	mov	curtiley,ax
	call	wword
	call	get_chr
	call	printtile
	mov	ax,ctiles+8
	mov	curtilex,ax
	call	wword
	mov	ax,ctiles+10
	mov	curtiley,ax
	call	wword
	call	get_chr
	call	printtile
	mov	ax,ctiles+12
	mov	curtilex,ax
	call	wword
	mov	ax,ctiles+14
	mov	curtiley,ax
	call	wword
	call	get_chr
	call	printtile

ENDIF
ship7:
	jmp	ship7a
IF printflag
	xor	ah,ah
	mov	al,rescolors+(4*2)	; green
	call	wword
	mov	al,rescolors+(4*2)+1	; green
	call	wword
	mov	al,rescolors+(4*2)+2	; green
	call	wword
	mov	al,rescolors+(4*2)+3	; green
	call	wword
	call	wcr
	mov	al,rescolors+(4*11)	; sky blue
	call	wword
	mov	al,rescolors+(4*11)+1	; sky blue
	call	wword
	mov	al,rescolors+(4*11)+2	; sky blue
	call	wword
	mov	al,rescolors+(4*11)+3	; sky blue
	call	wword
	call	wcr
	mov	ax,tempsum
	call	hwword
	mov	ax,ncyl
	call	hwword
	mov	ax,tempsum
	mov	dx,ncyl
	call	hashregcode
	call	unhashregcode
	call	hwword
	mov	ax,dx
	call	hwword
	call	wcr

	mov	ax,nregcode
	call	wword
	mov	ax,nregcodeh
	call	wword
	call	wcr
	mov	ax,tempsum
	mov	dx,ncyl
	call	dwword
ENDIF
ship7a:
IF printflag
	mov	ax,clnregcodeh
	call	wword
	mov	ax,clnregcode
	call	wword
	mov	ax,nregcodeh
	call	wword
	mov	ax,nregcode
	call	wword
	call	wcr
	mov	ax,zground
	mov	dx,zground+2
	call	dwword
	call	wcr
ENDIF

IF nodemo EQ 0
IF demorec
	mov	ax,cs:frmticks
	call	wword
	mov	ax,ofrmticks
	call	wword
	call	wcr
	mov	ax,delox
	mov	dx,delox+2
	call	dwword
	mov	ax,delox+4
	mov	dx,delox+6
	call	dwword
	mov	ax,delox+8
	mov	dx,delox+10
	call	dwword
	mov	ax,rtopv
	call	wword
	mov	ax,rtopv+2
	call	wword
	mov	ax,rtopv+4
	call	wword
	mov	ax,tempox
	mov	dx,tempox+2
	call	dwword
	mov	ax,tempox+4
	mov	dx,tempox+6
	call	dwword
	mov	ax,tempox+8
	mov	dx,tempox+10
	call	dwword
	call	wcr
	mov	ax,accelox
	call	wword
	mov	ax,accelox+2
	call	wword
	mov	ax,accelox+4
	call	wword
	mov	ax,maxacc
	call	wword
	call	wcr
IF delomegflag
	mov	ax,delomeg
	call	wword
	mov	ax,delomeg+2
	call	wword
	mov	ax,delomeg+4
	call	wword
	call	wcr
ENDIF
ENDIF
ENDIF
	call	wcr
	mov	si,offset @dataseg:frameratemsg
	call	put_str
	mov	ax,10000
	xor	dx,dx
	mov	bx,score
	div	bx
	call	decwword
	call	wcr
	call	wcr
IF printflag
	mov	ax,obj5dbits
	call	hwword
	mov	ax,obj5d+24
	call	hwword
	mov	al,groundflag
	xor	ah,ah
	call	hwword
	mov	al,crshlndflag
	xor	ah,ah
	call	hwword
	call	wcr
	call	wcr
	mov	si,offset @dataseg:topv
	call	wrtvec
	call	wcr
	mov	ax,ofrmticks
	call	wword
	uwtadj
	call	wword
ENDIF
	jmp	hair

IF printflag
	mov	al,44h
	call	put_chr
	mov	ax,distseg
	call	wword
	mov	ax,distptr
	call	wword
	call	wcr
	mov	ax,curndballs
	call	wword
	mov	ax,maxndballs
	call	wword
	mov	ax,ndballs
	call	wword
	call	wcr
	mov	curtilex,4
	mov	curtiley,4
	call	gettileadr
	mov	ax,es
	call	hwword
	call	wcr
	mov	ax,5555h
	call	getctstatusptr
	mov	byte ptr [bx],-1
	call	farmmemseg		; write it out

	mov	ax,dvel+10
	call	decwword
	mov	ax,avgdvelh
	call	decwword
	mov	ax,ofrmticks
	call	decwword
	call	decwword
	call	wcr
	mov	ax,nvechs
	call	decwword
	mov	al,onrunwayflag
	xor	ah,ah
	call	decwword
	call	wcr
	mov	ax,rtopv
	call	decwword
	mov	ax,rtopv+2
	call	decwword
	mov	ax,rtopv+4
	call	decwword
	call	wcr
	uwtadj
	call	decwword
	mov	ax,dvel+8
	mov	dx,dvel+10
	call	dwword


	mov	ax,toticks
	mov	dx,toticks+2
	call	dwword
	call	wcr
	mov	ax,epticks
	mov	dx,epticks+2
	call	dwword
	call	wcr
	mov	ax,gdticks
	mov	dx,gdticks+2
	call	dwword
	call	wcr
	mov	ax,dnticks
	mov	dx,dnticks+2
	call	dwword
	call	wcr
	mov	ax,hrticks
	mov	dx,hrticks+2
	call	dwword
	call	wcr
	mov	ax,inticks
	mov	dx,inticks+2
	call	dwword
	call	wcr
	mov	ax,ttticks
	mov	dx,ttticks+2
	call	dwword
	call	wcr
	mov	si,offset sxtemp
	call	put_str
	call	wcr
	mov	si,offset sytemp
	call	put_str
	mov	dx,ytemp	
	mov	ax,y1temp
	call	dwword
	call	wcr
ENDIF
hair:
diaglb7:
IF printflag
	mov	ax,3
	int	10h
	call	put_newline
	mov	si,offset @dataseg:expmsg
	call	put_str
	mov	ax,ds
	call	hwword
	mov	al,3ah
	call	put_chr
	mov	ax,offset @dataseg:exps
	call	hwword
	mov	ax,ds
	call	hwword
	mov	al,3ah
	call	put_chr
	mov	ax,offset @dataseg:neartbl
	call	hwword
	mov	ax,expsrmvd
	call	wword
	call	put_newline
	jmp	goaround1
	db	99h, 99h, 99h, 99h
goaround1:
ENDIF

	or	cs:cecode,0
	jnz	permsg

endus:	
	call	flush_keys	; flush buffer
;	cmp	crshflg,10
;	jz	werewolf
;	mov	ax,40h
;	mov	es,ax
;	test 	byte ptr es:[17h],2		; is left shift down?
;	jz	normalend
;	mov	ax,3			; put into text mode
;	int	10h
;	mov	ax,missionstatus
;	call	hwword
;	mov	ax,nfdest
;	call	wword
;	mov	ax,ardvark
;	call	wword
;	call	put_newline
;	call	get_chr
normalend:
	jmp	exit_ok		;exit to DOS with ERRORLEVEL=0

IF printflag
werewolf:
	mov	si,offset @dataseg:deathcoords
	mov	ax,[si]
	mov	dx,[si+2]
	call	dwword
	add	si,4
	mov	ax,[si]
	mov	dx,[si+2]
	call	dwword
	add	si,4
	mov	ax,[si]
	mov	dx,[si+2]
	call	dwword
	mov	ax,deathcode
	call	wword
	call	wcr
	call	get_chr
	jmp	exit_ok
ENDIF

permsg:	mov	si,offset @dataseg:cemsg
	call	put_str
	mov	al,cs:cecode
	cbw
	call	wword
	call	wcr
IF finalscreen
	call	get_chr			; wait for a key
ENDIF

	


	cmp	cs:cecode,63
	jnz	no63
	call	printexp
	call	wcr
	mov	ax,nflt
	call	wword
no63:
	jmp	endus
;	mov	ax,4c00h
;	int	21h			; return to DOS
.endp		main

.proc	grab08	auto		;grabs an int, man
;	mov	si,offset @dataseg:infmsg
;	call	put_str
	mov	bl,08		; video int
	call	get_vect	; get the current vector
	mov	old08+2,dx	; put into memory
	mov	old08,ax
	mov	bl,008		; now put in our new vector
	mov	dx,cs		; setup segment
	mov	ax,offset @codeseg:new08
	call	set_vect	; grab that vector!
	ret
.endp

IF xrv EQ 8
mwelcomewagon
cecode	db	0
mnew9
mdolandinggear
mnew08
ENDIF

.proc	rest08	auto		; restores int 08
	call	reset_ticks		; stop timer from racing, so we
	mov	bl,08		; int 08 is video bios
	mov	dx,old08+2	; get old segment
	mov	ax,old08	; get the old offset 
	mov	cx,dx
	or	cx,ax
	jz	r08ret
	call	set_vect	; set 'em back to orig state
r08ret:
	ret
.endp

IF errortrap

.proc	grab00	auto		;grabs an int, man
;	mov	si,offset @dataseg:infmsg
;	call	put_str
	mov	bl,00		; video int
	call	get_vect	; get the current vector
	mov	old00+2,dx	; put into memory
	mov	old00,ax
	mov	bl,000		; now put in our new vector
	mov	dx,cs		; setup segment
	mov	ax,offset @codeseg:new00
	call	set_vect	; grab that vector!
	ret
.endp

.proc	rest00	auto		; restores int 00
	mov	bl,00		; int 00 is video bios
	mov	dx,old00+2	; get old segment
	mov	ax,old00	; get the old offset 
	mov	cx,ax
	or	cx,dx
	jz	r00ret
	call	set_vect	; set 'em back to orig state
r00ret:
	ret
.endp

.proc	new00	far		; tick, man
	sti			; re-enable ints
	mov	cs:cecode,-1
	.push	ax,bx,cx,dx,si,di,es
				; inc ticks
	sti
	mov	ax,3
	int	10h
	mov	ax,@dataseg
	mov	ds,ax		; make sure segment is correct
	call	rest08
	call	reset_ticks
	call	rest00
	call	reset9
	mov	ax,0b800h
	mov	es,ax
	xor	di,di
	mov	cx,2000
	mov	ax,0130h
	cld
	rep	stosw
	.pop	ax,bx,cx,dx,si,di,es
	mov	bp,5555h	; make a flag for error printout
	call	fillscr
	mov	ax,ax
	mov	ax,1
	pushf
	call	dword ptr cs:old00		; call the old divide ovfl rout
	jmp	exit		; return to dos

inflp:	jmp	inflp

	iret			; return to interrupted program
.endp
.proc	printpanic	auto	; print stuff on printer when requested by
				; user
	mov	bp,5555h	; this is to identify what junk is on the stack
	call	fillscr
here:	jmp	here		; halt computer
.endp

.proc	fillscr	auto
	push	bp
	push	ax
	push	bx
	push	cx
	push	dx
	push	di
	push	si
	mov	ax,[si+72]
	push	ax
	mov	ax,ss
	mov	es,ax
	mov	ax,sp
	mov	di,ax

	mov	cx,20
toutlp:	mov	ax,es:[di]
	mov	si,offset @dataseg:kbuf
	call	word_to_hex
	mov	bx,offset @dataseg:kbuf
	push	es
	push	di

	push	cx
	mov	cx,4
ttlp1:	
	mov	al,[bx]
;	xor	ah,ah
;	mov	dx,0
;	int	17h	; write byte to printer
	mov	dl,al
	mov	ah,2
	int	21h
	inc	bx
	loop	ttlp1
	mov	dl,0dh
	mov	ah,2
	int	21h
	inc	bx
	mov	dl,0ah
	mov	ah,2
	int	21h
	pop	cx
	pop	di
	inc	di
	inc	di
	pop	es
	loop	toutlp
	pop	ax
	pop	si
	pop	di
	pop	cx
	pop	dx
	pop	bx	
	pop	ax
	pop	bp
	ret
.endp
ENDIF
.ends






;=============================================================================
; Stack normalization and memory management initialization labels
;
; NOTE: These declarations must remain after the declaration of the stack
; and anything in the stack segment. These labels define the end of the
; stack and the program, which is where the near and far heaps are placed
; by default. These declarations do not affect the size of the program and
; may be left here even if the stack is not normalized and the heaps are
; not used.
;=============================================================================

.public		nheap_default, fheap_default
IF NOT __TINY__
.stackseg
  IF __SMALL__ OR __MEDIUM__
.public		stack_end		;used by START to normalize stack
.label		stack_end	word	;must be defined past entire stack
  ENDIF
.label		nheap_default	word	;used by the near heap
.label		fheap_default	word	;used by the far heap
.ends
ELSE
_BSSEND		segment	byte public 'STACK'
.label		nheap_default	word	;used by the near heap
.label		fheap_default	word	;used by the far heap
_BSSEND		ends
% @dataseg	group	_BSSEND
ENDIF




		end	start		;specify START as starting address
