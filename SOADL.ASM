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
;.extrn	put_str:auto,put_chr:auto,get_chr:auto

.extrn	adldelay:auto,adlwdelay:auto,adldelayinit:auto,adlwrt:auto
.extrn	adlseq:auto,adlreginit:auto,voiceon:auto
.extrn	voiceoff:auto,engineinit:auto,guninit:auto,boominit:auto
.extrn	snareinit:auto,initsound:auto
.extrn	bassinit:auto,snaresnd:auto,scrapeinit:auto
.extrn	windinit:auto,windflag:byte,initvoices:auto,nwait:word
.extrn	screechinit:auto,saucerinit:auto
;,word_to_dec:auto
;.extrn	word_to_hex:auto
.ends

.public	kbuf,sndflg

.dataseg

;hellomsg	db	0dh,0ah,'Hello, welcome to soadl',0dh,0ah,0
;alrinstmsg	db	0dh,0ah,'Sound driver already installed',0dh,0ah,0
;pspmsg		db	0dh,0ah,'Psp Segment Address : ',0
kbuf		db	80 dup (0)
sndflg		db	-1

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

jumptable	dw	offset @codeseg:faradlinit
		dw	offset @codeseg:farvoiceon
		dw	offset @codeseg:farvoiceoff
		dw	offset @codeseg:faradlwrt
		dw	7777h

;.proc	hwword	auto
;		mov	si,offset @dataseg:kbuf
;		call	word_to_hex
;		call	put_str
;		mov	al,20h
;		call	put_chr
;		ret
;.endp



.proc	faradlinit	far
	mov	dx,@dataseg
	mov	ds,dx
	call	soadlmain
	retf
.endp

.proc	faradlwrt	far
	mov	dx,@dataseg
	mov	ds,dx
	call	adlwrt
	retf
.endp

.proc	farvoiceon	far
	mov	dx,@dataseg
	mov	ds,dx
	call	voiceon
	retf
.endp

.proc	farvoiceoff	far
	mov	dx,@dataseg
	mov	ds,dx
	call	voiceoff
	retf
.endp




.public		soadlmain
.proc		soadlmain		AUTO
		call	initsound	; initialize the board and everything
		call	saucerinit
		ret
.endp		soadlmain

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


		end		;specify START as starting address
