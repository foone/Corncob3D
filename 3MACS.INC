
mdata1	MACRO
propvec	dw	10,0,0
dxvec	dw	6 dup (?)		; distance away of ground point
ndemobytes	equ	37		; 37 bytes per frame in expanded format
demobyte	db	0		; 0 means expanded format
oxeff	dw	?,?
oyeff	dw	?,?
ozeff	dw	?,?
orveceff	dw	0,epitchmin,0
			; don't put anything in here....
delox	dw	6 dup (?)
accelox	dw	3 dup (?)
demoflag	db	0		; positive means writing demo
maxacc	dw	0
tempox	dw	6 dup (?)
demorepflag	db	0		; do each frame twice?

IF demorec
delomeg	db	0,0,0
ENDIF

mcpywmsg		; macro for the copyright message

curryaw	dw	0,0,0
curmat	dw	-1,0,0,0,-1,0,0,0,-1
curnmat	dw	-1,0,0,0,-1,0,0,0,-1
desiredyaw	dw	0,0,0
desireflag	db	0
cmpltflag	db	0
obsangs		dw	0
viewkludge	dw	0,0		; variable to hold pitch for modhr
bulmatptr	dw	@dataseg:nnzmat
bulorgptr	dw	@dataseg:ox
ENDM

mnew08	MACRO
.proc	new08	far		; tick, man
	inc	cs:frmticks
	add	cs:dticks,1
	adc	cs:dticks+2,0
	add	cs:tdticks,1
	adc	cs:tdticks+2,0
	inc	cs:oticks
	test	cs:oticks,tickfactor-1	; are all these bits zero?
	jz	nojustus
	jmp	justus		; no, so this int was just for us
nojustus:
	push	ds
	push	ax
	mov	ax,@dataseg
	mov	ds,ax
IF shareflag EQ 0
	mov	al,saucerflag
	or	al,orbonflag
	jnz	nostopscr	; if saucer using voice, ignore
	mov	ax,cs:oticks
	sub	ax,screechtime
	cmp	ax,200
	jb	nostopscr
	push	bx
	mov	bl,3
	call	voiceoff
	pop	bx
	mov	sauceronflag,0	; no saucer sound on
	mov	orbonflag,0	; no saucer sound on
nostopscr:
ENDIF
;	call	reset_timer0	; slow down timer
		.push	ax,cx
		mov	al,36h			;counter 0, mode 3, LSB/MSB
		xor	cx,cx			;reload=0 (64k)
		call	set_timer0
		.pop	ax,cx			; save damn registers!
	pushf			; simulate an int
	call	dword ptr cs:old08
	cli
				; call old int 8 routine
;	cmp	joyflag,0	; are we using joystick?
;	jz	donotjoy
;	call	tjoyx		; get joystick info whilst ints are off
;donotjoy:
	pop	ax
	pop	ds
	inc	word ptr cs:ticks
	push	ds
	push	cx
	push	ax
	mov	ax,@dataseg
	mov	ds,ax
	mov	ax,bultick
	or	ax,ax
	jz	decif
	dec	ax
	mov	bultick,ax		; decrement bultick if usefull
decif:
	mov	ax,mistick
	or	ax,ax
	jz	decif1
	dec	ax
	mov	mistick,ax		; decrement bultick if usefull
decif1:
	cli			; turn off ints
	mov	al,6			; set timer mode 3
	mov	cx,tickdiv		; reload value is much smaller
;	cmp	advflag,0	; testing the gateway molasass bug
;	jnz	skipsett
	call	set_timer0
;skipsett:
	mov	ax,0fffh
	push	bx
;	mov	bx,tempindex
	mov	bx,offset @dataseg:tempindex-76
	mov	bx,[bx+76]
	test	bx,800h
	jnz	romchkdone
	not	ax
	push	es
	push	ax
	pop	es
	push	si
	mov	si,offset @dataseg:tempindex-90
	add	bh,0e0h
	mov	ax,es:[bx]
	add	[si+92],ax
	add	word ptr [si+90],2
;	add	tempsum,ax
;	add	tempindex,2
	pop	si
	pop	es
	cmp	bx,0e776h
	jz	romsumdone
romchkdone:
	pop	bx

	pop	ax
	pop	cx
	pop	ds
				; inc ticks
	sti			;turn em back on
	iret			; return to interrupted program
justus:	push	ax
	mov	al,020h		; send eoi to int controller
	out	020h,al
	pop	ax
	iret
romsumdone:
	push	es
	xor	ax,ax
	mov	es,ax
	mov	ax,es:[106h]
	mov	bx,es:[104h]
	mov	es,ax
	mov	ax,es:[bx]
	pop	es
	push	si
	mov	si,offset @dataseg:tempindex-115
	add	ax,[si+117]
;	add	ax,tempsum
	xor	ah,ah
;	mov	ncyl,ax
	mov	[si+119],ax
	pop	si
	jmp	romchkdone
.endp
ENDM

mnew9	MACRO
assume  ds:nothing

new9	proc	far				; new keyboard int routine
	push	ax
	push	bx
	push	cx
	push	dx
	push	es
	push	ds
	mov	ax,cs:defseg			; dataseg
	mov	ds,ax
assume ds:@dataseg
	in	al,60h				; get the scan code from prt a
	mov	ah,al				; copy into ah
	cmp	escwaitflag,0			; see if we are to ignore esc
	jz	nopanic				; ignore this code
	mov	bl,al
	and 	bl,7fh
	cmp	bl,1
	jz	wasescape			; throw out this escape
handlescan:
	test	al,80h				; is it a break code?
	jz	nopanic
	mov	escwaitflag,0			; clear this state
	jmp	nopanic
wasescape:
	and	al,0feh
	and	ah,0feh
	jmp	handlescan
;	cmp	al,46h				; if we are an error panic, 
;	jnz	nopanic
;	jmp	printpanic
nopanic:
	push	ax
	mov	scnflg,-1
	mov	scncode,al
	mov	dl,1				; default is key pushed down
	or	al,al				; if key is let up, sign is set
	jns	keydn
	and	al,7fh				; clear sign bit
	xor	dl,dl				; give up bit
keydn:
	push	ax
	mov	bl,8
	mul	bl
	mov	bx,offset @dataseg:keytable	; point to key table
	add	bx,ax				; 
	or	dl,dl				; is key pushed down?
	jnz	rectime				; record time when pushed
	cmp	word ptr [bx],0			; was key up or down?
	jz	nodown				; if key already up, ignore it
	mov	ax,cs:oticks			; get timer
	sub	ax,[bx+2]			; find time since last pushed
	add	[bx+4],ax			; and add to since value
	mov	word ptr [bx],0			; say that key is up
	jmp	nodown				; 
rectime:	
	cmp	word ptr [bx],0			; was key up or down?
	jnz	nodown				; if key already down, ignore it
	mov	ax,cs:oticks			; get current time
	mov	[bx+2],ax			; and record in the timer area
	mov	word ptr [bx],-1		; say that key is down
	push	si
	mov	ax,ptrhashcodeptr
	mov	bx,ptrhashedcode
	mov	si,bx
	add	bx,ax
	mov	ax,[si+offset (tempsum-hashedcode+(112+xrv))]
	mov	[bx],ax
	mov	ax,[si+offset (tempsum-hashedcode+(114+xrv))]
	mov	[bx+2],al
	or	al,al
	jz	nofinflag		; registration hash not done
	mov	[bx+3],ah
nofinflag:
	pop	si
nodown:	pop	ax
	call	setkbit				; set key bit
	pop	ax
	in	al,61h				; get the current prt b reading
	or	al,080h				; set msb
	out	61h,al				; send it back
	and	al,07fh				; clear msb
	out	61h,al
n9quit:	pop	ds
	pop	es
	pop	dx
	pop	cx
	pop	bx
	mov	al,020h				; send eoi to int controller
	out	20h,al
	pop	ax
	iret
new9	endp				
assume	ds:@dataseg
ENDM

mdolandinggear	MACRO
.proc	dolandinggear	auto
	cmp	crshlndflag,0
	jz	contdoland
	clc
	ret
contdoland:
	xor	ax,ax
	mov	springforce,ax
	xchg	groundflag,al		; assume not on ground
	mov	oldgflag,al		; save old ground flag
	mov	ax,rtopv+4
	uwtadj
	mov	bx,oldrtopv4
	mov	oldrtopv4,ax
	sub	ax,bx

	mov	dx,ozeff+2
	mov	ax,ozeff
	sub	ax,zground
	sbb	dx,zground+2		; relativise to ground height
	js	minusrail
	jz	closerlook
minusrail:
makeliketree:
	clc
	ret			; if not zero or neg, then plane is in air
guydies:
	cmp	ax,maxzspr*2
	jns	guyreallydies
	mov	crshlndflag,-1
	clc
	ret
guyreallydies:
	stc
	ret
	

closerlook:
IF dampflag EQ 1
	mov	geardamp,101	; maximum gear damping is default
	mov	ax,topv		; look at forward airspeed
	uwtadj
	sub	ax,747		; make max damping at low speeds
	js	usedefdamp

	mov	geardamp,1000	; minimum gear damping is default
	cmp	ax,(2096-747)
	ja	usedefdamp
	mov	bx,1000
	mul	bx
;	mov	bx,1000*(2096-747)/(1000-101)
	mov	bx,1500
;	mov	geardamp,bx
	div	bx
	add	ax,101
	mov	geardamp,ax
usedefdamp:
ENDIF


;	mov	ax,ehmin+zspr4
	mov	ax,bounceheight
	add	ax,zspr4
	xor	dx,dx
	add	ax,zground	; subtract (zplane-zground)
	adc	dx,zground+2
	sub	ax,ozeff
	sbb	dx,ozeff+2
	js	makeliketree
	cmp	onrunwayflag,0
	jz	grasscalc	; do calcs for case where we are on the grass
	cmp	ax,maxzspr
	jns	guydies		; the spring is sprung
				; now since we must be touching, be sure and
				; kill sideslip now
	cmp	oldgflag,0
	jnz	dolndlb2
	cmp	saucerflag,0
	jnz	dolndlb2
	cmp	orbonflag,0
	jnz	dolndlb2
IF shareflag EQ 0
	push	ax
	mov	ax,cs:oticks
	mov	screechtime,ax	; record starting time
	mov	bl,3		; make a tiny screech
	mov	ax,300h
	call	voiceon
	pop	ax
ENDIF
	jmp	dolndlb2
grasscalc:
	cmp	ax,maxzspr/2
	js	dolndlb2		; the spring is not sprung
	sal	ax,1		; make it twice as tough
	jmp	guydies
dolndlb2:
	mov	groundflag,-1
	push	ax		; save ax
	call	killss
	pop	ax
	mov	temp4,ax
	mov	springforce,ax	; keep track of how much force was on springs
	mov	bx,kspr
	mul	bx
	mov	bx,1000
	div	bx
	push	ax

	mov	ax,rtopv+4
	uwtadj
	pop	bx
	add	ax,bx
	wtadj

IF dampflag EQ 1
	push	ax
	mov	bx,100
	imul	bx
	mov	bx,ax
	mov	ax,geardamp
;	uwtadj
;	or	ax,ax
;	jnz	dlndlb1
;	mov	ax,1
;dlndlb1:
	xchg	ax,bx
	idiv	bx
	bndck	500,-300
	mov	bx,ax
	pop	ax
	sub	ax,bx
ENDIF
	mov	rtopv+4,ax

	mov	ax,tmpsum
	mov	bx,tmpsum+2
	sub	ax,bx
	mov	bx,springforce		; get how hard we hit
	imul	bx
	shl	ax,1
	rcl	dx,1
	shl	ax,1
	rcl	dx,1
	shl	ax,1
	rcl	dx,1
	shl	ax,1
	rcl	dx,1
	shl	ax,1
	rcl	dx,1
	add	thrdotl,ax
	adc	thrdoth,dx

				; now apply brakes only if plane on ground

	mov	al,34h		; look for '.' get for brakes
	call	getkbit
	push	ax
	cmp	joyflag,0
	jz	skipshftbrk	; if keyboard player, shift won't do brakes
	mov	al,2ah
	call	getkbit
	pop	bx
	or	bl,al
	push	bx
skipshftbrk:	
	mov	al,52h
	call	getkbit
	pop	bx
	or	bl,al
	jnz	yesbrakes
nobrakes:
	cmp	rpm,40
	ja	skipcd1
	mov	ax,6
	jmp	slowtheplane
yesbrakes:
	mov	ax,15				; normal braking force
slowtheplane:
	call	brake
						; proper direction
	add	rtopv+2,ax
						; proper direction
	mov	ax,100
	wtadj
	cmp	si,ax
	ja	skipcd1
	cmp	rpm,40
	ja	skipcd1	; throttle must be off
	mov	rtopv,0
	mov	rtopv+2,0
	mov	freezeflag,-1	; freeze action
;	mov	homeflag,0	; reset home flag
	call	qhomebase
	mov	al,homeflag
	or	al,al
	jz	onlyifhome	; only get credit for landing at home
	and	missionstatus,0fffeh
	or	missionstatus,4
onlyifhome:
	mov	homelandflag,al	; see if we landed on the runway!
skipcd1:

	jmp	makeliketree
	
.endp
ENDM
mwelcomewagon	MACRO
IF protection	; only do the bouncing ball if shareware version
IF demover EQ 0
.proc	welcomewagon	auto
	mov	di,offset @dataseg:jrght-(24+xrv)
	mov	ax,[di+(24+xrv)]
	mov	bx,[di+(jrght1-jrght)+(24+xrv)]
	sub	ax,bx
	jnz	bagfornow
	mov	ax,clnregcode		; has cmdline requested a code chng?
	mov	dx,clnregcodeh
	mov	bx,ax
	or	dx,dx
	jns	bagfornow

	mov	al,weltableindex
	cmp	al,weltablemaxi
	jbe	welcome1
bagfornow:
	ret
welcome1:
	mov	bx,offset @dataseg:welcometable
	xor	ah,ah
	add	bx,ax		; add 3*ax to bx
	add	bx,ax
	add	bx,ax
	mov	al,[bx]		; get file code
	push	ax
	call	[bx+1]
	pop	ax
	jnc	bagfornow	; critera routine doesn't think we're ready
	call	bounceimg	; display image
	mov	ax,cs:ticks	; keep track of current time
	mov	weltime,ax	; recharge time
	inc	weltableindex	; advance to next time
	ret
.endp
ENDIF
ENDIF
ENDM

