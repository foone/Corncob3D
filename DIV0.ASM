;=============================================================================
;FILE:	ITHINK.ASM
;
;DESC:	Sample program from page 30 of the manual.
;
;NOTES:	Created using the MAIN.XXX skeleton file.
;=============================================================================

_MODEL	equ	<SMALL>

include		c:\sa\MODEL.INC


.codeseg	lib
.extrn		start:AUTO, exit:AUTO, exit_ok:AUTO
.extrn	put_str:auto,put_chr:auto,get_chr:auto
.extrn	set_vec:auto,shrink_prog:auto,get_psp:auto,get_vec:auto
.extrn	dos_msize:auto,get_version:auto,get_envseg:auto,dos_mfree:auto
.extrn	create_envblk:auto,put_newline:auto,arg_count:auto,arg_next:auto
.extrn	word_to_hex:auto
.ends

.public	kbuf

.dataseg

hellomsg	db	0dh,0ah,'Hello, welcome to soadl',0dh,0ah,0
alrinstmsg	db	0dh,0ah,'Sound driver already installed',0dh,0ah,0
pspmsg		db	0dh,0ah,'Psp Segment Address : ',0
kbuf		db	80 dup (0)

.ends


IF NOT __TINY__
.stackseg
		db	128 dup(?)	;define a 128 byte stack
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
assume		cs:@codeseg, ds:@dataseg, es:@dataseg, ss:@stackseg
ENDIF

old00	dw	0,0
old08	dw	0,0
old33	dw	0,0

	dw	3333h
msregs	dw	0,0,0,0,0,0	; ax,bx,cx,dx,si,di

.proc	grab00	auto		;grabs an int, man
;	mov	si,offset @dataseg:infmsg
;	call	put_str
	mov	bl,00		; video int
	call	get_vec	; get the current vector
	mov	old00+2,dx	; put into memory
	mov	old00,ax
	mov	bl,000		; now put in our new vector
	mov	dx,cs		; setup segment
	mov	ax,offset @codeseg:new00
	call	set_vec	; grab that vector!
	ret
.endp

.proc	grab33	auto		;grabs an int, man
;	mov	si,offset @dataseg:infmsg
;	call	put_str
	mov	bl,33h		; video int
	call	get_vec	; get the current vector
	mov	old33+2,dx	; put into memory
	mov	old33,ax
	mov	bl,33h		; now put in our new vector
	mov	dx,cs		; setup segment
	mov	ax,offset @codeseg:new33
	call	set_vec	; grab that vector!
	ret
.endp

.proc	new33	far	; do int 33 stuff
	mov	cs:msregs,ax
	mov	cs:msregs+2,bx
	mov	cs:msregs+4,cx
	mov	cs:msregs+6,dx
	mov	cs:msregs+8,si
	mov	cs:msregs+10,di
	pushf
	call	dword ptr cs:old33
	iret
.endp

.public	new00
.proc	new00	far		; tick, man
	sti			; re-enable ints
	.push	ax,bx,cx,dx,si,di,es
				; inc ticks
	sti
	mov	ax,3
	int	10h
	mov	ax,@dataseg
	mov	ds,ax		; make sure segment is correct
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
	push	ax
	xor	ah,ah
	mov	dx,0
	int	17h	; write byte to printer
	pop	ax
	mov	dl,al
	mov	ah,2
	int	21h
	inc	bx
	loop	ttlp1
	mov	dl,0dh
	mov	ah,2
	int	21h
	mov	dx,0
	mov 	ax,0dh
	int	17h
	inc	bx
	mov	dl,0ah
	mov	ah,2
	int	21h
	mov	dx,0
	mov 	ax,0ah
	int	17h
	pop	cx
	pop	di
	inc	di
	inc	di
	pop	es
	loop	toutlp

	mov	ax,cs
	mov	es,ax
	mov	di,offset @codeseg:msregs-2
	mov	cx,7
toutlp1:	mov	ax,es:[di]
	mov	si,offset @dataseg:kbuf
	call	word_to_hex
	mov	bx,offset @dataseg:kbuf
	push	es
	push	di

	push	cx
	mov	cx,4
ttlp2:	
	mov	al,[bx]
	push	ax
	xor	ah,ah
	mov	dx,0
	int	17h	; write byte to printer
	pop	ax
	mov	dl,al
	mov	ah,2
	int	21h
	inc	bx
	loop	ttlp2
	mov	dl,0dh
	mov	ah,2
	int	21h
	mov	dx,0
	mov 	ax,0dh
	int	17h
	inc	bx
	mov	dl,0ah
	mov	ah,2
	int	21h
	mov	dx,0
	mov 	ax,0ah
	int	17h
	pop	cx
	pop	di
	inc	di
	inc	di
	pop	es
	loop	toutlp1

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

.proc	grab08	auto		;grabs an int, man
;	mov	si,offset @dataseg:infmsg
;	call	put_str
	mov	bl,08		; video int
	call	get_vec	; get the current vector
	mov	cs:old08+2,dx	; put into memory
	mov	cs:old08,ax
	mov	bl,008		; now put in our new vector
	mov	dx,cs		; setup segment
	mov	ax,offset @codeseg:new08
	call	set_vec	; grab that vector!
	ret
.endp

.proc	new08	far
	.push	ax,bx,cx,dx,si,di,ds,es
	mov	ax,@dataseg
	mov	ds,ax
	mov	bl,000		; now put in our new vector
	mov	dx,cs		; setup segment
	mov	ax,offset @codeseg:new00
	call	set_vec	; grab that vector!
	.pop	ax,bx,cx,dx,si,di,ds,es
	pushf
	call	dword ptr cs:old08
	sti
	iret
.endp


.public		main
.proc		main		AUTO
	mov	si,offset @dataseg:hellomsg
	call	put_str
	call	get_version
	call	shrink_prog
	call	grab08
	call	grab33
;	call	grab00

hloop:
	mov	si,offset @dataseg:hellomsg
	call	put_str
	call	get_chr
	cmp	al,1bh
	jz	wpr
	jmp	hloop

wpr:

	call	get_psp
	call	dos_msize
	mov	si,offset @dataseg:kbuf
	call	word_to_hex
	call	put_str
	add	ax,15
	mov	dx,ax
	mov	ax,3100h	; become resident
	int	21h
		ret

.endp		main

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


		end	start	;specify START as starting address
