PROGRAM_NAME='Subroutines'
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
dvTP         = 10001:1:201
dvPROJECTOR  = 301:1:201
dvRELAYS     = 5001:8:201
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
NON_VOLATILE INTEGER nPROJ_MODE

(***********************************************************)
(*               LATCHING DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_LATCHING

(***********************************************************)
(*       MUTUALLY EXCLUSIVE DEFINITIONS GO BELOW           *)
(***********************************************************)
DEFINE_MUTUALLY_EXCLUSIVE

DEFINE_FUNCTION fnSYSTEM_ON()
{
    SET_PULSE_TIME(15)
    PULSE[BUTTON.INPUT]
    PULSE[dvRELAYS,4]
    SET_PULSE_TIME(5)
    WAIT 15
    {
	SEND_COMMAND dvPROJECTOR,"'SP',27"
	WAIT 20
	{
	    SET_PULSE_TIME(15)
	    PULSE[dvRELAYS,5]
	    SET_PULSE_TIME(5)
	}
    }
    
}

DEFINE_FUNCTION fnSYSTEM_OFF()
{
    SEND_COMMAND dvPROJECTOR,"'SP',28"
    SET_PULSE_TIME(15)
    PULSE[BUTTON.INPUT]
    SET_PULSE_TIME(5)
    WAIT 50
    {
	PULSE[dvRELAYS,6]
	WAIT 20
	{
	    SET_PULSE_TIME(15)
	    PULSE[dvRELAYS,7]
	    SET_PULSE_TIME(5)
	}
    }
    
}


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

BUTTON_EVENT[dvTP,41]
{
    PUSH: // SYSTEM ON
    {
	fnSYSTEM_ON()
    }
}
BUTTON_EVENT[dvTP,42]
{
    PUSH:  //SYSTEM OFF
    {
	fnSYSTEM_OFF()
    }
}

(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM
[dvTP,46] = ([dvRELAYS,4])
[dvTP,44] = ([dvRELAYS,5])
[dvTP,43] = ([dvRELAYS,6])
[dvTP,45] = ([dvRELAYS,7])
[dvTP,47] = ([dvPROJECTOR,27])
[dvTP,48] = ([dvPROJECTOR,28])



(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)

