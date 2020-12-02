#Include "Rwmake.ch"
#Include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � F050MCP  �Autor  � Cesar Padovani     � Data �  22/08/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada para adicionar campos a serem editados na ���
���          � opcao Alterar da rotina FINA050                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������Ĵ��
��� ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ���
�������������������������������������������������������������������������Ĵ��
��� PROGRAMADOR  � DATA   � MOTIVO DA ALTERACAO                           ���
�������������������������������������������������������������������������Ĵ��
��� Cesar        �22/08/13� Solicitante: Genildo Silva - Domus Aurea      ���
��� Padovani     �        � Motivo: Incluir campo E2_CCD                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/ 
User Function F050MCP()

Local _aCampos := paramixb

aAdd(_aCampos,"E2_CCD") // Adiciona campo E2_CCD
aAdd(_aCampos,"E2_VENCTO") // Adiciona campo E2_VENCTO
aAdd(_aCampos,"E2_VENCREA") // Adiciona campo E2_VENCREA
aAdd(_aCampos,"E2_ACRESC") // Adiciona campo E2_ACRESC
aAdd(_aCampos,"E2_ITEMD")
aAdd(_aCampos,"E2_ITEMC")
aAdd(_aCampos,"E2_CCC")
aAdd(_aCampos,"E2_CCUSTO")

Return _aCampos