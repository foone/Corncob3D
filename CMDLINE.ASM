	title 'cmdline'
_MODEL	equ	<SMALL>
include f3dequ.inc
include model.inc

	public	cmdline	; entry point
;
IF getunivbin
.extrn	gubflag:byte
ENDIF
.extrn	joyflag:byte,keyflag:byte,easyflag:byte,diagflg:byte
.extrn	invincible:byte,jctrflag:byte,actionflag:byte,slowflag:byte
.extrn	aeroflag:byte,rmsgflag:byte
.extrn	arg_count:auto,arg_next:auto
.extrn	exit_ok:auto
.extrn	dec_to_word:auto,dec_to_dword:auto
.extrn	put_str:auto,put_chr:auto,put_newline:auto
.extrn	str_cpye:auto,get_chr:auto
.extrn	qualaa:word,qualdbst:word,qualvest:word
.extrn	naas:word,ndbst:word,nvest:word
.extrn	clnregcode:word,clnregcodeh:word
.extrn	kbuf:byte
.extrn	readfileflag:byte
.extrn	chainflag:byte,rundemoflag:byte,aceflag:byte
.extrn	qtimeinc:word
.extrn		open_h:auto,close_h:auto,read_h:auto,hget_line:auto
.extrn	wword:auto

IF MVPCD
.extrn	str_cpy:auto,str_cat:auto
.extrn	wpath:byte
ENDIF

IF shareflag EQ 0
.extrn	lettercheck1:byte,lettercheck2:byte
ENDIF

.dataseg
IF demover
standalonemsg	db	0dh,0ah,'Error: this program is not meant to be run from a DOS command line',0dh,0ah,0
ENDIF
argmsg1	db	0dh,0ah,'Error:  Invalid command line option : ',0
argmsg3	db	0dh,0ah,'Command line : ',0dh,0ah,0
argmsg2	db	0dh,0ah
IF MVPCD
vcmdname	db	'3.cmd',0
cmdname	db	'3.cmd',35 dup(0)
ELSE
cmdname	db	'3.cmd',0
ENDIF
dfhandl	dw	?
verbflag	db	0
IF demover EQ 0
	db	0dh,0ah,'Usage:  3 [-edkijrs] [-n#] [-l#] [-m#] [-t#] [-q#]'
	db	'[-u#] [-v#]'
;	db	0dh,0ah,0ah,'e   copy univ enable'
;	db	0dh,0ah,'a   only create airfields, write univ.dat file'
;	db	0dh,0ah,'b   run demo in 3demo.dat file'
;	db	0dh,0ah,'d   diag mode'
;	db	0dh,0ah,'g   do not do automatic check for joystick'
;	db	0dh,0ah,'h   issue a plane from storage'
;	db	0dh,0ah,'i   invincible plane mode'
;	db	0dh,0ah,'j   force joystick recenter'
;	db	0dh,0ah,'k   keyboard only, no joystick'
;	db	0dh,0ah,'r   read in file 3univ.dat'
;	db	0dh,0ah,'s   do not call score.exe, and write 3.res file'
;	db	0dh,0ah,'l#  where # is number of dballs'
;	db	0dh,0ah,'m#  where # is number of shopping carts'
;	db	0dh,0ah,'n#  where # is number of aaa'
;	db	0dh,0ah,'p[str]  where string is the path'
;	db	0dh,0ah,'t#  where # is the quality of dball sites'
;	db	0dh,0ah,'v#  where # is the quality of aaa'
;	db	0dh,0ah,'w#  where # is the quality of cart sites'
;	db	0dh,0ah,'y   is the aerodynamic flag for beginners'
ENDIF
	db	0dh,0ah,0

kbufptr	dw	@dataseg:kbuf
argbuf	db	128 dup(0)
optable	dw	@codeseg:aopt	;a
	dw	@codeseg:bopt	;b
	dw	@codeseg:copt	;c
	dw	@codeseg:dopt	;d
	dw	@codeseg:eopt	;e
	dw	@codeseg:fopt	;f
	dw	@codeseg:gopt	;g
	dw	@codeseg:hopt	;h
	dw	@codeseg:iopt	;i
	dw	@codeseg:jopt	;j
	dw	@codeseg:kopt	;k
	dw	@codeseg:lopt	;l
	dw	@codeseg:mopt	;m
	dw	@codeseg:naaopt	;n
	dw	@codeseg:oopt	;o
IF MVPCD
	dw	@codeseg:popt	;p
ELSE
IF getunivbin
	dw	@codeseg:popt	;p
ELSE
	dw	@codeseg:nopt	;p no option
ENDIF
ENDIF
	dw	@codeseg:qopt	;q
	dw	@codeseg:ropt	;r
	dw	@codeseg:sopt	;s
	dw	@codeseg:topt	;t
	dw	@codeseg:uopt	;u
	dw	@codeseg:vopt	;v
	dw	@codeseg:wopt	;w
	dw	@codeseg:xopt	;x
	dw	@codeseg:yopt	;y
IF MVPCD
	dw	@codeseg:popt	;z demo option for CDROM
ELSE
	dw	@codeseg:nopt	;z option
ENDIF
	dw	@codeseg:bropt	;{ option

.ends

.codeseg
	; assume cs:@codeseg,
	assume ds:@dataseg

.proc	cmdline	auto
	call	arg_count	; get number of arguments
	or	cl,cl
IF demover
	jz	assisgrass	; yell if no options
ELSE
	jnz	noargs1not
	jmp	noargs1
noargs1not:
	xor	ch,ch		; do loop looking for dash
ENDIF
cmdloop:
	push	cx
	mov	si,offset @dataseg:argbuf
	call	arg_next
;	call	put_str
;	mov	al,20h
;	call	put_chr
	push	ds
	pop	es
	mov	di,kbufptr
	call	str_cpye
	mov	kbufptr,di
	cmp	byte ptr [si],2dh	; is it a dash?
	pop	cx
	jnz	nevalopts
	push	si
	call	evalopts
	pop	si
	jc	noargs
nevalopts:
	loop	cmdloop

	mov	kbufptr,offset @dataseg:kbuf
					; open config file
			mov	si,offset @dataseg:cmdname
			mov	ax,0102h
			call	open_h
			mov	dfhandl,bx
			jc	nocmdfile
nevalopts1:
	mov	si,offset @dataseg:argbuf
	mov	cx,32		; read a max of 79 characters
	mov	bx,dfhandl	; handle for file	
	mov	ax,ds		; set es for lord knows why?
	mov	es,ax
	call	hget_line
	jnc	nohgeterr
	jmp	cmdfileclose
nohgeterr:
	or	cx,cx
	jz	cmdfileclose
	cmp	verbflag,0
	jz	skipverb1
	mov	si,offset @dataseg:argbuf
	call	put_str
skipverb1:
	push	ds
	pop	es
	mov	di,kbufptr
	call	str_cpye
	mov	kbufptr,di
	cmp	byte ptr [si],2dh	; is it a dash?
	jnz	nevalopts1
	push	si
	call	evalopts
	pop	si
	jc	cmdfileclose
	jmp	nevalopts1
cmdfileclose:
	mov	bx,dfhandl	; handle for file	
	call	close_h
	cmp	verbflag,0
	jz	skipverb2
	call	get_chr
skipverb2:
nocmdfile:
IF demover
	cmp	rundemoflag,0
	jnz	rdoptfine
assisgrass:
	mov	si,offset @dataseg:standalonemsg
	call	put_str
	jmp	exit_ok
rdoptfine:
ENDIF
noargs1:
	clc
noargs:
IF 1 EQ 0
IF shareflag EQ 0
	pushf
	mov	ax,0c800h
	sub	ax,1000h
	mov	es,ax

	mov	al,es:[10*160+leftmarg]
	sub	al,050h
	add	al,es:[10*160+leftmarg+4]
	sub	al,050h
	sub	al,lettercheck1
	sub	al,lettercheck2
	mov	lettercheck1,-1		; ensure no 'P" failure
	jz	nameok
IF	MVPCD			; can't fail if MVPCD
	jmp	nameok
ENDIF
	mov	lettercheck1,0

nameok:
	popf
ENDIF
ENDIF
	ret
	
evalopts:
	mov	dx,9999h
	inc	si
	cmp	byte ptr [si],0		; are we done?
	jz	evaldn
	cmp	byte ptr [si],20h		; are we done?
	jz	evaldn
	cmp	byte ptr [si],0dh		; are we done?
	jz	evaldn
	cmp	byte ptr [si],0ah		; are we done?
	jz	evaldn
	mov	al,[si]
	sub	al,61h			; is less than a?
	js	evalerr
	cmp	al,20h
	ja	evalerr
	xor	ah,ah
	mov	bx,offset @dataseg:optable	; option table
	add	bx,ax			; point to entry
	add	bx,ax			; make into a word address
	call	[bx]			; call option
	jc	evalerr
	jmp	evalopts
evaldn:	
	clc
	ret			; return with no ceremony
evalerr:
	push	ax		; save invalid option number
	mov	ax,0b800h
	mov	es,ax
	mov	cx,2000
	mov	ax,0720h	; clear damn screen
	xor	di,di
	rep	stosw
	pop	ax

	mov	si,offset @dataseg:argmsg1
	call	put_str
	add	al,61h		; put character back the way it was
	call	put_chr
	mov	si,offset @dataseg:argmsg3
	call	put_str
	mov	si,offset @dataseg:kbuf
	call	put_str
	mov	si,offset @dataseg:argmsg2
	call	put_str
	call	get_chr
	stc
	ret
.endp

.proc	kopt	auto
	mov	joyflag,0
	clc
	ret
.endp

.proc	eopt	auto
	mov	easyflag,-1
	xor	ax,ax
	mov	naas,ax
	mov	ndbst,ax
	clc
	ret
.endp

.proc	fopt	auto
	mov	aceflag,-1
	clc
	ret
.endp

.proc	iopt	auto
	mov	invincible,-1
	clc
	ret
.endp

.proc	dopt	auto
	mov	diagflg,-1
	clc
	ret
.endp

.proc	jopt	auto
	or	jctrflag,80h
	clc
	ret
.endp

.proc	gopt	auto
	or	jctrflag,1
	clc
	ret
.endp

.proc	nopt	auto
	stc
	ret
.endp

.proc	aopt	auto
	mov	actionflag,-1
	clc
	ret
.endp

.proc	bopt	auto
	mov	rundemoflag,-1
	clc
	ret
.endp

.proc	hopt	auto
	mov	chainflag,-1
	clc
	ret
.endp

.proc	sopt	auto
	mov	slowflag,-1
	clc
	ret
.endp

.proc	ropt	auto
	mov	readfileflag,-1
	clc
	ret
.endp

.proc	oopt	auto
	mov	verbflag,-1
	clc
	ret
.endp

.proc	naaopt	auto
	inc	si		; point at next character after n
	call	dec_to_word	; convert this to a word
	jne	naaopterr
	mov	naas,ax		; woo!
	dec	si		; retard si because the loop does a pre-incr
	clc
	ret
naaopterr:
	stc
	ret
.endp

IF MVPCD

.proc	popt	auto
	inc	si		; point at next character after n
	push	es
	push	di
	mov	di,offset @dataseg:wpath	; replace wpath with string
	cld
	push	cx
	mov	cx,40		; max number of characters
wpcpylp:
	lodsb
	stosb
	or	al,al
	loopnz	wpcpylp
	pop	cx
	push	si
	mov	si,offset @dataseg:wpath	; replace path of 3.cmd
	mov	di,offset @dataseg:cmdname	; replace wpath with string
	call	str_cpy
	mov	si,offset @dataseg:vcmdname	; replace path of 3.cmd
	mov	di,offset @dataseg:cmdname	; replace wpath with string
	call	str_cat				; merge path into string

;	call	put_newline
;	mov	si,offset @dataseg:cmdname	; replace wpath with string
;	call	put_str
;	call	get_chr
;	call	put_newline

	pop	si
	pop	di
	pop	es
;	dec	si		; retard si because the loop does a pre-incr
	clc
	ret
.endp
ELSE
IF getunivbin
.proc	popt	auto
	mov	gubflag,-1
	clc
	ret
.endp
ENDIF
ENDIF
.proc	copt	auto
	inc	si		; point at next character after n
	call	dec_to_dword	; convert this to a word
	jne	copterr
	mov	clnregcode,ax		; woo!
	mov	clnregcodeh,dx
	dec	si		; retard si because the loop does a pre-incr
	clc
	ret
copterr:
	stc
	ret
.endp


.proc	mopt	auto
	inc	si		; point at next character after n
	call	dec_to_word	; convert this to a word
	jne	mopterr
	mov	nvest,ax		; woo!
	dec	si		; retard si because the loop does a pre-incr
	clc
	ret
mopterr:
	stc
	ret
.endp

.proc	qopt	auto
	inc	si		; point at next character after n
	push	ax		; save code
	call	dec_to_word	; convert this to a word
	jne	qopterr
	mov	qtimeinc,ax		; woo!
	dec	si		; retard si because the loop does a pre-incr
	pop	ax
	clc
	ret
qopterr:
	pop	ax
	stc
	ret
.endp

.proc	lopt	auto
	inc	si		; point at next character after n
	call	dec_to_word	; convert this to a word
	jne	lopterr
	mov	ndbst,ax		; woo!
	dec	si		; retard si because the loop does a pre-incr
	clc
	ret
lopterr:
	stc
	ret
.endp

.proc	getdigits	auto	; gets numerical digits of option
	inc	si		; point at next character after n
	call	dec_to_word	; convert this to a word
	jne	getdopterr
	dec	si		; retard si because the loop does a pre-incr
	clc
	ret
getdopterr:
	stc
	ret
.endp

.proc	topt	auto		; get qual of deathballs
	call	getdigits
	jc	toptret
	mov	qualdbst,ax
toptret:
	ret
.endp

.proc	uopt	auto		; get qual of deathballs
	jmp	topt
.endp

.proc	vopt	auto		; get qual of aa
	call	getdigits
	jc	voptret
	mov	qualaa,ax
voptret:
	ret
.endp

.proc	wopt	auto		; get qual of shopping carts
	call	getdigits
	jc	woptret
	mov	qualvest,ax
woptret:
	ret
.endp

.proc	xopt	auto		; get qual of deathballs
	jmp	wopt
.endp

.proc	yopt	auto
	mov	aeroflag,-1
	clc
	ret
.endp

.proc	bropt	auto
	mov	rmsgflag,-1
	clc
	ret
.endp

.ends
	end


