#INCLUDE "RWMAKE.CH"
#include "ap5mail.ch"
#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FKXFUN    �Autor  �Carlos R. Moreira   � Data �  05/14/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcoes comuns no Cliente                                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Fortknox                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ValidPerg �Autor  �Carlos R. Moreira   � Data �  03/19/04   ���
�������������������������������������������������������������������������͹��
���Desc.     �Valida o grupo de Perguntas                                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Escola Graduada                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function ValidPerg(cPerg,aRegs)
	Local aArea := GetArea()
	Local i,j
	dbSelectArea("SX1")
	dbSetOrder(1)

	If len(Alltrim(cPerg)) < 10 
	   cPerg := Alltrim(cPerg)+Space(10 - Len(Alltrim(cPerg)))
    EndIf
     
	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next
			MsUnlock()
		Endif
	Next

	RestArea(aArea)

Return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CABREL    �Autor  �Carlos R.Moreira    � Data �  05/12/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �Emite o cabecalho padrao para os relatorios customizados    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Escola Graduada                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User function CabRel(aTitulo,nForma,oPrn,nPag,cProg)
	Local cBitMap:= FisxLogo("1")

	oArial06Neg  :=  TFont():New( "Arial",,06,,.T.,,,,,.F. )

	If nForma == 1   //Paisagem
	
		Titulo := aTitulo[1]
		oPrn:Box( 050,  100, 300, 300 )
		oPrn:SayBitmap( 100,110,cBitMap,200,180 )
		oPrn:Box( 050,  301, 300,2500 )
		oPrn:Box( 050, 2501, 300,3300 )
	
		nCol :=  1610 - ( (Len(Alltrim(aTitulo[2])) / 2 ) * 20 )
		oPrn:Say(  80,  nCol, aTitulo[2],oFont2,100 )
	
		nCol :=  1610 - ( (Len(Alltrim(aTitulo[1])) / 2 ) * 20 )
		oPrn:Say( 150,  nCol, aTitulo[1],oFont2,100 )
	
		nCol :=  1610 - ( (Len(Alltrim(aTitulo[3])) / 2 ) * 20 )
		oPrn:Say( 220,  nCol, aTitulo[3],oFont2,100 )
	
	//	oPrn:Say( 150, 700, Titulo ,oFont3,100 )
	
		oPrn:Say( 090, 2720, "Pagina  :       "+StrZero(nPag,3),oFont12,100 )
		oPrn:Say( 150, 2720, "Emissao : "+Dtoc(Date())   ,oFont12,100 )
		oPrn:Say( 210, 2720, "Hora    : "+Time()   ,oFont12,100 )
	//	oPrn:Say( 270, 2920, cProg  ,oArial06Neg,100 )
	
	Else
	
		oPrn:Box( 050, 100, 300,2300 )
		oPrn:SayBitmap( 100,180,cBitMap,220,180 )
		oPrn:Line( 050, 550, 300, 550 )
		oPrn:Line( 050, 1800, 300, 1800 )
	
		nCol :=  1025 - ( (Len(Alltrim(aTitulo[2])) / 2 ) * 20 )
		oPrn:Say(  80,  nCol, aTitulo[2],oFont2,100 )
	
		nCol :=  1125 - ( (Len(Alltrim(aTitulo[1])) / 2 ) * 20 )
		oPrn:Say( 150,  nCol, aTitulo[1],oFont2,100 )
	
		nCol :=  1125 - ( (Len(Alltrim(aTitulo[3])) / 2 ) * 20 )
		oPrn:Say( 220,  nCol, aTitulo[3],oFont2,100 )
	
		oPrn:Say( 80,  1820, "Emiss�o : "+Dtoc(dDataBase),oFont3,100 )
	
		oPrn:Say( 150, 1820, "P�gina  : "+StrZero(nPag,3),oFont3,100 )
	
		oPrn:Say( 220, 1820, "Hora  : "+Time(),oFont3,100 )
	
		oPrn:Say( 270, 2020, cProg ,oArial06Neg ,100 )

	EndIf

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FKXFUN    �Autor  �Microsiga           � Data �  10/27/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function AceVarQry()

	Local cFilterUser := ""
	If !Empty(aReturn[7])
	//�����������������������������������������������Ŀ
	//� Cria Filtro das Notas de Devolucao            �
	//�������������������������������������������������
		cFilterUser := aReturn[7]
	//	cFilterUser := STRTRAN (cFilterUser,"D2","D1" )
		cFilterUser := STRTRAN (cFilterUser,".And."," And " )
		cFilterUser := STRTRAN (cFilterUser,".and."," And " )
		cFilterUser := STRTRAN (cFilterUser,".Or."," Or ")
		cFilterUser := STRTRAN (cFilterUser,".or."," Or ")
		cFilterUser := STRTRAN (cFilterUser,"=="," = ")
		cFilterUser := STRTRAN (cFilterUser,'"',"'")
		cFilterUser := STRTRAN (cFilterUser,'Alltrim',"LTRIM")
		cFilterUser := STRTRAN (cFilterUser,'$',"Like %")
		cFilterUser := STRTRAN (cFilterUser,"DTOS","")
		cFilterUser := STRTRAN (cFilterUser,"dtos","")
		cFilterUser := STRTRAN (cFilterUser,"dTos","")
		cFilterUser := STRTRAN (cFilterUser,"dToS","")
		cFilterUser := STRTRAN (cFilterUser,"!="," <> " )
	
	//	cFilterUser := STRTRAN (cFilterUser,"CLIENTE","FORNECE" )
	
	EndIf

Return cFilterUser

/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun�ao    �Fc021ProcEx� Autor � Claudio D. de Souza  � Data � 25-04-2005 ���
���������������������������������������������������������������������������Ĵ��
���Descri�ao �Processa a exportacao da planilha de trabalho para o Excel.   ���
���������������������������������������������������������������������������Ĵ��
��� Uso      �FINC021                                                       ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/
User Function Run_Excel(aDadosExcel,nCol)
	LOCAL cDirDocs   := MsDocPath()
	Local aStru		:= {}
	Local cArquivo := CriaTrab(,.F.)
	Local cPath		:= AllTrim(GetTempPath())
	Local oExcelApp
	Local nHandle
	Local cCrLf 	:= Chr(13) + Chr(10)
	Local nX

	ProcRegua(Len(aDaDosExcel))

	nHandle := MsfCreate(cDirDocs+"\"+cArquivo+".CSV",0)

	If nHandle > 0
	
	
		For nX := 1 to Len(aDadosExcel)
		
			IncProc("Aguarde! Gerando arquivo de integra��o com Excel...") //
			cBuffer := ""
			For nY := 1 to nCol  //Numero de Colunas do Vetor
			
				cBuffer += aDadosExcel[nX,nY] + ";"
			
			Next
			fWrite(nHandle, cBuffer+cCrLf ) // Pula linha
		
		Next
	
		IncProc("Aguarde! Abrindo o arquivo...") //
	
		fClose(nHandle)
	
		CpyS2T( cDirDocs+"\"+cArquivo+".CSV" , cPath, .T. )
	
		If ! ApOleClient( 'MsExcel' )
			MsgAlert( 'MsExcel nao instalado' ) //
			Return
		EndIf
	
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open( cPath+cArquivo+".CSV" ) // Abre uma planilha
		oExcelApp:SetVisible(.T.)
	Else
		MsgAlert( "Falha na cria��o do arquivo" ) //
	Endif

Return

/*
����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ��
���Fun��o    � 	Env_Email   � Autor � Carlos R. Moreira� Data � 28/03/02 ���
������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao que envia email                            		 ���
������������������������������������������������������������������������Ĵ��
���Parametros� cEmailTo:	Email do Destinatario.                       ���
���		     � cEmailCC:	Outras Contas para mandar Copia do email.    ���
���		     � cAssunto:	Assunto do Email.							 ���
���		     � cMensagem:	Mensagem do Corpo do email.                  ���
���		     � cAttach:		Arquivos a serem attachados no email.    	 ���
���			 � cChave:		Filial + Matricula do funcionario.  		 ���
������������������������������������������������������������������������Ĵ��
���Uso       � Generica                                                  ���
�������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������
����������������������������������������������������������������������������*/

User Function Env_Email(cEmailTo,cEmailCC,cAssunto,cMensagem,cAttach,cChave)

	Local aSaveArea		:= GetArea()
	Local lOk			:= .F.		// Variavel que verifica se foi conectado OK
	Local lSendOk		:= .F.		// Variavel que verifica se foi enviado OK
	Local cNome			:= ""
	Local cMailConta	:=GETMV("MV_EMCONTA")
	Local cMailServer	:=GETMV("MV_RELSERV")
	Local cMailSenha	:=GETMV("MV_EMSENHA")
	Local nErro			:= 0

	cEmailTo	:= If(cEmailTo 	== Nil, "", cEmailTo)
	cEmailCC	:= If(cEmailCC 	== Nil, "", cEmailCC)
	cAssunto	:= If(cAssunto 	== Nil, "", cAssunto)
	cMensagem	:= If(cMensagem	== Nil, "", cMensagem)
	cAttach		:= If(cAttach 	== Nil, "", Alltrim(cAttach))
	cChave		:= If(cChave	== Nil, "", cChave)

//Verifica se existe o SMTP Server
	If 	Empty(cMailServer)
		nErro := 1
		RestArea(aSaveArea)
		Return(nErro)
	EndIf

//Verifica se existe a CONTA
	If 	Empty(cMailConta)
		nErro := 2
		RestArea(aSaveArea)
		Return(nErro)
	EndIf

//Verifica se existe a Senha
	If 	Empty(cMailSenha)
		nErro := 3
		RestArea(aSaveArea)
		Return(nErro)
	EndIf

//Verifica se existe email do Destinatario
	If 	Empty(cEmailTo)
		nErro := 4
		RestArea(aSaveArea)
		Return(nErro)
	EndIf

// Envia e-mail com os dados necessarios
	If !Empty(cMailServer) .And. !Empty(cMailConta) .And. !Empty(cMailSenha)
		CONNECT SMTP SERVER cMailServer ACCOUNT cMailConta PASSWORD cMailSenha RESULT lOk
		If 	lOk
			SEND MAIL 	FROM cMailConta;
				TO cEmailTo;
				BCC cEmailcc;
				SUBJECT cAssunto;
				BODY cMensagem;
				ATTACHMENT cAttach;
				RESULT lSendOk
			If !lSendOk
			//Erro no Envio do e-mail
				nErro := 5
			EndIf
			DISCONNECT SMTP SERVER
		Else
		//Erro na conexao com o SMTP Server
			nErro := 5
		EndIf
	EndIf

	RestArea(aSaveArea)

Return nErro


//Funcoes para envio de email
/*/
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Funcao    � QNCXRMAIL  � Autor � Cicero Cruz           � Data � 26/09/04 ���
���������������������������������������������������������������������������Ĵ��
���Descricao � Rotina de envio do email generica de Relat�rio. 			    ���
���������������������������������������������������������������������������Ĵ��
���Sintaxe   � QNCXRMAIL()                                                  ���
���������������������������������������������������������������������������Ĵ��
��� Uso		 � SIGAQNC				                 					    ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function  QNCXRMAIL(aRel)

	Local aArqAux := {}
	Local aAttach := {}
	Local aDados  := QNCXRTO()
	Local cBody   := ""
	Local cAttach := ""
	Local cSubject := IIF(aRel[1,3]=="","",aRel[1,3])
	Local aUsrMat := QA_USUARIO()
	Local nX      := 0
	Local nY      := 0
// �������������������������������������Ŀ
// | Valida digita��o dos destinatarios. |
// ���������������������������������������
	If Empty(aDados[1])
		Return
	EndIF
// ����������������������������������������������������Ŀ
// |Gerando Corpo do Email com os Relatorios gerados.   |
// ������������������������������������������������������
	If !Empty(aDados[2])
		cBody := Alltrim(aDados[2])
		cBody += CHR(13)+CHR(10)+CHR(13)+CHR(10)
	EndIF
// ����������������������������������Ŀ
// |Anexa  arquivos                   |
// |       aRel{Path,Arquivo}         |
// ������������������������������������
	For nX:=1 to Len(aRel)
	// �������������������������������������Ŀ
	// | Verifico o arquivo.                 |
	// ���������������������������������������
		aArqAux := Directory(aRel[nX,1]+aRel[nX,2]+"*.jpg")
	
		For nY:=1 to Len(aArqAux)
			AADD(aAttach,{aArqAux[nY,1],aRel[nX,3]})
			If !Empty(cAttach)
				cAttach +=";"
			EndIf
			cAttach +=cStartPath+aArqAux[nY,1]
		Next nY
	Next nX

	aArqAux := {}
// �������������������������������������Ŀ
// | Monta dados para envio do email.    |
// ���������������������������������������
	AADD(aArqAux,{" - " + cSubject,cBody,cAttach})
	aUsuarios := {{"",aDados[1],aArqAux,"2"} }
	U_QaEnvMail(aUsuarios,,,,aUsrMat[5],"2" )  // "2"

// ������������������������������������������������Ŀ
// | Deleta arquivos JPEG gerados pelos relatorios. |
// ��������������������������������������������������
	For nY:=1 to Len(aAttach)
		FErase( cStartPath+aAttach[nY,1] )
	Next nY

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �QAEnvMail � Autor � Aldo Marini Junior    � Data � 26/07/00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Rotina que envia e-mail de acordo com array                ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � QAEnvMail(ExpA1)                                           ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpA1 = Array com os dados de envio (To,Subject,Body,      ���
���          �         Attachment)                                        ���
���          � ExpC1 = Caracter contendo conta de acesso ao servidor      ���
���          � ExpC2 = Caracter contendo o endereco do servidor           ���
���          � ExpC3 = Caracter contendo senha de acesso ao servidor      ���
���          � ExpC4 = Caracter contendo a conta do Usuario logado        ���
�������������������������������������������������������������������������Ĵ��
��� Retorno  � lResult = Logico retornando se houve algum erro no envio   ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � GENERICO                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function QAEnvMail(aUsuarios,cMailConta,cMailServer,cMailSenha,cSendConta,cTipoemail)
	Local lResult	:= .F.
	Local aRetUser := {}
	Local nAtConta
	Default cMailConta  := AllTrim(GETMV("MV_RELACNT"))
	Default cMailServer := AllTrim(GETMV("MV_RELSERV"))
	Default cMailSenha  := AllTrim(GETMV("MV_RELPSW"))
	Default cSendConta  := "SIGA"+cModulo
	Default cTipoemail	:= "1" //1=Sistemas 2=Usuario

//���������������������������������������������������������������������������������Ŀ
//� Verifica se a conta de email do usuario esta com mais de uma e considera apenas �
//� a primeira para conectar e enviar email                                         �
//�����������������������������������������������������������������������������������
	If ";" $ cSendConta
		nAtConta := AT(";",cSendConta)
		cSendConta := SubStr(cSendConta,1,nAtConta-1)
	Endif

	If Len(aUsuarios) == 0
		Return(.F.)
	Endif

	IF cTipoemail=="2"  //Tipo 2=Usuario
		If cSendConta == ("SIGA"+cModulo) .Or. Empty(AllTrim(cSendConta))
			PswOrder(1)
			PswSeek(__CUSERID)
			aRetUser := PswRet(1)
			If !Empty(aRetUser[1][14])
				cSendConta := AllTrim(aRetUser[1][14])
			Else
				cSendConta := GetMV("MV_EMCONTA")
				IF Empty(AllTrim(cSendConta))
					cSendConta := "SIGA"+cModulo+"@PROTHEUS"
				Endif
			EndIf
		Endif
	Else				//Tipo 1=Sistemas
		cSendConta := GetMV("MV_EMCONTA")
		IF Empty(AllTrim(cSendConta))
			cSendConta := "SIGA"+cModulo+"@PROTHEUS"
		Endif
	Endif

	If Empty(AllTrim(cMailConta))
		cMailConta :=AllTrim(GETMV("MV_RELACNT"))
	Endif

	If Empty(AllTrim(cMailServer))
		cMailServer:=AllTrim(GETMV("MV_RELSERV"))
	Endif

	If Empty(AllTrim(cMailSenha))
		cMailSenha :=AllTrim(GETMV("MV_RELPSW"))
	Endif

	LjMsgRun(OemToAnsi("Enviando e-Mail para os Usuarios..."),OemtoAnsi("Aguarde"),{||U_QARunMail(aUsuarios,cMailConta,cMailServer,cMailSenha,@lResult,cSendConta)})  // ### "Aguarde"

Return(lResult)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �QARunMail � Autor � Aldo Marini Junior    � Data � 26/07/00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Rotina que envia e-mail Mostrando Msg de Processamento     ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � QARunMail(ExpA1)                                           ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpA1 = Array com os dados de envio (To,Subject,Body,      ���
���          �         Attachment)                                        ���
���          � ExpC1 = Caracter contendo conta de acesso ao servidor      ���
���          � ExpC2 = Caracter contendo o endereco do servidor           ���
���          � ExpC3 = Caracter contendo senha de acesso ao servidor      ���
���          � ExpL1 = Logical  indicando Erro na Conexao ao Servidor     ���
���          � ExpC4 = Caracter contendo a conta do Usuario logado        ���
�������������������������������������������������������������������������Ĵ��
��� Retorno  � lResult = Logico retornando se houve algum erro no envio   ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � GENERICO                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function QARunMail(aUsuarios,cMailConta,cMailServer,cMailSenha,lResult,cSendConta)
	Local nA := 1
	Local nI := 1
	Local cError	:= ""
	Local lAuth 	:= GetMv("MV_RELAUTH",,.F.)
	Local lMsgError	:= GetMv("MV_QMSGERM", .T., .T.)

	If Empty(cSendConta)
		cSendConta := If(Empty(GetMV("MV_RELFROM",.F.,"")),cSendConta,AllTrim(GetMV("MV_RELFROM")))
	EndIf

	lResult	:= .F.

	If !Empty(cMailServer) .And. !Empty(cMailConta) .And. !Empty(cMailSenha)
	
		For nI :=1 to Len(aUsuarios)
			If !Empty(aUsuarios[nI,2])
				If ! lResult
				// Envia e-mail com os dados necessarios
					CONNECT SMTP SERVER cMailServer ACCOUNT cMailConta PASSWORD cMailSenha RESULT lResult
				
				// Autenticacao da conta de e-mail
					If lResult .And. lAuth
						lResult := MailAuth(cMailConta,cMailSenha)
						If !lResult
							lResult := QAGetMail() // Funcao que abre uma janela perguntando o usuario e senha para fazer autenticacao
						EndIf
						If !lResult
						//Erro na conexao com o SMTP Server
							If lMsgError
								GET MAIL ERROR cError
								MsgInfo(cError,OemToAnsi("Erro de Autenticacao")) // "Erro de Autenticacao"
							Endif
							Return Nil
						Endif
					Else
						If !lResult
						//Erro na conexao com o SMTP Server
							If lMsgError
								GET MAIL ERROR cError
								MsgInfo(cError,OemToAnsi("Erro de Conexao")) // "Erro de Conexao"
							Endif
							Return Nil
						Endif
					EndIf
				Endif
			
				If lResult
					For nA := 1 to Len(aUsuarios[nI,3])
						If !lResult
							Exit
						Endif
					
						SEND        MAIL  ;
							FROM        cSendConta ;
							TO          aUsuarios[nI,2] ;
							SUBJECT     "Protheus SIGA"+cModulo+" "+aUsuarios[nI,3,nA,1] ;
							BODY        aUsuarios[nI,3,nA,2] ;
							ATTACHMENT  aUsuarios[nI,3,nA,3];
							RESULT      lResult
					Next
				
					If !lResult
					//Erro no envio do email
						If lMsgError
							GET MAIL ERROR cError
							MsgInfo(cError,OemToAnsi("Erro no envio de e-Mail")) // "Erro no envio de e-Mail"
						Endif
					EndIf
				EndIf
				If ! lResult
					DISCONNECT SMTP SERVER
				Endif
			Endif
		Next
		DISCONNECT SMTP SERVER
	EndIf

Return Nil


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
User Function DispBrow(cMarca,lInverte,cArq,oMark)
	Local aTempos, cClearing, oCBXCLEAR, oDlgClear,lCOnf

	DbSelectArea( cArq )
	If IsMark("OK",cMarca,lInverte)
		If funname() =='PGPEA01'
			nNumParc := 1	                                                      
			
			@ 001,001 To 180,600 Dialog oSCR1 Title "Quantidade de Parcelas"
			@ 005,005 To 170,590 Pixel
			
			@ 015,020 Say "Informe abaixo a quantidade de parcelas para o t�tulo" +TRB->PEDIDO+"/"+TRB->ITEM  Pixel
			@ 025,020 Say "do funcionario: "+TRB->MAT+"/"+TRB->NOME+ " de Valor: "+cValtoChar(TRB->VALOR)  Pixel
			@ 035,020 Say "Qtd Parcelas: " Pixel
			@ 035,100 MsGet nNumParc Size 20,010 Pixel 
			
			@ 045,020 Button "&Confirmar" Size 030,012 Pixel Action Close(oSCR1)
			//@ 100,127 Button "&Ok"       Size 030,012 Pixel Action (Close(oSCR1),Processa({|lEND| IMPORTA(@lEND)},"Aguarde..."))
			Activate Dialog oSCR1 Centered
			 
			RecLock("TRB",.F.)                                 
		   		TRB->PARCELAS := nNumParc 
		 	MsUnlock()
			
		EndIf
	
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
User Function BrowInverte(cMarca,cArq,oMark)
	Local nReg := (cArq)->(Recno())
	Local cAlias := Alias()
	dbSelectArea(cArq)
	dbGoTop()
	While !Eof()
		RecLock(cArq)
		(cArq)->OK := IIF((cArq)->OK == "  ",cMarca,"  ")
		MsUnlock()
		dbSkip()
	Enddo
	(cArq)->(dbGoto(nReg))

	oMark:oBrowse:Refresh(.t.)
Return Nil


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LibPed    �Autor  �Carlos R. Moreira   � Data �  10/29/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ira liberar o pedido de venda se estiver ok com a lib de    ���
���          �MArgem                                                      ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Gtex                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function LibPed(cPedido)

	wAreaAnt	 := GetArea()
	wAreaSC5	 := SC5->(GetArea())
	wAreaSC6	 := SC6->(GetArea())
	wAreaSC9	 := SC9->(GetArea())
	wAreaSB1	 := SB1->(GetArea())
	wAreaSB2	 := SB2->(GetArea())
	wAreaSF4	 := SF4->(GetArea())
	wAreaSA1	 := SA1->(GetArea())

	Conout("Fun��o de Libera��o de Pedido")

	nTipo := Space(1)
	nStatus:= Space(2)

	DbSelectarea("SC6")
	DbSetorder(1)
	DbSeek(xFilial("SC6")+cPedido)

	While !Eof() .AND. SC6->C6_FILIAL+SC6->C6_NUM == xFilial("SC6")+cPedido
	
		DbSelectArea("SF4")
		DbSeek(xFilial("SF4")+SC6->C6_TES)
	
		DbSelectArea("SB2")
		dBSetOrder(1)
		If dBSeek(xfilial("SB2")+SC6->C6_PRODUTO+SC6->C6_Local) .and.;
				SF4->F4_ESTOQUE=="S"
		Endif
	
		SA1->(DbSeek(xFilial("SA1")+SC6->C6_CLI+SC6->C6_LOJA ))
	
		dbSelectArea("SC6")
	
		RecLock("SC6",.F.)
		SC6->C6_QTDLIB := If(SA1->A1_PERCRES>0 .And.SA1->A1_PERCRES<100 ,SC6->C6_QTDVEN * ( 1 - (SA1->A1_PERCRES / 100 )),SC6->C6_QTDVEN)
		MsUnlock()
	
	/* MALIBDOFAT
	���Parametros�ExpN1: Registro do SC6                                      ���
	���          �ExpN2: Quantidade a Liberar                                 ���
	���          �ExpL3: Bloqueio de Credito                                  ���
	���          �ExpL4: Bloqueio de Estoque                                  ���
	���          �ExpL5: Avaliacao de Credito                                 ���
	���          �ExpL6: Avaliacao de Estoque                                 ���
	���          �ExpL7: Permite Liberacao Parcial                            ���
	���          �ExpL8: Tranfere Locais automaticamente                      ���
	���          �ExpA9: Empenhos ( Caso seja informado nao efetua a gravacao ���
	���          �       apenas avalia ).                                     ���
	���          �ExpbA: CodBlock a ser avaliado na gravacao do SC9           ���
	���          �ExpAB: Array com Empenhos previamente escolhidos            ���
	���          �       (impede selecao dos empenhos pelas rotinas)          ���
	���          �ExpLC: Indica se apenas esta trocando lotes do SC9          ���
	���          �ExpND: Valor a ser adicionado ao limite de credito          ���
	���          �ExpNE: Quantidade a Liberar - segunda UM                    ���
	*/
		MaLibDoFat(SC6->(RecNo()),SC6->C6_QTDLIB,.T.,.T.,.T.,.T.,.F.,.F.)
	
		If SC5->C5_OPER $ "01#09"
			If SC5->C5_CONDPAG == "001" .And. SC5->C5_TIPO == "N" // Condicao a Vista deve ser Bloqueada no Credito
				DbSelectArea("SC9")
				RecLock("SC9",.F.)
				SC9->C9_BLCRED := "01"
				MsUnLock()
			EndIf
		Else
		
			DbSelectArea("SC9")
			RecLock("SC9",.F.)
			SC9->C9_BLCRED := "  "
			SC9->C9_BLEST  := "  "
			MsUnLock()
		EndIf
	
	
		ConOut("MALIBDOFAT Executada")
	
		dbSelectArea("SC6")
		DBSkip()
	
	End

//Verifico se houve duplicidade
	DbSelectArea("SC9")
	DbSetOrder(1)
	DbSeek(xFilial("SC9")+cPedido )

	While SC9->(!Eof()) .And. SC9->C9_PEDIDO == cPedido
	
		If SC9->C9_SEQUEN == "02"
			Reclock("SC9",.F.)
			SC9->(DbDelete())
			MsUnlock()
		EndIf
	
		SC9->(DbSkip())
	
	End

	lBlqCred := .F.

	DbSelectArea("SC9")
	DbSetOrder(1)
	DbSeek(xFilial("SC9")+cPedido )

	While SC9->(!Eof()) .And. SC9->C9_PEDIDO == cPedido
	
		If !Empty(SC9->C9_BLCRED) .And. SC9->C9_BLCRED # "10"
			lBlqCred := .T.
			Exit
		EndIf
	
		SC9->(DbSkip())
	
	End

//Quando Houver bloqueio de Credito Flega o SC5 e Estorna os empenhos
	If lBlqCred
	
		DbSelectArea("SC9")
		DbSetOrder(1)
		DbSeek(xFilial("SC9")+cPedido )
	
		While SC9->(!Eof()) .And. SC9->C9_PEDIDO == cPedido
		
			If !Empty(SC9->C9_BLEST) .Or. SC9->C9_BLEST == "10"
				SC9->(DbSkip())
				Loop
			EndIf
		
		//Estorno a qtd que gera reserva..
			DbSelectArea("SB2")
			If DbSeek(xFilial("SB2")+SC9->C9_PRODUTO+SC9->C9_LOCAL )
				RecLock("SB2",.F.)
				SB2->B2_RESERVA -= SC9->C9_QTDLIB
				MsUnlock()
			Endif
		
			DbSelectArea("SC6")
			DbSetOrder(1)
			If DbSeek(xFilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM )
				RecLock("SC6",.F.)
				SC6->C6_QTDLIB := 0
				SC6->C6_QTDEMP := 0
				SC6->C6_QTDEMP2 := 0
				MsUnlock()
			EndIf
		
		
			SC9->(DbSkip())
		
		End
	
		DbSelectArea("SC5")
		RecLock("SC5",.F.)
		SC5->C5_STATUS := "C"
		MsUnlock()
	
	EndIf

	If Empty(SC5->C5_STATUS)
	
		DbSelectArea("SC5")
		RecLock("SC5",.F.)
		SC5->C5_STATUS := "L"
		MsUnlock()
	
	EndIf

// Retorna as areas originais colocado por Keller
	RestArea(wAreaSF4)
	RestArea(wAreaSB2)
	RestArea(wAreaSB1)
	RestArea(wAreaSC9)
	RestArea(wAreaSC6)
	RestArea(wAreaSC5)
	RestArea(wAreaAnt)

	MsUnlockAll()

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SELFUNC   �Autor  �Carlos R. Moreira   � Data �  02/10/07   ���
�������������������������������������������������������������������������͹��
���Desc.     � Seleciona o funcionario                                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Graduada                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function Selfunc(nModo,lUnico)
	Local aCampos:= {}
	Local cMat   := Space(6)

	AaDd(aCampos,{"OK"        ,"C",2,0})
	AaDd(aCampos,{"MAT"       ,"C", 6,0})
	AaDd(aCampos,{"NOME"      ,"C",40,0})
	AaDd(aCampos,{"CPF"       ,"C",11,0})

	cArqTmp := CriaTrab(aCampos,.T.)

//��������������������������Ŀ
//�Cria o arquivo de Trabalho�
//����������������������������

	DbUseArea(.T.,,cArqTmp,"SELFUNC",.F.,.F.)
	If nModo == 1
		IndRegua("SELFUNC",cArqTmp,"NOME",,,"Selecionando Registros..." )
	Else
		IndRegua("SELFUNC",cArqTmp,"MAT",,,"Selecionando Registros..." )
	EndIf

	DbSelectArea("SRA")
	DbGotop()
	ProcRegua( RecCount())

	While SRA->(!Eof()) .And. SRA->RA_FILIAL == xFilial("SRA")
	
		IncProc("Processando o Matricula "+SRA->RA_MAT)
	
		If SRA->RA_SITFOLH $'D'
			dbSkip()
			Loop
		EndIf
	
		DbSelectArea("SELFUNC")
		RecLock("SELFUNC",.T.)
		SELFUNC->MAT       := SRA->RA_MAT
		SELFUNC->NOME      := SRA->RA_NOME
		SELFUNC->CPF       := SRA->RA_CIC
		MsUnlock()
	
		DbSelectArea("SRA")
		SRA->(DbSkip())
	
	End

	SELFUNC->(DbGoTop())

	aBrowse := {}
	If nModo == 1
		AaDD(aBrowse,{"OK","",""})
		AaDD(aBrowse,{"CPF","","C.P.F.","@R 999.999.999-99"})
		AaDD(aBrowse,{"NOME","","Nome"})
		AaDD(aBrowse,{"MAT","","Matricula"})

	Else
		AaDD(aBrowse,{"OK","",""})
		AaDD(aBrowse,{"MAT","","Matricula"})
		AaDD(aBrowse,{"NOME","","Nome"})
		AaDD(aBrowse,{"CPF","","C.P.F.","@R 999.999.999-99"})
	EndIf

	nOpca    :=0
	lInverte := .F.
	cMarca   := GetMark()

	DEFINE MSDIALOG oDlg1 TITLE "Seleciona Funcionario" From 9,0 To 26,55 OF oMainWnd

//����������������������������������������������������������������������Ŀ
//� Passagem do parametro aCampos para emular tamb�m a markbrowse para o �
//� arquivo de trabalho "FUNC".                                           �
//������������������������������������������������������������������������
	oMark := MsSelect():New("SELFUNC","OK","",aBrowse,@lInverte,@cMarca,{15,3,123,205})

	oMark:bMark := {| | fa060disp(cMarca,lInverte)}
	oMark:oBrowse:lhasMark = .t.
	oMark:oBrowse:lCanAllmark := .t.
	oMark:oBrowse:bAllMark := { || FA060Inverte(cMarca) }

	ACTIVATE MSDIALOG oDlg1 ON INIT LchoiceBar(oDlg1,{||nOpca:=0,oDlg1:End()},{||nOpca:=0,oDlg1:End()},nModo) centered


	If lUnico
		dbSelectArea("SELFUNC")
		dbGoTop()
		While !Eof()
	
			If !Empty(SELFUNC->OK)
				cMat := SELFUNC->MAT
				Exit
			EndIf
			dbSkip()
	
		Enddo

		SELFUNC->(DbCloseArea())

	Else
		cIndex := CriaTrab(Nil,.F.)
		IndRegua("SELFUNC",cArqTmp,"MAT",,,"Selecionando Registros..." )

	EndIf



Return cMat

/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �FA060Disp � Autor � Carlos R. Moreira     � Data � 09/05/03 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Exibe Valores na tela									  ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � Especifico Rhoss Print                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function Fa060Disp(cMarca,lInverte)
	Local aTempos, cClearing, oCBXCLEAR, oDlgClear,lCOnf
	If IsMark("OK",cMarca,lInverte)
	Endif
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Fa060Inve �Autor  �Carlos R. Moreira   � Data �  19/07/04   ���
�������������������������������������������������������������������������͹��
���Desc.     �inverte a Selecao dos Itens                                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Fa060Inverte(cMarca)
	Local nReg := SELFUNC->(Recno())
	Local cAlias := Alias()
	dbSelectArea("SELFUNC")
	dbGoTop()
	While !Eof()
		RecLock("SELFUNC")
		SELFUNC->OK := IIF(SELFUNC->OK == "  ",cMarca,"  ")
		MsUnlock()
		dbSkip()
	Enddo
	SELFUNC->(dbGoto(nReg))
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
Static Function LchoiceBar(oDlg,bOk,bCancel,nModo)
	Local oBar, bSet15, bSet24, lOk
	Local lVolta :=.f.

	DEFINE BUTTONBAR oBar SIZE 25,25 3D TOP OF oDlg
	DEFINE BUTTON RESOURCE "S4WB011N" OF oBar GROUP ACTION ProcNome(nModo) TOOLTIP OemToAnsi("Procura por Nome..")
	DEFINE BUTTON oBtOk RESOURCE "FINAL" OF oBar GROUP ACTION ( lLoop:=lVolta,lOk:=Eval(bOk)) TOOLTIP "Ok - <Ctrl-O>"
	SetKEY(15,oBtOk:bAction)
Return

Static Function ButtonOff(bSet15,bSet24,lOk)
	DEFAULT lOk := .t.
	IF lOk
		SetKey(15,bSet15)
		SetKey(24,bSet24)
	Endif
Return .T.

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ProcNome  �Autor  �Carlos R. Moreira   � Data �  19/07/04   ���
�������������������������������������������������������������������������͹��
���Desc.     �Localiza o Nome do Professor                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Escola Graduada                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ProcNome(nModo)
	Local cNome := If(nModo==1,Space(20),Space(6))
	Local oDlgProc

	If nModo # 1
		cIndex := CriaTrab(Nil,.f.)
		IndRegua("SELFUNC",cIndex,"NOME",,,"Selecionando Registros..." )
	EndIf

	DEFINE MSDIALOG oDlgProc TITLE If(nModo==1,"Procura Nome","Procura Matricula") From 9,0 To 18,40 OF oMainWnd

	@ 5,3 to 41,155 of oDlgProc PIXEL

	If nModo == 1
		@ 15,5 Say "Digite o Nome: " Size 50,10 of oDlgProc Pixel
	Else
		@ 15,5 Say "Matricula : " Size 50,10 of oDlgProc Pixel
	EndIf
	@ 13,45 Get cNome Picture "@!" Size 60,10 of oDlgProc Pixel

	@ 50, 90 BMPBUTTON TYPE 1 Action PosNom(@cNome,oDlgProc)
	@ 50,120 BMPBUTTON TYPE 2 Action Close(oDlgProc)

	ACTIVATE MSDIALOG oDlgProc Centered

	If nModo # 1

		cIndex := CriaTrab(Nil,.f.)
		IndRegua("SELFUNC",cIndex,"MAT",,,"Selecionando Registros..." )

	EndIf

Return


Static Function PosNom(cNome,oDlgProc)

	SELFUNC->(DbSeek(cNome,.T.))

	Close(oDlgProc)

Return
