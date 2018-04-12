	title	'clip'
	public	clip


_MODEL	equ	<SMALL>
include c:\sa\model.inc
include extrns.inc



; this routine clips line segments into a rectangular window
; the window coords are passed in the pointer si
;
wxmin	equ	0
wymin	equ	2
wxmax	equ	4
wymax	equ	6
wxsiz	equ	8
wysiz	equ	10

xmin	equ	[si+wxmin]
ymin	equ	[si+wymin]
xmax	equ	[si+wxmax]
ymax	equ	[si+wymax]

.dataseg
code1	db	0
code2	db	0
delx	dw	0
dely	dw	0
.ends

.codeseg
	assume cs:@codeseg,ds:@dataseg
scode1	proc	near		; sets the xcode
	mov	code1,0
	mov	ax,argx1
	cmp	ax,xmin		; is the argx1 less than xmin?
	jns	l01
	or	code1,1
l01:	cmp	ax,xmax
	js	l02
	jz	l02
	or	code1,4
l02:	mov	ax,argy1
	cmp	ax,ymin
	jns	l03
	or	code1,2
l03:	cmp	ax,ymax
	js	l04
	jz	l04
	or	code1,8
l04:	ret
scode1	endp

scode2	proc	near		; sets the xcode
	mov	code2,0
	mov	ax,argx2
	cmp	ax,xmin		; is the argx1 less than xmin?
	jns	ll01
	or	code2,1
ll01:	cmp	ax,xmax
	js	ll02
	jz	ll02
	or	code2,4
ll02:	mov	ax,argy2
	cmp	ax,ymin
	jns	ll03
	or	code2,2
ll03:	cmp	ax,ymax
	js	ll04
	jz	ll04
	or	code2,8
ll04:	ret
scode2	endp

csetup	proc	near		; sets up some values
	mov	ax,argx2
	sub	ax,argx1
	mov	delx,ax		; save delta-x
	mov	ax,argy2
	sub	ax,argy1
	mov	dely,ax
	ret
csetup	endp

yline	proc	near		; clips y(x) line
	sub	ax,argx1
	mov	bx,dely
	imul	bx
	mov	bx,delx
	idiv	bx
	add	ax,argy1
	ret
yline	endp

xline	proc	near		; clips x(y) line
	sub	ax,argy1
	mov	bx,delx
	imul	bx
	mov	bx,dely
	idiv	bx
	add	ax,argx1
	ret
xline	endp

fixx1a	proc	near		; fixes x1
	call	csetup		; calc delta x and dely
	test	code1,1		; is x1 too small?
	jz	fx1
	mov	ax,xmin
	call	yline		; get intersection of line and x=xmin
	mov	argy1,ax
	mov	ax,xmin
	mov	argx1,ax
fx1:	test	code1,4		; see if too big
	jz	fx3
	mov	ax,xmax
	call	yline
	mov	argy1,ax
	mov	ax,xmax
	mov	argx1,ax
fx3:	ret
fixx1a	endp

fixx1b	proc	near		; fixes x1
	call	csetup		; calc delta x and dely
	test	code1,2		; is x1 too small?
	jz	fx2
	mov	ax,ymin
	call	xline		; get intersection of line and x=xmin
	mov	argx1,ax
	mov	ax,ymin
	mov	argy1,ax
fx2:	test	code1,8		; see if too big
	jz	fx4
	mov	ax,ymax
	call	xline
	mov	argx1,ax
	mov	ax,ymax
	mov	argy1,ax
fx4:	ret
fixx1b	endp

fixx2a	proc	near		; fixes x1
	call	csetup		; calc delta x and dely
	test	code2,1		; is x1 too small?
	jz	fx5
	mov	ax,xmin
	call	yline		; get intersection of line and x=xmin
	mov	argy2,ax
	mov	ax,xmin
	mov	argx2,ax
fx5:	test	code2,4		; see if too big
	jz	fx7
	mov	ax,xmax
	call	yline
	mov	argy2,ax
	mov	ax,xmax
	mov	argx2,ax
fx7:	ret
fixx2a	endp

fixx2b	proc	near		; fixes x1
	call	csetup		; calc delta x and dely
	test	code2,2		; is x1 too small?
	jz	fx6
	mov	ax,ymin
	call	xline		; get intersection of line and x=xmin
	mov	argx2,ax
	mov	ax,ymin
	mov	argy2,ax
fx6:	test	code2,8		; see if too big
	jz	fx8
	mov	ax,ymax
	call	xline
	mov	argx2,ax
	mov	ax,ymax
	mov	argy2,ax
fx8:	ret
fixx2b	endp

	assume	ds:@dataseg
clip	proc	near		; clips line 
	call	scode1		; get code1
	call	scode2
	mov	al,code1	; see if line requires clipping at all
	or	al,code2
	clc
	jz	noclip		; if zero, no clipping needed!
	mov	al,code1
	and	al,code2	; if non-zero, no line needed!
	stc
	jnz	noclip
	call	fixx1a		; try fixing x coords
	call	fixx2a
; now try again, maybe all the clipping is done..
	call	scode1		; get code1
	call	scode2
	mov	al,code1	; see if line requires clipping at all
	or	al,code2
	clc
	jz	noclip		; if zero, no clipping needed!
	mov	al,code1
	and	al,code2	; if non-zero, no line needed!
	stc
	jnz	noclip
	call	fixx1b		; try fixing y coords
	call	fixx2b
	clc
noclip:	ret
clip	endp
.ends
	end

