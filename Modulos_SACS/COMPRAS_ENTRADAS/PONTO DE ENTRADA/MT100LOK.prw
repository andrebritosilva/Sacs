#include "rwmake.ch"
#include "protheus.ch"

//ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
//³Programa  ³ MT100LOK ³ Autor ³Katia Cilene Cruz      ³ Data ³17/07/2013³
//ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
//³Descri‡„o ³ Ponto de entrada na entrada da nota fiscal MATA103         ³
//ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
//³Sintaxe   ³ Chamada padr„o para programas em RdMake.                   ³
//ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
//³Uso       ³ Generico                                                   ³
//ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
//³Obs.:     ³ Valida amarração Produto x Fornecedor;                     ³
//³          ³ Valida se existe especificacao para o Produto              ³
//³          ³ se o tipo de C.Q. = "Q" SigaQuality                        ³
//ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
//³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³
//ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
//³Programador ³Data      ³ BOPS ³Motivo da Alteracao                     ³
//ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
//³Katia C Cruz³03/02/14  ³      ³Tratamento campo A5_SITU                ³
//ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
//³            ³          ³      ³                                        ³
//ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
//³            ³          ³      ³                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


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
      
         MsgAlert(" Não existe amarração Produto x Fornecedor - "+_cProd+" X "+_cForn+", favor verificar.")
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
      
         MsgAlert(" Não existe especificação para o Produto - "+_cProd+", favor verificar.")
         RestArea(_cArea)
         Return(.F.)
  
      Endif
      
   Endif        
   
Endif   
*/
   
RestArea(_cArea)
Return(.T.)                                                                   

