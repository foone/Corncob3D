include 	 UTIL.INC
__$TSR_PREFIX__	equ	<>
__$TPFX__	= 0
IFDEF _PREFIX
% IFDIFI <_PREFIX>,<>
    __$PFX__	= -1
  ELSE
    __$PFX__	= 0
  ENDIF
ELSE
  __$PFX__	= 0
ENDIF
__$KFLAGS__	= 0
% IFIDNI 	<_MODEL>,<TINY>
__TRANS__	equ	0
__EMS__		equ	0
__TINY__	equ	-1
__SMALL__	equ	0
__MEDIUM__	equ	0
__COMPACT__	equ	0
__LARGE__	equ	0
__HUGE__	equ	0
% ELSEIFIDNI 	<_MODEL>,<TTINY>
__TRANS__	equ	-1
__EMS__		equ	0
__TINY__	equ	-1
__SMALL__	equ	0
__MEDIUM__	equ	0
__COMPACT__	equ	0
__LARGE__	equ	0
__HUGE__	equ	0
% ELSEIFIDNI 	<_MODEL>,<ETINY>
__TRANS__	equ	0
__EMS__		equ	-1
__TINY__	equ	-1
__SMALL__	equ	0
__MEDIUM__	equ	0
__COMPACT__	equ	0
__LARGE__	equ	0
__HUGE__	equ	0
% ELSEIFIDNI <_MODEL>,<SMALL>
__TRANS__	equ	0
__EMS__		equ	0
__TINY__	equ	0
__SMALL__	equ	-1
__MEDIUM__	equ	0
__COMPACT__	equ	0
__LARGE__	equ	0
__HUGE__	equ	0
% ELSEIFIDNI <_MODEL>,<TSMALL>
__TRANS__	equ	-1
__EMS__		equ	0
__TINY__	equ	0
__SMALL__	equ	-1
__MEDIUM__	equ	0
__COMPACT__	equ	0
__LARGE__	equ	0
__HUGE__	equ	0
% ELSEIFIDNI <_MODEL>,<ESMALL>
__TRANS__	equ	0
__EMS__		equ	-1
__TINY__	equ	0
__SMALL__	equ	-1
__MEDIUM__	equ	0
__COMPACT__	equ	0
__LARGE__	equ	0
__HUGE__	equ	0
% ELSEIFIDNI <_MODEL>,<MEDIUM>
__TRANS__	equ	0
__EMS__		equ	0
__TINY__	equ	0
__SMALL__	equ	0
__MEDIUM__	equ	-1
__COMPACT__	equ	0
__LARGE__	equ	0
__HUGE__	equ	0
% ELSEIFIDNI <_MODEL>,<TMEDIUM>
__TRANS__	equ	-1
__EMS__		equ	0
__TINY__	equ	0
__SMALL__	equ	0
__MEDIUM__	equ	-1
__COMPACT__	equ	0
__LARGE__	equ	0
__HUGE__	equ	0
% ELSEIFIDNI <_MODEL>,<COMPACT>
__TRANS__	equ	0
__EMS__		equ	0
__TINY__	equ	0
__SMALL__	equ	0
__MEDIUM__	equ	0
__COMPACT__	equ	-1
__LARGE__	equ	0
__HUGE__	equ	0
% ELSEIFIDNI <_MODEL>,<TCOMPACT>
__TRANS__	equ	-1
__EMS__		equ	0
__TINY__	equ	0
__SMALL__	equ	0
__MEDIUM__	equ	0
__COMPACT__	equ	-1
__LARGE__	equ	0
__HUGE__	equ	0
% ELSEIFIDNI <_MODEL>,<ECOMPACT>
__TRANS__	equ	0
__EMS__		equ	-1
__TINY__	equ	0
__SMALL__	equ	0
__MEDIUM__	equ	0
__COMPACT__	equ	-1
__LARGE__	equ	0
__HUGE__	equ	0
% ELSEIFIDNI <_MODEL>,<LARGE>
__TRANS__	equ	0
__EMS__		equ	0
__TINY__	equ	0
__SMALL__	equ	0
__MEDIUM__	equ	0
__COMPACT__	equ	0
__LARGE__	equ	-1
__HUGE__	equ	0
% ELSEIFIDNI <_MODEL>,<TLARGE>
__TRANS__	equ	-1
__EMS__		equ	0
__TINY__	equ	0
__SMALL__	equ	0
__MEDIUM__	equ	0
__COMPACT__	equ	0
__LARGE__	equ	-1
__HUGE__	equ	0
% ELSEIFIDNI <_MODEL>,<HUGE>
__TRANS__	equ	0
__EMS__		equ	0
__TINY__	equ	0
__SMALL__	equ	0
__MEDIUM__	equ	0
__COMPACT__	equ	0
__LARGE__	equ	0
__HUGE__	equ	-1
% ELSEIFIDNI <_MODEL>,<THUGE>
__TRANS__	equ	-1
__EMS__		equ	0
__TINY__	equ	0
__SMALL__	equ	0
__MEDIUM__	equ	0
__COMPACT__	equ	0
__LARGE__	equ	0
__HUGE__	equ	-1
ELSE
.error	<No model specified or unrecognized _MODEL option>
__TRANS__	equ	0
__EMS__		equ	0
__TINY__	equ	0
__SMALL__	equ	-1
__MEDIUM__	equ	0
__COMPACT__	equ	0
__LARGE__	equ	0
__HUGE__	equ	0
ENDIF
IF __TRANS__ OR __EMS__
__RES__		EQU	0
ELSE
__RES__		EQU	-1
ENDIF
IF __TINY__ OR __SMALL__ OR __COMPACT__
__SMALL_CODE__	equ	-1
__LARGE_CODE__	equ	0
AUTO		equ	<NEAR>
AUTO_IPTR	equ	<WORD PTR>
ELSE
__SMALL_CODE__	equ	0
__LARGE_CODE__	equ	-1
AUTO		equ	<FAR>
AUTO_IPTR	equ	<DWORD PTR>
ENDIF
IF __TINY__ OR __SMALL__ OR __MEDIUM__
__SMALL_DATA__	equ	-1
__LARGE_DATA__	equ	0
ELSE
__SMALL_DATA__	equ	0
__LARGE_DATA__	equ	-1
ENDIF
$CODE_ALIGN	equ	<BYTE>
$TCODE_ALIGN	equ	<BYTE>
$ECODE_ALIGN	equ	<BYTE>
$CONST_ALIGN	equ	<WORD>
$DATA_ALIGN	equ	<WORD>
$BSS_ALIGN	equ	<WORD>
$FDATA_ALIGN	equ	<WORD>
$FBSS_ALIGN	equ	<WORD>
$STACK_ALIGN	equ	<PARA>
.rcodeseg	macro	sname,align
  IFB <sname>
%   IFNB <@filename>
% .rcodeseg	<@filename>
    exitm
    ENDIF
  ELSEIFIDNI <sname>,<byte>
% .rcodeseg	<@filename>,sname
    exitm
  ELSEIFIDNI <sname>,<word>
% .rcodeseg	<@filename>,sname
    exitm
  ELSEIFIDNI <sname>,<dword>
% .rcodeseg	<@filename>,sname
    exitm
  ELSEIFIDNI <sname>,<para>
% .rcodeseg	<@filename>,sname
    exitm
  ELSEIFIDNI <sname>,<page>
% .rcodeseg	<@filename>,sname
    exitm
  ENDIF
  IFNB <align>
$CODE_ALIGN	equ	<align>
  ENDIF
  IF __SMALL_CODE__
    IF __TINY__
% _TEXT		segment $CODE_ALIGN public 'CODE'
DGROUP		group	_TEXT
@RCODESEG	equ	<DGROUP>
@RCODESEG&sname	equ	<DGROUP>
    ELSE
% _TEXT		segment $CODE_ALIGN public 'CODE'
@RCODESEG	equ	<_TEXT>
@RCODESEG&sname	equ	<_TEXT>
    ENDIF
  ELSEIFNB <sname>
%   IFIDNI <sname>,<lib>
% LIB_TEXT	segment $CODE_ALIGN public 'CODE'
@RCODESEG	equ	<LIB_TEXT>
@RCODESEGLIB	equ	<LIB_TEXT>
    ELSE
% sname&_TEXT	segment $CODE_ALIGN public 'CODE'
@RCODESEG	equ	<sname&_TEXT>
@RCODESEG&sname	equ	<sname&_TEXT>
    ENDIF
  ELSE
%   IFNB <@filename>
% .rcodeseg	@filename
    ELSE
% .rcodeseg	NULL
    ENDIF
  ENDIF
% assume	cs:@rcodeseg
endm
.tcodeseg	macro	sname,align
  IFB <sname>
%   IFNB <@filename>
% .tcodeseg	<@filename>
    exitm
    ENDIF
  ELSEIFIDNI <sname>,<byte>
% .tcodeseg	<@filename>,sname
    exitm
  ELSEIFIDNI <sname>,<word>
% .tcodeseg	<@filename>,sname
    exitm
  ELSEIFIDNI <sname>,<dword>
% .tcodeseg	<@filename>,sname
    exitm
  ELSEIFIDNI <sname>,<para>
% .tcodeseg	<@filename>,sname
    exitm
  ELSEIFIDNI <sname>,<page>
% .tcodeseg	<@filename>,sname
    exitm
  ENDIF
  IFNB <align>
$TCODE_ALIGN	equ	<align>
  ENDIF
  IF __SMALL_CODE__
    IF __TINY__
% _TTEXT	segment $TCODE_ALIGN public 'TCODE'
DGROUP		group	_TTEXT
@TCODESEG	equ	<DGROUP>
@TCODESEG&sname	equ	<DGROUP>
    ELSE
% _TTEXT	segment $TCODE_ALIGN public 'TCODE'
@TCODESEG	equ	<_TTEXT>
@TCODESEG&sname	equ	<_TTEXT>
    ENDIF
  ELSEIFNB <sname>
%   IFIDNI <sname>,<lib>
% LIB_TTEXT	segment $TCODE_ALIGN public 'TCODE'
@TCODESEG	equ	<LIB_TTEXT>
@TCODESEGLIB	equ	<LIB_TTEXT>
    ELSE
% sname&_TTEXT	segment $TCODE_ALIGN public 'TCODE'
@TCODESEG	equ	<sname&_TTEXT>
@TCODESEG&sname	equ	<sname&_TTEXT>
    ENDIF
  ELSE
%   IFNB <@filename>
% .tcodeseg	@filename
    ELSE
% .tcodeseg	NULL
    ENDIF
  ENDIF
% assume	cs:@tcodeseg
endm
.emsseg		macro	align
  IFNB <align>
$ECODE_ALIGN	equ	<align>
  ENDIF
% _EMS		segment $ECODE_ALIGN public 'EMSCODE'
IF __TINY__
DGROUP		group	_EMS
@EMSSEG		equ	<DGROUP>
ELSE
@EMSSEG		equ	<_EMS>
ENDIF
% assume	cs:@EMSSEG
endm
.codeseg	macro	sname,align
  IF __TRANS__
__$TSR_PREFIX__	equ	<t_>
__$TPFX__	= -1
.tcodeseg	<sname>,<align>
@CODESEG	equ	<@TCODESEG>
@CODESEG&sname	equ	<@TCODESEG&sname>
  ELSEIF __EMS__
__$TSR_PREFIX__	equ	<e_>
__$TPFX__	= -1
.emsseg		<align>
@CODESEG	equ	<@EMSSEG>
@CODESEG&sname	equ	<@EMSSEG>
  ELSE
.rcodeseg	<sname>,<align>
@CODESEG	equ	<@RCODESEG>
@CODESEG&sname	equ	<@RCODESEG&sname>
  ENDIF
endm
.constseg	macro	align
  IFNB <align>
$CONST_ALIGN	equ	<align>
  ENDIF
  IF __TASM__
    nowarn
  ENDIF
% CONST		segment $CONST_ALIGN public 'CONST'
  IF __TASM__
    warn
  ENDIF
DGROUP		group CONST
@CONSTSEG	equ	<DGROUP>
endm
.tdataseg	macro	align
  IFNB <align>
$DATA_ALIGN	equ	<align>
  ENDIF
% _TDATA		segment $DATA_ALIGN public 'TDATA'
IF __TINY__
  DGROUP		group _TDATA
  @TDATASEG	equ	<DGROUP>
ELSE
  @TDATASEG	equ	<_TDATA>
ENDIF
endm
.dataseg	macro	align
  IFNB <align>
$DATA_ALIGN	equ	<align>
  ENDIF
% _DATA		segment $DATA_ALIGN public 'DATA'
DGROUP		group _DATA
  IF __SMALL_DATA__
@DATASEG	equ	<DGROUP>
  ELSE
@DATASEG	equ	<DGROUP>
  ENDIF
endm
.dataseg?	macro	align
  IFNB <align>
$BSS_ALIGN	equ	<align>
  ENDIF
% _BSS		segment $BSS_ALIGN public 'BSS'
DGROUP		group _BSS
@DATASEG?	equ	<DGROUP>
endm
.fardataseg	macro	sname,align
  IFB <sname>
.error	<.FARDATASEG must have a name argument>
  ENDIF
  IFNB <align>
$FDATA_ALIGN	equ	<align>
  ENDIF
% sname&_DATA	segment $FDATA_ALIGN public 'FAR_DATA'
@FARDATASEG&sname equ	<sname&_DATA>
endm
.fardataseg?	macro	sname,align
  IFB <sname>
.error	<.FARDATASEG? must have a name argument>
  ENDIF
  IFNB <align>
$FBSS_ALIGN	equ	<align>
  ENDIF
% sname&_BSS	segment $FBSS_ALIGN public 'FAR_BSS'
@FARDATASEG?&sname equ	<sname&_BSS>
endm
.tfardataseg	macro	sname,align
  IFB <sname>
.error	<.TFARDATASEG must have a name argument>
  ENDIF
  IFNB <align>
$FDATA_ALIGN	equ	<align>
  ENDIF
% sname&_TDATA	segment $FDATA_ALIGN public 'TFAR_DATA'
@TFARDATASEG&sname equ	<sname&_TDATA>
  IF __TINY__
DGROUP		group sname&_TDATA
  ENDIF
endm
.fardataseg?	macro	sname,align
  IFB <sname>
.error	<.FARDATASEG? must have a name argument>
  ENDIF
  IFNB <align>
$FBSS_ALIGN	equ	<align>
  ENDIF
% sname&_BSS	segment $FBSS_ALIGN public 'FAR_BSS'
@FARDATASEG?&sname equ	<sname&_BSS>
endm
.stackseg	macro	align
  IFNB <align>
$STACK_ALIGN	equ	<align>
  ENDIF
    IF __TASM__
      nowarn
    ENDIF
% STACK		segment	$STACK_ALIGN stack 'STACK'
    IF __TASM__
      warn
    ENDIF
  IF __SMALL_DATA__
DGROUP		group	STACK
@STACKSEG	equ	<DGROUP>
  ELSE
DGROUP		group	STACK
@STACKSEG	equ	<STACK>
  ENDIF
endm
.ends		macro
__$TSR_PREFIX__	equ	<>
__$TPFX__	= 0
@Curseg		ends
endm
.public		macro	p0,p1,p2,p3,p4,p5,p6,p7,p8,p9,p10
  IFNB <p10>
.error	<.PUBLIC has more than 10 arguments>
  ENDIF
  irp $pub,<p0,p1,p2,p3,p4,p5,p6,p7,p8,p9>
    IFB <$pub>
      exitm
    ENDIF
    IF __TASM__
      nowarn pdc
    ENDIF
    IF1
      IF __$PFX__
%       $pub catstr <_PREFIX>,<__$TSR_PREFIX__>,<$pub>
      ELSE
%       IF __$TPFX__
%         $pub catstr <__$TSR_PREFIX__>,<$pub>
	ENDIF
      ENDIF
    ENDIF
    IF __TASM__
      warn pdc
    ENDIF
%   public	$pub
  endm
endm
IF __MASM6__
  .proc		macro	procname:REQ, dist:=<AUTO>
  $tab_pos = @InStr(, <procname>, <	>)
  $space_pos = @InStr(, <procname>, < >)
  IF ($tab_pos OR $space_pos)
    IF ($tab_pos EQ 0)
      $pos = $space_pos
    ELSEIF ($space_pos EQ 0)
      $pos = $tab_pos
    ELSEIF ($tab_pos LT $space_pos)
      $pos = $tab_pos
    ELSE
      $pos = $space_pos
    ENDIF
    .proc	@SubStr(procname,1,$pos-1), @SubStr(procname,$pos)
  EXITM
  ELSE
%   procname	proc	dist
    $CURPROC	equ	<procname>
  ENDIF
  endm
ELSE
  .proc		macro	procname, dist
  $CURPROC	equ	<procname>
  IFNB <dist>
%   procname	proc	dist
  ELSE
%   procname	proc	auto
  ENDIF
  endm
ENDIF
.endp		macro	procname
  IFNB <procname>
% procname	endp
  ELSE
% $CURPROC	endp
  ENDIF
endm
IF __MASM6__
  .label		macro	labelname:REQ, dist:=<AUTO>
  $tab_pos = @InStr(, <labelname>, <	>)
  $space_pos = @InStr(, <labelname>, < >)
  IF ($tab_pos OR $space_pos)
    IF ($tab_pos EQ 0)
      $pos = $space_pos
    ELSEIF ($space_pos EQ 0)
      $pos = $tab_pos
    ELSEIF ($tab_pos LT $space_pos)
      $pos = $tab_pos
    ELSE
      $pos = $space_pos
    ENDIF
    .label	@SubStr(labelname,1,$pos-1), @SubStr(labelname,$pos)
    EXITM
  ELSE
%   labelname	label	dist
  ENDIF
  endm
ELSE
  .label		macro	labelname, dist
  IFNB <dist>
%   labelname	label	dist
  ELSE
%   labelname	label	auto
  ENDIF
  endm
ENDIF
.extrn		macro	e0,e1,e2,e3,e4,e5,e6,e7,e8,e9,e10
  IFNB <e10>
.error	<.EXTRN has more than 10 arguments>
  ENDIF
  irp $epair,<e0,e1,e2,e3,e4,e5,e6,e7,e8,e9>
    IFB <$epair>
      exitm
    ENDIF
    $$$pos instr <$epair>,<:>
    IFE $$$pos
.error	<.EXTRN argument requires a type: &$epair>
      exitm
    ENDIF
    $$$typ substr <$epair>,($$$pos+1)
    $$$nam substr <$epair>,1,($$$pos-1)
%   IFIDNI <$$$TYP>,<>
.error	<.EXTRN argument requires a type: &$epair>
      exitm
    ENDIF
    IF __TASM__
      nowarn pdc
    ENDIF
    IF1
      IF __$PFX__
%       $$$nam catstr <_PREFIX>,<__$TSR_PREFIX__>,<$$$nam>
      ELSE
%       IF __$TPFX__
%         $$$nam catstr <__$TSR_PREFIX__>,<$$$nam>
	ENDIF
      ENDIF
    ENDIF
    IF __TASM__
      warn pdc
    ENDIF
%   extrn	$$$nam : $$$typ
  endm
endm
.call		macro	procname
IF __LARGE_CODE__
		push	cs
ENDIF
%		call	near ptr procname
endm
.dcall		macro	varname
IF __LARGE_CODE__
		push	cs
ENDIF
%		call	varname
endm
