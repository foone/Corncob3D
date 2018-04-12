

	title 'defobjs'
				; using 32 bits
; this file contains the default objects used by 3

cdct	equ	0


_MODEL	equ	<SMALL>
include model.inc
include	imath.INC
include 3dvid.inc
include	f3dequ.inc
include	3dmac.inc
include ka.inc

	public	gmdest	; entry point
	public	plnplyobj	; entry point
	public	plnplyobjsm	; entry point
	public	propobj
	public	sunobj
	public	hqobj
	public	twobj
	public	rdrobj
	public	twobj
	public	roadobj
	.public	objhq,objsun,obj5d,obj5da,objprop,objtw,objrdr
	.public	objdbst
	.public	objman,objman1
	.public	tower
	.public	roadpiece
	.public	manobj,dmanobj
	.public	objshard,shrdclr,objshard2,bodclr,whlclr
IF slalom
	.public wingclr
ENDIF
	.public	objincend,shrdclr
	.public crtr,crtrobj,objvech
	.public	objvest,objwallx,objwally,objwallz
	.public	dbstclr,clrtwr
.public	fltsm1,fltsm2,fltsm1boom,fltsm1dball
.public	fltsm1aa,fltsm1aashell,aaclr
.public	fltsm1mis,fltsm1puff,fltsm1bomb
.public	objflt1dball,lobjflt1dball,sobjflt1dball,clrhq,clrhqb,clrtwr,clrhqc
.public objflt1aa,objflt1aashell
.public	objflt1boom
.public	objflt2boom
.public	objflt3boom
.public	objflt1mis,objflt2mis,objflt1bomb
.public	odest
.public	flsmph1,flsmph
.public	clrf1,clrf2,clrd1,clrd2,clrd3,clrd4,dballclr
.public smsph,smsph1,sdsph,sdsph1
.public	bullets,objbsph,gms,bptrmx,gmobj1
.public	objtimtable,tmpltseg,templatetable,ntemplates,extendedtypetbl
.public	initperms
.public	nulobj
.public	funeral5d,evaldist
.public	bbclr,mortclr,dhqobj
.public	changewallobjs,framecount
IF mbflag EQ 1
.public	objcursor
ENDIF
.public	youarehere,yahclr
.public	objrv,clrshell,clrbmr,clrfs1,clrfs2,clrlsph,wallc,sunclr
.public clrfss1,clrfss2,lwallclr,alclr,paveobj,xpclr,crtrclr
.public vechantclr
.public	resetplanesflag,nplaced,palmul
.public	hashregcode,unhashregcode,randspin
.public	bombclr,survclr


.extrn	ofrmticks:word,ticksf:word
.extrn	ondest:word
.extrn	dxvec:word,rand_w:auto,randr_w:auto
.extrn	rel3d:auto,vmag:auto
.extrn	omniflag:byte,strtflt:auto,nfdest:word
.extrn	aafireprob:word
.extrn	shardtim:auto,strtshard:auto
.extrn	incendtim:auto,strtincend:auto,dbsttim:auto
.extrn	strtaa:auto,damageplane:auto
.extrn	vechtim:auto,strtvech:auto
.extrn	vesttim:auto,strtvest:auto,walltim:auto,lwalltim:auto
.extrn	pufftim:auto,boomtim:auto,bombtim:auto,mistim:auto,aashelltim:auto
.extrn	crtrtim:auto
.extrn	dballtim:auto,aatim:auto,flttim:auto
.extrn	ndest:word
.extrn	bdest:auto
.extrn	totaldamage:word
.extrn	strtboom:auto,freezeflag:byte,rpm:word
.extrn	oticks:word
.extrn	kbuf:word,strtperm:auto,grand:auto
.extrn	initialqual:word,naas:word,qualaa:word,ox:word,nvest:word
.extrn	maxnvechs:word,qualvest:word,ndbst:word,maxndballs:word
.extrn	strtdbst:auto,qualdbst:word,hmin:word
.extrn	nplaneslost:word,ndballsdest:word,naasdest:word
.extrn	nvechsdest:word,nsitesdest:word,nhqsdest:word
.extrn	missionstatus:word,homedetect:auto
.extrn	groundflag:byte,redamageflag:byte,intowerflag:byte
.extrn	actionflag:byte,ejectflag:byte,newguyflag:byte,exitflag:byte
.extrn	crshflg:byte

.extrn	getinplane:auto
.extrn	startcoords:word,lastplaneflown:byte
.extrn	expobj:word
.extrn	universex:word,universey:word
.extrn	curtower:word
.extrn	bbtim:auto,bbsmtim:auto
.extrn	mortim:auto,dhqtim:auto,hqtim:auto,curnticks:word
.extrn	scos:auto,ssin:auto
.extrn	obj5dbits:word,shelltim:auto,bmrtim:auto,bmrstim:auto
.extrn	tettim:auto,altim:auto,stettim:auto,tripflag:byte,clrup:byte
.extrn	clrdn:byte,ptrgwinf:word,tripamount:word,xptim:auto
.extrn	readfileflag:byte
.extrn	norbsdest:word,getqtblptr:auto,hqtbl:word
.extrn	haluclrs:word,haluclrate:word,distcolors:auto
.extrn	tempsum:word,nregcode:word,frmnum:word
.extrn	cecode:byte
.extrn	tempindex:word,clnregcodeh:word
.extrn	aaprog:word,dballprog:word,rollprog:word
.extrn	invincible:byte,readfileflag:byte
.extrn	orbfreq:word

.extrn	bigboom:auto
.extrn incondest:auto

;
lp	equ	180
lpo2	equ	lp*2/3
lo3	equ	lo2*3/2
lpo6	equ	lp/6
lp2	equ	lp*2
lp4	equ	lp*4
l4rear	equ	lp*2
ldip	equ	lp*2
l6	equ	lp*6
l8	equ	lp*8
l10	equ	lp*10
lcanp	equ	lpo2*4/3
lelv	equ	l10-lp-lo3/2
lwelv	equ	lp*3
ltail	equ	lelv-lpo2
lwtail	equ	lp*5/2
clr8	equ	0
clr6	equ	12
clr9	equ	14

.dataseg

objtimtable	dw	@codeseg:bigdest	;0
	dw	@codeseg:stettim	;1
	dw	@codeseg:obj5datim	;2
	dw	@codeseg:fdestrdr	;3
	dw	@codeseg:donothing	;4
	dw	@codeseg:roadtim	;5
	dw	@codeseg:towertim	;6
	dw	@codeseg:mandest	;7
	dw	@codeseg:shardtim	;8
	dw	@codeseg:shardtim	;9
	dw	@codeseg:incendtim	;10
	dw	@codeseg:dbsttim	;11
	dw	@codeseg:vechtim	;12
	dw	@codeseg:vesttim	;13
	dw	@codeseg:walltim	;14
	dw	@codeseg:walltim	;15
	dw	@codeseg:walltim	;16
	dw	@codeseg:walltim	;17
	dw	@codeseg:pufftim	;18
	dw	@codeseg:boomtim	;19
	dw	@codeseg:bombtim	;20
	dw	@codeseg:mistim		;21
	dw	@codeseg:aashelltim	;22
	dw	@codeseg:aatim		;23
;	dw	@codeseg:donothing
	dw	@codeseg:dballtim	;24
	dw	@codeseg:flttim		;25
	dw	@codeseg:flttim		;26
	dw	@codeseg:gmdest		;27
	dw	@codeseg:odest		;28
	dw	@codeseg:donothing	;29
	dw	@codeseg:bdest		;30
	dw	@codeseg:survtim	;31
	dw	@codeseg:crtrtim	;32
	dw	@codeseg:donothing	;33
	dw	@codeseg:huttim		;34
	dw	@codeseg:donothing	;35
	dw	@codeseg:donothing	;36
	dw	@codeseg:donothing	;37
	dw	@codeseg:donothing	;38
	dw	@codeseg:donothing	;39
	dw	@codeseg:bbtim		;40
	dw	@codeseg:bbsmtim	;41
	dw	@codeseg:mortim	;42
	dw	@codeseg:dhqtim		;43
	dw	@codeseg:lwalltim	;44
	dw	@codeseg:lwalltim	;45
	dw	@codeseg:lwalltim	;46
	dw	@codeseg:lwalltim	;47
	dw	@codeseg:vechtim	;48
IF slalom
	dw	@codeseg:donothing	;49
ELSE
	dw	@codeseg:shelltim	;49
ENDIF
	dw	@codeseg:bmrtim		;50
	dw	@codeseg:bmrstim	;51
	dw	@codeseg:tettim		;52
	dw	@codeseg:bmrtim		;53
	dw	@codeseg:lwalltim	;54
	dw	@codeseg:lwalltim	;55
	dw	@codeseg:lwalltim	;56
	dw	@codeseg:altim	;57
	dw	@codeseg:xptim	;58
	dw	@codeseg:lwalltim	;59
	dw	@codeseg:lwalltim	;60
	

templatetable	dw	@dataseg:objhq	;0
	dw	@dataseg:objstet	;1
	dw	@dataseg:obj5da		;2
	dw	@dataseg:objrdr		;3
	dw	@dataseg:objtw		;4
	dw	@dataseg:roadpiece	;5
	dw	@dataseg:tower		;6
	dw	@dataseg:objman	;7
	dw	@dataseg:objshard2	;8
	dw	@dataseg:objshard	;9
	dw	@dataseg:objincend	;10
	dw	@dataseg:objdbst	;11
	dw	@dataseg:objvech	;12
	dw	@dataseg:objvest	;13
	dw	@dataseg:objwallz1	;14
	dw	@dataseg:objwallx	;15
	dw	@dataseg:objwally	;16
	dw	@dataseg:objwallz	;17
	dw	@dataseg:fltsm1puff	;18
	dw	@dataseg:fltsm1boom	;19
	dw	@dataseg:fltsm1bomb	;20
	dw	@dataseg:fltsm1mis	;21
	dw	@dataseg:fltsm1aashell	;22
	dw	@dataseg:fltsm1aa	;23
	dw	@dataseg:fltsm1dball	;24
	dw	@dataseg:fltsm1		;25
	dw	@dataseg:fltsm2		;26
	dw	@dataseg:gms		;27
	dw	@dataseg:obj5d		;28
	dw	@dataseg:objprop	;29
	dw	@dataseg:bullets	;30
	dw	@dataseg:objsurv	;31
	dw	@dataseg:crtr		;32
	dw	@dataseg:smgms		;33
	dw	@dataseg:objhut		;34
	dw	@dataseg:objroadend	;35
	dw	@dataseg:objroadend1	;36
	dw	@dataseg:objfn1		;37
	dw	@dataseg:objfn1a	;38
	dw	@dataseg:objfn1b	;39
	dw	@dataseg:objbb		;40
	dw	@dataseg:objbbsm	;41
	dw	@dataseg:objmort	;42
	dw	@dataseg:objdhq		;43
	dw	@dataseg:objlwallz1	;44
	dw	@dataseg:objlwallx	;45
	dw	@dataseg:objlwally	;46
	dw	@dataseg:objlwallz	;47
	dw	@dataseg:objrv		;48
	dw	@dataseg:objshell	;49
	dw	@dataseg:objbmr		;50
	dw	@dataseg:objbmrst	;51
	dw	@dataseg:objtet		;52
	dw	@dataseg:objbmrmo	;53
	dw	@dataseg:objslwallx	;54
	dw	@dataseg:objslwally	;55
	dw	@dataseg:objslwallz	;56
	dw	@dataseg:objal		;57
	dw	@dataseg:objxp		;58
	dw	@dataseg:objstep	; 59
	dw	@dataseg:objpstep	; 60

	; bit 0 means do not xfer to medium table
	; bit 1 means skip over when doing misson builder creates
	; bit 2 means terminate object if plane hits it
	; bit 3 means it is forcefield type object
	; bit 4 means it is a runway type object
	; bit 5 means object is a portal
	; bit 6 means object is standonable
	; bit 7 means object kills you
	; bit 8 means object walk height is collision + z coord
	; bit 9 means object captures you

extendedtypetbl	dw	0+4	;0
	dw	0	;1
	dw	0+4		;2
	dw	0+4		;3
	dw	0+4		;4
	dw	0+4+16+64	;5
	dw	0+4+64+256		;6
	dw	0+4	;7
	dw	0+2	;8
	dw	0+2	;9
	dw	1+2+4	;10
	dw	0+4	;11
	dw	4+512	;12
	dw	0	;13
	dw	0+4+8+64	;14
	dw	0+4+8	;15
	dw	0+4+8	;16
	dw	0+4+8+64	;17
	dw	1+2	;18
	dw	1+2	;19
	dw	1+2	;20
	dw	1+2	;21
	dw	1+2+128	;22
	dw	0+4	;23
	dw	128	;24
	dw	1+2		;25
	dw	1+2		;26
	dw	0+4+64+256		;27
	dw	0+2		;28	skip over obj5d, so cursor don't dis
	dw	1	;29
	dw	1+2	;30
	dw	0	;31
	dw	0+128		;32
	dw	0		;33
	dw	0		;34
	dw	0+16+64		;35
	dw	0+16+64		;36
	dw	0+4		;37
	dw	0+4		;38
	dw	0+4		;39
	dw	0+128		;40
	dw	0+128		;41
	dw	0+4		;42
	dw	0		;43
	dw	0+4+8+64	;44
	dw	0+4+8	;45
	dw	0+4+8	;46
	dw	0+4+8+64	;47
	dw	1+4		;48
	dw	0		;49
	dw	4+64+256		;50
IF slalom
	dw	0		;51
ELSE
	dw	0+64+256		;51
ENDIF
	dw	0		;52
	dw	4+64+256		;53
	dw	0+4+8	;54
	dw	0+4+8	;55
	dw	0+4+8+64	;56
	dw	0+512		;57
	dw	0+4+20h		;58
	dw	0+4+8+64	;59
	dw	0+4+8+64	;60

ntemplates	dw	60		; for safety's sake, keep track of #

tmpltseg	dw	@dataseg


clrtwr	db	0

clrf1	db	0ch
clrf2	db	0eh	; red and yellow for flames

clrd1	db	1	; the blue/yellow flash colors
clrd2	db	14
clrd3	db	0	; the red, black flash colors
clrd4	db	4

dballclr	db	1	; color of a deathball
tripvalue	dw	0,0
nplaced		dw	0	; number of planes that were placed
resetplanesflag	db	-1
palmul	dw	0

xpszl	equ	2000
xpszh	equ	3*xpszl/4
xpszl2	equ	xpszl/2
xpszh2	equ	xpszh/2
xpszcr	equ	xpszh2/2

xpclr	dw	11

xply	dw	8
	dw	xpclr
	dw	0,xpszl2,-xpszh2
	dw	0,xpszl2+xpszcr,-xpszh2+xpszcr
	dw	0,xpszl2+xpszcr,xpszh2-xpszcr
	dw	0,xpszl2,xpszh2
	dw	0,-xpszl2,xpszh2
	dw	0,-xpszl2-xpszcr,xpszh2-xpszcr
	dw	0,-xpszl2-xpszcr,-xpszh2+xpszcr
	dw	0,-xpszl2,-xpszh2

xpobj	dw	0,0,0
	dw	1
	dw	8 dup (8,xply)


alclr	db	9

alsz	equ	200
alsz2	equ	alsz/2
alsz86	equ	alsz*13/15
alctr	equ	2*alsz
alszft	equ	alsz/6

alwr1	dw	1
	dw	alclr
	dw	0,alsz2,alctr-alsz86
	dw	0,alsz2*2,alctr-2*alsz86

alwr2	dw	1
	dw	alclr
	dw	0,-alsz2,alctr-alsz86
	dw	0,-alsz2*2,alctr-2*alsz86

alwr4	dw	1
	dw	alclr
	dw	0,-alsz2*2+alszft,alctr-2*alsz86
	dw	0,-alsz2*2,alctr-2*alsz86
	dw	0,-alsz2*2-alszft,alctr-2*alsz86+(alszft/2)



alwr3	dw	1
	dw	alclr
	dw	0,alsz2*2-alszft,alctr-2*alsz86
	dw	0,alsz2*2,alctr-2*alsz86
	dw	0,alsz2*2+alszft,alctr-2*alsz86+(alszft/2)

alwr5	dw	1
	dw	alclr
	dw	0,alsz2,alctr+alsz86
	dw	0,alsz2*2,alctr+2*alsz86

alwr6	dw	1
	dw	alclr
	dw	0,-alsz2,alctr+alsz86
	dw	0,-alsz2*2,alctr+2*alsz86

alfrm	dw	6
	dw	alwr1,alwr2,alwr3,alwr4,alwr5,alwr6

alsph	dw	3
	dw	0,0,alctr,alsz*2,alclr
	dw	0,alsz2*2,alctr+2*alsz86,alszft*2,alclr
	dw	0,-alsz2*2,alctr+2*alsz86,alszft*2,alclr

alobj	dw	0,0,0
	dw	2
	dw	8 dup (6,alsph,2,alfrm)


rvl	equ	1000		; rescue van base size
rvl2	equ	rvl/2
rvlext	equ	rvl/4
rvh	equ	rvl/2
rhh2	equ	rvh/2
rvhw	equ	rvh/2
rvw	equ	rvl/2
rvw2	equ	rvw/2
rvwl2	equ	rvw2*2/3

rvplys1	dw	4
	dw	12
	dw	-rvl2,-rvw2,0
	dw	-rvl2,-rvw2,rvh
	dw	rvl2,-rvw2,rvh
	dw	rvl2+rvlext,-rvw2,0

rvplys2	dw	4
	dw	12
	dw	-rvl2,rvw2,0
	dw	-rvl2,rvw2,rvh
	dw	rvl2,rvw2,rvh
	dw	rvl2+rvlext,rvw2,0

rvwplys1	dw	3
	dw	7
	dw	rvl2,-rvw2,rvhw
	dw	rvl2,-rvw2,rvh
	dw	rvl2+rvlext/2,-rvw2,rvhw

rvwplys2	dw	3
	dw	7
	dw	rvl2,rvw2,rvhw
	dw	rvl2,rvw2,rvh
	dw	rvl2+rvlext/2,rvw2,rvhw

rvplyfrnt	dw	4
	dw	12
	dw	rvl2+rvlext,rvw2,0
	dw	rvl2+rvlext,-rvw2,0
	dw	rvl2,-rvw2,rvh
	dw	rvl2,rvw2,rvh

rvplyback	dw	4
	dw	12
	dw	-rvl2,rvw2,0
	dw	-rvl2,-rvw2,0
	dw	-rvl2,-rvw2,rvh
	dw	-rvl2,rvw2,rvh

rvplytop	dw	4
	dw	0
	dw	-rvl2,-rvw2,rvh
	dw	rvl2,-rvw2,rvh
	dw	rvl2,rvw2,rvh
	dw	-rvl2,rvw2,rvh

rvplyws	dw	4
	dw	7
	dw	rvl2+rvlext/2,rvw2,rvhw
	dw	rvl2,rvw2,rvh
	dw	rvl2,-rvw2,rvh
	dw	rvl2+rvlext/2,-rvw2,rvhw

rvsph	dw	4
	dw	rvl2,rvwl2,0,rvl/8,0
	dw	rvl2,-rvwl2,0,rvl/8,0
	dw	-rvl2+rvl/10,rvwl2,0,rvl/8,0
	dw	-rvl2+rvl/10,-rvwl2,0,rvl/8,0

rvwr1	dw	1
	dw	15
	dw	rvl2,-rvw2,rvhw-rvhw/4
	dw	-rvl2+rvl2/4,-rvw2,rvhw-rvhw/4

rvwr2	dw	1
	dw	15
	dw	rvl2,rvw2,rvhw-rvhw/4
	dw	-rvl2+rvl2/4,rvw2,rvhw-rvhw/4

rvwr3	dw	1
	dw	0
	dw	-rvl2,0,0
	dw	-rvl2,0,rvh

rvfr1	dw	1,rvwr1
rvfr2	dw	1,rvwr2
rvfr3	dw	1,rvwr3

rvobj	dw	0,0,0
	dw	11
	dw	8,rvplyws
	dw	6,rvsph,8,rvplys2,8,rvplyws,8,rvplyfrnt,8,rvplyback
	dw	2,rvfr3,8,rvplys1,2,rvfr1
	dw	8,rvwplys1,0,0

	dw	8,rvplyws
	dw	6,rvsph,8,rvplys2,8,rvplyws,8,rvplyfrnt,8,rvplyback
	dw	2,rvfr3,8,rvplys1,2,rvfr1
	dw	8,rvwplys1,8,rvplytop

	dw	8,rvplyws
	dw	6,rvsph,8,rvplys1,8,rvplyws,8,rvplyfrnt,8,rvplyback
	dw	2,rvfr3,8,rvplys2,2,rvfr2
	dw	8,rvwplys2,0,0

	dw	8,rvplyws
	dw	6,rvsph,8,rvplys1,8,rvplyws,8,rvplyfrnt,8,rvplyback
	dw	2,rvfr3,8,rvplys2,2,rvfr2
	dw	8,rvwplys2,8,rvplytop

	dw	6,rvsph,8,rvplys2
	dw	2,rvfr3,8,rvplyback,8,rvplyws,8,rvplyfrnt,8,rvplys1
	dw	8,rvwplys1,0,0,8,rvplyws,2,rvfr1

	dw	6,rvsph,8,rvplys2
	dw	2,rvfr3,8,rvplyback,8,rvplyws,8,rvplyfrnt,8,rvplys1
	dw	8,rvwplys1,8,rvplytop,8,rvplyws,2,rvfr1

	dw	6,rvsph,8,rvplys1
	dw	2,rvfr3,8,rvplyback,8,rvplyws,8,rvplyfrnt,8,rvplys2
	dw	8,rvwplys2,0,0,8,rvplyws,2,rvfr2

	dw	6,rvsph,8,rvplys1
	dw	2,rvfr3,8,rvplyback,8,rvplyws,8,rvplyfrnt,8,rvplys2
	dw	8,rvwplys2,8,rvplytop,8,rvplyws,2,rvfr2

clrhq	db	0	; color of the hq sphere
clrhqb	db	0	; color of the hq base
clrhqc	db	0	; color of the hq base top

dhqwire1	dw	1
	dw	clrhq
	dw	xgmx2a,0,-xgmx2
	dw	xgmx2a,0,0
dhqwire2	dw	1
	dw	clrhq
	dw	-xgmx2a,0,-xgmx2
	dw	-xgmx2a,0,0
dhqwire3	dw	1
	dw	clrhq
	dw	xgmx2a/2,xgmx8,-xgmx2
	dw	xgmx2a/2,xgmx8,0
dhqwire4	dw	1
	dw	clrhq
	dw	-xgmx2a/2,xgmx8,-xgmx2
	dw	-xgmx2a/2,xgmx8,0
dhqwire5	dw	1
	dw	clrhq
	dw	-xgmx2a/2,-xgmx8,-xgmx2
	dw	-xgmx2a/2,-xgmx8,0
dhqwire6	dw	1
	dw	clrhq
	dw	xgmx2a/2,-xgmx8,-xgmx2
	dw	xgmx2a/2,-xgmx8,0

dhqfrm	dw	6
	dw	dhqwire1,dhqwire2,dhqwire3,dhqwire4,dhqwire5,dhqwire6

dhqobj	dw	0,0,0
	dw	2
	dw	8 dup (2,dhqfrm,6,sdsph)

IF normaltet
tetsz	equ	1000
tet2	equ	tetsz/2
tet86	equ	tetsz*13/15
tet43	equ	tet86/2
tetht	equ	tet86*2

tetclr	dw	0

tetwr1	dw	5
	dw	tetclr
	dw	-tet2,-tet86,tet43
	dw	-tet2,tet86,tet43
	dw	tetsz,0,tet43
	dw	-tet2,-tet86,tet43
	dw	0,0,-tet86
	dw	-tet2,tet86,tet43

tetwr2	dw	1
	dw	tetclr
	dw	0,0,-tet86
	dw	tetsz,0,tet43

tetfrm1	dw	2
	dw	tetwr1
	dw	tetwr2

tetobj	dw	0,0,0
	dw	1
	dw	8 dup (2,tetfrm1)
ELSE ; normaltet
tetsz	equ	1000
tet2	equ	tetsz/2
tet86	equ	tetsz*13/15
tet43	equ	tet86/2
tetht	equ	16384
tetht2	equ	tetht/2

tetclr	dw	0

tetwr1	dw	5
	dw	tetclr
	dw	-tet2,-tet86,tet43+tetht2
	dw	-tet2,tet86,tet43+tetht2
	dw	tetsz,0,tet43+tetht2
	dw	-tet2,-tet86,tet43+tetht2
	dw	0,0,-tet86+tetht2
	dw	-tet2,tet86,tet43+tetht2

tetwr2	dw	2
	dw	tetclr
	dw	tetsz,0,tet43+tetht2
	dw	0,0,-tet86+tetht2
	dw	0,0,-tetht+tetht2

tetfrm1	dw	2
	dw	tetwr1
	dw	tetwr2

tetobj	dw	0,0,0
	dw	1
	dw	8 dup (2,tetfrm1)

ENDIF ; NORMALtet


stetsz	equ	60
stet2	equ	tetsz/2
stet86	equ	tetsz*13/15
stet43	equ	tet86/2

stetclr	equ	<clrhq>

stetwr1	dw	5
	dw	stetclr
	dw	-stet2,-stet86,stet43
	dw	-stet2,stet86,stet43
	dw	stetsz,0,stet43
	dw	-stet2,-stet86,stet43
	dw	0,0,-stet86
	dw	-stet2,stet86,stet43

stetwr2	dw	1
	dw	stetclr
	dw	0,0,-stet86
	dw	stetsz,0,stet43

stetfrm1	dw	2
	dw	stetwr1
	dw	stetwr2

stetsph	dw	1
	dw	0,0,0,stet2,stetclr

stetobj	dw	0,0,0
	dw	2
	dw	8 dup (2,stetfrm1,6,stetsph)

gmwire1	dw	1
	dw	clr8
	dw	xgmx2a,0,-xgmx2
	dw	xgmx2a,0,0
gmwire2	dw	1
	dw	clr8
	dw	-xgmx2a,0,-xgmx2
	dw	-xgmx2a,0,0
gmwire3	dw	1
	dw	clr8
	dw	xgmx2a/2,xgmx8,-xgmx2
	dw	xgmx2a/2,xgmx8,0
gmwire4	dw	1
	dw	clr8
	dw	-xgmx2a/2,xgmx8,-xgmx2
	dw	-xgmx2a/2,xgmx8,0
gmwire5	dw	1
	dw	clr8
	dw	-xgmx2a/2,-xgmx8,-xgmx2
	dw	-xgmx2a/2,-xgmx8,0
gmwire6	dw	1
	dw	clr8
	dw	xgmx2a/2,-xgmx8,-xgmx2
	dw	xgmx2a/2,-xgmx8,0
gmfrm	dw	6
	dw	gmwire1,gmwire2,gmwire3,gmwire4,gmwire5,gmwire6
gmfrm26	dw	2
	dw	gmwire2,gmwire6
gmfrm35	dw	2
	dw	gmwire3,gmwire5
gmfrm23	dw	2
	dw	gmwire2,gmwire3
gmfrm14	dw	2
	dw	gmwire1,gmwire4



gmwre1	dw	1
	dw	clr8
	dw	xgmx2a,xgmx2,-xgmx2
	dw	xgmx2a,0,0
gmwre2	dw	1
	dw	clr8
	dw	-xgmx2a,xgmx2,-xgmx2
	dw	-xgmx2a,0,0
gmwre3	dw	1
	dw	clr8
	dw	0,xgmx8,-xgmx2
	dw	xgmx2a/2,xgmx8,0
gmwre4	dw	1
	dw	clr8
	dw	-xgmx2a/2,0,-xgmx2
	dw	-xgmx2a/2,xgmx8,0
gmwre5	dw	1
	dw	clr8
	dw	-xgmx2a/2,-xgmx8,-xgmx2
	dw	-xgmx2a/2,-xgmx8,0
gmwre6	dw	1
	dw	clr8
	dw	xgmx2a/2,xgmx8,-xgmx2
	dw	xgmx2a/2,-xgmx8,0

gmifrm	dw	6
	dw	gmwre1,gmwre2,gmwre3,gmwre4,gmwre5,gmwre6

gmsph	dw	1
;	dw	0,0,xgmx2,xgmx,clr8
	dw	0,0,0,xgmx,clr8

ssgmobj1	dw	0,0,0
	dw	1
	dw	8 dup(6,gmsph)

sgmobj1	dw	0,0,0
	dw	2

	dw	6,gmsph
	dw	2,gmfrm26

	dw	6,gmsph
	dw	2,gmfrm26

	dw	6,gmsph
	dw	2,gmfrm35

	dw	6,gmsph
	dw	2,gmfrm35

	dw	6,gmsph
	dw	2,gmfrm23

	dw	6,gmsph
	dw	2,gmfrm23

	dw	6,gmsph
	dw	2,gmfrm14

	dw	6,gmsph
	dw	2,gmfrm14

gmobj1	dw	0,0,0
	dw	2
	dw	2,gmfrm
	dw	6,gmsph
	dw	2,gmfrm
	dw	6,gmsph
	dw	2,gmfrm
	dw	6,gmsph
	dw	2,gmfrm
	dw	6,gmsph
	dw	2,gmfrm
	dw	6,gmsph
	dw	2,gmfrm
	dw	6,gmsph
	dw	2,gmfrm
	dw	6,gmsph
	dw	2,gmfrm
	dw	6,gmsph

gmobj2	dw	0,0,0
	dw	2
	dw	2,gmifrm
	dw	6,sdsph
	dw	2,gmifrm
	dw	6,sdsph
	dw	2,gmifrm
	dw	6,sdsph
	dw	2,gmifrm
	dw	6,sdsph
	dw	2,gmifrm
	dw	6,sdsph
	dw	2,gmifrm
	dw	6,sdsph
	dw	2,gmifrm
	dw	6,sdsph
	dw	2,gmifrm
	dw	6,sdsph

gmobj3	dw	0,0,0
	dw	1
	dw	6,sdsph
	dw	6,sdsph
	dw	6,sdsph
	dw	6,sdsph
	dw	6,sdsph
	dw	6,sdsph
	dw	6,sdsph
	dw	6,sdsph
	dw	2,gmifrm
	dw	2,gmifrm
	dw	2,gmifrm
	dw	2,gmifrm
	dw	2,gmifrm
	dw	2,gmifrm
	dw	2,gmifrm
	dw	2,gmifrm



nulcld	dw	0
nulsph	dw	0
nulfrm	dw	0

o	equ	4*l/2

smsph	dw	16
	dw	2*l+lw,-l,0
smsize	dw	2*l,clr9
	dw	2*l+lw-o,-l,0,2*l,clr6
	dw	2*l+lw-(2*o),-l,0,2*l,clr8
	dw	2*l+lw-(3*o),-l,0,2*l,clr8
	dw	2*l+lw-(4*o),-l,0,2*l,clr8
	dw	2*l+lw-(5*o),-l,0,2*l,clr8
	dw	2*l+lw-(6*o),-l,0,2*l,clr8
	dw	2*l+lw-(7*o),-l,0,2*l,clr8
	dw	2*l+lw-(8*o),-l,0,2*l,clr8
	dw	2*l+lw-(9*o),-l,0,2*l,clr8
	dw	2*l+lw-(10*o),-l,0,2*l,clr8
	dw	2*l+lw-(11*o),-l,0,2*l,clr8
	dw	2*l+lw-(12*o),-l,0,2*l,clr8
	dw	2*l+lw-(13*o),-l,0,2*l,clr8
	dw	2*l+lw-(14*o),-l,0,2*l,clr8
	dw	2*l+lw-(15*o),-l,0,2*l,clr8
smsph1	dw	16
	dw	2*l+lw-o,-l,0
	dw	l/2,clrf1
	dw	2*l+lw-o-(o/2),-l,0,l,clrf2
	dw	2*l+lw-(2*o),-l,0,2*l,clr8
	dw	2*l+lw-(3*o),-l,0,2*l,clr8
	dw	2*l+lw-(4*o),-l,0,2*l,clr8
	dw	2*l+lw-(5*o),-l,0,2*l,clr8
	dw	2*l+lw-(6*o),-l,0,2*l,clr8
	dw	2*l+lw-(7*o),-l,0,2*l,clr8
	dw	2*l+lw-(8*o),-l,0,2*l,clr8
	dw	2*l+lw-(9*o),-l,0,2*l,clr8
	dw	2*l+lw-(10*o),-l,0,2*l,clr8
	dw	2*l+lw-(11*o),-l,0,2*l,clr8
	dw	2*l+lw-(12*o),-l,0,2*l,clr8
	dw	2*l+lw-(13*o),-l,0,2*l,clr8
	dw	2*l+lw-(14*o),-l,0,2*l,clr8
	dw	2*l+lw-(15*o),-l,0,2*l,clr8


sdsph	dw	16
	dw	0,0,0
sdsize	dw	2*l,clr9
	dw	0,0,p,2*pl,clr6
	dw	0,0,(2*p),2*pl,clr8
	dw	0,0,(3*p),2*pl,clr8
	dw	0,0,(4*p),2*pl,clr8
	dw	0,0,(5*p),2*pl,clr8
	dw	0,0,(6*p),2*pl,clr8
	dw	0,0,(7*p),2*pl,clr8
	dw	0,0,(8*p),2*pl,clr8
	dw	0,0,(9*p),2*pl,clr8
	dw	0,0,(10*p),2*pl,clr8
	dw	0,0,(11*p),2*pl,clr8
	dw	0,0,(12*p),2*pl,clr8
	dw	0,0,(13*p),2*pl,clr8
	dw	0,0,(14*p),2*pl,clr8
	dw	0,0,(15*p),2*pl,clr8
sdsph1	dw	16
	dw	0,0,0
	dw	2*pl,clr9
	dw	0,0,p,2*pl,clr6
	dw	0,0,(2*p),2*pl,clr8
	dw	0,0,(3*p),2*pl,clr8
	dw	0,0,(4*p),2*pl,clr8
	dw	0,0,(5*p),2*pl,clr8
	dw	0,0,(6*p),2*pl,clr8
	dw	0,0,(7*p),2*pl,clr8
	dw	0,0,(8*p),2*pl,clr8
	dw	0,0,(9*p),2*pl,clr8
	dw	0,0,(10*p),2*pl,clr8
	dw	0,0,(11*p),2*pl,clr8
	dw	0,0,(12*p),2*pl,clr8
	dw	0,0,(13*p),2*pl,clr8
	dw	0,0,(14*p),2*pl,clr8
	dw	0,0,(15*p),2*pl,clr8

bsph	dw	1
	dw	0,0,0,2*l,clr6

objbsph	dw	0,0,0
	dw	1
	dw	8 dup(6,bsph)
bulpt	dw	1
	dw	0,0,0,clr6

blkpt	dw	1
	dw	0,0,0,0

objblkpt	dw	0,0,0
	dw	1
	dw	8 dup (4,blkpt)

flshpt	dw	1
	dw	0,0,0,clrhq

objflshpt	dw	0,0,0
	dw	1
	dw	8 dup (4,flshpt)

aapt	dw	1
	dw	0,0,0,15

objaapt	dw	0,0,0
	dw	1
	dw	8 dup(4,aapt)

objbpt	dw	0,0,0
	dw	1
	dw	8 dup(4,bulpt)

bombsz	equ	dbsz/6
bombclr	db	7		; bombs are grey
sphbomb	dw	1
	dw	0,0,0,2*bombsz,bombclr

wirebomb	dw	3
	dw	bombclr
	dw	0,bombsz,bombsz
	dw	-bombsz,2*bombsz,bombsz
	dw	-3*bombsz,3*bombsz,3*bombsz/2
	dw	-bombsz,bombsz/2,bombsz/4

wirebomb2	dw	3
	dw	bombclr
	dw	0,-bombsz,bombsz
	dw	-bombsz,-2*bombsz,bombsz
	dw	-3*bombsz,-3*bombsz,3*bombsz/2
	dw	-bombsz,-bombsz/2,bombsz/4

wirebomb3	dw	3
	dw	bombclr
	dw	0,0,-bombsz
	dw	-bombsz,0,-2*bombsz
	dw	-3*bombsz,0,-3*bombsz
	dw	-bombsz,0,-bombsz/2


frmbomb1	dw	3
	dw	wirebomb
	dw	wirebomb2
	dw	wirebomb3

objflt1bomb	dw	0,0,0
	dw	2
	dw	8 dup(6,sphbomb,2,frmbomb1)


sphdball	dw	1
	dw	0,0,0,2*dbsz,dballclr

wiredball1	dw	3
	dw	dballclr
	dw	0,dbsz13,dbsz2
	dw	-dbsz,2*dbsz13,dbsz
	dw	-3*dbsz,3*dbsz13,3*dbsz/2
	dw	-dbsz13,dbsz13/2,dbsz/4

wiredball2	dw	3
	dw	dballclr
	dw	0,-dbsz13,dbsz2
	dw	-dbsz,-2*dbsz13,dbsz
	dw	-3*dbsz,-3*dbsz13,3*dbsz/2
	dw	-dbsz13,-dbsz13/2,dbsz/4

wiredball3	dw	3
	dw	dballclr
	dw	0,0,-dbsz
	dw	-dbsz,0,-2*dbsz
	dw	-3*dbsz,0,-3*dbsz
	dw	-dbsz13,0,-dbsz/2


frmdball1	dw	3
	dw	wiredball1
	dw	wiredball2
	dw	wiredball3

objflt1dball	dw	0,0,0
	dw	2
	dw	4 dup(2,frmdball1,6,sphdball)
	dw	4 dup(6,sphdball,2,frmdball1)

sobjflt1dball	dw	0,0,0
	dw	2
	dw	8 dup(6,sphdball,2,sfrmdball1)

swiredball	dw	1
	dw	dballclr
	dw	0,dbsz13,dbsz2
	dw	-dbsz,2*dbsz13,dbsz

swiredball2	dw	1
	dw	dballclr
	dw	0,-dbsz13,dbsz2
	dw	-dbsz,-2*dbsz13,dbsz

swiredball3	dw	1
	dw	dballclr
	dw	0,0,-dbsz
	dw	-dbsz,0,-2*dbsz

sfrmdball1	dw	3
	dw	swiredball
	dw	swiredball2
	dw	swiredball3



sphaashell	dw	1
	dw	0,0,0,3*dbsz/4,clrd3

objflt1aashell	dw	0,0,0
	dw	1
	dw	8 dup (6,sphaashell)

aaclr	dw	7

aasz	equ	1200

sphaa1	dw	1
	dw	0,0,0,3*aasz,15
sphaa2	dw	4
	dw	aasz,0,0,aasz,aaclr
	dw	2*aasz,0,0,aasz,aaclr
	dw	3*aasz,0,0,aasz,aaclr
	dw	4*aasz,0,0,aasz,aaclr
sphaa3	dw	1
	dw	5*aasz-(aasz/2),0,0,aasz/2,1

objflt1aa	dw	0,0,0
	dw	3
	dw	4 dup (6,sphaa3,6,sphaa2,6,sphaa1)
	dw	4 dup (6,sphaa1,6,sphaa2,6,sphaa3)



lsphdball	dw 1
	dw	0,0,0,2*dbsz,clrd1

lwiredball	dw	3
	dw	clrd1
	dw	0,dbsz13,dbsz2
	dw	-dbsz,2*dbsz13,dbsz
	dw	-3*dbsz,3*dbsz13,3*dbsz/2
	dw	-dbsz13,dbsz13/2,dbsz/4

lwiredball2	dw	3
	dw	clrd1
	dw	0,-dbsz13,dbsz2
	dw	-dbsz,-2*dbsz13,dbsz
	dw	-3*dbsz,-3*dbsz13,3*dbsz/2
	dw	-dbsz13,-dbsz13/2,dbsz/4

lwiredball3	dw	3
	dw	clrd1
	dw	0,0,-dbsz
	dw	-dbsz,0,-2*dbsz
	dw	-3*dbsz,0,-3*dbsz
	dw	-dbsz13,0,-dbsz/2


lfrmdball1	dw	3
	dw	lwiredball
	dw	lwiredball2
	dw	lwiredball3

lobjflt1dball	dw	0,0,0
	dw	2
	dw	8 dup(6,lsphdball,2,lfrmdball1)

fltsmw1	dw	3
	dw	clrf1	;black
	dw	700,0,0
	dw	-700,0,305
	dw	0,350,-305
	dw	0,0,0



fltsfr1	dw	1
	dw	fltsmw1
objflt1	dw	0,0,0
	dw	2
	dw	8 dup(2,fltsfr1,6,flsmph)

objflt1puff	dw	0,0,0
	dw	1
	dw	8 dup(6,flsmphpuff)

objflt1boom	dw	0,0,0
	dw	1
	dw	8 dup(6,flsmphboom)
objflt2boom	dw	0,0,0
	dw	1
	dw	8 dup(6,boomsph2)
objflt3boom	dw	0,0,0
	dw	1
	dw	8 dup(6,boomsph3)

objflt1mis	dw	0,0,0
	dw	2
	dw	8 dup(6,sphmis1,2,frmmis)

objflt2mis	dw	0,0,0
	dw	1
	dw	8 dup(6,sphmis1)

flsmphpuff	dw	1
	dw	0,0,0,750
puffclr	dw	7

flsmphboom	dw	1
	dw	0,0,0,6000
boomclr	dw	12

boomsph2	dw	1
	dw	0,0,0,4000
	dw	14

boomsph3	dw	1
	dw	0,0,0,2500
	dw	15

flsmph	dw	3
	dw	-1000,0,750,1000
fltclr	dw	0
	dw	-1500,500,0,750,0
	dw	-2000,-500,0,250,0

flsmph1	dw	3
	dw	-1000,0,750,1000,0
	dw	-1500,500,0,750,0
	dw	-2000,-500,0,250,0

fltsph1	dw	3
	dw	100,0,0,1000,clrf2
	dw	0,50,0,750,clrf1
	dw	-100,-50,0,250,clrf2

objflt2	dw	0,0,0
	dw	1
	dw	8 dup(6,fltsph1)


frmmis		dw	4
		dw	wiremis1
		dw	wiremis2
		dw	wiremis3
		dw	wiremis4

lm	equ	26
lm3	equ	lm*3
lm2	equ	lm/2
lm86	equ	lm*13/15
lml	equ	lm*10


wiremis1	dw	4
		dw	15
		dw	-lml,lm,0
		dw	lml,lm,0
		dw	lml+lm3,0,0
		dw	lml,-lm,0
		dw	-lml,-lm,0
wiremis2	dw	4
		dw	15
		dw	-lml,lm2,lm86
		dw	lml,lm2,lm86
		dw	lml+lm3,0,0
		dw	lml,-lm2,-lm86
		dw	-lml,-lm2,-lm86

wiremis3	dw	4
		dw	15
		dw	-lml,-lm2,lm86
		dw	lml,-lm2,lm86
		dw	lml+lm3,0,0
		dw	lml,lm2,-lm86
		dw	-lml,lm2,-lm86

wiremis4	dw	6
		dw	clrf1
		dw	-lml,lm,0
		dw	-lml,lm2,lm86
		dw	-lml,-lm2,lm86
		dw	-lml,-lm,0
		dw	-lml,-lm2,-lm86
		dw	-lml,lm2,-lm86
		dw	-lml,lm,0

sphmis1		dw	1
		dw	-lml,0,0,lm86,clrf2


ouraax	dw	-1

wrksz	equ	500
wrkl	equ	5000
wrkz	equ	-xgmx2

wrkply1	dw	3
	dw	0
	dw	wrkl/2,0,wrkz
	dw	wrkl,wrkl/2,wrkz
	dw	wrkl-wrksz,wrkl/2+wrksz,wrkz

wrkply2	dw	4
	dw	0
	dw	0,0,wrkz
	dw	0,wrksz,wrkz
	dw	-wrkl/2,-wrkl/2,wrkz
	dw	-wrkl/2-wrksz,-wrkl/2-wrksz,wrkz

wrkply3	dw	4
	dw	0
	dw	-wrkl/3,wrkl/4,wrkz
	dw	-wrkl/3,wrkl/4+wrksz,wrkz
	dw	-wrkl/3+wrksz,wrkl/4+wrksz,wrkz
	dw	-wrkl/3+wrksz,wrkl/4,wrkz

wrkply4	dw	4
	dw	0
	dw	-wrkl/3+wrksz,wrkl/4+wrksz,wrkz
	dw	-wrkl/3+wrksz,wrkl/4,wrkz
	dw	-wrkl/3+2*wrksz,wrkl/4,wrkz
	dw	-wrkl/3+2*wrksz,wrkl/4+wrksz,wrkz

wrkwr1	dw	6
	dw	0
	dw	wrkl/4,wrkl/4,wrkz
	dw	wrkl/3,wrkl/6,wrkz
	dw	-wrkl/4+wrksz,wrkl/5,wrkz
	dw	wrkl/4+wrksz,wrkl/5,wrkz/2
	dw	-wrkl/4,-wrkl/4,0
	dw	wrkl/3+wrksz,wrkl/4,wrkz
	dw	wrkl/4+wrksz,wrkl/5,wrkz*3/4

wrkwr2	dw	2
	dw	0
	dw	wrkl/4,-wrkl/4,0
	dw	-wrkl/3+wrksz,wrkl/4,wrkz
	dw	wrkl/4+wrksz,-wrkl/5,wrkz*3/4

wrkwr3	dw	6
	dw	0
	dw	-wrkl/4,wrkl/4,wrkz
	dw	-wrkl/3,-wrkl/6,wrkz
	dw	wrkl/4+wrksz,wrkl/5,0
	dw	-wrkl/4+wrksz,wrkl/5,wrkz/2
	dw	wrkl/4,-wrkl/4,0
	dw	-wrkl/3-wrksz,wrkl/4,wrkz/2
	dw	-wrkl/4+wrksz,wrkl/5,0

wrkfrm1	dw	2
	dw	wrkwr1
	dw	wrkwr2
;	dw	wrkwr3

wrkobj	dw	0,0,0	
	dw	6
	rept	8
	dw	8,wrkply1,8,wrkply2,8,wrkply3,8,wrkply4
	dw	2,wrkfrm1,6,sdsph
	endm

swrkobj	dw	0,0,0
	dw	2
	dw	8 dup (2,wrkfrm1,6,sdsph)


twire0	dw	1
	dw	0
	dw	-twsz,-twsz,-twszl
	dw	-twsz,-twsz,twszl

twfrm0	dw	1
	dw	twire0

twire1	dw	1
	dw	0
	dw	-twsz,twsz,-twszl
	dw	-twsz,twsz,twszl

twfrm1	dw	1
	dw	twire1

twire2	dw	1
	dw	0
	dw	twsz,twsz,-twszl
	dw	twsz,twsz,twszl

twfrm2	dw	1
	dw	twire2

twire3	dw	1
	dw	0
	dw	twsz,-twsz,-twszl
	dw	twsz,-twsz,twszl

twfrm3	dw	1
	dw	twire3


twrpl1	dw	4
	dw	7
	dw	twsz,-twsz,-twszl
	dw	twsz,-twsz,twszl
	dw	twsz,twsz,twszl
	dw	twsz,twsz,-twszl

twrpl2	dw	4
	dw	7
	dw	twsz,twsz,-twszl
	dw	twsz,twsz,twszl
	dw	-twsz,twsz,twszl
	dw	-twsz,twsz,-twszl

twrpl3	dw	4
	dw	7
	dw	twsz,-twsz,-twszl
	dw	twsz,-twsz,twszl
	dw	-twsz,-twsz,twszl
	dw	-twsz,-twsz,-twszl

twrpl4	dw	4
	dw	7
	dw	-twsz,-twsz,-twszl
	dw	-twsz,-twsz,twszl
	dw	-twsz,twsz,twszl
	dw	-twsz,twsz,-twszl

twrpl5	dw	4
	dw	15
	dw	-twsz,-twsz,twszl
	dw	-twsz,twsz,twszl
	dw	twsz,twsz,twszl
	dw	twsz,-twsz,twszl

ctwrobj	dw	0,0,0
	dw	6

	dw	8,twrpl5	; draw nice top
	dw	8,twrpl1	; draw front
	dw	8,twrpl2	; show left side
	dw	8,twrpl3	; show right side
	dw	8,twrpl4	; draw rear portion
	dw	2,twfrm0	; rear right side

	dw	8,twrpl5	; draw nice top
	dw	8,twrpl1	; draw front
	dw	8,twrpl2	; show left side
	dw	8,twrpl3	; show right side
	dw	8,twrpl4	; draw rear portion
	dw	2,twfrm0	; rear right side

	dw	8,twrpl5	; draw nice top
	dw	8,twrpl1	; draw front
	dw	8,twrpl3	; show right side
	dw	8,twrpl2	; show left side
	dw	8,twrpl4	; draw rear portion
	dw	2,twfrm1	; rear left side

	dw	8,twrpl5	; draw nice top
	dw	8,twrpl1	; draw front
	dw	8,twrpl3	; show right side
	dw	8,twrpl2	; show left side
	dw	8,twrpl4	; draw rear portion
	dw	2,twfrm1	; rear left side

	dw	8,twrpl5	; draw nice top
	dw	8,twrpl4	; draw rear portion
	dw	8,twrpl2	; show left side
	dw	8,twrpl3	; show right side
	dw	8,twrpl1	; draw front
	dw	2,twfrm3	; front right corner

	dw	8,twrpl5	; draw nice top
	dw	8,twrpl4	; draw rear portion
	dw	8,twrpl2	; show left side
	dw	8,twrpl3	; show right side
	dw	8,twrpl1	; draw front
	dw	2,twfrm3	; front right corner

	dw	8,twrpl5	; draw nice top
	dw	8,twrpl4	; draw rear portion
	dw	8,twrpl3	; show right side
	dw	8,twrpl2	; show left side
	dw	8,twrpl1	; draw front
	dw	2,twfrm2	; front left corner

	dw	8,twrpl5	; draw nice top
	dw	8,twrpl4	; draw rear portion
	dw	8,twrpl3	; show right side
	dw	8,twrpl2	; show left side
	dw	8,twrpl1	; draw front
	dw	2,twfrm2	; front left corner

twrobj	dw	0,0,0
	dw	4

	dw	0,0		; don't bother with top if too low
	dw	8,twrpl3	; show right side
	dw	8,twrpl4	; draw rear portion
	dw	2,twfrm0	; rear right side

	dw	8,twrpl5	; draw nice top
	dw	8,twrpl3	; show right side
	dw	8,twrpl4	; draw rear portion
	dw	2,twfrm0	; rear right side

	dw	0,0		; don't bother with top if too low
	dw	8,twrpl2	; show left side
	dw	8,twrpl4	; draw rear portion
	dw	2,twfrm1	; rear left side

	dw	8,twrpl5	; draw nice top
	dw	8,twrpl2	; show left side
	dw	8,twrpl4	; draw rear portion
	dw	2,twfrm1	; rear left side

	dw	0,0		; don't bother with top if too low
	dw	8,twrpl3	; show right side
	dw	8,twrpl1	; draw front
	dw	2,twfrm3	; front right corner

	dw	8,twrpl5	; draw nice top
	dw	8,twrpl3	; show right side
	dw	8,twrpl1	; draw front
	dw	2,twfrm3	; front right corner

	dw	0,0		; don't bother with top if too low
	dw	8,twrpl2	; show left side
	dw	8,twrpl1	; draw front
	dw	2,twfrm2	; front left corner

	dw	8,twrpl5	; draw nice top
	dw	8,twrpl2	; show left side
	dw	8,twrpl1	; draw front
	dw	2,twfrm2	; front left corner

twrwr1	dw	3
	dw	0
	dw	0,0,0
	dw	-1000,-1000,8000
	dw	1000,-1000,8000
	dw	0,0,0
twrwr2	dw	2
	dw	0
	dw	-1000,-1000,8000
	dw	0,1000,8000
	dw	1000,-1000,8000
twrwr3	dw	1
	dw	0
	dw	0,0,0
	dw	0,1000,8000

twrfrm	dw	3
	dw	twrwr1
	dw	twrwr2
	dw	twrwr3

twrobj2	dw	0,0,0
	dw	1
	dw	8 dup (2,twrfrm)

stwrobj	dw	0,0,0
	dw	1
	dw	8 dup (2,twfrm1)

twsz8	equ	twsz/5

hutpl1	dw	4
	dw	0
	dw	twsz8,0,0
	dw	twsz8,0,twsz8*3
	dw	-twsz8,0,twsz8*3
	dw	-twsz8,0,0

hutobj	dw	0,0,0
	dw	1
	dw	8 dup(8,hutpl1)

objsun	dw	4000,0		; 32 bit xyz coordinates
	dw	0,0
	dw	18928,2
	dw	0		; yaw, pitch, and roll
	dw	0
	dw	0

	dw	0		; distance default, 0=near

	dw	9612,244	; 32-bit distance squared

	dw	1		; object type 0= no-draw bit 4=destructable
	dw	2		; rotflg, 0= no rotation
	dd	977625289	; breakpoint for near dist squared
	dd	1067541266	; bkpt for med near dist sqrd
	dd	1067541266	; bkpt for med far dist sqrd
	dw	sunobj		; address of near object
	dw	sunobj		; address of med object
	dw	sunobj		; address of med object
	dw	0,0,0		; xyz velocity of object
	dw	1		; done flag 0= no move
	dw	0,0,0		; yaw, pitch and roll angular velocities
	dw	0,0		; dispersion, and wind resistance damping
	dw	0		; gravity
	dw	0,0,0		; rectangle of collision
	dw	@codeseg:donothing	; routine of destruction

wingclr	db	1

plnwr1	dw	8
	dw	0
	dw	lp4,-lpo6,-lpo2
	dw	lp4,lpo6,-lpo2
	dw	lp4,lpo2,-lpo6
	dw	lp4,lpo2,lpo6
	dw	lp4,lpo6,lpo2
	dw	lp4,-lpo6,lpo2
	dw	lp4,-lpo2,lpo6
	dw	lp4,-lpo2,-lpo6
	dw	lp4,-lpo6,-lpo2

plnfr1	dw	1
	dw	plnwr1


plnply1	dw	8
	dw	7
	dw	lp4,-lpo6,-lpo2
	dw	lp4,lpo6,-lpo2
	dw	lp4,lpo2,-lpo6
	dw	lp4,lpo2,lpo6
	dw	lp4,lpo6,lpo2
	dw	lp4,-lpo6,lpo2
	dw	lp4,-lpo2,lpo6
	dw	lp4,-lpo2,-lpo6

plnply2	dw	4
	dw	7
	dw	-l4rear,lpo2,lpo6
	dw	lp4,lpo2,lpo6
	dw	l4,lpo2,-lpo6
	dw	-l4rear,lpo2,-lpo6

plnply2top	dw	4
	dw	7
	dw	-l4rear,lpo2,lpo6
	dw	lp4,lpo2,lpo6
	dw	lp4,lpo6,lpo2
	dw	-l4rear,lpo6,lpo2

plnply2bot	dw	4
	dw	7
	dw	-l4rear,lpo2,-lpo6
	dw	lp4,lpo2,-lpo6
	dw	lp4,lpo6,-lpo2
	dw	-l4rear,lpo6,-lpo2

plnply2tri	dw	3
	dw	7
	dw	-l4rear,lpo2,lpo6
	dw	-l4rear,lpo2,-lpo6
	dw	-l10,0,0

plnply2toptri	dw	3
	dw	7
	dw	-l4rear,lpo2,lpo6
	dw	-l4rear,lpo6,lcanp
	dw	-l10,0,0

	
plnply2bottri	dw	3
	dw	7
	dw	-l4rear,lpo2,-lpo6
	dw	-l4rear,lpo6,-lpo2
	dw	-l10,0,0


plnply3	dw	4
	dw	7
	dw	-l4rear,-lpo2,lpo6
	dw	lp4,-lpo2,lpo6
	dw	lp4,-lpo2,-lpo6
	dw	-l4rear,-lpo2,-lpo6

plnply3top	dw	4
	dw	7
	dw	-l4rear,-lpo2,lpo6
	dw	lp4,-lpo2,lpo6
	dw	lp4,-lpo6,lpo2
	dw	-l4rear,-lpo6,lpo2

plnply3bot	dw	4
	dw	7
	dw	-l4rear,-lpo2,-lpo6
	dw	lp4,-lpo2,-lpo6
	dw	lp4,-lpo6,-lpo2
	dw	-l4rear,-lpo6,-lpo2

plnply3tri	dw	3
	dw	7
	dw	-l4rear,-lpo2,lpo6
	dw	-l4rear,-lpo2,-lpo6
	dw	-l10,0,0

plnply3toptri	dw	3
	dw	7
	dw	-l4rear,-lpo2,lpo6
	dw	-l4rear,-lpo6,lcanp
	dw	-l10,0,0

	
plnply3bottri	dw	3
	dw	7
	dw	-l4rear,-lpo2,-lpo6
	dw	-l4rear,-lpo6,-lpo2
	dw	-l10,0,0

plnply4	dw	4
	dw	7
	dw	-l4rear,-lpo6,lpo2
	dw	lp4,-lpo6,lpo2
	dw	lp4,lpo6,lpo2
	dw	-l4rear,lpo6,lpo2

plnply4tri	dw	3
	dw	7
	dw	-l4rear,-lpo6,lcanp
	dw	-l4rear,lpo6,lcanp
	dw	-l10,0,0

plnply5	dw	4
	dw	7
	dw	-l4rear,-lpo6,-lpo2
	dw	lp4,-lpo6,-lpo2
	dw	lp4,lpo6,-lpo2
	dw	-l4rear,lpo6,-lpo2

plnply5tri	dw	3
	dw	7
	dw	-l4rear,-lpo6,-lpo2
	dw	-l4rear,lpo6,-lpo2
	dw	-l10,0,0

plnplyw2	dw	4
	dw	wingclr
	dw	lp2,lpo2,0
	dw	-lp2,lpo2,0
	dw	-lp,ldip,-lpo2
	dw	lp2,ldip,-lpo2

plnplyw3	dw	4
	dw	wingclr
	dw	lp2,-lpo2,0
	dw	-lp2,-lpo2,0
	dw	-lp,-ldip,-lpo2
	dw	lp2,-ldip,-lpo2

plnplyw2tip	dw	4
	dw	wingclr
	dw	lp2,ldip,-lpo2
	dw	-lp,ldip,-lpo2
	dw	-lp+lpo2,l8,0
	dw	lp2,l8,0

plnplyw3tip	dw	4
	dw	wingclr
	dw	lp2,-ldip,-lpo2
	dw	-lp,-ldip,-lpo2
	dw	-lp+lpo2,-l8,0
	dw	lp2,-l8,0

plnplyelv2	dw	4
	dw	wingclr
	dw	-lelv,0,0
	dw	-lelv-lpo2,lwelv,0
	dw	-l10+lo3/2,lwelv,0
	dw	-l10+lo3/4,0,0

plnplyelv3	dw	4
	dw	wingclr
	dw	-lelv,0,0
	dw	-lelv-lpo2,-lwelv,0
	dw	-l10+lo3/2,-lwelv,0
	dw	-l10+lo3/4,0,0

plnplytail	dw	6
	dw	7
	dw	-ltail,0,0
	dw	-ltail-lpo2/2,0,lwtail*5/6
	dw	-ltail-lpo2,0,lwtail
	dw	-l10+3*lpo2/2,0,lwtail
	dw	-l10+lpo2,0,lwtail*4/5
	dw	-l10+lpo2,0,0

plnplyobjsm	dw	0,0,0
	dw	24

	dw	6,sdsph
	dw	8,plnplyw2,8,plnplyw2tip,8,plnplyelv2
	dw	8,plnply2top,8,plnply2bot
	dw	8,plnply2tri,8,plnply2toptri,8,plnply2bottri
	dw	8,plnply3tri,8,plnply3toptri,8,plnply3bottri
	dw	0,0,0,0,8,plnply5,8,plnply3top,8,plnply3bot,8,plnply3
	dw	8,plnply4tri,8,plnply5tri
	dw	8,plnplyw3,8,plnplyw3tip,8,plnplytail,8,plnplyelv3

	dw	8,plnplyw2,8,plnplyw2tip,8,plnplyelv2
	dw	8,plnply2tri,8,plnply2toptri,8,plnply2bottri
	dw	8,plnply3tri,8,plnply3toptri,8,plnply3bottri
	dw	8,plnply2top,8,plnply2bot
	dw	0,0,0,0,8,plnply4,8,plnply3bot,8,plnply3top,8,plnply3
	dw	8,plnply4tri,8,plnply5tri
	dw	8,plnplyw3,8,plnplyw3tip,8,plnplytail,8,plnplyelv3
	dw	6,sdsph


	dw	6,sdsph
	dw	8,plnplyw3,8,plnplyw3tip,8,plnplyelv3
	dw	8,plnply3tri,8,plnply3toptri,8,plnply3bottri
	dw	8,plnply2tri,8,plnply2toptri,8,plnply2bottri
	dw	8,plnply3top,8,plnply3bot
	dw	0,0,0,0,8,plnply5,8,plnply2top,8,plnply2bot,8,plnply2
	dw	8,plnply4tri,8,plnply5tri
	dw	8,plnplyw2,8,plnplyw2tip,8,plnplytail,8,plnplyelv2


	dw	8,plnplyw3,8,plnplyw3tip,8,plnplyelv3
	dw	8,plnply3tri,8,plnply3toptri,8,plnply3bottri
	dw	8,plnply2tri,8,plnply2toptri,8,plnply2bottri
	dw	8,plnply3top,8,plnply3bot
	dw	0,0,0,0,8,plnply4,8,plnply2bot,8,plnply2top,8,plnply2
	dw	8,plnply4tri,8,plnply5tri
	dw	8,plnplyw2,8,plnplyw2tip,8,plnplytail,8,plnplyelv2
	dw	6,sdsph


	dw	6,sdsph
	dw	8,plnplyw2,8,plnplyw2tip,8,plnplyelv2
	dw	8,plnply2top,8,plnply2bot
	dw	8,plnply1,8,plnply5,8,plnply3top,2,plnfr1,8,plnply3bot,8,plnply3
	dw	8,plnply2tri,8,plnply2toptri,8,plnply2bottri
	dw	8,plnply3tri,8,plnply3toptri,8,plnply3bottri
	dw	8,plnply4tri,8,plnply5tri,8,plnplytail
	dw	8,plnplyw3,8,plnplyw3tip,8,plnplyelv3


	dw	8,plnplyw2,8,plnplyw2tip,8,plnplyelv2
	dw	8,plnply2top,8,plnply2bot
	dw	8,plnply1,8,plnply4,8,plnply3bot,2,plnfr1,8,plnply3top,8,plnply3
	dw	8,plnply2tri,8,plnply2toptri,8,plnply2bottri
	dw	8,plnply3tri,8,plnply3toptri,8,plnply3bottri
	dw	8,plnply4tri,8,plnply5tri,8,plnplytail
	dw	8,plnplyw3,8,plnplyw3tip,8,plnplyelv3
	dw	6,sdsph


	dw	6,sdsph
	dw	8,plnplyw3,8,plnplyw3tip,8,plnplyelv3
	dw	8,plnply3top,8,plnply3bot
	dw	8,plnply1,8,plnply5,8,plnply2top,2,plnfr1,8,plnply2bot,8,plnply2
	dw	8,plnply3tri,8,plnply3toptri,8,plnply3bottri
	dw	8,plnply2tri,8,plnply2toptri,8,plnply2bottri
	dw	8,plnply4tri,8,plnply5tri,8,plnplytail
	dw	8,plnplyw2,8,plnplyw2tip,8,plnplyelv2


	dw	8,plnplyw3,8,plnplyw3tip,8,plnplyelv3
	dw	8,plnply3top,8,plnply3bot
	dw	8,plnply1,8,plnply4,8,plnply2bot,2,plnfr1,8,plnply2top,8,plnply2
	dw	8,plnply3tri,8,plnply3toptri,8,plnply3bottri
	dw	8,plnply2tri,8,plnply2toptri,8,plnply2bottri
	dw	8,plnply4tri,8,plnply5tri,8,plnplytail
	dw	8,plnplyw2,8,plnplyw2tip,8,plnplyelv2
	dw	6,sdsph

plnplyobj	dw	0,0,0
	dw	23

	dw	8,plnplyw2,8,plnplyw2tip,8,plnplyelv2
	dw	8,plnply2top,8,plnply2bot
	dw	8,plnply2tri,8,plnply2toptri,8,plnply2bottri
	dw	8,plnply3tri,8,plnply3toptri,8,plnply3bottri
	dw	0,0,0,0,8,plnply5,8,plnply3top,8,plnply3bot,8,plnply3
	dw	8,plnply4tri,8,plnply5tri
	dw	8,plnplyw3,8,plnplyw3tip,8,plnplytail,8,plnplyelv3

	dw	8,plnplyw2,8,plnplyw2tip,8,plnplyelv2
	dw	8,plnply2tri,8,plnply2toptri,8,plnply2bottri
	dw	8,plnply3tri,8,plnply3toptri,8,plnply3bottri
	dw	8,plnply2top,8,plnply2bot
	dw	0,0,0,0,8,plnply4,8,plnply3bot,8,plnply3top,8,plnply3
	dw	8,plnply4tri,8,plnply5tri
	dw	8,plnplyw3,8,plnplyw3tip,8,plnplytail,8,plnplyelv3


	dw	8,plnplyw3,8,plnplyw3tip,8,plnplyelv3
	dw	8,plnply3tri,8,plnply3toptri,8,plnply3bottri
	dw	8,plnply2tri,8,plnply2toptri,8,plnply2bottri
	dw	8,plnply3top,8,plnply3bot
	dw	0,0,0,0,8,plnply5,8,plnply2top,8,plnply2bot,8,plnply2
	dw	8,plnply4tri,8,plnply5tri
	dw	8,plnplyw2,8,plnplyw2tip,8,plnplytail,8,plnplyelv2


	dw	8,plnplyw3,8,plnplyw3tip,8,plnplyelv3
	dw	8,plnply3tri,8,plnply3toptri,8,plnply3bottri
	dw	8,plnply2tri,8,plnply2toptri,8,plnply2bottri
	dw	8,plnply3top,8,plnply3bot
	dw	0,0,0,0,8,plnply4,8,plnply2bot,8,plnply2top,8,plnply2
	dw	8,plnply4tri,8,plnply5tri
	dw	8,plnplyw2,8,plnplyw2tip,8,plnplytail,8,plnplyelv2


	dw	8,plnplyw2,8,plnplyw2tip,8,plnplyelv2
	dw	8,plnply2top,8,plnply2bot
	dw	8,plnply1,8,plnply5,8,plnply3top,2,plnfr1,8,plnply3bot,8,plnply3
	dw	8,plnply2tri,8,plnply2toptri,8,plnply2bottri
	dw	8,plnply3tri,8,plnply3toptri,8,plnply3bottri
	dw	8,plnply4tri,8,plnply5tri,8,plnplytail
	dw	8,plnplyw3,8,plnplyw3tip,8,plnplyelv3


	dw	8,plnplyw2,8,plnplyw2tip,8,plnplyelv2
	dw	8,plnply2top,8,plnply2bot
	dw	8,plnply1,8,plnply4,8,plnply3bot,2,plnfr1,8,plnply3top,8,plnply3
	dw	8,plnply2tri,8,plnply2toptri,8,plnply2bottri
	dw	8,plnply3tri,8,plnply3toptri,8,plnply3bottri
	dw	8,plnply4tri,8,plnply5tri,8,plnplytail
	dw	8,plnplyw3,8,plnplyw3tip,8,plnplyelv3


	dw	8,plnplyw3,8,plnplyw3tip,8,plnplyelv3
	dw	8,plnply3top,8,plnply3bot
	dw	8,plnply1,8,plnply5,8,plnply2top,2,plnfr1,8,plnply2bot,8,plnply2
	dw	8,plnply3tri,8,plnply3toptri,8,plnply3bottri
	dw	8,plnply2tri,8,plnply2toptri,8,plnply2bottri
	dw	8,plnply4tri,8,plnply5tri,8,plnplytail
	dw	8,plnplyw2,8,plnplyw2tip,8,plnplyelv2


	dw	8,plnplyw3,8,plnplyw3tip,8,plnplyelv3
	dw	8,plnply3top,8,plnply3bot
	dw	8,plnply1,8,plnply4,8,plnply2bot,2,plnfr1,8,plnply2top,8,plnply2
	dw	8,plnply3tri,8,plnply3toptri,8,plnply3bottri
	dw	8,plnply2tri,8,plnply2toptri,8,plnply2bottri
	dw	8,plnply4tri,8,plnply5tri,8,plnplytail
	dw	8,plnplyw2,8,plnplyw2tip,8,plnplyelv2

;splnply1	dw	5
splnply1	dw	4
	dw	7
	dw	lp4,0,lpo2
	dw	-l4rear,0,lpo2
	dw	-l10,0,0
	dw	-l4rear,0,-lpo2
	dw	lp4,0,lpo2

;splnply2	dw	5
splnply2	dw	4
	dw	7
	dw	lp4,lpo2,0
	dw	-l4rear,lpo2,0
	dw	-l10,0,0
	dw	-l4rear,-lpo2,0
	dw	lp4,lpo2,0

splnplyobj	dw	0,0,0
	dw	7

	dw	8,plnplyw2,8,plnplyw2tip
	dw	8,splnply2,8,splnply1
	dw	8,plnplyw3,8,plnplyw3tip,8,plnplytail

	dw	8,plnplyw2,8,plnplyw2tip
	dw	8,splnply2,8,splnply1
	dw	8,plnplyw3,8,plnplyw3tip,8,plnplytail


	dw	8,plnplyw3,8,plnplyw3tip
	dw	8,splnply2,8,splnply1
	dw	8,plnplyw2,8,plnplyw2tip,8,plnplytail


	dw	8,plnplyw3,8,plnplyw3tip
	dw	8,splnply2,8,splnply1
	dw	8,plnplyw2,8,plnplyw2tip,8,plnplytail


	dw	8,plnplyw2,8,plnplyw2tip
	dw	8,splnply2,8,splnply1
	dw	8,plnplyw3,8,plnplyw3tip,8,plnplytail


	dw	8,plnplyw2,8,plnplyw2tip
	dw	8,splnply2,8,splnply1
	dw	8,plnplyw3,8,plnplyw3tip,8,plnplytail


	dw	8,plnplyw3,8,plnplyw3tip,8,plnplytail
	dw	8,splnply2,8,splnply1
	dw	8,plnplyw2,8,plnplyw2tip


	dw	8,plnplyw3,8,plnplyw3tip,8,plnplytail
	dw	8,splnply2,8,splnply1
	dw	8,plnplyw2,8,plnplyw2tip

ssplnwr1	dw	1
	dw	1
	dw	0,-l8,0
	dw	0,l8,0

ssplnwr2	dw	1
	dw	7
	dw	-l4,0,0
	dw	-l10,0,0
ssplnfr	dw	2
	dw	ssplnwr1
	dw	ssplnwr2

ssplnobj	dw	0,0,0
	dw	1
	dw	8 dup (2,ssplnfr)


pwid	equ	lpo6/2
pwids	equ	lpo6/4
ppit	equ	lpo6/4
ppits	equ	lpo6/8
plen	equ	3*lpo2
ptip	equ	plen+pwid
psml	equ	lpo2
poff	equ	lp4+lpo6/2

propply1s	dw	4
		dw	15
		dw	poff,-pwids,0
		dw	poff,-pwid,psml
		dw	poff,pwid,psml
		dw	poff,pwids,0

propply2s	dw	4
		dw	15
		dw	poff,-pwids,0
		dw	poff,-pwid,-psml
		dw	poff,pwid,-psml
		dw	poff,pwids,0

propply3s	dw	4
		dw	15
		dw	poff,0,-pwids
		dw	poff,-psml,-pwid
		dw	poff,-psml,pwid
		dw	poff,0,pwids

propply4s	dw	4
		dw	15
		dw	poff,0,-pwids
		dw	poff,psml,-pwid
		dw	poff,psml,pwid
		dw	poff,0,pwids

propply1tip	dw	3
		dw	14
		dw	poff,0,ptip
		dw	poff,-pwid,plen
		dw	poff,pwid,plen

propply2tip	dw	3
		dw	14
		dw	poff,0,-ptip
		dw	poff,-pwid,-plen
		dw	poff,pwid,-plen

propply3tip	dw	3
		dw	14
		dw	poff,-ptip,0
		dw	poff,-plen,-pwid
		dw	poff,-plen,pwid

propply4tip	dw	3
		dw	14
		dw	poff,ptip,0
		dw	poff,plen,-pwid
		dw	poff,plen,pwid

propply1	dw	4
		dw	0
		dw	poff-ppit,-pwid,psml
		dw	poff-ppit,-pwid,plen
		dw	ppit+poff,pwid,plen
		dw	ppit+poff,pwid,psml

propply2	dw	4
		dw	0
		dw	ppit+poff,-pwid,-psml
		dw	ppit+poff,-pwid,-plen
		dw	-ppit+poff,pwid,-plen
		dw	-ppit+poff,pwid,-psml

propply3	dw	4
		dw	0
		dw	-ppit+poff,-psml,-pwid
		dw	-ppit+poff,-plen,-pwid
		dw	ppit+poff,-plen,pwid
		dw	ppit+poff,-psml,pwid

propply4	dw	4
		dw	0
		dw	ppit+poff,psml,-pwid
		dw	ppit+poff,plen,-pwid
		dw	-ppit+poff,plen,pwid
		dw	-ppit+poff,psml,pwid

propsph		dw	1
		dw	poff,0,0,5*pwid,0

propobj	dw	0,0,0
	dw	13
rept	8
	dw	8,propply1tip,8,propply2tip,8,propply3tip,8,propply4tip
	dw	8,propply1s,8,propply2s,8,propply3s,8,propply4s
	dw	6,propsph,8,propply1,8,propply2,8,propply3,8,propply4
endm

spropply1	dw	4
		dw	0
		dw	poff-ppit,-pwid,0
		dw	poff-ppit,-pwid,ptip
		dw	ppit+poff,pwid,ptip
		dw	ppit+poff,pwid,0

spropply2	dw	4
		dw	0
		dw	ppit+poff,-pwid,-0
		dw	ppit+poff,-pwid,-ptip
		dw	-ppit+poff,pwid,-ptip
		dw	-ppit+poff,pwid,-0

spropply3	dw	4
		dw	0
		dw	-ppit+poff,-0,-pwid
		dw	-ppit+poff,-ptip,-pwid
		dw	ppit+poff,-ptip,pwid
		dw	ppit+poff,-0,pwid

spropply4	dw	4
		dw	0
		dw	ppit+poff,0,-pwid
		dw	ppit+poff,ptip,-pwid
		dw	-ppit+poff,ptip,pwid
		dw	-ppit+poff,0,pwid

spropobj	dw	0,0,0
	dw	5
	dw	8 dup(6,propsph,8,spropply1,8,spropply2,8,spropply3,8,spropply4)

sspropwr1	dw	1
		dw 	0
	dw	poff,-ptip,0
	dw	poff,ptip,0

sspropwr2	dw	1
	dw	0
	dw	poff,0,-ptip
	dw	poff,0,ptip

sspropfrm	dw	2
	dw	sspropwr1
	dw	sspropwr2
sspropobj	dw	0,0,0
	dw	2
	dw	8 dup(2,sspropfrm,6,propsph)
	

lsun	equ	120
lsunsq	equ	lsun*100/141
lsun2	equ	lsun*3/2
lsunsq2	equ	lsunsq*3/2

.public	sunclr,sunsz1,sunsz2
sunclr	db	14

sunsph	dw	2
	dw	0,0,0
sunsz1	dw	lsun,15
	dw	0,0,0
sunsz2	dw	lsun-8,sunclr

sunwr1	dw	1
	dw	14
	dw	lsun,0,500
	dw	lsun2,0,500

sunwr2	dw	1
	dw	14
	dw	-lsun,0,500
	dw	-lsun2,0,500

sunwr3	dw	1
	dw	14
	dw	0,-lsun,500
	dw	0,-lsun2,500

sunwr8	dw	1
	dw	14
	dw	0,lsun,500
	dw	0,lsun2,500

sunwr4	dw	1
	dw	14
	dw	lsunsq,lsunsq,500
	dw	lsunsq2,lsunsq2,500

sunwr5	dw	1
	dw	14
	dw	-lsunsq,-lsunsq,500
	dw	-lsunsq2,-lsunsq2,500

sunwr6	dw	1
	dw	14
	dw	lsunsq,-lsunsq,500
	dw	lsunsq2,-lsunsq2,500

sunwr7	dw	1
	dw	14
	dw	-lsunsq,lsunsq,500
	dw	-lsunsq2,lsunsq2,500

sunfrm	dw	8
	dw	sunwr1
	dw	sunwr2
	dw	sunwr3
	dw	sunwr4
	dw	sunwr5
	dw	sunwr6
	dw	sunwr7
	dw	sunwr8

smwr1	dw	3
	dw	0
	dw	-lsun*3/16,-lsun/10,500
	dw	-lsun*3/32,-lsun/4,500
	dw	lsun*3/32,-lsun/4,500
	dw	lsun*3/16,-lsun/10,500
smfr1	dw	1
	dw	smwr1

smlsph	dw	2
	dw	-lsun/8,lsun/4,500,lsun/6,0
	dw	lsun/8,lsun/4,500,lsun/6,0

sunobj	dw	0,0,500			; since we draw direct, leave in 500
	dw	1
	dw	8 dup (6,sunsph)

sunobj1 	dw	0,0,500
	dw	4
	dw	8 dup (6,sunsph,2,sunfrm,2,smfr1,6,smlsph)

hqply1	dw	3
	dw	clrhqc
	dw	-lhqlo2,-lhql86,-lhq
	dw	lhqlo2,-lhql86,-lhq
	dw	0,lhqlo2,-lhq

hqply2	dw	4
	dw	clrhqb
	dw	-lhqlo2,-lhql86,-lhq
	dw	lhqlo2,-lhql86,-lhq
	dw	lhqlo2a,-lhql86a,-lhq*2
	dw	-lhqlo2a,-lhql86a,-lhq*2

hqply3	dw	4
	dw	clrhqb
	dw	lhqlo2,-lhql86,-lhq
	dw	0,lhqlo2,-lhq
	dw	0,lhqlo2a,-lhq*2
	dw	lhqlo2a,-lhql86a,-lhq*2

hqply4	dw	4
	dw	clrhqb
	dw	-lhqlo2,-lhql86,-lhq
	dw	0,lhqlo2,-lhq
	dw	0,lhqlo2a,-lhq*2
	dw	-lhqlo2a,-lhql86a,-lhq*2

hqsph	dw	1
	dw	0,0,0,lhq*2,clrhq

shqobj	dw	0,0,0
	dw	1
	dw	8 dup (6,hqsph)



hqobj	dw	0,0,0
	dw	5
	dw	6,hqsph,8,hqply1,8,hqply2,8,hqply3,8,hqply4
	dw	8,hqply2,8,hqply3,8,hqply4,8,hqply1,6,hqsph
	dw	6,hqsph,8,hqply1,8,hqply2,8,hqply3,8,hqply4
	dw	8,hqply2,8,hqply3,8,hqply4,8,hqply1,6,hqsph
	dw	6,hqsph,8,hqply1,8,hqply2,8,hqply3,8,hqply4
	dw	8,hqply2,8,hqply3,8,hqply4,8,hqply1,6,hqsph
	dw	6,hqsph,8,hqply1,8,hqply2,8,hqply3,8,hqply4
	dw	8,hqply2,8,hqply3,8,hqply4,8,hqply1,6,hqsph
	dw	6,hqsph,8,hqply1,8,hqply2,8,hqply3,8,hqply4
	dw	8,hqply2,8,hqply3,8,hqply4,8,hqply1,6,hqsph
	dw	6,hqsph,8,hqply1,8,hqply2,8,hqply3,8,hqply4
	dw	8,hqply2,8,hqply3,8,hqply4,8,hqply1,6,hqsph
	dw	6,hqsph,8,hqply1,8,hqply2,8,hqply3,8,hqply4
	dw	8,hqply2,8,hqply3,8,hqply4,8,hqply1,6,hqsph
	dw	6,hqsph,8,hqply1,8,hqply2,8,hqply3,8,hqply4
	dw	8,hqply2,8,hqply3,8,hqply4,8,hqply1,6,hqsph

twply1	dw	3
	dw	0
	dw	-ltwlo2,-ltwl86,-ltw
	dw	ltwlo2,-ltwl86,-ltw
	dw	0,ltwlo2,-ltw

twply2	dw	4
	dw	5
	dw	-ltwlo2,-ltwl86,-ltw
	dw	ltwlo2,-ltwl86,-ltw
	dw	ltwlo2a,-ltwl86a,-ltw*2
	dw	-ltwlo2a,-ltwl86a,-ltw*2

twply3	dw	4
	dw	5
	dw	ltwlo2,-ltwl86,-ltw
	dw	0,ltwlo2,-ltw
	dw	0,ltwlo2a,-ltw*2
	dw	ltwlo2a,-ltwl86a,-ltw*2

twply4	dw	4
	dw	5
	dw	-ltwlo2,-ltwl86,-ltw
	dw	0,ltwlo2,-ltw
	dw	0,ltwlo2a,-ltw*2
	dw	-ltwlo2a,-ltwl86a,-ltw*2


rdrply1	dw	4
	dw	clrtwr
	dw	-ltwl2-ltw,-ltw,-ltwl2+ltw
	dw	-ltwl2-ltw,-ltw,ltwl2+ltw
	dw	-ltwl2,0,ltwl2+ltw
	dw	-ltwl2,0,-ltwl2+ltw

rdrply2	dw	4
	dw	clrtwr
	dw	ltwl2+ltw,-ltw,-ltwl2+ltw
	dw	ltwl2,0,-ltwl2+ltw
	dw	ltwl2,0,ltwl2+ltw
	dw	ltwl2+ltw,-ltw,ltwl2+ltw

rdrply3	dw	4
	dw	clrtwr
	dw	ltwl2,0,-ltwl2+ltw
	dw	ltwl2,0,ltwl2+ltw
	dw	-ltwl2,0,ltwl2+ltw
	dw	-ltwl2,0,-ltwl2+ltw

rdrply4	dw	3
	dw	0
	dw	ltw/4,ltw/4,-ltw
	dw	-ltw/4,ltw/4,-ltw
	dw	0,ltw/4,ltwl2+ltw

rdrply5	dw	3
	dw	0
	dw	0,ltw/4+ltw/4,-ltw
	dw	0,-ltw/4+ltw/4,-ltw
	dw	0,ltw/4,2*ltw

rdrobj	dw	0,0,0
	dw	5
	dw	2 dup (8,rdrply5,8,rdrply4,8,rdrply1,8,rdrply2,8,rdrply3)
	dw	2 dup (8,rdrply1,8,rdrply2,8,rdrply3,8,rdrply4,8,rdrply5)
	dw	2 dup (8,rdrply5,8,rdrply4,8,rdrply1,8,rdrply2,8,rdrply3)
	dw	2 dup (8,rdrply1,8,rdrply2,8,rdrply3,8,rdrply4,8,rdrply5)


twobj	dw	0,0,0
	dw	4
	dw	8,twply1,8,twply2,8,twply3,8,twply4
	dw	8,twply2,8,twply3,8,twply4,8,twply1
	dw	8,twply1,8,twply2,8,twply3,8,twply4
	dw	8,twply2,8,twply3,8,twply4,8,twply1
	dw	8,twply1,8,twply2,8,twply3,8,twply4
	dw	8,twply2,8,twply3,8,twply4,8,twply1
	dw	8,twply1,8,twply2,8,twply3,8,twply4
	dw	8,twply2,8,twply3,8,twply4,8,twply1
	dw	8,twply1,8,twply2,8,twply3,8,twply4
	dw	8,twply2,8,twply3,8,twply4,8,twply1
	dw	8,twply1,8,twply2,8,twply3,8,twply4
	dw	8,twply2,8,twply3,8,twply4,8,twply1
	dw	8,twply1,8,twply2,8,twply3,8,twply4
	dw	8,twply2,8,twply3,8,twply4,8,twply1
	dw	8,twply1,8,twply2,8,twply3,8,twply4
	dw	8,twply2,8,twply3,8,twply4,8,twply1

stwply1	dw	3
	dw	5
	dw	-ltwlo2a,-ltwl86a,-ltw*2
	dw	ltwlo2a,-ltwl86a,-ltw*2
	dw	0,ltwlo2a,-ltw*2

stwobj	dw	0,0,0
	dw	2
	dw	8 dup(8,stwply1,8,twply1)

nulobj	dw	0,0,0
	dw	1
	dw	8 dup(0,0)		; draw no object at all

srdrply3	dw	4
	dw	clrtwr
	dw	ltwl2+ltw,0,-ltwl2+ltw
	dw	ltwl2+ltw,0,ltwl2+ltw
	dw	-ltwl2-ltw,0,ltwl2+ltw
	dw	-ltwl2-ltw,0,-ltwl2+ltw


srdrwr	dw	3
	dw	0
	dw	0,ltw/4+ltw/4,-ltw
	dw	0,ltw/4,2*ltw
	dw	0,-ltw/4+ltw/4,-ltw
	dw	0,ltw/4+ltw/4,-ltw

srdrfrm	dw	1
	dw	srdrwr

srdrobj	dw	0,0,0
	dw	2
	dw	8 dup (2,srdrfrm,8,srdrply3)

ssrdrsph	dw	1
	dw	0,0,ltw,ltwl2+ltw,clrtwr

ssrdrobj	dw	0,0,0
	dw	1
	dw	8 dup (6,ssrdrsph)

bbsmsz	equ	bbsize2
bbsmsz8	equ	500

bbsmsph	dw	6
	dw	0,0,-bbsmsz,bbsmsz8,15
	dw	0,0,bbsmsz,bbsmsz8,bbclr
	dw	-bbsmsz,0,0,bbsmsz8,4
	dw	bbsmsz,0,0,bbsmsz8,0dh
	dw	0,bbsmsz,0,bbsmsz8,bbclr
	dw	0,-bbsmsz,0,bbsmsz8,bbclr

bbsmobj	dw	0,0,0
	dw	1
	dw	8 dup(6,bbsmsph)

yahclr	dw	15

yahsph	dw	1
	dw	0,0,0,15000,yahclr

yahobj	dw	0,0,0
	dw	1
	dw	8 dup (6,yahsph)


IF mbflag EQ 1
cursorsz	equ	500
cursorsz8	equ	cursorsz/2

cursorsph1	dw	1
	dw	0,0,-cursorsz,cursorsz8,15
cursorsph2	dw	1
	dw	0,0,cursorsz,cursorsz8,0
cursorsph3	dw	1
	dw	-cursorsz,0,0,cursorsz8,4
cursorsph4	dw	1
	dw	cursorsz,0,0,cursorsz8,0dh
cursorsph5	dw	1
	dw	0,cursorsz,0,cursorsz8,9
cursorsph6	dw	1
	dw	0,-cursorsz,0,cursorsz8,14
cursorobj	dw	0,0,0
	dw	6

	dw	6,cursorsph4,6,cursorsph3,6,cursorsph5,6,cursorsph6
	dw	6,cursorsph2,6,cursorsph1
	dw	6,cursorsph4,6,cursorsph3,6,cursorsph5,6,cursorsph6
	dw	6,cursorsph1,6,cursorsph2
	dw	6,cursorsph4,6,cursorsph3,6,cursorsph6,6,cursorsph5
	dw	6,cursorsph2,6,cursorsph1
	dw	6,cursorsph4,6,cursorsph3,6,cursorsph6,6,cursorsph5
	dw	6,cursorsph1,6,cursorsph2

	dw	6,cursorsph3,6,cursorsph4,6,cursorsph5,6,cursorsph6
	dw	6,cursorsph2,6,cursorsph1
	dw	6,cursorsph3,6,cursorsph4,6,cursorsph5,6,cursorsph6
	dw	6,cursorsph1,6,cursorsph2
	dw	6,cursorsph3,6,cursorsph4,6,cursorsph6,6,cursorsph5
	dw	6,cursorsph2,6,cursorsph1
	dw	6,cursorsph3,6,cursorsph4,6,cursorsph6,6,cursorsph5
	dw	6,cursorsph1,6,cursorsph2

objcursor	dw	8000,roadx-1	; 32 bit xyz coordinates
	dw	8000,0
	dw	0,15		; lift off the ground
	dw	-8000		; yaw, pitch, and roll
	dw	-2456
	dw	0

	db	0		; distance default, 0=near
	db	1		; this is a class 1 object

	dw	9612,244	; 32-bit distance squared

	dw	0		; object type 0= no-draw bit 4=destructable
	dw	3		; rotflg, 0= no rotation
	dd	977625289	; breakpoint for near dist squared
	dd	256680332	; bkpt for med near dist sqrd
	dd	16680332	; bkpt for med far dist sqrd
	dw	cursorobj		; address of near object
	dw	cursorobj		; address of med object
	dw	cursorobj		; address of med object
	dw	0,0,0		; xyz velocity of object
	dw	1		; done flag 0= no move
	dw	0,0,0		; yaw, pitch and roll angular velocities
	dw	0,0		; dispersion, and wind resistance damping
	dw	0		; gravity
	dw	l*15,l*15,2*l	; rectangle of collision
	dw	21
ENDIF

youarehere	dw	0,0	; 32 bit xyz coordinates
	dw	0,0
	dw	0,0		; lift off the ground
	dw	-8000		; yaw, pitch, and roll
	dw	-2456
	dw	0

	db	0		; distance default, 0=near
	db	1		; this is a class 1 object

	dw	9612,244	; 32-bit distance squared

	dw	131h		; object type 0= no-draw bit 4=destructable
	dw	3		; rotflg, 0= no rotation
	dd	977625289	; breakpoint for near dist squared
	dd	977625289	; breakpoint for near dist squared
	dd	977625289	; breakpoint for near dist squared
	dw	yahobj		; address of near object
	dw	yahobj		; address of med object
	dw	yahobj		; address of med object
	dw	0,0,0		; xyz velocity of object
	dw	1		; done flag 0= no move
	dw	0,0,0		; yaw, pitch and roll angular velocities
	dw	0,0		; dispersion, and wind resistance damping
	dw	0		; gravity
	dw	l*15,l*15,2*l	; rectangle of collision
	dw	28

obj5d	dw	8000,roadx-1	; 32 bit xyz coordinates
	dw	8000,0
	dw	ehmin,0		; lift off the ground
	dw	-8000		; yaw, pitch, and roll
	dw	-2456
	dw	0

	db	0		; distance default, 0=near
	db	1		; this is a class 1 object

	dw	9612,244	; 32-bit distance squared

	dw	0e1h		; object type 0= no-draw bit 4=destructable
;	dw	11h
	dw	3		; rotflg, 0= no rotation
	dd	977625289	; breakpoint for near dist squared
	dd	256680332	; bkpt for med near dist sqrd
	dd	16680332	; bkpt for med far dist sqrd
	dw	plnplyobj		; address of near object
	dw	splnplyobj		; address of med object
	dw	ssplnobj		; address of med object
	dw	0,0,0		; xyz velocity of object
	dw	1		; done flag 0= no move
	dw	0,0,0		; yaw, pitch and roll angular velocities
	dw	0,0		; dispersion, and wind resistance damping
	dw	0		; gravity
	dw	lp4,lp4,lp4	; rectangle of collision
IF cdct EQ 0
	dw	28
ELSE
	dw	@codeseg:odest
ENDIF

objprop	dw	4000,0		; 32 bit xyz coordinates
	dw	0,0
	dw	18928,2
	dw	0		; yaw, pitch, and roll
	dw	0
	dw	0

	db	0		; distance default, 0=near
	db	1		; friendly
	dw	9612,244	; 32-bit distance squared

	dw	11h		; object type 0= no-draw bit 4=destructable
	dw	2		; rotflg, 0= no rotation
	dd	977625289	; breakpoint for near dist squared
	dd	256680332	; bkpt for med near dist sqrd
	dd	256680332	; bkpt for med far dist sqrd
	dw	propobj		; address of near object
	dw	spropobj		; address of med object
	dw	sspropobj		; address of med object
	dw	0,0,0		; xyz velocity of object
	dw	1		; done flag 0= no move
	dw	0,0,0		; yaw, pitch and roll angular velocities
	dw	0,0		; dispersion, and wind resistance damping
	dw	0		; gravity
	dw	l,l,l		; rectangle of collision
IF cdct EQ 0
	dw	29
ELSE
	dw	@codeseg:donothing
ENDIF

w2	equ	w/2
w10	equ	w/10
rl	equ	16384
rl2	equ	rl/2
rl8	equ	rl/8
rl16	equ	rl/16
;rl38	equ	rl8*3
rl38	equ	rl16*6

rlpl1	dw	4
	dw	0
	dw	-rl2,-w,0
	dw	rl2,-w,0
	dw	rl2,w,0
	dw	-rl2,w,0

rlpl10	dw	4
	dw	0
	dw	0,-w,0
	dw	rl2,-w,0
	dw	rl2,w,0
	dw	0,w,0

rlpl2	dw	4
	dw	15
	dw	-rl16,-w10,0
	dw	-rl16-rl38,-w10,0
	dw	-rl16-rl38,w10,0
	dw	-rl16,w10,0

rlpl3	dw	4
	dw	15
	dw	rl16,-w10,0
	dw	rl16+rl38,-w10,0
	dw	rl16+rl38,w10,0
	dw	rl16,w10,0

rlpl4	dw	4
	dw	14
	dw	rl16,-w10,0
	dw	rl16+rl38,-w10,0
	dw	rl16+rl38,w10,0
	dw	rl16,w10,0

rlpl5	dw	4
	dw	14
	dw	rl16,-w10+w/2,0
	dw	rl16+rl38,-w10+w/2,0
	dw	rl16+rl38,w10+w/2,0
	dw	rl16,w10+w/2,0

rlpl6	dw	4
	dw	14
	dw	rl16,-w10-w/2,0
	dw	rl16+rl38,-w10-w/2,0
	dw	rl16+rl38,w10-w/2,0
	dw	rl16,w10-w/2,0

rlpl7	dw	4
	dw	14
	dw	rl2-rl16,-w10,0
	dw	rl2-rl16-rl38,-w10,0
	dw	rl2-rl16-rl38,w10,0
	dw	rl2-rl16,w10,0

rlpl8	dw	4
	dw	14
	dw	rl2-rl16,-w10+w/2,0
	dw	rl2-rl16-rl38,-w10+w/2,0
	dw	rl2-rl16-rl38,w10+w/2,0
	dw	rl2-rl16,w10+w/2,0

rlpl9	dw	4
	dw	14
	dw	rl2-rl16,-w10-w/2,0
	dw	rl2-rl16-rl38,-w10-w/2,0
	dw	rl2-rl16-rl38,w10-w/2,0
	dw	rl2-rl16,w10-w/2,0

rlwr1	dw	1
	dw	15
	dw	-rl2,-w,0
	dw	rl2,-w,0
rlwr2	dw	1
	dw	7
	dw	-rl2,w,0
	dw	rl2,w,0
rlwr3	dw	4
	dw	15
	dw	-rl16,-w10,0
	dw	-rl16-rl38,-w10,0
	dw	-rl16-rl38,w10,0
	dw	-rl16,w10,0
	dw	-rl16,-w10,0
rlwr4	dw	4
	dw	15
	dw	rl16,-w10,0
	dw	rl16+rl38,-w10,0
	dw	rl16+rl38,w10,0
	dw	rl16,w10,0
	dw	rl16,-w10,0
	


rlfrm1	dw	4
	dw	rlwr1
	dw	rlwr2
	dw	rlwr3
	dw	rlwr4

rlfrm2	dw	1
	dw	rlwr3


srlwr1	dw	1
	dw	0
	dw	-rl2,0,0
	dw	rl2,0,0

srlfrm1	dw	1
	dw	srlwr1


roadobj	dw	0,0,0
	dw	2
	dw	8 dup(8,rlpl1,8,rlpl2)

paveobj	dw	0,0,0
	dw	1
	dw	8 dup(8,rlpl1)

roadendobj	dw	0,0,0
	dw	5
	dw	8 dup(8,rlpl1,8,rlpl2,8,rlpl4,8,rlpl5,8,rlpl6)

roadendobj1	dw	0,0,0
	dw	4
	dw	8 dup(8,rlpl10,8,rlpl7,8,rlpl8,8,rlpl9)

roadobj1	dw	0,0,0
	dw	1
	dw	8 dup(2,rlfrm1)

scroadobj	dw	0,0,0
	dw	2
	dw	8 dup(8,rlpl1,2,rlfrm2)

sroadobj	dw	0,0,0
	dw	1
	dw	8 dup(2,srlfrm1)

bodclr	dw	3
whlclr	dw	0
vechantclr	dw	0

veply1	dw	3
	dw	bodclr
	dw	vesz,0,veszht
	dw	-vesz86,-vesz2,veszht
	dw	-vesz86,vesz2,veszht

vewr1	dw	2
	dw	vechantclr
	dw	-vesz86,0,veszht
	dw	-vesz86,0,veszht+vesz*2
	dw	-vesz86-vesz2/2,0,veszht+vesz*2+vesz2

vewr2	dw	1
	dw	vechantclr
	dw	-vesz86,0,veszht
	dw	-vesz86-vesz2/2,0,veszht+vesz*2+vesz2

vefrm1	dw	1
	dw	vewr1
vefrm2	dw	1
	dw	vewr2

vesph1	dw	1
	dw	vesz,0,veszht,veszwh,whlclr
vesph2	dw	1
	dw	-vesz86,-vesz2,veszht,veszwh,whlclr
vesph3	dw	1
	dw	-vesz86,vesz2,veszht,veszwh,whlclr

veobj	dw	0,0,0
	dw	5

	dw	6,vesph1,8,veply1,6,vesph3,6,vesph2,2,vefrm1
	dw	6,vesph1,8,veply1,6,vesph3,6,vesph2,2,vefrm1

	dw	6,vesph1,8,veply1,6,vesph2,6,vesph3,2,vefrm1
	dw	6,vesph1,8,veply1,6,vesph2,6,vesph3,2,vefrm1

	dw	2,vefrm1,6,vesph3,8,veply1,6,vesph2,6,vesph1
	dw	2,vefrm1,6,vesph3,8,veply1,6,vesph2,6,vesph1

	dw	2,vefrm1,6,vesph2,8,veply1,6,vesph3,6,vesph1
	dw	2,vefrm1,6,vesph2,8,veply1,6,vesph3,6,vesph1

sveobj	dw	0,0,0
	dw	4

	dw	6,vesph1,6,vesph3,6,vesph2,2,vefrm2
	dw	6,vesph1,6,vesph3,6,vesph2,2,vefrm2

	dw	6,vesph1,6,vesph2,6,vesph3,2,vefrm2
	dw	6,vesph1,6,vesph2,6,vesph3,2,vefrm2

	dw	6,vesph3,6,vesph2,6,vesph1,2,vefrm2
	dw	6,vesph3,6,vesph2,6,vesph1,2,vefrm2

	dw	6,vesph2,6,vesph3,6,vesph1,2,vefrm2
	dw	6,vesph2,6,vesph3,6,vesph1,2,vefrm2

vestwr1	dw	3
	dw	bodclr
	dw	vesz,0,0
	dw	-vesz86,-vesz2,0
	dw	-vesz86,vesz2,0
	dw	vesz,0,0

vestfrm	dw	1
	dw	vestwr1

vestobj	dw	0,0,0
	dw	1
	dw	8 dup(2,vestfrm)


wallc	dw	6+10h		; make into a screen

wallplyy	dw	4
	dw	wallc
	dw	-wallsz2*2,0,-wallsz2
	dw	wallsz2*2,0,-wallsz2
	dw	wallsz2*2,0,wallsz2
	dw	-wallsz2*2,0,wallsz2

wallplyx	dw	4
	dw	wallc
	dw	0,-wallsz2*2,-wallsz2
	dw	0,wallsz2*2,-wallsz2
	dw	0,wallsz2*2,wallsz2
	dw	0,-wallsz2*2,wallsz2

wallplyz	dw	4
	dw	wallc
	dw	-wallsz,-wallsz,0
	dw	wallsz,-wallsz,0
	dw	wallsz,wallsz,0
	dw	-wallsz,wallsz,0

wallplyz1	dw	4
	dw	wallc
	dw	-wallsz2,-wallsz2,0
	dw	wallsz2,-wallsz2,0
	dw	wallsz2,wallsz2,0
	dw	-wallsz2,wallsz2,0


wyobj	dw	0,0,0
	dw	1
	dw	8 dup(8,wallplyy)
wxobj	dw	0,0,0
	dw	1
	dw	8 dup(8,wallplyx)
wzobj	dw	0,0,0
	dw	1
	dw	8 dup(8,wallplyz)
wz1obj	dw	0,0,0
	dw	1
	dw	8 dup(8,wallplyz1)
framecount	dw	0

nwallsz22	dw	15
nwallsz22b	dw	3
wallsz22tbl	dw	lwallwry+4
	dw	lwallwry+10
	dw	lwallwry+16
	dw	lwallwry+22
	dw	lwallwry+28
	dw	lwallwrx+4+2
	dw	lwallwrx+10+2
	dw	lwallwrx+16+2
	dw	lwallwrx+22+2
	dw	lwallwrx+28+2
	dw	lwallwrz+4
	dw	lwallwrz+10
	dw	lwallwrz+16
	dw	lwallwrz+22
	dw	lwallwrz+28
	dw	objlwally+66			; xcoord of objlwally
	dw	objlwallx+68			; ycoord of objlwallx
	dw	objlwallz+66			; xcoord of objlwallz
	dw	0

nwallsz2	dw	20
nwallsz2b	dw	4
wallsz2tbl	dw	lwallwry+4+4
	dw	lwallwry+10+4
	dw	lwallwry+16+4
	dw	lwallwry+22+4
	dw	lwallwry+28+4
	dw	lwallwrx+4+2+2
	dw	lwallwrx+10+2+2
	dw	lwallwrx+16+2+2
	dw	lwallwrx+22+2+2
	dw	lwallwrx+28+2+2
	dw	lwallwrz1+4
	dw	lwallwrz1+10
	dw	lwallwrz1+16
	dw	lwallwrz1+22
	dw	lwallwrz1+28
	dw	lwallwrz1+4+2
	dw	lwallwrz1+10+2
	dw	lwallwrz1+16+2
	dw	lwallwrz1+22+2
	dw	lwallwrz1+28+2
	dw	objlwally+70			; zcoord of objlwally
	dw	objlwallx+70			; zcoord of objlwallx
	dw	objlwallz1+66			; xcoord of objlwallz1
	dw	objlwallz1+68			; ycoord of objlwallz1
	dw	0

nwallsz	dw	5
nwallszb	dw	1
wallsztbl dw	lwallwrz+4+2
	dw	lwallwrz+10+2
	dw	lwallwrz+16+2
	dw	lwallwrz+22+2
	dw	lwallwrz+28+2
	dw	objlwallz+68			; ycoord objobjlwallz
	dw	0


lwallclr	db	0		; color of lwalls

lwallwry	dw	4
	dw	lwallclr
	dw	-wallsz2*2,0,-wallsz2
	dw	wallsz2*2,0,-wallsz2
	dw	wallsz2*2,0,wallsz2
	dw	-wallsz2*2,0,wallsz2
	dw	-wallsz2*2,0,-wallsz2

slwallwry1	dw	1
	dw	lwallclr
	dw	-swallsz2*2,0,-swallsz2
	dw	swallsz2*2,0,swallsz2

slwallwry2	dw	1
	dw	lwallclr
	dw	swallsz2*2,0,-swallsz2
	dw	-swallsz2*2,0,swallsz2

lwallfry	dw	1
	dw	lwallwry

slwallfry1	dw	3
	dw	slwallwry
	dw	slwallwry1
	dw	slwallwry2

lwallwrx	dw	4
	dw	lwallclr
	dw	0,-wallsz2*2,-wallsz2
	dw	0,wallsz2*2,-wallsz2
	dw	0,wallsz2*2,wallsz2
	dw	0,-wallsz2*2,wallsz2
	dw	0,-wallsz2*2,-wallsz2

slwallwrx1	dw	1
	dw	lwallclr
	dw	0,-swallsz2*2,-swallsz2
	dw	0,swallsz2*2,swallsz2

slwallwrx2	dw	1
	dw	lwallclr
	dw	0,swallsz2*2,-swallsz2
	dw	0,-swallsz2*2,swallsz2
	
slwallfrx1	dw	3
	dw	slwallwrx
	dw	slwallwrx1
	dw	slwallwrx2

lwallfrx	dw	1
	dw	lwallwrx

lwallwrz	dw	4
	dw	lwallclr
	dw	-wallsz,-wallsz,0
	dw	wallsz,-wallsz,0
	dw	wallsz,wallsz,0
	dw	-wallsz,wallsz,0
	dw	-wallsz,-wallsz,0

slwallwrz1	dw	1
	dw	lwallclr
	dw	-swallsz,-swallsz,0
	dw	swallsz,swallsz,0

slwallwrz2	dw	1
	dw	lwallclr
	dw	swallsz,-swallsz,0
	dw	-swallsz,swallsz,0

slwallfrz1	dw	3
	dw	slwallwrz
	dw	slwallwrz1
	dw	slwallwrz2

lwallfrz	dw	1
	dw	lwallwrz

lwallwrz1	dw	4
	dw	lwallclr
	dw	-wallsz2,-wallsz2,0
	dw	wallsz2,-wallsz2,0
	dw	wallsz2,wallsz2,0
	dw	-wallsz2,wallsz2,0
	dw	-wallsz2,-wallsz2,0

lwallfrz1	dw	1
	dw	lwallwrz1

lwyobj	dw	0,0,0
	dw	1
	dw	8 dup(2,lwallfry)
lwxobj	dw	0,0,0
	dw	1
	dw	8 dup(2,lwallfrx)
lwzobj	dw	0,0,0
	dw	1
	dw	8 dup(2,lwallfrz)
lwz1obj	dw	0,0,0
	dw	1
	dw	8 dup(2,lwallfrz1)

swallsz	equ	wallsz/2
swallsz2	equ	wallsz2/2

slwallwry	dw	4
	dw	lwallclr
	dw	-swallsz2*2,0,-swallsz2
	dw	swallsz2*2,0,-swallsz2
	dw	swallsz2*2,0,swallsz2
	dw	-swallsz2*2,0,swallsz2
	dw	-swallsz2*2,0,-swallsz2

slwallfry	dw	1
	dw	slwallwry

slwallwrx	dw	4
	dw	lwallclr
	dw	0,-swallsz2*2,-swallsz2
	dw	0,swallsz2*2,-swallsz2
	dw	0,swallsz2*2,swallsz2
	dw	0,-swallsz2*2,swallsz2
	dw	0,-swallsz2*2,-swallsz2

slwallfrx	dw	1
	dw	slwallwrx

slwallwrz	dw	4
	dw	lwallclr
	dw	-swallsz,-swallsz,0
	dw	swallsz,-swallsz,0
	dw	swallsz,swallsz,0
	dw	-swallsz,swallsz,0
	dw	-swallsz,-swallsz,0

slwallfrz	dw	1
	dw	slwallwrz

stepsz	equ	swallsz/8	; very small

stepplz	dw	4
	dw	lwallclr
	dw	-stepsz,-stepsz,0
	dw	stepsz,-stepsz,0
	dw	stepsz,stepsz,0
	dw	-stepsz,stepsz,0

stepwrz	dw	4
	dw	lwallclr
	dw	-stepsz,-stepsz,0
	dw	stepsz,-stepsz,0
	dw	stepsz,stepsz,0
	dw	-stepsz,stepsz,0
	dw	-stepsz,-stepsz,0

stepfrz	dw	1
	dw	stepwrz


stepwrz1	dw	1
	dw	lwallclr
	dw	-stepsz,-stepsz,0
	dw	stepsz,stepsz,0

stepwrz2	dw	1
	dw	lwallclr
	dw	stepsz,-stepsz,0
	dw	-stepsz,stepsz,0

stepfrz1	dw	3
	dw	stepwrz
	dw	stepwrz1
	dw	stepwrz2


slwyobj	dw	0,0,0
	dw	1
	dw	8 dup(2,slwallfry)
slwxobj	dw	0,0,0
	dw	1
	dw	8 dup(2,slwallfrx)
slwzobj	dw	0,0,0
	dw	1
	dw	8 dup(2,slwallfrz)

slwyobj1	dw	0,0,0
	dw	1
	dw	8 dup(2,slwallfry1)
slwxobj1	dw	0,0,0
	dw	1
	dw	8 dup(2,slwallfrx1)
slwzobj1	dw	0,0,0
	dw	1
	dw	8 dup(2,slwallfrz1)

stepobj	dw	0,0,0
	dw	1
	dw	8 dup(2,stepfrz)
stepobj1	dw	0,0,0
	dw	1
	dw	8 dup(2,stepfrz1)

pstepobj	dw	0,0,0
	dw	1
	dw	8 dup(8,stepplz)

shellsz	equ	1000

clrshell	db	5

treeht	equ	2000
treerad	equ	(treeht*4)
treewid	equ	600
treetht	equ	(treeht)

IF slalom
treeply1	dw	4
	dw	6
	dw	treewid,0,-treeht
	dw	treewid,0,treetht
	dw	-treewid,0,treetht
	dw	-treewid,0,-treeht

treeply2	dw	4
	dw	6
	dw	0,treewid,-treeht
	dw	0,treewid,treetht
	dw	0,-treewid,treetht
	dw	0,-treewid,-treeht

treesph	dw	1
	dw	0,0,treeht+(treerad/2),treerad,10

treewr	dw	1
	dw	6
	dw	0,0,-treeht
	dw	0,0,treetht

treefrm	dw	1
	dw	treewr


shellobj	dw	0,0,0
		dw	3
		dw	8 dup(8,treeply1,8,treeply2,6,treesph)

streeobj	dw	0,0,0
		dw	2
		dw	8 dup(2,treefrm,6,treesph)

sstreeobj	dw	0,0,0
		dw	1
		dw	8 dup(6,treesph)

ELSE

shellsph	dw	1
	dw	0,0,shellsz/2,shellsz,clrshell

shellobj	dw	0,0,0
	dw	1
	dw	8 dup (6,shellsph)
ENDIF




tlsfn	equ	1		; fraction of tail coord of wing coord
tlsfd	equ	2
stlhw	equ	8000/8
stlhns	equ	6000/8
stlhwtf	equ	0
stlhwtr	equ	6000/8
stlhanus	equ	stlhwtr*2/3
stlhtlw	equ	stlhw*tlsfn/tlsfd
stlhtll	equ	(stlhwtr-stlhanus)*tlsfn/tlsfd+stlhanus-stlhns/8
stlhtllt	equ	stlhwtr+stlhwtr*2/3-stlhns/8
stlhdepth	equ	stlhw/10
stlhtlz	equ	stlhdepth-(stlhdepth*2*tlsfn/tlsfd)
stlhtllz	equ	stlhdepth

clstlhr	db	0
clrbmr	db	5

;IF 1 EQ 0
stlhwng1	dw	4
	dw	clstlhr
	dw	-stlhanus,0,stlhdepth
	dw	-stlhwtr,stlhw,-stlhdepth
	dw	stlhwtf,stlhw,-stlhdepth
	dw	stlhns,0,stlhdepth

stlhwng2	dw	4
	dw	clstlhr
	dw	-stlhanus,0,stlhdepth
	dw	-stlhwtr,-stlhw,-stlhdepth
	dw	stlhwtf,-stlhw,-stlhdepth
	dw	stlhns,0,stlhdepth

stlhtl1	dw	3
	dw	clstlhr
	dw	-stlhanus,0,stlhdepth
	dw	-stlhtll,stlhtlw,stlhtlz
	dw	-stlhtllt,0,-stlhtllz

stlhtl2	dw	3
	dw	clstlhr
	dw	-stlhanus,0,stlhdepth
	dw	-stlhtll,-stlhtlw,stlhtlz
	dw	-stlhtllt,0,-stlhtllz

stlhtl3	dw	3
	dw	clstlhr
	dw	-stlhanus,0,stlhdepth
	dw	-stlhtllt,0,-stlhtllz
	dw	stlhns,0,stlhdepth

stlhsph	dw	1
	dw	0,0,0,stlhns/2,clstlhr

stlhobj	dw	0,0,0
	dw	5
	dw	8,stlhwng1,8,stlhwng2,8,stlhtl1,8,stlhtl2,8,stlhtl3
	dw	8,stlhwng1,8,stlhwng2,8,stlhtl1,8,stlhtl2,8,stlhtl3
	dw	8,stlhwng1,8,stlhwng2,8,stlhtl1,8,stlhtl2,8,stlhtl3
	dw	8,stlhwng1,8,stlhwng2,8,stlhtl1,8,stlhtl2,8,stlhtl3
	dw	8,stlhwng1,8,stlhwng2,8,stlhtl1,8,stlhtl2,8,stlhtl3
	dw	8,stlhwng1,8,stlhwng2,8,stlhtl1,8,stlhtl2,8,stlhtl3
	dw	8,stlhwng1,8,stlhwng2,8,stlhtl1,8,stlhtl2,8,stlhtl3
	dw	8,stlhwng1,8,stlhwng2,8,stlhtl1,8,stlhtl2,8,stlhtl3

;ENDIF


fsr	equ	4000

rs15	equ	1035
rc15	equ	3863
rs45	equ	2828
rc45	equ	2828
fstoph	equ	fsr/5
fstophe	equ	fsr/9
fstopsh	equ	fstoph*2

clrfs1	db	0
clrfs2	db	15
clrfss1	db	0
clrfss2	db	15
clrlsph	db	12

bplyfs1	dw	5
	dw	clrfs1
	dw	rc45,rs45,-fstophe
	dw	rs15,rc15,-fstophe
	dw	-rs15,rc15,-fstophe
	dw	-rc45,rs45,-fstophe
	dw	0,0,-fstoph



bplyfs2	dw	5
	dw	clrfs2
	dw	-rc45,rs45,-fstophe
	dw	-rc15,rs15,-fstophe
	dw	-rc15,-rs15,-fstophe
	dw	-rc45,-rs45,-fstophe
	dw	0,0,-fstoph

bplyfs3	dw	5
	dw	clrfs1
	dw	-rc45,-rs45,-fstophe
	dw	-rs15,-rc15,-fstophe
	dw	rs15,-rc15,-fstophe
	dw	rc45,-rs45,-fstophe
	dw	0,0,-fstoph

bplyfs4	dw	5
	dw	clrfs2
	dw	rc45,-rs45,-fstophe
	dw	rc15,-rs15,-fstophe
	dw	rc15,rs15,-fstophe
	dw	rc45,rs45,-fstophe
	dw	0,0,-fstoph


plyfs1	dw	5
	dw	clrfs1
	dw	rc45,rs45,fstophe
	dw	rs15,rc15,fstophe
	dw	-rs15,rc15,fstophe
	dw	-rc45,rs45,fstophe
	dw	0,0,fstoph


plyfs2	dw	5
	dw	clrfs2
	dw	-rc45,rs45,fstophe
	dw	-rc15,rs15,fstophe
	dw	-rc15,-rs15,fstophe
	dw	-rc45,-rs45,fstophe
	dw	0,0,fstoph

plyfs3	dw	5
	dw	clrfs1
	dw	-rc45,-rs45,fstophe
	dw	-rs15,-rc15,fstophe
	dw	rs15,-rc15,fstophe
	dw	rc45,-rs45,fstophe
	dw	0,0,fstoph

plyfs4	dw	5
	dw	clrfs2
	dw	rc45,-rs45,fstophe
	dw	rc15,-rs15,fstophe
	dw	rc15,rs15,fstophe
	dw	rc45,rs45,fstophe
	dw	0,0,fstoph

plyfss1	dw	4
	dw	clrfss1
	dw	rc45,rs45,fstophe
	dw	rc45,rs45,-fstophe
	dw	-rc45,rs45,-fstophe
	dw	-rc45,rs45,fstophe

plyfss2	dw	4
	dw	clrfss2
	dw	-rc45,rs45,fstophe
	dw	-rc45,rs45,-fstophe
	dw	-rc45,-rs45,-fstophe
	dw	-rc45,-rs45,fstophe

plyfss3	dw	4
	dw	clrfss1
	dw	-rc45,-rs45,fstophe
	dw	-rc45,-rs45,-fstophe
	dw	rc45,-rs45,-fstophe
	dw	rc45,-rs45,fstophe

plyfss4	dw	4
	dw	clrfss2
	dw	rc45,-rs45,fstophe
	dw	rc45,-rs45,-fstophe
	dw	rc45,rs45,-fstophe
	dw	rc45,rs45,fstophe

bmrstwr1	dw	1
	dw	0			; black
	dw	rc45,-rs45,-fstophe
	dw	-rc45,rs45,-fstophe

bmrstwr2	dw	1
	dw	0			; black
	dw	-rc45,-rs45,-fstophe
	dw	rc45,rs45,-fstophe

bmrstfr	dw	2
	dw	bmrstwr1
	dw	bmrstwr2

sphfs1	dw	1
	dw	0,0,fstopsh
fsph1sz	dw	fsr/3,clrbmr

sphfs2	dw	1
	dw	0,0,-fstopsh
fsph2sz	dw	fsr/3,clrlsph


IF slalom
include	farm.inc
ELSE
bmrobj	dw	0,0,0
	dw	14

	dw	6,sphfs1,8,plyfs4,8,plyfs3,8,plyfs1,8,plyfs2
	dw	8,plyfss4,8,plyfss3,8,plyfss1,8,plyfss2
	dw	8,bplyfs4,8,bplyfs3,8,bplyfs1,8,bplyfs2,6,sphfs2

	dw	6,sphfs2,8,bplyfs4,8,bplyfs3,8,bplyfs1,8,bplyfs2
	dw	8,plyfss4,8,plyfss3,8,plyfss1,8,plyfss2
	dw	8,plyfs4,8,plyfs3,8,plyfs1,8,plyfs2,6,sphfs1


	dw	6,sphfs1,8,plyfs4,8,plyfs1,8,plyfs3,8,plyfs2
	dw	8,plyfss4,8,plyfss1,8,plyfss3,8,plyfss2
	dw	8,bplyfs4,8,bplyfs1,8,bplyfs3,8,bplyfs2,6,sphfs2

	dw	6,sphfs2,8,bplyfs4,8,bplyfs1,8,bplyfs3,8,bplyfs2
	dw	8,plyfss4,8,plyfss1,8,plyfss3,8,plyfss2
	dw	8,plyfs4,8,plyfs1,8,plyfs3,8,plyfs2,6,sphfs1


	dw	6,sphfs1,8,plyfs2,8,plyfs3,8,plyfs1,8,plyfs4
	dw	8,plyfss2,8,plyfss1,8,plyfss3,8,plyfss4
	dw	8,bplyfs2,8,bplyfs3,8,bplyfs1,8,bplyfs4,6,sphfs2

	dw	6,sphfs2,8,bplyfs2,8,bplyfs3,8,bplyfs1,8,bplyfs4
	dw	8,plyfss2,8,plyfss1,8,plyfss3,8,plyfss4
	dw	8,plyfs2,8,plyfs3,8,plyfs1,8,plyfs4,6,sphfs1


	dw	6,sphfs1,8,plyfs2,8,plyfs1,8,plyfs3,8,plyfs4
	dw	8,plyfss2,8,plyfss1,8,plyfss3,8,plyfss4
	dw	8,bplyfs2,8,bplyfs1,8,bplyfs3,8,bplyfs4,6,sphfs2

	dw	6,sphfs2,8,bplyfs2,8,bplyfs1,8,bplyfs3,8,bplyfs4
	dw	8,plyfss2,8,plyfss1,8,plyfss3,8,plyfss4
	dw	8,plyfs2,8,plyfs1,8,plyfs3,8,plyfs4,6,sphfs1
ENDIF

;
;bmrstwr	dw	6
;	dw	clrbmr
;	dw	-bmranus,0,bmrdepth
;	dw	-bmrwtr,-bmrw,-bmrdepth
;	dw	bmrwtf,-bmrw,-bmrdepth
;	dw	bmrns,0,bmrdepth
;	dw	bmrwtf,bmrw,-bmrdepth
;	dw	-bmrwtr,bmrw,-bmrdepth
;	dw	-bmranus,0,bmrdepth
;
;bmrstfrm	dw	1
;	dw	bmrstwr

bmrstobj	dw	0,0,0
	dw	5
	dw	8,plyfss4,8,plyfss3,8,plyfss1,8,plyfss2,2,bmrstfr
	dw	2,bmrstfr,8,plyfss4,8,plyfss3,8,plyfss1,8,plyfss2
	dw	8,plyfss4,8,plyfss1,8,plyfss3,8,plyfss2,2,bmrstfr
	dw	2,bmrstfr,8,plyfss4,8,plyfss1,8,plyfss3,8,plyfss2
	dw	8,plyfss2,8,plyfss1,8,plyfss3,8,plyfss4,2,bmrstfr
	dw	2,bmrstfr,8,plyfss2,8,plyfss1,8,plyfss3,8,plyfss4
	dw	8,plyfss2,8,plyfss1,8,plyfss3,8,plyfss4,2,bmrstfr
	dw	2,bmrstfr,8,plyfss2,8,plyfss1,8,plyfss3,8,plyfss4

msz	equ	40
msz2	equ	msz*2
msz3	equ	msz*3
msz5	equ	msz*5
msz6	equ	msz*6
mszo2	equ	msz/2
mside	equ	3*msz/2
mhead	equ	msz/3

pantscolor	dw	1
shirtcolor	dw	6

mnply1	dw	5
	dw	pantscolor
	dw	0,mside,0
	dw	0,mszo2,0
	dw	0,mszo2,msz2
	dw	0,0,msz3
	dw	0,mside,msz3
mnply2	dw	5
	dw	pantscolor
	dw	0,-mside,0
	dw	0,-mszo2,0
	dw	0,-mszo2,msz2
	dw	0,0,msz3
	dw	0,-mside,msz3
mnply3	dw	4
	dw	shirtcolor
	dw	0,msz5,msz5
	dw	0,-msz5,msz5
	dw	0,-msz5,msz6
	dw	0,msz5,msz6
mnply3a	dw	4
	dw	shirtcolor
	dw	0,mside+msz,msz5
	dw	0,-msz5,msz5
	dw	0,-msz5,msz6
	dw	0,mside+msz,msz6
mnply3b	dw	4
	dw	shirtcolor
	dw	0,mside+msz,msz5
	dw	0,mside+msz,msz5+msz*3/2
	dw	0,mside+msz+msz,msz5+msz*3/2
	dw	0,mside+msz+msz,msz5
mnply3c	dw	4
	dw	7
	dw	0,mside+msz,msz5+msz*3/2
	dw	0,mside+msz+msz,msz5+msz*3/2
	dw	0,mside+msz+msz,msz5+msz*3/2+msz/4
	dw	0,mside+msz,msz5+msz*3/2+msz/4
mnply3d	dw	4
	dw	7
	dw	0,mside+msz+msz-msz/3,msz5+msz*3/2+msz/4
	dw	0,mside+msz+msz/3,msz5+msz*3/2+msz/4
	dw	0,mside+msz+msz/3,msz5+msz*3/2+msz/4+msz/2
	dw	0,mside+msz+msz-msz/3,msz5+msz*3/2+msz/4+msz/2
	

mnply4	dw	4
	dw	shirtcolor
	dw	0,mside,msz3
	dw	0,-mside,msz3
	dw	0,-mside,msz5
	dw	0,mside,msz5

mnply5	dw	3
	dw	4
	dw	0,mside,msz6
	dw	0,mside,msz5
	dw	0,-mside,msz*4
	
mnsph	dw	3
	dw	0,0,msz6+msz/2,msz,7
	dw	0,msz/4,msz6+(msz*2/3),msz/8,1
	dw	0,-msz/4,msz6+(msz*2/3),msz/8,1

mnsph2	dw	2
	dw	0,0,msz3,msz3,4
	dw	0,0,msz3,msz5,12
mlpo2	equ	msz6*2/3
mlpo6	equ	msz6/6
mnply6	dw	8
	dw	4
	dw	0,-mlpo6,-mlpo2+msz3
	dw	0,mlpo6,-mlpo2+msz3
	dw	0,mlpo2,-mlpo6+msz3
	dw	0,mlpo2,mlpo6+msz3
	dw	0,mlpo6,mlpo2+msz3
	dw	0,-mlpo6,mlpo2+msz3
	dw	0,-mlpo2,mlpo6+msz3
	dw	0,-mlpo2,-mlpo6+msz3

mnwr1	dw	1
	dw	0
	dw	0,msz/4,msz6+(msz/4)
	dw	0,-msz/4,msz6+(msz/4)

mnwr2	dw	1
	dw	0
	dw	0,mside,msz3
	dw	0,-mside,msz3

mnfrm	dw	2
	dw	mnwr1
	dw	mnwr2

manobj	dw	0,0,0
	dw	6
	dw	8 dup(8,mnply1,8,mnply2,8,mnply3,8,mnply4,6,mnsph,2,mnfrm)

fmanobj	dw	0,0,0
	dw	9
	rept	8
	dw	8,mnply1,8,mnply2,8,mnply3a,8,mnply3b,8,mnply3c,8,mnply3d
	dw	8,mnply4,6,mnsph,2,mnfrm
	endm

dmanobj	dw	0,0,0
	dw	8
	rept	8
	dw	8,mnply6
	dw	8,mnply1,8,mnply2,8,mnply3,8,mnply4,6,mnsph,2,mnfrm,8,mnply5
	endm

ssmanobj	dw	0,0,0
	dw	1
	dw	8 dup(0,0)	

manvec	dw	0,0,0

shrdsz	equ	1000

shrdclr	dw	0

shardply	dw	3
	dw	shrdclr
	dw	-shrdsz,0,0
	dw	shrdsz/2,-shrdsz/2,0
	dw	shrdsz,shrdsz/2,0
shardwr1	dw	4
	dw	shrdclr
	dw	-shrdsz,0,0
	dw	shrdsz/2,-shrdsz/2,shrdsz/4
	dw	0,shrdsz/4,-shrdsz/3
	dw	shrdsz/5,shrdsz/4,shrdsz/5
	dw	0,0,0

shardfrm1	dw	1
	dw	shardwr1
shardobj2	dw	0,0,0
	dw	1
	dw	8 dup (2,shardfrm1)

shardobj	dw	0,0,0
	dw	1
	dw	8 dup (8,shardply)

incendsph	dw	1
	dw	0,0,0,1000,14		; yellow sphere
	
incendobj	dw	0,0,0
	dw	1
	dw	8 dup(6,incendsph)

IF slalom
crtrsz	equ	16000
ELSE
crtrsz	equ	4000
ENDIF
crtsz2	equ	crtrsz/2
crtsz6	equ	crtrsz/6
crtrclr	db	0

crtrply	dw	8
IF slalom
	dw	1
ELSE
	dw	@dataseg:crtrclr
ENDIF
	dw	-crtsz6,-crtsz2,-5
	dw	crtsz6,-crtsz2,-5
	dw	crtsz2,-crtsz6,-5
	dw	crtsz2,crtsz6,-5
	dw	crtsz6,crtsz2,-5
	dw	-crtsz6,crtsz2,-5
	dw	-crtsz2,crtsz6,-5
	dw	-crtsz2,-crtsz6,-5

crtrobj	dw	0,0,0
	dw	1
	dw	8 dup (8,crtrply)

dbstclr	db	1

dbstsz	equ	800
dbst2	equ	dbstsz/2
dbst86	equ	dbstsz*13/15
dbstwr1	dw	6
	dw	dbstclr
	dw	dbstsz,0,0
	dw	dbst2,dbst86,0
	dw	-dbst2,dbst86,0
	dw	-dbstsz,0,0
	dw	-dbst2,-dbst86,0
	dw	dbst2,-dbst86,0
	dw	dbstsz,0,0
dbstfr1	dw	1
	dw	dbstwr1
dbstobj	dw	0,0,0
	dw	1
	dw	8 dup(2,dbstfr1)
dbstsph	dw	1
	dw	0,0,0,dbstsz,dbstclr
sdbstobj	dw	0,0,0
	dw	1
	dw	8 dup(2,dbstfr1)

survsz	equ	2000
survsz2	equ	survsz/2

survply	dw	4
	dw	0eh
	dw	-survsz2,-survsz2,0
	dw	survsz2,-survsz2,0
	dw	survsz2,survsz2,0
	dw	-survsz2,survsz2,0

survwr1	dw	1
	dw	0
	dw	-survsz2,0,0
	dw	survsz2,0,0

survwr2	dw	1
	dw	0
	dw	0,-survsz2,0
	dw	0,survsz2,0
	
survfrm1	dw	2
	dw	survwr1
	dw	survwr2
survsph	dw	1
	dw	0,0,0,survsz,survclr

survobj	dw	0,0,0
	dw	2
	dw	8 dup (8,survply,2,survfrm1)

ssurvobj	dw	 0,0,0
	dw	1
	dw	8 dup (6,survsph)

survclr	db	0

fenszl	equ	4096
fenszh	equ	fenszl/6
fenszh2	equ	fenszh/2

fenwr1	dw	3
	dw	15
	dw	-fenszl,0,0
	dw	-fenszl,0,fenszh
	dw	fenszl,0,fenszh
	dw	fenszl,0,0

fenwr2	dw	1
	dw	15
	dw	-fenszl,0,fenszh2
	dw	fenszl,0,fenszh2

fenfrm1	dw	2
	dw	fenwr1
	dw	fenwr2
fenfrm2	dw	1
	dw	fenwr1
fenfrm3	dw	1
	dw	fenwr2

fenobj	dw	0,0,0
	dw	1
	dw	8 dup(2,fenfrm1)
sfenobj	dw	0,0,0
	dw	1
	dw	8 dup(2,fenfrm2)
ssfenobj	dw	0,0,0
	dw	1
	dw	8 dup(2,fenfrm3)

fenwr1a	dw	3
	dw	15
	dw	0,-fenszl,0
	dw	0,-fenszl,fenszh
	dw	0,fenszl,fenszh
	dw	0,fenszl,0

fenwr2a	dw	1
	dw	15
	dw	0,-fenszl,fenszh2
	dw	0,fenszl,fenszh2

fenfrm1a	dw	2
	dw	fenwr1a
	dw	fenwr2a
fenfrm2a	dw	1
	dw	fenwr1a
fenfrm3a	dw	1
	dw	fenwr2a

fenobja	dw	0,0,0
	dw	1
	dw	8 dup(2,fenfrm1a)
sfenobja	dw	0,0,0
	dw	1
	dw	8 dup(2,fenfrm2a)
ssfenobja	dw	0,0,0
	dw	1
	dw	8 dup(2,fenfrm3a)

fenwr1b	dw	3
	dw	15
	dw	fenszl,-fenszl,0
	dw	fenszl,-fenszl,fenszh
	dw	-fenszl,fenszl,fenszh
	dw	-fenszl,fenszl,0

fenwr2b	dw	1
	dw	15
	dw	fenszl,-fenszl,fenszh2
	dw	-fenszl,fenszl,fenszh2

fenfrm1b	dw	2
	dw	fenwr1b
	dw	fenwr2b
fenfrm2b	dw	1
	dw	fenwr1b
fenfrm3b	dw	1
	dw	fenwr2b

fenobjb	dw	0,0,0
	dw	1
	dw	8 dup(2,fenfrm1b)
sfenobjb	dw	0,0,0
	dw	1
	dw	8 dup(2,fenfrm2b)
ssfenobjb	dw	0,0,0
	dw	1
	dw	8 dup(2,fenfrm3b)

bbclr	db	0
bbsph	dw	1
	dw	0,0,0,bbsize,bbclr
bbobj	dw	0,0,0
	dw	1
	dw	8 dup (6,bbsph)

mortsz	equ	500

mortclr	db	0

mortsph	dw	4
	dw	0,0,0,mortsz,mortclr
	dw	0,0,mortsz/2,mortsz,mortclr
	dw	0,0,mortsz,mortsz,mortclr
	dw	0,0,mortsz*3/2,mortsz,mortclr

mortwr1	dw	1
	dw	mortclr
	dw	0,0,0
	dw	mortsz*3,0,0

mortwr2	dw	1
	dw	mortclr
	dw	0,0,0
	dw	-3*mortsz,3*mortsz*13/15*2,0

mortwr3	dw	1
	dw	mortclr
	dw	0,0,0
	dw	-3*mortsz,-3*mortsz*13/15*2,0

mortfrm	dw	3
	dw	mortwr1
	dw	mortwr2
	dw	mortwr3

mortobj	dw	0,0,0
	dw	2
	dw	8 dup (2,mortfrm,6,mortsph)


bullets	dw	4000,0		; 32 bit xyz coordinates
	dw	0,0
	dw	4000,0
	dw	0		; yaw, pitch, and roll
	dw	0
	dw	0

	db	-1,0		; distance default, 0=near

	dw	9612,244	; 32-bit distance squared

	dw	1		; object type 0= no-draw
	dw	0		; rotflg, 0= no rotation
	dd	977625289	; breakpoint for near dist squared
	dd	1067541266	; bkpt for med near dist sqrd
	dd	1067541266	; bkpt for med far dist sqrd
	dw	objbsph		; address of near object
	dw	objbsph		; address of med object
	dw	objbpt		; address of far object, usually point
	dw	0,0,0		; velocity for x,y,z
	dw	3200		; time left to party
	dw	0,0,0		; yaw, pitch and roll angular velocities
	dw	0,0		; dispersion, and wind resistance damping
	dw	0		; gravity
	dw	l*15,l*15,l*15	; rectangle of collision
IF cdct EQ 0
	dw	30
ELSE
	dw	@codeseg:bdest	; routine of destruction
ENDIF

IF guns
	rept	22
	dw	4000,0		; 32 bit xyz coordinates
	dw	0,0
	dw	4000,0
	dw	0		; yaw, pitch, and roll
	dw	0
	dw	0

	db	-1,0		; distance default, 0=near

	dw	9612,244	; 32-bit distance squared

	dw	0		; object type 0= no-draw
	dw	0		; rotflg, 0= no rotation
	dd	977625289	; breakpoint for near dist squared
	dd	1067541266	; bkpt for med near dist sqrd
	dd	1067541266	; bkpt for med far dist sqrd
	dw	objbsph		; address of near object
	dw	objbsph		; address of med object
	dw	objbpt		; address of far object, usually point
	dw	0,0,0		; velocity for x,y,z
	dw	3200		; time left to party
	dw	0,0,0		; yaw, pitch and roll angular velocities
	dw	0,0		; dispersion, and wind resistance damping
	dw	0		; gravity
	dw	l*15,l*15,l*15	; rectangle of collision
IF cdct EQ 0
	dw	30
ELSE
	dw	@codeseg:bdest	; routine of destruction
ENDIF
	endm
ENDIF ; guns
bptrmx	dw	0


.ends

.codeseg
;assume	cs:@codeseg,
	assume ds:@dataseg


.proc	changewallobjs	auto
	inc	framecount
	mov	ax,framecount
	mov	cl,12
	shl	ax,cl
	mov	tripvalue+2,ax
	call	scos
	hmul	ax,wallsz2*2/2
	mov	ax,dx
	add	ax,wallsz2*2/2
	jnz	wallszok
	mov	ax,1
wallszok:
	or	ax,ax
	jns	wallszok1
	mov	ax,wallsz2*2
wallszok1:
	mov	dx,ax
	mov	si,offset @dataseg:wallsz22tbl
	mov	cx,nwallsz22
	call	chgwloop
	shl	dx,1			; make collision twice the size
	mov	cx,nwallsz22b
	call	chgwloop

	mov	ax,framecount
	mov	bx,3111
	mul	bx

	call	scos
	mov	tripvalue,ax		; save wavy sin for tripping
	push	ax
	hmul	ax,fsr/12
	mov	ax,dx
	add	ax,fsr/6+fsr/12
	mov	fsph1sz,ax

	mov	ax,dx
	sub	ax,fsr/6+fsr/12
	neg	ax
	mov	fsph2sz,ax
	pop	ax

	hmul	ax,wallsz2/2
	mov	ax,dx
	add	ax,wallsz2/2
	jnz	wallszok2
	mov	ax,1
wallszok2:
	or	ax,ax
	jns	wallszok3
	mov	ax,wallsz2
wallszok3:
	mov	dx,ax
	mov	si,offset @dataseg:wallsz2tbl
	mov	cx,nwallsz2
	call	chgwloop
	shl	dx,1			; make collision twice the size
	mov	cx,nwallsz2b
	call	chgwloop

	mov	ax,framecount
	mov	bx,5333
	mul	bx
	call	scos

	hmul	ax,wallsz/2
	mov	ax,dx
	add	ax,wallsz/2
	jnz	wallszok4
	mov	ax,1
wallszok4:
	or	ax,ax
	jns	wallszok5
	mov	ax,wallsz
wallszok5:
	mov	dx,ax
	mov	si,offset @dataseg:wallsztbl
	mov	cx,nwallsz
	call	chgwloop
	shl	dx,1			; make collision twice the size
	mov	cx,nwallszb
	call	chgwloop
	test	tripflag,1		; are we horizon tripping?
	jnz	notrip3
	jmp	notrip
notrip3:
	mov	ax,haluclrate
	wtadj
	hmul	ax,palmul
	add	haluclrs,dx
	mov	ax,haluclrate+2
	wtadj
	hmul	ax,palmul
	add	haluclrs+2,dx
	mov	ax,haluclrate+4
	wtadj
	hmul	ax,palmul
	add	haluclrs+4,dx

	call	distcolors
notrip:

;	mov	ax,0b02h		; default horizon colors
;	test	tripflag,1		; are we horizon tripping?
;	jz	notrip
;
;	call	rand_w
;	add	ax,0f0fh		; strip off uncool bits
;notrip:
;	mov	clrup,ah
;	mov	clrdn,al

	mov	ax,300
	mov	bx,200
	mov	orbfreq,128
	test	tripflag,2
	jz	notrip2
	mov	ax,tripvalue
	call	ssin
	hmul	ax,tripamount
	mov	ax,300
	mov	bx,tripamount
	shr	bx,1
	sub	dx,bx
	add	ax,dx
	push	ax
	mov	ax,tripvalue+2
	call	ssin
	hmul	ax,tripamount
	push	dx
	mov	ax,128
	imul	dx
	mov	bx,tripamount
	idiv	bx
	mov	orbfreq,ax			; make orb freq differ from 128
	pop	dx
	mov	ax,200
	mov	bx,tripamount
	shr	bx,1
	sub	dx,bx
	add	ax,dx
	mov	bx,ax
	pop	ax
notrip2:
	mov	si,ptrgwinf
	mov	[si+12],ax		; distort things a little
	mov	[si+14],bx		; distort things a little
	ret
.endp

.proc	chgwloop	auto
chlwloop:
	mov	bx,[si]
	mov	ax,[bx]
	or	ax,ax
	js	itsaneg
	mov	[bx],dx
	jmp	itsadone
itsaneg:
	mov	ax,dx
	neg	ax
	mov	[bx],ax
itsadone:	
	add	si,2
	loop	chlwloop
	ret
.endp



.proc	mandest		auto	; kills man
	jnc	nomandie
	test	word ptr [si+24],1000h	; are we already dead?
	jnz	mandestret
	push	di
	mov	ax,[di+72]	; get object type to chech extended table
	add	ax,ax		; make into a word address
	mov	di,offset @dataseg:extendedtypetbl
	add	di,ax
	mov	ax,[di]		; check save bit
	pop	di
	test	ax,8		; is it a forcefield?
	jnz	mandestret	; yes, don't kill guy
	call	fdestcheck
	jnc	nokillguy
	or	word ptr [si+24],1000h	; make into a dead man
	and	word ptr [si+24],NOT 8	; make indestructable
	call	qincfdest		; only count it if a friendly
nokillguy:
mandestret:
	ret

nomandie:
	mov	pantscolor,1	; spy is wearing black
	mov	shirtcolor,6	; spy is wearing black
	test	word ptr [si+24],800h	; check special bit
	jz	notspy
	mov	pantscolor,0	; spy is wearing black
	mov	shirtcolor,0	; spy is wearing black
notspy:
	test	word ptr [si+24],1000h	; look if quality is zero
	jz	mannotdead
	mov	ax,offset @dataseg:dmanobj
	mov	[si+40],ax
	mov	[si+42],ax
	mov	[si+44],ax
	mov	[si+14],16384	; lie man down on the ground
mannotdead:
	mov	[si+52],32000	; never die
	push	si
	call	rel3d
	pop	si		; see how close we are
	jc	mantofar		; too far away
	or	ch,ch			; if cx is zero, then too far
	jnz	mantofar
					; dxvec now holds the magic vector
					; which points away from the plane
	and	cl,0ffh			; now check for still too far
	jnz	mantofar		;
	cmp	ejectflag,0		; if pilot in plane, don't finger
	jz	mantofar
	mov	ax,offset @dataseg:manobj
	cmp	[si+40],ax		; if man is dead, don't finger
	jnz	mantofar
	mov	ax,dxvec
	mov	manvec,ax
	mov	ax,dxvec+4
	mov	manvec+2,ax
	mov	ax,dxvec+8
	mov	manvec+4,ax
	push	si
	mov	si,offset @dataseg:manvec
	call	vmag
	pop	si
	cmp	ax,2000
	ja	mantofar
	mov	ax,offset @dataseg:fmanobj
	mov	[si+40],ax
	mov	[si+42],ax
	mov	[si+44],ax
	test	word ptr [si+24],800h	; check special bit
	jz	notspy1
	call	incondest	; inc # objectives variable
hqok:
notspy1:		; if set, man is spy
;	mov	ax,offset @dataseg:sunobj1
;	mov	objsun+40,ax
mantofar:
	ret
.endp

.proc	bigdest	auto	; destroys object 5d
	jc	bighit			; have we taken a hit?
	jmp	hqtim			; just do some hq type checkout
bighit:
	cmp	di,-1		; has the plane hit?
	jz	bdestroyp	; then kill pilot if kill me tough
	mov	ax,[si+24]	; check quality for killmetough
	and	ah,70h
	cmp	ah,40h		; quality 5 is killme tough
	jz	bnodamage	; no shards even for killme tough
	mov	bl,1
	test	byte ptr [di+24],40h		; get other object type
	jz	bminorhit1
	mov	bl,6
bminorhit1:
	test	byte ptr [di+24],80h		; get other object type
	jz	bminorhit2
	mov	bl,25
bminorhit2:
	mov	al,[si+27]		; get number of hits left
	sub	al,bl
	jz	bdestroy		; destroy object, this guy gets it!
	js	bdestroy
	mov	[si+27],al		; leave number of hits decrmented
	cmp	bl,6
	jb	bnodamage		; if single hit, don't let fly
	push	di
	push	si
	mov	bx,2				; twelve destruction pieces
	mov	omniflag,0			; omni-directional explosion
	call	strtshard
	pop	si
	pop	di
bnodamage:
	ret
bdestroyp:
	mov	ax,[si+24]	; get orb type
	and	ax,7000h
	cmp	ah,40h		; is it quality 5?
	jnz	bdestroy
	cmp	ejectflag,0	; only kill if not ejected
	jnz	bdestroy
	mov	crshflg,11	; fatal crash with building
	or	missionstatus,1000h	; set a bit in status
bdestroy:
	push	di
	mov	byte ptr [si+27],0		; clear hits, so can't go neg

	mov	ax,offset @dataseg:dhqobj
	mov	[si+40],ax
	mov	ax,offset @dataseg:dhqobj
	mov	ax,offset @dataseg:dhqobj
	mov	[si+42],ax
	mov	[si+44],ax
;	mov	word ptr [si+24],11h		; make object non-destructable

	mov	ax,[si+24]			
	and	ax,0ff00h
	or	ax,11h
	mov	[si+24],ax			; do it without changing rest of
						; bits
	mov	word ptr [si+72],43		; make into wreckage
	inc	ondest				; increment # destroyed count
	push	si
	mov	bx,12				; twelve destruction pieces
	mov	omniflag,0			; omni-directional explosion
	call	strtflt				; start a piece of flotsom
	pop	si
	push	si
	mov	bx,10				; twelve destruction pieces
	mov	omniflag,0			; omni-directional explosion
	call	strtshard
	call	bigboom			; big destructive noise
	pop	si
	pop	di
;	inc	nhqsdest
	push	si
	push	di
	mov	di,offset @dataseg:hqtbl	; point to dball qual table
	call	getqtblptr
	xor	bh,bh				; bl has quality
	add	bx,bx				; make word address
	inc	word ptr [bx+offset @dataseg:norbsdest]
	pop	di
	pop	si
bigret:	ret
.endp

.proc	fdestrdr	auto
	pushf
	mov	ax,cs:oticks
	shl	ax,1
	shl	ax,1
	mov	[si+12],ax	; rotate the radar
	popf
	jmp	fdest
.endp

.proc	qincfdest	auto
	cmp	di,-1			; was it the plane?
	jz	incnfdest
	cmp	byte ptr [di+19],0	; was it one of our ammo items?
	jnz	noincnfdest
	cmp	byte ptr [di+72],30
	jz	incnfdest
	cmp	byte ptr [di+72],21
	jz	incnfdest
	cmp	word ptr [di+72],20
	jnz	noincnfdest		; if not a bomb, death occurs
	test	word ptr [di+24],2	; was bomb dropped from a saucer?
	jnz	noincnfdest
incnfdest:
	inc	nfdest				; increment # destroyed count
noincnfdest:
	ret
.endp

.proc	fdestcheck	auto
	cmp	di,-1				; has the plane hit?
	jz	fdestroy

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
	clc
	ret
fdestroy:
	stc
	ret
.endp

.proc	fdest	auto	; destroys object 5d
	jc	frndhit			; have we taken a hit?
	inc	word ptr [si+52]		; check our time on earth
	ret			; and return having done nothing
frndhit:
	call	fdestcheck
	jc	fdestroy1
	ret	

fdestroy1:
	push	di
	call	qincfdest
	mov	byte ptr [si+27],0		; clear hits, so can't go neg
	mov	[si+8],xgmx
	mov	word ptr [si+10],0
	call	rand_w
	mov	[si+12],ax			; random yaw angle
	mov	ax,offset @dataseg:wrkobj
	mov	[si+40],ax
	mov	ax,offset @dataseg:swrkobj
	mov	ax,offset @dataseg:swrkobj
	mov	[si+42],ax
	mov	[si+44],ax
	mov	word ptr [si+24],11h		; make object non-destructable
	mov	word ptr [si+72],33		; make into a smoking thing
	push	si
	mov	bx,12				; twelve destruction pieces
	mov	omniflag,0			; omni-directional explosion
	call	strtflt				; start a piece of flotsom
	pop	si
	push	si
	mov	bx,5				; twelve destruction pieces
	mov	omniflag,0			; omni-directional explosion
	call	strtshard
	pop	si
	pop	di
gmret:	ret
.endp

.proc	gmdest	auto	; destroys object 5d
	jc	gmhit			; have we taken a hit?
	inc	word ptr [si+52]		; check our time on earth
	inc	curnticks
	ret			; and return having done nothing
gmhit:
	mov	bl,1
	test	byte ptr [di+24],40h		; get other object type
	jz	gminorhit1
	mov	bl,6
gminorhit1:
	test	byte ptr [di+24],80h		; get other object type
	jz	gminorhit2
	mov	bl,25
gminorhit2:
	mov	al,[si+27]		; get number of hits left
	sub	al,bl
	jz	gfdestroy		; destroy object, this guy gets it!
	js	gfdestroy
	mov	[si+27],al		; leave number of hits decrmented
	ret
gfdestroy:
	push	di
	mov	byte ptr [si+27],0	; turn off hits, dont' allow neg
	mov	ax,offset @dataseg:gmobj2
	mov	[si+40],ax
	mov	ax,offset @dataseg:gmobj3
	mov	ax,offset @dataseg:gmobj3
	mov	[si+42],ax
	mov	[si+44],ax
	mov	word ptr [si+24],11h		; make object non-destructable
	mov	word ptr [si+72],33		; make into a smoking thing
	inc	ndest				; increment # destroyed count
	push	si
	mov	bx,12				; twelve destruction pieces
	mov	omniflag,0			; omni-directional explosion
	call	strtflt				; start a piece of flotsom
	call	bigboom
	pop	si
	pop	di
	ret
.endp

.proc	odest	auto	; destroys object 5d
	jc	realodest
	mov	[si+52],32000

	cmp	si,offset @dataseg:obj5d
	jz	isreal5d
	mov	word ptr [si+72],2	; make into an obj5da
	clc				; do not destroy
	jmp	obj5datim
isreal5d:
	mov	wingclr,1
	test	[si+24],1000h
	jz	nodumpy1			; test for ok or dumpy plane
	mov	wingclr,6		; brown wings for dumpy plane
nodumpy1:
	test	[si+24],2000h		 ; test for bomber
	jz	notbomber
	mov	ax,offset @dataseg:stlhobj
	mov	word ptr [si+40],ax	; change appearance
	mov	word ptr [si+42],ax
notbomber:
	ret
realodest:
	push	di
	push	si
	mov	word ptr [si+24],1		; make object non-destructable
	xor	ax,ax
	mov	[si+10],ax	
	mov	[si+46],ax			; clear height and velocity
	mov	[si+48],ax			; clear height and velocity
	mov	[si+50],ax			; clear height and velocity
	mov	word ptr [si+8],100
	mov	omniflag,0
	mov	bx,15
	push	si
	call	strtflt
	pop	si
	mov	bx,15
	call	strtshard
	pop	si
	xor	ax,ax
	mov	word ptr [si+8],ax
	mov	word ptr [si+10],ax
	pop	di
	mov	freezeflag,-1
	mov	rpm,20
;	inc	nplaneslost
;	mov	fateofplane,-1
	push	si
	push	di
	stc				; mark plane as destroyed
	call	funeral5d		; replace 5d with a 5da
	call	bigboom			; plane crash
	pop	di
	pop	si
	ret
.endp

.proc	donothing	auto	; timed object routine for a non-destructable
				; permanent object
	mov	[si+52],32000	; don't let run down
	ret			; just quit, even if destruction requested
.endp

.proc	roadtim	auto	; timed object routine for a non-destructable
				; permanent object
	mov	[si+52],32000	; don't let run down
	mov	ax,[si+24]	; get type
	and	ax,7000h
	jz	normroad
	mov	ax,offset @dataseg:paveobj
	mov	[si+40],ax
	mov	[si+42],ax
	mov	ax,offset @dataseg:sroadobj	; address of med object
	mov	[si+44],ax
normroad:
	ret			; just quit, even if destruction requested
.endp

.proc	doradar	auto
	jnc	noradardie
	jmp	fdest
noradardie:
	mov	[si+52],32000	; don't let run down
;	mov	ax,cs:oticks
;	shl	ax,1
;	shl	ax,1
;	mov	objrdr+12,ax	; rotate the radar
	ret
.endp

.proc	adjustxy	auto		; moves start positions of these
					; things to the lower left corner

;	sub	word ptr [si+2],64		; mov back to lower row
;	add	word ptr [si+6],64		; mov to left side
	ret
.endp

.proc	initperms	auto

	inc	nplaced			; put planes behind us
	mov	si,offset @dataseg:kbuf	; just use any old buffer
	mov	di,si
	push	ds
	pop	es
	mov	cx,74
	xor	ax,ax		; clear kbuf
	rep	stosw
	mov	cx,10
	xor	ax,ax		; make up starting point for roadpieces
	mov	word ptr [si+4],-w*4
	mov	word ptr [si+6],-1
	mov	[si+8],ax
	mov	[si+10],ax
	mov	word ptr [si],-1
	mov	word ptr [si+2],roadx
	mov	initialqual,0		; set quality to def value of zero
	call	adjustxy
	mov	si,offset @dataseg:kbuf
	push	si
	push	cx
	mov	di,offset @dataseg:objroadend
	mov	initialqual,0
	call	strtperm
	pop	cx
	pop	si
	add	word ptr [si],32768		; advance position
	adc	word ptr [si+2],-1
rdpilp:	
	mov	si,offset @dataseg:kbuf
	push	si
	push	cx
	mov	di,offset @dataseg:roadpiece
	mov	initialqual,0
	call	strtperm
	pop	cx
	pop	si
	add	word ptr [si],32768		; advance position
	adc	word ptr [si+2],-1
	loop	rdpilp

	mov	si,offset @dataseg:kbuf
	push	si
	push	cx
	mov	di,offset @dataseg:objroadend1
	mov	initialqual,0
	call	strtperm
	pop	cx
	pop	si
	mov	ax,startcoords
	mov	dx,startcoords+2
	sub	ax,12000
	sbb	dx,0
	mov	[si],ax
	mov	[si+2],dx
	xor	ax,ax
	mov	[si+4],ax
	mov	[si+6],ax
	mov	initialqual,7		; make a non-striped roadpiece
	mov	di,offset @dataseg:roadpiece
	call	strtperm


	cmp	actionflag,0
	jz	skipenem2
	jmp	skipenem1
skipenem2:

	mov	cx,ngmo
gmilp:	mov	si,offset @dataseg:dxvec
	call	grand
	mov	[si],ax
	mov	[si+2],dx
	call	grand
	mov	[si+4],ax
	mov	[si+6],dx
	xor	ax,ax
	mov	[si+10],ax
	mov	[si+8],xgmx2
	push	si
	push	cx
	mov	di,offset @dataseg:gms
	mov	initialqual,0
	call	adjustxy
	call	strtperm
	pop	cx
	pop	si
	loop	gmilp

	mov	cx,naas
	or	cx,cx
	jnz	aap
	jmp	nostrtaa
aap:	
	mov	ax,qualaa
	or	ax,ax
	jns	aaqok
	call	rand_w
	and	ax,7
aaqok:
	mov	initialqual,ax
	push	cx
	mov	si,offset @dataseg:dxvec		; point to xyz 
						; coordinate passing area
	call	grand
	mov	[si],ax
	mov	[si+2],dx
	call	grand
	mov	[si+4],ax
	mov	[si+6],dx
	mov	ax,2*dbsz
	xor	dx,dx		; lift it off the ground by some amount
	mov	[si+8],ax	; 
	mov	[si+10],dx
	call	adjustxy
	call	strtaa	; add dball to exp data area
	pop	cx
	loop	aap		; go get the next one
nostrtaa:

	mov	ax,ds
	mov	es,ax
	cld
	mov	cx,6
	mov	si,offset @dataseg:ox
	mov	di,offset @dataseg:dxvec
	rep	movsw
	mov	si,offset @dataseg:dxvec
	add	word ptr [si+6],-5
	add	word ptr [si+2],2
;	call	strtvest

	mov	cx,nvest
	mov	maxnvechs,cx
	or	cx,cx
	jnz	vechlp
	jmp	nostrtvest
vechlp:	
	mov	ax,qualvest
	or	ax,ax
	jns	vestqok
	call	rand_w
	and	ax,7
vestqok:
	mov	initialqual,ax
	push	cx
	mov	si,offset @dataseg:dxvec		; point to xyz 
						; coordinate passing area
	call	grand
	mov	[si],ax
	mov	[si+2],dx
	call	grand
	mov	[si+4],ax
	mov	[si+6],dx
	mov	ax,2*dbsz
	xor	dx,dx		; lift it off the ground by some amount
	mov	[si+8],ax	; 
	mov	[si+10],dx
	call	adjustxy
	call	strtvest	; add dball to exp data area
	pop	cx
	loop	vechlp		; go get the next one

nostrtvest:
	mov	cx,ndbst
	mov	maxndballs,cx	; set #dballs to the number of sites
	or	cx,cx
	jnz	dballp
	jmp	nostrtdbst
dballp:	
	mov	ax,qualdbst
	or	ax,ax
	jns	dbstqok
	call	rand_w
	and	ax,7
dbstqok:
	mov	initialqual,ax	; set quality
	push	cx
	mov	si,offset @dataseg:dxvec		; point to xyz 
						; coordinate passing area
	call	grand
	mov	[si],ax
	mov	[si+2],dx
	call	grand
	mov	[si+4],ax
	mov	[si+6],dx
	mov	ax,2*dbsz
	xor	dx,dx		; lift it off the ground by some amount
	mov	[si+8],ax	; 
	mov	[si+10],dx
	call	adjustxy
	call	strtdbst	; add dball to exp data area
	pop	cx
	loop	dballp		; go get the next one
nostrtdbst:

	mov	initialqual,4	; set quality
	mov	di,offset @dataseg:objwallx
	mov	si,offset @dataseg:kbuf
	mov	word ptr [si],wallsz*2
	mov	word ptr [si+2],0
	mov	word ptr [si+4],0
	mov	word ptr [si+6],0
	mov	word ptr [si+8],wallsz
	mov	word ptr [si+10],0
	mov	word ptr [si+12],0
	mov	word ptr [si+14],0
	mov	word ptr [si+16],0
	call	adjustxy
	call	strtperm

	mov	initialqual,4	; set quality
	mov	di,offset @dataseg:objwallx
	mov	si,offset @dataseg:kbuf
	mov	word ptr [si],-wallsz*2
	mov	word ptr [si+2],-1
	mov	word ptr [si+8],wallsz
	call	adjustxy
	call	strtperm

	mov	di,offset @dataseg:objwallz
	mov	si,offset @dataseg:kbuf
	mov	word ptr [si],0
	mov	word ptr [si+2],0
	mov	word ptr [si+8],2*wallsz
	call	adjustxy
	call	strtperm

IF saucey
	mov	di,offset @dataseg:objwally
	mov	si,offset @dataseg:kbuf
	mov	word ptr [si],0
	mov	word ptr [si+2],0
	mov	word ptr [si+4],0
	mov	word ptr [si+6],2
	mov	word ptr [si+8],2*wallsz
	mov	word ptr [si+10],0
	mov	word ptr [si+12],0
	mov	word ptr [si+14],0
	mov	word ptr [si+16],0
	call	adjustxy
	call	strtperm

	mov	ax,1				; default quality for hq
	mov	initialqual,ax	; set quality
	mov	di,offset @dataseg:objhq
	mov	si,offset @dataseg:kbuf
	mov	word ptr [si],0
	mov	word ptr [si+2],0
	mov	word ptr [si+4],0
	mov	word ptr [si+6],0
	mov	word ptr [si+8],lhq*4
	mov	word ptr [si+10],0
	mov	word ptr [si+12],0
	mov	word ptr [si+14],0
	mov	word ptr [si+16],0
	call	adjustxy
	call	strtperm

	mov	ax,qualdbst
	or	ax,ax
	jns	dbmrstqok
	call	rand_w
	and	ax,7
dbmrstqok:
	mov	initialqual,ax	; set quality
	mov	di,offset @dataseg:objbmrmo
	mov	si,offset @dataseg:kbuf
	mov	word ptr [si],0
	mov	word ptr [si+2],0
	mov	word ptr [si+4],0
	mov	word ptr [si+6],0
	mov	word ptr [si+8],32000
	mov	word ptr [si+10],2
	mov	word ptr [si+12],0
	mov	word ptr [si+14],0
	mov	word ptr [si+16],0
	call	adjustxy
	call	strtperm
ELSE ; saucey
	xor	ax,ax
	mov	initialqual,ax	; set quality
	mov	di,offset @dataseg:objbmrst
	mov	si,offset @dataseg:kbuf
	mov	word ptr [si],0
	mov	word ptr [si+2],-6
	mov	word ptr [si+4],32000
	mov	word ptr [si+6],1
	mov	word ptr [si+8],0
	mov	word ptr [si+10],2
	mov	word ptr [si+12],0
	mov	word ptr [si+14],0
	mov	word ptr [si+16],0
	call	adjustxy
	call	strtperm
	mov	word ptr [si],10000
	mov	word ptr [si+2],-6
	mov	word ptr [si+4],22000
	mov	di,offset @dataseg:objbmrst
	mov	si,offset @dataseg:kbuf
	call	adjustxy
	call	strtperm
	mov	word ptr [si+4],42000
	mov	di,offset @dataseg:objbmrst
	mov	si,offset @dataseg:kbuf
	call	adjustxy
	call	strtperm

	xor	ax,ax
	mov	initialqual,ax	; set quality
	mov	di,offset @dataseg:crtr
	mov	si,offset @dataseg:kbuf
	mov	word ptr [si],0
	mov	word ptr [si+2],3
	mov	word ptr [si+4],32000
	mov	word ptr [si+6],2
	mov	word ptr [si+8],0
	mov	word ptr [si+10],0
	mov	word ptr [si+12],0
	mov	word ptr [si+14],0
	mov	word ptr [si+16],0
	call	adjustxy
	call	strtperm

	mov	cx,50
trloop:	
	mov	initialqual,ax	; set quality
	push	cx
	mov	si,offset @dataseg:kbuf		; point to xyz 
						; coordinate passing area
	call	grand
	mov	[si],ax
	mov	[si+2],dx
	call	grand
	mov	[si+4],ax
	mov	[si+6],dx
	mov	ax,2*dbsz
	mov	word ptr [si+8],treeht
	mov	word ptr [si+10],0
	mov	di,offset @dataseg:objshell
	call	adjustxy
	call	strtperm
	pop	cx
	loop	trloop		; go get the next one

	xor	ax,ax
	mov	initialqual,ax	; set quality
	mov	di,offset @dataseg:objbmr
	mov	si,offset @dataseg:kbuf
	mov	word ptr [si],0
	mov	word ptr [si+2],0
	mov	word ptr [si+4],-1
	mov	word ptr [si+6],-2
	mov	word ptr [si+8],frmzl
	mov	word ptr [si+10],0
	mov	word ptr [si+12],0
	mov	word ptr [si+14],0
	mov	word ptr [si+16],0
	call	adjustxy
	call	strtperm

	mov	bx,0
	mov	dx,tetht
	mov	cx,2
rmfloop:
	push	cx

	mov	ax,0
	mov	cx,6
obtloop:
	push	cx
	mov	di,offset @dataseg:objtet
	mov	si,offset @dataseg:kbuf
	mov	word ptr [si],0
	mov	word ptr [si+2],ax
	add	ax,2
	mov	word ptr [si+4],0
	mov	word ptr [si+6],2
	mov	word ptr [si+8],dx
	mov	word ptr [si+10],bx
	mov	word ptr [si+12],0
	mov	word ptr [si+14],0
	mov	word ptr [si+16],0
	push	dx
	push	bx
	push	ax
	call	adjustxy
	call	strtperm
	pop	ax
	pop	bx
	pop	dx
	pop	cx
	loop	obtloop
	add	dx,tetht+tetht
	adc	bx,0
	pop	cx
	loop	rmfloop
ENDIF ;saucey
skipenem1:

	mov	initialqual,0	
	mov	di,offset @dataseg:obj5da
	mov	si,offset @dataseg:kbuf
	mov	word ptr [si],8000
	mov	word ptr [si+2],roadx-1
	mov	word ptr [si+4],8000
	mov	word ptr [si+6],0
	mov	ax,hmin
	mov	word ptr [si+8],ax
	mov	word ptr [si+10],0
	mov	word ptr [si+12],-8192
	mov	word ptr [si+14],epitchmin
	mov	word ptr [si+16],0
	call	adjustxy
	call	strtperm


	mov	di,offset @dataseg:objtw
	mov	si,offset @dataseg:kbuf
	mov	word ptr [si],-1
	mov	word ptr [si+2],roadx
	mov	word ptr [si+4],16000
	mov	word ptr [si+6],0
	mov	word ptr [si+8],ltw*4
	mov	word ptr [si+10],0
	mov	word ptr [si+12],0
	mov	word ptr [si+14],0
	mov	word ptr [si+16],0
	call	adjustxy
	call	strtperm

	mov	di,offset @dataseg:objrdr
	mov	si,offset @dataseg:kbuf
	mov	word ptr [si],-1
	mov	word ptr [si+2],roadx
	mov	word ptr [si+4],16000
	mov	word ptr [si+6],0
	mov	word ptr [si+8],ltw*4
	mov	word ptr [si+10],0
	mov	word ptr [si+12],0
	mov	word ptr [si+14],0
	mov	word ptr [si+16],0
	call	adjustxy
	call	strtperm

	mov	di,offset @dataseg:objman
	mov	si,offset @dataseg:kbuf
	mov	word ptr [si],-1
	mov	word ptr [si+2],roadx
	mov	word ptr [si+4],22000
	mov	word ptr [si+6],0
	mov	word ptr [si+8],0
	mov	word ptr [si+10],0
	mov	word ptr [si+12],0
	mov	word ptr [si+14],0
	mov	word ptr [si+16],0
	call	adjustxy
	call	strtperm

	mov	di,offset @dataseg:objhut
	mov	si,offset @dataseg:kbuf
	mov	word ptr [si],-1
	mov	word ptr [si+2],roadx-2
	mov	word ptr [si+4],16000-(twsz*2)
	mov	word ptr [si+6],0
	mov	word ptr [si+8],0
	mov	word ptr [si+10],0
	mov	word ptr [si+12],0
	mov	word ptr [si+14],0
	mov	word ptr [si+16],0
	call	adjustxy
	call	strtperm

	mov	di,offset @dataseg:tower
	mov	si,offset @dataseg:kbuf
	mov	word ptr [si],-1
	mov	word ptr [si+2],roadx-2
	mov	word ptr [si+4],16000
	mov	word ptr [si+6],0
	mov	word ptr [si+8],twszl*2
	mov	word ptr [si+10],0
	mov	word ptr [si+12],0
	mov	word ptr [si+14],0
	mov	word ptr [si+16],0
	call	adjustxy
	call	strtperm

	mov	di,offset @dataseg:objsurv
	mov	si,offset @dataseg:kbuf
	mov	word ptr [si],0
	mov	word ptr [si+2],0
	mov	word ptr [si+4],0
	mov	word ptr [si+6],0
	mov	word ptr [si+8],0
	mov	word ptr [si+10],0
	mov	word ptr [si+12],0
	mov	word ptr [si+14],0
	mov	word ptr [si+16],0
	call	adjustxy
	call	strtperm

	mov	di,offset @dataseg:objsurv
	mov	si,offset @dataseg:kbuf
	mov	word ptr [si],0
	mov	word ptr [si+2],0
	mov	word ptr [si+4],0
	mov	word ptr [si+6],0
	mov	word ptr [si+8],0
	mov	word ptr [si+10],0
	mov	word ptr [si+12],0
	mov	word ptr [si+14],0
	mov	word ptr [si+16],0
	call	adjustxy
	call	strtperm

	mov	di,offset @dataseg:objsurv
	mov	si,offset @dataseg:kbuf
	mov	word ptr [si],0
	mov	word ptr [si+2],-32
	mov	word ptr [si+4],0
	mov	word ptr [si+6],-32
	mov	word ptr [si+8],0
	mov	word ptr [si+10],0
	mov	word ptr [si+12],0
	mov	word ptr [si+14],0
	mov	word ptr [si+16],0
	call	adjustxy
	call	strtperm

	mov	di,offset @dataseg:objsurv
	mov	si,offset @dataseg:kbuf
	mov	word ptr [si],0
	mov	word ptr [si+2],0
	mov	word ptr [si+4],0
	mov	word ptr [si+6],-32
	mov	word ptr [si+8],0
	mov	word ptr [si+10],0
	mov	word ptr [si+12],0
	mov	word ptr [si+14],0
	mov	word ptr [si+16],0
	call	adjustxy
	call	strtperm

	mov	di,offset @dataseg:objsurv
	mov	si,offset @dataseg:kbuf
	mov	word ptr [si],0
	mov	word ptr [si+2],-32
	mov	word ptr [si+4],0
	mov	word ptr [si+6],0
	mov	word ptr [si+8],0
	mov	word ptr [si+10],0
	mov	word ptr [si+12],0
	mov	word ptr [si+14],0
	mov	word ptr [si+16],0
	call	adjustxy
	call	strtperm
	ret
.endp

.proc	funeral5d	auto		; takes out object 5d, and
					; starts a nice object 5da
	pushf				; save the carry state till later
	mov	obj5d+24,0		; have object 5d removed from table
	mov	si,offset @dataseg:obj5d
	mov	di,offset @dataseg:kbuf
	mov	cx,9
	mov	ax,ds
	mov	es,ax
	cld
	rep	movsw			; transfer all angles and stuff
					; to obj5da
	xor	ax,ax
	mov	di,offset @dataseg:obj5da
	mov	[di+46],ax
	mov	[di+48],ax
	mov	[di+50],ax		; put velocity to zero
	mov	si,offset @dataseg:kbuf
	call	adjustxy
	mov	initialqual,0		; default is nice plane!
	call	strtperm
	mov	si,expobj		; get pointer to object just created
;	mov	word ptr [si+66],0		; make us uncollidable
;	and	word ptr [si+24],NOT 8		; make us indestructable
	mov	ax,obj5dbits		; get crashed and home bits from obj5d
	or	[si+24],ax
	or	byte ptr [si+65],10h	; mark plane as being fiddled with
	popf				; is plane wrecked?
	jnc	planeok
	or	word ptr [si+24],100h		; make into a damn wall
	and	word ptr [si+24],NOT 8		; make us indestructable
planeok:
;		cmp	groundflag,0		; are we wheeling about?
;	jnz	planeongrnd
;	mov	ax,obj5d+10
;	cmp	ax,1
;	jae	kjllll
;	mov	bx,hmin
;	cmp	obj5d+8,bx
;	ja	kjllll
;	jmp	planeongrnd
;
;kjllll:
;	call	randspin			; assign a random spin
;	mov	byte ptr [si+64],20		; let plane drop like a rock
;planeongrnd:
	ret
.endp

.proc	randspin	auto
	mov	bx,60
	call	randr_w			; get randome bnmre
	add	ax,20
	mov	[si+54],ax		; put some spin on it
	mov	bx,40
	call	randr_w			; get randome bnmre
	add	ax,10
	mov	[si+56],ax		; put some spin on it
	mov	bx,110
	call	randr_w			; get randome bnmre
	add	ax,30
	mov	[si+58],ax		; put some spin on it
	ret
.endp

.proc	evaldist	auto	; check distance from this obj to observer
	push	si
	call	rel3d
	pop	si		; see how close we are
	jc	evmantofar		; too far away
	or	ch,ch			; if cx is zero, then too far
	jnz	evmantofar
					; dxvec now holds the magic vector
					; which points away from the plane
	and	cl,0ffh			; now check for still too far
	jnz	evmantofar		;
	mov	ax,dxvec
	mov	manvec,ax
	mov	ax,dxvec+4
	mov	manvec+2,ax
	mov	ax,dxvec+8
	mov	manvec+4,ax
	push	si
	mov	si,offset @dataseg:manvec
	call	vmag
	pop	si
	clc
	ret
evmantofar:
	stc
	ret
.endp

.proc	placeplane	auto		; places planes in their own spots
	push	si
	mov	di,offset @dataseg:startcoords
	xchg	si,di
	mov	ax,ds
	mov	es,ax
	mov	cx,8			; mov z coord, and angles
	cld
	rep	movsw			; now plane is at startcoords
	pop	si
	mov	ax,l10*4
	mov	bx,nplaced		; get number of planes which have
					; been placed
	mul	bx
	sub	[si],ax			; add offset to move plane back
	sbb	[si+2],dx
	mov	ax,-8000		; get default yaw
	mov	[si+12],ax		; so plane is pointed right
	inc	nplaced			; tell next plane to move back!
	ret
.endp
	
.proc	obj5datim	auto		; what does a plane do?
	jnc	noblastus
	jmp	blastus
noblastus:
	test	word ptr [si+24],100h
	jz	nocrashed
	mov	ax,offset @dataseg:plnplyobjsm
	mov	word ptr [si+40],ax
	mov	word ptr [si+42],ax
nocrashed:
	mov	wingclr,1
	test	[si+24],1000h
	jz	nodumpy			; test for ok or dumpy plane
	mov	wingclr,6		; brown wings for dumpy plane
nodumpy:
	mov	[si+52],32000	; never die

	cmp	exitflag,0	; if we are destined to exit, don't get in 
	jnz	hasbeenfiddled	; the plane

	cmp	resetplanesflag,0
	jz	mayberepair
	mov	byte ptr [si+65],0
	jmp	hasbeenfiddled
mayberepair:
	test	byte ptr [si+65],10h
	jnz	hasbeenfiddled
	mov	ax,word ptr [si+24]
	test	ax,2100h			; is plane crashed? or bomber?
	jnz	hasbeenfiddled
	and	ax,6
	cmp	ax,6			; was this object crashlanded at home?
	jz	repairandplace
	or	ax,ax
	jz	justplace		; if plane is ok, then just place it
	jnz	hasbeenfiddled		; no, so leave alone
repairandplace:
justplace:
	and	word ptr [si+24],NOT 106h	; repair plane!
	push	si
	add	si,8
	mov	di,offset @dataseg:startcoords+8
	xchg	si,di
	mov	ax,ds
	mov	es,ax
	mov	cx,5			; mov z coord, and angles
	cld
	rep	movsw
	pop	si
	test	byte ptr [si+65],1	; have we inited this plane?
	jnz	alreadyinited		; ie have we placed it at the strt
	call	placeplane		; coords?
	or	byte ptr [si+65],1	; mark plane as placed
	jmp	hasbeenfiddled		; ork a dork
alreadyinited:
	cmp	ejectflag,0
	jz	hasbeenfiddled		; this code places new guy in plane
					; if game has just been entered
	cmp	newguyflag,0
	jz	hasbeenfiddled		; this code places new guy in plane
	jmp	goandgetin1		; jump into first plane I see
hasbeenfiddled:
	cmp	ejectflag,0
	jz	dmantofar
	cmp	exitflag,0	; if we are destined to exit, don't get in 
	jnz	dmantofar	; the plane
	call	evaldist
	jc	dmantofar
	cmp	ax,2000
	ja	dmantofar
;	test	word ptr [si+24],100h	; is plane dead?
;	jnz	dmantofar		; yes, then can't get into it
;	cmp	fateofplane,0		; has fate of obj5d been determined?
;	jz	qfate		; no, so can't get in other plane
goandgetin:
	jmp	goandgetin2
goandgetin1:
	call	evaldist
	jc	hasbeenfiddled
	mov	newguyflag,0		; turn off this in future
	add	word ptr [si+4],-w*4	; move out to beginning of runway
	adc	word ptr [si+6],-1
	mov	word ptr [si+12],0	; point exactly to the north
goandgetin2:
	push	si
	push	di
	call	getinplane
	pop	di
	pop	si
	mov	word ptr [si+24],0	; remove this object from table
	ret
dmantofar:
	test	[si+24],2000h		 ; test for bomber
	jz	notbomber1
	mov	ax,offset @dataseg:stlhobj
	mov	word ptr [si+40],ax	; change appearance
	mov	word ptr [si+42],ax
notbomber1:
	ret
qfate:	cmp	groundflag,0
	jz	dmantofar
	jmp	goandgetin
blastus:
	cmp	di,offset @dataseg:obj5d	; don't let object 5d destroy
	jz	no5dkillus			; us ever
	push	di
	mov	ax,[di+72]	; get object type to chech extended table
	add	ax,ax		; make into a word address
	mov	di,offset @dataseg:extendedtypetbl
	add	di,ax
	mov	ax,[di]		; check save bit
	pop	di
	test	ax,16		; is it a runway?
	jnz	no5dkillus			; us ever no kill us
	stc				; make it clear what we want
	jmp	fdest			; just do a friendly destruction
no5dkillus:
	ret
.endp


.proc	towertim	auto		; does what a tower does best
	call	homedetect
	pushf
	mov	ax,[si]
	mov	dx,[si+2]
	add	ax,3001
	adc	dx,-2
	mov	startcoords,ax
	mov	startcoords+2,dx
	mov	ax,[si+4]
	mov	dx,[si+6]
	add	ax,-16000
	adc	dx,-1
	mov	startcoords+4,ax
	mov	startcoords+6,dx
	mov	ax,[si]
	mov	dx,[si+2]
	sub	ax,-1
	sbb	dx,roadx-2		; get x origin of tower into
	sub	dx,universex
	mov	cl,6				; 0,1,2
	shr	dx,cl				; divide by 64
	sub	dx,1				; now dx should have 0,1,2
	push	dx				; save for now
	mov	ax,[si+4]			; do same for y
	mov	dx,[si+6]
	sub	ax,16000
	sbb	dx,universey
	mov	cl,6				; 0,1,2
	shr	dx,cl				; divide by 64
	sub	dx,1				; now dx should have 0,1,2
	mov	bx,3				; make into 0,3,6
	mov	ax,dx
	mul	bx
	pop	bx
	add	ax,bx				; now should have # 0-8
	mov	curtower,ax			; to force rearrangment
	popf
	jmp	fdest
.endp

.proc	hashregcode	auto	; hashes response code
	ror	al,1
	ror	al,1
	ror	al,1
	add	al,177
	rol	ah,1
	add	ah,55
	add	ah,al
	rol	dl,1
	rol	dl,1
	rol	dl,1
	rol	dl,1
	xor	dl,ah
	add	dl,al
	ret
.endp

.proc	unhashregcode	auto
	sub	dl,al
	xor	dl,ah
	ror	dl,1
	ror	dl,1
	ror	dl,1
	ror	dl,1
	sub	ah,al
	sub	ah,55
	ror	ah,1
	sub	al,177
	rol	al,1
	rol	al,1
	rol	al,1
	ret
.endp



.proc	survtim	auto		; time for what a survey marker does
	mov	[si+52],32000	; permanent object
IF protection
IF demover EQ 0
;	cmp	frmnum,1365	; many frames
;	jbe	regok

	mov	bx,offset @dataseg:tempindex-71
	mov	bx,[bx+71]
	test	bx,800h
	jz	regok

	call	rand_w
	cmp	ax,100
	ja	regok		; wait some more time

	push	si
	mov	si,offset @dataseg:clnregcodeh-10
	mov	dx,[si+10]
	or	dx,dx
	pop	si
	js	hotshot		; don't check if no value put in for -c option

	mov	bx,offset @dataseg:tempsum-210
	mov	ax,[bx+210]
	mov	dx,[bx+212]
	call	hashregcode	; hash reg code before checking
	mov	bx,offset @dataseg:nregcode-210
	mov	cx,[bx+210]
	mov	bx,[bx+212]
	xor	bh,bh
	xor	dh,dh
	.cmp_dd	dx,ax,bx,cx
	jz	regok
	or	bx,cx
	jz	regok			; don't bother if in trial period
	mov	word ptr [si+66],-1	; make radius negative
ENDIF
ENDIF
regok:	ret
IF protection
IF demover EQ 0
hotshot:				; detect if player is too good
					; to be playing in a trial period
	mov	bx,offset @dataseg:readfileflag-13
	add	bx,13
	cmp	byte ptr [bx],0
	jnz	skiptst1		; never skip test if flying combat
	mov	bx,offset @dataseg:invincible-15
	add	bx,13
	inc	bx
	inc	bx
	cmp	byte ptr [bx],0
	jnz	skiptst			; skip jerkout if in training invinc
skiptst1:
	mov	ax,rollprog		; hot pilots do more that 50 rolls
	cmp	ax,125
	ja	hosehim			; hose this guy, he's too good!
	mov	ax,aaprog+2
	cmp	ax,4
	ja	hosehim
	mov	ax,dballprog+2
	cmp	ax,12
	ja	hosehim			; evaded too many KLA's
skiptst:
	ret

hosehim:				; nuke this guy!
	mov	word ptr [si+66],-2	; make radius negative
	ret
ENDIF
ENDIF
.endp

.proc	huttim	auto
	jnc	lookforhuman
	ret
lookforhuman:
	mov	[si+52],32000	; never die

	cmp	ejectflag,0
	jz	tmantofar	; don't allow tower access to plane
	call	evaldist
	jc	tmantofar
	cmp	ax,2000
	ja	tmantofar
	mov	redamageflag,0
	mov	intowerflag,-1
tmantofar:
	ret
.endp

.ends

.dataseg
objhq	dw	0,0		; 32 bit xyz coordinates
	dw	0,0
	dw	lhq*4,0
	dw	0		; yaw, pitch, and roll
	dw	0
	dw	0

	db	0		; distance default, 0=near
	db	3		; this is a class 2 object

	dw	9612,244	; 32-bit distance squared

	dw	0b9h		; object type 0= no-draw bit 4=destructable
	db	2		; rotflg, 0= no rotation
	db	hqhits		; two bombs + 3 missles ought to do it
	dd	977625289	; breakpoint for near dist squared
	dd	456680332	; bkpt for med near dist sqrd
	dd	1067541266	; bkpt for med far dist sqrd
	dw	hqobj		; address of near object
	dw	hqobj		; address of med object
	dw	shqobj		; address of med object
	dw	0,0,0		; xyz velocity of object
	dw	32000		; done flag 0= no move
	dw	0,0,0		; yaw, pitch and roll angular velocities
	dw	0,0		; dispersion, and wind resistance damping
	dw	0		; gravity
	dw	lhq*2,lhq*2,lhq*2	; rectangle of collision
IF cdct EQ 0
	dw	0
ELSE
	dw	@codeseg:bigdest	; routine of destruction
ENDIF

objstet	dw	0,0		; 32 bit xyz coordinates
	dw	0,0
	dw	stet86*2,0
	dw	0		; yaw, pitch, and roll
	dw	32768		; flip upsidedown
	dw	0

	db	0		; distance default, 0=near
	db	3		; this is a class 3 object

	dw	9612,244	; 32-bit distance squared

	dw	1b9h		; object type 0= no-draw bit 4=destructable
	db	3		; rotflg, 0= no rotation
	db	1		; 5 hits to bring down a fuel dump
	dd	977625289	; breakpoint for near dist squared
	dd	367541266	; bkpt for med near dist sqrd
	dd	1067541266	; bkpt for med far dist sqrd
	dw	stetobj		; address of near object
	dw	stetobj		; address of med object
	dw	objflshpt	; address of med object
	dw	0,0,0		; xyz velocity of object
	dw	32000		; done flag 0= no move
	dw	1500,0,0	; yaw, pitch and roll angular velocities
	dw	0,0		; dispersion, and wind resistance damping
	dw	0		; gravity
	dw	stet86*2,stet86*2,stet86*2	; rectangle of collision
	dw	1

obj5da	dw	8000,roadx-1	; 32 bit xyz coordinates
	dw	8000,0
	dw	ehmin,0		; lift off the ground
	dw	-8000		; yaw, pitch, and roll
	dw	-2456
	dw	0

	db	0		; distance default, 0=near
	db	1		; this is a class 1 object

	dw	9612,244	; 32-bit distance squared

	dw	0f9h		; object type 0= no-draw bit 4=destructable
;	dw	11h
	db	3		; rotflg, 0= no rotation
	db	2		; takes two hits
	dd	977625289	; breakpoint for near dist squared
	dd	256680332	; bkpt for med near dist sqrd
	dd	16680332	; bkpt for med far dist sqrd
	dw	plnplyobj		; address of near object
	dw	splnplyobj		; address of med object
	dw	ssplnobj		; address of med object
	dw	0,0,0		; xyz velocity of object
	dw	32000		; done flag 0= no move
	dw	0,0,0		; yaw, pitch and roll angular velocities
	dw	0,0		; dispersion, and wind resistance damping
	dw	0		; gravity
	dw	lp4,lp4,lp4	; rectangle of collision
IF cdct EQ 0
	dw	2
ELSE
	dw	@codeseg:fdest	; routine of destruction
ENDIF

objrdr	dw	-1,roadx	; 32 bit xyz coordinates
	dw	16000,0
	dw	4*ltw,0		; lift off the ground
	dw	0		; yaw, pitch, and roll
	dw	0
	dw	0

	db	0		; distance default, 0=near
	db	1		; this is a class 1 object

	dw	9612,244	; 32-bit distance squared

	dw	0b9h		; object type 0= no-draw bit 4=destructable
	db	2		; rotflg, 0= no rotation
	db	10		; ten hits to make the radar blow
	dd	977625289	; breakpoint for near dist squared
	dd	300000000	; bkpt for med near dist sqrd
	dd	1067541266	; bkpt for med far dist sqrd
	dw	rdrobj		; address of near object
	dw	srdrobj		; address of near object
	dw	ssrdrobj		; address of med object
	dw	0,0,0		; xyz velocity of object
	dw	32000		; done flag 0= no move
	dw	0,0,0		; yaw, pitch and roll angular velocities
	dw	0,0		; dispersion, and wind resistance damping
	dw	0		; gravity
	dw	ltwl,ltwl,ltwl	; rectangle of collision
IF cdct EQ 0
	dw	3
ELSE
	dw	@codeseg:fdest	; routine of destruction
ENDIF

objtw	dw	-1,roadx	; 32 bit xyz coordinates
	dw	16000,0
	dw	4*ltw,0		; lift off the ground
	dw	0		; yaw, pitch, and roll
	dw	0
	dw	0

	db	0		; distance default, 0=near
	db	1		; this is a class 1 object

	dw	9612,244	; 32-bit distance squared

	dw	11h		; object type 0= no-draw bit 4=destructable
	dw	2		; rotflg, 0= no rotation
	dd	977625289	; breakpoint for near dist squared
	dd	256680332	; bkpt for med near dist sqrd
	dd	13344265	; bkpt for med far dist sqrd
	dw	twobj		; address of near object
	dw	twobj		; address of near object
	dw	nulobj		; address of far object
	dw	0,0,0		; xyz velocity of object
	dw	32000		; done flag 0= no move
	dw	0,0,0		; yaw, pitch and roll angular velocities
	dw	0,0		; dispersion, and wind resistance damping
	dw	0		; gravity
	dw	0,0,0		; collision rect
IF cdct EQ 0
	dw	4
ELSE
	dw	@codeseg:donothing	; routine of destruction
ENDIF

objroadend	dw	-1,roadx	; 32 bit xyz coordinates
	dw	0,0
	dw	0,0
	dw	0		; yaw, pitch, and roll
	dw	0
	dw	0

	db	0		; distance default, 0=near
;	db	1		; object class: friendly
	db	0

	dw	9612,244	; 32-bit distance squared

	dw	111h		; object type 0= no-draw bit 4=destructable
	dw	2		; rotflg, 0= no rotation
	dd	977625289	; breakpoint for near dist squared
	dd	256680332	; bkpt for med near dist sqrd
	dd	1067541266	; bkpt for med far dist sqrd
	dw	roadendobj		; address of near object
	dw	roadendobj		; address of med object
	dw	sroadobj	; address of med object
	dw	0,0,0		; xyz velocity of object
	dw	32000		; done flag 0= no move
	dw	0,0,0		; yaw, pitch and roll angular velocities
	dw	0,0		; dispersion, and wind resistance damping
	dw	0		; gravity
	dw	rl,w*2,8000	; this is the size of things
IF cdct EQ 0
	dw	35
ELSE
	dw	@codeseg:donothing	; routine of destruction
ENDIF

objroadend1	dw	-1,roadx	; 32 bit xyz coordinates
	dw	0,0
	dw	0,0
	dw	0		; yaw, pitch, and roll
	dw	0
	dw	0

	db	0		; distance default, 0=near
;	db	1		; object class: friendly
	db	0

	dw	9612,244	; 32-bit distance squared

	dw	111h		; object type 0= no-draw bit 4=destructable
	dw	2		; rotflg, 0= no rotation
	dd	977625289	; breakpoint for near dist squared
	dd	256680332	; bkpt for med near dist sqrd
	dd	1067541266	; bkpt for med far dist sqrd
	dw	roadendobj1		; address of near object
	dw	roadendobj1	; address of med object
	dw	sroadobj	; address of med object
	dw	0,0,0		; xyz velocity of object
	dw	32000		; done flag 0= no move
	dw	0,0,0		; yaw, pitch and roll angular velocities
	dw	0,0		; dispersion, and wind resistance damping
	dw	0		; gravity
	dw	rl,w*2,8000	; this is the size of things
IF cdct EQ 0
	dw	36
ELSE
	dw	@codeseg:donothing	; routine of destruction
ENDIF


roadpiece	dw	-1,roadx	; 32 bit xyz coordinates
	dw	0,0
	dw	0,0
	dw	0		; yaw, pitch, and roll
	dw	0
	dw	0

	db	0		; distance default, 0=near
;	db	1		; object class: friendly
	db	0

	dw	9612,244	; 32-bit distance squared

	dw	111h		; object type 0= no-draw bit 4=destructable
	dw	2		; rotflg, 0= no rotation
	dd	977625289	; breakpoint for near dist squared
	dd	256680332	; bkpt for med near dist sqrd
	dd	1067541266	; bkpt for med far dist sqrd
	dw	roadobj		; address of near object
	dw	scroadobj		; address of med object
	dw	sroadobj	; address of med object
	dw	0,0,0		; xyz velocity of object
	dw	32000		; done flag 0= no move
	dw	0,0,0		; yaw, pitch and roll angular velocities
	dw	0,0		; dispersion, and wind resistance damping
	dw	0		; gravity
	dw	rl,w*2,8000	; this is the size of things
IF cdct EQ 0
	dw	5
ELSE
	dw	@codeseg:donothing	; routine of destruction
ENDIF

objhut	dw	-1,roadx-2	; 32 bit xyz coordinates
	dw	16000,0
	dw	0,0		; lift off the ground
	dw	0		; yaw, pitch, and roll
	dw	0
	dw	0

	db	0		; distance default, 0=near
	db	1		; this is a class 1 object

	dw	9612,244	; 32-bit distance squared

	dw	19h		; object type 0= no-draw bit 4=destructable
				; take coords as wall type
	db	0		; rotflg, 0= no rotation
	db	10		; 10 hits to make it blow
	dd	977625289	; breakpoint for near dist squared
	dd	256680332	; bkpt for med near dist sqrd
	dd	16680332	; bkpt for med far dist sqrd
	dw	hutobj		; address of near object
	dw	hutobj		; address of near object
	dw	nulobj		; address of med object
	dw	0,0,0		; xyz velocity of object
	dw	32000		; done flag 0= no move
	dw	0,0,0		; yaw, pitch and roll angular velocities
	dw	0,0		; dispersion, and wind resistance damping
	dw	0		; gravity
	dw	0,0,0	; rectangle of collision
IF cdct EQ 0
	dw	34
ELSE
	dw	@codeseg:fdest	; routine of destruction
ENDIF

tower	dw	-1,roadx-2	; 32 bit xyz coordinates
	dw	16000,0
	dw	twszl*2,0		; lift off the ground
	dw	0		; yaw, pitch, and roll
	dw	0
	dw	0

	db	0		; distance default, 0=near
	db	1		; this is a class 1 object

	dw	9612,244	; 32-bit distance squared

	dw	1b9h		; object type 0= no-draw bit 4=destructable
				; take coords as wall type
	db	2		; rotflg, 0= no rotation
	db	10		; 10 hits to make it blow
	dd	977625289	; breakpoint for near dist squared
	dd	256680332	; bkpt for med near dist sqrd
	dd	16680332	; bkpt for med far dist sqrd
	dw	ctwrobj		; address of near object
	dw	twrobj		; address of near object
	dw	stwrobj		; address of med object
	dw	0,0,0		; xyz velocity of object
	dw	32000		; done flag 0= no move
	dw	0,0,0		; yaw, pitch and roll angular velocities
	dw	0,0		; dispersion, and wind resistance damping
	dw	0		; gravity
	dw	2*twsz,2*twsz,2*twszl	; rectangle of collision
IF cdct EQ 0
	dw	6
ELSE
	dw	@codeseg:fdest	; routine of destruction
ENDIF

objman1	dw	-1,roadx	; 32 bit xyz coordinates
	dw	22000,0
	dw	0,0		; lift off the ground
	dw	0		; yaw, pitch, and roll
	dw	0
	dw	0

	db	0		; distance default, 0=near
	db	1		; this is a class 1 object

	dw	9612,244	; 32-bit distance squared

	dw	19h		; object type 0= no-draw bit 4=destructable
	dw	2		; rotflg, 0= no rotation
	dd	977625289	; breakpoint for near dist squared
	dd	256680332	; bkpt for med near dist sqrd
	dd	13344265	; bkpt for med far dist sqrd
	dw	manobj		; address of near object
	dw	manobj		; address of near object
	dw	ssmanobj		; address of far object
	dw	0,0,0		; xyz velocity of object
	dw	32000		; done flag 0= no move
	dw	0,0,0		; yaw, pitch and roll angular velocities
	dw	0,0		; dispersion, and wind resistance damping
	dw	0		; gravity
	dw	msz6,msz6,msz6	; rectangle of collision
IF cdct EQ 0
	dw	7
ELSE
	dw	@codeseg:mandest	; routine of destruction
ENDIF
	
objman	dw	-1,roadx	; 32 bit xyz coordinates
	dw	22000,0
	dw	0,0		; lift off the ground
	dw	0		; yaw, pitch, and roll
	dw	0
	dw	0

	db	0		; distance default, 0=near
	db	1		; this is a class 1 object

	dw	9612,244	; 32-bit distance squared

	dw	19h		; object type 0= no-draw bit 4=destructable
	db	2		; rotflg, 0= no rotation
	db	1		; just one hit to take out
	dd	977625289	; breakpoint for near dist squared
	dd	256680332	; bkpt for med near dist sqrd
	dd	13344265	; bkpt for med far dist sqrd
	dw	manobj		; address of near object
	dw	manobj		; address of near object
	dw	ssmanobj		; address of far object
	dw	0,0,0		; xyz velocity of object
	dw	32000		; done flag 0= no move
	dw	0,0,0		; yaw, pitch and roll angular velocities
	dw	0,0		; dispersion, and wind resistance damping
	dw	0		; gravity
	dw	msz6,msz6,msz6	; rectangle of collision
IF cdct EQ 0
	dw	7
ELSE
	dw	@codeseg:mandest	; routine of destruction
ENDIF

objshard2	dw	8000,roadx-1	; 32 bit xyz coordinates
	dw	8000,0
	dw	2*3*l,0		; lift off the ground
	dw	-8000		; yaw, pitch, and roll
	dw	-2456
	dw	0

	db	0		; distance default, 0=near
	db	2		; make it a class 2

	dw	9612,244	; 32-bit distance squared

	dw	11h		; object type 0= no-draw, timed object
	dw	2		; rotflg, 0= no rotation
	dd	977625289	; breakpoint for near dist squared
	dd	256680332	; bkpt for med near dist sqrd
	dd	16680332	; bkpt for med far dist sqrd
	dw	shardobj2		; address of near object
	dw	shardobj2		; address of med object
	dw	nulobj		; address of med object
	dw	0,0,0		; xyz velocity of object
	dw	1		; done flag 0= no move
	dw	0,0,0		; yaw, pitch and roll angular velocities
	dw	0,0	; dispersion, and wind resistance damping
	dw	54		; gravity
	dw	l*15,l*15,2*l	; rectangle of collision
IF cdct EQ 0
	dw	8
ELSE
	dw	@codeseg:shardtim	; routine of destruction
ENDIF

objshard	dw	8000,roadx-1	; 32 bit xyz coordinates
	dw	8000,0
	dw	2*3*l,0		; lift off the ground
	dw	-8000		; yaw, pitch, and roll
	dw	-2456
	dw	0

	db	0		; distance default, 0=near
	db	2		; make it a class 2

	dw	9612,244	; 32-bit distance squared

	dw	11h		; object type 0= no-draw, timed object
	dw	2		; rotflg, 0= no rotation
	dd	977625289	; breakpoint for near dist squared
	dd	256680332	; bkpt for med near dist sqrd
	dd	16680332	; bkpt for med far dist sqrd
	dw	shardobj		; address of near object
	dw	shardobj		; address of med object
	dw	nulobj		; address of med object
	dw	0,0,0		; xyz velocity of object
	dw	1		; done flag 0= no move
	dw	0,0,0		; yaw, pitch and roll angular velocities
	dw	0,0	; dispersion, and wind resistance damping
	dw	54		; gravity
	dw	l*15,l*15,2*l	; rectangle of collision
IF cdct EQ 0
	dw	9
ELSE
	dw	@codeseg:shardtim	; routine of destruction
ENDIF

objincend	dw	8000,roadx-1	; 32 bit xyz coordinates
	dw	8000,0
	dw	2*3*l,0		; lift off the ground
	dw	-8000		; yaw, pitch, and roll
	dw	-2456
	dw	0

	db	0		; distance default, 0=near
	db	3		; class 3

	dw	9612,244	; 32-bit distance squared

	dw	11h		; object type 0= no-draw, timed object
	dw	2		; rotflg, 0= no rotation
	dd	977625289	; breakpoint for near dist squared
	dd	256680332	; bkpt for med near dist sqrd
	dd	16680332	; bkpt for med far dist sqrd
	dw	incendobj		; address of near object
	dw	incendobj		; address of med object
	dw	nulobj		; address of med object
	dw	0,0,0		; xyz velocity of object
	dw	1		; done flag 0= no move
	dw	0,0,0		; yaw, pitch and roll angular velocities
	dw	0,0	; dispersion, and wind resistance damping
	dw	54		; gravity
	dw	1000,1000,1000	; rectangle of collision
IF cdct EQ 0
	dw	10
ELSE
	dw	@codeseg:incendtim	; routine of destruction
ENDIF


objdbst	dw	-1,roadx	; 32 bit xyz coordinates
	dw	16000,0
	dw	4*ltw,0		; lift off the ground
	dw	0		; yaw, pitch, and roll
	dw	0
	dw	0

	db	0		; distance default, 0=near
	db	2		; this is a class 1 object

	dw	9612,244	; 32-bit distance squared

	dw	019h		; object type 0= no-draw bit 4=destructable
	db	2		; rotflg, 0= no rotation
	db	50		; fifty hits to take out site
	dd	977625289	; breakpoint for near dist squared
	dd	300000000	; bkpt for med near dist sqrd
	dd	1067541266	; bkpt for med far dist sqrd
	dw	dbstobj		; address of near object
	dw	dbstobj		; address of near object
	dw	sdbstobj		; address of med object
	dw	0,0,0		; xyz velocity of object
	dw	1		; done flag 0= no move
	dw	0,0,0		; yaw, pitch and roll angular velocities
	dw	0,0		; dispersion, and wind resistance damping
	dw	0		; gravity
	dw	2*dbstsz,2*dbstsz,2*dbstsz ; rectangle of collision
IF cdct EQ 0
	dw	11
ELSE
	dw	@codeseg:dbsttim	; routine of destruction
ENDIF

objvech	dw	-1,roadx	; 32 bit xyz coordinates
	dw	16000,0
	dw	0,0		; lift off the ground
	dw	0		; yaw, pitch, and roll
	dw	0
	dw	0

	db	0		; distance default, 0=near
	db	2		; this is a class 1 object

	dw	9612,244	; 32-bit distance squared

	dw	019h		; object type 0= no-draw bit 4=destructable
	db	2		; rotflg, 0= no rotation
	db	5		; fifty hits to take out site
	dd	977625289	; breakpoint for near dist squared
	dd	977625289	; bkpt for med near dist sqrd
	dd	977625289	; bkpt for med far dist sqrd
	dw	veobj		; address of near object
	dw	veobj		; address of near object
	dw	sveobj		; address of near object
	dw	0,0,0		; xyz velocity of object
	dw	1		; done flag 0= no move
	dw	0,0,0		; yaw, pitch and roll angular velocities
	dw	0,0		; dispersion, and wind resistance damping
	dw	0		; gravity
	dw	2*vesz,2*vesz,2*vesz ; rectangle of collision
IF cdct EQ 0
	dw	12
ELSE
	dw	@codeseg:vechtim	; routine of destruction
ENDIF

objvest	dw	-1,roadx	; 32 bit xyz coordinates
	dw	16000,0
	dw	4*ltw,0		; lift off the ground
	dw	0		; yaw, pitch, and roll
	dw	0
	dw	0

	db	0		; distance default, 0=near
	db	2		; this is a class 1 object

	dw	9612,244	; 32-bit distance squared

	dw	019h		; object type 0= no-draw bit 4=destructable
	db	2		; rotflg, 0= no rotation
	db	50		; fifty hits to take out site
	dd	977625289	; breakpoint for near dist squared
	dd	300000000	; bkpt for med near dist sqrd
	dd	1067541266	; bkpt for med far dist sqrd
	dw	vestobj		; address of near object
	dw	vestobj		; address of near object
	dw	nulobj		; address of med object
	dw	0,0,0		; xyz velocity of object
	dw	1		; done flag 0= no move
	dw	0,0,0		; yaw, pitch and roll angular velocities
	dw	0,0		; dispersion, and wind resistance damping
	dw	0		; gravity
	dw	2*dbstsz,2*dbstsz,2*dbstsz ; rectangle of collision
IF cdct EQ 0
	dw	13
ELSE
	dw	@codeseg:vesttim	; routine of destruction
ENDIF

objwallx	dd	wallsz*2	; 32 bit xyz coordinates
	dw	0,0
	dw	wallsz,0		; lift off the ground
	dw	0		; yaw, pitch, and roll
	dw	0
	dw	0

	db	0		; distance default, 0=near
	db	3		; this is a class 1 object

	dw	9612,244	; 32-bit distance squared

	dw	139h		; object type 0= no-draw bit 4=destructable
				; wallbit 100h set to say it's a wall
	db	2		; rotflg, 0= no rotation
	db	50		; fifty hits to take out site
	dd	977625289	; breakpoint for near dist squared
	dd	125000000	; bkpt for med near dist sqrd
	dd	1067541266	; bkpt for med far dist sqrd
	dw	wxobj		; address of near object
	dw	wxobj		; address of near object
IF slalom
	dw	wxobj		; address of near object
ELSE
	dw	nulobj		; address of med object
ENDIF
	dw	0,0,0		; xyz velocity of object
	dw	32000		; done flag 0= no move
	dw	0,0,0		; yaw, pitch and roll angular velocities
	dw	0,0		; dispersion, and wind resistance damping
	dw	0		; gravity
	dw	3000,2*wallsz,wallsz	; rectangle of collision
IF cdct EQ 0
	dw	15
ELSE
	dw	@codeseg:walltim	; routine of destruction
ENDIF

objwally	dw	0,0	; 32 bit xyz coordinates
	dd	wallsz*8
	dd	wallsz*2		; lift off the ground
	dw	0		; yaw, pitch, and roll
	dw	0
	dw	0

	db	0		; distance default, 0=near
	db	3		; this is a class 1 object

	dw	9612,244	; 32-bit distance squared

	dw	139h		; object type 0= no-draw bit 4=destructable
				; wallbit 100h set to say it's a wall
	db	2		; rotflg, 0= no rotation
	db	50		; fifty hits to take out site
	dd	977625289	; breakpoint for near dist squared
	dd	125000000	; bkpt for med near dist sqrd
	dd	1067541266	; bkpt for med far dist sqrd
	dw	wyobj		; address of near object
	dw	wyobj		; address of near object
IF slalom
	dw	wyobj		; address of near object
ELSE
	dw	nulobj		; address of med object
ENDIF
	dw	0,0,0		; xyz velocity of object
	dw	32000		; done flag 0= no move
	dw	0,0,0		; yaw, pitch and roll angular velocities
	dw	0,0		; dispersion, and wind resistance damping
	dw	0		; gravity
	dw	2*wallsz,3000,wallsz	; rectangle of collision
IF cdct EQ 0
	dw	16
ELSE
	dw	@codeseg:walltim	; routine of destruction
ENDIF

objwallz	dd	0	; 32 bit xyz coordinates
	dd	0
	dw	2*wallsz,0		; lift off the ground
	dw	0		; yaw, pitch, and roll
	dw	0
	dw	0

	db	0		; distance default, 0=near
	db	3		; this is a class 1 object

	dw	9612,244	; 32-bit distance squared

	dw	139h		; object type 0= no-draw bit 4=destructable
				; wallbit 100h set to say it's a wall
	db	2		; rotflg, 0= no rotation
	db	50		; fifty hits to take out site
	dd	977625289	; breakpoint for near dist squared
	dd	125000000	; bkpt for med near dist sqrd
	dd	1067541266	; bkpt for med far dist sqrd
	dw	wzobj		; address of med object
	dw	wzobj		; address of med object
IF slalom
	dw	wzobj		; address of med object
ELSE
	dw	nulobj		; address of near object
ENDIF
	dw	0,0,0		; xyz velocity of object
	dw	32000		; done flag 0= no move
	dw	0,0,0		; yaw, pitch and roll angular velocities
	dw	0,0		; dispersion, and wind resistance damping
	dw	0		; gravity
	dw	2*wallsz,2*wallsz,3000	; rectangle of collision
IF cdct EQ 0
	dw	17
ELSE
	dw	@codeseg:walltim	; routine of destruction
ENDIF

objwallz1	dd	0	; 32 bit xyz coordinates
	dd	0
	dw	2*wallsz,0		; lift off the ground
	dw	0		; yaw, pitch, and roll
	dw	0
	dw	0

	db	0		; distance default, 0=near
	db	3		; this is a class 1 object

	dw	9612,244	; 32-bit distance squared

	dw	139h		; object type 0= no-draw bit 4=destructable
				; wallbit 100h set to say it's a wall
	db	2		; rotflg, 0= no rotation
	db	50		; fifty hits to take out site
	dd	977625289	; breakpoint for near dist squared
	dd	125000000	; bkpt for med near dist sqrd
	dd	1067541266	; bkpt for med far dist sqrd
	dw	wz1obj		; address of near object
	dw	wz1obj		; address of med object
IF slalom
	dw	wz1obj		; address of med object
ELSE
	dw	nulobj		; address of near object
ENDIF
	dw	0,0,0		; xyz velocity of object
	dw	32000		; done flag 0= no move
	dw	0,0,0		; yaw, pitch and roll angular velocities
	dw	0,0		; dispersion, and wind resistance damping
	dw	0		; gravity
	dw	wallsz,wallsz,3000	; rectangle of collision
IF cdct EQ 0
	dw	14
ELSE
	dw	@codeseg:walltim	; routine of destruction
ENDIF



fltsm1puff	dw	4000,0		; 32 bit xyz coordinates
	dw	0,0
	dw	0,0
	dw	0		; yaw, pitch, and roll
	dw	0
	dw	0

	dw	0		; distance default, 0=near

	dw	9612,244	; 32-bit distance squared

	dw	11h		; object type 0= no-draw
	dw	0		; rotflg, 0= no rotation
	dd	977625289	; breakpoint for near dist squared
	dd	1067541266	; bkpt for med near dist sqrd
	dd	1067541266	; bkpt for med far dist sqrd
	dw	objflt1puff		; address of near object
	dw	objflt1puff		; address of med object
	dw	objbpt		; address of far object, usually point
	dw	0,0,50		; velocity for x,y,z
	dw	3200		; time left to party
	dw	0,0,1700	; yaw, pitch and roll angular velocities
	dw	20,16000	; dispersion, and wind resistance damping
	dw	254		; gravity
	dw	l*15,l*15,2*l	; rectangle of collision
IF cdct EQ 0
	dw	18
ELSE
	dw	@codeseg:pufftim	; routine of destruction
ENDIF

fltsm1boom	dw	4000,0		; 32 bit xyz coordinates
	dw	0,0
	dw	0,0
	dw	0		; yaw, pitch, and roll
	dw	0
	dw	0

	dw	0		; distance default, 0=near

	dw	9612,244	; 32-bit distance squared

	dw	11h		; object type 0= no-draw
	db	0		; rotflg, 0= no rotation
	db	2		; this is a class two object?
	dd	977625289	; breakpoint for near dist squared
	dd	1067541266	; bkpt for med near dist sqrd
	dd	1067541266	; bkpt for med far dist sqrd
	dw	objflt3boom		; address of near object 40
	dw	objflt3boom		; address of med object 42
	dw	objbpt		; address of far object, usually point 44
	dw	0,0,0		; velocity for x,y,z
	dw	3200		; time left to party
	dw	0,0,1700	; yaw, pitch and roll angular velocities
	dw	0,0		; dispersion, and wind resistance damping
	dw	0		; gravity
	dw	5000,5000,5000	; rectangle of collision
IF cdct EQ 0
	dw	19
ELSE
	dw	@codeseg:boomtim	; routine of destruction
ENDIF

crtr	dw	4000,0		; 32 bit xyz coordinates
	dw	0,0
	dw	60,0
	dw	0		; yaw, pitch, and roll
	dw	0
	dw	0

	dw	0		; distance default, 0=near

	dw	9612,244	; 32-bit distance squared

	dw	191h		; object type 0= no-draw, non-destructable
	dw	0		; rotflg, 0= no rotation
	dd	977625289	; breakpoint for near dist squared
	dd	1067541266	; bkpt for med near dist sqrd
	dd	1067541266	; bkpt for med far dist sqrd
	dw	crtrobj		; address of near object
	dw	crtrobj		; address of med object
	dw	nulobj		; address of far object, usually point
	dw	0,0,0		; velocity for x,y,z
	dw	3200		; time left to party
	dw	0,0,0		; yaw, pitch and roll angular velocities
	dw	0,0		; dispersion, and wind resistance damping
	db	0		; gravity
	db	1		; flag for boom on destruction
	dw	5000,5000,500	; rectangle of collision
IF cdct EQ 0
	dw	32
ELSE
	dw	@codeseg:donothing	; routine of destruction
ENDIF

fltsm1bomb	dw	4000,0		; 32 bit xyz coordinates
	dw	0,0
	dw	0,0
	dw	0		; yaw, pitch, and roll
	dw	0
	dw	0

	dw	0		; distance default, 0=near

	dw	9612,244	; 32-bit distance squared

	dw	19h		; object type 0= no-draw, destructable
	dw	1		; rotflg, 0= no rotation
	dd	977625289	; breakpoint for near dist squared
	dd	1067541266	; bkpt for med near dist sqrd
	dd	1067541266	; bkpt for med far dist sqrd
	dw	objflt1bomb		; address of near object
	dw	objflt1bomb		; address of med object
	dw	objbpt		; address of far object, usually point
	dw	0,0,50		; velocity for x,y,z
	dw	3200		; time left to party
	dw	0,0,0	; yaw, pitch and roll angular velocities
	dw	0,0		; dispersion, and wind resistance damping
	db	0		; gravity
	db	1		; flag for boom on destruction
	dw	bomblst,bomblst,bomblst	; rectangle of collision
IF cdct EQ 0
	dw	20
ELSE
	dw	@codeseg:bombtim	; routine of destruction
ENDIF

fltsm1mis	dw	4000,0		; 32 bit xyz coordinates
	dw	0,0
	dw	0,0
	dw	0		; yaw, pitch, and roll
	dw	0
	dw	0

	dw	0		; distance default, 0=near

	dw	9612,244	; 32-bit distance squared

	dw	59h		; object type 0= no-draw, 6pack of damage
	dw	1		; rotflg, 0= no rotation
	dd	977625289	; breakpoint for near dist squared
	dd	1067541266	; bkpt for med near dist sqrd
	dd	1067541266	; bkpt for med far dist sqrd
	dw	objflt1mis		; address of near object
	dw	objflt2mis		; address of med object
	dw	objbpt		; address of far object, usually point
	dw	0,0,50		; velocity for x,y,z
	dw	3200		; time left to party
	dw	0,0,1700	; yaw, pitch and roll angular velocities
	dw	0,0		; dispersion, and wind resistance damping
	db	55		; gravity
	db	1		; flag for boom on destruction
	dw	5000,5000,5000	; rectangle of collision
IF cdct EQ 0
	dw	21
ELSE
	dw	@codeseg:mistim	; routine of destruction
ENDIF

fltsm1aashell	dw	4000,0		; 32 bit xyz coordinates
	dw	0,0
	dw	0,0
	dw	0		; yaw, pitch, and roll
	dw	0
	dw	0

	db	0		; distance default, 0=near
	db	2		; this is a class 2 object

	dw	9612,244	; 32-bit distance squared

aashelltype	dw	39h	; object type 0= no-draw with plane crash bit
	db	0		; rotflg, 0= no rotation
	db	1		; two hits to take out
	dd	977625289	; breakpoint for near dist squared
	dd	1067541266	; bkpt for med near dist sqrd
	dd	1067541266	; bkpt for med far dist sqrd
	dw	objflt1aashell		; address of near object
	dw	objflt1aashell		; address of med object
	dw	objbpt		; address of far object, usually point
	dw	0,0,50		; velocity for x,y,z
	dw	3200		; time left to party
	dw	0,0,0	; yaw, pitch and roll angular velocities
	dw	10,0		; dispersion, and wind resistance damping
	db	0		; gravity
	db	1		; flag for boom on destruction
	dw	3000,3000,3000	; rectangle of collision
IF cdct EQ 0
	dw	22
ELSE
	dw	@codeseg:aashelltim	; routine of destruction
ENDIF

fltsm1aa	dw	4000,0		; 32 bit xyz coordinates
	dw	0,0
	dw	0,0
	dw	0		; yaw, pitch, and roll
	dw	0
	dw	0

	db	0		; distance default, 0=near
	db	2		; this is a class 2 object

	dw	9612,244	; 32-bit distance squared

	dw	0f9h		; object type 0= no-draw with plane crash bit
	db	2		; rotflg, 0= no rotation
	db	6		; six hits to take out
	dd	977625289	; breakpoint for near dist squared
	dd	1067541266	; bkpt for med near dist sqrd
	dd	1067541266	; bkpt for med far dist sqrd
	dw	objflt1aa		; address of near object
	dw	objflt1aa		; address of med object
	dw	objaapt		; address of far object, usually point
	dw	0,0,0		; velocity for x,y,z
	dw	32000		; time left to party
	dw	0,0,0	; yaw, pitch and roll angular velocities
	dw	0,0		; dispersion, and wind resistance damping
	db	0		; gravity
	db	1		; flag for boom on destruction
	dw	dbsz*2,dbsz*2,dbsz*2	; rectangle of collision
IF cdct EQ 0
	dw	23
ELSE
	dw	@codeseg:aatim	; routine of destruction
ENDIF

fltsm1dball	dw	4000,0		; 32 bit xyz coordinates
	dw	0,0
	dw	0,0
	dw	0		; yaw, pitch, and roll
	dw	0
	dw	0

	db	0		; distance default, 0=near
	db	2		; this is a class 2 object

	dw	9612,244	; 32-bit distance squared

	dw	79h		; object type 0= no-draw with plane crash bit
				; the 40h position bit means 6pak of dest
	db	2		; rotflg, 0= no rotation
	db	2		; two hits to take out
	dd	977625289	; breakpoint for near dist squared
	dd	1067541266	; bkpt for med near dist sqrd
	dd	1067541266	; bkpt for med far dist sqrd
	dw	objflt1dball		; address of near object
	dw	sobjflt1dball		; address of med object
	dw	objbpt		; address of far object, usually point
	dw	0,0,50		; velocity for x,y,z
	dw	3200		; time left to party
	dw	0,0,0	; yaw, pitch and roll angular velocities
	dw	0,0		; dispersion, and wind resistance damping
	db	0		; gravity
	db	1		; flag for boom on destruction
	dw	dbsz*2,dbsz*2,dbsz*2	; rectangle of collision
IF cdct EQ 0
	dw	24
ELSE
	dw	@codeseg:dballtim	; routine of destruction
ENDIF

fltsm1	dw	4000,0		; 32 bit xyz coordinates
	dw	0,0
	dw	0,0
	dw	0		; yaw, pitch, and roll
	dw	0
	dw	0

	dw	0		; distance default, 0=near

	dw	9612,244	; 32-bit distance squared

	dw	19h		; object type 0= no-draw
	dw	1		; rotflg, 0= no rotation
	dd	977625289	; breakpoint for near dist squared
	dd	1067541266	; bkpt for med near dist sqrd
	dd	1067541266	; bkpt for med far dist sqrd
	dw	objflt1		; address of near object
	dw	objflt1		; address of med object
	dw	objbpt		; address of far object, usually point
	dw	0,0,0		; velocity for x,y,z
	dw	3200		; time left to party
	dw	0,0,1700	; yaw, pitch and roll angular velocities
	dw	20,16000	; dispersion, and wind resistance damping
	dw	54		; gravity
	dw	l*15,l*15,2*l	; rectangle of collision
IF cdct EQ 0
	dw	25
ELSE
	dw	@codeseg:flttim	; routine of destruction
ENDIF

fltsm2	dw	4000,0		; 32 bit xyz coordinates
	dw	0,0
	dw	0,0
	dw	0		; yaw, pitch, and roll
	dw	0
	dw	0

	dw	0		; distance default, 0=near

	dw	9612,244	; 32-bit distance squared

	dw	19h		; object type 0= no-draw
	dw	1		; rotflg, 0= no rotation
	dd	977625289	; breakpoint for near dist squared
	dd	1067541266	; bkpt for med near dist sqrd
	dd	1067541266	; bkpt for med far dist sqrd
	dw	objflt2		; address of near object
	dw	objflt2		; address of med object
	dw	objbpt		; address of far object, usually point
	dw	0,0,0		; velocity for x,y,z
	dw	3200		; time left to party
	dw	1000,-5000,-700	; yaw, pitch and roll angular velocities
	dw	200,32000	; dispersion, and wind resistance damping
	db	54,0		; gravity, and destroy with boom
	dw	6000,6000,6000	; rectangle of collision
IF cdct EQ 0
	dw	26
ELSE
	dw	@codeseg:flttim	; routine of destruction
ENDIF

smgms	dw	4000,0		; 32 bit xyz coordinates
	dw	0,0
	dw	0,0
	dw	0		; yaw, pitch, and roll
	dw	0
	dw	0

	db	0		; distance default, 0=near
	db	2		; this is a class 2 object

	dw	9612,244	; 32-bit distance squared

	dw	011h		; object type 0= no-draw bit 4=destructable
	db	0		; rotflg, 0= no rotation
	db	5		; 5 hits to bring down a fuel dump
	dd	977625289	; breakpoint for near dist squared
	dd	367541266	; bkpt for med near dist sqrd
	dd	1067541266	; bkpt for med far dist sqrd
	dw	gmobj2		; address of near object
	dw	gmobj3		; address of med object
	dw	gmobj3		; address of med object
	dw	0,0,0		; xyz velocity of object
	dw	32000		; done flag 0= no move
	dw	0,0,0		; yaw, pitch and roll angular velocities
	dw	0,0		; dispersion, and wind resistance damping
	dw	0		; gravity
	dw	xgmx,xgmx,xgmx	; rectangle of collision
IF cdct EQ 0
	dw	33
ELSE
	dw	@codeseg:gmdest	; routine of destruction
ENDIF


gms	dw	4000,0		; 32 bit xyz coordinates
	dw	0,0
	dw	0,0
	dw	0		; yaw, pitch, and roll
	dw	0
	dw	0

	db	0		; distance default, 0=near
	db	2		; this is a class 2 object

	dw	9612,244	; 32-bit distance squared

	dw	0b9h		; object type 0= no-draw bit 4=destructable
	db	0		; rotflg, 0= no rotation
	db	13		; 5 hits to bring down a fuel dump
	dd	977625289	; breakpoint for near dist squared
	dd	367541266	; bkpt for med near dist sqrd
	dd	1067541266	; bkpt for med far dist sqrd
	dw	gmobj1		; address of near object
	dw	sgmobj1		; address of med object
	dw	ssgmobj1		; address of med object
	dw	0,0,0		; xyz velocity of object
	dw	32000		; done flag 0= no move
	dw	0,0,0		; yaw, pitch and roll angular velocities
	dw	0,0		; dispersion, and wind resistance damping
	dw	0		; gravity
	dw	xgmx,xgmx,xgmx	; rectangle of collision
IF cdct EQ 0
	dw	27
ELSE
	dw	@codeseg:gmdest	; routine of destruction
ENDIF

objsurv	dw	-1,roadx-2	; 32 bit xyz coordinates
	dw	16000,0
	dw	twszl*2,0		; lift off the ground
	dw	0		; yaw, pitch, and roll
	dw	0
	dw	0

	db	0		; distance default, 0=near
	db	0		; this is a class 1 object

	dw	9612,244	; 32-bit distance squared

	dw	111h		; object type 0= no-draw bit 4=destructable
				; take coords as wall type
	db	2		; rotflg, 0= no rotation
	db	10		; 10 hits to make it blow
	dd	977625289	; breakpoint for near dist squared
	dd	256680332	; bkpt for med near dist sqrd
	dd	1067541266		; bkpt for med far dist sqrd
	dw	survobj		; address of near object
	dw	survobj		; address of near object
	dw	ssurvobj		; address of med object
	dw	0,0,0		; xyz velocity of object
	dw	32000		; done flag 0= no move
	dw	0,0,0		; yaw, pitch and roll angular velocities
	dw	0,0		; dispersion, and wind resistance damping
	dw	0		; gravity
	dw	0,0,0	; rectangle of collision
IF cdct EQ 0
	dw	31
ELSE
	dw	@codeseg:donothing	; routine of destruction
ENDIF

objfn1	dw	-1,roadx-2	; 32 bit xyz coordinates
	dw	16000,0
	dw	0,0		; lift off the ground
	dw	0		; yaw, pitch, and roll
	dw	0
	dw	0

	db	0		; distance default, 0=near
	db	1		; this is a class 1 object

	dw	9612,244	; 32-bit distance squared

	dw	111h		; object type 0= no-draw bit 4=destructable
				; take coords as wall type
	db	2		; rotflg, 0= no rotation
	db	10		; 10 hits to make it blow
	dd	977625289	; breakpoint for near dist squared
	dd	256680332	; bkpt for med near dist sqrd
	dd	1067541266		; bkpt for med far dist sqrd
	dw	fenobj
	dw	sfenobj
	dw	ssfenobj
	dw	0,0,0		; xyz velocity of object
	dw	32000		; done flag 0= no move
	dw	0,0,0		; yaw, pitch and roll angular velocities
	dw	0,0		; dispersion, and wind resistance damping
	dw	0		; gravity
	dw	fenszl*2,500,fenszh*2	; rectangle of collision
IF cdct EQ 0
	dw	37
ELSE
	dw	@codeseg:donothing	; routine of destruction
ENDIF

objfn1a	dw	-1,roadx-2	; 32 bit xyz coordinates
	dw	16000,0
	dw	0,0		; lift off the ground
	dw	0		; yaw, pitch, and roll
	dw	0
	dw	0

	db	0		; distance default, 0=near
	db	1		; this is a class 1 object

	dw	9612,244	; 32-bit distance squared

	dw	111h		; object type 0= no-draw bit 4=destructable
				; take coords as wall type
	db	2		; rotflg, 0= no rotation
	db	10		; 10 hits to make it blow
	dd	977625289	; breakpoint for near dist squared
	dd	256680332	; bkpt for med near dist sqrd
	dd	1067541266		; bkpt for med far dist sqrd
	dw	fenobja
	dw	sfenobja
	dw	ssfenobja
	dw	0,0,0		; xyz velocity of object
	dw	32000		; done flag 0= no move
	dw	0,0,0		; yaw, pitch and roll angular velocities
	dw	0,0		; dispersion, and wind resistance damping
	dw	0		; gravity
	dw	500,fenszl*2,fenszh*2	; rectangle of collision
IF cdct EQ 0
	dw	38
ELSE
	dw	@codeseg:donothing	; routine of destruction
ENDIF

objfn1b	dw	-1,roadx-2	; 32 bit xyz coordinates
	dw	16000,0
	dw	0,0		; lift off the ground
	dw	0		; yaw, pitch, and roll
	dw	0
	dw	0

	db	0		; distance default, 0=near
	db	1		; this is a class 1 object

	dw	9612,244	; 32-bit distance squared

	dw	111h		; object type 0= no-draw bit 4=destructable
				; take coords as wall type
	db	2		; rotflg, 0= no rotation
	db	10		; 10 hits to make it blow
	dd	977625289	; breakpoint for near dist squared
	dd	256680332	; bkpt for med near dist sqrd
	dd	1067541266		; bkpt for med far dist sqrd
	dw	fenobjb
	dw	sfenobjb
	dw	ssfenobjb
	dw	0,0,0		; xyz velocity of object
	dw	32000		; done flag 0= no move
	dw	0,0,0		; yaw, pitch and roll angular velocities
	dw	0,0		; dispersion, and wind resistance damping
	dw	0		; gravity
	dw	fenszl*2,fenszl*2,fenszh*2	; rectangle of collision
IF cdct EQ 0
	dw	39
ELSE
	dw	@codeseg:donothing	; routine of destruction
ENDIF

objbb	dw	-1,roadx-2	; 32 bit xyz coordinates
	dw	16000,0
	dw	bbsize,0	; lift off the ground
	dw	0		; yaw, pitch, and roll
	dw	0
	dw	0

	db	0		; distance default, 0=near
	db	1		; this is a class 1 object

	dw	9612,244	; 32-bit distance squared

	dw	031h		; object type 0= no-draw bit 4=destructable
				; take coords as wall type
	db	2		; rotflg, 0= no rotation
	db	10		; 10 hits to make it blow
	dd	977625289	; breakpoint for near dist squared
	dd	1067541266		; bkpt for med far dist sqrd
	dd	1067541266		; bkpt for med far dist sqrd
	dw	bbobj
	dw	bbobj
	dw	bbobj
	dw	0,0,0		; xyz velocity of object
	dw	32000		; done flag 0= no move
	dw	0,0,0		; yaw, pitch and roll angular velocities
	dw	0,0		; dispersion, and wind resistance damping
	dw	0		; gravity
	dw	bbsize2,bbsize2,bbsize2	; rectangle of collision
IF cdct EQ 0
	dw	40
ELSE
	dw	@codeseg:donothing	; routine of destruction
ENDIF


objbbsm	dw	-1,roadx-2	; 32 bit xyz coordinates
	dw	16000,0
	dw	bbsize,0	; lift off the ground
	dw	0		; yaw, pitch, and roll
	dw	0
	dw	0

	db	0		; distance default, 0=near
	db	1		; this is a class 1 object

	dw	9612,244	; 32-bit distance squared

	dw	031h		; object type 0= no-draw bit 4=destructable
				; take coords as wall type
	db	2		; rotflg, 0= no rotation
	db	10		; 10 hits to make it blow
	dd	977625289	; breakpoint for near dist squared
	dd	1067541266		; bkpt for med far dist sqrd
	dd	1067541266		; bkpt for med far dist sqrd
	dw	bbsmobj
	dw	bbsmobj
	dw	nulobj
	dw	0,0,0		; xyz velocity of object
	dw	32000		; done flag 0= no move
	dw	0,0,0		; yaw, pitch and roll angular velocities
	dw	0,0		; dispersion, and wind resistance damping
	dw	0		; gravity
	dw	bbsize,bbsize,bbsize	; rectangle of collision
IF cdct EQ 0
	dw	41
ELSE
	dw	@codeseg:donothing	; routine of destruction
ENDIF

objmort	dw	-1,roadx-2	; 32 bit xyz coordinates
	dw	16000,0
	dw	0,0	; lift off the ground
	dw	0		; yaw, pitch, and roll
	dw	0
	dw	0

	db	0		; distance default, 0=near
	db	3		; this is a class 1 object

	dw	9612,244	; 32-bit distance squared

	dw	039h		; object type 0= no-draw bit 4=destructable
				; take coords as wall type
	db	2		; rotflg, 0= no rotation
	db	40		; 10 hits to make it blow
	dd	977625289	; breakpoint for near dist squared
	dd	1067541266		; bkpt for med far dist sqrd
	dd	1067541266		; bkpt for med far dist sqrd
	dw	mortobj
	dw	mortobj
	dw	nulobj
	dw	0,0,0		; xyz velocity of object
	dw	morttime		; done flag 0= no move
	dw	0,0,0		; yaw, pitch and roll angular velocities
	dw	0,0		; dispersion, and wind resistance damping
	dw	0		; gravity
	dw	mortsz*2,mortsz*2,mortsz*2	; rectangle of collision
IF cdct EQ 0
	dw	42
ELSE
	dw	@codeseg:donothing	; routine of destruction
ENDIF

objdhq	dw	4000,0		; 32 bit xyz coordinates
	dw	0,0
	dw	0,0
	dw	0		; yaw, pitch, and roll
	dw	0
	dw	0

	db	0		; distance default, 0=near
	db	2		; this is a class 2 object

	dw	9612,244	; 32-bit distance squared

	dw	011h		; object type 0= no-draw bit 4=destructable
	db	0		; rotflg, 0= no rotation
	db	5		; 5 hits to bring down a fuel dump
	dd	977625289	; breakpoint for near dist squared
	dd	367541266	; bkpt for med near dist sqrd
	dd	1067541266	; bkpt for med far dist sqrd
	dw	dhqobj		; address of near object
	dw	dhqobj		; address of med object
	dw	dhqobj		; address of med object
	dw	0,0,0		; xyz velocity of object
	dw	32000		; done flag 0= no move
	dw	0,0,0		; yaw, pitch and roll angular velocities
	dw	0,16000	; dispersion, and wind resistance damping
	dw	0		; gravity
	dw	xgmx,xgmx,xgmx	; rectangle of collision
	dw	43

objlwallx	dd	wallsz*2	; 32 bit xyz coordinates
	dw	0,0
	dw	wallsz,0		; lift off the ground
	dw	0		; yaw, pitch, and roll
	dw	0
	dw	0

	db	0		; distance default, 0=near
	db	3		; this is a class 1 object

	dw	9612,244	; 32-bit distance squared

	dw	131h		; object type 0= no-draw bit 4=destructable
				; wallbit 100h set to say it's a wall
	db	2		; rotflg, 0= no rotation
	db	50		; fifty hits to take out site
	dd	977625289	; breakpoint for near dist squared
	dd	1067541266	; bkpt for med far dist sqrd
	dd	1067541266	; bkpt for med far dist sqrd
	dw	lwxobj		; address of near object
	dw	lwxobj		; address of near object
	dw	lwxobj		; address of near object
	dw	0,0,0		; xyz velocity of object
	dw	32000		; done flag 0= no move
	dw	0,0,0		; yaw, pitch and roll angular velocities
	dw	0,0		; dispersion, and wind resistance damping
	dw	0		; gravity
	dw	3000,2*wallsz,wallsz	; rectangle of collision
IF cdct EQ 0
	dw	45
ELSE
	dw	@codeseg:walltim	; routine of destruction
ENDIF

objlwally	dw	0,0	; 32 bit xyz coordinates
	dd	wallsz*8
	dd	wallsz*2		; lift off the ground
	dw	0		; yaw, pitch, and roll
	dw	0
	dw	0

	db	0		; distance default, 0=near
	db	3		; this is a class 1 object

	dw	9612,244	; 32-bit distance squared

	dw	131h		; object type 0= no-draw bit 4=destructable
				; wallbit 100h set to say it's a wall
	db	2		; rotflg, 0= no rotation
	db	50		; fifty hits to take out site
	dd	977625289	; breakpoint for near dist squared
	dd	1067541266	; bkpt for med far dist sqrd
	dd	1067541266	; bkpt for med far dist sqrd
	dw	lwyobj		; address of near object
	dw	lwyobj		; address of near object
	dw	lwyobj		; address of near object
	dw	0,0,0		; xyz velocity of object
	dw	32000		; done flag 0= no move
	dw	0,0,0		; yaw, pitch and roll angular velocities
	dw	0,0		; dispersion, and wind resistance damping
	dw	0		; gravity
	dw	2*wallsz,3000,wallsz	; rectangle of collision
IF cdct EQ 0
	dw	46
ELSE
	dw	@codeseg:walltim	; routine of destruction
ENDIF

objlwallz	dd	0	; 32 bit xyz coordinates
	dd	0
	dw	2*wallsz,0		; lift off the ground
	dw	0		; yaw, pitch, and roll
	dw	0
	dw	0

	db	0		; distance default, 0=near
	db	3		; this is a class 1 object

	dw	9612,244	; 32-bit distance squared

	dw	131h		; object type 0= no-draw bit 4=destructable
				; wallbit 100h set to say it's a wall
	db	2		; rotflg, 0= no rotation
	db	50		; fifty hits to take out site
	dd	977625289	; breakpoint for near dist squared
	dd	1067541266	; bkpt for med far dist sqrd
	dd	1067541266	; bkpt for med far dist sqrd
	dw	lwzobj		; address of med object
	dw	lwzobj		; address of med object
	dw	lwzobj		; address of med object
	dw	0,0,0		; xyz velocity of object
	dw	32000		; done flag 0= no move
	dw	0,0,0		; yaw, pitch and roll angular velocities
	dw	0,0		; dispersion, and wind resistance damping
	dw	0		; gravity
	dw	2*wallsz,2*wallsz,3000	; rectangle of collision
IF cdct EQ 0
	dw	47
ELSE
	dw	@codeseg:walltim	; routine of destruction
ENDIF

objlwallz1	dd	0	; 32 bit xyz coordinates
	dd	0
	dw	2*wallsz,0		; lift off the ground
	dw	0		; yaw, pitch, and roll
	dw	0
	dw	0

	db	0		; distance default, 0=near
	db	3		; this is a class 1 object

	dw	9612,244	; 32-bit distance squared

	dw	131h		; object type 0= no-draw bit 4=destructable
				; wallbit 100h set to say it's a wall
	db	2		; rotflg, 0= no rotation
	db	50		; fifty hits to take out site
	dd	977625289	; breakpoint for near dist squared
	dd	1067541266	; bkpt for med far dist sqrd
	dd	1067541266	; bkpt for med far dist sqrd
	dw	lwz1obj		; address of near object
	dw	lwz1obj		; address of med object
	dw	lwz1obj		; address of med object
	dw	0,0,0		; xyz velocity of object
	dw	32000		; done flag 0= no move
	dw	0,0,0		; yaw, pitch and roll angular velocities
	dw	0,0		; dispersion, and wind resistance damping
	dw	0		; gravity
	dw	wallsz,wallsz,3000	; rectangle of collision
IF cdct EQ 0
	dw	44
ELSE
	dw	@codeseg:walltim	; routine of destruction
ENDIF


objrv	dw	8000,roadx-1	; 32 bit xyz coordinates
	dw	8000,0
	dw	rvh/10,0		; lift off the ground
	dw	0		; yaw, pitch, and roll
	dw	0
	dw	0

	db	0		; distance default, 0=near
	db	1		; this is a class 1 object

	dw	9612,244	; 32-bit distance squared

	dw	07019h		; object type 0= no-draw bit 4=destructable
	dw	3		; rotflg, 0= no rotation
	dd	977625289	; breakpoint for near dist squared
	dd	256680332	; bkpt for med near dist sqrd
	dd	16680332	; bkpt for med far dist sqrd
	dw	rvobj		; address of near object
	dw	rvobj		; address of med object
	dw	rvobj		; address of med object
	dw	0,0,0		; xyz velocity of object
	dw	32000		; done flag 0= no move
	dw	0,0,0		; yaw, pitch and roll angular velocities
	dw	0,0		; dispersion, and wind resistance damping
	dw	0		; gravity
	dw	rvl,rvl,rvl	; rectangle of collision
IF cdct EQ 0
	dw	48
ELSE
	dw	@codeseg:fdest	; routine of destruction
ENDIF


IF slalom
objshell	dw	0,0		; 32 bit xyz coordinates
	dw	0,0
	dw	shellsz,0
	dw	0		; yaw, pitch, and roll
	dw	0
	dw	0

	db	0		; distance default, 0=near
	db	2		; this is a class 2 object

	dw	9612,244	; 32-bit distance squared

	dw	1b9h		; object type 0= no-draw bit 4=destructable
	db	0		; rotflg, 0= no rotation
	db	1		; 5 hits to bring down a fuel dump
	dd	977625289	; breakpoint for near dist squared
	dd	556680332	; bkpt for med near dist sqrd
	dd	16680332	; bkpt for med far dist sqrd
	dw	shellobj		; address of near object
	dw	shellobj		; address of med object
	dw	streeobj		; address of med object
	dw	0,0,0		; xyz velocity of object
	dw	32000		; done flag 0= no move
	dw	0,0,0		; yaw, pitch and roll angular velocities
	dw	0,0		; dispersion, and wind resistance damping
	dw	0		; gravity
	dw	treerad,treerad,treeht*4 ; rectangle of collision
	dw	49
ELSE
objshell	dw	0,0		; 32 bit xyz coordinates
	dw	0,0
	dw	shellsz,0
	dw	0		; yaw, pitch, and roll
	dw	0
	dw	0

	db	0		; distance default, 0=near
	db	2		; this is a class 2 object

	dw	9612,244	; 32-bit distance squared

	dw	1b9h		; object type 0= no-draw bit 4=destructable
	db	0		; rotflg, 0= no rotation
	db	1		; 5 hits to bring down a fuel dump
	dd	977625289	; breakpoint for near dist squared
	dd	1067541266	; bkpt for med far dist sqrd
	dd	1067541266	; bkpt for med far dist sqrd
	dw	shellobj		; address of near object
	dw	shellobj		; address of med object
	dw	shellobj		; address of med object
	dw	0,0,0		; xyz velocity of object
	dw	32000		; done flag 0= no move
	dw	0,0,0		; yaw, pitch and roll angular velocities
	dw	0,0		; dispersion, and wind resistance damping
	dw	0		; gravity
	dw	treerad,treerad,treeht	; rectangle of collision
	dw	49
ENDIF

IF slalom
objbmr	dw	0,0	; 32 bit xyz coordinates
	dw	0,0
	dw	frmzl,0		; lift off the ground
	dw	0		; yaw, pitch, and roll
	dw	0
	dw	0

	db	0		; distance default, 0=near
	db	2		; this is a class 1 object

	dw	9612,244	; 32-bit distance squared

	dw	1b9h		; object type 0= no-draw bit 4=destructable
	db	3		; rotflg, 0= no rotation
	db	bmrhits		; takes 40 hits to bring down
	dd	977625289	; breakpoint for near dist squared
	dd	977625289	; breakpoint for near dist squared
	dd	977625289	; breakpoint for near dist squared
	dw	bmrobj		; address of near object
	dw	bmrobj		; address of med object
	dw	objblkpt		; address of med object
	dw	0,0,0		; xyz velocity of object
	dw	32000		; done flag 0= no move
	dw	0,0,0		; yaw, pitch and roll angular velocities
	dw	0,0		; dispersion, and wind resistance damping
	dw	0		; gravity
	dw	frmzx,frmzy,frmzl
	dw	50
ELSE
objbmr	dw	8000,roadx-1	; 32 bit xyz coordinates
	dw	8000,0
	dw	30000,0		; lift off the ground
	dw	0		; yaw, pitch, and roll
	dw	0
	dw	0

	db	0		; distance default, 0=near
	db	2		; this is a class 1 object

	dw	9612,244	; 32-bit distance squared

	dw	1f9h		; object type 0= no-draw bit 4=destructable
	db	3		; rotflg, 0= no rotation
	db	bmrhits		; takes 40 hits to bring down
	dd	977625289	; breakpoint for near dist squared
	dd	977625289	; breakpoint for near dist squared
	dd	977625289	; breakpoint for near dist squared
	dw	bmrobj		; address of near object
	dw	bmrobj		; address of med object
	dw	objblkpt		; address of med object
	dw	0,0,0		; xyz velocity of object
	dw	32000		; done flag 0= no move
	dw	0,0,0		; yaw, pitch and roll angular velocities
	dw	0,0		; dispersion, and wind resistance damping
	dw	0		; gravity
	dw	fsr*2,fsr*2,fstoph	; rectangle of collision
	dw	50
ENDIF

IF slalom
objbmrst	dw	-1,roadx	; 32 bit xyz coordinates
	dw	8000,0
	dw	ehmin,0		; lift off the ground
	dw	-8000		; yaw, pitch, and roll
	dw	-2456
	dw	0

	db	0		; distance default, 0=near
	db	1		; this is a class 1 object

	dw	9612,244	; 32-bit distance squared

	dw	0b9h		; object type 0= no-draw bit 4=destructable
;	dw	11h
	db	3		; rotflg, 0= no rotation
	db	2		; takes two hits
	dd	977625289	; breakpoint for near dist squared
	dd	256680332	; bkpt for med near dist sqrd
	dd	16680332	; bkpt for med far dist sqrd
	dw	splnplyobj		; address of med object
	dw	ssplnobj		; address of near object
	dw	ssplnobj		; address of med object
	dw	0,0,0		; xyz velocity of object
	dw	32000		; done flag 0= no move
	dw	0,0,0		; yaw, pitch and roll angular velocities
	dw	0,0		; dispersion, and wind resistance damping
	dw	0		; gravity
	dw	lp4*2,lp4*2,lp4*2	; rectangle of collision
	dw	51
ELSE
objbmrst	dw	-1,roadx	; 32 bit xyz coordinates
	dw	16000,0
	dw	4*ltw,0		; lift off the ground
	dw	0		; yaw, pitch, and roll
	dw	0
	dw	0

	db	0		; distance default, 0=near
	db	2		; this is a class 1 object

	dw	9612,244	; 32-bit distance squared

	dw	0b9h		; object type 0= no-draw bit 4=destructable
	db	2		; rotflg, 0= no rotation
	db	100		; fifty hits to take out site
	dd	977625289	; breakpoint for near dist squared
	dd	1067541266	; bkpt for med far dist sqrd
	dd	1067541266	; bkpt for med far dist sqrd
	dw	bmrstobj		; address of near object
	dw	bmrstobj		; address of near object
	dw	objflshpt		; address of med object
	dw	0,0,0		; xyz velocity of object
	dw	1		; done flag 0= no move
	dw	0,0,0		; yaw, pitch and roll angular velocities
	dw	0,0		; dispersion, and wind resistance damping
	dw	0		; gravity
	dw	fsr*2,fsr*2,fstoph	; rectangle of collision
	dw	51
ENDIF


objtet	dw	0,0		; 32 bit xyz coordinates
	dw	0,0
	dw	tetht,0
	dw	0		; yaw, pitch, and roll
	dw	0
	dw	0

	db	0		; distance default, 0=near
	db	2		; this is a class 2 object

	dw	9612,244	; 32-bit distance squared

	dw	1b9h		; object type 0= no-draw bit 4=destructable
	db	3		; rotflg, 0= no rotation
	db	13		; 5 hits to bring down a fuel dump
	dd	977625289	; breakpoint for near dist squared
	dd	1067541266	; bkpt for med far dist sqrd
	dd	1067541266	; bkpt for med far dist sqrd
	dw	tetobj		; address of near object
	dw	tetobj		; address of med object
	dw	objblkpt		; address of med object
	dw	0,0,0		; xyz velocity of object
	dw	32000		; done flag 0= no move
	dw	1500,0,0	; yaw, pitch and roll angular velocities
	dw	0,0		; dispersion, and wind resistance damping
	dw	0		; gravity
IF slalom
	dw	tet86*2,tet86*2,(tet86*2)+(tetht) ; rectangle of collision
ELSE
	dw	tet86*2,tet86*2,tet86*2 ; rectangle of collision
ENDIF
	dw	52


objbmrmo	dw	8000,roadx-1	; 32 bit xyz coordinates
	dw	8000,0
	dw	30000,0		; lift off the ground
	dw	0		; yaw, pitch, and roll
	dw	0
	dw	0

	db	0		; distance default, 0=near
	db	2		; this is a class 1 object

	dw	9612,244	; 32-bit distance squared

	dw	1f9h		; object type 0= no-draw bit 4=destructable
	db	3		; rotflg, 0= no rotation
	db	bmrhits		; takes 40 hits to bring down
	dd	977625289	; breakpoint for near dist squared
	dd	977625289	; breakpoint for near dist squared
	dd	977625289	; breakpoint for near dist squared
	dw	bmrobj		; address of near object
	dw	bmrobj		; address of med object
	dw	objflshpt		; address of med object
	dw	0,0,0		; xyz velocity of object
	dw	32767		; done flag 0= no move
	dw	0,0,0		; yaw, pitch and roll angular velocities
	dw	0,0		; dispersion, and wind resistance damping
	dw	0		; gravity
	dw	fsr*2,fsr*2,fstoph	; rectangle of collision
	dw	53

objslwallx	dd	wallsz*2	; 32 bit xyz coordinates
	dw	0,0
	dw	wallsz,0		; lift off the ground
	dw	0		; yaw, pitch, and roll
	dw	0
	dw	0

	db	0		; distance default, 0=near
	db	3		; this is a class 1 object

	dw	9612,244	; 32-bit distance squared

	dw	131h		; object type 0= no-draw bit 4=destructable
				; wallbit 100h set to say it's a wall
	db	2		; rotflg, 0= no rotation
	db	50		; fifty hits to take out site
	dd	977625289	; breakpoint for near dist squared
	dd	1067541266	; bkpt for med far dist sqrd
	dd	1067541266	; bkpt for med far dist sqrd
	dw	slwxobj1		; address of near object
	dw	slwxobj		; address of near object
	dw	nulobj		; address of near object
	dw	0,0,0		; xyz velocity of object
	dw	32000		; done flag 0= no move
	dw	0,0,0		; yaw, pitch and roll angular velocities
	dw	0,0		; dispersion, and wind resistance damping
	dw	0		; gravity
	dw	3000/2,2*wallsz/2,wallsz/2	; rectangle of collision
IF cdct EQ 0
	dw	54
ELSE
	dw	@codeseg:walltim	; routine of destruction
ENDIF

objslwally	dw	0,0	; 32 bit xyz coordinates
	dd	wallsz*8
	dd	wallsz*2		; lift off the ground
	dw	0		; yaw, pitch, and roll
	dw	0
	dw	0

	db	0		; distance default, 0=near
	db	3		; this is a class 1 object

	dw	9612,244	; 32-bit distance squared

	dw	131h		; object type 0= no-draw bit 4=destructable
				; wallbit 100h set to say it's a wall
	db	2		; rotflg, 0= no rotation
	db	50		; fifty hits to take out site
	dd	977625289	; breakpoint for near dist squared
	dd	1067541266	; bkpt for med far dist sqrd
	dd	1067541266	; bkpt for med far dist sqrd
	dw	slwyobj1		; address of near object
	dw	slwyobj		; address of near object
	dw	nulobj		; address of near object
	dw	0,0,0		; xyz velocity of object
	dw	32000		; done flag 0= no move
	dw	0,0,0		; yaw, pitch and roll angular velocities
	dw	0,0		; dispersion, and wind resistance damping
	dw	0		; gravity
	dw	wallsz,3000/2,wallsz/2	; rectangle of collision
IF cdct EQ 0
	dw	55
ELSE
	dw	@codeseg:walltim	; routine of destruction
ENDIF

objslwallz	dd	0	; 32 bit xyz coordinates
	dd	0
	dw	2*wallsz,0		; lift off the ground
	dw	0		; yaw, pitch, and roll
	dw	0
	dw	0

	db	0		; distance default, 0=near
	db	3		; this is a class 1 object

	dw	9612,244	; 32-bit distance squared

	dw	131h		; object type 0= no-draw bit 4=destructable
				; wallbit 100h set to say it's a wall
	db	2		; rotflg, 0= no rotation
	db	50		; fifty hits to take out site
	dd	977625289	; breakpoint for near dist squared
	dd	1067541266	; bkpt for med far dist sqrd
	dd	1067541266	; bkpt for med far dist sqrd
	dw	slwzobj1		; address of med object
	dw	slwzobj		; address of med object
	dw	nulobj		; address of med object
	dw	0,0,0		; xyz velocity of object
	dw	32000		; done flag 0= no move
	dw	0,0,0		; yaw, pitch and roll angular velocities
	dw	0,0		; dispersion, and wind resistance damping
	dw	0		; gravity
	dw	wallsz,wallsz,3000/2	; rectangle of collision
IF cdct EQ 0
	dw	56
ELSE
	dw	@codeseg:walltim	; routine of destruction
ENDIF

objal	dd	0	; 32 bit xyz coordinates
	dd	0
	dw	0,0		; lift off the ground
	dw	0		; yaw, pitch, and roll
	dw	0
	dw	0

	db	0		; distance default, 0=near
	db	2		; this is a class 2 object

	dw	9612,244	; 32-bit distance squared

	dw	135h		; object type 0= no-draw bit 4=destructable
				; wallbit 100h set to say it's a wall
	db	3		; rotflg, 0= no rotation
	db	3		; fifty hits to take out site
	dd	977625289	; breakpoint for near dist squared
	dd	1067541266	; bkpt for med far dist sqrd
	dd	1067541266	; bkpt for med far dist sqrd
	dw	alobj		; address of med object
	dw	alobj		; address of med object
	dw	nulobj		; address of med object
	dw	0,0,0		; xyz velocity of object
	dw	32000		; done flag 0= no move
	dw	0,0,0		; yaw, pitch and roll angular velocities
	dw	0,0		; dispersion, and wind resistance damping
	dw	20		; gravity
	dw	alsz,alsz,(alctr+alsz/2)*2	; rectangle of collision
IF cdct EQ 0
	dw	57
ELSE
	dw	@codeseg:walltim	; routine of destruction
ENDIF


objxp	dd	0	; 32 bit xyz coordinates
	dd	0
	dw	xpszh2*2,0		; lift off the ground
	dw	0		; yaw, pitch, and roll
	dw	0
	dw	0

	db	0		; distance default, 0=near
	db	2		; this is a class 2 object

	dw	9612,244	; 32-bit distance squared

	dw	135h		; object type 0= no-draw bit 4=destructable
				; wallbit 100h set to say it's a wall
	db	3		; rotflg, 0= no rotation
	db	3		; fifty hits to take out site
	dd	977625289	; breakpoint for near dist squared
	dd	1067541266	; bkpt for med far dist sqrd
	dd	1067541266	; bkpt for med far dist sqrd
	dw	xpobj		; address of med object
	dw	xpobj		; address of med object
	dw	nulobj		; address of med object
	dw	0,0,0		; xyz velocity of object
	dw	32000		; done flag 0= no move
	dw	0,0,0		; yaw, pitch and roll angular velocities
	dw	0,0		; dispersion, and wind resistance damping
	dw	0		; gravity
	dw	xpszcr*2,xpszl,xpszh	; rectangle of collision
IF cdct EQ 0
	dw	58
ELSE
	dw	@codeseg:walltim	; routine of destruction
ENDIF

objstep	dd	0	; 32 bit xyz coordinates
	dd	0
	dw	2*stepsz,0		; lift off the ground
	dw	0		; yaw, pitch, and roll
	dw	0
	dw	0

	db	0		; distance default, 0=near
	db	3		; this is a class 1 object

	dw	9612,244	; 32-bit distance squared

	dw	131h		; object type 0= no-draw bit 4=destructable
				; wallbit 100h set to say it's a wall
	db	2		; rotflg, 0= no rotation
	db	50		; fifty hits to take out site
	dd	977625289	; breakpoint for near dist squared
	dd	1067541266	; bkpt for med far dist sqrd
	dd	1067541266	; bkpt for med far dist sqrd
	dw	stepobj1	; address of med object
	dw	stepobj		; address of med object
	dw	nulobj		; address of med object
	dw	0,0,0		; xyz velocity of object
	dw	32000		; done flag 0= no move
	dw	0,0,0		; yaw, pitch and roll angular velocities
	dw	0,0		; dispersion, and wind resistance damping
	dw	0		; gravity
	dw	stepsz*2,stepsz*2,750	; rectangle of collision
IF cdct EQ 0
	dw	59
ELSE
	dw	@codeseg:walltim	; routine of destruction
ENDIF

objpstep	dd	0	; 32 bit xyz coordinates
	dd	0
	dw	2*stepsz,0		; lift off the ground
	dw	0		; yaw, pitch, and roll
	dw	0
	dw	0

	db	0		; distance default, 0=near
	db	3		; this is a class 1 object

	dw	9612,244	; 32-bit distance squared

	dw	131h		; object type 0= no-draw bit 4=destructable
				; wallbit 100h set to say it's a wall
	db	2		; rotflg, 0= no rotation
	db	50		; fifty hits to take out site
	dd	977625289	; breakpoint for near dist squared
	dd	1067541266	; bkpt for med far dist sqrd
	dd	1067541266	; bkpt for med far dist sqrd
	dw	pstepobj	; address of med object
	dw	pstepobj		; address of med object
	dw	nulobj		; address of med object
	dw	0,0,0		; xyz velocity of object
	dw	32000		; done flag 0= no move
	dw	0,0,0		; yaw, pitch and roll angular velocities
	dw	0,0		; dispersion, and wind resistance damping
	dw	0		; gravity
	dw	stepsz*2,stepsz*2,750	; rectangle of collision
IF cdct EQ 0
	dw	60
ELSE
	dw	@codeseg:walltim	; routine of destruction
ENDIF

.ends

end
