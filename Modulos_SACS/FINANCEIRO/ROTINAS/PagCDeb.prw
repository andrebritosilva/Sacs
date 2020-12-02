#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 14/08/01

User Function PagCDeb()
Local cCDebito:=""
Local nTam    :=0
nTam:=Len(Alltrim(replace(SEE->EE_CONTA,"-","")))
cCDebito:=STRZERO(Val(SUBSTR(Alltrim(SEE->EE_CONTA),1,(nTam-1))),7,0)
Return(cCDebito)