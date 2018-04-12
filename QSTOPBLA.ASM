

IF shareflag EQ 0
.proc	qstopblam	auto
	push	bx		; save screen shake info
	cmp	shakecnt,0
	jnz	nostopblam
	cmp	blamtick,-1
	jz	blamoff1
	jmp	nostopblam
blamoff1:
	mov	bl,2
	mov	ax,10h
	call	voiceoff
	mov	ax,cs:oticks
	mov	blamtick,ax
nostopblam:
	pop	bx
	ret
.endp
ENDIF
