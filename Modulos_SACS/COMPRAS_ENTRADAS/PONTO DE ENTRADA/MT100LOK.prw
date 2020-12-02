#include "rwmake.ch"
#include "protheus.ch"

//�����������������������������������������������������������������������Ŀ
//�Programa  � MT100LOK � Autor �Katia Cilene Cruz      � Data �17/07/2013�
//�����������������������������������������������������������������������Ĵ
//�Descri��o � Ponto de entrada na entrada da nota fiscal MATA103         �
//�����������������������������������������������������������������������Ĵ
//�Sintaxe   � Chamada padr�o para programas em RdMake.                   �
//�����������������������������������������������������������������������Ĵ
//�Uso       � Generico                                                   �
//�����������������������������������������������������������������������Ĵ
//�Obs.:     � Valida amarra��o Produto x Fornecedor;                     �
//�          � Valida se existe especificacao para o Produto              �
//�          � se o tipo de C.Q. = "Q" SigaQuality                        �
//�����������������������������������������������������������������������Ĵ
//�         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             �
//�����������������������������������������������������������������������Ĵ
//�Programador �Data      � BOPS �Motivo da Alteracao                     �
//�����������������������������������������������������������������������Ĵ
//�Katia C Cruz�03/02/14  �      �Tratamento campo A5_SITU                �
//�����������������������������������������������������������������������Ĵ
//�            �          �      �                                        �
//�����������������������������������������������������������������������Ĵ
//�            �          �      �                                        �
//�������������������������������������������������������������������������


User Function MT100LOK() 

_cArea    := GetArea()   


/*
If ! Upper(Funname())=="MATA103"
   Return(.T.)
Endif
   
If ! CTIPO $ 'DB'

   If SB1->B1_TIPOCQ = "Q"
   
      _nPosCod  := aScan(aHeader,{|x| AllTrim(x[2])=="D1_COD"})
      _cProd    := aCols[n][_nPosCod]
      _cForn    := ca100For+cLoja
     
      DbSelectArea("SA5")
      DbSetOrder(2)
      
      If ! DbSeek(xFilial("SA5")+_cProd+_cForn)
      
         MsgAlert(" N�o existe amarra��o Produto x Fornecedor - "+_cProd+" X "+_cForn+", favor verificar.")
         RestArea(_cArea)
         Return(.F.)
         
      Else
 
         // Katia C Cruz - Tratamento campo A5_SITU
               
         If EMPTY(SA5->A5_SITU)
         	MsgAlert(" Faltam cadastros na Pasta CQ x Fornecedor - "+_cProd+" X "+_cForn)
         	RestArea(_cArea)
         	Return(.F.)
         Endif	
         
      Endif
      
      DbSelectArea("QE6")
      DbSetOrder(3)
      
      If ! DbSeek(xFilial("QE6")+_cProd)
      
         MsgAlert(" N�o existe especifica��o para o Produto - "+_cProd+", favor verificar.")
         RestArea(_cArea)
         Return(.F.)
  
      Endif
      
   Endif        
   
Endif   
*/
   
RestArea(_cArea)
Return(.T.)                                                                   

