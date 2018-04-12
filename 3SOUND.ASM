	title '3sound'
;
; argument is passed in dx:ax
; sqrt value is returned in ax

_MODEL	equ	<SMALL>
include c:\sa\model.inc

.extrn	soundtick:word
.public	chgsnd

.dataseg
.ends

.codeseg
	assume cs:@codeseg,ds:@dataseg
.proc	chgsnd	auto
	ret
	in	al,61h
	and	al,0feh
	xor	al,02		; reverse data bit
	out	61h,al
	ret
.endp

.ends
	end
