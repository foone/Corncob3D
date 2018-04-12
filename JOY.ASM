

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
	mov	jleft,ax		; store it for later
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
	call	setjrght
	mov	jdown,bx
	shr	ax,1			; divide by two
	cmp	ax,jleft		; make sure jright is >2*jleft
	jg	joyok1
	jmp	joyerr
joyok1:
	shr	bx,1			; divide by two
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
	mov	jcntr,ax		; store it for later
	mov	jvctr,bx
					; now check for invalid entry
	shr	ax,1			; divide by two
	cmp	ax,jleft		; make sure jright is >2*jleft
	jg	joyok3
	jmp	joyerr
joyok3:
	shr	bx,1			; divide by two
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


