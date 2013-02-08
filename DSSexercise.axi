PROGRAM_NAME='DSSexercise'
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
dvIR_SAT = 5001:10:201
dvTP     = 10001:1:0
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
VOLATILE INTEGER nBIC

/*
VOLATILE INTEGER nDSS_BTNS[]={
10,11,12,13,14,15,16,17,18,19,20,21,
44,45,46,47,48,49,50,105,235,
1011,1012,1013,1014,1015,1016 }
*/
VOLATILE INTEGER nFAVS[]={
507,509,504,505,562,635 }

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

(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT
DATA_EVENT[dvIR_SAT]
{
    ONLINE: //when IR PORT 10 COMES ONLINE
    {
	SEND_COMMAND dvIR_SAT,"'SET MODE IR'"
	SEND_COMMAND dvIR_SAT,"'CTON',2"
	SEND_COMMAND dvIR_SAT,"'CTOF',3"
	SEND_COMMAND dvIR_SAT,"'CARON'"
	SEND_COMMAND dvIR_SAT,"'XCHM-1'"
    }
}

BUTTON_EVENT[dvTP,nDSS_BTNS]
    {
	PUSH:
	{
	    LOCAL_VAR INTEGER nCH_NUM
	    nBIC = BUTTON.INPUT.CHANNEL
	    PULSE[BUTTON.INPUT]
	    IF(nBIC > 9 && nBIC < 50)
	    {
		SEND_COMMAND dvIR_SAT,"'SP',nBIC"
	    }
	    ELSE IF(nBIC > 1000)
	    {
		nBIC = nBIC -1010
		nCH_NUM = nFAVS[nBIC]
		SEND_COMMAND dvIR_SAT,"'XCH ',ITOA(nCH_NUM)"
	    }
	    ELSE
	    {
		SWITCH(nBIC)
		{
		    CASE 50://EXIT
		    {
			SEND_COMMAND dvIR_SAT,"'SP',84"
		    }
		    CASE 105://GUIDE
		    {
			SEND_COMMAND dvIR_SAT,"'SP',53"
		    }
		    CASE 235://PREVIOUS CHANNEL
		    {
			SEND_COMMAND dvIR_SAT,"'SP',55"
		    }
		}
	    }
	}
    }
(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM

(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)

