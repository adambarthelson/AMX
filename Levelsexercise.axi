PROGRAM_NAME='Levelsexercise'
(***********************************************************)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 04/05/2006  AT: 09:00:25        *)
(***********************************************************)
(* System Type : NetLinx                                   *)
(***********************************************************)
(* REV HISTORY:                                            *)
(***********************************************************)
(*
    $History: $
*)
(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE
#IF_NOT_DEFINED MY_DEVICES
dvKEYPAD = 10001:3:201
dvTP= 10001:1:201
#END_IF



(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT
DVD        = 1
SIRIUS     = 2
iPOD       = 3
DSS        = 4
LIGHT_MODE = 5
TEMP_MODE  = 6
AUDIO_MODE = 7

(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE
NON_VOLATILE INTEGER nVOL_LVL
NON_VOLATILE INTEGER nMODE_NUM
NON_VOLATILE INTEGER nAUDIO_SOURCE
NON_VOLATILE INTEGER nLIGHT_LEVEL
NON_VOLATILE INTEGER nTEMPERATURE
NON_VOLATILE INTEGER nZONE2LIGHTS
NON_VOLATILE INTEGER nZONE2_PRESET
VOLATILE INTEGER nKEYPAD_BTNS[]={
1,2,3,4,5,6 }
VOLATILE FLOAT fINC_LVL
NON_VOLATILE FLOAT fTEMP_LEVEL
NON_VOLATILE FLOAT fLIGHT_LVL

(***********************************************************)
(*               LATCHING DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_LATCHING

(***********************************************************)
(*       MUTUALLY EXCLUSIVE DEFINITIONS GO BELOW           *)
(***********************************************************)
DEFINE_MUTUALLY_EXCLUSIVE

(***********************************************************)
(*        SUBROUTINE/FUNCTION DEFINITIONS GO BELOW         *)
(***********************************************************)
(* EXAMPLE: DEFINE_FUNCTION <RETURN_TYPE> <NAME> (<PARAMETERS>) *)
(* EXAMPLE: DEFINE_CALL '<NAME>' (<PARAMETERS>) *)
DEFINE_FUNCTION fnUPDATE_PANEL()
{
    SELECT
    {
	ACTIVE (nMODE_NUM == AUDIO_MODE):
	{
	    SEND_LEVEL dvKEYPAD,2,nVOL_LVL
	    SEND_LEVEL dvTP,1,nVOL_LVL
	}
	ACTIVE (nMODE_NUM == LIGHT_MODE):
	{
	    SEND_LEVEL dvKEYPAD,2,(TYPE_CAST(nLIGHT_LEVEL*2.55))
	    SEND_LEVEL dvTP,1,(TYPE_CAST(nLIGHT_LEVEL*2.55))
	    SEND_STRING 0,"'LIGHT LEVEL IS: ',(TYPE_CAST(nLIGHT_LEVEL*2.55))"
	}
	ACTIVE (nMODE_NUM == TEMP_MODE):
	{
	    SEND_LEVEL dvKEYPAD,2,(TYPE_CAST(nTEMPERATURE-60)*12.75)
	    SEND_LEVEL dvTP,1,(TYPE_CAST(nTEMPERATURE-60)*12.75)
	}
    }
    SEND_LEVEL dvTP,1,LEVEL.VALUE
}

(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START
nZONE2_PRESET = 128

(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT
DATA_EVENT[dvKEYPAD]
{
    ONLINE://WHEN TP PORT 3 COMES ONLINE
    {
	SEND_COMMAND DATA.DEVICE,"'ADBEEP'"
    }
}
BUTTON_EVENT[dvTP,61]
{
    PUSH:
    {
	TO[BUTTON.INPUT]
	IF(nZONE2LIGHTS < 255)
	{
	    nZONE2LIGHTS++
	}
    }
    HOLD[1,REPEAT]:
    {
	IF(nZONE2LIGHTS < 255)
	{
	    nZONE2LIGHTS++
	}
    }
}
BUTTON_EVENT[dvTP,62]
{
    PUSH:
    {
	TO[BUTTON.INPUT]
	IF(nZONE2LIGHTS>0)
	{
	    nZONE2LIGHTS--
	}
    }
    HOLD[1,REPEAT]:
    {
	IF(nZONE2LIGHTS>0)
	{
	    nZONE2LIGHTS--
	}
    }
}
BUTTON_EVENT[dvTP,63]
{
    PUSH:
    {
	TO[BUTTON.INPUT]
    }
    HOLD[20]:
    {
	nZONE2_PRESET = nZONE2LIGHTS
    }
    RELEASE:
    {
	nZONE2LIGHTS =nZONE2_PRESET
	SEND_COMMAND dvTP,"'ADBEEP'"
    }
}
BUTTON_EVENT[dvKEYPAD,nKEYPAD_BTNS]
{
    PUSH://ANY BTN ON MET6N
    {
	LOCAL_VAR INTEGER nBIC
	nBIC = BUTTON.INPUT.CHANNEL
	IF(nBIC < 5)
	{
	    nMODE_NUM = AUDIO_MODE
	    nAUDIO_SOURCE = nBIC
	}
	ELSE IF(nBIC == 5)
	{
	    nMODE_NUM = LIGHT_MODE
	}
	ELSE //(nBIC == 6)
	{
	    nMODE_NUM = TEMP_MODE
	}
	fnUPDATE_PANEL()
    }
}
LEVEL_EVENT[dvKEYPAD,2]
{
    fINC_LVL = LEVEL.VALUE
    SWITCH(nMODE_NUM)
    {
	CASE AUDIO_MODE:
	{
	    nVOL_LVL = LEVEL.VALUE
	    SEND_COMMAND dvTP,"'^TXT-52,0,',ITOA(nVOL_LVL)"
	}
	CASE LIGHT_MODE:
	{
	    fLIGHT_LVL = ((fINC_LVL / 2.55))
	    nLIGHT_LEVEL = TYPE_CAST(fLIGHT_LVL)
	    SEND_COMMAND dvTP,"'^TXT-52,0,',ITOA(nLIGHT_LEVEL)"
	}
	CASE TEMP_MODE:
	{
	    fTEMP_LEVEL = (((fINC_LVL/255)*20)+60)
	    nTEMPERATURE = TYPE_CAST(fTEMP_LEVEL)
	    SEND_COMMAND dvTP,"'^TXT-51,0,',ITOA(fTEMP_LEVEL)"
	}
    }
    SEND_LEVEL dvTP,1,LEVEL.VALUE
    SEND_COMMAND dvTP,"'^TXT-51,0,',ITOA(LEVEL.VALUE)"
}
(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM
WAIT 2
{
    SEND_LEVEL dvTP,2,nZONE2LIGHTS
}


[dvKEYPAD,1] = (nAUDIO_SOURCE == DVD && nMODE_NUM == AUDIO_MODE)
[dvKEYPAD,2] = (nAUDIO_SOURCE == SIRIUS && nMODE_NUM == AUDIO_MODE)
[dvKEYPAD,3] = (nAUDIO_SOURCE == iPOD && nMODE_NUM == AUDIO_MODE)
[dvKEYPAD,4] = (nAUDIO_SOURCE == DSS && nMODE_NUM == AUDIO_MODE)
[dvKEYPAD,5] = (nMODE_NUM == LIGHT_MODE)
[dvKEYPAD,6] = (nMODE_NUM == TEMP_MODE)

(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)

