#INCLUDE "RWMAKE.CH"
#include "Protheus.Ch"
#INCLUDE "VKEY.CH"
#INCLUDE "colors.CH"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FI050ROT  �Autor  �Carlos R. Moreira   � Data �  06/27/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �Acrescenta nos rotinas no Menu                              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function F050ROT()

aRotina := ParamIxb

aAdd( aRotina,	{ "Visual C.Custo"   ,"U_Vis_CC", 0 , 6})
aAdd( aRotina,	{ "Cons Doc Entrada"   ,"U_ConDocEnt", 0 , 6})

Return aRotina


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FI050ROT  �Autor  �Microsiga           � Data �  10/29/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Consulta o contrato                                        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Scarlat                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function Vis_CC()
Local aArea := GetArea()

If SE2->E2_PREFIXO # "GPE"

DbSelectArea("SD1")
DbSetOrder(1)

If DbSeek(xFilial("SD1")+SE2->E2_NUM+SE2->E2_PREFIXO+SE2->E2_FORNECE+SE2->E2_LOJA )
          
   Mostra_CC()
   
EndIf 
                          
Else

DbSelectArea("RC1")
DbSetOrder(5)

If DbSeek(xFilial("RC1")+SE2->E2_NUM )
          
   Mostra_CC()
   
EndIf 

EndIf 

RestArea(aArea)
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F050ROT   �Autor  �Microsiga           � Data �  06/20/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Mostra_cc()
Local aCampos := {}
Local oDlg1, oValor

AADD(aCampos,{"OK"   ,"C",2,0 })
AADD(aCampos,{"COD"  ,"C",6,0 })
AADD(aCampos,{"DESC" ,"C",30,0 }) 
AADD(aCampos,{"CC"   ,"C", 9,0 })
AADD(aCampos,{"VALOR" ,"N",17,2 })

cArqTrab := CriaTrab(aCampos,.T.)
dbUseArea(.T.,,cArqTrab,"TRB",.F.,.F.)
IndRegua("TRB",cArqTrab,"COD+CC",,,"Selecionando Registros..." )

If SE2->E2_PREFIXO # "GPE" 
DbSelectArea("SD1")

While SD1->(!Eof()) .And.  SE2->E2_NUM+SE2->E2_PREFIXO+SE2->E2_FORNECE+SE2->E2_LOJA == SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA

   DbSelectArea("TRB")
   RecLock("TRB",.T.) 
   TRB->COD   := SD1->D1_COD
   TRB->DESC  := SD1->D1_DESCR
   TRB->CC    := SD1->D1_CC
   TRB->VALOR := SD1->D1_TOTAL 
   MsUnlock()

   DbSelectArea("SD1")
   DbSkip()
   
End 

Else

DbSelectArea("RC1")

While RC1->(!Eof()) .And.  RC1->RC1_NUMTIT == SE2->E2_NUM 

   DbSelectArea("TRB")
   RecLock("TRB",.T.) 
   TRB->COD   := RC1->RC1_MAT
   TRB->DESC  := RC1->RC1_DESCRI
   TRB->CC    := RC1->RC1_CC
   TRB->VALOR := RC1->RC1_VALOR 
   MsUnlock()

   DbSelectArea("RC1")
   DbSkip()
   
End 

EndIf 

TRB->(DbGoTop())

aBrowse := {}
AaDD(aBrowse,{"OK","",""})

AaDD(aBrowse,{"COD","","Produto"})
AaDD(aBrowse,{"DESC","","Descricao"})
AaDD(aBrowse,{"CC","","C.Custo"}) 
AaDD(aBrowse,{"VALOR","","Valor","@E 999,999,999.99"})

cMarca   := GetMark()
nOpca    :=0
lInverte := .F.
DEFINE MSDIALOG oDlg1 TITLE "Consulta o Titulo C.Custo" From 9,0 To 37,80 OF oMainWnd

//����������������������������������������������������������������������Ŀ
//� Passagem do parametro aCampos para emular tamb�m a markbrowse para o �
//� arquivo de trabalho "TRB".                                           �
//������������������������������������������������������������������������
oMark := MsSelect():New("TRB","","",aBrowse,@lInverte,@cMarca,{15,3,203,315})

oMark:bMark := {| | fa060disp(cMarca,lInverte)}
oMark:oBrowse:lhasMark = .t.
oMark:oBrowse:lCanAllmark := .t.
oMark:oBrowse:bAllMark := { || FA060Inverte(cMarca) }

ACTIVATE MSDIALOG oDlg1 ON INIT LchoiceBar(oDlg1,{||nOpca:=1,oDlg1:End()},{||oDlg1:End()},.F.) centered

TRB->(DbCloseArea())

Return

/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �FA060Disp � Autor � Carlos R. Moreira     � Data � 09/05/03 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Exibe Valores na tela									  ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � Especifico Escola Graduada                                 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function Fa060Disp(cMarca,lInverte)
Local aTempos, cClearing, oCBXCLEAR, oDlgClear,lCOnf
If IsMark("OK",cMarca,lInverte)

Else
	
Endif
oMark:oBrowse:Refresh(.t.)
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �EGF003    �Autor  �Microsiga           � Data �  02/19/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Fa060Inverte(cMarca)
Local nReg := TRB->(Recno())
Local cAlias := Alias()
dbSelectArea("TRB")
dbGoTop()
While !Eof()
	RecLock("TRB")
	TRB->OK := IIF(TRB->OK == "  ",cMarca,"  ")
	MsUnlock()
	dbSkip()
Enddo
TRB->(dbGoto(nReg))

oMark:oBrowse:Refresh(.t.)
Return Nil

/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �LchoiceBar� Autor � Pilar S Albaladejo    � Data �          ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Mostra a EnchoiceBar na tela                               ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function LchoiceBar(oDlg,bOk,bCancel,lPesq)
Local oBar, bSet15, bSet24, lOk
Local lVolta :=.f.

DEFINE BUTTONBAR oBar SIZE 25,25 3D TOP OF oDlg
//DEFINE BUTTON RESOURCE "PESQUISA" OF oBar GROUP ACTION ProcTransp() TOOLTIP OemToAnsi("Procura Transportadora...")    //
//DEFINE BUTTON RESOURCE "EDIT" OF oBar GROUP ACTION PrincTransp() TOOLTIP OemToAnsi("Define a Transportadora Principal.")    //
DEFINE BUTTON oBtOk RESOURCE "OK" OF oBar GROUP ACTION ( lLoop:=lVolta,lOk:=Eval(bOk)) TOOLTIP "Ok - <Ctrl-O>"
SetKEY(15,oBtOk:bAction)
DEFINE BUTTON oBtCan RESOURCE "CANCEL" OF oBar ACTION ( lLoop:=.F.,Eval(bCancel),ButtonOff(bSet15,bSet24,.T.)) TOOLTIP OemToAnsi("Cancelar - <Ctrl-X>")  //
SetKEY(24,oBtCan:bAction)
oDlg:bSet15 := oBtOk:bAction
oDlg:bSet24 := oBtCan:bAction
oBar:bRClicked := {|| AllwaysTrue()}
Return

Static Function ButtonOff(bSet15,bSet24,lOk)
DEFAULT lOk := .t.
IF lOk
	SetKey(15,bSet15)
	SetKey(24,bSet24)
Endif
Return .T.

