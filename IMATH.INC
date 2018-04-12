IF __MASM6__
  option	DOTNAME
ENDIF
.abs_b		macro	arg1
local		nosign
		or	arg1,arg1
		 jns	nosign
		neg	arg1
nosign		label	near
endm
.abs_w		equ	<.abs_b>
.abs_d		macro	arg1,arg2
local		nosign
		or	arg1,arg1
		 jns	nosign
		.neg_d	arg1,arg2
nosign		label	near
endm
.abs_q		macro	arg1,arg2
local		nosign
		test	byte ptr arg1+7,80h
		 jns	nosign
		.neg_q	arg1,arg2
nosign		label	near
endm
.add_d		macro	arg1,arg2,arg3
		add	arg2,arg3
  IF (arg3 GE 0)
		adc	arg1,0
  ELSE
		adc	arg1,-1
  ENDIF
endm
.add_dw		macro	arg1,arg2,arg3
		add	arg2,arg3
		adc	arg1,0
endm
.add_dd		macro	arg1,arg2,arg3,arg4
		add	arg2,arg4
		adc	arg1,arg3
endm
.add_q		macro	arg1,arg2,arg3
  IFNB <arg3>
    IF (arg2 GE 0)
		xor	arg3,arg3
    ELSEIF (arg2 LT 0)
		mov	arg3,-1
    ENDIF
		add	word ptr arg1,arg2
		adc	word ptr arg1+2,arg3
		adc	word ptr arg1+4,arg3
		adc	word ptr arg1+6,arg3
  ELSE
		add	word ptr arg1,arg2
    IF (arg2 GE 0)
		adc	word ptr arg1+2,0
		adc	word ptr arg1+4,0
		adc	word ptr arg1+6,0
    ELSEIF (arg2 LT 0)
		adc	word ptr arg1+2,-1
		adc	word ptr arg1+4,-1
		adc	word ptr arg1+6,-1
    ENDIF
  ENDIF
endm
.add_qw		macro	arg1,arg2,arg3
  IFNB <arg3>
		xor	arg3,arg3
		add	word ptr arg1,arg2
		adc	word ptr arg1+2,arg3
		adc	word ptr arg1+4,arg3
		adc	word ptr arg1+6,arg3
  ELSE
		add	word ptr arg1,arg2
		adc	word ptr arg1+2,0
		adc	word ptr arg1+4,0
		adc	word ptr arg1+6,0
  ENDIF
endm
.add_qd		macro	arg1,arg2,arg3,arg4
  IFNB <arg4>
		xor	arg4,arg4
		add	word ptr arg1,arg3
		adc	word ptr arg1+2,arg2
		adc	word ptr arg1+4,arg4
		adc	word ptr arg1+6,arg4
  ELSE
		add	word ptr arg1,arg3
		adc	word ptr arg1+2,arg2
		adc	word ptr arg1+4,0
		adc	word ptr arg1+6,0
  ENDIF
endm
.add_qq		macro	arg1,arg2,arg3
  IFNB <arg3>
		mov	arg3,word ptr arg2
		add	word ptr arg1,arg3
		mov	arg3,word ptr arg2+2
		adc	word ptr arg1+2,arg3
		mov	arg3,word ptr arg2+4
		adc	word ptr arg1+4,arg3
		mov	arg3,word ptr arg2+6
		adc	word ptr arg1+6,arg3
  ELSE
		push	ax
		.add_qq	arg1,arg2,ax
		pop	ax
  ENDIF
endm
.adds_d		equ	<.add_d>
.adds_dw	macro	arg1,arg2,arg3,arg4
local		nosign
  IFNB <arg4>
		xor	arg4,arg4
		test	arg3,arg3
		 jns	nosign
		dec	arg4
nosign:		add	arg2,arg3
		adc	arg1,arg4
  ELSE
		push	bp
		.adds_dw arg1,arg2,arg3,bp
		pop	bp
  ENDIF
endm
.adds_dd	equ	<.add_dd>
.adds_q		equ	<.add_q>
.adds_qw	macro	arg1,arg2,arg3
local		nosign
  IFNB <arg3>
		xor	arg3,arg3
		test	arg2,arg2
		 jns	nosign
		dec	arg3
nosign:		add	word ptr arg1,arg2
		adc	word ptr arg1+2,arg3
		adc	word ptr arg1+4,arg3
		adc	word ptr arg1+6,arg3
  ELSE
		push	bp
		.adds_qw arg1,arg2,bp
		pop	bp
  ENDIF
endm
.adds_qd	macro	arg1,arg2,arg3,arg4
local		nosign
  IFNB <arg4>
		xor	arg4,arg4
		test	arg2,arg2
		 jns	nosign
		dec	arg4
nosign:		add	word ptr arg1,arg3
		adc	word ptr arg1+2,arg2
		adc	word ptr arg1+4,arg4
		adc	word ptr arg1+6,arg4
  ELSE
		push	bp
		.adds_qd arg1,arg2,arg3,bp
		pop	bp
  ENDIF
endm
.adds_qq	equ	<.add_qq>
.cmp_d		macro	arg1,arg2,arg3
local		done
  IF (ARG3 GE 0)
		cmp	arg1,0
  ELSEIF (ARG3 LT 0)
		cmp	arg1,-1
  ENDIF
		 jne	done
		cmp	arg2,arg3
done		label	near
endm
.cmp_dw		macro	arg1,arg2,arg3
local		done
		cmp	arg1,0
		 jne	done
		cmp	arg2,arg3
done		label	near
endm
.cmp_dd		macro	arg1,arg2,arg3,arg4
local		done
		cmp	arg1,arg3
		 jne	done
		cmp	arg2,arg4
done		label	near
endm
.cmp_q		macro	arg1,arg2,arg3
local		done
  IFNB <arg3>
    IF (arg2 GE 0)
		xor	arg3,arg3
    ELSEIF (arg2 LT 0)
		mov	arg3,-1
    ENDIF
		cmp	word ptr arg1+6,arg3
		 jne	done
		cmp	word ptr arg1+4,arg3
		 jne	done
		cmp	word ptr arg1+2,arg3
		 jne	done
		cmp	word ptr arg1,arg2
  ELSE
    IF (arg2 GE 0)
		cmp	word ptr arg1+6,0
		 jne	done
		cmp	word ptr arg1+4,0
		 jne	done
		cmp	word ptr arg1+2,0
		 jne	done
		cmp	word ptr arg1,arg2
    ELSEIF (arg2 LT 0)
		cmp	word ptr arg1+6,-1
		 jne	done
		cmp	word ptr arg1+4,-1
		 jne	done
		cmp	word ptr arg1+2,-1
		 jne	done
		cmp	word ptr arg1,arg2
    ENDIF
  ENDIF
done		label	near
endm
.cmp_qw		macro	arg1,arg2,arg3
local		done
  IFNB <arg3>
		xor	arg3,arg3
		cmp	word ptr arg1+6,arg3
		 jne	done
		cmp	word ptr arg1+4,arg3
		 jne	done
		cmp	word ptr arg1+2,arg3
		 jne	done
		cmp	word ptr arg1,arg2
done		label	near
  ELSEIFDIFI <arg2>,<ax>
		push	ax
		.cmp_qw	arg1,arg2,ax
		pop	ax
  ELSE
		push	dx
		.cmp_qw	arg1,arg2,dx
		pop	dx
  ENDIF
endm
.cmp_qd		macro	arg1,arg2,arg3
local		done
		cmp	word ptr arg1+6,0
		 jne	done
		cmp	word ptr arg1+4,0
		 jne	done
		cmp	word ptr arg1+2,arg2
		 jne	done
		cmp	word ptr arg1,arg3
done		label	near
endm
.cmp_qq		macro	arg1,arg2,arg3
local		done
  IFNB <arg3>
		mov	arg3,word ptr arg1+6
		cmp	arg3,word ptr arg2+6
		 jne	done
		mov	arg3,word ptr arg1+4
		cmp	arg3,word ptr arg2+4
		 jne	done
		mov	arg3,word ptr arg1+2
		cmp	arg3,word ptr arg2+2
		 jne	done
		mov	arg3,word ptr arg1
		cmp	arg3,word ptr arg2
done		label	near
  ELSE
		push	ax
		.cmp_qq	arg1,arg2,ax
		pop	ax
  ENDIF
endm
IF __MASM6__
  option	DOTNAME
ENDIF
.dec_d		macro	arg1,arg2
		sub	arg2,1
		sbb	arg1,0
endm
.dec_q		macro	arg1,arg2
  IFNB <arg2>
		xor	arg2,arg2
		sub	word ptr arg1,1
		sbb	word ptr arg1+2,arg2
		sbb	word ptr arg1+4,arg2
		sbb	word ptr arg1+6,arg2
  ELSE
		sub	word ptr arg1,1
		sbb	word ptr arg1+2,0
		sbb	word ptr arg1+4,0
		sbb	word ptr arg1+6,0
  ENDIF
endm
.divr_wb	macro	arg1
local		round, noround
		div	arg1
		shl	ah,1
		 jc	round
		cmp	ah,arg1
		 jb	noround
round:		inc	ax
noround		label	near
endm
.divr_dw	macro	arg1
local		round, noround
		div	arg1
		shl	dx,1
		 jc	round
		cmp	dx,arg1
		 jb	noround
round:		inc	ax
noround		label	near
endm
.inc_d		macro	arg1,arg2
		add	arg2,1
		adc	arg1,0
endm
.inc_q		macro	arg1,arg2
  IFNB <arg2>
		xor	arg2,arg2
		add	word ptr arg1,1
		adc	word ptr arg1+2,arg2
		adc	word ptr arg1+4,arg2
		adc	word ptr arg1+6,arg2
  ELSE
		add	word ptr arg1,1
		adc	word ptr arg1+2,0
		adc	word ptr arg1+4,0
		adc	word ptr arg1+6,0
  ENDIF
endm
.mov_d		macro	arg1,arg2,arg3
		mov	arg2,arg3
  IF (arg3 GE 0)
		xor	arg1,arg1
  ELSE
		mov	arg1,-1
  ENDIF
endm
.mov_dw		macro	arg1,arg2,arg3
  IFDIFI <arg2>,<arg3>
		mov	arg2,arg3
  ENDIF
		xor	arg1,arg1
endm
.mov_q		macro	arg1,arg2,arg3
  IFNB <arg3>
    IF (arg2 EQ 0)
		xor	arg3,arg3
		mov	word ptr arg1,arg3
    ELSEIF (arg2 GT 0)
		xor	arg3,arg3
		mov	word ptr arg1,arg2
    ELSE
		mov	arg3,-1
		mov	word ptr arg1,arg2
    ENDIF
		mov	word ptr arg1+2,arg3
		mov	word ptr arg1+4,arg3
		mov	word ptr arg1+6,arg3
  ELSE
		mov	word ptr arg1,arg2
    IF (arg2 GE 0)
		mov	word ptr arg1+2,0
		mov	word ptr arg1+4,0
		mov	word ptr arg1+6,0
    ELSE
		mov	word ptr arg1+2,-1
		mov	word ptr arg1+4,-1
		mov	word ptr arg1+6,-1
    ENDIF
  ENDIF
endm
.mov_qw		macro	arg1,arg2,arg3
		mov	word ptr arg1,arg2
  IFNB <arg3>
		xor	arg3,arg3
		mov	word ptr arg1+2,arg3
		mov	word ptr arg1+4,arg3
		mov	word ptr arg1+6,arg3
  ELSE
		mov	word ptr arg1+2,0
		mov	word ptr arg1+4,0
		mov	word ptr arg1+6,0
  ENDIF
endm
.mov_qd		macro	arg1,arg2,arg3,arg4
		mov	word ptr arg1,arg3
		mov	word ptr arg1+2,arg2
  IFNB <arg4>
		xor	arg4,arg4
		mov	word ptr arg1+4,arg4
		mov	word ptr arg1+6,arg4
  ELSE
		mov	word ptr arg1+4,0
		mov	word ptr arg1+6,0
  ENDIF
endm
.mov_qq		macro	arg1,arg2,arg3
  IFNB <arg3>
		mov	arg3,word ptr arg2
		mov	word ptr arg1,arg3
		mov	arg3,word ptr arg2+2
		mov	word ptr arg1+2,arg3
		mov	arg3,word ptr arg2+4
		mov	word ptr arg1+4,arg3
		mov	arg3,word ptr arg2+6
		mov	word ptr arg1+6,arg3
  ELSE
		push	ax
		.mov_qq	arg1,arg2,ax
		pop	ax
  ENDIF
endm
.mov_qqes	macro
		push	si
		push	di
		movsw
		movsw
		movsw
		movsw
		pop	di
		pop	si
endm
.movs_d		equ	<.mov_d>
.movs_dw	macro	arg1,arg2,arg3
local		nosign
  IFDIFI <arg2>,<arg3>
		mov	arg2,arg3
  ENDIF
		xor	arg1,arg1
		test	arg2,arg2
		 jns	nosign
		dec	arg1
nosign		label	near
endm
.movs_q		equ	<.mov_q>
.movs_qw	macro	arg1,arg2,arg3
local		nosign
  IFIDNI <arg2>,<ax>
    IFNB <arg3>
		mov	word ptr arg1,arg2
      IFIDNI <arg3>,<dx>
		cwd
      ELSE
        IFDIFI <arg2>,<arg3>
		xor	arg3,arg3
		test	arg2,arg2
        ELSE
		test	arg2,arg2
		mov	arg3,0
        ENDIF
		 jns	nosign
		dec	arg3
      ENDIF
nosign:		mov	word ptr arg1+2,arg3
		mov	word ptr arg1+4,arg3
		mov	word ptr arg1+6,arg3
    ELSE
		push	dx
		.movs_qw arg1,arg2,dx
		pop	dx
    ENDIF
  ELSE
    IFNB <arg3>
		mov	word ptr arg1,arg2
      IFDIFI <arg2>,<arg3>
		xor	arg3,arg3
		test	arg2,arg2
      ELSE
		test	arg2,arg2
		mov	arg3,0
      ENDIF
		 jns	nosign
		dec	arg3
nosign:		mov	word ptr arg1+2,arg3
		mov	word ptr arg1+4,arg3
		mov	word ptr arg1+6,arg3
    ELSE
		push	ax
		.movs_qw arg1,arg2,ax
		pop	ax
    ENDIF
  ENDIF
endm
.movs_qd	macro	arg1,arg2,arg3,arg4
local		nosign
  IFIDNI <arg2>,<ax>
    IFNB <arg4>
		mov	word ptr arg1,arg3
		mov	word ptr arg1+2,arg2
      IFIDNI <arg4>,<dx>
		cwd
      ELSE
        IFDIFI <arg2>,<arg4>
		xor	arg4,arg4
		test	arg2,arg2
        ELSE
		test	arg2,arg2
		mov	arg4,0
        ENDIF
		 jns	nosign
		dec	arg4
      ENDIF
nosign:		mov	word ptr arg1+4,arg4
		mov	word ptr arg1+6,arg4
    ELSE
		push	dx
		.movs_qd arg1,arg2,arg3,dx
		pop	dx
    ENDIF
  ELSE
    IFNB <arg4>
		mov	word ptr arg1,arg3
		mov	word ptr arg1+2,arg2
      IFDIFI <arg2>,<arg4>
		xor	arg4,arg4
		test	arg2,arg2
      ELSE
		test	arg2,arg2
		mov	arg4,0
      ENDIF
		 jns	nosign
		dec	arg4
nosign:		mov	word ptr arg1+4,arg4
		mov	word ptr arg1+6,arg4
    ELSE
		push	ax
		.movs_qd arg1,arg2,arg3,ax
		pop	ax
    ENDIF
  ENDIF
endm
.movs_qq	equ	<.mov_qq>
.movs_qqes	equ	<.mov_qqes>
.mul_dw		macro	arg1,arg2
  IFNB <arg2>
		xchg	arg2,ax
		xchg	ax,dx
		mul	arg1
		xchg	arg2,ax
		mul	arg1
		add	dx,arg2
  ELSE
    IFDIFI <arg1>,<cx>
		push	cx
		.mul_dw	arg1,cx
		pop	cx
    ELSE
		push	bx
		.mul_dw	arg1,bx
		pop	bx
    ENDIF
  ENDIF
endm
.muls_dw	macro	arg1,arg2
local		pos_mult
  IFNB <arg2>
		xchg	arg2,ax
		xchg	ax,dx
		mul	arg1
		xchg	arg2,ax
		or	arg1,arg1
		 jns	pos_mult
		sub	arg2,ax
pos_mult:	mul	arg1
		add	dx,arg2
  ELSE
    IFDIFI <arg1>,<cx>
		push	cx
		.muls_dw arg1,cx
		pop	cx
    ELSE
		push	bx
		.muls_dw arg1,bx
		pop	bx
    ENDIF
 ENDIF
endm
.neg_d		macro	arg1,arg2
		neg	arg1
		neg	arg2
		sbb	arg1,0
endm
.neg_q		macro	arg1,arg2
		not	word ptr arg1+6
		not	word ptr arg1+4
		not	word ptr arg1+2
  IFNB <arg2>
		xor	arg2,arg2
		neg	word ptr arg1
		cmc
		adc	word ptr arg1+2,arg2
		adc	word ptr arg1+4,arg2
		adc	word ptr arg1+6,arg2
  ELSE
		neg	word ptr arg1
		cmc
		adc	word ptr arg1+2,0
		adc	word ptr arg1+4,0
		adc	word ptr arg1+6,0
  ENDIF
endm
IF __MASM6__
  option	DOTNAME
ENDIF
.sgn_b		macro	arg1,arg2
		test	arg1,arg1
endm
.sgn_w		equ	<.sgn_b>
.sgn_d		equ	<.sgn_b>
.sgn_q		macro	arg1
		test	byte ptr arg1+7,80h
endm
.sub_d		macro	arg1,arg2,arg3
		sub	arg2,arg3
  IF (arg3 GE 0)
		sbb	arg1,0
  ELSE
		sbb	arg1,-1
  ENDIF
endm
.sub_dw		macro	arg1,arg2,arg3
		sub	arg2,arg3
		sbb	arg1,0
endm
.sub_dd		macro	arg1,arg2,arg3,arg4
		sub	arg2,arg4
		sbb	arg1,arg3
endm
.sub_q		macro	arg1,arg2,arg3
  IFNB <arg3>
    IF (arg2 GE 0)
		xor	arg3,arg3
		sub	word ptr arg1,arg2
    ELSEIF (arg2 LT 0)
		mov	arg3,-1
		sub	word ptr arg1,arg2
    ENDIF
		sbb	word ptr arg1+2,arg3
		sbb	word ptr arg1+4,arg3
		sbb	word ptr arg1+6,arg3
  ELSE
		sub	word ptr arg1,arg2
    IF (arg2 GE 0)
		sbb	word ptr arg1+2,0
		sbb	word ptr arg1+4,0
		sbb	word ptr arg1+6,0
    ELSEIF (arg2 LT 0)
		sbb	word ptr arg1+2,-1
		sbb	word ptr arg1+4,-1
		sbb	word ptr arg1+6,-1
    ENDIF
  ENDIF
endm
.sub_qw		macro	arg1,arg2,arg3
  IFNB <arg3>
		xor	arg3,arg3
		sub	word ptr arg1,arg2
		sbb	word ptr arg1+2,arg3
		sbb	word ptr arg1+4,arg3
		sbb	word ptr arg1+6,arg3
  ELSE
		sub	word ptr arg1,arg2
		sbb	word ptr arg1+2,0
		sbb	word ptr arg1+4,0
		sbb	word ptr arg1+6,0
  ENDIF
endm
.sub_qd		macro	arg1,arg2,arg3,arg4
  IFNB <arg4>
		xor	arg4,arg4
		sub	word ptr arg1,arg3
		sbb	word ptr arg1+2,arg2
		sbb	word ptr arg1+4,arg4
		sbb	word ptr arg1+6,arg4
  ELSE
		sub	word ptr arg1,arg3
		sbb	word ptr arg1+2,arg2
		sbb	word ptr arg1+4,0
		sbb	word ptr arg1+6,0
  ENDIF
endm
.sub_qq		macro	arg1,arg2,arg3
  IFNB <arg3>
		mov	arg3,word ptr arg2
		sub	word ptr arg1,arg3
		mov	arg3,word ptr arg2+2
		sbb	word ptr arg1+2,arg3
		mov	arg3,word ptr arg2+4
		sbb	word ptr arg1+4,arg3
		mov	arg3,word ptr arg2+6
		sbb	word ptr arg1+6,arg3
  ELSE
		push	ax
		.sub_qq	arg1,arg2,ax
		pop	ax
  ENDIF
endm
.subs_d		equ	<.sub_d>
.subs_dw	macro	arg1,arg2,arg3,arg4
local		nosign
  IFNB <arg4>
		xor	arg4,arg4
		test	arg3,arg3
		 jns	nosign
		dec	arg4
nosign:		sub	arg2,arg3
		sbb	arg1,arg4
  ELSE
		push	bp
		.subs_dw arg1,arg2,arg3,bp
		pop	bp
  ENDIF
endm
.subs_dd	equ	<.sub_dd>
.subs_q		equ	<.sub_q>
.subs_qw	macro	arg1,arg2,arg3
local		nosign
  IFNB <arg3>
		xor	arg3,arg3
		test	arg2,arg2
		 jns	nosign
		dec	arg3
nosign:		sub	word ptr arg1,arg2
		sbb	word ptr arg1+2,arg3
		sbb	word ptr arg1+4,arg3
		sbb	word ptr arg1+6,arg3
  ELSE
		push	bp
		.subs_qw arg1,arg2,bp
		pop	bp
  ENDIF
endm
.subs_qd	macro	arg1,arg2,arg3,arg4
local		nosign
  IFNB <arg4>
		xor	arg4,arg4
		test	arg2,arg2
		 jns	nosign
		dec	arg4
nosign:		sub	word ptr arg1,arg3
		sbb	word ptr arg1+2,arg2
		sbb	word ptr arg1+4,arg4
		sbb	word ptr arg1+6,arg4
  ELSE
		push	bp
		.subs_qd arg1,arg2,arg3,bp
		pop	bp
  ENDIF
endm
.subs_qq	equ	<.sub_qq>
