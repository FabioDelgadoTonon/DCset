User function UFINA100(lInterface, aInfos, aLayOut, aSaidas, aVetores)

Local aNewVet := array(3)
Local aRotAuto := aClone(aVetores[1])

aNewVet[1] := {3}//nPosRotina
aNewVet[2] := aRotAuto

If aRotAuto[aScan(aRotAuto,{|aAux|alltrim(aAux[1]) == "E5_RECPAG"})][2] == "P"
    aNewVet[3] := {3} // nOpcAuto onde 3 = Pagar, 4 = Receber, inclusive a opção pode ser conforme a posição de aVetores
Else
    aNewVet[3] := {4}
EndIf

Return aClone(aNewVet)