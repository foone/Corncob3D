
sdwtadj	macro
local	skdwt
;	endm
;m1111	macro
	push	cx
	push	bx
	mov	ax,ofrmticks
	imul	dx
	mov	bx,ticksf
	idiv	bx
	mov	dx,ax
	pop	bx
	pop	cx
	endm

dwtadj	macro
;	endm
;m1111	macro
	push	cx
	push	bx
	mov	bx,ofrmticks
	.muls_dw	bx,cx
	mov	bx,ticksf
	call	divrs_dw
	pop	bx
	pop	cx
	endm
wtadj	macro
;	endm
;m2222	macro
	push	cx
	push	dx
	mov	cx,ofrmticks
	imul	cx
	mov	cx,ticksf
	idiv	cx
	pop	dx
	pop	cx
	endm

uwtadj	macro
;	endm
;m2222	macro
	push	cx
	push	dx
	mov	cx,ticksf
	imul	cx
	mov	cx,ofrmticks
	idiv	cx
	pop	dx
	pop	cx
	endm

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

bndck	macro	high,low
	local	lok1,lok2
	cmp	ax,high
	jl	lok1
	mov	ax,high
lok1:	cmp	ax,low
	jg	lok2
	mov	ax,low
lok2:
	endm

	
