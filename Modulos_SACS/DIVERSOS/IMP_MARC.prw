#include "rwmake.ch"
#include "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMP_MARC  ºAutor  ³Carlos R. Moreira   º Data ³  09/10/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ira seleciona o arquivo com os pedidos do HCI para        º±±
±±º          ³ fazer o comparativo                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function IMP_MARC()
Local cFile 	:= ""
Local xBuffer  := ""
Local dData 	:= Ctod("")

Private lContinua := .F.
Private cPerg := "IMP_MARC"
Private aCampos := {}

//PutSx1(cPerg,"01","Data processamento         ?","","","mv_ch1","D",  8,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","",{{"Data de processamento "}},{{" "}},{{" "}},"")

cFile := cGetFile("Arquivos | *.TXT", "Selecione os Arquivos ")
If !Empty(cFile) .and. File( cFile )
	
	LjMsgRun("Gerando o arquivo de marcaçoes..","Aguarde",{||GerArqMarc(cFile)} )
	
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GerArqMarcºAutor  ³Carlos R Moreira    º Data ³  09/12/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera o arquivo                                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GerArqMarc(cFile)
Local nRecno := 0

If ! MsgYesNo("Deseja realmente processar o arquivo..")
   Return
EndIf 
   
lFirst := .T.
FT_FUSE(cFile)
FT_FGOTOP()

While !FT_FEOF()
	
	cLinha:= FT_FREADLN()
	
	If Empty(cLinha) .Or. lFirst .Or. Substr(cLinha,1,1) == "9"
		FT_FSKIP()
		lFirst := .F.
		Loop
	EndIf
	
	++nRecno
	cRecno	 := Ltrim(Str( nRecno ))
	
	IncProc('Processando Linha: ' + cRecno )
	
	//Pega os Dados
	
	dData := Ctod(Substr(cLinha,11,2)+"/"+Substr(cLinha,13,2)+"/"+Substr(cLinha,15,4))
	cHora := Substr(cLinha,19,4)
	cPis  := Substr(cLinha,24,11)
	
	DbSelectArea("SRA")
	DbSetOrder(6)
	If ! DbSeek(xFilial("SRA")+cPis )
		MsgStop("Funcionario nao cadastrado..")
		FT_FSKIP()
		Loop
	EndIf
	
	DbSelectArea("SZ3")
	DbSetOrder(1)
	If !DbSeek(xFilial("SZ3")+Dtos(dData)+SRA->RA_MAT )
		Reclock("SZ3",.T.)
		SZ3->Z3_FILIAL  := xFilial("SZ3")
		SZ3->Z3_MAT     := SRA->RA_MAT
		SZ3->Z3_NOME    := SRA->RA_NOME
		SZ3->Z3_CC      := SRA->RA_CC
		SZ3->Z3_PIS     := cPis
		SZ3->Z3_DATA    := dData
		SZ3->Z3_1E      := cHora 
		MsUnlock()
	Else
		Reclock("SZ3",.F.)
		If !Empty(SZ3->Z3_1E) .And. cHora # SZ3->Z3_1E
			
			If Empty(SZ3->Z3_1S)
				SZ3->Z3_1S := cHora
			Else
				If !Empty(SZ3->Z3_1S) .And. cHora # SZ3->Z3_1S
					If Empty(SZ3->Z3_2E)
						SZ3->Z3_2E := cHora
					Else
						If !Empty(SZ3->Z3_2E) .And. cHora # SZ3->Z3_2E
							
							If Empty(SZ3->Z3_2S)
								SZ3->Z3_2S := cHora
							Else
								If !Empty(SZ3->Z3_2S) .And. cHora # SZ3->Z3_2S
									
									If Empty(SZ3->Z3_3E)
										SZ3->Z3_3E := cHora
									Else
										If !Empty(SZ3->Z3_3E) .And. cHora # SZ3->Z3_3E
											If Empty(SZ3->Z3_3S)
												SZ3->Z3_3S := cHora
											Else
												If !Empty(SZ3->Z3_3S) .And. cHora # SZ3->Z3_3S
													If Empty(SZ3->Z3_4E)
														SZ3->Z3_4E := cHora
													Else
														If !Empty(SZ3->Z3_4E) .And. cHora # SZ3->Z3_4E
															If Empty(SZ3->Z3_4S)
																SZ3->Z3_4S := cHora
															EndIf
														EndIf
													EndIf
												EndIf
											EndIf
										EndIf
									EndIf
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
		MsUnlock()
	EndIf
	
	FT_FSKIP()
	
End

FT_FUSE()

Return


