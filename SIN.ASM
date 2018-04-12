	title 'sin'
; this subroutine generates a sin value given an argument
; the argument will be in the form of an integer from +-32767
; where 0 is 0 radians, and 32767 is 32767*pi/32768 radians
;
; argument is passed in ax
; sin value is returned in ax
;  integer value returned is abs(sin(x)*65536) if negflg is non-zero,
; then this unsigned integer is really negative
; note that an inaccurate result occurs for 90 deg, since 1. cannot be
; represented.

_MODEL	equ	<SMALL>
include model.inc

	public	negflg
	public	sin
	public	cos
	public	ssin
	public	scos

atnseg	segment	para 'horseshit'
sintbl	dw	0
	dw	402
	dw	804
	dw	1206
	dw	1608
	dw	2010
	dw	2412
	dw	2814
	dw	3216
	dw	3617
	dw	4019
	dw	4420
	dw	4821
	dw	5222
	dw	5623
	dw	6023
	dw	6424
	dw	6824
	dw	7224
	dw	7623
	dw	8022
	dw	8421
	dw	8820
	dw	9218
	dw	9616
	dw	10014
	dw	10411
	dw	10808
	dw	11204
	dw	11600
	dw	11996
	dw	12391
	dw	12785
	dw	13180
	dw	13573
	dw	13966
	dw	14359
	dw	14751
	dw	15143
	dw	15534
	dw	15924
	dw	16314
	dw	16703
	dw	17091
	dw	17479
	dw	17867
	dw	18253
	dw	18639
	dw	19024
	dw	19409
	dw	19792
	dw	20175
	dw	20557
	dw	20939
	dw	21320
	dw	21699
	dw	22078
	dw	22457
	dw	22834
	dw	23210
	dw	23586
	dw	23961
	dw	24335
	dw	24708
	dw	25080
	dw	25451
	dw	25821
	dw	26190
	dw	26558
	dw	26925
	dw	27291
	dw	27656
	dw	28020
	dw	28383
	dw	28745
	dw	29106
	dw	29466
	dw	29824
	dw	30182
	dw	30538
	dw	30893
	dw	31248
	dw	31600
	dw	31952
	dw	32303
	dw	32652
	dw	33000
	dw	33347
	dw	33692
	dw	34037
	dw	34380
	dw	34721
	dw	35062
	dw	35401
	dw	35738
	dw	36075
	dw	36410
	dw	36744
	dw	37076
	dw	37407
	dw	37736
	dw	38064
	dw	38391
	dw	38716
	dw	39040
	dw	39362
	dw	39683
	dw	40002
	dw	40320
	dw	40636
	dw	40951
	dw	41264
	dw	41576
	dw	41886
	dw	42194
	dw	42501
	dw	42806
	dw	43110
	dw	43412
	dw	43713
	dw	44011
	dw	44308
	dw	44604
	dw	44898
	dw	45190
	dw	45480
	dw	45769
	dw	46056
	dw	46341
	dw	46624
	dw	46906
	dw	47186
	dw	47464
	dw	47741
	dw	48015
	dw	48288
	dw	48559
	dw	48828
	dw	49095
	dw	49361
	dw	49624
	dw	49886
	dw	50146
	dw	50404
	dw	50660
	dw	50914
	dw	51166
	dw	51417
	dw	51665
	dw	51912
	dw	52156
	dw	52398
	dw	52639
	dw	52878
	dw	53114
	dw	53349
	dw	53581
	dw	53812
	dw	54040
	dw	54267
	dw	54491
	dw	54714
	dw	54934
	dw	55152
	dw	55368
	dw	55582
	dw	55794
	dw	56004
	dw	56212
	dw	56418
	dw	56621
	dw	56823
	dw	57022
	dw	57219
	dw	57414
	dw	57607
	dw	57798
	dw	57986
	dw	58172
	dw	58356
	dw	58538
	dw	58718
	dw	58896
	dw	59071
	dw	59244
	dw	59415
	dw	59583
	dw	59750
	dw	59914
	dw	60075
	dw	60235
	dw	60392
	dw	60547
	dw	60700
	dw	60851
	dw	60999
	dw	61145
	dw	61288
	dw	61429
	dw	61568
	dw	61705
	dw	61839
	dw	61971
	dw	62101
	dw	62228
	dw	62353
	dw	62476
	dw	62596
	dw	62714
	dw	62830
	dw	62943
	dw	63054
	dw	63162
	dw	63268
	dw	63372
	dw	63473
	dw	63572
	dw	63668
	dw	63763
	dw	63854
	dw	63944
	dw	64031
	dw	64115
	dw	64197
	dw	64277
	dw	64354
	dw	64429
	dw	64501
	dw	64571
	dw	64639
	dw	64704
	dw	64766
	dw	64827
	dw	64884
	dw	64940
	dw	64993
	dw	65043
	dw	65091
	dw	65137
	dw	65180
	dw	65220
	dw	65259
	dw	65294
	dw	65328
	dw	65358
	dw	65387
	dw	65413
	dw	65436
	dw	65457
	dw	65476
	dw	65492
	dw	65505
	dw	65516
	dw	65525
	dw	65531
	dw	65535
	dw	65535
atnseg	ends

.dataseg
negflg	db	0
.ends

.codeseg
	;assume cs:@codeseg,
	assume ds:@dataseg

sin	proc	near		; main procedure
	mov	negflg,0
	test	ax,7fffh	; see if zero, or -32768
	jnz	nok		; yup
	xor	ax,ax		; the answer is zero
	ret
nok:	mov	negflg,0	; clear flag
	or	ax,ax		; test the sign bit
	jns	notsgn		; see if neg 
	inc	negflg		; leave flag
	neg	ax		; and negate argument
notsgn:	test	ax,16384	; see if in outer quadrant
	jz	nioq		; not in outer quad
	mov	bx,ax
	mov	ax,32768
	sub	ax,bx		; subtract from 32768 to switch quad
nioq:	mov	cl,6		; now translate 0-16384 into 0-256
	mov	bx,ax		; save lower 6 bits
	shr	ax,cl
	shl	ax,1		; now multiply by two for word count
	mov	si,ax
		assume	es:atnseg
		push	es
		mov	ax,atnseg
		mov	es,ax
	mov	ax,es:[si+offset atnseg:sintbl+2]	; get next value
	sub	ax,es:[si+offset atnseg:sintbl]	; get sin value
	and	bx,63		; and off important bits
	mul	bx		; do interpolation
	mov	bx,64		; now divide back to scale
	div	bx
	add	ax,es:[si+offset atnseg:sintbl]	; now add original offset
	pop	es
		assume	es:nothing
	ret
sin	endp

cos	proc	near		; guess what this routine does?
	add	ax,16384
	jmp	sin
cos	endp

.proc	ssin	auto		; signed sign routine
	push	bx
	call	sin		; call regular sin
	shr	ax,1		; leave room for sign information
	cmp	negflg,0	; should we make it negative?
	jz	ssjp
	neg	ax		; yes, then change sin
ssjp:	
	pop	bx
	ret
.endp

.proc	scos	auto		; of course, man
	add	ax,16384
	jmp	ssin		; did you expect any different?
.endp

.ends
	end
