
vgmode	equ	010h
;vgmode	equ	00dh
;vgmode	equ	81h
IF vgmode EQ 81h
lconst	equ	bpl+2000h
ENDIF
IF vgmode NE 81h
lconst	equ	bpl
ENDIF


	IF vgmode EQ 10h
	  vgseg	equ	0a000h
	  bpl	equ	80
	  boffs	equ	3
	  vxsiz	equ	640
	  vysiz	equ	350
	  nilns	equ	149
	  pgadr0 equ	0
	  pgadr1 equ	7e00h
	  gfxmin	equ	8
	  gfymin	equ	4
	  gfxmax	equ	631
	  gfymax	equ	199
	  gfxsz		equ	gfxmax-gfxmin
	  gfysz		equ	gfymax-gfymin
	  gfxpln	equ	300
	  gfypln	equ	200
	  gfxctr	equ	(gfxmin+gfxmax)/2
	  gfyctr	equ	(gfymin+gfymax)/2
	  gfmnb		equ	gfymin*bpl+(gfxmin/8)
	  gfmxb		equ	gfymax*bpl

	  gtxmin	equ	168
	  gtymin	equ	254
	  gtxmax	equ	471
	  gtymax	equ	344
	  gtxsz		equ	gtxmax-gtxmin
	  gtysz		equ	gtymax-gtymin
	  gtxpln	equ	150
	  gtypln	equ	100
	  gtxctr	equ	(gtxmin+gtxmax+1)/2
	  gtyctr	equ	(gtymin+gtymax+1)/2
	  gtmnb		equ	gtymin*bpl+(gtxmin/8)
	  gtmxb		equ	gtymax*bpl

	  gfsxmin	equ	8
	  gfsymin	equ	4
	  gfsxmax	equ	631
	  gfsymax	equ	345
	  gfsxsz		equ	gfsxmax-gfsxmin
	  gfsysz		equ	gfsymax-gfsymin
	  gfsxpln	equ	300
	  gfsypln	equ	200
	  gfsxctr	equ	(gfsxmin+gfsxmax)/2
	  gfsyctr	equ	(gfsymin+gfsymax)/2
	  gfsmnb		equ	gfsymin*bpl+(gfsxmin/8)
	  gfsmxb		equ	gfsymax*bpl

mgwins  macro	
gwinf	dw	gfxmin,gfymin
	dw	gfxmax,gfymax
	dw	gfxsz,gfysz
	dw	gfxpln,gfypln
	dw	gfxctr,gfyctr
	dw	gfmnb,gfmxb

gwint	dw	gtxmin,gtymin
	dw	gtxmax,gtymax
	dw	gtxsz,gtysz
	dw	gtxpln,gtypln
	dw	gtxctr,gtyctr
	dw	gtmnb,gtmxb
;	8,4,631,199,622,193,300,200,320,102,4*80,199*80
;	168,254,471,344,303,95,150,100,320,297,254*80,344*80
gwinfs	dw	gfsxmin,gfsymin
	dw	gfsxmax,gfsymax
	dw	gfsxsz,gfsysz
	dw	gfsxpln,gfsypln
	dw	gfsxctr,gfsyctr
	dw	gfsmnb,gfsmxb
	  endm
	ENDIF
	IF vgmode EQ 0dh
	  vgseg	equ	0a000h
	  bpl	equ	40
	  boffs	equ	3
	  vxsiz	equ	320
	  vysiz	equ	200
	  pgadr0 equ	0
	  pgadr1 equ	7e00h
	  gfxmin	equ	8
	  gfymin	equ	4
	  gfxmax	equ	315
	  gfymax	equ	114
	  gfxsz		equ	gfxmax-gfxmin
	  gfysz		equ	gfymax-gfymin
	  gfxpln	equ	150
	  gfypln	equ	114
	  gfxctr	equ	(gfxmin+gfxmax)/2
	  gfyctr	equ	(gfymin+gfymax)/2
	  gfmnb		equ	gfymin*bpl+(gfxmin/8)
	  gfmxb		equ	gfymax*bpl

	  nilns	equ	vysiz-gfymax-1

	  gtxmin	equ	88
	  gtymin	equ	145
	  gtxmax	equ	236
	  gtymax	equ	198
	  gtxsz		equ	gtxmax-gtxmin
	  gtysz		equ	gtymax-gtymin
	  gtxpln	equ	75
	  gtypln	equ	57
	  gtxctr	equ	(gtxmin+gtxmax)/2
	  gtyctr	equ	(gtymin+gtymax)/2
	  gtmnb		equ	gtymin*bpl+(gtxmin/8)
	  gtmxb		equ	gtymax*bpl

mgwins  macro	
gwinf	dw	gfxmin,gfymin
	dw	gfxmax,gfymax
	dw	gfxsz,gfysz
	dw	gfxpln,gfypln
	dw	gfxctr,gfyctr
	dw	gfmnb,gfmxb

gwint	dw	gtxmin,gtymin
	dw	gtxmax,gtymax
	dw	gtxsz,gtysz
	dw	gtxpln,gtypln
	dw	gtxctr,gtyctr
	dw	gtmnb,gtmxb

;	8,4,315,144,311,110,300,200,160,72,4*80,144*80
;	88,174,236,198,303,95,150,100,160,186,174*80,198*80
	  endm
	ENDIF

IF	vgmode EQ 81h
	  vgseg	equ	0b000h
	  bpl	equ	90
	  boffs	equ	3
	  vxsiz	equ	720
	  vysiz	equ	348
	  nilns	equ	149
	  pgadr0 equ	0
	  pgadr1 equ	7e00h
	  gfxmin	equ	8
	  gfymin	equ	4
	  gfxmax	equ	712
	  gfymax	equ	199
	  gfxsz		equ	gfxmax-gfxmin
	  gfysz		equ	gfymax-gfymin
	  gfxpln	equ	338
	  gfypln	equ	200
	  gfxctr	equ	(gfxmin+gfxmax)/2
	  gfyctr	equ	(gfymin+gfymax)/2
	  gfmnb		equ	gfymin*bpl+(gfxmin/8)
	  gfmxb		equ	gfymax*bpl

	  gtxmin	equ	189
	  gtymin	equ	254
	  gtxmax	equ	529
	  gtymax	equ	344
	  gtxsz		equ	gtxmax-gtxmin
	  gtysz		equ	gtymax-gtymin
	  gtxpln	equ	169
	  gtypln	equ	100
	  gtxctr	equ	(gtxmin+gtxmax)/2
	  gtyctr	equ	(gtymin+gtymax)/2
	  gtmnb		equ	gtymin*bpl+(gtxmin/8)
	  gtmxb		equ	gtymax*bpl

mgwins  macro	
gwinf	dw	gfxmin,gfymin
	dw	gfxmax,gfymax
	dw	gfxsz,gfysz
	dw	gfxpln,gfypln
	dw	gfxctr,gfyctr
	dw	gfmnb,gfmxb

gwint	dw	gtxmin,gtymin
	dw	gtxmax,gtymax
	dw	gtxsz,gtysz
	dw	gtxpln,gtypln
	dw	gtxctr,gtyctr
	dw	gtmnb,gtmxb
;	8,4,631,199,622,193,300,200,320,102,4*80,199*80
;	168,254,471,344,303,95,150,100,320,297,254*80,344*80
	  endm
ENDIF

