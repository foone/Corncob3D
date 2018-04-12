

frmsz	equ	2000
frmzx	equ	((frmsz*3)/2)
frmzy	equ	frmsz
frmzl	equ	(frmsz/2)
frmszr	equ	(frmzl)
frszx	equ	frmzx
frszy	equ	frmzy
frszl	equ	frmzl

frmpl1	dw	5
	dw	4
	dw	frmzx,-frmzy,-frmzl
	dw	frmzx,-frmzy,frmzl
	dw	frmzx,0,frmzl+frmszr
	dw	frmzx,frmzy,frmzl
	dw	frmzx,frmzy,-frmzl

frmpl2	dw	4
	dw	12
	dw	frmzx,frmzy,-frmzl
	dw	frmzx,frmzy,frmzl
	dw	-frmzx,frmzy,frmzl
	dw	-frmzx,frmzy,-frmzl

frmpl3	dw	4
	dw	12
	dw	frmzx,-frmzy,-frmzl
	dw	frmzx,-frmzy,frmzl
	dw	-frmzx,-frmzy,frmzl
	dw	-frmzx,-frmzy,-frmzl

frmpl4	dw	5
	dw	4
	dw	-frmzx,-frmzy,-frmzl
	dw	-frmzx,-frmzy,frmzl
	dw	-frmzx,0,frmzl+frmszr
	dw	-frmzx,frmzy,frmzl
	dw	-frmzx,frmzy,-frmzl

frmpl5	dw	4
	dw	0
	dw	-frmzx,-frmzy,frmzl
	dw	-frmzx,0,frmzl+frmszr
	dw	frmzx,0,frmzl+frmszr
	dw	frmzx,-frmzy,frmzl

frmpl6	dw	4
	dw	0
	dw	-frmzx,0,frmzl+frmszr
	dw	-frmzx,frmzy,frmzl
	dw	frmzx,frmzy,frmzl
	dw	frmzx,0,frmzl+frmszr


frire0	dw	1
	dw	0
	dw	-frszx,-frszy,-frszl
	dw	-frszx,-frszy,frszl

frfrm0	dw	1
	dw	frire0

frire1	dw	1
	dw	0
	dw	-frszx,frszy,-frszl
	dw	-frszx,frszy,frszl

frfrm1	dw	1
	dw	frire1

frire2	dw	1
	dw	0
	dw	frszx,frszy,-frszl
	dw	frszx,frszy,frszl

frfrm2	dw	1
	dw	frire2

frire3	dw	1
	dw	0
	dw	frszx,-frszy,-frszl
	dw	frszx,-frszy,frszl

frfrm3	dw	1
	dw	frire3



bmrobj	dw	0,0,0
	dw	5

	dw	0,0		; don't bother with top if too low
	dw	8,frmpl3	; show right side
	dw	8,frmpl5	; show right top
	dw	8,frmpl4	; draw rear portion
	dw	2,frfrm0	; rear right side

	dw	8,frmpl3	; show right side
	dw	8,frmpl4	; draw rear portion
	dw	8,frmpl6	; draw nice left top
	dw	8,frmpl5	; draw nice right top
	dw	2,frfrm0	; rear right side

	dw	0,0		; don't bother with top if too low
	dw	8,frmpl2	; show left side
	dw	8,frmpl6	; draw nice left top
	dw	8,frmpl4	; draw rear portion
	dw	2,frfrm1	; rear left side

	dw	8,frmpl5	; draw nice right top
	dw	8,frmpl2	; show left side
	dw	8,frmpl6	; draw nice left top
	dw	8,frmpl4	; draw rear portion
	dw	2,frfrm1	; rear left side

	dw	0,0		; don't bother with top if too low
	dw	8,frmpl3	; show right side
	dw	8,frmpl1	; draw front
	dw	8,frmpl5	; draw nice right top
	dw	2,frfrm3	; front right corner

	dw	8,frmpl3	; show right side
	dw	8,frmpl1	; draw front
	dw	8,frmpl6	; draw nice left top
	dw	8,frmpl5	; draw nice top
	dw	2,frfrm3	; front right corner

	dw	0,0		; don't bother with top if too low
	dw	8,frmpl2	; show left side
	dw	8,frmpl6	; draw nice left top
	dw	8,frmpl1	; draw front
	dw	2,frfrm2	; front left corner

	dw	8,frmpl2	; show left side
	dw	8,frmpl1	; draw front
	dw	8,frmpl5	; draw nice top
	dw	8,frmpl6	; draw nice left top
	dw	2,frfrm2	; front left corner

