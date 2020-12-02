#include "rwmake.ch"        

User Function BRADCAR()       


Local _Retcar := "000"

If !Empty(SE2->E2_LINDIG)
	IF SUBS(SE2->E2_LINDIG,1,3) == "237"
	_Retcar := "00" + SUBS(SE2->E2_LINDIG,11,1)		
	EndIf
EndIf

Return(_Retcar)
