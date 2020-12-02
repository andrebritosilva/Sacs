#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 14/08/01

User Function BRADLIV()        // incluido pelo assistente de conversao do AP5 IDE em 14/08/01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_AMODEL,")

/////  PROGRAMA PARA INDICAR A MODALIDADE DO PAGAMENTO POS.264-265
_Campo1:=' '
_Campo2:=' '
_Campo3:=' '
_Campo4:=' '
_Campo5:=' '
_cLivre:= ''          
_agencia:= ' '
_digitoAg:= ' '
_carteira:=' '
_nossoNum:=' '
_contaCor:=' '
_zero:= ' '
_digcodbar:=' '
_moeda:=' '

_DOC  := "                        "
_cModelo := SUBSTR(SEA->EA_MODELO,1,2)
//_cBanco  := SUBSTR(SEA->EA_PORTADOR,1,3)

IF _cModelo $ "01_03_08"
   IF SA2->A2_BANCO == "237"
      _DOC  := "                         "
   Else
      _DOC  := "C0000000101              "
   Endif
Else
   //_Doc  :=  SUBSTR(SE2->E2_LINDIG,20,25)
   IF SUBSTR(SE2->E2_LINDIG,1,3) # '237'
      _Campo1:= substr(SE2->E2_LINDIG,5,5)
      _Campo2:= substr(SE2->E2_LINDIG,11,10)
      _Campo3:= substr(SE2->E2_LINDIG,22,10)
      _Campo4:= substr(SE2->E2_LINDIG,33,1)
      _Campo5:= substr(SE2->E2_LINDIG,4,1)
      _cLivre := _Campo1 + _Campo2 + _Campo3 + _Campo4 + _Campo5
   ELse               
      _agencia:= SUBSTR(SE2->E2_LINDIG,5,4)
      _digitoAg:= SUBSTR(SE2->E2_LINDIG,10,1)
      _carteira:= "0" + SUBS(SE2->E2_LINDIG,11,1)
      _nossoNum:=SUBSTR(SE2->E2_LINDIG,12,09) 
      _contaCor:=SUBSTR(SE2->E2_LINDIG,24,7)
      _nossoNum1:=SUBSTR(SE2->E2_LINDIG,22,2)
      _digcodbar:=SUBSTR(SE2->E2_LINDIG,33,1)
      _moeda:=SUBSTR(SE2->E2_LINDIG,4,1)
      _zero:= "0"

      _cLivre := _agencia + _carteira +_nossoNum + _nossoNum1 +_contaCor + _zero + _digcodbar + _moeda
   endif

   Return(_cLivre)        // incluido pelo assistente de conversao do AP5 IDE em 14/08/01
   return(_DOC)


EndIf

return(_DOC)
Return(_cLivre)


/*IF SUBSTR(SE2->E2_LINDIG,1,3) # '237'
   _Campo1:= substr(SE2->E2_LINDIG,5,5)
   _Campo2:= substr(SE2->E2_LINDIG,11,10)
   _Campo3:= substr(SE2->E2_LINDIG,22,10)
   _Campo4:= substr(SE2->E2_LINDIG,33,1)
   _Campo5:= substr(SE2->E2_LINDIG,4,1)
   _cLivre := _Campo1 + _Campo2 + _Campo3 + _Campo4 + _Campo5
ELse               
   _agencia:= SUBSTR(SE2->E2_LINDIG,5,4)
   _digitoAg:= SUBSTR(SE2->E2_LINDIG,10,1)
   _carteira:= "0" + SUBS(SE2->E2_LINDIG,11,1)
   _nossoNum:=SUBSTR(SE2->E2_LINDIG,12,09) 
   _contaCor:=SUBSTR(SE2->E2_LINDIG,24,7)
   _nossoNum1:=SUBSTR(SE2->E2_LINDIG,22,2)
   _zero:= "0"

   _cLivre := _agencia + _carteira +_nossoNum + _nossoNum1 +_contaCor + _zero 
endif

// Substituido pelo assistente de conversao do AP5 IDE em 14/08/01 ==> __Return(_aModel)
/*Return(_cLivre)        // incluido pelo assistente de conversao do AP5 IDE em 14/08/01
