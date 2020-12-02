#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO9     บ Autor ณ AP6 IDE            บ Data ณ  12/04/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Codigo gerado pelo AP6 IDE.                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function atuforole


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Private oLeTxt
Private cCaminho    := ""
Private cString := ""
Private Lcont := .T.
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Montagem da tela de processamento.                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

@ 200,1 TO 380,380 DIALOG oLeTxt TITLE OemToAnsi("Leitura de Arquivo Texto")
@ 02,10 TO 080,190
@ 10,018 Say " Este programa ira ler o conteudo de um arquivo texto, conforme"
@ 18,018 Say " os parametros definidos pelo usuario, com os registros do arquivo"
@ 26,018 Say "                                                            "

@ 70,098 BMPBUTTON TYPE 01 ACTION OkLeTxt()
@ 70,128 BMPBUTTON TYPE 02 ACTION Close(oLeTxt)
@ 70,158 BMPBUTTON TYPE 05 ACTION SELEARQ()
Activate Dialog oLeTxt Centered

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ OKLETXT  บ Autor ณ AP6 IDE            บ Data ณ  12/04/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao chamada pelo botao OK na tela inicial de processamenบฑฑ
ฑฑบ          ณ to. Executa a leitura do arquivo texto.                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function OkLeTxt

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Abertura do arquivo texto                                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

//Private cArqTxt := "D:\gtex\importacao\FOROLE.TXT"
//Private nHdl    := fOpen(cArqTxt,330)

Private cEOL    := "CHR(13)+CHR(10)"

If Empty( cCaminho )  
	
	msginfo("Selecione o arquivo txt.")
	Return lCont
	
Endif


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Inicializa a regua de processamento                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Processa({|| RunCont() },"Processando...")
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ RUNCONT  บ Autor ณ AP5 IDE            บ Data ณ  12/04/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunCont

Local nTamFile, nTamLin, cBuffer, nBtLidos
Local cNomeArq := ""
            
cTam := (len(alltrim(cCaminho))+1)
for a:= 1 to len(alltrim(cCaminho)) //"FOROLEAMA"
    if subs(cCaminho,ctam,1) == "\"
       exit
    endif   
    cNomearq += subs(cCaminho,ctam,1)
    ctam--
next 
cNomarq := ""
nTantot := len(cNomearq)
for a:= 1 to len(cNomearq) 
    if subs(cNomearq,nTantot,1) == "."
       exit
    endif
    cNomarq += subs(cNomearq,nTantot,1)
    nTantot--
next     

//ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
//บ Lay-Out do arquivo Texto gerado:                                บ
//ฬออออออออออออออออัออออออออัอออออออออออออออออออออออออออออออออออออออน
//บCampo           ณ Inicio ณ Tamanho                               บ
//วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
//บ ??_FILIAL     ณ 01     ณ 02                                    บ
//ศออออออออออออออออฯออออออออฯอออออออออออออออออออออออออออออออออออออออผ
Ft_fuse( cCaminho ) 		// Abre o arquivo
Ft_FGoTop()
		
ProcRegua(Ft_fLastRec()) 	// Numero de registros a processar

nlin := 1

do While !ft_feof() 			// Enquanto nใo for final do arquivo
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Incrementa a regua                                                  ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	IncProc()
	
	cBuffer  :=	ALLTRIM(ft_freadln())

	if nLin == 1
		//----------------------------------------------------------------+
		// Cria Arquivo Temporario                                        +
		//----------------------------------------------------------------+
		aCampos := {}
		cPosini := 0
		nCont   := 0     
		cCampo1 := space(10)
		for a:= 1 to len(cBuffer )
			nCont++
			if subs(cbuffer,a,1) == ";"

				if cposini == 0
					cCampo := Substr(cBuffer,01,a-1)
				else
					cCampo := Substr(cBuffer,cposini, (ncont-1) )
				endif
				FOR b:=1 TO LEN(CCAMPO)        
				    if subs(ccampo,b,1) <> " " .and. subs(ccampo,b,1) <> "." .and. subs(ccampo,b,1) <> "ใ"  .and. subs(ccampo,b,1) <> "/" .and. subs(ccampo,b,1) <> "+";
				    .and. subs(ccampo,b,1) <> "/"
				       cCampo1 += subs(ccampo,b,1) 
				    endif   
				NEXT
				cSemAcento := cCampo1
				cSemAcento := StrTran( cSemAcento,"ว" , "C")  //(cAliasQry)->ZZ3_OBS
				cSemAcento := StrTran( cSemAcento,"็" , "c")  //(cAliasQry)->ZZ3_OBS
				cSemAcento := StrTran( cSemAcento,"ร" , "A")  //(cAliasQry)->ZZ3_OBS
				cSemAcento := StrTran( cSemAcento,"ใ" , "a")  //(cAliasQry)->ZZ3_OBS
				cSemAcento := StrTran( cSemAcento,"ษ" , "E")  //(cAliasQry)->ZZ3_OBS
				cSemAcento := StrTran( cSemAcento,"้" , "e")  //(cAliasQry)->ZZ3_OBS
				cSemAcento := StrTran( cSemAcento,"ำ" , "O")  //(cAliasQry)->ZZ3_OBS
				cSemAcento := StrTran( cSemAcento,"๓" , "o")  //(cAliasQry)->ZZ3_OBS
				cSemAcento := StrTran( cSemAcento,"ม" , "A")  //(cAliasQry)->ZZ3_OBS
				cSemAcento := StrTran( cSemAcento,"แ" , "a")  //(cAliasQry)->ZZ3_OBS
				cSemAcento := StrTran( cSemAcento,"อ" , "I")  //(cAliasQry)->ZZ3_OBS
				cSemAcento := StrTran( cSemAcento,"ํ" , "i")  //(cAliasQry)->ZZ3_OBS				      
				ccampo1 := alltrim(cSemacento)
				ccampo1 := subs(alltrim(ccampo1),1,10)
				if ASCAN(aCampos, { |x| alltrim(x[1]) == alltrim(ccampo1) } ) > 0 //ascan(aCampos,ccampo1) > 0                 
				   do case
				      case a > 9 .and. a <= 10
				           ccampo1 := subs(ccampo1,1,9)+alltrim(str(a))
				      case a < 100     
				           ccampo1 := subs(ccampo1,1,8)+alltrim(str(a))				   
				      case a > 100 .and. a < 999
					      ccampo1 := subs(ccampo1,1,7)+alltrim(str(a)) 
				      case a > 999
					      ccampo1 := subs(ccampo1,1,6)+alltrim(str(a)) 
					          
				   endcase  
				endif
				do case   
				   case ALLTRIM(ccampo1) == "UltPreco"
				        aAdd(aCampos, {ccampo1  ,"N",15,02})
				   case ALLTRIM(ccampo1) == "UltCompra"
				     	aAdd(aCampos, {ccampo1  ,"D",08,00})
				   case ALLTRIM(ccampo1) == "Descricao"                
				      aAdd(aCampos, {ccampo1  ,"C",100,00})
				otherwise
				      aAdd(aCampos, {ccampo1  ,"C",30,00})
				Endcase   
			//	endif
				cCampo1 := space(10)				
				cposini := a+1  
				ncont := 0
			endif

		next
		IF TCCanOpen(cNomArq)
			TCDelFile(cNomArq)
		ENDIF          
		
		DBCreate(cNomArq,aCampos, "TOPCONN")
		DbUseArea(.T.,"TOPCONN",cNomArq,"FORN")
		

		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Grava os campos obtendo os valores da linha lida do arquivo texto.  ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	    ft_fskip()		
		cBuffer  :=	ALLTRIM(ft_freadln())
		
	endif 



	DBSELECTAREA("FORN")
    aCampos1 := dbStruct()
    nPosini := 0
    nCont := 0
    a:= 1 
    dbselectarea("FORN")
	RecLock("FORN",.T.) 


      for b:= 1 to len(cBuffer)
        if a > len(acampos1)
           exit
        endif   
		nCont++
        if subs(cBuffer,b,1) == ";"
			if nposini == 0
			   do case                                                          
			      case aCampos1[a,1] == "ULTPRECO"
	                   Replace &(aCampos1[a,1]) with val(alltrim(Substr(cBuffer,01, (B-1) )))
	              case aCampos1[a,1] == "ULTCOMPRA"
			           Replace &(aCampos1[a,1]) with CTOD(alltrim(Substr(cBuffer,01, (B-1) )))  
	           Otherwise                                                                
	              Replace &(aCampos1[a,1]) with alltrim(Substr(cBuffer,01, (B-1) ))	           
	           Endcase                                        
	        else
	           do case                                                                             
   			      case aCampos1[a,1] == "ULTPRECO"
	                   Replace &(aCampos1[a,1]) with val( alltrim(Substr(cBuffer,nposini, (ncont-1) )) )
	              case aCampos1[a,1] == "ULTCOMPRA"
			           Replace &(aCampos1[a,1]) with CTOD(alltrim(Substr(cBuffer,nposini, (NCONT-1) ))) 	              
       		      Otherwise
	                   Replace &(aCampos1[a,1]) with alltrim(Substr(cBuffer,nposini, (ncont-1) ))
	           
	           endcase
	        endif   
           nposini := b + 1                                               
           ncont := 0
           a++
	    endif
	  next


	forN->(MSUnLock())
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Leitura da proxima linha do arquivo texto.                          ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	//nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da proxima linha do arquivo texto
	
	nlin++
	
	ft_fskip()
	
EndDo 

ft_fuse()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ O arquivo texto deve ser fechado, bem como o dialogo criado na fun- ณ
//ณ cao anterior.                                                       ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
                                  
forn->(dbclosearea())

Return



//-----------------------------------
// Funcao para selecionar o arquivo
//-----------------------------------
Static Function SELEARQ()

Local cRetAux  :=""
Local cTipoArq :=""
Local cFile    :=""

cRetAux  := ""
cCaminho := ""
cFile    := ""
mv_par10 := ""
aEstrutura := {}

cTipoArq := "Todos os Arquivos (*.TXT)     | *.TXT | "
cRetAux  := cGetFile(cTipoArq,"Selecione o arquivo de importa็ใo",0,"SERVIDOR\",.T.,GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE)
mv_par10 := cRetAux
cCaminho := cRetAux //Guarda caminho do arquivo de seriais para endere็amento em MT100AGR
//cFile:= SubStr(cRetAux,RAT("\",cRetAux) + 1,Len(cRetAux))

if !empty( cCaminho ) 
	
	@ 145,65 Say "Arquivo Selecionado: "+ cCaminho pixel
	
	if substr( cCaminho,len( cCaminho )-2,3) <> "txt" //.and. substr( cCaminho,len( cCaminho )-2,3) <> "csv"
		
		Msgstop("O arquivo deve ser do tipo *.txt")
		nopca := .F.
		lCont := .F.
		//oLeTxt:End()
		Return lCont
		
	endif
	
Endif

Return lCont
