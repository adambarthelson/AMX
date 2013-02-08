PROGRAM_NAME='TASCAM'
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
dvSERIAL_DVD = 5001:1:201
dvTP         = 10001:1:201

#END_IF

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE
VOLATILE INTEGER nTRANSPORT_STATUS
VOLATILE INTEGER nTASCAM_BTNS[]={
1,2,3,4,5,6,7 }
VOLATILE CHAR sDVD_CMDS[9][17]

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

(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START
sDVD_CMDS[1]= "$02,'>PLYcFWD     17',$03"//play
sDVD_CMDS[2]= "$02,'>STPc        98',$03"//stop
sDVD_CMDS[3]= "$02,'>PLYcPAU     1C',$03"//pause
sDVD_CMDS[4]= "$02,'>SKPcN       BD',$03"//skipf
sDVD_CMDS[5]= "$02,'>SKPcP       BF',$03"//skipb
sDVD_CMDS[6]= "$02,'>PLYcFFW     19',$03"//FF
sDVD_CMDS[7]= "$02,'>PLYcFBW     15',$03"//RW
sDVD_CMDS[8]= "$02,'>INIc        81',$03"//serial mode
sDVD_CMDS[9]= "$02,'>MODc        81',$03"//query


(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT
DATA_EVENT[dvSERIAL_DVD]
{
    ONLINE:
    {
	SEND_COMMAND dvSERIAL_DVD,"'SET BAUD 9600,N,8,1 485 DISABLE'"
    }
    STRING:
    {
	LOCAL_VAR CHAR cMOD_CHAR
	LOCAL_VAR CHAR sFROM_DVD[18]
	sFROM_DVD = DATA.TEXT
	cMOD_CHAR = sFROM_DVD[7]
	SEND_COMMAND dvTP,"'^TXT-10,0,',sFROM_DVD"
	sFROM_DVD = MID_STRING(sFROM_DVD,3,7)
	SELECT
	{
	    ACTIVE(sFROM_DVD == 'PLYsFWD' || cMOD_CHAR == ':'):
	    {
		nTRANSPORT_STATUS = 1
	    }
	    ACTIVE(sFROM_DVD == 'STPs        ' || cMOD_CHAR == '7'):
	    {
		nTRANSPORT_STATUS = 2
	    }
	    ACTIVE(sFROM_DVD == 'PLYsPAU' || cMOD_CHAR == ';'):
	    {
		nTRANSPORT_STATUS = 3
	    }
	    ACTIVE(sFROM_DVD == 'SKPsN    '):
	    {
		nTRANSPORT_STATUS = 4
	    }
	    ACTIVE(sFROM_DVD == 'SPKsP    '):
	    {
		nTRANSPORT_STATUS = 5
	    }
	    ACTIVE(sFROM_DVD == 'PLYsFFW'):
	    {
		nTRANSPORT_STATUS = 6
	    }
	    ACTIVE(sFROM_DVD == 'PLYsFBW'):
	    {
		nTRANSPORT_STATUS = 7
	    }
	}
    }
}
BUTTON_EVENT[dvTP,nTASCAM_BTNS]
{
    PUSH:
    {
	STACK_VAR INTEGER nBIC
	//TO[BUTTON.INPUT]
	nBIC = BUTTON.INPUT.CHANNEL
	SWITCH(nBIC)
	{
	    CASE 1: //PLAY
	    {
		SEND_STRING dvSERIAL_DVD,"sDVD_CMDS[1]"
	    }
	    CASE 2: //STOP
	    {
		SEND_STRING dvSERIAL_DVD,"sDVD_CMDS[2]"
	    }
	    CASE 3: //PAUSE
	    {
		SEND_STRING dvSERIAL_DVD,"sDVD_CMDS[3]"
	    }
	    CASE 4: //NEXT
	    {
		SEND_STRING dvSERIAL_DVD,"sDVD_CMDS[4]"
	    }
	    CASE 5: //PREV
	    {
		SEND_STRING dvSERIAL_DVD,"sDVD_CMDS[5]"
	    }
	    CASE 6: //FF
	    {
		SEND_STRING dvSERIAL_DVD,"sDVD_CMDS[6]"
	    }
	    CASE 7: //RW
	    {
		SEND_STRING dvSERIAL_DVD,"sDVD_CMDS[7]"
	    }
	}
	WAIT 20
	{
	    SEND_STRING dvSERIAL_DVD,"sDVD_CMDS[9]"
	}
    }
}

(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM
WAIT 20
{
    SEND_STRING dvSERIAL_DVD,"sDVD_CMDS[9]"
}

[dvTP,1] = (nTRANSPORT_STATUS == 1)
[dvTP,2] = (nTRANSPORT_STATUS == 2)
[dvTP,3] = (nTRANSPORT_STATUS == 3)
[dvTP,4] = (nTRANSPORT_STATUS == 4)
[dvTP,5] = (nTRANSPORT_STATUS == 5)
[dvTP,6] = (nTRANSPORT_STATUS == 6)
[dvTP,7] = (nTRANSPORT_STATUS == 7)

(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)

