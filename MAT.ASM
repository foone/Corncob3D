	title 'mat'
;
;	this routine returns the pixel addr for ega modes
;	when given x and y coords
;
;	caller: 		ax = y-coordinate
;				bx = x-cooordintat
;	
;	returns:		ah = bit mask
;				bx = byte offset in buffer
;				cl = number of bits to shift left
;				es = video buffer segment
;
_MODEL	equ	<SMALL>
include model.inc
include		imath.INC

hmul	macro	var1,var2
	local	fxup
	mov	ax,var1
	mov	dx,var2
	imul	dx
	cmp	dx,8000h
	jnz	fxup
	mov	ah,-1
fxup:	shl	ax,1
	rcl	dx,1
	endm

madd1	macro
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

madd	macro
	local	maddend,itsneg
	push	bx
	push	cx
	push	dx
	cwd
	mov	cx,dx
	mov	bx,ax
	pop	ax
	cwd			; convert both to 32bit numbers
	add	ax,bx		; and then do 32 bit add
	adc	dx,cx
	js	itsneg		; negative?
	mov	bx,ax
	mov	cx,dx
	.sub_d	cx,bx,32767
	js	maddend		; not too big, so continue
	mov	ax,32767
	jmp	maddend

itsneg:	mov	bx,ax
	mov	cx,dx
	.add_d	cx,bx,32767	; see if too small
	jns	maddend
	mov	ax,-32767
maddend:
	pop	cx
	pop	bx		; restore other accums
	endm





.extrn	scos:auto,ssin:auto,atn2:auto
.extrn	mat2mul:auto
.extrn	calcsin:auto,ncalcmat:auto
;.extrn	wrtmat:auto,wword:auto,wcr:auto,dwword:auto



	public	getang
;	public	rotpr
;	public	rotopr
	public	rolpln
	public	rolmat
;
.dataseg
cpa	dw	0
cya	dw	0
spa	dw	0
sya	dw	0
xtemp	dw	0
ytemp	dw	0
rotang	dw	0
rolvec	dw	0,0,0
rolmat	dw	9 dup(0)
tmpmat	dw	9 dup(0)

.ends

.codeseg

;assume		cs:@codeseg, 
	assume ds:@dataseg, es:@dataseg

.proc	getang	auto		; takes a matrix in [bx], returns
				; 3 angles yaw,pitch,roll in [si]
	mov	dx,[bx+6]
	mov	ax,[bx]
	or	dh,dh		; test x,y to see if they are big enough
	jz	ysmal
	cmp	dh,-1
	jnz	ynsml
ysmal:	or	ah,ah
	jz	xsmal
	cmp	ah,-1
	jnz	ynsml
xsmal:				; x and y are too small to get a good angle	
	mov	ax,[bx+12]	; look at sign of z
	mov	dx,16384	; put a 90 degree angle into dx
	mov	cpa,0		; set up cosine and sign of them
	mov	cya,32767
	mov	spa,-32767
	mov	sya,0		; for zero yaw, but heavy pitch, man
	or	ax,ax		; test sign of z to determine sign of dx
	js	zpos
	neg	dx
	neg	spa		; reverse signs which need reversing
zpos:	mov	[si+2],dx	; set pitch angle to +- 90 deg
	mov	word ptr [si],0		; reset the yaw angle
	jmp	getrol		; now get the roll angle
ynsml:	push	si
	push	bx
	call	atn2
	pop	bx
	pop	si
	mov	[si],ax
	push	si
	call	ssin
	mov	sya,ax
	pop	si
	hmul	ax,[bx+6]
	push	dx
	push	si
	mov	ax,[si]
	call	scos
	mov	cya,ax
;	neg	ax
	pop	si
	hmul	ax,[bx]
	pop	ax
	push	bx
	madd
	pop	bx
;	add	ax,dx

	mov	dx,[bx+12]
	push	si
	push	bx
	call	atn2
	pop	bx
	pop	si
	neg	ax
	mov	[si+2],ax
getrol:	hmul	[bx+2],cya	;a 12
;	mov	ax,dx
;	call	wword

	push	dx
	hmul	[bx+8],sya	;a22
;	mov	ax,dx
;	call	wword
	pop	ax
	push	bx
	madd
;	call	wword
	pop	bx
;	add	ax,dx		; now the y comp of y' axis is un yawed
	mov	xtemp,ax
	hmul	[bx+2],sya	; now do the x comp
	neg	dx
;	mov	ax,dx
;;	call	wword
	push	dx
	hmul	[bx+8],cya
;	mov	ax,dx
;	call	wword
;	call	wcr
	pop	ax
	push	bx
	madd
;	call	wword
	pop	bx
;	add	ax,dx		; now the x and y components are unyawed
	mov	ytemp,ax
	mov	ax,[si+2]	; get the pitch
;	call	wword
	push	si
	call	scos		; get sign of pitch angle
	mov	cpa,ax
;	call	wword
	pop	si
	hmul	ax,[bx+14]	; a32 * cos pitch
;	mov	ax,dx
;	call	wword
	push	dx
	mov	ax,[si+2]
	push	si
	call	ssin		; get sin
	mov	spa,ax
;	call	wword
;	call	wcr
	pop	si
	hmul	ax,xtemp	; sin*x coord calced above
;	mov	ax,dx
;	call	wword
	pop	ax
	xchg	ax,dx
	push	bx
	madd
	pop	bx
;	add	dx,ax		; this should be the new z coord height
	mov	dx,ax
;	call	wword
	mov	ax,ytemp	; now we can calc the damn angle
;	call	wword
	push	si
	call	atn2		; get the angle
	pop	si
	mov	[si+4],ax	; save the angle
	ret
	.endp

IF 1 EQ 0
.proc	rotpr	auto
	mov	rotang,bx
	push	si
	push	ax
	call	scos
	mov	cya,ax
	pop	ax
	call	ssin
	pop	si
	mov	sya,ax
	mov	di,[si+2]
	mov	cx,[si+4]
	hmul	di,cya
	push	dx
	hmul	cx,sya
	pop	ax
	neg	dx
	madd
;	sub	ax,dx
	mov	[si+2],ax
	hmul	cx,cya
	push	dx
	hmul	di,sya
	pop	ax
	madd
;	add	ax,dx
	mov	[si+4],ax
	mov	di,[si+8]
	mov	cx,[si+10]
	hmul	di,cya
	push	dx
	hmul	cx,sya
	pop	ax
	neg	dx
	madd
;	sub	ax,dx
	mov	[si+8],ax
	hmul	cx,cya
	push	dx
	hmul	di,sya
	pop	ax
	madd
;	add	ax,dx
	mov	[si+10],ax
	mov	di,[si+14]
	mov	cx,[si+16]
	hmul	di,cya
	push	dx
	hmul	cx,sya
	pop	ax
	neg	dx
	madd
;	sub	ax,dx
	mov	[si+14],ax
	hmul	cx,cya
	push	dx
	hmul	di,sya
	pop	ax
	madd
;	add	ax,dx
	mov	[si+16],ax
	push	si
	mov	ax,rotang
	push	ax
	call	scos
	mov	cya,ax
	pop	ax
	call	ssin
	mov	sya,ax
	pop	si
	mov	di,[si]
	mov	cx,[si+4]
	hmul	di,cya
	push	dx
	hmul	cx,sya
	pop	ax
	neg	dx
	madd
;	sub	ax,dx
	mov	[si],ax
	hmul	cx,cya
	push	dx
	hmul	di,sya
	pop	ax
	madd
;	add	ax,dx
	mov	[si+4],ax
	mov	di,[si+6]
	mov	cx,[si+10]
	hmul	di,cya
	push	dx
	hmul	cx,sya
	pop	ax
	neg	dx
	madd
;	sub	ax,dx
	mov	[si+6],ax
	hmul	cx,cya
	push	dx
	hmul	di,sya
	pop	ax
	madd
;	add	ax,dx
	mov	[si+10],ax
	mov	di,[si+12]
	mov	cx,[si+16]
	hmul	di,cya
	push	dx
	hmul	cx,sya
	pop	ax
	neg	dx
	madd
;	sub	ax,dx
	dec	ax
	mov	[si+12],ax
	hmul	cx,cya
	push	dx
	hmul	di,sya
	pop	ax
	madd
;	add	ax,dx
	mov	[si+16],ax
	ret
	.endp


.proc	rotopr	auto
	mov	rotang,bx
	push	si
	push	ax
	call	scos
	mov	cya,ax
	pop	ax
	call	ssin
	pop	si
	mov	sya,ax
	mov	di,[si+6]
	mov	cx,[si+12]
	hmul	di,cya
	push	dx
	hmul	cx,sya
	pop	ax
	madd
	mov	[si+6],ax
	hmul	cx,cya
	push	dx
	hmul	di,sya
	pop	ax
	neg	dx
	madd
;	add	ax,dx
	mov	[si+12],ax
	mov	di,[si+8]
	mov	cx,[si+14]
	hmul	di,cya
	push	dx
	hmul	cx,sya
	pop	ax
	madd
;	sub	ax,dx
	mov	[si+8],ax
	hmul	cx,cya
	push	dx
	hmul	di,sya
	pop	ax
	neg	dx
	madd
	mov	[si+14],ax
	mov	di,[si+10]
	mov	cx,[si+16]
	hmul	di,cya
	push	dx
	hmul	cx,sya
	pop	ax
	madd
	mov	[si+10],ax
	hmul	cx,cya
	push	dx
	hmul	di,sya
	pop	ax
	neg	dx
	madd
	mov	[si+16],ax
	push	si
	mov	ax,rotang
	push	ax
	call	scos
	mov	cya,ax
	pop	ax
	call	ssin
	mov	sya,ax
	pop	si
	mov	di,[si]
	mov	cx,[si+12]
	hmul	di,cya
	push	dx
	hmul	cx,sya
	pop	ax
	madd
	mov	[si],ax
	hmul	cx,cya
	push	dx
	hmul	di,sya
	pop	ax
	neg	dx
	madd
	mov	[si+12],ax
	mov	di,[si+2]
	mov	cx,[si+14]
	hmul	di,cya
	push	dx
	hmul	cx,sya
	pop	ax
	madd
	mov	[si+2],ax
	hmul	cx,cya
	push	dx
	hmul	di,sya
	pop	ax
	neg	dx
	madd
	mov	[si+14],ax
	mov	di,[si+4]
	mov	cx,[si+16]
	hmul	di,cya
	push	dx
	hmul	cx,sya
	pop	ax
	madd
	dec	ax
	mov	[si+4],ax
	hmul	cx,cya
	push	dx
	hmul	di,sya
	pop	ax
	neg	dx
	madd
	mov	[si+16],ax
	ret
	.endp
ENDIF

.proc	rolpln	auto		; this trys to roll plane
				; ax contains roll angle
				; bx contains pitch angle
				; cx contains yaw angle
				; si contains old rotation matrix

	push	si
	mov	rolvec+4,ax	; save roll angle
	mov	rolvec+2,bx	; save pitch angle
	mov	rolvec,cx
	mov	bx,offset @dataseg:rolvec
	call	calcsin
	mov	si,offset @dataseg:rolmat	; make matrix of angles
	call	ncalcmat		;
;	push	si
;	mov	si,offset @dataseg:rolmat	; make matrix of angles
;	call	wrtmat
;	pop	si
	pop	bx
	mov	si,offset @dataseg:rolmat	; make matrix of angles
	mov	di,offset @dataseg:tmpmat	; prepare for matrix mul
	call	matmul

				; copy the source matrix
;	ret
	mov	cx,9
	mov	ax,ds
	mov	es,ax
	mov	di,bx
	mov	si,offset @dataseg:tmpmat
	rep	movsw
	ret
.endp




				; bx has source matrix
				; si has secondary matrix
				; di holds resultant matrix
.proc	matmul	auto		; multiplies two matrices
;	mov	si,offset @dataseg:tmat		; now multiply matrices
;	mov	di,offset @dataseg:omat
;	mov	bx,offset @dataseg:orot		; matrix of observer
	push	bx
	call	mat2mul
	pop	bx
	sub	di,10
	add	si,2
	push	bx
	call	mat2mul
	pop	bx
	add	si,2
	sub	di,10
	push	bx
	call	mat2mul
	pop	bx
	ret
	.endp

.ends
	end

