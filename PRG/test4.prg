IF !USED("_PLAQUE") THEN
	OPENTABLE("PLAQUE", "", "_PLAQUE")
ENDIF

SELECT _PLAQUE
SET FILTER TO !INSLEEP
SetScrObj("INIT", "Immatriculation")
SET STEP ON 
SetScrObj("GROUP", "", )
=SetScrObj("W:VIEW:O=zoImmatriculation", "PLAQUE", "_PLAQUE", "!INSLEEP", "", 120, 140, 140 )
=SetScrObj("X:VIEW:O=zoImmatriculation", "PLAQUE", "_PLAQUE", "!INSLEEP", "", 120, 140, 140 )
=SetScrObj("Y:VIEW:O=zoImmatriculation", "PLAQUE", "_PLAQUE", "!INSLEEP", "", 120, 140, 140 )
SET STEP ON 

&&goScrObj[gnScrObj].zoImmatriculation.oViewGrid.Height = 20
&&goScrObj[gnScrObj].zoImmatriculation.oViewGrid.Width = 30
&&goScrObj[gnScrObj].zoImmatriculation.oViewGrid.zWidthMax = 30
&&goScrObj[gnScrObj].zoImmatriculation.oViewGrid.gridlinewidth = 1

SetScrObj( ":READ" )

CloseUsed("_PLAQUE")