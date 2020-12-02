#INCLUDE "Protheus.ch"
#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO8     �Autor  �Microsiga           � Data �  08/01/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT120LOK()
Local lRet := .T. 
Local nPosPrd    := aScan(aHeader,{|x| AllTrim(x[2]) == "C7_PRODUTO"})
Local nPosMat    := aScan(aHeader,{|x| AllTrim(x[2]) == "C7_MATFUNC"})
Local nPosCC     := aScan(aHeader,{|x| AllTrim(x[2]) == "C7_CC"}) 
Local nPosTes    := aScan(aHeader,{|x| AllTrim(x[2]) == "C7_TES"})
Local nPosConta  := aScan(aHeader,{|x| AllTrim(x[2]) == "C7_CONTA"})

//Verifico se o Item nao esta deletado
If !aCols[n][Len(aCols[n])] 

   cRevenda  := Posicione("SB1",1,xFilial("SB1")+aCols[n,nPosPrd],"B1_REVENDA") 
   cTipoProd := Posicione("SB1",1,xFilial("SB1")+aCols[n,nPosPrd],"B1_PRD_LOC")
   
   //Produto para pagamento de Multa de Transito Ira trazer a tela para selecao do funcionario para desconto em folha
   If cTipoProd == "M"
   
      If MsgYesNo("Descontar de Funcionario " )
         
         cMatFunc := U_SelFunc(1,.T.)
         
         If !Empty(cMatfunc)
            aCols[n,nPosMat] := cMatFunc
         EndIf 
      
      EndIf 
      
   ElseIf cRevenda == "S" 
   
       cObra := Posicione("CTD",1,xFilial("CTD")+aCols[n,nPosCC],"CTD_OBRA" )
       
       If cObra $ "R,A"
       
          If MsgYesNo("Este item ser� utilizado para Revenda" )
          
             aCols[n,nPosTes]   := "018" 
             aCols[n,nPosConta] := "311101002"
          EndIf 
       EndIf
        
   EndIf 
   
EndIf 

Return lRet 