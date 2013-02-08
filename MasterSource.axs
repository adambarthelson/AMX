PROGRAM_NAME='MasterSource'
(***********************************************************)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 02/05/2013  AT: 09:00:25        *)
(***********************************************************)
(* System Type : NetLinx                                   *)
(***********************************************************)
(* REV HISTORY:  DVD/Screen                                *)
(***********************************************************)
(*
    $History: $
*)
(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE
dvPROJECTOR  = 301:1:201
dvSERIAL_DVD = 5001:1:201
dvSWITCHER   = 5001:2:201
dvRELAYS     = 5001:8:201
dvIR_DVD     = 5001:9:201 //first I/O port is 9
dvIR_SAT     = 5001:10:201

dvTP         = 10001:1:201
dvKEYPAD     = 10001:3:201

#DEFINE MY_DEVICES

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
VOLATILE INTEGER nIR_DVD_BTNS[]={
1,2,3,4,5,6,7}
VOLATILE INTEGER nSCREEN_BTNS[]={
21,32,33}


(***********************************************************)
(*               LATCHING DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_LATCHING

(***********************************************************)
(*       MUTUALLY EXCLUSIVE DEFINITIONS GO BELOW           *)
(***********************************************************)
DEFINE_MUTUALLY_EXCLUSIVE
([dvRELAYS,1]..[dvRELAYS,3])
(***********************************************************)
(*        SUBROUTINE/FUNCTION DEFINITIONS GO BELOW         *)
(***********************************************************)
(* EXAMPLE: DEFINE_FUNCTION <RETURN_TYPE> <NAME> (<PARAMETERS>) *)
(* EXAMPLE: DEFINE_CALL '<NAME>' (<PARAMETERS>) *)
//#INCLUDE 'DSSexercise.axi'
#INCLUDE 'Levelsexercise.axi'
#INCLUDE 'Switcher.axi'
#INCLUDE 'TASCAM.axi'
#INCLUDE 'Subroutines.axi'

DEFINE_FUNCTION fnPULSE_RELAY(INTEGER nREL_NUMBER)
{
    IF(nREL_NUMBER == 3)
    {
	PULSE[dvRELAYS,3]
    }
    ELSE
    {
	SET_PULSE_TIME(25)
	PULSE[dvRELAYS,nREL_NUMBER]
	SET_PULSE_TIME(5)
    }
}
(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START

(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT
DATA_EVENT[dvIR_DVD]
{
    ONLINE:
    {
	SEND_COMMAND dvIR_DVD,"'SET MODE IR'"
	SEND_COMMAND dvIR_DVD,"'CTON',2"
	SEND_COMMAND dvIR_DVD,"'CTOF',3"
	SEND_COMMAND dvIR_DVD,"'CARON'"
    }
}

/*BUTTON_EVENT[dvTP,nIR_DVD_BTNS]
{
    PUSH:
    {
	LOCAL_VAR INTEGER nBIC
	nBIC = BUTTON.INPUT.CHANNEL
	SEND_COMMAND dvIR_DVD,"'SP',nBIC"
	SET_PULSE_TIME(10)
	PULSE[BUTTON.INPUT]
	SET_PULSE_TIME(5)
    }
} 
*/

BUTTON_EVENT[dvTP, nSCREEN_BTNS]
{
    PUSH:
    {
	LOCAL_VAR INTEGER nBIC
	nBIC = (BUTTON.INPUT.CHANNEL - 30)
	fnPULSE_RELAY(nBIC)
    }
}
(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM
[dvTP,31] = ([dvRELAYS,1])
[dvTP,32] = ([dvRELAYS,2])
[dvTP,33] = ([dvRELAYS,3])

(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)

