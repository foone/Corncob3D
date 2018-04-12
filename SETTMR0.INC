.proc	noop	auto		; waste time while timer chip recovers
	push	ax
	push	dx
	mov	dx,3d4h		; read the random video port to waste 50 usec
rept	38		
	in	al,dx
endm
	pop	dx
	pop	ax
	ret
.endp

.proc		set_timer0	near
	cmp	qtimeinc,0
	jz	gasetit
	ret
gasetit:
		.push	ax,cx


;FUNC:	$SET_TIMER0
;
;DESC:	Sets the counting mode and reload value for system timer zero.
;
;IN:	STACK		input AX,CX already pushed
;	AL		mode of operation ("mode")
;	CX		reload value ("reload")
;
;OUT:	None
;
;NOTES:	See SET_TIMER0


		pushf				;save interrupt state
		cli				;interrupts off
		or	al,30h			;counter 0, "mode", LSB/MSB
		out	43h,al			;set the Mode Control Word
;		.recover			;wait for counter chip
		call	noop
		xchg	ax,cx
		out	40h,al			;set count LSB
;		.recover			;wait for counter chip
		call	noop
		mov	al,ah
		out	40h,al			;set count MSB
		popf				;restore interrupt state
		.pop	ax,cx
		ret
.endp		set_timer0

