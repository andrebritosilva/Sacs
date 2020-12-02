#Include "Protheus.ch"
#Include "Rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � _ATCCSE5 �Autor  � Cesar Padovani     � Data �  03/02/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina para atualizar o campo E5_CCD do SE5 conforme o     ���
���          � campo E2_CCD do SE2                                        ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������Ĵ��
��� ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ���
�������������������������������������������������������������������������Ĵ��
��� PROGRAMADOR  � DATA   � MOTIVO DA ALTERACAO                           ���
�������������������������������������������������������������������������Ĵ��
��� Cesar        �03/02/12� Solicitante: Genildo Silva - Domus Aurea      ���
��� Padovani     �        � Motivo: Atualizar o campo E5_CCD conforme o   ���
���              �        �         campo E2_CCD                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function _AtCcSE5()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Private cPerg := "_ATCCSE5"

ValidPerg()
Pergunte(cPerg,.F.)

//���������������������������������������������������������������������Ŀ
//� Montagem da tela de processamento.                                  �
//�����������������������������������������������������������������������
@ 200,1 TO 380,380 DIALOG Dlg_AtE2E5 TITLE OemToAnsi("Atualiza Centro de Custo SE2 x SE5")
@ 02,10 TO 080,190
@ 10,018 Say " Este programa ira compatibilizar o Centro de Custo Debito do  "
@ 18,018 Say " arquivo de Movimentacoes Bancarias(SE5) de acordo com o       "
@ 26,018 Say " arquivo de Titulos a Pagar(SE2).                              "

@ 70,088 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)
@ 70,128 BMPBUTTON TYPE 01 ACTION _AtE2E5()
@ 70,158 BMPBUTTON TYPE 02 ACTION Dlg_AtE2E5:End()

Activate Dialog Dlg_AtE2E5 Centered

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � _AtE2E5  �Autor  � Cesar Padovani     � Data �  03/02/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ajuste do campo E5_CCD de acordo com o E2_CCD              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function _AtE2E5()

If !MsgYesNo("Confirma ?")
	Return
EndIf

_nTotReg := 0
Processa({|| _pAtE2E5() })

If _nTotReg <= 0
	MsgInfo("Nenhum registro encontrado")
Else
	If _nTotReg == 1
		MsgInfo("1 registro processado")
	Else
		MsgInfo(Alltrim(Str(_nTotReg))+" registros processados")
	EndIf
EndIf

Close(Dlg_AtE2E5)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � _pAtE2E5 �Autor  � Cesar Padovani     � Data �  03/02/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Processa ajuste do campo E5_CCD de acordo com o E2_CCD     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function _pAtE2E5()

_cSE2 := RetSQLName("SE2")
_cQuery := ""
_cQuery += "SELECT "+_cSE2+".E2_PREFIXO,"+_cSE2+".E2_NUM,"+_cSE2+".E2_PARCELA,"+_cSE2+".E2_TIPO,"+_cSE2+".E2_FORNECE, "
_cQuery += "       "+_cSE2+".E2_LOJA,"+_cSE2+".E2_VALOR,"+_cSE2+".E2_SALDO,"+_cSE2+".E2_EMISSAO,"+_cSE2+".E2_CCD  "
_cQuery += "FROM "+_cSE2+" "
_cQuery += "WHERE "+_cSE2+".D_E_L_E_T_ <> '*' "
_cQuery += "AND "+_cSE2+".E2_EMISSAO BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"' "
_cQuery += "AND "+_cSE2+".E2_SALDO <> "+_cSE2+".E2_VALOR "
_cQuery += "AND "+_cSE2+".E2_CCD <> '' "
_cQuery += "ORDER BY "+_cSE2+".E2_EMISSAO "
_cQuery := ChangeQuery(_cQuery)

DbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"TRB",.F.,.T.)

_aTam:=TamSX3("E2_VALOR")
TcSetField("TRB","E2_VALOR",_aTam[3],_aTam[1],_aTam[2] )

_aTam:=TamSX3("E2_SALDO")
TcSetField("TRB","E2_SALDO",_aTam[3],_aTam[1],_aTam[2] )

_aTam:=TamSX3("E2_EMISSAO")
TcSetField("TRB","E2_EMISSAO",_aTam[3],_aTam[1],_aTam[2] )

DbSelectArea("TRB")
DbGoTop()
Count To _nTotReg
                   
If _nTotReg == 0
	TRB->(DbCloseArea())
	Return
Else
	DbSelectArea("TRB")
	ProcRegua(_nTotReg)
	DbGoTop()
	Do While !Eof()
	    IncProc("Titulo: "+Alltrim(TRB->E2_PREFIXO)+Alltrim(TRB->E2_NUM)+Alltrim(TRB->E2_PARCELA)+" - C.Custo "+Alltrim(TRB->E2_CCD) )

		// Atualiza o SE5
		DbSelectArea("SE5")
		DbSetOrder(7)
		DbSeek(xFilial("SE5")+TRB->E2_PREFIXO+TRB->E2_NUM+TRB->E2_PARCELA+TRB->E2_TIPO+TRB->E2_FORNECE+TRB->E2_LOJA,.T.)
		Do While !Eof() .and. SE5->E5_PREFIXO==TRB->E2_PREFIXO .and. SE5->E5_NUMERO==TRB->E2_NUM .and. SE5->E5_PARCELA==TRB->E2_PARCELA .and. SE5->E5_TIPO==TRB->E2_TIPO .and. SE5->E5_CLIFOR==TRB->E2_FORNECE .and. SE5->E5_LOJA==TRB->E2_LOJA
			// Considera somente movimentos a pagar
			If Alltrim(SE5->E5_RECPAG)<>"P"
				DbSelectArea("SE5")
				DbSkip()
				Loop
			EndIf
			
			RecLock("SE5",.F.)
			SE5->E5_CCD := TRB->E2_CCD
			MsUnLock()
			
			DbSelectArea("SE5")
			DbSkip()
		EndDo
		
		DbSelectArea("TRB")
		DbSkip()
	EndDo
EndIf

TRB->(DbCloseArea())

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � ValidPerg �Autor� Cesar Padovani           �Data�03/02/2012���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Verifica as perguntas incluindo-as caso nao existam        ���
�������������������������������������������������������������������������Ĵ��
���Uso       �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ValidPerg()

DbSelectArea( "SX1" )
DbSetOrder(1)
cPerg := PADR(cPerg,10)
aRegs:={}
aAdd(aRegs,{cPerg,"01","Da Emissao ?   ","","","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","S","","","",""})
aAdd(aRegs,{cPerg,"02","Ate a Emissao ?","","","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","S","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			FieldPut(j,aRegs[i,j])
		Next
		MsUnlock()
		dbCommit()
	EndIf
Next

Return

