#include "topconn.ch"   
#INCLUDE "Rwmake.ch"
#INCLUDE "PROTHEUS.CH"

User function RelFinLeg()
  
Local cQuery      :="" 
Local cQueryB6    :="" 
Local dEmissao    :=""
Local wHamb       :=""
Local vTotal      :=0
Local cAliasTop   := GetNextAlias()
Local nRegs       := 0

cQuery := "SELECT DISTINCT D1_TIPO    AS 'TIPONF', "
cQuery += "D1_DOC     AS 'NUMERONF', "
cQuery += "D1_SERIE   AS 'SERIENF', "
cQuery += "D1_FORNECE AS 'CODFORNEC', "
cQuery += "D1_NFORI   AS 'NUMNOTAORIGEM', "
cQuery += "D1_SERIORI AS 'SERIEDV ', "
cQuery += "D1_CC      AS 'CENTROCUSTO'," 
cQuery += "D1_ITEMCTA AS 'ITEMCONTA', "
cQuery += "E2_FILIAL  AS 'FILIALTITULO', "
cQuery += "E2_PREFIXO AS 'PREFIXO', "
cQuery += "E2_NUM     AS 'NUMEROTITULO', "
cQuery += "E2_PARCELA AS 'PARCELA', "
cQuery += "E2_TIPO    AS 'TIPO', "
cQuery += "E2_FORNECE AS 'FORNECEDOR', "
cQuery += "E2_LOJA    AS 'LOJA' "
cQuery += "FROM   SD1010 "
cQuery += "LEFT JOIN SF1010 "
cQuery += "ON F1_DOC = D1_DOC "
cQuery += "AND F1_SERIE = D1_SERIE "
cQuery += "AND F1_FORNECE = D1_FORNECE "
cQuery += "AND F1_LOJA = D1_LOJA "
cQuery += "AND SF1010.D_E_L_E_T_ = '' "
cQuery += "LEFT JOIN SE2010 "
cQuery += "ON E2_NUM = F1_DOC "
cQuery += "AND E2_PREFIXO = F1_SERIE "
cQuery += "AND E2_FORNECE = F1_FORNECE "
cQuery += "AND E2_LOJA = F1_LOJA "
cQuery += "AND SE2010.D_E_L_E_T_ = '' "
cQuery += "WHERE  D1_DTDIGIT BETWEEN '20200101' AND '20200717' "
cQuery += "AND E2_ITEMD = '' AND E2_TIPO = 'NF'"

dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cAliasTop,.F.,.F.)

DbSelectArea(cAliasTop)             
(cAliasTop)->(DbGoTop ())


While (cAliasTop)->(!EOF()) 
	
	DbSelectArea("SE2")
	SE2->(dbSetOrder(1)) 
	
	If dbSeek((cAliasTop)->FILIALTITULO + (cAliasTop)->PREFIXO + (cAliasTop)->NUMEROTITULO + (cAliasTop)->PARCELA + (cAliasTop)->TIPO + (cAliasTop)->FORNECEDOR + (cAliasTop)->LOJA )
		RecLock("SE2",.F.)
			SE2->E2_ITEMD := (cAliasTop)->ITEMCONTA
			nRegs := nRegs + 1
		MsUnlock()
	EndIf
	
	(cAliasTop)->(DbSkip())	

EndDo             
MSGINFO( "Itens Contabeis inclusos: " + Str(nRegs) + "", "Itens Inclusos" )
(cAliasTop)->(DbCloseArea())
Return