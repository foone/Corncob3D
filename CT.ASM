

include c:\powerc\pcmac.asm

argx1	equ	[bp+(1*2+4)]
argy1	equ	[bp+(2*2+4)]
argx2	equ	[bp+(3*2+4)]

jumptableoff	equ	0

modbeg	ct

adlseg	dw	0
adlrlc	dw	0
fname	db	'soadl.exe',0

routineoff	dw	0
routineseg	dw	0

procbeg	LOADSOADL
	push	ds
	mov	ax,cs
	mov	ds,ax
assume cs:module,ds:module,es:nothing,ss:nothing
	mov	si,argx1
	mov	ax,argy1
	or	si,si		; is offset zero?
	jz	ptrok
	add	si,15		; convert far ptr to segment address
	mov	cl,4
	shr	si,cl
	add	ax,si
ptrok:
	mov	adlseg,ax	; store segment address
	mov	adlrlc,ax		; relocate exe by same amount
	mov	routineseg,ax	; and also for top of pointer to routine
	mov	ax,cs
	mov	es,ax
	mov	bx,offset module:adlseg

	mov	dx,offset module:fname

	mov	ax,04b03h	; dos call to load overlay
	int	21h
	jc	noovl
	mov	ax,0
noovl:
	pop	ds
procend LOADSOADL

assume cs:module,ds:nothing

; voiceon(int voice#,int freq)	
; turns on a synthisizer voice
procbeg	voiceon
	push	ds
	push	ss
	mov	ax,cs:routineseg
	mov	es,ax
	mov	si,0
	mov	ax,es:[si+2]
	mov	routineoff,ax
	mov	ax,argy1
	mov	bx,argx1
	call	dword ptr cs:[routineoff]
	pop	ss
	pop	ds
procend voiceon


; voiceoff(int voice#,int freq)	
; turns off a synthisizer voice
procbeg	voiceoff
	push	ds
	push	ss
	mov	ax,cs:routineseg
	mov	es,ax
	mov	si,jumptableoff
	mov	ax,es:[si+4]
	mov	routineoff,ax
	mov	ax,argy1
	mov	bx,argx1
	call	dword ptr cs:[routineoff]
	pop	ss
	pop	ds
procend voiceoff

; adlinit();
; writes defaults to all the adl registers, silences board, initializes delays
procbeg	adlinit
	push	ds
	push	ss
	mov	ax,cs:routineseg
	mov	es,ax
	mov	si,jumptableoff
	mov	ax,es:[si]
	mov	routineoff,ax
	mov	ax,5555h
	call	dword ptr cs:[routineoff]
	pop	ss
	pop	ds
procend	adlinit

; adlwrt(int register# ,int data)	
; writes to an adlib register
procbeg	adlwrt
	push	ds
	push	ss
	mov	ax,cs:routineseg
	mov	es,ax
	mov	si,jumptableoff
	mov	ax,es:[si+6]
	mov	routineoff,ax
	mov	ax,argy1
	mov	bx,argx1
	call	dword ptr cs:[routineoff]
	pop	ss
	pop	ds
procend adlwrt

modend	ct
