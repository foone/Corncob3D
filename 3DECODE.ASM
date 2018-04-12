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
.extrn		start:AUTO, exit:AUTO, exit_ok:AUTO
.extrn		put_str:AUTO,get_str:auto,put_newline:auto
.extrn		dword_to_dec:auto,asc_to_dword:auto
.ends


.dataseg
ithink		db	13,10,"I think, therfore I ASM.",13,10,0
msg1		db	0dh,0ah,'Enter the code : ',0
msg2		db	0dh,0ah,'Number invalid.',0dh,0ah,0

kbuf		db	128 dup (0)
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

.proc	hashregcode	auto	; hashes response code
	ror	al,1
	ror	al,1
	ror	al,1
	add	al,177
	rol	ah,1
	add	ah,55
	add	ah,al
	rol	dl,1
	rol	dl,1
	rol	dl,1
	rol	dl,1
	xor	dl,ah
	add	dl,al
	ret
.endp

.public		main
.proc		main		AUTO
		mov	si,offset @dataseg:msg1
		call	put_str
		mov	si,offset @dataseg:kbuf
		mov	cl,16
		call	get_str
		mov	si,offset @dataseg:kbuf
		mov	bl,10
		call	asc_to_dword	
		jz	convok
		mov	si,offset @dataseg:msg2
		call	put_str
		ret			;exit to DOS with ERRORLEVEL=0
convok:		call	hashregcode
		call	put_newline
		mov	si,offset @dataseg:kbuf
		call	dword_to_dec
		call	put_str
		ret
.endp		main

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
