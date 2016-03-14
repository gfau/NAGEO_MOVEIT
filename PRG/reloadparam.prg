SET STEP ON 
SAVEPARAM("PRESTA_WSPROCVERSION","109")

INFO(TRANSFORM(ReloadParam("PRESTA_WSPROCVERSION")))

&&INFO(GetParam("PRESTA_WSPROCVERSION",""))

&&Cette fonction va chercher la valeur d'un paramètre sur le disque pour la recharger en mémoire.
FUNCTION ReloadParam
	LPARAMETERS pcParamKey
	
	LOCAL lnOldSelect, lnRecn, lnTableId, lxParam 
	
	lnOldSelect = SELECT()
	lnRecno = RECNO() 
	
	&&On lit la valeur sur le disque
	lnTableid = GetTableId("INCODES")
	lxParam = goCache.IncodesGetFieldValue( "INCODES", pcParamKey, "VALA1", "" )
	
	&&On recherche son index dans la table mémoire gaparam.
	lnIndex	= ASCAN( gaParam, pcParamKey, 1, -1, 1, 15 ) && 15 : Case Insensitive; Return row number; Exact ON
	IF lnIndex = 0
		RETURN .F.
	ENDIF
	
 	&&On initialise la valeur dans le tableau mémoire
 	gaparam[lnIndex,2] = lxParam 
	
	SELECT(lnOldSelect)
	GOTO lnRecno
	
	RETURN .T.
	
ENDFUNC
