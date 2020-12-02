#include "rwmake.ch"

User Function SVALIMP()
    if len(alltrim(SE2->E2_CODBAR)) < 44
       cCampo := substr(SE2->E2_CODBAR,34,5)
    else
       cCampo := substr(SE2->E2_CODBAR,6,14)
    endif
    cCampo := Strzero(Val(cCampo),14)
Return(cCampo)
