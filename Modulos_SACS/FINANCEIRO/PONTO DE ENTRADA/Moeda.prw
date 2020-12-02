#include "rwmake.ch"

User Function Moeda()
   if !Empty(SE2->E2_CODBAR)
      cCampo := SUBSTR(SE2->E2_CODBAR,4,1)                                  
   else
      cCampo := SUBSTR(SE2->E2_LINDIG,4,1)                                  
   endif
Return(cCampo)
