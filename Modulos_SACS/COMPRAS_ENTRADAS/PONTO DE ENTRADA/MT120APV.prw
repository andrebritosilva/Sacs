#include "rwmake.ch"
#include "topconn.ch"

User Function MT120APV()
	
	Local _cRet   := ""
	Local nqtdgru := 0
	Local aArea   := GetArea()
	Local lManut  := ""

	cPedido := SC7->C7_NUM
   
//Quando for emergencial for o grupo correspondente
	If SC7->C7_TIPPED == "3"

		_cRet := "999901"
  
		DbSelectArea("SC7")
		DbSetOrder(1)
		DbSeek(xFilial("SC7")+cPedido )
    
		While SC7->(!Eof()) .And. cPedido == SC7->C7_NUM

			RecLock("SC7",.F.)
			SC7->C7_APROV := _cRet
			MsUnlock()
			SC7->(DbSkip())
      
		End

	ElseIf SC7->C7_TIPPED == "4"

		_cRet := "999902"

		DbSelectArea("SC7")
		DbSetOrder(1)
		DbSeek(xFilial("SC7")+cPedido )
    
		While SC7->(!Eof()) .And. cPedido == SC7->C7_NUM

			RecLock("SC7",.F.)
			SC7->C7_APROV := _cRet
			MsUnlock()
			SC7->(DbSkip())
      
		End

	Else
  
		lDsRh  := .F.
		lEPIS  := .F.
		lManut := .F.

		aCC   := {}
    
		DbSelectArea("SC7")
		DbSetOrder(1)
		DbSeek(xFilial("SC7")+cPedido )
    
		While SC7->(!Eof()) .And. cPedido == SC7->C7_NUM
    
			dbSelectArea("SB1")
			dbSetOrder(1)
			dbSeek(xFilial("SB1")+SC7->C7_PRODUTO )
			  
			If ! lDsRh .Or. !lEpis .Or. !lManut
			
				If SB1->B1_GRUPO == "EPIS"
					_cRet := "000009"
					lEpis := .T.
				ElseIf  SB1->B1_GRUPO == "DSRH" //Quando o grupo for de RH deve forcar o grupo de aprovador
					_cRet := "000003"
					lDsRh := .T.
				ElseIf (SB1->B1_GRUPO == "MANT" .Or. SB1->B1_GRUPO == "MTRA" )
					_cRet := "000002"
					lManut := .T.
				Else
					_cRet := sc7->c7_aprov
				EndIf
    
			Else

				_cRet := "000003"
         
			EndIf

			nPesq := Ascan(aCC, SC7->C7_CC )
			If nPesq == 0
				AaDD(aCC,SC7->C7_CC )
			EndIf
             
			DbSelectArea("SC7")
			SC7->(DbSkip())
      
		End


		If ldsrh
   
			If Len(aCC) > 1

				_cRet := "000003"
                 
				DbSelectArea("SC7")
				DbSetOrder(1)
				DbSeek(xFilial("SC7")+cPedido )
    
				While SC7->(!Eof()) .And. cPedido == SC7->C7_NUM

					RecLock("SC7",.F.)
					SC7->C7_APROV := _cRet
					MsUnlock()
					SC7->(DbSkip())
      
				End
			
			Else
      
				If Substr(aCC[1],1,1) == "1"

					_cRet := "000003"

					DbSelectArea("SC7")
					DbSetOrder(1)
					DbSeek(xFilial("SC7")+cPedido )
    
					While SC7->(!Eof()) .And. cPedido == SC7->C7_NUM

						RecLock("SC7",.F.)
						SC7->C7_APROV := _cRet
						MsUnlock()
						SC7->(DbSkip())
      
					End
         
				Else
         
				EndIf

			EndIf

		ElseIf lEpis

			If Len(aCC) > 1
			
				_cRet := "000009"

				DbSelectArea("SC7")
				DbSetOrder(1)
				DbSeek(xFilial("SC7")+cPedido )
    
				While SC7->(!Eof()) .And. cPedido == SC7->C7_NUM

					RecLock("SC7",.F.)
					SC7->C7_APROV := _cRet
					MsUnlock()
	
					SC7->(DbSkip())
      
				End
   
			Else
    
				If Substr(aCC[1],1,1) == "1"

					_cRet := "000009"

					DbSelectArea("SC7")
					DbSetOrder(1)
					DbSeek(xFilial("SC7")+cPedido )
    
					While SC7->(!Eof()) .And. cPedido == SC7->C7_NUM

						RecLock("SC7",.F.)
						SC7->C7_APROV := _cRet
						MsUnlock()
	
						SC7->(DbSkip())
      
					End

				Else
				
					DbSelectArea("SC7")
					DbSetOrder(1)
					DbSeek(xFilial("SC7")+cPedido )

				   _cRet := SC7->C7_APROV 
				   
				EndIf
      
			EndIf
			
		ElseIf lManut
		
			If Len(aCC) > 1
			
				_cRet := "000002"

				DbSelectArea("SC7")
				DbSetOrder(1)
				DbSeek(xFilial("SC7")+cPedido )
    
				While SC7->(!Eof()) .And. cPedido == SC7->C7_NUM

					RecLock("SC7",.F.)
					SC7->C7_APROV := _cRet
					MsUnlock()
	
					SC7->(DbSkip())
      
				End
   
			Else
    
				If Substr(aCC[1],1,1) == "1"

					_cRet := "000002"

					DbSelectArea("SC7")
					DbSetOrder(1)
					DbSeek(xFilial("SC7")+cPedido )
    
					While SC7->(!Eof()) .And. cPedido == SC7->C7_NUM

						RecLock("SC7",.F.)
						SC7->C7_APROV := _cRet
						MsUnlock()
	
						SC7->(DbSkip())
      
					End

				Else
				
					DbSelectArea("SC7")
					DbSetOrder(1)
					DbSeek(xFilial("SC7")+cPedido )

				   _cRet := SC7->C7_APROV 
				   
				EndIf
      
			EndIf
     
		Else
   
			If Len(aCC) > 1

				_cRet := "000001"

				DbSelectArea("SC7")
				DbSetOrder(1)
				DbSeek(xFilial("SC7")+cPedido )
    
				While SC7->(!Eof()) .And. cPedido == SC7->C7_NUM

					RecLock("SC7",.F.)
					SC7->C7_APROV := _cRet
					MsUnlock()
					SC7->(DbSkip())
      
				End
		   
			EndIf
	
		EndIf

	EndIf
/*   
		cAliasT := GetNextAlias()
	

	// VERIFICA SE TEM VARIOS CENTROS DE CUSTO PARA ENVIAR PARA GRUPO 000001
		CQUERY := "SELECT C7_APROV FROM "+RetSqlName("SC7")+" WHERE D_E_L_E_T_<> '*' AND C7_NUM = '"+cPedido+"' "
		CQUERY += "GROUP BY C7_APROV "
		CQUERY += "ORDER BY C7_APROV "
	
		dbUseArea(.T., 'TOPCONN',TCGenQry(,,cQuery),cAliasT,.F.,.T.)
	
		(cAliast)->(dbgotop())
	
		While ! (cAliast)->(eof())
			nqtdgru++
			(cAliast)->(dbskip())
		Enddo

		if nqtdgru > 1
			_cRet := "000001"
		endif
	

	EndIf */ 


	RestArea(aArea)
Return (_cRet)