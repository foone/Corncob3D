
	title	'strtexp'
;
;	these procedures create, mov, and evaluate actions of
;  timed objects created under the heading of timed objects
;
_MODEL	equ	<SMALL>

include model.inc
include	imath.INC
include f3dequ.inc
include		3dmac.inc
include ka.inc

alertdistance	equ	1200
warndistance	equ	1000
alarmdistance	equ	800

IF slalom
.extrn	radarstat:byte,oldradarstat:byte
.extrn	put_newline:auto
ENDIF
.extrn	
.extrn		omniflag:byte
.extrn		objdisp:word,tckgrav:word,objdamp:word,ndballs:word
.extrn	scos:auto,ssin:auto,atn2:auto
.extrn	mat2mul:auto
.extrn	calcsin:auto,ncalcmat:auto
.extrn	calcmat:auto
.extrn	nnzmat:word,norot:word,ctopv:word,dxvec:word,nzmat:word
.extrn		getang:auto
.extrn		rolpln:auto
.extrn		matvmul:auto
.extrn	dtopv:word
.extrn	randr_w:auto,rand_w:auto
.extrn		tbadd:auto
.extrn		tblist:auto
.extrn	crtrobj:word
.extrn	objflt1aa:word,objflt1aashell:word,gmobj1:word
.extrn	ox:word,oy:word,oz:word
.extrn	oxeff:word,oyeff:word,ozeff:word
.extrn	orvec:word,orveceff:word
.extrn	dorot:word
.extrn	dnrot:word
.extrn	ndest:word,ondest:word,gmdest:auto
.extrn	rel3d:auto,relobj5d:auto
.extrn	vmag:auto
.extrn	ofrmticks:word,ticksf:word
.extrn	divrs_dw:auto
.extrn	misyoff:word,bulyoff:word,deathcode:word
.extrn	n:byte,dsqrt:auto,radardot:auto,ejectflag:byte,demoflag:byte
.extrn	dballclr:byte,dbstclr:byte,aaclr:byte
IF slalom
.extrn	wingclr:byte
ENDIF
.extrn	oticks:word
.extrn	rtopv:word
.extrn	shrdclr:word
.extrn	shrdclr:word
.extrn	xvec:word,xvec1:word
.extrn	whlclr:byte,bodclr:byte,tmpltseg:word
.extrn	objflt1boom:word
.extrn	objflt2boom:word
.extrn	objflt3boom:word
.extrn	objflt1mis:word
.extrn	objflt2mis:word
.extrn	wword:auto,put_chr:auto,wcr:auto

.extrn	fltsm1:word,fltsm2:word,fltsm1boom:word,fltsm1dball:word
.extrn	fltsm1bomb:word
.extrn	fltsm1mis:word,fltsm1puff:word,fltsm1aa:word
.extrn	fltsm1aashell:word
.extrn	objdbst:word,objvech:word,objvest:word
.extrn	objincend:word
.extrn	objshard2:word
.extrn	objshard:word
.extrn	nulobj:word
.extrn	nplaneslost:word,ndballsdest:word,naasdest:word,patchcrash:word
.extrn	nvechsdest:word,nsitesdest:word,nhqsdest:word,norbsdest:word
.extrn	maxaaonme:word,maxdbonme:word
.extrn	missionstatus:word,closetowerflag:byte
.extrn	z0:word,bbclr:byte
.extrn	objtimtable:word,extendedtypetbl:word
.extrn	crtr:word
.extrn	getkbit:auto
.extrn	cecode:byte
.extrn	changewallobjs:auto,clrhqb:byte,clrfs1:byte,clrfs2:byte,clrhqc:byte
.extrn	clrfss1:byte,clrfss2:byte,clrhq:byte,lwallclr:byte
.extrn	clrlsph:byte
.extrn	cmpltflag:byte,startcoords:word
.extrn	objrv:word
.extrn	kbuf:byte,disteval:auto,clrshell:byte,clrbmr:byte,wallc:byte
.extrn	templatetable:word,alclr:byte,xpclr:byte,crtrclr:byte,vechantclr:byte
.extrn	clrup:byte,clrdn:byte,damageplane:auto,crshflg:byte
.extrn	flushtiles:auto,nplaced:word,resetplanesflag:byte
.extrn	actionflag:byte,readfileflag:byte,palmul:word
.extrn	haluclrs:word,distcolors:auto
.extrn	mapobjbuf:word,advflag:byte,capturedflag:byte
IF shareflag EQ 0
.extrn	lettercheck1:byte
ENDIF
.extrn	randspin:auto
.extrn	cleardamage:auto,restoreview:auto
.extrn	bombclr:byte
IF soundflag EQ 0
.extrn	voiceon:auto,voiceoff:auto,adlwrt:auto
.extrn	blamtick:word,b3oominit:auto
ENDIF
.extrn	rmsgqueue:word,cmpltrmsg:byte,cmpltdmsg:byte,totaldamage:word

.public		pufftim,boomtim,mistim,dballtim,flttim
.public		strtpuff,strtflt,strtdball,strtmis
.public		strtboom,objmov,expmov,aatim,strtaa,bombtim,strtbomb,crtrtim
.public		strtbomb1
.public		aashelltim,vechtim,strtvech
.public		shardtim,strtshard
.public		incendtim,strtincend,aafireprob,dbsttim,strtdbst
.public		expobj,nvechs
.public		vesttim,strtvest
.public	maxndballs,maxnvechs
.public		haltflag,rescueflag,haltox,walltim,lwalltim
.public		initialqual
.public		strtperm
.public		findexp
.public		exptr
.public		homedetect,initnumbers
.public		curndballs,curnticks,maxnrvs
.public	cleanexp
.public	bbtim,bbsmtim,mortim,dhqtim,hqtim
.public	ndeadhqs,curndeadhqs,printexp
.public	nflt,rescuestart,shelltim,bmrtim,bmrstim
.public	bdest,dballlock,tettim,altim,stettim,tripflag,tripamount
.public	xpflag
.public	xptim
.public	ntets,hqtbl,getqtblptr,attractplane
.public	nbmrs,nbmrst
.public dballprog,aaprog,rollprog
.public	nkillmetough
.public	bigboom,saucerdist,ssfreq,kladist,klaqual,orbdist,orbfreq,makeboom

.public incondest
bombkvalue	equ	4630

.public	exps,expsrmvd

.dataseg
xpflag		db	0
tripflag	db	0
tripamount	dw	0
rvstartcoords	dw	0,0,0,0
haltflag	db	0
rescueflag	db	0
haltox		dw	6 dup(?)
oldobjptr	dw	?
exptr	dw	@dataseg:exps
exps	dw	nexps*nbytexp/2 dup(0)
eptrmx	dw	0
expobj	dw	?
exprand	dw	1500
expsrmvd	dw	0
bmrdespit	dw	0
initialqual	dw	0	; for starting routines, this sets quality
qtblptr	dw	?		; place to save ptr to qtable entry
dbstrest	dw	400
flttype		db	0	; this is three during a mortor firing
mortfiredist	dd	130000000
saucerflag	db	0	; non-zero means aa is a saucer

curnticks	dw	1
maxnticks	dw	1
curndbst	dw	?	; the number of current sites for dballs
curnvest	dw	?	; the number of curretn sites for vechs
curnrvs		dw	0
maxnrvs		dw	0

bmrmode		dw	0
bmrmodecprob	dw	0
bmrtargdist	dw	0
bhits		db	0	
curnbmrs	dw	0
nbmrs		dw	0
curnbmrst	dw	0
nbmrst		dw	0
nals		dw	0
curnals		dw	0
maxnals		dw	0
curnstets	dw	0
curntets	dw	0
nstets		dw	0
ntets		dw	0

IF slalom
distclosest	dw	0
ENDIF

bmdtbl		dw	@codeseg:famode
		dw	@codeseg:circmode
		dw	@codeseg:atkmode
		dw	@codeseg:slmode

dballqtbl	dw	12		; table of qualities for dballs
		dw	6,9
		dw	50,50,60,800,550,550,31,1500,16384,800
		dw	6,14
		dw	50,50,120,1100,800,550,31,1000,16384,900
		dw	6,15
		dw	70,70,120,800,650,250,31,1000,16384,1000
		dw	7,9
		dw	90,90,120,800,650,50,81,500,16384,1200
		dw	7,14
		dw	90,90,120,900,750,250,11,500,16384,1300
		dw	7,15
		dw	100,100,180,1200,800,550,11,500,16384,1400
		dw	1,14
		dw	120,120,120,1000,750,250,21,200,16384,1500
		dw	1,15
		dw	150,150,60,1200,825,250,11,500,8192,1700

dbstqtbl	dw	3		; table of qualities for dballsites

		dw	6,9,400
		dw	6,14,400
		dw	6,15,400
		dw	7,9,400
		dw	7,14,400
		dw	7,15,400
		dw	1,14,400
		dw	1,15,400

aaqtbl		dw	6
		dw	6
		dw	500,100,30,30,0
		dw	5
		dw	1000,50,50,50,0
		dw	7
		dw	1000,50,50,50,0
		dw	7
		dw	1500,30,50,50,-1
		dw	3
		dw	1500,30,50,50,-1
		dw	3
		dw	2000,30,70,70,-1
		dw	15
		dw	3000,10,120,120,-1
		dw	15
		dw	4000,10,500,500,-1


alqtbl 	dw	4
		dw	5,3,50,50
		dw	3,3,50,100
		dw	6,2,30,75
		dw	7,2,50,75
		dw	4,1,50,100
		dw	13,3,150,150
		dw	14,2,100,200
		dw	15,3,500,300

lwallqtbl 	dw	1
		dw	5
		dw	3
		dw	6
		dw	7
		dw	4
		dw	14
		dw	15
		dw	-1

wallqtbl 	dw	1
		dw	6+10h
		dw	3
		dw	6
		dw	7
		dw	4
		dw	13
		dw	14
		dw	15

xpqtbl		dw	4
		dw	11,11+10h,1,0		; takes us back to base
		dw	3,9+10h,255,0		; takes us to random place
		dw	12,11+10h,1,1		; takes to base, but damages us
		dw	0,11+10h,1,-1		; kills us instantly
		dw	11,11+10h,101h,0	; takes us to base, fufills mis
		dw	11,11,1,1		; takes to base, but no flashs
		dw	7,11+10h,0,2		; repairs plane, doesn't xpose
		dw	10,3,100h,0		; doesn't move us, miss obj

vestqtbl	dw	2
		dw	7,150
		dw	7,200
		dw	7,200
		dw	7,200
		dw	3,200
		dw	3,300
		dw	3,300
		dw	15,300

vechqtbl	dw	9
		dw	7,6
		dw	250,100,6000,8000,500,6553/300,15
		dw	7,6
		dw	300,150,6000,8000,500,6553/600,65
		dw	7,1
		dw	300,200,6000,8000,500,6553/900,120
		dw	7,0
		dw	300,300,6000,8000,500,6553/300,50
		dw	3,6
		dw	400,400,5000,32000,300,6553/600,70
		dw	3,1
		dw	500,450,7000,32000,200,6553/333,40
		dw	3,0
		dw	700,600,1000,32000,2000,6553/1600,50
		dw	15,0
		dw	800,600,2000,32000,3000,6553/600,65


bbqtbl	dw	4
	dw	0,150,10,2000
	dw	6,200,20,2000
	dw	7,200,40,2000
	dw	3,250,80,2000
	dw	9,350,160,2000
	dw	13,500,320,2000
	dw	11,600,60,2000
	dw	2,800,500,1000


IF slalom
bmrstqtbl	dw	4
		dw	0,150,150,150
		dw	0,150,150,150
		dw	0,150,150,150
		dw	0,150,150,150
		dw	0,150,150,150
		dw	0,150,150,150
		dw	0,150,150,150
		dw	0,150,150,150
ELSE
bmrstqtbl	dw	3		; table of qualities for bmrsites

		dw	0,15,400
		dw	6,14,400
		dw	6,15,400
		dw	7,9,400
		dw	7,14,400
		dw	7,15,400
		dw	1,14,400
		dw	1,15,400
ENDIF


hqtbl	dw	2
	dw	0,@codeseg:killme
	dw	6,@codeseg:killticks
	dw	7,@codeseg:killdbaa
	dw	3,@codeseg:killvechs
	dw	9,@codeseg:killmetough
	dw	13,@codeseg:killbmrst
	dw	4,@codeseg:killstets
	dw	14,@codeseg:killal

shellqtbl	dw	3		; table of qualities for dballsites
		dw	13,0,6		; vech stite
		dw	42,6,7		; mortar
		dw	11,7,3		; dball site
		dw	23,3,9		; aa site
		dw	40,9,13		; barrage balloon
		dw	41,13,11		; bee swarm
		dw	27,11,0		; a tick
		dw	23,2,2		; 0= random

bmrqtbl	dw	14		; table of qualities for dballs
		dw	0,15
		dw	10,0,13,0,200,5,31,5,5,300,0,0
		dw	6,14
		dw	30,1,30,1,200,5,31,30,30,300,10,2+256
		dw	6,15
		dw	30,5,30,5,200,40,31,5,10,300,10,3
		dw	7,9
		dw	15,20,15,20,200,70,81,70,5,300,30,4+256
		dw	7,14
		dw	10,40,10,50,200,30,11,15,100,300,40,4
		dw	7,15
		dw	24,80,10,60,200,100,11,50,30,300,50,5+256
		dw	1,14
		dw	24,160,5,60,200,100,21,100,100,500,100,6
		dw	1,15
		dw	10,150,15,30,200,100,11,200,200,1000,300,7+256
		

saucerdist	dw	256
ssdist		dw	255
ssfreq		db	0ffh
kladist		dw	64
klaqual		db	0
orbdist		dw	63
orbfreq		db	0ffh
dballvector	dw	0,0,0		; vector of origin to dball
nflt		dw	0		; number of flotsom onscreen
maxnflt		dw	25		; maximum number of flotsum
naa		dw	0
ndeadhqs	dw	0		; have we killed a local orb?
nhqs		dw	0
curnhqs		dw	0
curndeadhqs	dw	0		; well, speak up!
nvechs		dw	0
maxnvechs		dw	10
dballvel	dw	1		; start them out from rest
olddballvel	dw	1
aashellvel	dw	1500		; relatively fast shells
vechrest	dw	300		; waiting time for vech refueling
vechtime	dw	10000
vechvel		dw	300		; about 100 mph
vechresetprob	dw	600		; every 100 frames
vechtrakprob	dw	6000		; make about 1/8
nkillmetough	dw	0		; how many kmt's we've destroyed
cratertime	dw	3000		; make them last a few minutes
cratertimem1	dw	3000		; make them last a few minutes
dballdist	dw	100		; distance from plane
dballavgvel	dw	620		; average dball velocity
dblockang	dw	500		; angle which qualifies as a lock
dbstopang	dw	16384		; 90 degrees
dbmaxang	dw	0		; largest angle dball is off by
dballcrnr	dw	120
ndballcrnr	dw	-120
dballlock	dw	0		; temp location
dbnlocks	db	0		; 0 = no lock, n=#locks
maxndballs	dw	6		; we only want 6 in the air at once
tcurndballs	dw	8 dup (?)
lasttick	dw	0
addprogflag	db	0

dballprog	dw	0,0		; double number to keep dball evasiv
aaprog		dw	0,0		; double number to keep dball evasiv
rollprog	dw	0

dballsum	dw	0
aasum		dw	0
newdballsum	dw	0
newaasum		dw	0
curndballs	dw	0 
curnvechs	dw	?
tcurnaa		dw	8 dup (?)
curnaas		dw	0
naas		dw	0
aalockang	dw	500		; angle which qualifies as a lock
aalock	db	0		; temp location
aanlocks	db	0		; 0 = no lock, n=#locks
aafireprob	dw	3000
expzrand	dw	5000
aacrnr		dw	200
naacrnr		dw	-200

boomdeadly	db	20h	; if 20h, deadly boom, if not, harmless

boomcnt		dw	0
bboomcnt		dw	0

.ends

.codeseg

;assume		cs:@codeseg, 
		assume ds:@dataseg, es:@dataseg

IF slalom
.proc	xymag	auto		; gets magnitude of xy vector in ax,bx
	.abs_w	ax
	mul	ax		; square x
	xchg	bx,ax
	mov	cx,dx
	.abs_w	ax
	mul	ax
	add	ax,bx		; add the sqaures
	adc	dx,cx
	call	dsqrt		; take square root
	ret			; and leave in ax
.endp	

.proc calcdist auto
	mov	dx,[si+2]
	mov	ax,[si]
	.sub_dd	dx,ax,oxeff+2,oxeff
	.abs_d	dx,ax
	test	dx,0ffc0h
	jnz	toobig1
	mov	bl,ah
	mov	bh,dl	; divide by 256

	mov	dx,[si+6]
	mov	ax,[si+4]
	.sub_dd	dx,ax,oyeff+2,oyeff
	.abs_d	dx,ax
	test	dx,0ffc0h
	jnz	toobig1


	mov	al,ah
	mov	ah,dl	; divide by 256

	call	xymag	; find magnitude of
	ret

toobig1:
	mov	ax,07ffh
	ret
.endp

.proc	frmupdatecldst	auto
	push	di
	push	si
	pushf
	jc	skipudistc
	call	calcdist
	cmp	ax,7fffh
	jz	skipudistc

	add	ax,ozeff+1
	add	ax,alarmdistance/3	; make farmhouse a much closer thing

	cmp	ax,distclosest
	ja	skipfdistc
	mov	distclosest,ax
skipfdistc:	
	popf
	pop	si
	pop	di
	ret
.endp

.proc	updatecldst	auto
	push	di
	push	si
	pushf
	jc	skipudistc
	call	calcdist
	cmp	ax,7fffh
	jz	skipudistc

	push	ax
	mov	dx,ozeff+2
	mov	ax,ozeff
	.subs_dd dx,ax,[si+10],[si+8]
	.abs_d	dx,ax
	mov	bl,ah
	mov	bh,dl
	pop	ax
	add	ax,bx

	cmp	ax,distclosest
	ja	skipudistc
	mov	distclosest,ax
skipudistc:	
	popf
	pop	si
	pop	di
	ret
.endp

.proc	rdrupdatecldst	auto
	push	di
	push	si
	pushf
	jnc	rdrupev
skip1distc:
	jmp	skipdistc
rdrupev:
	call	calcdist
	cmp	ax,7fffh
	jz	skip1distc
	mov	cx,ax		; save original distance in cx
			; radar is 2x more powerful than farmhouses
	shr	ax,1
	cmp	ax,alertdistance	; see if possible to be spotted
	ja	skip1distc
				; but now we have to see we are within the
				; warning cone  r<16z

	mov	bx,ax		; leave default distance code
	mov	di,ax		; and also save in di register
;	jmp	coneruled
	mov	dx,ozeff+2
	mov	ax,oz
	test	dx,0fff0h	; check for over 40,000 feet
	jnz	skiphigh

				; since cx holds r << 8  we can get 16 x z
				; with z << 4
	rept	5
	shr	dx,1
	rcr	ax,1
	endm
				; r<16z for alert distance

	cmp	ax,cx		; is this bigger than original r?

	jb	skiphigh	; if not, then radar can't see us
				; we are too low
	mov	dx,ax		; multply z times 1.5
	add	dx,ax
	add	dx,ax		; ax*3
	shr	dx,1		; ax*3/2
	cmp	dx,cx		; is this bigger than z*1.5?
	jb	skipalert	; if alert, then do so

	shr	cx,1		; downsize r by two
				; if r<8z then full alarm
	cmp	ax,cx		; is this bigger than z*1.5?
	jb	skipwarning	; if alert, then do so

	mov	bx,alarmdistance-1	; mark as alarm distance


	jmp	conedone
skipwarning:			; if we end up here, mark distance as warning
	mov	bx,warndistance-1
	jmp	conedone
skipalert:			; if we end up here, mark distance as warning
	mov	bx,alertdistance-1
	jmp	conedone
skiphigh:
	mov	bx,07fffh	; too high, so report as uselessly hight
conedone:
	mov	ax,bx		; ax now has our corrected distance
	cmp	ax,7fffh	; if got this code, skip dist check
	jz	skipdistc	
				; ok, now take the bigger of the cone distance
				; modifier, or the real distance code
	cmp	ax,di	
	ja	coneruled
	mov	ax,di		; I guess we are far away and dist is important
coneruled:


	cmp	ax,distclosest
	ja	skipdistc
	mov	distclosest,ax
skipdistc:	
	popf
	pop	si
	pop	di
	ret
.endp

ENDIF

.proc	bigboom	auto
IF soundflag EQ 0
		mov	ax,cs:oticks
		mov	bx,ax
		sub	ax,bboomcnt
		cmp	ax,512
		jb	nobboom
		mov	bboomcnt,bx
		mov	al,20h
		mov	bl,0bdh
		call	adlwrt
		mov	al,30h
		mov	bl,0bdh
		call	adlwrt
nobboom:
ENDIF
		ret
.endp


.proc	makeboom	auto
IF soundflag EQ 0
		mov	ax,blamtick
		or	ax,ax	; is voice still being used for blam?
		jz	noblams
		cmp	ax,-1
		jnz	runblamdown
justhome:
		ret
runblamdown:
		mov	bx,cs:oticks
		sub	bx,ax
		cmp	bx,512
		jb	justhome
		call	b3oominit
noblams:
		mov	ax,cs:oticks
		mov	bx,ax
		sub	ax,boomcnt
		cmp	ax,512
		jb	noboomr
		mov	boomcnt,bx
		mov	bl,2
		call	voiceoff
		mov	bl,2
		mov	ax,0h
		call	voiceon
noboomr:
ENDIF
		ret
.endp

.proc	resetnplaced	auto		; sets the base number of planes
	mov	nplaced,0
	cmp	actionflag,0
	jnz	nooverlay
	cmp	readfileflag,0;			; make sure we don't overlay
	jnz	nonisthere			; the plane ontop of the user
nooverlay:
	mov	nplaced,1			; number of placed planes=0
nonisthere:
	ret
.endp

.proc	cleanexp
	call	resetnplaced	; do this for the good of mankind
	mov	si,exptr	; get current pointer
	mov	cx,nexps	; don't loop thru more than once
	mov	si,offset @dataseg:exps
cfexpl1:
;	cmp	word ptr [si+24],0	; see if this bullet is active
;	jnz	cnotfree		; found one!
	mov	word ptr [si+24],0
	mov	byte ptr [si+18],-1
cnotfree:
	add	si,nbytexp	; if not, goto next bullet
	cmp	si,offset @dataseg:eptrmx
				; but be careful not to go off the end
	js	ceptrok		; looks ok from here...
	jz	ceptrok
	mov	si,offset @dataseg:exps
ceptrok:	
	loop	cfexpl1		; try again
	stc			; set error flag
	ret
.endp

.proc	printexp
	mov	si,exptr	; get current pointer
	mov	cx,nexps	; don't loop thru more than once
	mov	si,offset @dataseg:exps
pfexpl1:
	mov	ax,[si+24]
	call	wword
	mov	ax,[si+18]
	call	wword
	mov	ax,[si+72]
	call	wword
	mov	al,2eh
	call	put_chr
	add	si,nbytexp	; if not, goto next bullet
	cmp	si,offset @dataseg:eptrmx
				; but be careful not to go off the end
	js	peptrok		; looks ok from here...
	jz	peptrok
	mov	si,offset @dataseg:exps
peptrok:	
	mov	ax,cx
	and	ax,3
	jnz	nowcr
	call	wcr
nowcr:
	loop	pfexpl1		; try again
	stc			; set error flag
	ret
.endp

.proc	findexp	auto		; finds next avail bullet in system
	mov	si,exptr	; get current pointer
	mov	cx,nexps	; don't loop thru more than once
	mov	si,offset @dataseg:exps
fexpl1:	cmp	word ptr [si+24],0	; see if this bullet is active
	jnz	notfree
	mov	al,byte ptr [si+18]	; get distance code
	or	al,al
	js	expfree		; found one!
;	inc	byte ptr [si+18]	; avoid totally dead objects
notfree:
	add	si,nbytexp	; if not, goto next bullet
	cmp	si,offset @dataseg:eptrmx
				; but be careful not to go off the end
	js	eptrok		; looks ok from here...
	jz	eptrok
	mov	si,offset @dataseg:exps
eptrok:	
	loop	fexpl1		; try again
	stc			; set error flag
	ret
expfree:
	mov	exptr,si	; save back into variable
	clc			; reset error flag
	ret
	.endp

.proc	expstrt	auto
	call	findexp		; try to find bullet
	jnc	nexpero		; error, no free bullets
	stc
expero:	ret
nexpero:
	mov	ax,ds		; transfer from chosen object
	mov	es,ax
	mov	di,si
	mov	cx,nbytexp	; number of bytes to move
	push	si		; save ptr to object
	mov	si,expobj	; load source of object template address
	cld			; make sure direction flag is correct
	push	ds
	mov	ax,tmpltseg
	mov	ds,ax
	rep	movsb
	pop	ds
	pop	si
	clc
	ret
.endp

.proc	objmov	auto			; moves an object pointed to by
					; si
;	mov	ax,objdisp
;	call	wword
;	mov	ax,objdamp
;	call	wword
;	mov	ax,tckgrav
;	call	wword
;	call	exit_ok
	mov	al,[si+26]		; if non zero, then apply rotation
	or	al,al
	jz	nrotv			; forget rotation
	mov	ax,[si+54]
	add	[si+12],ax		; increment angle
	mov	ax,[si+56]
	add	[si+14],ax		; increment angle
	mov	ax,[si+58]
	add	[si+16],ax		; increment angle
nrotv:
	mov	bx,objdisp
	mov	ax,bx			; start with ax 0 if no dispersion
	or	bx,bx
	jz	obm0
	call	randr_w
	shr	bx,1
	jnc	obmrnd0
	inc	bx			; round evenly, so remainder is 
obmrnd0:				; must be considered	
	sub	ax,bx
obm0:	mov	bx,objdamp		; dampen velocity with air resistance
	or	bx,bx			; check for no damping
	jz	obmlb0
	add	ax,[si+46]
	mov	[si+46],ax
	pushf				; save flags for sign decision
	mov	dx,ax
	imul	dx
	div	bx
	popf
	js	obmlb0
	neg	ax
obmlb0:
	add	ax,[si+46]
	mov	[si+46],ax
	cwd
	dwtadj
	add	[si],ax
	adc	[si+2],dx
	mov	bx,objdisp
	mov	ax,bx
	or	ax,ax
	jz	obm1
	call	randr_w
	shr	bx,1
	jnc	obmrnd1
	inc	bx			; round evenly, so remainder is 
obmrnd1:				; must be considered	
	sub	ax,bx
obm1:	mov	bx,objdamp		; dampen velocity with air resistance
	or	bx,bx			; check for no damping
	jz	obmlb1
	add	ax,[si+48]
	mov	[si+48],ax
	pushf				; save flags for sign decision
	mov	dx,ax
	imul	dx
	mov	bx,objdamp		; dampen velocity with air resistance
	div	bx
	popf
	js	obmlb1
	neg	ax
obmlb1:
	add	ax,[si+48]
	mov	[si+48],ax
	cwd
	dwtadj
	add	[si+4],ax
	adc	[si+6],dx
	mov	bx,objdisp
	mov	ax,bx
	or	ax,ax
	jz	obm2
	call	randr_w
	shr	bx,1
	jnc	obmrnd2
	inc	bx			; round evenly, so remainder is 
obmrnd2:				; must be considered	
	sub	ax,bx
obm2:	mov	bx,objdamp		; dampen velocity with air resistance
	or	bx,bx			; check for no damping
	jz	obmlb2
	add	ax,[si+50]
	mov	[si+50],ax
	pushf				; save flags for sign decision
	mov	dx,ax
	imul	dx
	mov	bx,objdamp		; dampen velocity with air resistance
	div	bx
	popf
	js	obmlb2
	neg	ax
obmlb2:
	add	ax,[si+50]
	mov	[si+50],ax
	mov	bx,ax
	mov	ax,tckgrav		; subtract gravity effect
	cmp	tckgrav,55		; if 55, don't applt
	jz	dontadjust
	wtadj
dontadjust:
	sub	bx,ax
	mov	ax,bx
	cmp	tckgrav,55		; if 55, don't applt
	jz	badkludge
	mov	[si+50],ax
badkludge:
	
	cwd
	dwtadj
	add	[si+8],ax
	adc	[si+10],dx
;	jmp	obmlb3

	jns	obmlb3
	cmp	word ptr [si+50],0	; if zvel is zero, don't move obj
	jz	obmlb3
	xor	ax,ax
	mov	[si+8],ax
	mov	[si+10],ax
	mov	ax,ds
	mov	es,ax
	mov	di,si
	add	di,46
	push	cx
;	mov	cx,7		; zero out all seven parameters
	mov	cx,3
	xor	ax,ax
	cld
	rep	stosw
	cmp	byte ptr [si+26],0
	jz	obmlb4
	add	di,2		; skip over item 52
	mov	cx,6		; zero out the three angles
	rep	stosw		; and the gravity, dispersion and damping
obmlb4:
	pop	cx
	stc
	ret				; set carry for error
obmlb3:
	clc
	ret
.endp


.proc	expmov	auto
	mov	si,offset @dataseg:exps
	mov	cx,nexps
	or	cx,cx
	jnz	expsag
	jmp	noexps
expsag:	
expmlp:
	test	word ptr [si+24],8000h	; is this object primed for creation?
	jz	noeprm
	and	word ptr [si+24],07fffh	; make into a real object
	mov	al,byte ptr [si+18]	; get proper table to be in
	and	ax,3			; dist code is zero thru 3
	add	ax,ax			; form an address for table
	push	si
	push	cx
	mov	bx,si			; prepare for tbadd call
	mov	si,offset @dataseg:tblist
;	add	si,ax			; point to correct table
	mov	si,[si]			; add to near table list
	call	tbadd
	pop	cx
	pop	si
noeprm:
	cmp	z0,0			; don't move object
	jnz	expml0
	cmp	word ptr [si+24],0
	jz	expml0
	cmp	word ptr [si+52],0	; see if bullet has run out
	js	expkil
	jz	expkil
	dec	word ptr [si+52]
	mov	ax,[si+60]
	mov	objdisp,ax
	mov	ax,[si+62]
	mov	objdamp,ax
	mov	ax,[si+64]
	xor	ah,ah			; only lower byte has gravity
	mov	tckgrav,ax
	call	objmov			; move object
expml0:	
	add	si,nbytexp
	loop	expmlp
noexps:	ret
expkil:	
	cmp	byte ptr [si+65],0
	jz	noboom
	push	si
	push	cx
	mov	boomdeadly,20h		; make deadly
	call	strtboom		; explode the killed piece
	pop	cx
	pop	si
noboom:	mov	word ptr [si+24],0
	jmp	expml0
	.endp


.proc	strtflt	auto		; starts a flotsom object, and lets it rip
;	mov	bx,12
	mov	ax,bx
	cmp	flttype,3
	jz	nofltrand
	shr	bx,1
	mov	dx,bx
	call	randr_w
	add	ax,dx		; make sure at least half get tried
	inc	ax		; count must be at least one...
nofltrand:
	mov	cx,ax		; random number of objects
strflp:	

	mov	ax,nflt		; find number of flotsom
	add	ax,cx		; add in the number requested
	cmp	ax,maxnflt	; make sure there isn't too much already
	jb	nfltok
	cmp	cx,26
	jb	notcrit
	mov	cs:cecode,163	; outlandish # of flots requested
notcrit:
	jmp	sfltok
nfltok:
	push	cx
	push	si		; save the target object
	mov	di,offset @dataseg:fltsm1	; address of flotsom object
	mov	bx,4000
	call	randr_w
	mov	[di+48],ax	; put a little random spin on the object
	cmp	flttype,3
	jz	forcetype2	; if shot from a mortor, only have type 2
	call	rand_w
	or	ax,ax
	js	strtlb0
forcetype2:
	mov	di,offset @dataseg:fltsm2	; address of flotsom object
strtlb0:
	mov	expobj,di
	call	expstrt				; start the object
	jnc	expstrtok
	pop	si
	pop	cx
	jmp	strexit
expstrtok:
	mov	expobj,si		; save ptr to our new object
	mov	di,si
	pop	si
	push	si
	mov	ax,ds		; xfer the object's origin to the new object
	mov	es,ax
	mov	cx,6		; twelve bytes for position
	cld
	rep	movsw
	pop	si
	push	si
	mov	di,expobj	; restore addresses of object begginings
	add	[di+8],750	; lift off the ground
	add	si,46		; point to velocities
	add	di,46		; point to velocities
	mov	cx,3
	cld
	rep	movsw
	pop	si
	push	si
	mov	di,expobj	; restore addresses of object begginings
	mov	bx,exprand
	call	randr_w		; add random number to velocities
	sar	bx,1
	sub	ax,bx
	add	[di+46],ax	; give vel some pep
	mov	bx,exprand
	call	randr_w		; add random number to velocities
	sar	bx,1
	sub	ax,bx
	add	[di+48],ax	; give vel some pep
	cmp	omniflag,0	; is this an omni explosion?
	jnz	omniexp
	mov	bx,expzrand
	call	randr_w		; add random number to velocities
				; make z vel addition positive
	jmp	omniexp2
omniexp:
	mov	bx,exprand
	call	randr_w		; add random number to velocities
	sar	bx,1
	sub	ax,bx
omniexp2:	
	add	[di+50],ax	; give vel some pep
	xor	ax,ax			; set distance to near
	mov	[di+18],al
	mov	bx,exptime	; get time for object to last
	cmp	omniflag,0	; is this an omni explosion?
	jz	omnitlb
	mov	bx,omnitime	; time for an omni explosion to last
omnitlb:
	mov	ax,bx		; relatavize for machine speed
	uwtadj
	mov	bx,ax
	call	randr_w
	sar	bx,1
	sar	bx,1
	add	ax,bx		; give at least 1/4 the apointed time
	mov	[di+52],ax
	mov	si,di
	or	word ptr [si+24],08000h	; make a timed object
	mov	al,flttype	; make it the correct type of flotsom
	mov	byte ptr [si+19],al
	cmp	al,3
	jnz	leaveharmless1	; if mortar, make object harmful to plane
	or	word ptr [si+24],30h	; set the bits of harm
	mov	byte ptr [si+65],1	; make into wicked boom death
leaveharmless1:
	pop	si
	pop	cx
	loop	strflpa
sfltok:	clc
	ret
strflpa:	
	jmp	strflp
strexit:
	stc				; sumthin went wrong
	ret				; attempt failed, abort whole idea
	.endp

.proc	flttim	auto		; routine for what flotsom does
	jnc	nofltdie
flt2hell:
	mov	ax,nflt		; keep track of death
	dec	ax
	jns	nflttool1
	xor	ax,ax
nflttool1:
	mov	nflt,ax
	cmp	byte ptr [si+19],3	; are we a mortar thingy?
	jnz	fltret1
	push	si
	push	di
	mov	boomdeadly,20h		; make deadly
	call	strtboom		; do a boom
	pop	di
	pop	si
	mov	word ptr [si+24],0	; remove from the universe
fltret1:
	ret			; nothing for now
nofltdie:
	cmp	word ptr [si+10],0
	jnz	fltret1
	cmp	word ptr [si+8],0
	jnz	fltret1
	mov	word ptr [si+24],0	; cancel object when it hits ground
	ret
IF 1 EQ 0
	cmp	byte ptr [si+19],3	; are we a mortar thingy?
	jnz	fltret1
	mov	dx,[si+10]		; check if we are same ht as plane
	mov	ax,[si+8]
	cmp	dx,oxeff+10		; is top part the same?
	jnz	fltret1			; no, so don't explode
	sub	ax,oxeff+8
	cmp	ax,[si+66]		; compare it to the blast radius
	jb	fltret1
	jmp	flt2hell		; blow us up!
ENDIF
.endp

.proc	strtincend	auto	; starts a flotsom object, and lets it rip
	mov	cx,bx		; not random number of objects
strflp2:	
	push	cx
	push	si		; save the target object
	mov	di,offset @dataseg:objincend	; address of flotsom object
	mov	expobj,di
	call	expstrt				; start the object
	jnc	expstrtokinc
	pop	si
	pop	cx
	jmp	strexit1
expstrtokinc:
	mov	expobj,si		; save ptr to our new object
	mov	di,si
	pop	si
	push	si
	mov	ax,ds		; xfer the object's origin to the new object
	mov	es,ax
	mov	cx,6		; twelve bytes for position
	cld
	rep	movsw
	pop	si
	push	si
	mov	di,expobj	; restore addresses of object begginings
	add	[di+8],750	; lift off the ground
	add	si,46		; point to velocities
	add	di,46		; point to velocities
	mov	cx,3
	cld
	rep	movsw
	pop	si
	push	si
	mov	di,expobj	; restore addresses of object begginings
	mov	bx,1200
	sar	bx,1
	sar	bx,1
	call	randr_w		; add random number to velocities
	sar	bx,1
	sub	ax,bx
	mov	[di+46],ax	; give vel some pep
	mov	bx,1200
	sar	bx,1
	sar	bx,1
	call	randr_w		; add random number to velocities
	sar	bx,1
	sub	ax,bx
	mov	[di+48],ax	; give vel some pep
	mov	bx,1200
	call	randr_w		; add random number to velocities
				; make z vel addition positive
	mov	[di+50],ax	; give vel some pep
	xor	ax,ax			; set distance to near
	mov	[di+18],al
	mov	ax,150		; live for 150 frames
	uwtadj
	mov	word ptr [di+52],ax
	mov	si,di
	or	word ptr [si+24],08000h	; make a timed object
	mov	bx,4000
	call	randr_w
	mov	[si+54],ax
	call	randr_w
	mov	[si+56],ax
	call	randr_w
	mov	[si+58],ax
	pop	si
	pop	cx
	loop	strflpa2
	clc
	ret
strflpa2:	
	jmp	strflp2
strexit2:
	stc				; sumthin went wrong
	ret				; attempt failed, abort whole idea
	.endp

.proc	strtshard	auto	; starts a flotsom object, and lets it rip
	shr	bx,1
	mov	dx,bx
	call	randr_w
	add	ax,dx		; make sure at least half get tried
	inc	ax		; count must be at least one...
	mov	cx,ax		; random number of objects
strflp1:	
	push	cx
	push	si		; save the target object
	mov	di,offset @dataseg:objshard	; address of flotsom object
	call	rand_w
	or	ax,ax
	js	shrdlb0

	mov	di,offset @dataseg:objshard2	; address of flotsom object
shrdlb0:
	mov	expobj,di
	call	expstrt				; start the object
	jnc	expstrtokshrd
	pop	si
	pop	cx
	jmp	strexit1
expstrtokshrd:
	mov	expobj,si		; save ptr to our new object
	mov	di,si
	pop	si
	push	si
	mov	ax,ds		; xfer the object's origin to the new object
	mov	es,ax
	mov	cx,6		; twelve bytes for position
	cld
	rep	movsw
	pop	si
	push	si
	mov	di,expobj	; restore addresses of object begginings
	add	[di+8],750	; lift off the ground
	add	si,46		; point to velocities
	add	di,46		; point to velocities
	mov	cx,3
	cld
	rep	movsw
	pop	si
	push	si
	mov	di,expobj	; restore addresses of object begginings
	mov	bx,exprand
	sar	bx,1
	sar	bx,1
	call	randr_w		; add random number to velocities
	sar	bx,1
	sub	ax,bx
	add	[di+46],ax	; give vel some pep
	mov	bx,exprand
	sar	bx,1
	sar	bx,1
	call	randr_w		; add random number to velocities
	sar	bx,1
	sub	ax,bx
	add	[di+48],ax	; give vel some pep
	cmp	omniflag,0	; is this an omni explosion?
	jnz	omniexpshrd
	mov	bx,1500
	call	randr_w		; add random number to velocities
				; make z vel addition positive
	jmp	omniexp2shrd
omniexpshrd:
	mov	bx,exprand
	call	randr_w		; add random number to velocities
	sar	bx,1
	sub	ax,bx
omniexp2shrd:	
	add	[di+50],ax	; give vel some pep
	xor	ax,ax			; set distance to near
	mov	[di+18],al
	mov	bx,exptime	; get time for object to last
	cmp	omniflag,0	; is this an omni explosion?
	jz	omnitlbshrd
	mov	bx,omnitime	; time for an omni explosion to last
omnitlbshrd:
	mov	[di+52],6200	; let them sit for about 5 min
	mov	si,di
	or	word ptr [si+24],08000h	; make a timed object
	mov	bx,4000
	call	randr_w
	mov	[si+54],ax
	call	randr_w
	mov	[si+56],ax
	call	randr_w
	mov	[si+58],ax
	pop	si
	pop	cx
	loop	strflpa1
	clc
	ret
strflpa1:	
	jmp	strflp1
strexit1:
	stc				; sumthin went wrong
	ret				; attempt failed, abort whole idea
	.endp

.proc	incendtim	auto
	pushf				; save cry
	cmp	word ptr [si+50],40
	ja	leaveharmless
;	or	word ptr [si+24h],8h	; make destructable after a little bit
leaveharmless:
	popf
	jc	incendbang		; do we blow up now?
	cmp	word ptr [si+8],0
	jnz	letflyinc
incendbang:
	push	si
	push	di
	mov	boomdeadly,20h		; make deadly
	call	strtboom		; do a boom
	pop	di
	pop	si
	push	si
	push	di			; reset registers
	mov	bx,3			; three pieces
	mov	omniflag,0		; all around explosion
	call	strtflt		; do a boom
	pop	di
	pop	si
	mov	word ptr [si+24],0	; cancel object
	ret
letflyinc:				; live and let fly if still in air
	ret
.endp

.proc	shardtim	auto
	jnc	shardalive
	mov	word ptr [si+24],0	; just make shard disappear
	ret
shardalive:
	cmp	word ptr [si+8],0
	jnz	letfly
	mov	shrdclr,0		; turn them black on the ground
	ret
letfly:					; live and let fly if still in air
	mov	ax,si
	sub	ax,offset @dataseg:exps
	cwd
	mov	bx,nbytexp
	idiv	bx
	and	ax,3			; look at two lower bits of obj #
	jz	flamclr			; if zero, then make flame color
	mov	shrdclr,0
	ret
flamclr:
	mov	bx,2
	call	randr_w
	shl	ax,1
	add	ax,0ch			; make it oscillate from red to wht
	mov	shrdclr,ax
	ret
.endp

.proc	getobsvec	auto	; find out position of observer, put in vector
	cmp	ejectflag,0		; if pilot has ejected, go for the plane
	jz	normrel3d
	call	relobj5d
	jmp	reload			; it's a kludge, but that's life
obstofar:
	stc				; too far, leave flag and exit
	ret
normrel3d:
	call	rel3d			; get dxvector to point the way
reload:
	jc	obstofar		; too far away
	or	ch,ch			; if cx is zero, then too far
	jnz	obstofar
	and	cl,0f0h			; now check for still too far
	jnz	obstofar		;
					; dxvec now holds the magic vector
					; which points away from the plane

	mov	ax,dxvec		; load vector to handy location
	mov	dx,dxvec+2
	rept	6
	sar	dx,1
	rcr	ax,1
	endm
	neg	ax			; changing sign as we go
	mov	dtopv,ax
	mov	ax,dxvec+4		; load vector to handy location
	mov	dx,dxvec+6
	rept	6
	sar	dx,1
	rcr	ax,1
	endm
	neg	ax			; changing sign as we go
	mov	dtopv+2,ax
	mov	ax,dxvec+8		; load vector to handy location
	mov	dx,dxvec+10
	rept	6
	sar	dx,1
	rcr	ax,1
	endm
	neg	ax			; changing sign as we go
	mov	dtopv+4,ax
	push	si
	mov	si,offset @dataseg:dtopv
	call	vmag
	pop	si
	mov	dballdist,ax		; save distance for speed burst
	clc
	ret
.endp

.proc	getobsyaw	auto		; calc yaw to get us to observer
	mov	ax,dtopv		; then find atn2(delta-y/delta-x)
	neg	ax
	mov	dx,dtopv+2
	neg	dx
	push	si
	call	atn2
	pop	si
	add	ax,32768
	ret
.endp

.proc	getobspit	auto		; calc pitch to get us to observer
	push	si
	mov	si,offset @dataseg:dtopv
	mov	ax,[si+4]		; get height
	push	ax
	mov	word ptr [si+4],0		; find x^2 + y^2 sqrt
	call	vmag
	pop	dx
	pop	si

;	mov	ax,dtopv		; first find atn2(delta-z/delta-x)
;	mov	dx,dtopv+4		; height is already in dx
	neg	dx
	push	si
	call	atn2
	pop	si
	ret
.endp

.proc	homedetect	auto	; this routine calculated distance from home
				; for the tower of the air base to tell if you
				; are at home base
	push	di
	pushf
	mov	closetowerflag,0	; far until proven close
;	call	getobsvec	; how far are we from tower?
	call	normrel3d	; we want us, not them!
	jc	nohome
	cmp	dballdist,5200	; if too far out, then turn off homeflag
	ja	nohome	; 
	mov	closetowerflag,1
	cmp	dballdist,4200
	ja	nohome
	mov	resetplanesflag,0
	mov	closetowerflag,-1	; set the close to towerflag
	popf
	pop	di
	ret
nohome:
	mov	resetplanesflag,-1	; reset all the planes
	mov	nplaced,0
	popf
	pop	di
	ret
.endp

.proc	aatim	auto		; routine for what flotsom does
	jnc	noaadie
	call	enoughits		; are we killed?
	jnc	noaadie1			; or are we simply not dead yet?

	push	si
	push	di
	mov	boomdeadly,0		; make wimpy
	call	strtboom		; do a boom
	inc	ondest
	dec	naa			; one less dball hanging there
	jns	nazck
	mov	naa,0		; don't let go negative
nazck:
	mov	bx,4	; three pieces
	mov	omniflag,0		; all around explosion
	call	strtflt		; do a boom
	call	makeboom
	pop	di
	pop	si

	push	si
	push	di
	mov	di,offset @dataseg:aaqtbl	; point to dball qual table
	call	getqtblptr
	xor	bh,bh				; bl has quality
	add	bx,bx				; make word address
	inc	word ptr [bx+offset @dataseg:naasdest]
	pop	di
	pop	si
	mov	word ptr [si+24],0	; kill us
	ret
noaadie1:
;	push	si
;	push	di
;	mov	bx,2			; three pieces
;	mov	omniflag,1		; all around explosion
;	mov	flttype,2		; make it so it doesn't harm aa
;	call	strtflt		; do a boom
;	mov	flttype,0
;	pop	di
;	pop	si
	ret
aatofar:
	pop	si
	xor	ax,ax
	mov	[si+46],ax
	mov	[si+48],ax
	mov	[si+50],ax
	pop	di
	ret

noaadie:
	mov	saucerflag,0
sauceraa:
	inc	curnaas		; help keep track of current # of aa's
	push	di
	push	si
	mov	di,offset @dataseg:aaqtbl	; point to dball qual table
	call	getqtblptr
	xor	bh,bh
	add	bx,bx			; form word address into curnaa table
	inc	word ptr [bx+offset @dataseg:tcurnaa]
	mov	ax,[di]			; get default color
	mov	aaclr,al		; default is blue
	call	getobsvec	; find out position of observer, put in vector
	jc	aatofar

	cmp	dballdist,3000
	ja	noaadaa
	pop	si
	push	si
	call	addaa		; add aa score to user's flight prowess
noaadaa:


	mov	cl,4		; divied lead by 8

	mov	di,qtblptr	; get pointer to qual
	cmp	word ptr [di+10],0	; if non zero then lead
	jz	nolead

	mov	bx,rtopv
	sar	bx,cl			; diminish  leading by scale factor
	imul	bx			; multiply distance times velocity
	mov	bx,aashellvel		; divide by the shell speed
	push	dx
	.abs_w	dx
	shl	dx,1
	cmp	dx,bx		; check for possible overflows
	pop	dx
	jae	nolead		; cant lead, due to limited dynamic range	
	idiv	bx			; ax now has lead coordinate change
	add	dtopv,ax		; so add it up!
	mov	ax,dballdist
	mov	bx,rtopv+2
	sar	bx,cl			; diminish  leading by scale factor
	imul	bx			; multiply distance times velocity
	mov	bx,aashellvel		; divide by the shell speed
	push	dx
	.abs_w	dx
	shl	dx,1
	cmp	dx,bx		; check for possible overflows
	pop	dx
	jae	nolead		; cant lead, due to limited dynamic range	
	idiv	bx			; ax now has lead coordinate change
	add	dtopv+2,ax		; so add it up!
	mov	ax,dballdist
	mov	bx,rtopv+4
	sar	bx,cl			; diminish  leading by scale factor
	imul	bx			; multiply distance times velocity
	mov	bx,aashellvel		; divide by the shell speed
	push	dx
	.abs_w	dx
	shl	dx,1
	cmp	dx,bx		; check for possible overflows
	pop	dx
	jae	nolead		; cant lead, due to limited dynamic range	
	idiv	bx			; ax now has lead coordinate change
	add	dtopv+4,ax		; so add it up!

nolead:
					
;	add	si,46			; point to the velocity of the dball
;	mov	di,offset @dataseg:dtopv
;	mov	bx,offset @dataseg:dorot
;	call	matvmul
					; now vector which points to plane
					; is in the rotated coordinate set
					; in dtopv
	call	getobspit		; get yaw to point us to observer
	cmp	saucerflag,0
	jnz	saucerlim1
	sub	ax,[si+14]		; get difference from current pitch
	mov	cl,4			; make into an error correction
	sar	ax,cl
	mov	di,qtblptr
	mov	dx,[di+8]
	neg	dx
	cmp	ax,dx			; check limits
	jge	aapitlim1
	mov	ax,dx
aapitlim1:	
	neg	dx
	cmp	ax,dx
	jle	aapitlim2
	mov	ax,dx
aapitlim2:
	wtadj
saucerlim1:
	add	[si+14],ax		; change angle
	mov	bx,ax
	push	bx			; save pitch for later
	call	getobsyaw
	cmp	saucerflag,0
	jz	saucerlim2
	mov	[si+12],ax
	pop	bx
	jmp	saucerlim3
saucerlim2:
	sub	ax,[si+12]		; get difference from current pitch
	mov	cl,4			; make into an error correction
	sar	ax,cl
	mov	di,qtblptr
	mov	dx,[di+6]
	neg	dx
	cmp	ax,dx			; check limits
	jge	aayawlim1
	mov	ax,dx
aayawlim1:	
	neg	dx
	cmp	ax,dx
	jle	aayawlim2
	mov	ax,dx
aayawlim2:
	pop	bx	
	wtadj
	add	[si+12],ax		; apply correction to yaw
saucerlim3:
	cmp	word ptr [si+10],0	; is gun on the ground?
	jnz	angleok			; no, then don't limit pitch
	cmp	word ptr [si+8],2000	; is aa high enough?
	ja	angleok
	cmp	[si+14],-1200		; don't let gun fire horizontally
	jl	angleok	
	mov	[si+14],-1200
angleok:
	mov	bx,si
	add	bx,12			; point to the angles of rotation
	call	calcsin
	mov	si,offset @dataseg:dorot
	call	calcmat
	mov	si,offset @dataseg:dnrot
	call	ncalcmat
	pop	si
	push	si
	call	rand_w			; get random number
	mov	di,qtblptr
	mov	bx,[di+2]		; get firing prob from qual table
	cmp	ax,bx			; are we firing?
	jb	fireshell		; yes!
	jmp	strexitaashell
fireshell:
	mov	ax,aashellvel		; set velocity of dballs
	mov	dtopv,ax		; set forward speed at 300 ticks
	mov	dtopv+2,0
	mov	dtopv+4,0

					; the following code starts an aa shell

	push	cx
	push	si		; save the target object
	mov	di,offset @dataseg:fltsm1aashell
			; address of flotsom object
	mov	expobj,di
	call	expstrt				; start the object
	jnc	expstrtokaashell
	pop	si
	pop	cx
	jmp	strexitaashell
expstrtokaashell:
	mov	expobj,si		; save ptr to our new object
	mov	di,expobj
	xor	ax,ax			; set distance to near
	mov	[di+18],al
	mov	ax,aashelltime	; get time for object to last
	uwtadj			; relativise for machine speed
	mov	[di+52],ax
	or	word ptr [di+24],8000h	; make a timed object
	xor	ax,ax			; set distance to near
	mov	[di+18],al
	pop	si
	pop	cx
;	pop	di
;	push	di
	mov	ax,[si]		; xfer coordinates from gun to new shell
	mov	[di],ax
	mov	ax,[si+2]
	mov	[di+2],ax
	mov	ax,[si+4]
	mov	[di+4],ax
	mov	ax,[si+6]
	mov	[di+6],ax
	mov	ax,[si+8]
	add	ax,dbsz*4
	mov	[di+8],ax
	mov	ax,[si+10]
	adc	ax,0
	mov	[di+10],ax
	mov	si,offset @dataseg:dtopv
	mov	bx,offset @dataseg:dnrot
	add	di,46			; point to veloctiy
;	mov	di,offset @dataseg:rtopv
	call	matvmul
	mov	di,qtblptr
	mov	ax,[di+4]	; get shell dispersion from qualtable
	mov	si,expobj	; point to new shell
	mov	[si+60],ax	; put into shell object
strexitaashell:
	pop	si
	pop	di
	ret			; nothing for now
.endp

.proc	aashelltim	auto		; routine for an aa shell
	jnc	noaashelldie
aashelltohell:
	push	si
	push	di
	mov	boomdeadly,20h		; make deadly
	call	strtboom		; do a boom
	pop	di
	pop	si
	push	si
	push	di			; reset registers
	mov	bx,9			; three pieces
	mov	omniflag,1		; all around explosion
	call	strtflt		; do a boom
	pop	di
	pop	si
	mov	word ptr [si+24],0	; cancel object
IF 1 EQ 0
IF shareflag EQ 0
	cmp	lettercheck1,0		; do protection of username in
	jnz	nameok			; signon message
	mov	al,49
	inc	al
	mov	bx,offset @codeseg:cecode-9
	mov	cs:[bx+9],al
nameok:
ENDIF
ENDIF
	ret
noaashelldie:
;	mov	bx,aashelltime
;;	mov	ax,aashelltime2
;	uwtadj				; give for time for slower machines
;	sub	bx,ax			;
	mov	ax,word ptr [si+52]
;	cmp	ax,bx ; are we more than half way?
;	jb	aasalive
;
;	ret
aasalive:
	cmp	ax,1
	jnz	noaadieyet	
	jmp	aashelltohell
noaadieyet:
	mov	ax,[si+8]	; how close are we to the plane's height?
	mov	dx,[si+10]
	or	dx,dx
	jnz	notoolow
	sar	ax,1
	js	notoolow
	cmp	ax,[si+66]	; cmpare to blast radius
	ja	notoolow	; not too low!
	ret
notoolow:
	mov	ax,[si+8]	; how close are we to the plane's height?
	sub	ax,ozeff
	sbb	dx,ozeff+2		; dx:ax has double distance
	.abs_d	dx,ax
	or	dx,dx
	jnz	aawayoff
	sub	ax,4500
	ja	aawayoff
	call	rand_w		; get random #
	mov	bx,ax		; don't always explode at correct height
	mov	ax,3000
	wtadj
	cmp	bx,ax
	ja	aawayoff
aasth:	jmp	aashelltohell	; if above plane, blow shell
aawayoff:
	mov	ax,6000
	mov	[si+66],ax
	mov	[si+68],ax
	mov	[si+70],ax
	ret
.endp

.proc	bombtim	auto		; routine for what flotsom does
	jc	bombtohell	
	jmp	nobombdie
bombtohell:


	push	si
	push	di
	mov	boomdeadly,60h		; make it do a six pack
	call	strtboom		; do a boom
	pop	di
	pop	si

	mov	bx,15			; three pieces
	test	word ptr [si+24],2	; was it dropped by a saucer?
	jz	nitwdbas
	mov	bx,5			; make it less spectacular
nitwdbas:
	push	si
	push	di
	call	strtincend		; do a boom
	call	bigboom			; make a big boom noise
	pop	di
	pop	si
	mov	dx,[si+10]		; if exploded too high in the air
	or	dx,dx
	jz	maybelowenough
notlowenough:		
	mov	word ptr [si+24],0	; just kill bomb
	ret
maybelowenough:
	mov	ax,[si+8]
	cmp	ax,10000		; if higher than 333ft, don't make 
	ja	notlowenough		; crater


	mov	ax,offset @dataseg:crtrobj
	mov	[si+40],ax
	mov	[si+42],ax
	mov	[si+44],ax
	mov	word ptr [si+72],32		; make into a crater
	xor	ax,ax
	mov	word ptr [si+8],10		; put slightly above ground
	mov	word ptr [si+10],ax
	mov	byte ptr [si+18],3	; make far away, to avoid crash on 1st
					; frame after dropping
	mov	[si+12],ax		; zero out angle
	mov	[si+14],ax		; zero out angle
	mov	[si+16],ax		; zero out angle
	mov	[si+26],al		; zero out rot flag
	mov	ax,cratertime		; make crater last only so long
	uwtadj
	mov	bx,ax
	sub	ax,100
	mov	cratertimem1,ax
	test	word ptr [si+24],2	; was bomb dropped from a saucer?
	jz	nobdfscr
	shr	bx,1			; then divide time by 16 for life
	shr	bx,1			; then divide time by 16 for life
	shr	bx,1			; then divide time by 16 for life
	shr	bx,1			; then divide time by 16 for life
nobdfscr:
	mov	[si+52],bx
	and	word ptr [si+24],911h	; make object harmless to plane

	ret

bombtohell1:
	jmp	bombtohell
nobombdie:
;	mov	al,2
;	call	getkbit
;	or	al,al
;	jnz	bombtohell1
	mov	bombclr,7
	test	word ptr [si+24],800h	; is bomb an assasin bomb?
	jz	noassbomb
	mov	bombclr,15
noassbomb:
	test	word ptr [si+24],4	; see if bomb is in air, or planted
	jnz	plantedbomb		; run code for planted bomb
	mov	ax,word ptr [si+10]
	or	ax,ax
	js	bombtohell1		; blow up if under surface
	or	ax,word ptr [si+8]
	jz	bombtohell1
	call	getobsvec			; how close are we?
	jc	noarmbomb
	mov	ax,dballdist		; get distance
	cmp	ax,200
	jb	noarmbomb		; don't arm bomb
	or	word ptr [si+24],0e8h	; arm the bomb!, and make collision
					; possible
noarmbomb:
	test	word ptr [si+24],4	; see if bomb is in air, or planted
	jz	bombinair
plantedbomb:
	mov	al,020h
	call	getkbit			; detonate command?
	jz	bombsit
	or	word ptr [si+24],0e8h	; arm the bomb!, and make collision
	and	word ptr [si+24],NOT 4	; make it a non-planted bomb
	mov	word ptr [si+66],bomblst
	jmp	bombinair
bombsit:
	ret
bombinair:
	push	si
	add	si,46				; point to velocity
	call	vmag				; of velocity
	mov	bx,ax
	neg	bx
	mov	ax,[si]		; now apply -kv2 to the velocity coords
	imul	bx
	mov	cx,bombkvalue	; k is applied as a divisor
	idiv	cx
	add	[si],ax
	mov	ax,[si+2]		; now apply -kv2 to the velocity coords
	imul	bx
	idiv	cx
	add	[si+2],ax
	mov	ax,[si+4]		; now apply -kv2 to the velocity coords
	imul	bx
	idiv	cx
	sub	ax,54		; tickgrav
	add	[si+4],ax
	pop	si
	ret
.endp

.proc	crtrtim	auto		; does what's expected of a crater
	jnc	crtrlb1
crtret:	ret
crtrlb1:
	mov	crtrclr,0		; make crater black as default
	test	word ptr [si+24],800h	; check special bit
	jz	crtrtim1			; if set, crtr lives forever
	inc	word ptr [si+52]
	or 	word ptr [si+24],0e0h	; make object lethal for plane
	mov	crtrclr,6		; make crater brown
	ret
crtrtim1:
	mov	ax,cratertimem1
	sub	ax,[si+52]	; how many frames since we were formed?
	jb	crtret
	or 	word ptr [si+24],0e0h	; make object lethal for plane
	ret
.endp


.proc	getqtblptr	auto		; takes table offset in di, obj in si
	mov	ax,[di]			; get number of words in table
	add	di,2			; make di point to the first element
	add	ax,ax			; make into a word offset
	mov	bx,[si+24]		; get object type to get quality
	mov	cl,4			; rotate until obj qual bits are 
	rol	bx,cl			; in correct spot
	and	bl,7			; now quality is 0-7
	mul	bl			; now we have the correct table offset
	add	di,ax			; and di is pointing to table entry
	mov	qtblptr,di		; save the table start for later
					; leave quality in bl 
	ret
.endp


.proc	addaa	auto		; adds dball factor to how well user is doing
	push	ax
	push	dx
	mov	ax,[si+24]	; get object quality
	mov	cl,4
	rol	ax,cl
	and	ax,7		; qual is in 0-7
	cmp	ax,4
	jb	noaddaa
	cmp	advflag,0	; if in adv time, don't include
	ja	noaddaa
	cmp	ejectflag,0
	jnz	noaddaa		; don't count if ejected
	mov	dx,ax
	mul	dx
	dwtadj
	add	aaprog,ax
	adc	aaprog+2,dx
noaddaa:
	pop	dx
	pop	ax
	ret
.endp

.proc	addball	auto		; adds dball factor to how well user is doing
	push	ax
	push	dx
	mov	ax,[si+24]	; get object quality
	mov	cl,4
	rol	ax,cl
	and	ax,7		; qual is in 0-7
	cmp	ax,4
	jb	noaddball
	cmp	advflag,0	; if in adv time, don't include
	ja	noaddball
	cmp	ejectflag,0
	jnz	noaddball
	mov	dx,ax
	mul	dx
	dwtadj			; relativise for machine speed
	add	dballprog,ax
	adc	dballprog+2,dx
noaddball:
	pop	dx
	pop	ax
	ret
.endp


.proc	radarprocess	auto		; calculates relative position of
					; object.  Puts a dot on the radar
					; screen if in range, sets dballdist
					; etc

	cmp	ejectflag,0		; if pilot has ejected, go for the plane
	jz	normrel3da
	call	relobj5d
	jmp	reloada			; it's a kludge, but that's life
dballtofar1:
	stc				; ball is too far away return
	ret
normrel3da:
	call	rel3d			; get dxvector to point the way
reloada:
	jc	dballtofar1		; too far away
	or	ch,ch			; if cx is zero, then too far
	jnz	dballtofar1
					; dxvec now holds the magic vector
					; which points away from the plane
	and	cl,0f0h			; now check for still too far
	jnz	dballtofar1		;

	call	addball
	mov	ax,dxvec		; load vector to handy location
	mov	dx,dxvec+2
	rept	4
	shr	dx,1
	rcr	ax,1
	endm
	neg	ax			; changing sign as we go
	mov	dballvector,ax
	mov	ax,dxvec+4		; load vector to handy location
	mov	dx,dxvec+6
	rept	4
	shr	dx,1
	rcr	ax,1
	endm
	neg	ax			; changing sign as we go
	mov	dballvector+2,ax
	neg	ax
	mov	dx,dballvector
	neg	dx
	xchg	ax,dx
	push	si
	call	atn2
	pop	si			; save si during call
	push	ax			; save angle
	xor	ax,ax
	mov 	dballvector+4,ax		; get magnitude assuming
					; delta-z is zero for radar screen
	push	si
	mov	si,offset @dataseg:dballvector
	call	vmag
	pop	si
	mov	dballdist,ax		; save distance for speed burst
	xor	dx,dx			; make top zero for another sqrt call
	call	dsqrt
	pop	bx			; bx has angle, ax has 0-255 distance 
	mov	ssdist,ax
	sub	bx,orveceff		; add the yaw angle of the plane
	push	si			; save si from destruction
	call	radardot
	pop	si
	
	

	mov	ax,dxvec+8		; load vector to handy location
	mov	dx,dxvec+10
	rept	4
	shr	dx,1
	rcr	ax,1
	endm
	neg	ax			; changing sign as we go
	mov	dballvector+4,ax
	
	clc
	ret				; normal return
.endp
					


.proc	dballtim	auto		; routine for what flotsom does
	jnc	nodballdie
	push	si
	push	di
	mov	boomdeadly,0		; make it harmless
	call	strtboom		; do a boom
	inc	ondest
ndzck:
	pop	di
	pop	si
	push	si
	push	di
	mov	bx,9			; three pieces
	mov	omniflag,1		; all around explosion
	call	strtflt		; do a boom
	pop	di
	pop	si

	push	si
	push	di
	mov	di,offset @dataseg:dballqtbl	; point to dball qual table
	call	getqtblptr
	xor	bh,bh				; bl has quality
	add	bx,bx				; make word address
	inc	word ptr [bx+offset @dataseg:ndballsdest]
	pop	di
	pop	si
	mov	word ptr [si+24],0	; remove from table
	ret
dballtofar:
	pop	si
	xor	ax,ax
	mov	[si+46],ax
	mov	[si+48],ax
	mov	[si+50],ax
	cmp	[si+52],dballtime2/2	; are we more than half way?
	ja	nosuicide
	mov	word ptr [si+52],1	; queue for termination
nosuicide:
	pop	di
	ret
nodballdie:
	mov	kladist,64
	inc	curndballs
	push	di
	push	si
	mov	di,offset @dataseg:dballqtbl	; point to dball qual table
	call	getqtblptr
	xor	bh,bh
	add	bx,bx			; form word address into curnaa table
	inc	word ptr [bx+offset @dataseg:tcurndballs]
	mov	ax,[di]			; get default color
	mov	dballclr,al		; default is blue

	cmp	[si+52],dballtime2	; are we more than half way?
	jb	ballalive
	mov	ax,dballtime		; now get elasped time from strt
	sub	ax,[si+52]		; this goes from 1 to dballrest
	mov	dx,dbrestspin		; max rotation speed when active
	mul	dx
	mov	bx,dballrest		; normalize from 0 - 12000
	div	bx
	pop	si
	pop	di			; just sit there, waiting
	ret
ballalive:
	xor	ax,ax			; clear gravity and so on
	mov	[si+64],al
	mov	[si+60],ax
	mov	[si+62],ax
	mov	ax,[di+12]		; get default speed from table
	mov	dballavgvel,ax		; the default target speed

	mov	n,10			; use light green color for rdr dot
	call	radarprocess		; get distance, angle, and place a dot
					; on the radar

	jc	dballtofar
	mov	ax,dballdist
	mov	cl,6
	shr	ax,cl
	cmp	ax,kladist		; take only closest kla
	ja	nklosest
	mov	kladist,ax		; distance to nearest kla
	mov	bx,[si+24]		; get object type to get quality
	mov	cl,4			; rotate until obj qual bits are 
	rol	bx,cl			; in correct spot
	and	bl,7			; now quality is 0-7
	mov	klaqual,bl
nklosest:
	
					; now vector which points to plane
					; is in the rotated coordinate set
					; in dtopv

	push	si
	mov	si,offset @dataseg:dballvector
	mov	ax,[si+4]		; get height
	push	ax
	mov	word ptr [si+4],0		; find x^2 + y^2 sqrt
	call	vmag
	pop	dx
	pop	si

;	mov	ax,dtopv		; first find atn2(delta-z/delta-x)
;	mov	dx,dtopv+4		; height is already in dx
	neg	dx
	push	si
	call	atn2
	pop	si
	sub	ax,[si+14]		; get difference from current pitch
	mov	cl,4			; make into an error correction
	sar	ax,cl
	push	ax
	.abs_w	ax
	mov	dbmaxang,ax		; maximum angle dball misses by
	pop	ax

	mov	di,qtblptr		; reinstate quality table ptr
	mov	bx,[di+6]		; get cornering limit for pitch
	neg	bx			; first check negative limit
	cmp	ax,bx			; check limits
	jge	pitlim1
	mov	ax,bx
pitlim1:	
	neg	bx			; now check positive limit
	cmp	ax,bx
	jle	pitlim2
	mov	ax,bx
pitlim2:
	wtadj
	add	[si+14],ax		; change angle
	mov	bx,ax
	push	bx			; save pitch for later
	mov	ax,dballvector		; then find atn2(delta-y/delta-x)
	neg	ax
	mov	dx,dballvector+2
	neg	dx
	push	si
	call	atn2
	pop	si
	add	ax,32768
	sub	ax,[si+12]		; get difference from current pitch
	mov	cl,4			; make into an error correction
	sar	ax,cl

	push	ax			; save angle
	.abs_w	ax			; 
	cmp	ax,dbmaxang		; is this bigger?
	jb	notbigger		; no, then leave dbmaxang alone
	mov	dbmaxang,ax		; yes, then swap
notbigger:
	pop	ax

	mov	di,qtblptr		; reinstate quality table ptr
	mov	bx,[di+4]		; get cornering limit for yaw
	neg	bx			; first check negative limit

	cmp	ax,bx			; check limits
	jge	yawlim1
	mov	ax,bx
yawlim1:	
	neg	bx
	cmp	ax,bx
	jle	yawlim2
	mov	ax,bx
yawlim2:
	pop	bx	
	wtadj
	add	[si+12],ax		; apply to dball's yaw angle
	mov	cx,ax
	mov	di,qtblptr		; reinstate quality table ptr
	mov	ax,[di+22]		; get roll rate
	wtadj
	add	[si+16],ax		; make it roll
	mov	bx,si
	add	bx,12			; point to the angles of rotation
	call	calcsin
	mov	si,offset @dataseg:dnrot
	call	ncalcmat

	pop	si
	push	si
	add	si,46			; point to velocity
	call	vmag			; get present velocity
	mov	dballvel,ax		; leave in variable

	mov	di,qtblptr		; reinstate quality table ptr
	mov	bx,[di+18]		; get lock angle requirement

	mov	ax,bx
	cmp	dbmaxang,ax			; are we locked in both angles?
	ja	nolock4				; no
	test	cs:oticks,512		; check status of bit
	jz	noyellow
	mov	di,qtblptr	; get quality table entry for color
	mov	ax,[di+2]
	mov	dballclr,al	; turn dball yellow
noyellow:
	cmp	dballdist,200		; if far away
	jb	nolock5a			; then accelerate
	mov	ax,[di+10]		; top speed of dball
	mov	dballavgvel,ax	; accelerate up to top speed
	jmp	nolock5
nolock5a:
	cmp	addprogflag,0	; should we add to close dball table?
	jz	nolock5
	pop	si
	push	si
nolock4:
	mov	bx,[di+20]		; get put-on-brakes angle
	mov	ax,bx		; at are we way off?
	jb	nolock5			; not in lolly land, so lay off!
	mov	ax,[di+14]		; slow speed value
	mov	dballavgvel,ax		; slow way down
nolock5:
	call	adjdballv		; adjust dball speed
	pop	si
	push	si
	mov	ax,dballvel		; set velocity of dballs
	mov	dtopv,ax		; set forward speed at 300 ticks
	mov	dtopv+2,0
	mov	dtopv+4,0
	mov	si,offset @dataseg:dtopv
	mov	bx,offset @dataseg:dnrot
	pop	di
	push	di
	add	di,46			; point to veloctiy
	call	matvmul
	pop	si

	mov	di,qtblptr		; reinstate quality table ptr
	mov	bx,[di+18]		; get lock angle requirement
nolock3:	
;	mov	[si+40],ax			; enable correct image
;	mov	[si+42],ax	
	cmp	word ptr [si+10],0		; are we too near the ground?
	jnz	dballhengh		; yes, we are high enough
	cmp	word ptr [si+8],1000		; no, we won't go less than 1000
	ja	dballhengh
	or	word ptr [si+50],0		; check sign of z velocity
	jns	dballhengh
	mov	word ptr [si+50],0		; don't let us drag down
dballhengh:
	pop	di
	ret			; nothing for now
.endp

.proc	pufftim	auto		; routine for what puff does
	ret
.endp

.proc	boomtim	auto		; routine for what puff does
	mov	dx,[si+52]
	cmp	dx,bmtime-2	; acceleration cutoff after 1 second
	jg	boomoff		; too long, burn is over
	mov	ax,offset @dataseg:objflt2boom
	cmp	dx,bmtime-3
	jg	chgboom
	mov	ax,offset @dataseg:objflt1boom
chgboom:
	mov	[si+40],ax
	mov	[si+42],ax
	mov	[si+44],ax
boomoff:
	ret
.endp

.proc	mistim	auto
	jnc	nomisdie
mistohell:
	push	si
	push	di
	mov	boomdeadly,20h		; make deadly
	call	strtboom		; do a boom
	pop	di
	pop	si
	push	si
	push	di			; reset registers
	mov	bx,3			; three pieces
	mov	omniflag,1		; all around explosion
	call	strtflt		; do a boom
	pop	di
	pop	si
	mov	word ptr [si+24],0	; cancel object
	ret
nomisdie: 
	mov	ax,[si+10]	; are we in the ground?
	or	ax,[si+8]
	jz	mistohell	; yes, explode!
	mov	ax,[si+52]
	cmp	ax,mistime-11	; acceleration cutoff after 1 second
	jl	misoff		; too long, burn is over
	push	si		; make sure velocity isn;t too big
	add	si,46
	call	vmag
	cmp	ax,3000		; don't allow faster than 3000
	pop	si
	ja	misoff
	mov	ax,[si+46]	; get velocity
	mov	bx,1000
	imul	bx
	mov	bx,890
	idiv	bx
	mov	[si+46],ax
;	mov	xvx,ax
	mov	ax,[si+48]	; get velocity
	mov	bx,1000
	imul	bx
	mov	bx,890
	idiv	bx
	mov	[si+48],ax
;	mov	xvx+2,ax
	mov	ax,[si+50]	; get velocity
	mov	bx,1000
	imul	bx
	mov	bx,890
	idiv	bx
	mov	[si+50],ax
;	mov	xvx+4,ax
misoff:	ret
.endp

.proc	strtpuff	auto	; starts a flotsom object, and lets it rip
	mov	bx,4
	call	randr_w
	inc	ax		; count must be at least one...
	mov	cx,ax		; random number of objects
strflppuff:	
	push	cx
	push	si		; save the target object
	mov	di,offset @dataseg:fltsm1puff	; address of flotsom object
	mov	expobj,di
	call	expstrt				; start the object
	jnc	expstrtokpuff
	pop	si
	pop	cx
	jmp	strexitpuff
expstrtokpuff:
	mov	expobj,si		; save ptr to our new object
	mov	di,si
	pop	si
	push	si
	mov	ax,ds		; xfer the object's origin to the new object
	mov	es,ax
	mov	cx,4		; twelve bytes for position
	cld
	rep	movsw
	mov	ax,0
	stosw
	stosw			; put zeros in for z coordinate
	pop	si
	push	si
	mov	di,expobj	; restore addresses of object begginings
	pop	si
	push	si
	mov	di,expobj	; restore addresses of object begginings
	mov	bx,100
	call	randr_w		; add random number to velocities
	sar	bx,1
	sub	ax,bx
	add	[di+46],ax	; give vel some pep
	mov	bx,100
	call	randr_w		; add random number to velocities
	sar	bx,1
	sub	ax,bx
	add	[di+48],ax	; give vel some pep
	mov	bx,450
	call	randr_w		; add random number to velocities
				; make z vel addition positive
	add	[di+50],ax	; give vel some pep
	xor	ax,ax			; set distance to near
	mov	[di+18],al
;	mov	bx,exptime	; get time for object to last
	mov	ax,7	; get time for object to last, one second
	mov	[di+52],ax
	mov	si,di
	or	word ptr [si+24],8000h	; make a timed object
	pop	si
	pop	cx
	loop	strflpapuff
	clc
	ret
strflpapuff:	
	jmp	strflppuff
strexitpuff:
	stc				; sumthin went wrong
	ret				; attempt failed, abort whole idea
	.endp

.proc	strtboom	auto	; starts a flotsom object, and lets it rip
strflpboom:	
	push	cx
	push	si		; save the target object
	mov	di,offset @dataseg:fltsm1boom	; address of flotsom object
	mov	expobj,di
	call	expstrt				; start the object
	jnc	expstrtokboom
	pop	si
	pop	cx
	jmp	strexitboom
expstrtokboom:
	mov	expobj,si		; save ptr to our new object
	mov	di,si
	pop	si
	push	si
	mov	ax,ds		; xfer the object's origin to the new object
	mov	es,ax
	mov	cx,6		; twelve bytes for position
	cld
	rep	movsw
	pop	si
	push	si
	mov	di,expobj	; restore addresses of object begginings
	pop	si
	push	si
	mov	di,expobj	; restore addresses of object begginings
	mov	bx,100
	call	randr_w		; add random number to velocities
	sar	bx,1
	sub	ax,bx
	add	[di+46],ax	; give vel some pep
	mov	bx,100
	call	randr_w		; add random number to velocities
	sar	bx,1
	sub	ax,bx
	add	[di+48],ax	; give vel some pep
	mov	bx,450
	call	randr_w		; add random number to velocities
				; make z vel addition positive
	add	[di+50],ax	; give vel some pep
	xor	ax,ax			; set distance to near
	mov	[di+18],al
;	mov	bx,exptime	; get time for object to last
	mov	ax,bmtime	; get time for object to last, one second
	mov	[di+52],ax
	mov	si,di
	or	word ptr [si+24],8000h	; make a timed object
	mov	al,boomdeadly	; set destruction bit?
	or	byte ptr [si+24],al

	call	makeboom	; make boom sound

	pop	si
	pop	cx
	clc
	ret
strflpaboom:	
	jmp	strflpboom
strexitboom:
	stc				; sumthin went wrong
	ret				; attempt failed, abort whole idea
	.endp

.proc	strtbomb1	auto	; starts a flotsom object, and lets it rip
	push	cx
	push	si		; save the target object
	mov	di,offset @dataseg:fltsm1bomb	; address of flotsom object
	mov	expobj,di
	call	expstrt				; start the object
	jnc	expstrtokbomb1
	pop	si
	pop	cx
	jmp	strexitbomb1
expstrtokbomb1:
	mov	expobj,si		; save ptr to our new object
	mov	di,expobj
	pop	si
	push	si
	mov	al,[si+18]
	mov	[di+18],al
	mov	byte ptr [di+19],2	; make it a class II bomb
	mov	ax,bombtime	; get time for object to last
	mov	[di+52],ax
	mov	si,di
	or	word ptr [si+24],8000h	; make a timed object
	mov	bx,si
	xor	ax,ax			; set distance to near
	mov	cx,6
	mov	ax,ds
	mov	es,ax
	mov	di,bx
;	mov	si,offset @dataseg:oxeff
	pop	si
	push	si
	cld
	rep	movsw
	pop	si
	push	si
	add	si,46
	mov	di,expobj
	add	di,46
	mov	cx,3
	rep	movsw		; transfer velocity to bomb
	pop	si
	pop	cx
	clc
	ret
strexitbomb1:
	stc				; sumthin went wrong
	ret				; attempt failed, abort whole idea
	.endp

.proc	strtbomb	auto	; starts a flotsom object, and lets it rip
	push	cx
	push	si		; save the target object
;	cmp	ejectflag,0	; has pilot ejected?
;	jnz	bombsmexit
	mov	di,offset @dataseg:fltsm1bomb	; address of flotsom object
	mov	expobj,di
	call	expstrt				; start the object
	jnc	expstrtokbomb
bombsmexit:	pop	si
	pop	cx
	jmp	strexitbomb
expstrtokbomb:
	mov	expobj,si		; save ptr to our new object
	mov	di,expobj
	xor	ax,ax			; set distance to near
	mov	[di+18],al
	mov	ax,bombtime	; get time for object to last
	mov	[di+52],ax
	mov	si,di
	or	word ptr [si+24],8000h	; make a timed object
	and	word ptr [si+24],NOT 0e8h	; strip destructable bit
	mov	bx,si
	xor	ax,ax			; set distance to near
	mov	[bx+18],al
	mov	cx,6
	mov	ax,ds
	mov	es,ax
	mov	di,bx
	mov	si,offset @dataseg:oxeff
	cld
	rep	movsw
	mov	si,offset @dataseg:orveceff
	mov	cx,3
	rep	movsw			; copy angle of plane too
	mov	si,offset @dataseg:rtopv	; get forward velocity
	mov	cl,4			; divide rtopv down
	xor	dx,dx
	mov	ax,[si]
	sar	ax,cl
	sub	[si],ax
	sbb	[si+2],dx
	mov	[bx+46],ax
	mov	ax,[si+2]
	sar	ax,cl
	mov	[bx+48],ax
	sub	[si+4],ax
	sbb	[si+6],dx
	mov	ax,[si+4]
	sar	ax,cl
	mov	[bx+50],ax
	sub	[si+8],ax
	sbb	[si+10],dx

;jmp	ship1
	push	bx
	mov	si,offset @dataseg:xvec
	mov	word ptr [si],-500	; start bomb below and behind plane
	mov	word ptr [si+2],0
	mov	word ptr [si+4],-500
	mov	bx,offset @dataseg:nnzmat
	mov	di,offset @dataseg:xvec1
	call	matvmul
	pop	si			; si now has ptr to object
	mov	ax,xvec1
	cwd
	add	[si],ax
	adc	word ptr [si+2],dx
	mov	ax,xvec1+2
	cwd
	add	[si+4],ax
	adc	word ptr [si+6],dx
	mov	ax,xvec1+4
	cwd
	add	[si+8],ax
	adc	word ptr [si+10],dx
ship1:
	pop	si
	pop	cx
	clc
	ret
strexitbomb:
	stc				; sumthin went wrong
	ret				; attempt failed, abort whole idea
	.endp

.proc	strtmis	auto		; starts a flotsom object, and lets it rip
	push	cx
	push	si		; save the target object
;	cmp	ejectflag,0	; has pilot ejected?
;	jnz	smexit
	mov	di,offset @dataseg:fltsm1mis	; address of flotsom object
	mov	expobj,di
	call	expstrt				; start the object
	jnc	expstrtokmis
smexit:	pop	si
	pop	cx
	jmp	strexitmis
expstrtokmis:
	mov	expobj,si		; save ptr to our new object
	mov	di,expobj
	xor	ax,ax			; set distance to near
	mov	[di+18],al
	mov	ax,mistime	; get time for object to last
	mov	[di+52],ax
	mov	si,di
	or	word ptr [si+24],8000h	; make a timed object
	mov	bx,si
	mov	si,offset @dataseg:nnzmat
	mov	ax,ctopv
	add	ax,125
	mov	di,ax
	hmul	di,[si]
	mov	[bx+46],dx
	hmul	di,[si+6]
	mov	[bx+48],dx
	hmul	di,[si+12]
	mov	[bx+50],dx
	xor	ax,ax			; set distance to near
	mov	[bx+18],al
	mov	cx,6
	mov	ax,ds
	mov	es,ax
	mov	di,bx
	mov	si,offset @dataseg:oxeff
	rep	movsw
	mov	si,offset @dataseg:orveceff
	mov	cx,3
	rep	movsw			; copy angle of plane too
;	mov	ax,bulyoff		; make bullets come from wings
	mov	si,offset @dataseg:nnzmat
	hmul	misyoff,[si+2]
	mov	ax,dx
	cwd
	add	[bx],ax
	adc	[bx+2],dx
	hmul	misyoff,[si+8]
	mov	ax,dx
	cwd
	add	[bx+4],ax
	adc	[bx+6],dx
	hmul	misyoff,[si+14]
	mov	ax,dx
	cwd
	add	[bx+8],ax
	adc	[bx+10],dx
	neg	misyoff
	pop	si
	pop	cx
	clc
	ret
strexitmis:
	stc				; sumthin went wrong
	ret				; attempt failed, abort whole idea
	.endp

.proc	strtdball	auto	; starts a flotsom object, and lets it rip
	mov	oldobjptr,si	; save ptr to old object
	push	cx
	push	si		; save the target object
	mov	di,offset @dataseg:fltsm1dball	; address of flotsom object
	mov	expobj,di
	call	expstrt				; start the object
	jnc	expstrtokdball
	pop	si
	pop	cx
	jmp	strexitdball
expstrtokdball:
	mov	expobj,si		; save ptr to our new object
	mov	di,expobj
	xor	ax,ax			; set distance to near
	mov	[di+18],al
	mov	ax,dballtime	; get time for object to last
	mov	[di+52],ax
	mov	si,di
	mov	ax,initialqual		; now we merge quality with obj type
	and	ax,7			; make sure no non-proper bits are set
	mov	cl,4
	ror	ax,cl			; mov bits to proper position
	or	ax,8000h		; set new object bit
	or	word ptr [si+24],ax	; make a timed object
	mov	bx,si
	mov	si,offset @dataseg:nnzmat
	xor	ax,ax			; set distance to near
	mov	[bx+46],ax
	mov	[bx+48],ax
	mov	[bx+50],ax
	mov	[bx+18],al
	mov	[bx+12],ax		
	mov	[bx+16],ax
	mov	[bx+14],-16384		; set direction to be straight up
	mov	cx,6
	mov	ax,ds
	mov	es,ax
	mov	di,bx
	mov	si,oldobjptr
	rep	movsw
	pop	si
	pop	cx
	clc
	ret
strexitdball:
	stc				; sumthin went wrong
	ret				; attempt failed, abort whole idea
	.endp

.proc	strtvech	auto	; starts a flotsom object, and lets it rip
	mov	oldobjptr,si	; save ptr to old object
	push	cx
	push	si		; save the target object
	mov	di,offset @dataseg:objvech	; address of flotsom object
	mov	expobj,di
	call	expstrt				; start the object
	jnc	expstrtokvech
	pop	si
	pop	cx
	jmp	strexitvech
expstrtokvech:
	mov	expobj,si		; save ptr to our new object
	mov	di,expobj
	xor	ax,ax			; set distance to near
	mov	[di+18],al
	mov	ax,vechtime	; get time for object to last
	uwtadj			; relativise for machine speed
	mov	[di+52],ax
	mov	si,di
	mov	ax,initialqual		; now we merge quality with obj type
	and	ax,7			; make sure no non-proper bits are set
	mov	cl,4
	ror	ax,cl			; mov bits to proper position
	or	ax,8000h		; set new object bit
	or	word ptr [si+24],ax	; make a timed object
	mov	bx,si
	xor	ax,ax			; set distance to near
	mov	[bx+46],ax
	mov	[bx+48],ax
	mov	[bx+50],ax
	mov	[bx+18],al
	mov	[bx+12],ax		
	mov	[bx+16],ax
	mov	[bx+14],ax		; set direction to be straight up
	mov	cx,6
	mov	ax,ds
	mov	es,ax
	mov	di,bx
	mov	si,oldobjptr
	rep	movsw
	pop	si
	pop	cx
	clc
	ret
strexitvech:
	stc				; sumthin went wrong
	ret				; attempt failed, abort whole idea
	.endp


.proc	killvech	auto		; overturn car, and
	mov	word ptr [si+8],2*veszht
	mov	word ptr [si+16],20000		; roll it over
	mov	word ptr [si+14],2400		; nose it down a little
	mov	ax,800
	uwtadj				; make it live shorter on slow machines
	mov	[si+52],ax		; make it sit there a while
	mov	byte ptr [si+24],71h	; make undestructable, but crashintoable
	xor	ax,ax
	mov	word ptr [si+10],ax
	mov	[si+46],ax		; set velocity to zero
	mov	[si+48],ax		; set velocity to zero
	mov	[si+50],ax		; set velocity to zero
	mov	[si+66],ax		; make object not destroy anything agn
	mov	[si+68],ax		; make object not destroy anything agn
	mov	[si+70],ax		; make object not destroy anything agn
	ret
.endp


.proc	vechtim	auto		; do the vechicular thing!
	pushf			; save flags
	push	di		; always get colors set correctly
	mov	di,offset @dataseg:vechqtbl	; point to dball qual table
	call	getqtblptr
	mov	ax,[di]			; get default color
	mov	bodclr,al		; default is blue
	mov	ax,[di+2]			; get default color
	mov	whlclr,al		; default is blue
	pop	di
	mov	ax,[si+24]
	and	ax,0ffh
	cmp	ax,71h	; are we exploded?
	jnz	stillkickin
	cmp	word ptr [si+52],0
	jnz	gomoretime
	mov	word ptr [si+24],0
	popf
	ret			; just kill it
gomoretime:
	popf
	ret			; do nothing
stillkickin:
	popf
	mov	ax,0		; don't blather the carry flag!
	mov	word ptr [si+8],ax
	mov	[si+10],ax
	jnc	novechdie		; do we just die?
	test	word ptr [si+24],800h	; check special bit
	jz	vechregular		; if special bit set, can't die
					; except from bullets & missles
	mov	ax,[di+72]
	cmp	ax,30	; is it a bullet?
	jz	vechregular
	cmp	ax,21	; is it a missle?
	jz	vechregular
	cmp	ax,19	; is it a boom?
	jz	vechregular
	jmp	vechsaved
vechregular:
	call	enoughits		; are we killed?
	jnc	vechsaved
	push	si
	push	di
	mov	byte ptr [si+27],-1	; explain that we are a carcass
	mov	boomdeadly,0		; make wimpy
	call	strtboom		; do a boom
	inc	ondest
	push	si
	push	di
	mov	di,offset @dataseg:vechqtbl	; point to dball qual table
	call	getqtblptr
	xor	bh,bh				; bl has quality
	add	bx,bx				; make word address
	inc	word ptr [bx+offset @dataseg:nvechsdest]
	pop	di
	pop	si
	mov	bx,9			; three pieces
	mov	omniflag,1		; all around explosion
	call	strtflt		; do a boom
	pop	di
	pop	si
	call	killvech	; overturn vehicle
	mov	ax,[si+52]
	or	ax,ax
	jz	skipdeathtime
	shr	ax,1
	shr	ax,1
	add	ax,300
	mov	[si+52],ax	; lifetime of vehicle after death
skipdeathtime:
	ret
vechsaved:
	push	di			; conserve di
	mov	di,offset @dataseg:vechqtbl	; point to dball qual table
	call	getqtblptr
	call	resetvech
	pop	di
	ret
novechdie:

	cmp	byte ptr [si+19],1	; are we a friendly van?
	jnz	nofrvan
	inc	curnrvs
nofrvan:
	mov	vechantclr,0		; make antenna black
	test	word ptr [si+24],800h	; check special bit
	jz	vechregular1		; if special bit set, can't die
	test	cs:oticks,512
	jz	noantflash
	mov	vechantclr,15		; make it flash white
noantflash:
	inc	word ptr [si+52]	; never die if special bit set
vechregular1:		
	inc	curnvechs
	push	di
	mov	di,qtblptr
	mov	ax,[di+12]		; this is our reset prob
	wtadj				; relativise for machine speed
	mov	bx,ax			; move it to bx to avoid being junked
	cmp	byte ptr [si+18],0	; are we stupendously close?
	jnz	leaverand		; leave it random if not
	test	word ptr [si+24],4	; is car stopped?
	jnz	defreset		; yes, then definately track
	shl	bx,1
	shl	bx,1			; make it 4 times more likely
					; to change direction
leaverand:
	call	rand_w
	cmp	ax,bx
	ja	nodirchg
defreset:
	call	resetvech
nodirchg:
	test	word ptr [si+24],4	; is car stopped?
	jz	keeptracking
	xor	ax,ax
	mov	[si+46],ax
	mov	[si+48],ax
	mov	[si+50],ax
	cmp	byte ptr [si+19],1	; are we a friendly van?
	jz	nofrvan2
	call	followangles		; propell car forward in direction
nofrvan2:
	pop	di
	ret
keeptracking:
	mov	di,qtblptr		; get di back
	mov	ax,cs:oticks		; get tick count
	mov	dx,[di+14]		; make a six second cycle in position
	mul	dx
	push	di
	push	si
	call	ssin			; get sin of angle
	pop	si			; sin will trash si
	pop	di
	cwd
	mov	bx,[di+16]		; divide the serpentine action down
	idiv	bx
	add	[si+12],ax		; change yaw direction of car
	call	followangles		; propell car forward in direction
					; specified in the angles
	pop	di
	ret
.endp

.proc	resetvech	auto
;	mov	ax,vechtime		; let objects explode if need be
;	mov	word ptr [si+52],ax
	test	word ptr [si+24],4	; is vehicle stopped
	jnz	norandtwist
	xor	ax,ax
	mov	[si+14],ax		; clear roll and pitch
	mov	[si+16],ax		; clear roll and pitch
	call	rand_w			; take random direction
	mov	[si+12],ax		; go for it!
norandtwist:
	mov	di,qtblptr		; get vechtrakprob from table
	mov	dx,[di+10]		; randomness assuming we are close
	cmp	byte ptr [si+18],3	; are we pretty far?
	jnz	noprettyfar
	mov	word ptr [si+24],0	; just remove from table w no fanfare
	ret

noprettyfar:
	cmp	byte ptr [si+18],1	; are we sort of close?
	jz	closetrak
	cmp	byte ptr [si+18],0	; are we stupendously close?
	jz	yestrak			; definately track
	mov	dx,[di+8]		; randomness assuming we are far
closetrak:
	call	rand_w
	cmp	ax,dx		; should we track the observer?
	jbe	yestrak
	jmp	notrak
yestrak:
	push	si
	cmp	ejectflag,0		; is the guy out of the plane?
	jz	followobs
	mov	al,ejectflag
	push	ax
	mov	ejectflag,0
	call	getobsvec
	pop	ax
	mov	ejectflag,al		; temporarily fool the observer
	jmp	ardvaark
followobs:
	call	getobsvec		; get info on tracking observer
ardvaark:
	pop	si
	jc	notrak			; abort if too far
	test	word ptr [si+24],4	; are we halted?
	jnz	skipjerk		; then don't sit there jerking
	push	si
	call	getobsyaw		; get his yaw angle
	pop	si
	mov	[si+12],ax		; make it our own
skipjerk:
	cmp	dballdist,256		; are we real close?
	ja	notrak			; no, continue on
	cmp	ejectflag,0		; are we out of the plane?
	jz	notrak
	cmp	haltflag,0
	jnz	leavehalone
	mov	haltflag,-1
	or	word ptr [si+24],2	; set bit that we are close
leavehalone:
	cmp	dballdist,100
	ja	stillkicking		; he's still kicking, but will be
	mov	haltflag,1		; dead soon
	or	word ptr [si+24],4	; set bit that we are way close
	cmp	byte ptr [si+19],1	; is it friendly class=rescue van?
	jnz	notrescuevan1
	mov	haltflag,0		; stop capture if rescue van here
	cmp	dballdist,32
	ja	notrescuevan1
	mov	rescueflag,-1
notrescuevan1:
stillkicking:
	mov	di,offset @dataseg:haltox	; set the coordinates for halt
	mov	ax,ds
	mov	es,ax
	cld
	mov	cx,6
	push	si			; preserve si
	rep	movsw			; xfer coords
	pop	si
	ret				; return without moving car
	call	followangles		; propell car forward in direction
					; specified in the angles
	ret
notrak:
	and	word ptr [si+24],NOT 6	; clear halt and whatnot bits
	call	followangles		; propell car forward in direction
					; specified in the angles
	ret
.endp

.proc	followangles auto	; propell car forward in direction
				; specified in the angles

	push	si
	mov	bx,si
	add	bx,12			; point to the angles of rotation
	call	calcsin
	mov	si,offset @dataseg:dnrot
	call	ncalcmat
	mov	di,qtblptr
	mov	ax,[di+4]		; fast speed, assuming far
;	mov	ax,vechvel		; set velocity of dballs
	pop	si
	cmp	byte ptr [si+18],0	; is the vechicle near?
	jnz	keepupspd		; no, then continue going fast
	mov	ax,[di+6]		; slow speed assuming close
	test	word ptr [si+24],2	; should we slow down?
	jz	keepupspd
	shr	ax,1
	shr	ax,1
	test	word ptr [si+24],4	; should we slow down?
	jz	keepupspd
	xor	ax,ax			; halt if we are stopped
keepupspd:
	push	si
	mov	dtopv,ax		; set forward speed at 300 ticks
	mov	dtopv+2,0
	mov	dtopv+4,0
	mov	si,offset @dataseg:dtopv
	mov	bx,offset @dataseg:dnrot
	pop	di
	push	di
	add	di,46			; point to veloctiy
	call	matvmul
	pop	si
	ret
.endp

.proc	strtdbst	auto	; starts a flotsom object, and lets it rip
	mov	oldobjptr,si
	push	cx
	push	si		; save the target object
	mov	di,offset @dataseg:objdbst	; address of flotsom object
	mov	expobj,di
	call	expstrt				; start the object
	jnc	expstrtokdbst
	pop	si
	pop	cx
	jmp	strexitdbst
expstrtokdbst:
	mov	expobj,si		; save ptr to our new object
	push	di
	mov	di,offset @dataseg:dbstqtbl	; point to dball qual table
	call	getqtblptr
	mov	ax,[di]			; get default color
	mov	dbstclr,al		; default is blue
	mov	ax,[di+4]		; get our rest time
	mov	dbstrest,ax
	pop	di
	call	resetdbst
	mov	di,expobj
	xor	ax,ax			; set distance to near
	mov	[di+18],al
	mov	si,di
	mov	ax,initialqual		; now we merge quality with obj type
	and	ax,7			; make sure no non-proper bits are set
	mov	cl,4
	ror	ax,cl			; mov bits to proper position
	or	ax,8000h		; set new object bit
	or	word ptr [si+24],ax	; make a timed object
	mov	bx,si
	mov	si,offset @dataseg:nnzmat
	xor	ax,ax			; set distance to near
	mov	[bx+46],ax
	mov	[bx+48],ax
	mov	[bx+50],ax
	mov	[bx+18],al
	mov	[bx+12],ax		
	mov	[bx+16],ax
	mov	[bx+14],ax		; set direction to be straight up
	mov	cx,6
	mov	ax,ds
	mov	es,ax
	mov	di,bx
	mov	si,oldobjptr
	rep	movsw
	pop	si
	pop	cx
	clc
	ret
strexitdbst:
	stc				; sumthin went wrong
	ret				; attempt failed, abort whole idea
	.endp

.proc	strtvest	auto	; starts a flotsom object, and lets it rip
	mov	oldobjptr,si
	push	cx
	push	si		; save the target object
	mov	di,offset @dataseg:objvest	; address of flotsom object
	mov	expobj,di
	call	expstrt				; start the object
	jnc	expstrtokvest
	pop	si
	pop	cx
	jmp	strexitvest
expstrtokvest:
	mov	expobj,si		; save ptr to our new object
	mov	di,expobj
	xor	ax,ax			; set distance to near
	mov	[di+18],al
	call	resetvest
	mov	si,di
	mov	ax,initialqual		; now we merge quality with obj type
	and	ax,7			; make sure no non-proper bits are set
	mov	cl,4
	ror	ax,cl			; mov bits to proper position
	or	ax,8000h		; set new object bit
	or	word ptr [si+24],ax	; make a timed object
	mov	bx,si
	mov	si,offset @dataseg:nnzmat
	xor	ax,ax			; set distance to near
	mov	[bx+46],ax
	mov	[bx+48],ax
	mov	[bx+50],ax
	mov	[bx+18],al
	mov	[bx+12],ax		
	mov	[bx+16],ax
	mov	[bx+14],ax		; set direction to be straight up
	mov	cx,6
	mov	ax,ds
	mov	es,ax
	mov	di,bx
	mov	si,oldobjptr
	rep	movsw
	pop	si
	pop	cx
	clc
	ret
strexitvest:
	stc				; sumthin went wrong
	ret				; attempt failed, abort whole idea
	.endp


.proc	vesttim	auto			; what does a dball site do?
	jnc	novestdie		; do we just die?
	call	enoughits		; are we killed?
	jnc	vestsaved
	push	si
	push	di
	mov	boomdeadly,0		; make wimpy
	call	strtboom		; do a boom
	inc	ondest
	mov	bx,9			; three pieces
	mov	omniflag,1		; all around explosion
	call	strtflt		; do a boom
	call	makeboom
	pop	di
	pop	si
	push	si
	push	di
	mov	di,offset @dataseg:vestqtbl	; point to dball qual table
	call	getqtblptr
	xor	bh,bh				; bl has quality
	add	bx,bx				; make word address
	inc	word ptr [bx+offset @dataseg:nsitesdest]
	pop	di
	pop	si
	mov	word ptr [si+24],0	; kill us
	ret
vestsaved:
	push	di
	call	resetvest
	pop	di
	ret
novestdie:
	inc	curnvest		; keep running total of number of vest
	push	di
	mov	di,offset @dataseg:vestqtbl	; point to dball qual table
	call	getqtblptr
	mov	ax,[di]			; get default color
	mov	bodclr,al		; default is blue
	mov	ax,[di+2]
	mov	vechrest,ax		; set the time for existance
	pop	di
	mov	ax,[si+52]		; get our time in existance
	cmp	ax,vechrest		; are we due for another vech?
	jb	makevech
	ret				; no, just hang out!
makevech:
	call	resetvest
	mov	ax,nvechs	; how many vech are in the sky?
	mov	bx,maxnvechs	; how many vech are in the sky?
;	cmp	ax,maxnvechs	; are there too many?
	cmp	bx,4		; always allow at least 4 of them
	jae	ok4
	mov	bx,4
ok4:
	cmp	ax,bx	; are there too many?
	jae	skipvech	; then don't make another!
	mov	bx,[si+24]		; get object type to get quality
	mov	cl,4			; rotate until obj qual bits are 
	rol	bx,cl			; in correct spot
	and	bx,7			; now quality is 0-7
	mov	initialqual,bx		; set dball's qual = to our own
	inc	nvechs			; show that we have started one
	call	strtvech	; then we start a vech at our coords
	push	si
	mov	si,expobj	; change our class to match the vehicles
	mov	ax,nvechs
	inc	ax
	neg	ax
	mov	[si+19],al		; set our class to be unique
	pop	si
	mov	[si+19],al
skipvech:
	ret			; and wait for the next thing todo
.endp

.proc	enoughits	auto		; sees if enough hits have arrived
					; to blow the sucker
;	mov	ax,[si+52]		; if object has run out, destroy
;	js	fdestroy
;	jz	fdestroy
	cmp	di,-1			; infinite damage?
	jz	fdestroy1		; blow her up if plane as object
	mov	bl,1
	test	byte ptr [di+24],40h		; get other object type
	jz	minorhit1
	mov	bl,6
minorhit1:
	test	byte ptr [di+24],80h		; get other object type
	jz	minorhit2
	mov	bl,25
minorhit2:
	mov	al,[si+27]		; get number of hits left
	sub	al,bl
	jz	fdestroy		; destroy object, this guy gets it!
	js	fdestroy
	mov	[si+27],al		; leave number of hits decrmented
	clc				; no carry means object survives
	ret
fdestroy1:
	mov	di,offset @dataseg:crtr
fdestroy:
	mov	byte ptr [si+27],0
	stc
	ret				; blow her good!
.endp

.proc	dbsttim	auto			; what does a dball site do?
	jnc	nodbstdie		; do we just die?
	call	enoughits		; are we killed?
	jnc	dbstsaved
	push	si
	push	di
	mov	boomdeadly,0		; make wimpy
	call	strtboom		; do a boom
	inc	ondest
	inc	nsitesdest
	mov	bx,9			; three pieces
	mov	omniflag,1		; all around explosion
	call	strtflt		; do a boom
	call	makeboom
	pop	di
	pop	si
	mov	word ptr [si+24],0	; kill us
	ret
dbstsaved:
	push	di
	mov	di,offset @dataseg:dbstqtbl	; point to dball qual table
	call	getqtblptr
	mov	ax,[di]			; get default color
	mov	dbstclr,al		; default is blue
	mov	ax,[di+4]		; get our rest time
	mov	dbstrest,ax
	call	resetdbst
	pop	di
	ret
nodbstdie:
	inc	curndbst		; keep running total of number of dbst
	push	di
	mov	di,offset @dataseg:dbstqtbl	; point to dball qual table
	call	getqtblptr
	mov	ax,[di]			; get default color
	mov	dbstclr,al		; default is blue
	mov	ax,[di+4]		; get our rest time
	mov	dbstrest,ax
	pop	di
	mov	ax,[si+52]		; get our time in existance

	cmp	ax,100		; are we due for another dball?
	jb	makedball
	ret				; no, just hang out!
makedball:
	mov	ax,ndballs	; how many dballs are in the sky?
	cmp	ax,maxndballs	; are there too many?
	jae	skipdball	; then don't make another!
	call	resetdbst
	mov	bx,[si+24]		; get object type to get quality
	mov	cl,4			; rotate until obj qual bits are 
	rol	bx,cl			; in correct spot
	and	bx,7			; now quality is 0-7
	mov	initialqual,bx		; set dball's qual = to our own
	inc	ndballs			; show that we have created one
	call	strtdball	; then we start a dball at our coords
	ret
skipdball:
	inc	word ptr [si+52]	; don't let vest blow up, just cause
					; it can't make a site
	ret			; and wait for the next thing todo
.endp

.proc	resetvest	auto	; resets the survival time for a vech site
	mov	ax,vechrest	; get time for object to last
	add	ax,ax		; make it twice the dball rest time
	mov	bx,ax		; and add a little more
	shr	bx,1
	add	ax,bx
	mov	[si+52],ax	; first off, we reset the death countdown
	ret
.endp


.proc	resetdbst	auto	; resets the survival time for a dball site
	mov	ax,dbstrest	; get time for object to last
	mov	[si+52],ax	; first off, we reset the death countdown
	ret
.endp
	
.proc	strtperm	auto	; starts a perm object, and lets it rip
				; ie places an object in the timed buffer
				; si has pointer to starting dxyzcoords
				; with 3 angles ie 9 words.
				; di points to the object template addr
				; variable initialqual has object quality
	mov	oldobjptr,si
	push	cx
	push	si		; save the target object
;	mov	di,offset @dataseg:fltsm1aa	; address of flotsom object
	mov	expobj,di
	call	expstrt				; start the object
	jnc	expstrtokperm
	pop	si
	pop	cx
	jmp	strexitperm
expstrtokperm:
	mov	expobj,si		; save ptr to our new object
	mov	di,expobj
	xor	ax,ax			; set distance to near
	mov	[di+18],al
	mov	si,di
	mov	ax,initialqual		; now we merge quality with obj type
	and	ax,7			; make sure no non-proper bits are set
	mov	cl,4
	ror	ax,cl			; mov bits to proper position
	or	ax,8000h		; set new object bit
	or	word ptr [si+24],ax	; make a timed object
	mov	bx,si
	mov	cx,9			; get position and angle from caller
	mov	ax,ds
	mov	es,ax
	mov	di,bx
	mov	si,oldobjptr
	rep	movsw
	pop	si
	pop	cx
	clc
	ret
strexitperm:
	stc				; sumthin went wrong
	ret				; attempt failed, abort whole idea
	.endp


	
.proc	strtaa	auto	; starts a flotsom object, and lets it rip
	mov	oldobjptr,si
	push	cx
	push	si		; save the target object
	mov	di,offset @dataseg:fltsm1aa	; address of flotsom object
	mov	expobj,di
	call	expstrt				; start the object
	jnc	expstrtokaa
	pop	si
	pop	cx
	jmp	strexitaa
expstrtokaa:
	mov	expobj,si		; save ptr to our new object
	mov	di,expobj
	xor	ax,ax			; set distance to near
	mov	[di+18],al
	mov	ax,dballtime	; get time for object to last
	mov	[di+52],ax
	mov	si,di
	mov	ax,initialqual		; now we merge quality with obj type
	and	ax,7			; make sure no non-proper bits are set
	mov	cl,4
	ror	ax,cl			; mov bits to proper position
	or	ax,8000h		; set new object bit
	or	word ptr [si+24],ax	; make a timed object
	mov	bx,si
	mov	si,offset @dataseg:nnzmat
	xor	ax,ax			; set distance to near
	mov	[bx+46],ax
	mov	[bx+48],ax
	mov	[bx+50],ax
	mov	[bx+18],al
	mov	[bx+12],ax		
	mov	[bx+16],ax
	mov	[bx+14],-16384		; set direction to be straight up
	mov	cx,6
	mov	ax,ds
	mov	es,ax
	mov	di,bx
	mov	si,oldobjptr
	rep	movsw
	inc	naa			; increment number of active dballs
	pop	si
	pop	cx
	clc
	ret
strexitaa:
	stc				; sumthin went wrong
	ret				; attempt failed, abort whole idea
	.endp


.proc	adjdballv	auto		; adjusts the speed of a dball
					; at random
					; assume di points to dball qtbl
	mov	ax,dballavgvel		; average dball speed
	sub	ax,dballvel
	cwd
	mov	bx,[di+8]		; get momentum from qualtble
;	mov	bx,60			; this has the correction to keep
					; the speed centered
	idiv	bx
	mov	bx,[di+16]		; get randomness factor
	mov	dx,ax			; save for later
;	mov	bx,11
	call	randr_w			; get random adjustment to speed
	shr	bx,1			; center result around zero
	sub	ax,bx			; make centered around zero
	add	ax,dx			; include other part
	add	dballvel,ax
	ret
.endp


IF 1 EQ 0
.proc	getdist	auto			; gets distance from plane
	cmp	ejectflag,0		; if pilot has ejected, go for the plane
	jz	normrel3d1
	call	relobj5d
	jmp	reload1			; it's a kludge, but that's life
aatofar2:
	ret				; liffle mofomter perafmallubb
normrel3d1:
	call	rel3d			; get dxvector to point the way
reload1:
	mov	dballdist,30000
	jc	aatofar2		; too far away
	or	ch,ch			; if cx is zero, then too far
	jnz	aatofar2
	and	cl,0f0h			; now check for still too far
	jnz	aatofar2	;
					; dxvec now holds the magic vector
					; which points away from the plane

	mov	ax,dxvec		; load vector to handy location
	mov	dx,dxvec+2
	rept	6
	sar	dx,1
	rcr	ax,1
	endm
	neg	ax			; changing sign as we go
	mov	xvec,ax

	mov	ax,dxvec+4		; load vector to handy location
	mov	dx,dxvec+6
	rept	6
	sar	dx,1
	rcr	ax,1
	endm
	neg	ax			; changing sign as we go
	mov	xvec+2,ax

	mov	ax,dxvec+8		; load vector to handy location
	mov	dx,dxvec+10
	rept	6
	sar	dx,1
	rcr	ax,1
	endm
	neg	ax			; changing sign as we go
	mov	xvec+4,ax

	push	si
	add	si,46			; point to the magic vector
	call	vmag
	pop	si
	mov	dballdist,ax		; save distance for speed burst
	ret
.endp
ENDIF

.proc	bbsmtim	auto
	call	rand_w
	mov	word ptr [si+12],ax
	call	rand_w
	mov	word ptr [si+14],ax
	call	rand_w
	mov	word ptr [si+16],ax
	jmp	bbtim
.endp

.proc	bbtim	auto		; what the barrage balls do
	mov	word ptr [si+52],32000
	jnc	nobbdie
bbret:
	ret
nobbdie:
	push	si
	push	di
	mov	di,offset @dataseg:bbqtbl	; point to dball qual table
	call	getqtblptr
	mov	ax,[di]			; get default color
	mov	bbclr,al		; default is blue
	pop	di
	pop	si
	cmp	word ptr [si+50],0
	jz	headup
	mov	dx,[si+10]
	mov	ax,[si+8]
	or	dx,dx
	js	headup
	jz	chklower
	jns	headdown
chklower:
	cmp	ax,bbsize
	jb	headup
	push	di
	mov	di,qtblptr		; reinstate quality table ptr
	mov	ax,[di+4]		; get cornering limit for yaw
	wtadj
	mov	dx,ax
	call	rand_w
	cmp	ax,dx
	ja	bbt1
	neg	word ptr [si+50]	; change direction
bbt1:
	pop	di
	ret
headup:	
	push	di
	mov	di,qtblptr		; reinstate quality table ptr
	mov	ax,[di+2]		; get cornering limit for yaw
	pop	di
	wtadj
	mov	[si+50],ax
	ret
headdown:
	push	di
	mov	di,qtblptr		; reinstate quality table ptr
	mov	ax,[di+2]		; get cornering limit for yaw
	pop	di
	wtadj
	neg	ax
	mov	[si+50],ax
	ret
.endp

.proc	mortim	auto
IF slalom
	push	si
	push	di
	jc	skipmrtstuff
	pushf
	mov	n,10			; use white green color for rdr dot
	call	radarprocess		; get distance, angle, and place a dot
					; on the radar
	call	rdrupdatecldst
	popf
skipmrtstuff:
	pop	di
	pop	si
ELSE
	jnc	nomortdie
	call	enoughits
	jnc	mortsaved
	push	si
	push	di
	mov	boomdeadly,0		; make wimpy
	call	strtboom		; do a boom
	inc	ondest
	inc	nsitesdest
	mov	bx,9			; three pieces
	mov	omniflag,1		; all around explosion
	call	strtflt		; do a boom
	pop	di
	pop	si
	mov	word ptr [si+24],0	; schedule this for destruction
mortsaved:
	ret
nomortdie:	
	mov	ax,[si+52]
	cmp	ax,morttime-mortrechargetime
	ja	notcharged
	mov	[si+52],morttime-mortrechargetime
	cmp	byte ptr [si+18],0
	jnz	notcharged
	mov	ax,[si]		; get distance away from last frame
	mov	dx,[si+2]
	sub	ax,oxeff	
	sbb	dx,oxeff+2
	.abs_d	dx,ax
	mov	cx,[si+4]
	mov	bx,[si+6]
	sub	cx,oxeff+4
	sbb	bx,oxeff+6
	.abs_d	bx,cx
	add	ax,cx
	adc	dx,bx
	mov	bx,word ptr mortfiredist+2
	mov	cx,word ptr mortfiredist
	.cmp_dd	dx,ax,bx,cx
	ja	notcharged
	mov	word ptr [si+52],morttime
	push	si
	push	di
	mov	flttype,3		; flag that we are shooting a mortar
	mov	omniflag,0		; make it spew up
	mov	bx,2			; three pieces
	call	strtflt		; do a boom
	mov	flttype,0		; put back to normal operation
	pop	di
	pop	si
notcharged:
ENDIF ; slalom
	ret
.endp

.proc	walltim	auto			; does wall code
	jnc	nowalldie
	mov	ax,[si+40]
	mov	[si+44],ax
	mov	word ptr [si+52],32000
	ret
nowalldie:
	push	di
	mov	di,offset @dataseg:wallqtbl	; point to dball qual table
	call	getqtblptr
	mov	ax,[di]
	mov	wallc,al
	pop	di

IF slalom EQ 0
	cmp	curndeadhqs,0
	jnz	wallshutdown
	or 	bl,bl
	jnz	nowalldisp	; if not a flashing one, make it solid
	cmp	word ptr [si+52],31992
	ja	nowalldisp
	mov	word ptr [si+52],31990
	mov	ax,offset @dataseg:nulobj
	mov	[si+44],ax
nowalldisp:
ENDIF
	ret
IF slalom EQ 0
wallshutdown:
	cmp	nhqs,0
	jnz	nowalldisp
	mov	word ptr [si+24],0
	ret
ENDIF
.endp

.proc	lwalltim	auto			; does wall code
	jnc	nolwalldie
	ret
nolwalldie:
	push	di
	mov	di,offset @dataseg:wallqtbl	; point to dball qual table
	call	getqtblptr
	mov	ax,[di]
	or	ax,ax				; if color is -1, then
						; use clrhq
	jns	usetblclr
	mov	al,clrhq
usetblclr:
	mov	lwallclr,al
	pop	di
	cmp	curndeadhqs,0
	jnz	lwallshutdown
	mov	word ptr [si+52],32000
nolwalldisp:
	ret
lwallshutdown:
	cmp	nhqs,0
	jnz	nolwalldisp
	mov	word ptr [si+24],0
	ret
.endp


.proc	initnumbers	auto		; keep track of numbers of sites

IF slalom
	mov	ax,distclosest
	mov	bl,radarstat	; see if radar has already changed this frm
	xor	bl,oldradarstat
	jnz	skiprdrsc	; if so, then don't do anything
	mov	dl,0		; default is out of range
	cmp	ax,alertdistance		; 800 is spotted
	ja	stillwarn
	mov	dl,1		; leave potential spotted code
	cmp	ax,warndistance
	ja	stillwarn
	mov	dl,2		; default is warning
	cmp	ax,alarmdistance		; 800 is spotted
	ja	stillwarn
	mov	dl,3		; leave potential spotted code
stillwarn:
	mov	bl,radarstat	; closer...
	cmp	dl,bl		; if already set coorectly, leave
	jz	skiprdrsc
	jb	backone
	inc	radarstat	; move us up
	jmp	skiprdrsc
backone:
	dec	radarstat
skiprdrsc:
	mov	distclosest,7fffh
ENDIF
	mov	kladist,64
	mov	orbdist,63		; default is no orb
	mov	orbfreq,128
	mov	saucerdist,256
	xor	ax,ax		; if we kept score last frame, skip it here
	cmp	addprogflag,al
	jz	notogprog
	mov	addprogflag,al
notogprog:
	mov	ax,cs:oticks
	sub	ax,lasttick
	cmp	ax,2048
	jb	noprogadd
	mov	addprogflag,-1	; set flag to add progress to charts
noprogadd:

	mov	cx,8			; first lets find the score
					; capability of the current # of aa
					; and dballs
	xor	dx,dx
	mov	newaasum,dx
	mov	newdballsum,dx

nmaxloop:
	mov	bx,cx
	neg	bx
	add	bx,8
	add	bx,bx			; form word offset into tables
	mov	ax,[bx+offset @dataseg:tcurndballs]
	mov	dx,cx
	neg	dx
	add	dx,9
	mul	dx
	add	newdballsum,ax		; #dballs * qual of each type
	mov	ax,[bx+offset @dataseg:tcurnaa]
	mov	dx,cx
	neg	dx
	add	dx,9
	mul	dx
	add	newaasum,ax
	loop	nmaxloop
	



	mov	cx,8
	xor	dx,dx
nmaxloop1:
	mov	bx,cx
	neg	bx
	add	bx,8
	add	bx,bx			; form word offset into tables
	mov	ax,[bx+offset @dataseg:tcurndballs]
	mov	dx,dballsum
	cmp	newdballsum,dx
	jbe	notpeakdb
	mov	[bx+offset @dataseg:maxdbonme],ax
notpeakdb:
	xor	dx,dx
	mov	[bx+offset @dataseg:tcurndballs],dx
	mov	ax,word ptr [bx+offset @dataseg:tcurnaa]
	mov	dx,aasum
	cmp	newaasum,dx
	jbe	notpeakaa
	mov	[bx+offset @dataseg:maxaaonme],ax
notpeakaa:
	xor	dx,dx
	mov	[bx+offset @dataseg:tcurnaa],dx
	loop	nmaxloop1

	mov	ax,curnals
	cmp	ax,maxnals
	jbe	labl001
	mov	maxnals,ax
labl001:
	mov	dx,aasum	 ; only update maximum if it is a true maximum
	cmp	newaasum,dx
	jbe	notpeakaa1
	mov	ax,newaasum
	mov	aasum,ax
notpeakaa1:
	mov	dx,dballsum	 ; only update maximum if it is a true maximum
	cmp	newdballsum,dx
	jbe	notpeakdb1
	mov	ax,newdballsum
	mov	dballsum,ax
notpeakdb1:


	mov	ax,curnrvs
	mov	maxnrvs,ax
	mov	ax,curnticks
	mov	maxnticks,ax
	mov	ax,curndbst
	mov	maxndballs,ax
	mov	ax,curnvest
	mov	maxnvechs,ax
	mov	ax,curnvechs
	mov	nvechs,ax
	mov	ax,curndballs
	mov	ndballs,ax
	mov	ax,ndeadhqs
	mov	curndeadhqs,ax
	mov	ax,curnbmrs
	mov	nbmrs,ax
	mov	ax,curnbmrst
	mov	nbmrst,ax
	mov	ax,curnals
	mov	nals,ax
	mov	ax,curnstets
	mov	nstets,ax
	mov	ax,curntets
	mov	ntets,ax
	mov	ax,curnaas
	mov	naas,ax
	mov	ax,curnhqs
	mov	nhqs,ax
	xor	ax,ax
	mov	curnhqs,ax
	mov	curnaas,ax
	mov	curnstets,ax
	mov	curntets,ax
	mov	curnals,ax
	mov	curndbst,ax
	mov	curnvest,ax
	mov	curndballs,ax
	mov	curnvechs,ax
	mov	curnticks,ax
	mov	curnrvs,ax
	mov	curnbmrs,ax
	mov	curnbmrst,ax
	mov	ndeadhqs,ax
	mov	haltflag,al
	call	changewallobjs
	ret
.endp

.proc	dhqtim	auto
	pushf
	mov	[si+52],32000		; object will live forever
	inc	ndeadhqs

	test	word ptr [si+24],200h	; is mission completed?
	jz	nonodrop		; then don't let it drop!
	cmp	word ptr [si+10],0
	jnz	yesdrop
	cmp	word ptr [si+8],lhq*4
	jbe	nodrop
	
yesdrop:
	call	randspin

	mov	byte ptr [si+64],35		; make it fall
	jmp	nonodrop

nodrop:
	xor	ax,ax			; set velocity to zero
	mov	word ptr [si+10],ax
	mov	word ptr [si+8],xgmx
	mov	[si+46],ax
	mov	[si+48],ax
	mov	[si+50],ax
	mov	[si+60],ax		; set dispersion and wind resistance
	mov	[si+62],ax		; to zero
nonodrop:

	popf
	and	tripflag,NOT 2		; default is no trip

	jmp	hqtim1
.endp

.proc	attractplane	auto
	cmp	ejectflag,0
	jz	yesattract
noattract1:
	jmp	noattract
yesattract:
	call	getobsvec		; get observer vector
	mov	ax,dballdist		; get distance
	cmp	ax,5000
	ja	noattract1
	mul	ax			; distance squared
	
	mov	bx,5000
	div	bx
	cmp	ax,10
	ja	divnotzero
	mov	ax,10
divnotzero:
	mov	bx,ax

	mov	ax,dxvec		; load vector to handy location
	mov	dx,dxvec+2
;	mov	al,ah
;	mov	ah,dl
;	mov	dl,dh
	rept	3
	sar	dx,1
	rcr	ax,1
	endm
	idiv	bx
;	neg	ax			; changing sign as we go
	wtadj
	add	rtopv,ax

	mov	ax,dxvec+4		; load vector to handy location
	mov	dx,dxvec+6
;	mov	al,ah
;	mov	ah,dl
;	mov	dl,dh
	rept	3
	sar	dx,1
	rcr	ax,1
	endm
	idiv	bx
;	neg	ax			; changing sign as we go
	wtadj
	add	rtopv+2,ax

	mov	ax,dxvec+8		; load vector to handy location
	mov	dx,dxvec+10
;	mov	al,ah
;	mov	ah,dl
;	mov	dl,dh
	rept	3
	sar	dx,1
	rcr	ax,1
	endm
	idiv	bx
;	neg	ax			; changing sign as we go
	wtadj
	add	rtopv+4,ax


noattract:
	ret
.endp

hqgrav	equ	70

.proc	hqtim	auto
	inc	curnhqs
;	cmp	closetowerflag,-1	; don't let missions complete while
;					; at home base
;	jz	hqtret
	and	tripflag,NOT 2		; default is no trip
	mov	tripamount,0
	mov	orbdist,63		; assume no orb around
	push	si
	call	normrel3d		; we don't want distance to plane!
	pop	si
	jc	hqtim1
;	xor	ax,ax
;	push	ax
;	test	word ptr [si+24],800h	; check special bit
;	jnz	tripisok		; don't shake if gravity is on
;	pop	ax
	mov	ax,dballdist
	cmp	ax,2000
	ja	hqtim1			; too far for effect
	or	tripflag,2		; give us a little flag to trip by
	mov	bx,hqgrav			; turn 0-1000 into 75 to 0
	mul	bx
	mov	bx,2000
	div	bx			; now is 0-75
	push	ax
	neg	ax
	add	ax,hqgrav+1
	cmp	ax,hqgrav/2
	jbe	tripisok
	mov	ax,hqgrav/2		; curb the trip a little
tripisok:
	mov	tripamount,ax
	pop	ax
	cmp	ax,63			; this will be a loudness
	jbe	odjr			; orb distance ok
	mov	ax,63
odjr:
	mov	orbdist,ax
	mov	ax,tripamount
	test	word ptr [si+24],800h	; check special bit
	jz	hqtim1			; if nograv, forget it!
	call	attractplane		; if grav, attract plane
hqtim1:
	mov	[si+52],32000		; object will live forever
	push	di
	push	si
	mov	di,offset @dataseg:hqtbl	; point to dball qual table
	call	getqtblptr
	mov	ax,[di]			; get default color
	mov	clrhqb,al		; default is blue
	mov	clrhqc,0
	test	word ptr [si+24],800h
	jz	nogravflash
	test	cs:oticks,512
	jz	nogravflash
	mov	clrhqc,15
nogravflash:
	test	word ptr [si+24],0200h
	jz	nocmpltbitset
	test	cs:oticks,512+256	; hmm
	jnz	nocmpltbitset
	xor	clrhqb,08h		; reverse intensity bit for base color
nocmpltbitset:
	pop	si
	push	si
	cmp	byte ptr [si+18],0
	jz	mustkillcode		; if near, run code no matter
	mov	dx,[si+22]		; if med near, must be closer to
	mov	ax,[si+20]		; to run code
	.cmp_dd	dx,ax,[si+34],[si+32]	; are we too far for med near?
	ja	skipkillcode		; only run code if nice and near
mustkillcode:
	call	[di+2]		; get addr of code to run
skipkillcode:
	pop	si
	pop	di
hqtret:
	ret
.endp

.proc	killme	auto		; this sets complete flag if the orb me
				; blows up
;	cmp	word ptr [si+72],0	; if it is a hq, then it should be zero
;	jz	hqok
;	cmp	nhqs,0
	cmp	word ptr [si+72],0	; if we are still an orb, we aren't don
	jz	hqok		; light up when all hqs are dead
	call	incondest	; inc # objectives variable
hqok:
	ret
.endp

.proc	killmetough	auto	; this sets complete flag if the orb me
				; blows up

	mov	byte ptr [si+27],hqhits	; fully regenerate any damage
					; only a plane hit can take us
	cmp	word ptr [si+72],0	; if it is a hq, then it should be zero
	jz	toughhqok
	mov	ax,missionstatus	; if user hasn't crashnothomed, then
					; leave flag to not penalize
	or	ax,8000h		; leave flag that suicide mission succesful
	mov	missionstatus,ax
	test	ax,40h			; crashed not home bit
	jnz	skipclear		; if already crashed not home, punt
	and	patchcrash,NOT 40h
skipclear:
	inc	nkillmetough		; keep track of how many times we be
					; killed
	call	incondest	; inc # objectives variable
toughhqok:
	ret
.endp

.proc	killticks	auto		; this sets complete flag if the orb me
				; blows up
	mov	ax,ntets	; both all ticks and tets must be dead
	add	ax,maxnticks	; are all the ticks dead?
	jnz	thqok
	call	incondest	; inc # objectives variable
thqok:
	ret
.endp

.proc	killal	auto		; this sets complete flag if the aliens are
				; all killed
	cmp	maxnals,0
	jz	alhqok
	cmp	nals,0		; are they all dead?
	jnz	alhqok		; no, then no mission accomplished yet
	call	incondest	; inc # objectives variable
alhqok:
	ret
.endp

.proc	killstets	auto	; sets complt flag if the stets are eliminated
	cmp	nstets,0	; are they all dead?
	jnz	stsqok		; no, then no mission accomplished yet
	call	incondest	; inc # objectives variable
stsqok:
	ret
.endp

.proc	killbmrst	auto	; sets complt flag if the stets are eliminated
	mov	ax,nbmrst	; sum of bombers plus sites
	add	ax,nbmrs
	jnz	bmrstqok		; no, then no mission accomplished yet
	call	incondest	; inc # objectives variable
bmrstqok:
	ret
.endp


.proc	killdbaa	auto	; sets cmplt flg upon term of all aa+db sites
	mov	ax,maxndballs	; this is the number of sites
	add	ax,naas
	jnz	dbaaqok
	call	incondest
dbaaqok:
	ret
.endp

.proc	killvechs	auto	; lights cmplt when all vechs and sites killed
	mov	ax,maxnvechs
	add	ax,nvechs
	jnz	nvqok
	call	incondest
nvqok:
	ret
.endp



.proc	incondest	auto	; increment the number of objectives reached
	test	word ptr [si+24],200h	; has the objective been done?
	jnz	lockedout
	inc	nhqsdest
	or	word ptr [si+24],200h	; lock out ondest from futher incs until
	cmp	cmpltflag,0
	jnz	ihqok			; ignore if already set
	mov	cmpltflag,-1		; set mission complete flag
ihqok:
	mov	rmsgqueue,offset @dataseg:cmpltrmsg
				; we are long gone
	cmp	totaldamage,16
	jb	lockedout
	mov	rmsgqueue,offset @dataseg:cmpltdmsg
lockedout:
	ret
.endp

.proc	bdest	auto	; destroys bullet
	jnc	nobdest
	mov	ax,[si+10]	; check for hitting pavement
	js	nobdest		; no explosions for hitting pavement
	push	di
	mov	al,[di+19]	; get other guy's object class
	and	al,3		; make fltsom harmless
	mov	flttype,al
	push	si
	mov	bx,2				; twelve destruction pieces
	mov	omniflag,1			; omni-directional explosion
	call	strtflt				; start a piece of flotsom
	pop	si
	mov	flttype,0
	pop	di
	mov	word ptr [si+24],0	; remove bullet from table
nobdest:
	ret
.endp


.proc	rescuestart	auto	; gets rescue van start coords

	mov	si,offset @dataseg:startcoords
	mov	di,offset @dataseg:kbuf
	mov	ax,ds
	mov	es,ax
	cld
	mov	cx,4
	rep	movsw

	mov	ax,7
	mov	initialqual,ax
	mov	di,offset @dataseg:objrv
	mov	si,offset @dataseg:kbuf
	mov	word ptr [si+8],50
	mov	word ptr [si+10],0
	mov	word ptr [si+12],0
	mov	word ptr [si+14],0
	mov	word ptr [si+16],0
	call	strtperm

	mov	si,expobj
	mov	byte ptr [si+18],3	; set up default distance

	mov	cx,16			; max number of tries
rvsloop:
	mov	al,[si+18]		; get distance code
	and	al,0feh
	jz	closeenuf
	push	cx
	mov	si,expobj
	call	disteval		; get dxvector to point the way

	mov	ax,dxvec
	mov	dx,dxvec+2
	sar	dx,1
	rcr	ax,1			; divide diff coords by 2
	sub	[si],ax
	sbb	[si+2],dx		; then subtract from original coords
	mov	ax,dxvec+4
	mov	dx,dxvec+6
	sar	dx,1
	rcr	ax,1			; divide diff coords by 2
	sub	[si+4],ax
	sbb	[si+6],dx		; then subtract from original coords
	pop	cx
	loop	rvsloop			; go get next one
	mov	cs:cecode,75		; give error if never became close
	ret
closeenuf:


	ret
.endp

.proc	getobjtemp	auto		; given object code in ax, returns
					; address of template in di
	push	si
	mov	si,ax	; get addr in table to look up
	add	si,si		; make into word address
	mov	di,[si+offset @dataseg:templatetable] ; call destructo routine
	pop	si
	ret
.endp

.proc	shelltim	auto
	jnc	noshelldie
	push	di
	push	si
	
	mov	di,offset @dataseg:kbuf
	mov	ax,ds
	mov	es,ax
	cld
	mov	cx,9
	rep	movsw

	pop	si
	push	si	

	mov	di,offset @dataseg:shellqtbl	; point to dball qual table
	call	getqtblptr
	mov	ax,[di]				; get the damn object to make
	call	getobjtemp			; get the address of it
	mov	ax,[di+8]			; get default height
	mov	dx,[si+10]
	mov	si,offset @dataseg:kbuf
	mov	word ptr [si+8],ax
	mov	word ptr [si+10],dx
	mov	initialqual,7
	call	strtperm
	pop	si
	mov	word ptr [si+24],0		; cancel present object
	pop	di

noshelldie:
	push	di
	mov	di,offset @dataseg:shellqtbl	; point to dball qual table
	call	getqtblptr
	cmp	bl,6
	jnz	nocounttick
	inc	curnticks
nocounttick:
	mov	ax,[di+2]
	pop	di
	xor	al,al				; force color to be black
	mov	clrshell,al			; set up color

	mov	ax,[si+52]			; flash colors
	test	ax,16384			; is it in native mode?
	jz	nonative
	sub	ax,32000
	neg	ax				; how many frames elapsed
	push	ax
	mov	ax,30
	uwtadj
	pop	bx
	cmp	ax,bx
	jb	changecmode
	ret
changecmode:
	mov	[si+52],16000
	ret
nonative:
	push	di
	mov	di,qtblptr
	mov	ax,[di+4]
	mov	clrshell,al
	pop	di
	mov	ax,[si+52]			; flash colors
	sub	ax,16000
	neg	ax				; how many frames elapsed
	push	ax
	mov	ax,5
	uwtadj
	cmp	ax,2
	ja	avoidtosml
	mov	ax,2
avoidtosml:
	pop	bx
	cmp	ax,bx
	jb	changecmode1
	ret
changecmode1:
	mov	[si+52],32000
	ret
.endp

bmrclmpit	equ	-2400

.proc	strtbmr	auto	; starts a flotsom object, and lets it rip
	mov	oldobjptr,si	; save ptr to old object
	push	cx
	push	si		; save the target object
	mov	ax,50		; identity code for a bomber
	call	getobjtemp	; get the address of a bomber into di
	mov	expobj,di
	call	expstrt				; start the object
	jnc	expstrtokbmr
	pop	si
	pop	cx
	jmp	strexitbmr
expstrtokbmr:
	mov	expobj,si		; save ptr to our new object
	mov	di,expobj
	xor	ax,ax			; set distance to near
	mov	[di+18],al
	mov	ax,32000	; get time for object to last
	mov	[di+52],ax
	mov	si,di
	mov	ax,initialqual		; now we merge quality with obj type
	and	ax,7			; make sure no non-proper bits are set
	mov	cl,4
	ror	ax,cl			; mov bits to proper position
	or	ax,8000h		; set new object bit
	or	word ptr [si+24],ax	; make a timed object
	mov	bx,si
	xor	ax,ax			; set distance to near
	mov	[bx+46],ax
	mov	[bx+48],ax
	mov	[bx+50],ax
	mov	[bx+18],al
	mov	[bx+12],ax		
	mov	[bx+16],ax
	mov	[bx+14],ax	; set direction to be straight up
	mov	cx,6
	mov	ax,ds
	mov	es,ax
	mov	di,bx
	mov	si,oldobjptr
	rep	movsw
	pop	si
	pop	cx
	clc
	ret
strexitbmr:
	stc				; sumthin went wrong
	ret				; attempt failed, abort whole idea
	.endp

IF slalom
.proc	bmrstim	auto			; what does a dball site do?
	jnc	nobmrstdie		; do we just die?
	call	enoughits		; are we killed?
	jnc	bmrstsaved
	push	si
	push	di
	mov	boomdeadly,0		; make wimpy
	call	strtboom		; do a boom
	inc	ondest
	push	si
	push	di
	mov	di,offset @dataseg:bmrstqtbl	; point to dball qual table
	call	getqtblptr
	xor	bh,bh				; bl has quality
	add	bx,bx				; make word address
	inc	word ptr [bx+offset @dataseg:nsitesdest]
	pop	di
	pop	si
	mov	bx,9			; three pieces
	mov	omniflag,1		; all around explosion
	call	strtflt		; do a boom
	pop	di
	pop	si
	mov	word ptr [si+24],0	; kill us
	ret
bmrstsaved:
	push	di
	mov	di,offset @dataseg:bmrstqtbl	; point to dball qual table
	call	getqtblptr
	mov	ax,[di]	; get wing color
	mov	wingclr,al
	pop	di
	ret
nobmrstdie:

	call	updatecldst
	inc	curnbmrst
	push	si
	mov	n,10			; use light green color for rdr dot
	call	radarprocess		; get distance, angle, and place a dot
	pop	si
	push	di
	mov	di,offset @dataseg:bmrstqtbl	; point to dball qual table
	call	getqtblptr
	mov	ax,[di]	; get wing color
	mov	wingclr,al
	call	followangles		; propell car forward in direction
	pop	di
	ret
.endp
ELSE
.proc	bmrstim	auto			; what does a dball site do?
	jnc	nobmrstdie		; do we just die?
	call	enoughits		; are we killed?
	jnc	bmrstsaved
	push	si
	push	di
	mov	boomdeadly,0		; make wimpy
	call	strtboom		; do a boom
	inc	ondest
	push	si
	push	di
	mov	di,offset @dataseg:bmrstqtbl	; point to dball qual table
	call	getqtblptr
	xor	bh,bh				; bl has quality
	add	bx,bx				; make word address
	inc	word ptr [bx+offset @dataseg:nsitesdest]
	pop	di
	pop	si
	mov	bx,9			; three pieces
	mov	omniflag,1		; all around explosion
	call	strtflt		; do a boom
	pop	di
	pop	si
	mov	word ptr [si+24],0	; kill us
	ret
bmrstsaved:
	push	di
	mov	di,offset @dataseg:bmrstqtbl	; point to dball qual table
	call	getqtblptr
	mov	ax,[di]			; get default color
	mov	clrbmr,al		; default is blue
	mov	ax,[di+4]		; get our rest time
	mov	dbstrest,ax
	call	resetdbst
	pop	di
	ret
nobmrstdie:
	inc	curnbmrst
	push	di
	mov	di,offset @dataseg:bmrstqtbl	; point to dball qual table
	call	getqtblptr
	mov	ax,[di]			; get default color
	mov	clrfss1,al
	mov	ax,[di+2]
	mov	clrfss2,al
	mov	ax,[di+4]		; get our rest time
	mov	dbstrest,ax
	pop	di
	mov	ax,[si+52]		; get our time in existance

	cmp	ax,100		; are we due for another dball?
	jb	makebmr
	ret				; no, just hang out!
makebmr:
	mov	ax,nbmrst
	cmp	ax,nbmrs
	jbe	skipmakebmr
	mov	ax,100
	wtadj
	mov	bx,ax
	call	rand_w			; don't make one all right away
	cmp	ax,bx
	ja	skipmakebmr
	mov	bx,[si+24]		; get object type to get quality
	mov	cl,4			; rotate until obj qual bits are 
	rol	bx,cl			; in correct spot
	and	bx,7			; now quality is 0-7
	mov	initialqual,bx		; set dball's qual = to our own
	call	strtbmr			; then we start a dball at our coords
	inc	nbmrs			; make sure we know the bomber is there
	call	resetdbst
	ret
skipmakebmr:
	inc	word ptr [si+52]	; don't let us dissappear
	ret
.endp
ENDIF

.proc	atkmode	auto		; moves saucer towords startcoords
	mov	clrbmr,2
	mov	ax,dxvec
	sal	ax,1
	add	[si+46],ax	; move towards startcoords
	mov	ax,dxvec+4
	sal	ax,1
	add	[si+48],ax	; move towards startcoords
	mov	ax,3
	cmp	byte ptr [si+27],bmrhits/2	; are we hurting?
	ja	bmrnothurtin
	mov	ax,20		; make it 4 times more likely to break off
bmrnothurtin:
	mov	bmrmodecprob,ax	; leave small prob of attack
	cmp	bmrtargdist,13	; move out of attack mode only when close
				; to target
	ja	stickinatk
	mov	bmrmodecprob,50
stickinatk:
	ret
.endp


.proc	circmode	auto
	mov	clrbmr,1
	mov	ax,dxvec
	add	[si+48],ax	; move perp to startcoords
	mov	ax,dxvec+4
	neg	ax
	add	[si+46],ax	; move perp
	mov	di,qtblptr	; get quality table entry for color
	mov	ax,[di+18]
	mov	bmrmodecprob,ax	; load the prob
	ret
.endp

.proc	famode	auto		; fly away from startcoords
	mov	clrbmr,0
	mov	ax,dxvec
	sub	[si+46],ax	; move away startcoords
	mov	ax,dxvec+4
	sub	[si+48],ax	; move away startcoords
	mov	di,qtblptr	; get quality table entry for color
	mov	ax,[di+14]
	mov	bmrmodecprob,ax	; load the prob
	ret
.endp

.proc	slmode	auto		; do nothing, just fly along
	mov	clrbmr,3
	mov	di,qtblptr	; get quality table entry for color
	mov	ax,[di+20]
	mov	bmrmodecprob,ax	; load the prob
	ret
.endp



IF slalom
.proc	bmrtim	auto
	jc	skipbmrstuff
	pushf
	mov	n,1			; use white green color for rdr dot
	call	radarprocess		; get distance, angle, and place a dot
					; on the radar
	call	frmupdatecldst
	popf
skipbmrstuff:
	call	gmdest
	ret
.endp
ELSE
.proc	bmrtim	auto
	jnc	nobmrdie
	mov	al,byte ptr [si+27]	; save number of hits in a variable
	mov	bhits,al
;	cmp	word ptr [si+72],53	; is it a mission objective?
;	jnz	dontfilter
	cmp	di,-1		; has the plane hit?
	jz	bmrdestroy
	call	enoughits		; are we killed?
	jnc	bmrsaved
bmrdestroy:
	inc	ndest			; make it a resource
	push	si
	push	di
	mov	boomdeadly,0		; make it harmless
	call	strtboom		; do a boom
	pop	di
	pop	si
	push	si
	push	di
	mov	bx,9			; three pieces
	mov	omniflag,1		; all around explosion
	call	strtflt		; do a boom
	pop	di
	pop	si
	and	word ptr [si+24],NOT 8	; change us into a non-destructable obj
	mov	bx,4000
	call	randr_w		; make it spin in uncontrolled manner
	mov	[si+54],ax
	call	randr_w		; make it spin in uncontrolled manner
	mov	[si+56],ax
	call	randr_w		; make it spin in uncontrolled manner
	mov	[si+58],ax
	cmp	word ptr [si+72],53	; is it the mission objective kind of saucer?
	jnz	skipmostuff	; no, so just leave
	call	incondest
skipmostuff:
	ret
bmrsaved:
	mov	al,bhits
	sub	al,[si+27]	; get number of hits gotten
	js	donottip
	cbw
	mov	bx,400
	mul	bx
	add	word ptr [si+16],ax	; give saucer a kick in the cullionies
donottip:
	ret

nobmrdie:
	inc	curnbmrs
	push	di
	push	si

	mov	di,offset @dataseg:bmrqtbl	; point to dball qual table
	call	getqtblptr
	mov	ax,[di+12]		; get default speed from table
	mov	dballavgvel,ax		; the default target speed
	mov	ax,[di]
	mov	clrfs1,al
	mov	clrfss1,al
	mov	ax,[di+2]
	mov	clrfs2,al
	mov	clrfss2,al
	test	cs:oticks,512
	jz	usefss2
	mov	al,clrfs1
usefss2:
	mov	n,al
	call	radarprocess		; get distance, angle, and place a dot
	jc	notclosest
	test	word ptr [si+24],8	; look at destruct bit to see if we
					; have been shot down
	jz	deadsilents
	mov	ax,ssdist
	cmp	ax,saucerdist
	ja	notclosest
	mov	saucerdist,ax		; find nearest saucer
	mov	ah,bmrhits		; find how healthy we are
	mov	bl,ah
	inc	bl
	mov	ah,[si+27]	; get number of hits gotten
	xor	al,al
	div	bl		; find health from 0 to 255
	add	al,2		; minimum frequency
	mov	ssfreq,al
deadsilents:
notclosest:


	cmp	word ptr [si+72],53	; is it a mission objective?
	jnz	nomo
	mov	al,clrhq		; make outer ring flash
	mov	clrfss1,al
	mov	clrfss2,al

	cmp	word ptr [si+52],32700	; are we still in resting state?
	jb	nomo			; if taken off, let loose
	test	word ptr [si+24],4000h	; if lower quality mo, just take off
	jnz	yesmo
	mov	word ptr [si+52],32000
	jmp	nomo
yesmo:
	cmp	byte ptr [si+27],bmrhits/2	; have we taken damage?
	jb	takeoff			; if not, then stay on ground
	mov	word ptr [si+52],32767	; restore timer value
bmrdonothing:
	jmp	abortnobmbdie		; exit having done nothing
takeoff:
	mov	byte ptr [si+27],bmrhits	; repair damage
	mov	word ptr [si+52],32000	; change timer value to flag active
	inc	ndeadhqs		; kill the shields
	
nomo:
	cmp	demoflag,0
	jz	bmrdonothing1
	cmp	byte ptr [si+27],bmrhits-1
	jae	bmrdonothing
bmrdonothing1:
	test	word ptr [si+24],8	; look at destruct bit to see if we
					; have been shot down
	jnz	itisalive
	mov	dx,[si+10]		; if under ground, blow up good
	mov	ax,[si+8]
	sub	ax,1000
	sbb	dx,0
					; reinstate damping
	jns	noexplo
	mov	bx,12			; three pieces
	mov	omniflag,0		; all around explosion
	call	strtflt			; do a boom
	mov	bx,15			; three pieces
	call	strtincend		; do a boom
	mov	word ptr [si+24],0	; kill poor saucer when hits ground
	call	bigboom			; make big sound on impact

noexplo:
IF 1 EQ 0
	mov	ax,900
	wtadj
	mov	bx,ax
	call	rand_w
	shr	ax,1
	cmp	ax,bx
	ja	skipshards
	mov	omniflag,1		; all around explosion
	mov	bx,2
	call	strtshard
skipshards:
ENDIF

	mov	byte ptr [si+64],15
	mov	word ptr [si+60],20
	mov	word ptr [si+62],18000
	jmp	abortnobmbdie

itisalive:

	mov	bx,word ptr [si+52]
	inc	bx
	mov	ax,3
	wtadj				; subtract a const from time
	sub	bx,ax
	jns	isnicepos
	xor	bx,bx			; don't let drop below zero
isnicepos:
	mov	[si+52],bx


	mov	ax,[si+16]		; get roll
	mov	cl,4
	sar	ax,cl			; divide by 8
	neg	ax
	add	[si+16],ax		; exponential fall off for roll

	
	add	[si+12],4000

	mov	ax,[si+14]		; get current pitch
	mov	bmrdespit,ax		; make it the desired pitch

	mov	ax,[si+8]	; get height
	mov	dx,[si+10]

	sub	ax,0
	sbb	dx,3

	mov	al,ah
	mov	ah,dl
	neg	ax		; if too low, rise up!
	cwd
	mov	bx,100
	idiv	bx
	mov	bx,ax
	.abs_w	bx
	cmp	bx,40
	jb	zadjok
	bndck	15,-15
zadjok:
	wtadj			; relativise!
	add	[si+50],ax
	mov	bx,[si+50]
	mov	ax,20
	uwtadj			; the slower the machine, the more damping
	or	ax,ax
	jnz	bmrdampok
	mov	ax,1
bmrdampok:
	xchg	ax,bx
	cwd
	idiv	bx		; divide z velocity by the damping constant
	sub	[si+50],ax

flylevel:
	call	startvector

	mov	bx,[si+24]		; put mode bits from object type
	and	bx,6			; strip off unneeded bits
	mov	bmrmode,bx
	call	[bx+offset @dataseg:bmdtbl]	; call code
	call	rand_w			; get random number
	shr	ax,1
	mov	bx,ax
	mov	ax,bmrmodecprob		; get prob of a mode switch
	wtadj
	cmp	bx,ax
	ja	nomodechg
	mov	bx,bmrmode
	add	bx,2
	and	bx,6
	and	[si+24],NOT 6
	or	[si+24],bx		; put mode bits back into bomber type
nomodechg:

					; drop a bomb if can

	cmp	bmrtargdist,13	; move out of attack mode only when close
				; to target
	ja	qsendamis

	cmp	word ptr [si+10],0	; don't drop a bomb if too low
	jnz	norandbomb1
	jmp	norandbomb
norandbomb1:
	call	rand_w
	shr	ax,1		; don't get into a tizzie over the sign
	mov	di,qtblptr	; get quality table entry for color
	cmp	ax,[di+22]	; get probability of a bomb drop
	ja	norandbomb
	call	strtbomb1	; drop a bomb from a flying saucer
	mov	bx,expobj	; get address of bomb
	or	word ptr [bx+24],2	; declare it to be a saucer bomb
	jmp	norandbomb

qsendamis:
;	mov	al,3
;	call	getkbit
;	jnz	makesmis
	call	rand_w
	shr	ax,1		; don't get into a tizzie over the sign
	mov	di,qtblptr	; get quality table entry for color
	cmp	ax,[di+24]	; get probability of a bomb drop

	ja	norandbomb

makesmis:
	test	word ptr [si+24],8	; look at destruct bit to see if we
					; have been shot down
	jz	saucerfalling1		; don't shoot if saucer falling

	mov	di,qtblptr	; get quality table entry for color
	mov	ax,ndballs	; how many dballs are in the sky?
	cmp	al,[di+26]	; are there too many?
	ja	norandbomb	; then don't make another!
	mov	bx,[si+24]		; get object type to get quality
	mov	cl,4			; rotate until obj qual bits are 
	rol	bx,cl			; in correct spot
	and	bx,7			; now quality is 0-7
	mov	initialqual,bx		; set dball's qual = to our own
	inc	ndballs			; show that we have created one
	mov	ax,qtblptr	
	push	ax			; save qtblptr
	call	strtdball	; then we start a dball at our coords
	pop	ax
	mov	qtblptr,ax	; restore it
	mov	di,expobj	; make newly created dball fall
	mov	byte ptr [di+64],20
	mov	word ptr [di+60],20
	mov	word ptr [di+62],16000
	mov	ax,60
	uwtadj
	add	ax,dballtime2
	mov	[di+52],ax	; make dballs only be inactive for 3 seconds

saucerfalling1:		; don't shoot if saucer falling
norandbomb:


	mov	ax,32000
	sub	ax,[si+52]
	cmp	ax,1000
	jb	getssinarg
	mov	word ptr [si+52],32000
	xor	ax,ax
getssinarg:
	wtadj			; relativise
	push	ax		; save it
	mov	di,qtblptr	; get quality table entry for color
	cmp	word ptr [di+6],0	; do we jink?
	jz	nojink
	mov	bx,[di+4]	; get period info
	shl	bx,1
	shl	bx,1
	shl	bx,1
;	mov	bx,8*24
	mul	bx
	push	si
	call	ssin
	pop	si
	neg	ax		; make it go up at first
	mov	di,qtblptr	; get quality table entry for color
;	hmul	ax,140
	hmul	ax,[di+6]
	mov	ax,[si+10]	; make sure it is high enough
	or	ax,ax
	jz	nohtbounce
	add	[si+50],dx	; put some sin in the height 
nohtbounce:
nojink:
	pop	ax
;	mov	bx,8*40
	mov	di,qtblptr	; get quality table entry for color
	cmp	word ptr [di+10],0	; do we serpentine?
	jz	noserp
	mov	bx,[di+8]
	shl	bx,1
	shl	bx,1
	shl	bx,1
	mul	bx
	push	ax
	push	si
	call	ssin
	pop	si
	neg	ax		; make it go up at first
	mov	di,qtblptr	; get quality table entry for color
	hmul	ax,[di+10]
;	hmul	ax,100
	add	[si+46],dx	; put some sin in the height 
	pop	ax
	push	si
	call	scos
	pop	si
	neg	ax		; make it go up at first
	hmul	ax,100
	add	[si+48],dx	; put some sin in the height 
noserp:


IF 1 EQ 0
	mov	cl,3
	sar	ax,cl
	add	bmrdespit,ax	; jink the pitch
	
	mov	ax,20		; make time constant twenty frames
	uwtadj			; bigger time constant for faster computers
	cmp	ax,2
	jae	tconstok
	mov	ax,2
tconstok:
	mov	bx,ax
	mov	ax,bmrdespit
	sub	ax,[si+14]
	cwd
	idiv	bx
	add	[si+14],ax	; apply desired pitch correction to pitch
ENDIF	
gowherepoint:


	pop	si
	push	si
	add	si,46			; point to velocity
	call	vmag			; get present velocity
	mov	olddballvel,ax		; leave in variable
	mov	dballvel,ax		; leave in variable

	mov	di,qtblptr	; get quality table entry for color
	call	adjdballv

	pop	si
	push	si
	mov	bx,dballvel		; set velocity of dballs
	mov	cx,olddballvel		; set velocity of dballs
	cmp	bx,cx			; which is larger?
	ja	abortspdchg		; if we are too slow, abort
	mov	ax,cx
	or	ax,ax			; check for divide by zero
	jz	abortspdchg
	sal	ax,1			; make sure dballvel is not > 2old
	cmp	bx,ax
	jle	proceedwi
	mov	bx,2
	mov	cx,1		; then just a factor of two
proceedwi:
	mov	ax,[si+46]		; set to new velocity
	imul	bx
	idiv	cx
	mov	[si+46],ax
	mov	ax,[si+48]		; set to new velocity
	imul	bx
	idiv	cx
	mov	[si+48],ax
	mov	ax,[si+50]		; set to new velocity
	imul	bx
	idiv	cx
	mov	[si+50],ax
abortspdchg:
abortnobmbdie:
	test	word ptr [si+24],8	; look at destruct bit to see if we
					; have been shot down
	jz	saucerfalling2		; don't shoot if saucer falling
	mov	di,qtblptr		; see if we are a type who shoots
	cmp	byte ptr [di+27],0
	jz	noshootatall		; don't shoot if lowest qual
	call	shootshells		; shoot shells from aa
saucerfalling2:
noshootatall:
	pop	si
	pop	di

	ret
.endp
ENDIF


.proc	shootshells	auto		; shoots aa shells from a saucer
	push	si				; save address of saucer
	mov	di,offset @dataseg:mapobjbuf	; use this buffer as temp space
						; to hold a virtual aa site
	mov	ax,ds				; first move center coords
	mov	es,ax
	mov	cx,6
	rep	movsw				; move coords
	xor	ax,ax				; zero out angles
	mov	cx,3
	rep	stosw
	pop	si
	mov	di,offset @dataseg:mapobjbuf	; use this buffer as temp space
	mov	ax,[si+24]			; make aa site qual same as
	mov	bx,ax				; but make maximum qual 6
	mov	cl,4
	rol	bx,cl
	and	bl,7
	cmp	bl,5
	jbe	bmrqok
	mov	bl,5
bmrqok:
	ror	bl,cl
	and	ax,NOT 7000h			; clear quality bits
	or	ah,bl				; put new bits inplace
	mov	[di+24],ax			; the saucer	
	mov	ax,[si+18]			; get distance and class
	mov	[di+18],ax
	mov	saucerflag,-1			; let code know it's a saucer
	push	si
	mov	si,di				; pass addr of mapobjbuf
						; as startaddr of aa
	call	sauceraa			; jump into aa code
	pop	si
	ret
.endp

.proc	startvector	auto		; gets a small magnitude vector
					; for which direction to startcoords
					; for a nice bombing run
	mov	di,offset @dataseg:startcoords
	mov	dx,[di+2]
	mov	ax,[di]
	sub	ax,[si]
	sbb	dx,[si+2]
	mov	dxvec+2,dx
	mov	dxvec,ax
	mov	dx,[di+6]
	mov	ax,[di+4]
	sub	ax,[si+4]
	sbb	dx,[si+6]
	mov	dxvec+6,dx
	mov	dxvec+4,ax
	mov	cx,31
strtvloop:
	mov	dx,dxvec+2
	mov	ax,dxvec
	.abs_d	dx,ax
	or	dx,dx
	jnz	md1
	or	ax,ax
	js	md1
	cmp	ax,10			; is nice and small?
	ja	md1
	mov	dx,dxvec+6
	mov	ax,dxvec+4
	.abs_d	dx,ax
	or	dx,dx
	jnz	md1
	or	ax,ax
	js	md1
	cmp	ax,10			; is nice and small?
	ja	md1
	jmp	svloopdn
md1:
	mov	dx,dxvec+2
	mov	ax,dxvec
	sar	dx,1
	rcr	ax,1
	mov	dxvec+2,dx
	mov	dxvec,ax

	mov	dx,dxvec+6
	mov	ax,dxvec+4
	sar	dx,1
	rcr	ax,1
	mov	dxvec+6,dx
	mov	dxvec+4,ax

	loop	strtvloop
svloopdn:
	mov	clrlsph,12
	sub	cx,31
	neg	cx		; make 30-0 into 0 to 30
	mov	dballlock,cx
	mov	bmrtargdist,cx	; save for other code
	cmp	cx,14
	ja	clrisred
	mov	clrlsph,0	; make it black when close
clrisred:
	ret
.endp

.proc	stettim	auto
	jnc	nostetdie
	cmp	word ptr [di+72],20		; is it a bomb?
	jz	stetblows
	cmp	word ptr [di+72],32		; is it a crater?
	jz	stetblows
	jmp	stetsaved		; no, so don't blow
stetblows:
	test	word ptr [si+24],800h	; is it a special tet?
	jz	tetnotspec
	test	word ptr [di+24],800h	; is bomb an assasin bomb?
	jz	stetsaved		; no, then ignore plane-dropped bomb
tetnotspec:
	call	enoughits		; are we killed?
	jnc	stetsaved
	push	si
	push	di
	mov	boomdeadly,20h		; make deadly
	call	strtboom		; do a boom
	pop	di
	pop	si
	push	si
	push	di			; reset registers
	mov	bx,3			; three pieces
	mov	omniflag,1		; all around explosion
	call	strtshard
	pop	di
	pop	si
	mov	word ptr [si+24],0	; kill object
	and	tripflag,NOT 1		; kill trip
	xor	ax,ax
	mov	haluclrs,ax
	mov	haluclrs+2,ax
	mov	haluclrs+4,ax
	push	si
	call	distcolors
	pop	si
stetsaved:
;	mov	omniflag,1		; all around explosion
;	mov	bx,2
;	call	strtflt		; do a boom
	ret
nostetdie:
	inc	word ptr [si+52]	; object lasts forever
	inc	curnstets		; keep track of how many there are
;	test	word ptr [si+24],4
;	jz	turnonspace
turnonspace:
	push	si
;	call	getobsvec
	call	normrel3d		; we don't want distance to plane!
	pop	si
	jc	dontspaceout
	cmp	dballdist,1000
	ja	dontspaceout
	or	word ptr [si+24],4	; turn on weird effect
	mov	ax,dballdist
	mov	bx,1000
	sub	ax,bx			; 0 if far, 1 if close
	neg	ax
	mul	ax			; square
	mov	bx,31
	div	bx			; 0-1000 squared scaled into 0-32258
	mov	palmul,ax
	or	tripflag,1		; trip it out, dude
	ret
dontspaceout:
	and	tripflag,NOT 1
	ret
.endp


.proc	tettim	auto
	jnc	notetdie
	call	enoughits		; are we killed?
	jnc	tetsaved
	push	si
	push	di
	mov	boomdeadly,20h		; make deadly
	call	strtboom		; do a boom
	pop	di
	pop	si
	push	si
	push	di			; reset registers
	mov	bx,3			; three pieces
	mov	omniflag,1		; all around explosion
	call	strtshard
	pop	di
	pop	si
	inc	ndest
	mov	word ptr [si+24],0	; kill object
tetsaved:
	mov	omniflag,1		; all around explosion
	mov	bx,2
	call	strtflt		; do a boom
	ret
notetdie:
	inc	word ptr [si+52]	; object lasts forever
	inc	curntets
	ret
.endp


.proc	hoparound	auto
	push	bx
	push	ax
	call	randr_w
	shr	bx,1
	sub	ax,bx
	pop	bx
	add	ax,bx
	pop	bx
	mov	bx,ax
	sar	bx,1
	sar	bx,1
	sar	bx,1
	neg	bx
	add	ax,bx
	ret
.endp


.proc	altim	auto		; alien
	jnc	noaldie
	cmp	word ptr [di+72],30	; were we hit by a bullet?
	jnz	alsaved		; no, then skip it
	call	enoughits
	jnc	alsaved
	xor	ax,ax
	mov	[si+8],ax
	mov	[si+10],ax
	mov	word ptr [si+14],16384	; lie him down
	and	word ptr [si+24],NOT 0ch	; make destructable
	mov	byte ptr [si+64],al	; turn off gravity
	mov	word ptr [si+50],100	; make them float up
	inc	ndest			; count them as a resource point
	ret
alsaved:
	ret
noaldie:
	mov	di,offset @dataseg:alqtbl	; point to dball qual table
	call	getqtblptr
	mov	ax,[di]			; get color from table
	mov	alclr,al
	inc	word ptr [si+52]	; mr alien never dies
	test	word ptr [si+24],4	; is object destructable?
	jnz	heisnotdead1
	xor	ax,ax
	cmp	byte ptr [si+18],al	; is he out of range?
	jz	notgoneyet
	mov	word ptr [si+24],ax	; cancel him
notgoneyet:
	ret
heisnotdead1:
	inc	curnals
	xor	ax,ax
	cmp	ejectflag,al		; if in plane, do not activate
	jz	donotactivate
	cmp	byte ptr [si+18],al
	jnz	donotactivate
	mov	word ptr [si+52],16000	; active the man!
	or	word ptr [si+24],8	; make man destructable
donotactivate:
	test	word ptr [si+52],16384	; check to see if man has been 
	jz	yesactiv		; activated
	ret
yesactiv:
	test	word ptr [si+24],8	; is object destructable?
	jnz	heisnotdead
	ret
heisnotdead:
	mov	ax,[si+8]
	mov	dx,[si+10]		; check for negative z coord
	or	dx,dx
	js	bounceup
	or	ax,dx
	jz	bounceup		; if height is neg or zero
	ret
bounceup:
	mov	di,qtblptr
	mov	ax,[di+4]		; get jump up velocity from table
	mov	word ptr [si+50],ax	; make man jump up
	xor	ax,ax
	mov	[si+8],ax
	mov	[si+10],ax
	mov	ax,[di+2]		; get gravity from table
	mov	byte ptr [si+64],al	; make sure gravity is on
	mov	ax,[si+46]		; make the guy hop around a little
	mov	bx,[di+6]		; get our randomness from table
	call	hoparound
	mov	[si+46],ax
	mov	ax,[si+48]		; make the guy hop around a little
	mov	bx,50
	call	hoparound
	mov	[si+48],ax
	mov	ax,[si+12]
	mov	bx,1000
	call	hoparound
	mov	[si+12],ax
	ret
.endp

.proc	qxpdamage	auto	; sees if plane deserves damage
	or	bx,bx
	jz	noxpdam
	js	xpkill
	test	bx,2		; is repair bit set?
	jz	norepair
	push	si
	push	ax
	call	cleardamage
	call	restoreview	; clear damage indicators
	pop	ax
	pop	si
	jmp	noxpdam
norepair:
	push	si
	push	ax
	mov	cx,75
	call	damageplane
	pop	ax
	pop	si
	jmp	noxpdam
xpkill:
	mov	crshflg,-1
noxpdam:
	ret
.endp


;		dw	10,3,100h,0		; doesn't move us, miss obj
.proc	xptim	auto		; code for portals
	jnc	noxpdie
	cmp	di,-1		; called because plane was hit?
	jnz	noplanenogain
	cmp	ejectflag,0
	jnz	noplanenogain
	push	si
	mov	di,offset @dataseg:xpqtbl	; point to dball qual table
	call	getqtblptr
	mov	ax,[di+4]
	mov	xpflag,al	; save flags for later call to arms
	test	ah,1		; check if user wants it to be a mission cmplt
	jz	notmisobj
	call	incondest	; inc say the mission is complete
notmisobj:
	mov	bx,[di+6]
	call	qxpdamage	; see if plane should be damaged	

	pop	si
noplanenogain:
	and	word ptr [si+52],16383	; cut out that top bit or so
	ret
noxpdie:
	
	mov	di,offset @dataseg:xpqtbl	; point to dball qual table
	call	getqtblptr
	mov	ax,[di]
	test	word ptr [si+24],200h		; is complete bit set?
	jz	notcompleted
	mov	al,15				; make damn thing white
notcompleted:
	mov	xpclr,al
	mov	dx,[di+2]
;	mov	ax,2500
;;	wtadj
;	mov	bx,ax
;	call	rand_w
;	cmp	ax,bx
	call	rand_w
	or	ax,ax
	js	leaveclr
	mov	xpclr,dl
leaveclr:
	mov	ax,[si+52]		; get time value
	test	ax,16384		; should we show noise?
	mov	word ptr [si+52],32000	; set timer back
	jnz	stilllit
	mov	xpclr,dl		; flash that sucker
stilllit:
	ret
.endp
.ends
	end

