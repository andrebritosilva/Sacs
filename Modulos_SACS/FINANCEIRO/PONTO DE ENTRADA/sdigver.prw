#include "rwmake.ch"

User Function SDIGVER()
   _nPos  := 33 //iif(len(alltrim(SE2->E2_CODBAR))<44,33,5)
   cCampo := substr(SE2->E2_LINDIG,_nPos,1)
Return(cCampo)