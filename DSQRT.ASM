	title 'dsqrt'
;
; argument is passed in dx:ax
; sqrt value is returned in ax

_MODEL	equ	<SMALL>
include model.inc

	public	dsqrt
.dataseg
.ends

.codeseg
	;assume cs:@codeseg,
	assume ds:@dataseg

.proc	dsqrt	auto		; 
	test	dx,0c000h	; are the top two bits clear?
	jz	scarboro	; if not, then subject is too large
dsqrabt:
	mov	ax,32767
	ret
scarboro:
	push	dx
	push	ax		; save for later
	shl	ax,1
	rcl	dx,1
	shl	ax,1
	rcl	dx,1
	mov	bx,32767	; di, and bx are our guesses
	mov	di,23170	; 23170 = 32767/sqrt(2)
	mov	cx,14		; fifteen iterations
guessloop:
	shl	ax,1
	rcl	dx,1
	jc	usebx
	shl	ax,1
	rcl	dx,1
	jc	usedi
	shr	bx,1		; as we prove the number is smaller
	shr	di,1		; we downscale our guess
	loop	guessloop
	pop	ax
	pop	ax
	mov	ax,1		; don't return zero, return 1 as lowest
	ret

usedi:	mov	bx,di
usebx:
	pop	ax		; restore number
	pop	dx
	mov	di,ax
dsqlp:
	mov	cx,bx
	push	dx
	mov	ax,di
	div	bx
	pop	dx
	add	bx,ax
	shr	bx,1
	sub	cx,bx
	jns	dsql2
	neg	cx
dsql2:	cmp	cx,3
	jns	dsqlp
	ret
.endp
.ends
	end
