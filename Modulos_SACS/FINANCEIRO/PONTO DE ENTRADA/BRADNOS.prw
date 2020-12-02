#include "rwmake.ch"
User Function BRADNOS()

Local     _RETNOS := "000000000000"

//// RETORNA O NOSSO NUMERO QUANDO COM VALOR NO E2_CODBAR, E ZEROS QUANDO NAO
//// TEM VALOR POSICAO ( 142 - 150 )

If !Empty(SE2->E2_LINDIG)
	IF SUBS(SE2->E2_LINDIG,01,3) == "237"
		_RETNOS := SUBSTR(SE2->E2_LINDIG,12,9)+SUBSTR(SE2->E2_LINDIG,22,2)
	EndIf
EndIf
Return(_RETNOS)
