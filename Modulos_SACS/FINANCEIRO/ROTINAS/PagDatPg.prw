#include "rwmake.ch"

User Function PagDatPg()
Local cDatPg:=""

If Alltrim(dtos(SE2->E2_DTPAG)) <> ""
	cDatPg:=Dtos(SE2->E2_DTPAG)
Else
	Alert("Deve ser preenchido a data de pagamento do titulo: "+SE2->E2_NUM)
EndIf 

Return(cDatPg) 
