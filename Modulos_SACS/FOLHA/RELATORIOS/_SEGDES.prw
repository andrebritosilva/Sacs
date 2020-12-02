#INCLUDE "RWMAKE.CH"        // incluido pelo assistente de conversao do AP5 IDE em 19/11/99
#INCLUDE 'SEGDES.CH'
#INCLUDE 'protheus.CH'
/*
�����������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������ͻ��
���Programa     �_SEGDES   �Autor  �Microsiga                � Data �  10-01-02  ���
�������������������������������������������������������������������������������͹��
���Desc.        �Requerimento de Seguro-Desemprego - S.D.	 	 	 	           ���
�������������������������������������������������������������������������������͹��
���Uso          �AP6                                                            ���
�������������������������������������������������������������������������������͹��
���			     	        ATUALIZACOES OCORRIDAS                                ���
�������������������������������������������������������������������������������Ĵ��
���Programador  �Data    � BOPS/FNC  �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������������Ĵ��
���Priscila     �30/09/02�015780     �Ajuste p/ Impressao, qdo Cal.Resc. mes se ���
���             �        �           �guinte e nao foi feito o Fechamento Atual.���
���             �        �-----------�Ajuste no salto de pagina.                ���
���             �        �-----------�Acerto nos Valores dos 3 Ultimos Salarios.���
���             �        �-----------�Ajuste para posicionar correto no SRA.    ���
���             �        �-----------�Ajuste na impressao em Disco.             ���
���             �        �-----------�Validacao Impr.Rescisao somente Efetiva.  ���
���Emerson      �06/01/03�-----------�Buscar o codigo CBO no cadastro de funcoes���
���             �        �-----------�de acordo com os novos codigos CBO/2002.  ���
���Priscila     �15/05/03�063264     �Ajuste p/ trazer correto os valores dos 3 ���
���             �        �           �ultimos salarios.                         ���
���Silvia       �30/09/03�066800     �Ajuste no calculo dos 3 ult.salario       ���
���Pedro Eloy   �12/02/04�069232     |Definicao das variaveis atribuindo o :=0  ���
���Pedro Eloy   �02/06/04�068748     |Foi tratado os valores AntPen. e Penul.   ��� 
���             �17/08/04�073442     �Troca da fSomaAcl por fBuscaAcm- verifica ���
���             �        �-----------�as transf. do funcionario                 ���
���             �13/09/04�-----------�Novo lay-out - Resol. 393/2004            ���
���             �15/02/05�075395     �Faz a impressao dos salarios juntamente   ���
���             �        �-----------�com as verbas incorporadas -Busca id 318  ���
���Pedro Eloy   �13/07/05�SADVLQ     �Ajuste no retorno do campo SRA->RA_SerCp  ���
���             �        �-----------�busca a serie da carteira trabalhista.    ���
���             �29/07/05�082433     �Impressao do campo telefone do Funcion.   ���
���Ricardo D.   �05/01/06�090269     �Ajuste na pesquisa do penultimo salario no���
���             �        �           �caso em que a demissao ocorrer no mes se- ���
���             �        �           �guinte ao mes aberto.                     ���
���Tania/Ricardo�22/02/06�092668     �Acerto para impressao das verbas no acumu-���
���             �        �           �lado quando em Top.                       ���
���Natie        �04/07/06�101533     �Ajuste na impressao do cpo Endereco       ���
���Natie        �28/11/06�111215     �Ajuste na impressao do Cep qdo nao havia  ���
���             �        �           �impressao de complemento  de endereco     ���
���Pedro Eloy   �01/06/07�126187     �Tratamento na emissao do aviso indenizado.���
���Natie        �06/06/07�096700     �Ajuste na composicao dos meses trabalhados���
���Marcelo      �20/01/09�155069     �Conversao p/ permitir impressao em formato���
���             �        �           �grafico. Inclusao das funcoes: AjustaSX e ���
���             �        �           �fIncSpace.                                ���
���Marcelo      �06/03/09�004737/2009�Criacao de pergunta p/definir se as verbas���
���             �        �           �informadas serao somadas no ultimo salario���
���Marcelo      �27/05/09�013064/2009�Ajuste em fSegDes para considerar sempre a���
���             �        �           �data de demissao na apuracao dos meses    ���
���             �        �           �trabalhados.                              ���
���Reginaldo    �19/08/09�020743/2009� Ajuste no grupo de campos filial.        ���
���Marcelo      �11/09/09�022163/2009�Ajustes na funcao fIncSpace e no valor das���
���             �        �           �margens horizontal e vertical p/ corrigir ���
���             �        �           �a impressao no formato grafico.           ���
���Luis Ricardo �04/11/10�023628/2010�Ajustes no layout da versao Grafica.		���
�������������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������������
���������������������������������������������������������������������������������*/
User Function _SEGDES()        // incluido pelo assistente de conversao do AP5 IDE em 19/11/99

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������
Private NSALARIO	:=0,NSALHORA	:=0,NORDEM		:=0
Private NSALMES		:=0,NSALDIA		:=0,NLUGAR		:=0
Private NVALULT		:=0,NVALPEN		:=0,NVALANT		:=0
Private NVALULTSAL	:=0,NVALPENSAL	:=0,NVALANTSAL	:=0,NX		:=0

SetPrvt("CTIT,CDESC1,CDESC2,CDESC3,CSTRING,CALIAS")
SetPrvt("AORD,WNREL,CPERG,CFILANTE,LEND,LFIRST")
SetPrvt("ARETURN,AINFO,NLASTKEY")
SetPrvt("CFILDE,CFILATE,CMATDE,CMATATE,CCOMPL")
SetPrvt("CCCDE,CCCATE,NVIAS,DDTBASE,CVERBAS,DDEMIDE,DDEMIATE")
SetPrvt("CNOME,CEND,CCEP,CUF,CFONE,CMAE,CTPINSC")
SetPrvt("CCGC,CCNAE,CPIS,CCTPS,CCTSERIE,CCTUF")
SetPrvt("CCBO,COCUP,DADMISSAO,DDEMISSAO,CSEXO,CGRINSTRU")
SetPrvt("DNASCIM,CHRSEMANA,CMAT,CFIL,CCC,CNMESES")
SetPrvt("C6SALARIOS,CINDENIZ,DDTULTSAL,DDTPENSAL,DDTANTSAL,CTIPO")
SetPrvt("CVALOR,CCPF,aCodFol, cEndCompl")

//+--------------------------------------------------------------+
//� Define Variaveis Locais (Basicas)                            �
//+--------------------------------------------------------------+
cTit     :=	STR0001 // ' REQUERIMENTO DE SEGURO-DESEMPREGO - S.D. '
cDesc1   :=	STR0002 // 'Requerimento de Seguro-Desemprego - S.D.'
cDesc2   :=	STR0003 // 'Ser� impresso de acordo com os parametros solicitados pelo'
cDesc3   :=	STR0004 // 'usuario.'
cString  :=	'SRA'
cAlias   :=	'SRA'
aOrd     :=	{STR0005,STR0006}	// 'Matricula'###'Centro de Custo'
WnRel    :=	'_SEGDES'
cPerg    :=	'SEGDES'                    
cFilAnte :=	Replicate("�", FWGETTAMFILIAL)
lEnd     :=	.F.
lFirst   :=	.T.
aReturn  :=	{ STR0007,1,STR0008,2,2,1,'',1 }	// 'Zebrado'###'Administra��o'	
aInfo    :=	{}
nLastKey :=	0
nLinha	 :=	0
aRegs    :=	{}

/*
��������������������������������������������������������������Ŀ
� Variaveis de Acesso do Usuario                               �
����������������������������������������������������������������*/
cAcessaSRA	:= &( " { || " + ChkRH( "_SEGDES" , "SRA" , "2" ) + " } " )

AjustaSX()

//+--------------------------------------------------------------+                      
//� Verifica as perguntas selecionadas                           �
//+--------------------------------------------------------------+
pergunte('SEGDES',.F.)
   
//+--------------------------------------------------------------+
//� Variaveis utilizadas para parametros                         �
//� MV_PAR01        //  FiLial De                                �
//� MV_PAR02        //  FiLial Ate                               �
//� MV_PAR03        //  Matricula De                             �
//� MV_PAR04        //  Matricula Ate                            �
//� MV_PAR05        //  Centro De Custo De                       �
//� MV_PAR06        //  Centro De Custo Ate                      �
//� MV_PAR07        //  N� de Vias                               �
//� MV_PAR08        //  Data Base                                �
//� MV_PAR09        //  Verbas a serem somadas ao Salario        �
//� MV_PAR10        //  Compl.Verbas a somar ao Salario          �
//� MV_PAR11        //  Data Demissao De                         �
//� MV_PAR12        //  Data Demissao Ate                        �
//� MV_PAR13        //  1=impressao Grafica; 2=Impressao Zebrada �
//� MV_PAR14        //  Somar verbas da Rescisao; 1=Sim; 2=Nao   �
//+--------------------------------------------------------------+
   
//+--------------------------------------------------------------+
//� Envia controle para a funcao SETPRINT                        �
//+--------------------------------------------------------------+
WnRel :=SetPrint(cString,WnRel,cPerg,cTit,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,'M')

//+--------------------------------------------------------------+
//� Carregando variaveis MV_PAR?? para Variaveis do Sistema.     �
//+--------------------------------------------------------------+
nOrdem   := aReturn[8]

cFilDe	 := If(!Empty(MV_PAR01), MV_PAR01, Space(FWGETTAMFILIAL))
cFilAte	 := If(!Empty(MV_PAR02), MV_PAR02, Replicate("Z", FWGETTAMFILIAL))
cMatDe	 := If(!Empty(MV_PAR03), MV_PAR03, Space(GetSx3Cache("RA_MAT", "X3_TAMANHO")))
cMatAte	 := If(!Empty(MV_PAR04), MV_PAR04, Replicate("Z", GetSx3Cache("RA_MAT", "X3_TAMANHO")) )
cCCDe	 := If(!Empty(MV_PAR05), MV_PAR05, Space(GetSx3Cache("RA_CC", "X3_TAMANHO")))
cCCAte	 := If(!Empty(MV_PAR06), MV_PAR06, Replicate("Z", GetSx3Cache("RA_CC", "X3_TAMANHO")) )
nVias	 := If(!Empty(MV_PAR07), IIf(MV_PAR07 <= 0, 1, MV_PAR07), 1)
dDtBase  := If(!Empty(MV_PAR08), IIf(Empty(MV_PAR08), dDataBase, MV_PAR08), dDataBase)
cVerbas  := AllTrim(MV_PAR09) + AllTrim(MV_PAR10)
dDemiDe  := MV_PAR11
dDemiAte := MV_PAR12
   
Private nTipoRel := MV_PAR13 // 1= impressao Grafica; 2= Impressao Zebrada
Private nVerbRes := MV_PAR14 // Somar verbas da Rescisao; 1=Sim; 2=Nao

//��������������������������������Ŀ
//� Objetos p/ Impresssao Grafica  �
//����������������������������������
Private cFonte	:= "Arial"
Private nTamFon	:= 09   //10
Private oFont10 := TFont():New( cFonte, nTamFon, nTamFon, , .F., 100, , 100, , , .F. )

//��������������������������������������������������������������Ŀ
//�                                                              �
//����������������������������������������������������������������
fTransVerba()

//��������������������������������������������������������������Ŀ
//� Inicializa Impressao                                         �
//����������������������������������������������������������������
If ! fInicia(cString)
	Return
Endif     

If nTipoRel = 1
	lFirst := .T.
	oPrint := TMSPrinter():New( STR0001 )
	oPrint:SetPortrait()
Endif	

nLinha	:= 6

RptStatus({|| fSegDes()})// Substituido pelo assistente de conversao do AP5 IDE em 19/11/99 ==> 	RptStatus({|| Execute(fSegDes)})

If nTipoRel == 1
	oPrint:Preview()  		// Visualiza impressao grafica antes de imprimir
Endif                  

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FSEGDES   �Autor  �Microsiga           � Data �  10-01-02   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function fSegDes()

Local nCont := 0
Local nX
Local nTam	:= 0 

dbSelectArea('SRA')
dbSetOrder(nOrdem)
SetRegua(RecCount())
dbSeek(cFilDe + cMatDe,.T.)

Do While !Eof()	
	//+------------------------------------------- -----------------+
	//� Incrementa Regua de Processamento.                           �
	//+--------------------------------------------------------------+
	IncRegua()

	//+--------------------------------------------------------------+
	//� Processa Quebra de Filial.                                   �
	//+--------------------------------------------------------------+
	If SRA->RA_FILIAL != cFilAnte
		If	!fInfo(@aInfo,SRA->RA_FILIAL) .or. !( Fp_CodFol(@aCodFol,Sra->Ra_FILIAL) )
			dbSkip()
			Loop
		Endif		
		cFilAnte := SRA->RA_FILIAL		
	Endif		
	
	//+--------------------------------------------------------------+
	//� Cancela Impres�o ao se pressionar <ALT> + <A>.               �
	//+--------------------------------------------------------------+
	If lEnd
		@ pRow()+ 1, 00 PSAY STR0009 // ' CANCELADO PELO OPERADOR . . . '
		Exit
	EndIF
	
	//+--------------------------------------------------------------+
	//� Consiste Parametriza�o do Intervalo de Impress�o.           �
	//+--------------------------------------------------------------+
	If 	(SRA->RA_FILIAL < cFilDe)	.Or. (SRA->RA_FILIAL > cFilAte)	.Or.;
		(SRA->RA_MAT < cMatDe)		.Or. (SRA->RA_MAT > cMatAte)	.Or.;
		(SRA->RA_CC < cCcDe)		.Or. (SRA->RA_CC > cCCAte) 
        SRA->(dbSkip())
		Loop
	EndIf
	
	//+--------------------------------------------------------------+
	//� Pesquisando o Tipo de Rescisao ( Indenizada ou nao )         �
	//+--------------------------------------------------------------+
	cAlias := Alias()                                                            
	lAchouSrg := .F.
	dbSelectArea('SRG')     
	If dbSeek(SRA->RA_FILIAL+SRA->RA_MAT)
		While ! EOF() .And. SRA->RA_FILIAL+SRA->RA_MAT == SRG->RG_FILIAL+SRG->RG_MAT
			If (SRG->RG_DATADEM < dDemiDe) .Or. (SRG->RG_DATADEM > dDemiAte) .Or. SRG->RG_EFETIVA == "N"
				SRG->(dbSkip())
				Loop
			EndIf
			lAchouSrg := .T.
			Exit
		Enddo
	EndIf    

	//�����������������������������������������������������������������������Ŀ
	//�Caso nao encontre o funcionario no SRG, le o proximo funcionario no SRA�
	//�������������������������������������������������������������������������
	If ! lAchouSrg .OR.(SRG->RG_DATADEM < dDemiDe) .Or. (SRG->RG_DATADEM > dDemiAte) .Or. SRG->RG_EFETIVA == "N"
		dbSelectArea("SRA")
		dbSkip()
		Loop
	Endif
	

	//�����������������������������������������������������������������������Ŀ
	//�Consiste Filiais e Acessos                                             �
	//�������������������������������������������������������������������������
	IF !( SRA->RA_FILIAL $ fValidFil() .and. Eval( cAcessaSRA ) )
		dbSelectArea("SRA")
   		dbSkip()
  		Loop
	EndIF


	//--Carregar a descricao do tipo da rescisao		
	cIndeniz   := fPHist82(SRG->RG_FILIAL,'32',SRG->RG_TipoRes,32,1)
	
	//+--------------------------------------------------------------+
	//� Variaveis utilizadas na impressao.                           �
	//+--------------------------------------------------------------+
	cNome      := Left(SRA->RA_Nome,38)
	cMae       := Left(SRA->RA_Mae,38)     
	cEndCompl  := AllTrim(SRA->RA_Endereco) + '-' + AllTrim(SRA->RA_Bairro)   + '-' + AllTrim(SRA->RA_MUNICIP)   + ' ' + alltrim(SRA->RA_Complem) 
	//cEnd       := Left(cEndCompl, If( nTipoRel=1, 40, 38 )) 	
	//cCompl	   := If( nTipoRel=1, substr(cEndCompl,41,16) , substr(cEndCompl,39,14) )
	cEnd       := Left(cEndCompl, If( nTipoRel=1, 38, 38 )) //  
	//cCompl	   := If( nTipoRel=1, substr(cEndCompl,39,18) , substr(cEndCompl,39,14) ) //  
	cCompl	   := Substr(cEndCompl,39,14)
	If Len(cCompl) < 14 
		nTam	:= 14 - Len(cCompl)
		cCompl	:= cCompl+space(nTam)
	Endif 
	cCep       := Transform(Left(SRA->RA_Cep,8),'@R #####-###')
	//cCep       := Left(SRA->RA_Cep,1)+" "+Substr(SRA->RA_Cep,2,1)+" "+Substr(SRA->RA_Cep,3,1)+" "+Substr(SRA->RA_Cep,4,1)+" "+Substr(SRA->RA_Cep,5,1)+"  "+Substr(SRA->RA_Cep,6,1)+" "+Substr(SRA->RA_Cep,7,1)+" "+Substr(SRA->RA_Cep,8,1)
	cUF        := Left(SRA->RA_Estado,2)
	cFone      := Left(alltrim(SRA->RA_Telefon),10)
	cTpInsc    := If(aInfo[15]==1,'2','1') //-- 1=C.G.C. 2=C.E.I.
	cCgc       := Transform(Left(aInfo[8],14),'@R ')
	cCNAE      := Left(aInfo[16],5)
	cPis       := Left(SRA->RA_Pis,11)
	cCTPS      := Left(SRA->RA_NumCp,7)
	cCTSerie   := Right(Alltrim(SRA->RA_SerCp),3)
	cCTUF      := Left(SRA->RA_UFCP,2)
	cCBO       := fCodCBO(SRA->RA_FILIAL,SRA->RA_CODFUNC,dDtBase)
	cOcup      := DescFun(SRA->RA_CodFunc,SRA->RA_FILIAL)
	dAdmissao  := SRA->RA_Admissa
	dDemissao  := SRG->RG_DATADEM
	cSexo      := If(Sra->RA_Sexo=='M','1','2')
	dNascim    := SRA->RA_Nasc
	cHrSemana  := StrZero(Int(SRA->RA_HRSEMAN),2)
	cMat       := SRA->RA_MAT
	cFil       := SRA->RA_FILIAL
	cCC        := SRA->RA_CC
	cCpf	   := SRA->RA_CIC
	cNMeses    := fMesesTrab (SRA->RA_ADMISSA, SRG->RG_DATADEM)
	cNMeses	   := If (SRA->RA_MESESAN > 0,cNMeses + SRA->RA_MESESAN,CNMeses) 
	cNMeses    := If(cNMeses<=36,StrZero(cNMeses,2),'36')
	c6Salarios := If(Val(cNMeses)+SRA->RA_MesesAnt>=6,'1','2')
	
	//+--------------------------------------------------------------+
	//� Pesquisando o Tipo de Rescisao ( Indenizada ou nao )         �
	//+--------------------------------------------------------------+
	cAlias := Alias()
	dbSelectArea('SRG')
	If dbSeek(SRA->RA_FILIAL+SRA->RA_Mat,.F.)
		cIndeniz   := fPHist82(SRA->RA_FILIAL,'32',SRG->RG_TipoRes,32,1)
	Else
		cIndeniz   := ' '	
	EndIf
	dbSelectArea(cAlias)

	If cIndeniz == "I"
	   cIndeniz := "1"
	Else
	   cIndeniz := "2"
	Endif
	
	//
	cGrInstru := "1"
	If SRA->RA_GRINRAI == "10"
		cGrInstru := "1"
	Elseif SRA->RA_GRINRAI == "20"
		cGrInstru := "2"					
	Elseif SRA->RA_GRINRAI == "25"
		cGrInstru := "3"					
	Elseif SRA->RA_GRINRAI == "30"
		cGrInstru := "4"					
	Elseif SRA->RA_GRINRAI == "35"
		cGrInstru := "5"					
	Elseif SRA->RA_GRINRAI == "40"
		cGrInstru := "6"					
	Elseif SRA->RA_GRINRAI == "45"
		cGrInstru := "7"					
	Elseif SRA->RA_GRINRAI == "50"
		cGrInstru := "8"					
	Else
		cGrInstru := "9"					
	Endif

	//+--------------------------------------------------------------+
	//� Pesquisando os Tres Ultimos Salarios ( Datas e Valores )     �
	//+--------------------------------------------------------------+	
	cTipo   	:= "A"
	nSalMes		:= 0				   				//--  Incluso verbas que incorporam  ao salario 
	nVAlUlt 	:= nValPen		:= nValant		:=0
	NValUltSal	:= nValPenSal	:= nValAntSal	:=0
	dDTUltSal 	:= dDemissao						//-- Data do Ultimo Salario 

	//-- Data do Penultimo Salario.
	dDTPenSal := If(Month(dDemissao)-1 != 0, CtoD('01/' +StrZero(Month(dDemissao)-1,2)+'/'+Right(StrZero(Year(dDemissao),4),2)),CtoD('01/12/'+Right(StrZero(Year(dDemissao)-1,4),2)) )
	If MesAno(dDtPenSal) < MesAno(dAdmissao)
		dDTPenSal 	:= CTOD("  /  /  ")
 		nValPenSal 	:= 0.00
    Endif

	//-- Data do Antepenultimo Salario.	
	dDTAntSal := If(Month(dDtPenSal)-1 != 0,CtoD('01/'+StrZero(Month(dDtPenSal)-1,2)+'/'+Right(StrZero(Year(dDtPenSal),4),2)),CtoD('01/12/'+Right(StrZero(Year(dDtPenSal)-1,4),2)) )	
	If MesAno(dDtAntSal) < MesAno(dAdmissao)
		dDTAntSal 	:= CTOD("  /  /  ")
		nValAntSal 	:= 0.00
    Endif
	
	/*
	�����������������������������������������������������������������������Ŀ
	�Busca Salario ( + verba incorporada)do Movto Acumulado                 �  
	�Somar verbas informadas nos parametros                                 �
	�������������������������������������������������������������������������
	*/
	//fSalario(@nSalario,@nSalHora,@nSalDia,@nSalMes,cTipo)
	nSalMes		:= SRG->RG_SALMES   				//--  Incluso verbas que incorporam  ao salario 
	nValUltSal 	:= nSalMes
		
	fSomaSrr(StrZero(Year(dDTUltSal),4), StrZero(Month(dDTUltSal),2), cVerbas, @nValUlt)
    //--Penultimo 
	If !Empty(dDTPenSal)              
		nValPen := fBuscaAcm(cVerbas + acodfol[318,1]  ,,dDTPenSal,dDTPenSal,"V")	//-- Salario do mes + verbas que incorporaram  ao salario
		//--Pesquisa no movimento mensal quando o mes corrente estiver aberto
		//--e nao encontrar salario nos acumulados anuais.
		If nValPen == 0 .And. MesAno(dDTPenSal) == SuperGetMv("MV_FOLMES")
			If SRC->(Dbseek(SRA->(RA_FILIAL+RA_MAT)))
				While !SRC->(eof()) .And. SRA->(RA_FILIAL+RA_MAT) == SRC->(RC_FILIAL+RC_MAT)
					If SRC->RC_PD $cVerbas + acodfol[318,1]
						nValPen += SRC->RC_VALOR
					Endif
					SRC->(dbskip())
				Enddo
			Endif
		Endif
	Endif
	//--Antepenultimo
	If !Empty(dDTAntSal)
		nValAnt := fBuscaAcm(cVerbas + acodfol[318,1], NIL, dDTAntSal, dDTAntSal, "V") 	//-- Salario do mes + verbas que incorporaram  ao salario 
	Endif
	
	//--Somar verbas informardas aos salarios
	nValUltSal += If( nVerbRes == 1, nValUlt, 0 )
	nValPenSal += nValPen
	nValAntSal += nValAnt

	//+--------------------------------------------------------------+
	//�** Inicio da Impressao do Requerimento de Seguro-Desemprego **�
	//+--------------------------------------------------------------+	
	For Nx := 1 to nVias
		If nCont >= 2
			SetPrc(0,0)
			nLinha	:= 10
		Else
			nCont:= nCont + 1
		Endif

		If nTipoRel == 1
			fImpSegGraf(Nx)
		Else
			fImpSeg()
		EndIf			
			
		If aReturn[5] != 1
			If lFirst  
				fInicia(cString)
				nLinha	:= 10
				Pergunte("GPR30A",.T.)                 
				lFirst	:= If(MV_PAR01 = 1 ,.F. , .T. )    //  Impressao Correta ? Sim/Nao 
				If lFirst == .T.       						// Se impressao esta incorreta, zera contador para imprimir o numero de vias correto
					nx := 0 
					Loop 
				EndIf
			EndIf    
    	Endif
	Next Nx

	//+--------------------------------------------------------------+
	//�** Final  da Impressao do Requerimento de Seguro-Desemprego **�
	//+--------------------------------------------------------------+
	dbSelectArea("SRA")
	dbSkip()	
EndDo	

//+--------------------------------------------------------------+
//� Termino do Relatorio.                                        �
//+--------------------------------------------------------------+
dbSelectArea( 'SRA' )
RetIndex('SRA')
dbSetOrder(1)   
dbGoTop()
Set Device To Screen

If aReturn[5] == 1 .And. nTipoRel != 1
	Set Printer To
	dbCommitAll()
	OurSpool(WnRel)
Endif

MS_Flush()

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fImpSeg   �Autor  �Microsiga           � Data �  10-01-02   ���
�������������������������������������������������������������������������͹��
���Desc.     � Impressao do Requerimento de Seguro-Desemprego			  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function fImpSeg()
Local nColIni	:= 08
//+--------------------------------------------------------------+
//�** Inicio da Impressao do Requerimento de Seguro-Desemprego **�
//+--------------------------------------------------------------+
@ nLinha, nColIni PSAY  fPluSpace( cNome ) 
nLinha	+= 3 
@ nLinha, nColIni PSAY  fPluSpace( cMae )
nLinha	+= 3 
@ nLinha, nColIni PSAY fPluSpace( cEnd )
nLinha	+= 3
@ nLinha, nColini      PSAY fPluSpace( cCompl )

@ nLinha, nColIni+ 30  PSAY fPluSpace( cCep )
@ nLinha, nColIni+ 50  PSAY fPluSpace( cUF )
@ nLinha, nColIni+ 56  PSAY fPluSpace( cFone )
nLinha	+= 3 
@ nLinha, nColIni      PSAY fPluSpace( cPIS )
@ nLinha, nColIni+ 26  PSAY fPluSpace( cCTPS ) 
@ nLinha, nColIni+ 40  PSAY fPluSpace( cCTSerie )
@ nLinha, nColIni+ 46  PSAY fPluSpace( cCTUF )
@ nLinha, nColIni+ 54  PSAY fPluSpace( cCPF )
nLinha	+= 3
@ nLinha, nColIni+ 08  PSAY fPluSpace( cTpInsc )
@ nLinha, nColIni+ 13  PSAY fPluSpace( cCgc )
@ nLinha, nColIni+ 44  PSAY fPluSpace( cCNAE )
nLinha	+= 3
@ nLinha, nColIni      PSAY fPluSpace( cCBO )
@ nLinha, nColIni+ 14  PSAY cOcup 
nLinha	+= 6
@ nLinha, nColIni     PSAY fPluSpace( StrZero(Day(dAdmissao),2) ) + fPluSpace( StrZero(Month(dAdmissao),2) )+ fPluSpace( Right(StrZero(Year(dAdmissao),4),2))
@ nLinha, nColIni+ 15 PSAY fPluSpace( StrZero(Day(dDemissao),2) ) + fPluSpace( StrZero(Month(dDemissao),2) )+ fPluSpace( Right(StrZero(Year(dDemissao),4),2))
@ nLinha, nColIni+ 38 PSAY fPluSpace( cSexo )
@ nLinha, nColIni+ 50 PSAY fPluSpace( cGrInstru )
@ nLinha, nColIni+ 55 PSAY fPluSpace( StrZero(Day(dNascim),2) )+ fPluSpace( StrZero(Month(dNascim),2)) + fPluSpace( Right(StrZero(Year(dNascim),4),2))
@ nLinha, nColIni+ 70 PSAY fPluSpace( cHrSemana )
nLinha	+= 3
@ nLinha, nColIni     PSAY fPluSpace( StrZero(Month(dDtAntSal),2))
@ nLinha, nColIni+ 05 PSAY fPluSpace( Transform(nValAntSal*100,'@E 9999999999' ))
@ nLinha, nColIni+ 25 PSAY fPluSpace( StrZero(Month(dDtPenSal),2) )
@ nLinha, nColIni+ 30 PSAY fPluSpace( Transform(nValPenSal*100,'@E 9999999999'))
@ nLinha, nColIni+ 51 PSAY fPluSpace( StrZero(Month(dDtUltSal),2) )
@ nLinha, nColIni+ 56 PSAY fPluSpace( Transform(nValUltSal*100,'@E 9999999999'))
nLinha	+= 3
@ nLinha, nColIni     PSAY fPluSpace( Transform( ( nValAntSal+nValPenSal+nValUltSal) *100,'@E 9999999999'))
@ nLinha, nColIni+ 72 PSAY fPluSpace( cNMeses  )
nLinha	+= 3
@ nLinha, nColIni+ 20 PSAY fPluSpace( c6Salarios)
@ nLinha, nColIni+ 39 PSAY fPluSpace( cIndeniz  )
nLinha	+= 15
@ nLinha, nColIni PSAY fPluSpace( cPis )
nLinha	+= 3
@ nLinha, nColIni PSAY fPluSpace( cNome )
nLinha	+= 09
@ nLinha, 00 PSAY ' '

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fSomaSRR  �Autor  �Microsiga           � Data �  10-01-02   ���
�������������������������������������������������������������������������͹��
���Desc.     � Soma Verbas do arquivo SRR								  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Parametros� CAno 	-Ano do ultimo salario                            ���
���          � CMes 	-Mes do ultimo salario                            ���
���          � CVerbas  -Verbas a serem somada                            ���
���          � nValor   -Valor das verbas                                 ���
�������������������������������������������������������������������������͹��
���Uso       � AP6                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
static Function fSomaSrr(cAno, cMes, cVerbas, nValor)

Local lRet    := .T.
Local cPesq   := ''
Local cFilSRR := xFilial('SRR', SRA->RA_FILIAL)
Local dDtGerar:= ctod('  /  /  ')	

//-- Reinicializa Variaveis
cAno    := If(Empty(cAno), StrZero(Year(dDTUltSal),4), cAno)
cMes    := If(Empty(cMes), StrZero(Month(dDTUltSal),2), cMes)
cVerbas := If(Empty(cVerbas), '', AllTrim(cVerbas))
nValor  := If(Empty(nValUlt) .OR. ValType(nValUlt) != 'N', 0, nValUlt)

Begin Sequence

	If Empty(cVerbas) .Or. Len(cVerbas) < 3 .Or. ;
		!SRR->(dbSeek((cPesq := cFilSRR + SRA->RA_MAT +'R'+ cAno + cMes), .T.))
		lRet := .F.
		Break
	EndIf


	dbSelectarea('SRG')
	If dbSeek(SRA->RA_FILIAL+SRA->RA_Mat,.F.)
		dDtGerar := SRG->RG_DTGERAR
		dbSelectArea("SRR")
		dbSeek(SRA->RA_FILIAL+SRA->RA_Mat,.F.)
		While !EOF() .And. RR_FILIAL+RR_MAT == cFil+cMat
			If dDtGerar == SRR->RR_DATA
				If SRR->RR_PD $ cVerbas
					If PosSrv(SRR->RR_PD,SRR->RR_FILIAL,"RV_TIPOCOD") $ "1*3"
				  		nValor += SRR->RR_VALOR
					Else
						nValor -= SRR->RR_VALOR
					EndIf
				Endif
			EndIf
			SRR->(DbSkip())
		Enddo	
	EndIf

	If nValor == 0
		lRet := .F.
		Break
	EndIf

End Sequence
dbSelectArea('SRA')
Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fInicia   �Autor  �R.H.Natie           � Data �  11/12/01   ���
�������������������������������������������������������������������������͹��
���Desc.     �Inicializa Impressao                                        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function fInicia(cString)

//--Lendo os Driver's de Impressora e gravando no Array--// 
MS_Flush()
aDriver := ReadDriver()
If nLastKey == 27
	Return .F.
Endif
SetDefault(aReturn,cString)
If nLastKey == 27
	Return  .F. 
Endif
Return .T.

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fTransVerba�Autor �R.H.                � Data �  17/08/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function  fTransVerba()
Local cPD	:= ""
Local nX	:= 0

For nX := 1 to Len(cVerbas) step 3 
	cPD += Subs(cVerbas,nX,3)
	cPD += "/" 
Next nX

cVerbas:= cPD

Return( )
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fPluSpace �Autor  �R.H.                � Data �  14/10/04   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Generico                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function  fPluSpace( cDet )
Local cDetF :=""
Local nX	:= 0

For nX := 1 to Len(cDet)
	cDetF += Subs(cDet,nX,1) + space(1)
Next nX    

Return(cDetF)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fImpSegGraf �Autor  �Microsiga           � Data � 10-01-09  ���
�������������������������������������������������������������������������͹��
���Desc.     � Impressao GRAFICA do Requerimento de Seguro-Desemprego     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP8                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function fImpSegGraf( nNumVias )

_cPerg := "_LCSEG"
_ValPergSeg()
Pergunte(_cPerg,.T.)

nLinha	:= mv_par01 // 212
nColun	:= mv_par02 // 162
nTresSal	:= 0
cDtAdmis	:= ""
cDtDemis	:= ""
cDtNasci	:= ""

oPrint:StartPage() //Inicia uma nova pagina
                  
nLinha += 75 //  
fIncSpace( cNome, nlinha, nColun )	//Nome

nLinha += 150
fIncSpace( cMae, nlinha, nColun )	//Nome da Mae

nLinha += 150 // 160 //  
fIncSpace( cEnd, nlinha, nColun )	//Endereco

nLinha += 150 // 160 //  
fIncSpace( cCompl			, nLinha, nColun 		) //Complemento endereco
//fIncSpace( Subst(cCep,1,5)	, nLinha, nColun + 0940	) //CEP
fIncSpace( Subst(cCep,1,5)	, nLinha, nColun + 0910	) //CEP //  
fIncSpace( Subst(cCep,7,3)	, nLinha, nColun + 1265	) //CEP
//fIncSpace( cUF				, nLinha, nColun + 1480	) //UF
fIncSpace( cUF				, nLinha, nColun + 1500	) //UF //  
//fIncSpace( cFone			, nLinha, nColun + 1650	) //Telefone
fIncSpace( cFone			, nLinha, nColun + 1675	) //Telefone //  

nLinha += 160 // 150 // 31/07/2013
fIncSpace( cPIS		, nLinha, nColun + 0003 ) //Pis
fIncSpace( cCTPS	, nLinha, nColun + 0770 ) //CTPS
//fIncSpace( cCTSerie	, nLinha, nColun + 1160 ) //Serie CTPS
fIncSpace( cCTSerie	, nLinha, nColun + 1175 ) //Serie CTPS //  
//fIncSpace( cCTUF	, nLinha, nColun + 1320 ) //UF CTPS
fIncSpace( cCTUF	, nLinha, nColun + 1350 ) //UF CTPS //  
//fIncSpace( cCPF		, nLinha, nColun + 1590 ) //CPF
fIncSpace( cCPF		, nLinha, nColun + 1615 ) //CPF //  

nLinha += 155 // 150 // 199  // 31/07/2013
//fIncSpace( cTpInsc	, nLinha, nColun + 0280 ) //Tipo Inscricao
fIncSpace( cTpInsc	, nLinha, nColun + 0235 ) //Tipo Inscricao
fIncSpace( cCgc		, nLinha, nColun + 0385 ) //CNPJ/CEI
//fIncSpace( cCNAE	, nLinha, nColun + 1272 ) //Atividade economica
fIncSpace( cCNAE	, nLinha, nColun + 1315 ) //Atividade economica //  

nLinha += 145
//fIncSpace( Subst(cCBO,1,5)	, nLinha, nColun + 0015 ) //CBO
fIncSpace( Subst(cCBO,1,5)	, nLinha, nColun - 0005 ) //CBO //  
//fIncSpace( Subst(cCBO,6,1)	, nLinha, nColun + 0335 ) //CBO Digito
fIncSpace( Subst(cCBO,6,1)	, nLinha, nColun + 0311 ) //CBO Digito //  
//fIncSpace( cOcup			, nLinha, nColun + 0400 ) //Ocupacao
fIncSpace( cOcup			, nLinha, nColun + 0420 ) //Ocupacao //  

cDtAdmis := StrZero(Day(dAdmissao),2) + StrZero(Month(dAdmissao),2) + Right(StrZero(Year(dAdmissao),4),2)
cDtDemis := StrZero(Day(dDemissao),2) + StrZero(Month(dDemissao),2) + Right(StrZero(Year(dDemissao),4),2)
cDtNasci := StrZero(Day(dNascim),2)   + StrZero(Month(dNascim),2)   + Right(StrZero(Year(dNascim),4),2)

nLinha += 298 // 225  
fIncSpace( cDtAdmis		,nLinha, nColun + 0005 ) //Data admissao
//fIncSpace( cDtDemis		,nLinha, nColun + 0448 ) //Data dispensa
fIncSpace( cDtDemis		,nLinha, nColun + 0440 ) //Data dispensa // 31/07/2013
//fIncSpace( cSexo		,nLinha, nColun + 1123 ) //Sexo //  
fIncSpace( cSexo		,nLinha, nColun + 1108 ) //Sexo //   // 31/07/2013
//fIncSpace( cGrInstru	,nLinha, nColun + 1480 ) //Grau de instrucao //  
fIncSpace( cGrInstru	,nLinha, nColun + 1455 ) //Grau de instrucao //  // 31/07/2013
//fIncSpace( cDtNasci		,nLinha, nColun + 1638 ) //Data nascimento //  
fIncSpace( cDtNasci		,nLinha, nColun + 1613 ) //Data nascimento //  // 31/07/2013
//fIncSpace( cHrSemana	,nLinha, nColun + 2088 ) //Horas trabalhadas por semana //  
fIncSpace( cHrSemana	,nLinha, nColun + 2063 ) //Horas trabalhadas por semana //   // 31/07/2013

nLinha += 155
fIncSpace( StrZero( Month( dDtAntSal ), 2 )					, nLinha, nColun + 0005	)	//Mes antepenultimo salario //  
//fIncSpace( Transform( nValAntSal * 100, '@E 9999999999')	, nLinha, nColun + 0142	)	//Antepenultimo salario //  
fIncSpace( Transform( nValAntSal * 100, '@E 9999999999')	, nLinha, nColun + 0128	)	//Antepenultimo salario //   // 31/07/2013
//fIncSpace( StrZero( Month( dDtPenSal ), 2 )					, nLinha, nColun + 0765	)	//Mes penultimo salario //  
fIncSpace( StrZero( Month( dDtPenSal ), 2 )					, nLinha, nColun + 0755	)	//Mes penultimo salario //  // 31/07/2013
//fIncSpace( Transform( nValPenSal * 100, '@E 9999999999')	, nLinha, nColun + 0905	)	//Penultimo salario
fIncSpace( Transform( nValPenSal * 100, '@E 9999999999')	, nLinha, nColun + 0885	)	//Penultimo salario  // 31/07/2013
//fIncSpace( StrZero( Month( dDtUltSal ), 2 )					, nLinha, nColun + 1528	)	//Mes ultimo salario //  
fIncSpace( StrZero( Month( dDtUltSal ), 2 )					, nLinha, nColun + 1508	)	//Mes ultimo salario //  // 31/07/2013
//fIncSpace( Transform( nValUltSal * 100, '@E 9999999999')	, nLinha, nColun + 1675	)	//Ultimo salario //  
fIncSpace( Transform( nValUltSal * 100, '@E 9999999999')	, nLinha, nColun + 1655	)	//Ultimo salario //  // 31/07/2013

nTresSal := Transform( ( nValAntSal+nValPenSal+nValUltSal ) *100,'@E 9999999999') 

nLinha += 155
//fIncSpace( nTresSal	, nLinha, nColun + 0000 ) //Soma 3 ultimos salarios //  
fIncSpace( nTresSal	, nLinha, nColun - 10 ) //Soma 3 ultimos salarios //  // 31/07/2013
//fIncSpace( cNMeses	, nLinha, nColun + 2150 ) //Qtd meses com vinculo ultimos 36 meses //  
fIncSpace( cNMeses	, nLinha, nColun + 2125 ) //Qtd meses com vinculo ultimos 36 meses //  // 31/07/2013

nLinha += 145 // 135  
//fIncSpace( c6Salarios	, nLinha, nColun + 0588 ) //Recebeu ultimos 6 meses //  
fIncSpace( c6Salarios	, nLinha, nColun + 0563 ) //Recebeu ultimos 6 meses //  // 31/07/2013
//fIncSpace( cIndeniz		, nLinha, nColun + 1162 ) //Aviso previo indenizado
fIncSpace( cIndeniz		, nLinha, nColun + 1167 ) //Aviso previo indenizado // 31/07/2013

nLinha += 825  

If nNumVias == 2      
	fIncSpace( cPis, nLinha, nColun - 50 ) //Pis 2o. Via

	nLinha += 100  
	fIncSpace( cNome, nLinha, nColun - 50 ) //Nome 2o. Via
EndIf

oPrint:EndPage() //Finaliza a pagina

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fIncSpace �Autor  �Microsiga           � Data �  10-01-09   ���
�������������������������������������������������������������������������͹��
���Desc.     � Tratamento para impressao no formato grafico.			     ���
���          � Foi definido o tamanho FIXO na var nColImpr de 55 para	  ���
���          � determinar a distancia entre cada quadrado do formulario	  ���
���          � destinado para a impressao dos dados. CUIDADO AO ALTERAR	  ���
���          � ESTA VARIAVEL, POIS PODERA DESCONFIGURAR TODO O FORMULARIO.���
�������������������������������������������������������������������������͹��
���Uso       � AP8                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function fIncSpace( cTexto, nlin, nCol )
Local nPos 		:= 1
Local i 		:= 1
//Local nColImpr	:= 60.5 // 55 //  
Local nColImpr	:= 60

For i := 1 To Len( cTexto )              
                            
	If Upper( SubStr( cTexto, nPos, 1 ) ) <> " "
		oPrint:say( nLin, nCol, SubStr( cTexto, nPos, 1 ),  oFont10, 100 ) //Impressao por Caracter
	EndIf

	nCol 	+= nColImpr

	nPos++
Next i    

Return( )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AjustaSX  �Autor  �Microsiga           � Data �  10-01-09   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ajusta dicionario de dados                                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP8                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function AjustaSX()

Local aArea     := getArea()
Local aRegs     := {}
Local cPerg		:= "_SEGDES"
Local cHelp13 	:= "" 
Local cHelp14 	:= "" 

Local aHelpPor  := {}
Local aHelpSpa  := {}
Local aHelpEng  := {}
                                
cHelp13 	:= ".GPRPPP19." 
cHelp14 	:= ".SEGDES01."

//Atualiza Help do Somar Verbas Rescisao
AADD(aHelpPor, 'Somar as verbas de rescis�o no valor')
AADD(aHelpPor, 'do �ltimo Sal�rio ?'                 )

AADD(aHelpSpa, '�Sumar los conceptos de rescision al')
AADD(aHelpSpa, 'valor del ultimo Sueldo?'            )

AADD(aHelpEng, 'Add the types of funds in the amount')
AADD(aHelpEng, 'of last salary'                      )

PutSX1Help("P"+cHelp14, aHelpPor, aHelpSpa, aHelpEng )

/*��������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ŀ
  �        Grupo  Ordem Pergunta Portugues            Pergunta Espanhol            Pergunta Ingles            Variavel      Tipo  	Tamanho Decimal Presel  GSC   	Valid       	                      Var01      	Def01       DefSPA1          	DefEng1      Cnt01    Var02  	Def02   	         DefSpa2              DefEng2	   	      Cnt02     Var03 	Def03    	DefSpa3   	DefEng3  		Cnt03  	Var04  	Def04     	DefSpa4    	DefEng4  	Cnt04  	Var05  	Def05       DefSpa5		DefEng5   	Cnt05  	XF3  	GrgSxg  cPyme	aHelpPor	aHelpEng	aHelpSpa    cHelp    �
  ����������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������*/
Aadd(aRegs,{cPerg,"13","Tipo de Impressao ?"         ,"�Tipo de Impressao ?"      , "Tipo de Impressao ?   " , "mv_chd"    ,"N"    ,1		,0		,2		,"C"	,""									 ,"MV_PAR13"   ,"Grafico"	,"Grafico"			,"Grafico"	,""		,""			,"Zebrado"			,"Zebrado"			,"Zebrado"			,""			,""		,""			,""			,""				,""		,""		,""			,""			,""			,""		,""		,""			,""			,""			,""		,""		,""		,"S"	, 			, 			, 			,cHelp13})
aAdd(aRegs,{cPerg,"14","Somar verbas Resc ?"         ,"�Somar verbas Resc ?"      , "Somar verbas Resc ?   " , "mv_che"    ,"N"	,1		,0		,0		,"C"	,""	                     	         ,"MV_PAR14"   ,"Sim "		,"Si"		     	,"Yes "		,""		,""			,"Nao" 	            ,"No"		        ,"No"			    ,""			,""		,""			,""			,""				,""		,""		,""			,""			,""			,""		,""		,""			,""			,""			,""		,""		,"" 	,"S"	,aHelpPor	,aHelpSpa	,aHelpEng   ,cHelp14})

ValidPerg( aRegs, cPerg, .T. )

RestArea( aArea )

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �ValidPerg  �Autor� Cesar Padovani           |Data�24/08/2005���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Verifica as perguntas incluindo-as caso nao existam        ���
�������������������������������������������������������������������������Ĵ��
���Uso       �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function _ValPergSeg()

DbSelectArea( "SX1" )
DbSetOrder(1)

_cPerg := PADR(_cPerg,10)
aRegs:={}
aAdd(aRegs,{_cPerg,"01","Linha ? ","","","mv_ch1","N",04,0,1,"G","","mv_par01","","","","212","","","","","","","","","","","","","","","","","","","","","","S","","","",""})
aAdd(aRegs,{_cPerg,"02","Coluna ?","","","mv_ch2","N",04,0,1,"G","","mv_par02","","","","162","","","","","","","","","","","","","","","","","","","","","","S","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(_cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			FieldPut(j,aRegs[i,j])
		Next
		MsUnlock()
		dbCommit()
	EndIf
Next

Return
