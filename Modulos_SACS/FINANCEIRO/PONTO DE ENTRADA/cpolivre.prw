#include "rwmake.ch"

User Function CPOLIVRE()
   if len(alltrim(SE2->E2_CODBAR)) < 44
      cCampo := substr(SE2->E2_LINDIG,5,5)+substr(SE2->E2_LINDIG,11,10)+substr(SE2->E2_LINDIG,22,10)
   else
      cCampo := substr(SE2->E2_LINDIG,20,25)
   endif
Return(cCampo)
