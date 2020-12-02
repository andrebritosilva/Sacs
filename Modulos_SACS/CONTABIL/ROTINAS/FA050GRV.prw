#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'

User Function FA050GRV()

Local aArea      := GetArea()

Alert("Título incluso!")

RestArea( aArea )

Return
