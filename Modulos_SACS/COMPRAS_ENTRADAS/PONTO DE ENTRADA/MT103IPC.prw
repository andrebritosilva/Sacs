User Function MT103IPC
 Local _nItem := PARAMIXB[1]
 Local _nPosOBS := AsCan(aHeader,{|x|Alltrim(x[2])=="D1_OBS"})
 Local _nPosDes := AsCan(aHeader,{|x|Alltrim(x[2])=="D1_DESCR"})
 If _nPosDES > 0 .And. _nItem > 0
 	aCols[_nItem,_nPosDes] := SC7->C7_DESCRI
 	
 Endif
 If _nPosDES > 0 .And. _nItem > 0
 	aCols[_nItem,_nPosOBS] := SC7->C7_OBS
 	
 Endif

 Return 