	title 'rimg'
; this routine reads in an image file, and places it in the video buffer
;
_MODEL	equ	<SMALL>
include c:\sa\model.inc
include 3dvid.inc
include pixaddr1.inc

.public	main

;
.codeseg	lib
.extrn		start:AUTO, exit:AUTO, exit_ok:AUTO
.extrn	arg_count:auto,arg_next:auto,str_cat:auto
.extrn		put_str:AUTO
.extrn		words_to_dec:auto,put_chr:auto
.extrn		get_version:auto
.extrn		open_h:auto,close_h:auto,read_h:auto
.ends

n	equ	7

.dataseg
fname	db	'img\3d',0
	db	64 dup (0)		; leave room for path/file/name
fexten	db	'.img',0
ferrmsg	db	0dh,0ah,'File error has occured',0dh,0ah,0
panicmsg	db	0dh,0ah,'This program cannot be run directly, it is'
		db	' called by other programs.'
		db	0dh,0ah,'Exiting..',0dh,0ah,0

fhandl	dw	?
imgbuf	db	16384 dup(?)
dimx	dw	28000
distrt	dw	?
notslowflag	db	-1
oldtick	dw	0
.ends

IF NOT __TINY__
.stackseg
		db	128 dup(?)	;define a 128 byte stack
.ends
ENDIF

.codeseg
assume		cs:@codeseg, ds:@dataseg, es:@dataseg

IF 1 EQ 0
.proc	tickwait	auto
	push	es
	push	cx
	push	bx
	push	dx
	mov	ax,40h
	mov	es,ax
	mov	cx,20000
twloop:
	mov	ax,es:[6ch]
	cmp	ax,oldtick
	loopz	twloop
	mov	oldtick,ax
	pop	dx
	pop	bx
	pop	cx
	pop	es
	ret
.endp
ENDIF

.proc	rimg	auto
		mov	distrt,di		; save start address for later
		mov	si,offset @dataseg:fname
		xor	ax,ax
		call	open_h
		jc	error
		mov	fhandl,bx
		mov	si,offset @dataseg:imgbuf
		mov	cx,16383
		mov	bx,fhandl
		call	read_h
		jc	error
		mov	bx,fhandl
		call	close_h
		jc 	error
		jmp	wrtimg

error:		
		mov	ax,3
		int	10h
		mov	si,offset @dataseg:ferrmsg
		call	put_str
	
		stc
		ret

;		call	grab08
wrtimg:
	mov	dx,3ceh		; dx := graphics controller port addr
	mov	ah,0
	xor	al,al
	out	dx,ax		; put color selection in set/reset reg
	mov	ax,0f01h
	out	dx,ax		; put 0fh in bit plane enable
	mov	ah,0
	mov	al,3
	out	dx,ax		; 0 for the RWM bits of the ALU
	mov	ax,0305h	; write mode 3 select
	out	dx,ax
	mov	di,distrt
	mov	ax,vgseg
	mov	es,ax		; set up segment
	mov	al,-1
	mov	es:[di],al	; write latches
	mov	al,es:[di]	; read latches
	mov	ah,n
	xor	al,al
	out	dx,ax		; set color to n
	mov	si,offset @dataseg:imgbuf
	add	si,4		; skip first four bytes
	cld
imglp2:	
;	cmp	notslowflag,0
;	jnz	skipwait
;	call	tickwait
;skipwait:
	mov	ax,di		; check for finish
	sub	ax,distrt
	cmp	ax,dimx
	jae	idone
;	jns	idone
	mov	cx,[si]		; get count of fill bytes
	and	cx,03fffh	; limit max count to 16383
	add	si,2
	mov	ax,dimx
	sub	ax,di		; get max bytes left
	add	ax,distrt
	cmp	cx,ax
	jb	imlb1
;	js	imlb1
	mov	cx,ax
imlb1:	
	mov	al,[si]		; get byte to fill with
	inc	si
	rep	stosb		; fill RAM
	mov	cx,[si]		; get count for data bytes
	and	cx,03fffh	; limit max count to 16383
	add	si,2
	mov	ax,dimx
	sub	ax,di		; get max bytes left
	add	ax,distrt
	cmp	cx,ax
	jb	imlb2
;	js	imlb2
	mov	cx,ax
imlb2:	
	rep	movsb		; move bytes
	jmp	imglp2		; go back for another

idone:	
	mov	dx,3ceh		; dx := graphics controller port addr
	mov	ax,5
	out	dx,ax		; write mode 0
	xor	ax,ax
	out	dx,ax
	inc	ax
	out	dx,ax
		clc
		ret			;exit to DOS with ERRORLEVEL=0
.endp

.proc	main	far

	mov	ax,0f00h
	int	10h			; make sure we are in graphics mode
	cmp	al,vgmode		; is it correct?
	jz	modeok			; yes, continue
	mov	si,offset @dataseg:panicmsg		; no, panic and exit
	call	put_str
	mov	al,1
	jmp	exit			; exit with error code set
modeok:
	call	arg_count	; get number of arguments
	or	cl,cl
	jz	noargs

	mov	si,offset @dataseg:imgbuf	; use imgbuf as buffer
	call	arg_next
	mov	al,[si]				; get character
	push	ax
	mov	di,offset @dataseg:fname	; going cat the string
	mov	ax,ds
	mov	es,ax
	call	str_cat				; cat o cat
	pop	ax
	sub	al,30h				; is it a zero?
	mov	notslowflag,al
	jz	noargs

	mov	dimx,gfymax*bpl			; don't let above this!

noargs:				; if no args, then assume inst panel
	mov	si,offset @dataseg:fexten	; use imgbuf as buffer
	mov	di,offset @dataseg:fname	; going cat the string
	mov	ax,ds
	mov	es,ax
	call	str_cat				; put file type on there
	mov	di,0
;	add	di,gfymax*bpl
	call	rimg
	jc	ohheavens
	mov	di,7e00h		; start video in right place
;	add	di,gfymax*bpl
	call	rimg
	jc	ohheavens
	jmp	exit_ok
ohheavens:
	mov	al,1			; signal error
	jmp	exit
.endp

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
	end

