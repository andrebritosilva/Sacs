#Include "Rwmake.ch"
#Include "Protheus.ch"

User Function F040CPO()

Local _aCampos := paramixb

aAdd(_aCampos,"E1_CCD") // Adiciona campo E2_CCD
aAdd(_aCampos,"E1_ITEMD")
aAdd(_aCampos,"E1_ITEMC")
aAdd(_aCampos,"E1_CCC")
aAdd(_aCampos,"E1_CCUSTO")
aq
Return _aCampos