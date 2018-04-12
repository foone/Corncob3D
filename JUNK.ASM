

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
 call wword
	mov	jleft,ax		; store it for later
 mov ax,bx
 call wword
 call wcr
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
 push ax
 call wword
 mov ax,bx
 call wword
 call wcr
 pop ax
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
 push ax
 call wword
 mov ax,bx
 call wword
 call wcr
 pop ax
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

