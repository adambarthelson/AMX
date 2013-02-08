PROGRAM_NAME='Switcher'
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
dvSWITCHER   = 5001:2:201
#END_IF

dvTP_SWITCHER = 10001:2:201
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
VOLATILE CHAR sTO_SEND[8]
VOLATILE INTEGER nSELECTED_INPUT
VOLATILE INTEGER nSELECTED_OUTPUT
VOLATILE INTEGER nARRAY_OF_OUTPUTS[8]

VOLATILE INTEGER nINPUT_BTNS[]={
101,102,103,104,105,106,107,108}
VOLATILE INTEGER nOUTPUT_BTNS[]={
201,202,203,204,205,206,207,208}


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

DATA_EVENT[dvSWITCHER]
{
    ONLINE://WHEN SERIAL PORT 2 ONLINE..
    {
	SEND_COMMAND dvSWITCHER,"'SET BAUD 9600,N,8,1 485 DISENABLE'"
    }
}
BUTTON_EVENT[dvTP_SWITCHER,nINPUT_BTNS]
{
    PUSH://ANY INPUT BTN
    {
	nSELECTED_INPUT = BUTTON.INPUT.CHANNEL - 100
	sTO_SEND = "'CL0I',ITOA(nSELECTED_INPUT),'O'"
    }
}

BUTTON_EVENT[dvTP_SWITCHER,nOUTPUT_BTNS]
{
    PUSH://ANY OUTPUT BTN
    {
	nSELECTED_OUTPUT = BUTTON.INPUT.CHANNEL - 200
	sTO_SEND = "sTO_SEND,ITOA(nSELECTED_OUTPUT),'T'"
	SEND_STRING dvSWITCHER, "sTO_SEND"
    }
}
(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM
[dvTP_SWITCHER,101] = (nSELECTED_INPUT == 1)
[dvTP_SWITCHER,102] = (nSELECTED_INPUT == 2)
[dvTP_SWITCHER,103] = (nSELECTED_INPUT == 3)
[dvTP_SWITCHER,104] = (nSELECTED_INPUT == 4)
[dvTP_SWITCHER,105] = (nSELECTED_INPUT == 5)
[dvTP_SWITCHER,106] = (nSELECTED_INPUT == 6)
[dvTP_SWITCHER,107] = (nSELECTED_INPUT == 7)
[dvTP_SWITCHER,108] = (nSELECTED_INPUT == 8)
[dvTP_SWITCHER,201] = (nSELECTED_OUTPUT == 1)
[dvTP_SWITCHER,202] = (nSELECTED_OUTPUT == 2)
[dvTP_SWITCHER,203] = (nSELECTED_OUTPUT == 3)
[dvTP_SWITCHER,204] = (nSELECTED_OUTPUT == 4)
[dvTP_SWITCHER,205] = (nSELECTED_OUTPUT == 5)
[dvTP_SWITCHER,206] = (nSELECTED_OUTPUT == 6)
[dvTP_SWITCHER,207] = (nSELECTED_OUTPUT == 7)
[dvTP_SWITCHER,208] = (nSELECTED_OUTPUT == 8)

(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)
