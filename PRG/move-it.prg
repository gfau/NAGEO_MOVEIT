&&vContratNouveau("", "WB00000001")

&&vContratNouveau("9782857072805","")
&&Pr�voir un clic droit sur le poids qui bouge qui renvoie la trame
&&Avertissement sonore quand on d�passe un certain nombre de kg
&&Utilisateur est celui de logistcs GCUserId

&&Entreprise c'est le dossier
&&un transporteur -> plusieurs camions
&&La plaque sera dans le dochead. PLAQUE DEF250 , libell� (Camion de jos�), Transporteur (Code et libell�) (cr�er la table)
&&une plaque a une TARE

*** Table plaque ***
&& PLAQUE | LIBELLE | TARE | TRANSPORTEUR 
********************

*** Table contrat ***
&& CODE C(20) | Libell� c(50) | Tonnage N(12.3) | Produit (ARTID)  | Client GROUPID | Prix U N(12.2)| Remise N(5.2) | INSLEEP
*********************

&&Bordereau Ext  = YOURREF
&&Pr�voir un bouton effacer pour supprimer un document
&&Entrepot = STKID par d�faut celui du journal
&&N� de lot, si on a la gestion des lots s�ries (comme dans un journal d'achat)
&&Remarque interne 		DOCHEAD.NOTE
&&Remarque borderau		DOCDET.ARTDESC

&&Brut - tare -> qty

&&Saisie Ordre
&&Plaque / Tiers / Contrat(du tiers) alors le produit est li� (produit pas modifiable), si pas de contrat alors choisir produit.



PRIVATE lcThirdid, lcThirdName, lcThirdGroup, scUtilisateur, scFilter, snWeight, scPesageJnl, scViewRecSource
STORE "" TO lcThirdid, lcThirdName, lcThirdGroup, scFilter, snWeight, scPesageJnl 
scUtilisateur = PADR("",50)
snWeight = 0

scPesageJnl = GetPesageJnl()

TRY

	IF !USED("DOCHEAD") THEN
		USE gcdatadir+"DOCHEAD" SHARED AGAIN IN 0
	ENDIF

	SELECT DOCHEAD
	SET FILTER TO JNL = scPesageJnl 

PRIVATE soMainform

	SetScrObj(":INIT","Move-It","","","","", "PesageKeyPress", "",200)
	*-*-*-*-*
	=SetScrObj(":BEGINGROUP")
		=SetScrObj(":BEGINGROUP")
			=SetScrObj(":VIEW:O=zoDocuments", "DOCHEAD", "VHEAD", "!EMPTY(PLAQUEID)", "JNL+STR(NUMBER,8)" )
			scViewRecSource = goScrObj[gnScrObj].zoDocuments.oviewgrid.recordsource
			goScrObj[gnScrObj].zoDocuments.oviewgrid.zwhen = goScrObj[gnScrObj].zoDocuments.oviewgrid.zwhen +" AND RefreshMainGrid()"
			
		=SetScrObj( ":ENDGROUP" )
		=SetScrObj("R_:BEGINGROUP")
			=SetScrObj(":BEGINGROUP")
*				=SetScrObj( "C:SAY", "")
				=GetField( "_C:GET:O=loWeight", "", "snWeight",	"99999999.99", ".T.", ".F." )
				=SetScrObj("LASTOBJECT", "FORECOLOR", RGB(0,255,100))
				=SetScrObj("LASTOBJECT", "BACKCOLOR", RGB(0,0,0))
				=SetScrObj("LASTOBJECT", "WIDTH", 70)
				=SetScrObj("LASTOBJECT", "HEIGHT", 8)
				=SetScrObj("LASTOBJECT", "LEFT", 338)
				=SetScrObj("LASTOBJECT", "ALIGNMENT", 2)
				=SetScrObj("LASTOBJECT", "SELECTEDBACKCOLOR", RGB(0,0,0))
				=SetScrObj("LASTOBJECT", "SELECTEDFORECOLOR", RGB(0,0,0))
				=SetScrObj("LASTOBJECT", "DISABLEDBACKCOLOR", RGB(0,0,0))
				=SetScrObj("LASTOBJECT", "DISABLEDFORECOLOR", RGB(87,113,92))
				=SetScrObj("LASTOBJECT", "BORDERCOLOR", RGB(0,0,0))
				=SetScrObj("LASTOBJECT", "FONTSIZE", 48)
				=SetScrObj("LASTOBJECT", "FONTSHADOW", .T.)
				=SetScrObj("LASTOBJECT", "TABSTOP", .F.)
			=SetScrObj( ":ENDGROUP" )
			=SetScrObj(":BEGINGROUP", "Options Pesage")
				=SetScrObj(":GET:", "", "", "@*HN Peser"			, "", 1, 60, "vPeser()"				, ".T."  )
			=SetScrObj( ":ENDGROUP" )
			=SetScrObj(":BEGINGROUP", "Options Documents")
				=SetScrObj(":GET:", "", "", "@*HN Nouveau (F9)"	, 1, 60, 60, "vNouveau()"			, ".T."  )
				=SetScrObj("_:GET:", "", "", "@*HN Dupliquer"		, "", 1, 60, "vDupliquer()"			, ".T."  )
				=SetScrObj(":GET:", "", "", "@*HN Imprimer (F4)"	, "", 1, 60, "vImprimer()"			, ".T."  )
				=SetScrObj(":GET:", "", "", "@*HN Effacer (F12)"	, "", 1, 60, "vEffacer()"			, ".T."  )
				=SetScrObj("_:GET:", "", "", "@*HN Modifier (F5)"	, "", 1, 60, "vModifier()"			, ".T."  )
			=SetScrObj( ":ENDGROUP" )				
			=SetScrObj(":BEGINGROUP", "Options Diverses")				
				=SetScrObj(":GET:", "", "", "@*HN Contrats"		, "", 1, 60, "vContrats('', '', .F.)"			, ".T."  )
				=SetScrObj(":GET:", "", "", "@*HN Immatriculation"	, "", 1, 60, "vImmatriculation()"	, ".T."  )
			=SetScrObj( ":ENDGROUP" )
			=SetScrObj(":BEGINGROUP")
			
				=SetScrObj(":GET:", "Bordereau",  scViewRecSource+".JNL", "", VHEAD.JNL, 1, 60, ".F.", ".F."  )
				=GetField( "GET" , "Num�ro"		, scViewRecSource +".NUMBER" 		, "99999999", ".T.", ".F." )
				=GetField( "GET" , "Client"		, scViewRecSource +".THIRDNAME" 	, "*!", ".T.", ".F." )
				
				=GetField( "GET" , "Plaque du v�hicule"	, scViewRecSource +".PLAQUEID" , "", ".F.", ".F." )
				=GetField( "GET" , "Contrat"			, "gocache.docheadgetfieldvalue("+scViewRecSource+".jnl,"+scViewRecSource+".number,'CONTRATID'",'')" , "", ".F.", ".F." )
				=GetField( "GET" , "R�f�rence"			, scViewRecSource +".YOURREF" , "", ".F.", ".F." )
				
			=SetScrObj( ":ENDGROUP" )
		=SetScrObj( ":ENDGROUP" )
	=SetScrObj( ":ENDGROUP" )
	*-*-*-*-*
	InitFilter()

	&&Ajout du timer dans la page
	ADDPROPERTY(goScrObj[gnScrObj], "zoRefreshTimer", CREATEOBJECT("RefreshTimer", goScrObj[gnScrObj]))
	ADDPROPERTY(goScrObj[gnScrObj], "zoTimer", NULL)
	goScrObj[gnScrObj].zoTimer = CREATEOBJECT("WinTimer", goScrObj[gnScrObj].hWnd,1, goScrObj[gnScrObj].zoRefreshTimer)

	SetScrObj("READ:O")  
	RELEASE loWeight 
	
CATCH TO loError
	INFO(loError.MESSAGE + " (" + TRANSFORM(loError.LINENO) + ")")
ENDTRY	
*-----------------------------------------------------------------
FUNCTION RefreshMainGrid
*SET STEP ON

	SetScrObj("REFRESH")
	RETURN .T.
ENDFUNC
*-----------------------------------------------------------------
FUNCTION GetPesageJnl

	LOCAL lnOldSelect, lcJnl
	
	lnOldSelect = SELECT()
	
	IF !USED("CURJNL") THEN
		OPENTABLE("JNL", "JNL", "CURJNL")
	ENDIF
	
	SELECT CURJNL
	GO TOP
	DO WHILE !EOF()
	
		IF CURJNL.PESAGE THEN
			lcJnl = CURJNL.JNL
			CloseUsed("CURJNL")
			SELECT (lnOldSelect)
			RETURN lcJnl
		ENDIF
	
		SELECT CURJNL
		SKIP
	ENDDO
	CloseUsed("CURJNL")
	SELECT (lnOldSelect)
	RETURN ""
	
ENDFUNC
*-----------------------------------------------------------------                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
DEFINE CLASS RefreshTimer AS CUSTOM

	soScreen = NULL

	PROCEDURE INIT
		LPARAMETERS poScreen
		
		This.soScreen = poScreen
		
	ENDPROC
*-----------------------------------------------------------------
	PROCEDURE TimerAction
	
		LOCAL lnWeight 
		IF goScrObj[gnScrObj] = This.soScreen THEN
			lnWeight = This.GetWeight()
			This.soScreen.loWeight.value  = lnWeight 
		ENDIF
			
	ENDPROC
*-----------------------------------------------------------------	
	FUNCTION GetWeight
	
		LOCAL lnWeight 
		lnWeight = INT(RAND() * 100000)
		RETURN lnWeight 
	
	ENDFUNC
	
ENDDEFINE

*-----------------------------------------------------------------
PROCEDURE vImmatriculation
	LPARAMETERS plSelect


	PRIVATE scViewSelect
	scViewSelect = ""
	IF !USED("PLAQUE") THEN
		USE gcdatadir+"Plaque" SHARED AGAIN IN 0
	ENDIF
	
	SELECT PLAQUE

	SetScrObj("INIT", "Immatriculation", "", "", "", "", "", "", 150, 30)
		=SetScrObj(":VIEW:O=zoImmatriculation", "PLAQUE", "PLAQUEVIEW", "INSLEEP = .F.", "PLAQUEID" )
	SetScrObj("READ","vValidImmatriculation()","@* <A>;<D>;<O>")
	
	IF plSelect
		RETURN scViewSelect
	ELSE
		RETURN .T.
	ENDIF

ENDPROC

*-----------------------------------------------------------------
PROCEDURE vValidImmatriculation
	
	LOCAL lcCmd
	
	DO CASE
		CASE lnDo = 1 &&Mise � jour
			vImmatriculationNouveau()
			goScrObj[gnScrObj].zoImmatriculation.RefreshView()
			SetScrObj("REFRESH")
			RETURN .T.
		
		CASE lnDo = 2
			vImmatriculationSupprimer()
			
			goScrObj[gnScrObj].zoImmatriculation.RefreshView()
			SetScrObj("REFRESH")
			RETURN .T.
			
		CASE lnDo = 3 &&Quitter 
			lcCmd = "TRIM("+goScrObj[gnScrObj].zoImmatriculation.cviewname+".PLAQUEID)"
			scViewSelect = &lcCmd 
		
			DO CLEAR_READ
			RETURN .T.
	ENDCASE
			
	RETURN .T.
	
ENDPROC
*-----------------------------------------------------------------
FUNCTION vImmatriculationSupprimer

	IF YesNo("Etes-vous sur de vouloir supprimer cette immatriculation ?") 
		lcCmd = "REPLACE INSLEEP WITH .T. FOR TRIM(PLAQUEID) = TRIM("+goScrObj[gnScrObj].zoImmatriculation.cviewname+".PLAQUEID) IN PLAQUE"
		&lcCmd
		RETURN .T.
	ENDIF
	
	RETURN .F.


ENDFUNC
*-----------------------------------------------------------------
PROCEDURE vImmatriculationNouveau

	PRIVATE scLib, scNumero, scCodeTrans
	
	STORE PADR("",50) TO scLib, scNumero, scCodeTrans
	snTare = 0.0000
	SetScrObj("INIT", "Ajout d'une immatriculation")
	=GetField( "GET" , "Num�ro"			, "scNumero" 	, "*!", ".T.", ".T." )
	=GetField( "GET" , "Libell�"		, "scLib" 		, "*!", ".T.", ".T." )
	=GetField( "GET" , "Tare"			, "snTare" 		, "999999.99", ".T.", ".T." )
	=GetField( "GET" , "Transporteur"	, "scCodeTrans" 	, "*!", ".T.", ".T." )
	=SetScrObj("_:GET:", "", "", "@*HN ..."	, "", 1, 60, "vChoixTransporteur()"			, ".T."  )
	IF SetScrObj("READ") 
		vImmatriculationAjout()
	ENDIF 
	SetScrObj("REFRESH")
	RETURN .T.
	
ENDPROC
*-----------------------------------------------------------------
PROCEDURE vImmatriculationAjout

	LOCAL lnOldAlias
	lnOldAlias = SELECT()

	DO CASE
	
		CASE lnDo = 1
			IF !USED("_PLAQUE") THEN
				OPENTABLE("PLAQUE", "PLAQUEID", "_PLAQUE")
			ENDIF
			
			SELECT _PLAQUE
			SET ORDER TO PLAQUEID
			IF SEEK(PADR(scNumero,LEN(PLAQUEID))) THEN
				INFO("Ce num�ro de plaque existe d�j�, veuillez le modifier")
				RETURN .F.
			ENDIF
			
			SELECT _PLAQUE
			APPEND BLANK
			REPLACE PLAQUEID 		WITH scNumero
			REPLACE LIBELLE		WITH scLib
			REPLACE TARE		WITH snTare
			REPLACE CODETRANS 	WITH scCodeTrans
			RETURN .T.
			
		CASE lnDo = 2 &&Quitter 
			DO CLEAR_READ
			RETURN .T.
	ENDCASE
	
	SELECT (lnOldAlias)
			
	RETURN .T.

ENDPROC 
*-----------------------------------------------------------------
PROCEDURE vChoixTransporteur
	
	LOCAL lcCode
	
	scCodeTrans = ""
	IF !USED("_TRANSPORTEUR") THEN
		OPENTABLE("TRANSPORTEUR", "", "_TRANSPORTEUR")
	ENDIF
	SELECT _TRANSPORTEUR
	=SetScrObj("INIT", "Liste des transporteurs")
	=SetScrObj( "C0:BEGINGROUP" )
	=SetScrObj( ":WINLIST:O=zoTransporteur", "", "" , "UPPER($)", "", 35, 180, ".T." , ".T.", "_TRANSPORTEUR" )
	=SetScrObj( "WINCOL" , l("Code")			, 	"_TRANSPORTEUR.CODETRANS"			, 	20 )
	=SetScrObj( "WINCOL" , l("Libell�")			, 	"_TRANSPORTEUR.LIB"					, 	100 )
	=SetScrObj( ":ENDGROUP" )
	=SetScrObj( "_C0:BEGINGROUP" )
	=SetScrObj(":GET:", "", "", "@*HN Nouveau"		, 1, 60, 60, "vTransporteurNouveau()"		, ".T."  )
	=SetScrObj(":GET:", "", "", "@*HN Supprimer"	, 1, 60, 60, "vImmatriculationSupprimer()"		, ".T."  )
	=SetScrObj( ":ENDGROUP" )
	IF SetScrObj("READ") THEN
		scCodeTrans = _TRANSPORTEUR.CODETRANS
	ENDIF
	SetScrObj("REFRESH")
	RETURN .T.
	
	
ENDPROC
*-----------------------------------------------------------------
PROCEDURE vTransporteurNouveau

	PRIVATE scTransCode, scTransLib
	STORE PADR("",50) TO scTransCode, scTransLib
	
	=SetScrObj("INIT", "Ajout d'un transporteur")
	GetField( "GET" , "Code"			, "scTransCode" 	, "*!", ".T.", ".T." )
	GetField( "GET" , "Libell�"			, "scTransLib" 		, "*!", ".T.", ".T." )
	SetScrObj("READ","vTransporteurAjout()","@* <A>;<O>") 
	SetScrObj("REFRESH")
	
ENDPROC
*-----------------------------------------------------------------
PROCEDURE vTransporteurAjout

	DO CASE
	
		CASE lnDo = 1
			IF !USED("_TRANSPORTEUR") THEN
				OPENTABLE("TRANSPORTEUR", "CODETRANS", "_TRANSPORTEUR")
			ENDIF
			
			SELECT _TRANSPORTEUR
			SET ORDER TO CODETRANS
			IF SEEK(PADR(scTransCode,LEN(CODETRANS))) THEN
				INFO("Ce num�ro de transporteur existe d�j�, veuillez le modifier")
				RETURN .F.
			ENDIF
			
			SELECT _TRANSPORTEUR
			APPEND BLANK 
			REPLACE CODETRANS	WITH scTransCode
			REPLACE LIB 		WITH scTransLib
			SetScrObj("REFRESH")
			RETURN .T.
			
		CASE lnDo = 2 &&Quitter 
			DO CLEAR_READ
			RETURN .T.
	ENDCASE
			
	RETURN .T.

ENDPROC 

*-----------------------------------------------------------------
PROCEDURE vContrats
	LPARAMETERS pcArtId, pcGroupid, plSelect
	
	PRIVATE scGroupId , scArtId, scViewSelect
	LOCAL lcCmd
	scGroupId 	= pcGroupid
	scArtId 	= pcArtId
	scViewSelect = ""
	LOCAL lcFilter 
	
	IF !USED("CONTRAT") THEN
		USE gcdatadir+"CONTRAT" SHARED AGAIN IN 0
	ENDIF
	
	SetScrObj("INIT", "Contrat", "", "", "", "", "", "", 150, 30)
	=SetScrObj(":VIEW:O=zoContrats", "CONTRAT", "", "INSLEEP = .F.", "CODE" )

	=SetScrObj("READ","vValidContrat()","@* <A>;<D>;<O>") 
	
	IF plSelect
		RETURN scViewSelect

	ELSE
		RETURN .T.
	ENDIF

ENDPROC
*-----------------------------------------------------------------
PROCEDURE vValidContrat

	DO CASE
		CASE lnDo = 1 &&Mise � jour
			vContratNouveau(scArtId, scGroupId)
			goScrObj[gnScrObj].zoContrats.RefreshView()
			SetScrObj("REFRESH")
			RETURN .T.
		
		CASE lnDo = 2
			vContratSupprimer()
			goScrObj[gnScrObj].zoContrats.RefreshView()
			SetScrObj("REFRESH")
			RETURN .F.
			
		CASE lnDo = 3 &&Quitter 
			lcCmd = "TRIM("+goScrObj[gnScrObj].zoContrats.cviewname+".CODE)"
			scViewSelect = &lcCmd
			DO CLEAR_READ
			RETURN .T.
	ENDCASE
			
	RETURN .T.

ENDPROC

*-----------------------------------------------------------------
PROCEDURE vContratSupprimer
	
	IF YesNo("Etes-vous sur de vouloir supprimer ce contrat ?") 
		lcCmd = "REPLACE INSLEEP WITH .T. FOR TRIM(CODE) = TRIM("+goScrObj[gnScrObj].zoContrats.cviewname+".CODE) IN CONTRAT"
		&lcCmd
		RETURN .T.
	ENDIF
	SetScrObj("REFRESH")
	RETURN .F.
ENDPROC
*-----------------------------------------------------------------
PROCEDURE vContratNouveau
	PARAMETERS pcArtId, pcCustId

	PRIVATE scCode, scLib, snPu, snTonnage, scThirdName,  scArtid, scArtName, sdDateStart, sdDateEnd
	
	STORE PADR("",20) TO scCode, scArtid, scThirdid
	STORE PADR("",50) TO scLib, scThirdid, scArtName, scThirdName
	STORE CTOD("") TO sdDateStart, sdDateEnd
	STORE 0 TO snPu, snTonnage
	
	scCode = TTOC(DATETIME(),"YYYYMMYY")
	
	IF !EMPTY(pcArtID) THEN
		IF !USED("_ART") 
			OPENTABLE("ART","ARTID", "_ART")
		ENDIF
		SELECT _ART
		IF !SEEK(pcArtId)
			ERROR("Probl�me : L'article '" + _ART.ARTID + "' n'existe pas") 
			RETURN	
		ENDIF
		scArtid 	= _ART.ARTID
		scArtName	= _ART.NAME1
	ENDIF
	
	IF !EMPTY(pcCustId) THEN
		IF !USED("_CUST") 
			OPENTABLE("CUST","CUSTID", "_CUST")
		ENDIF
		SELECT _CUST
		IF !SEEK(pcCustId) 
			
			ERROR("Probl�me : L'article '" + _ART.ARTID + "' n'existe pas")
		ENDIF
		scCustId 		= _CUST.CUSTID	
		scThirdid 		= _CUST.GROUPID 
		scThirdName 	= _CUST.NAME
	ENDIF
	
	STORE 0 TO snPu, snTonnage
	
	SetScrObj("INIT", "Contrat")
	=GetField( "GET" , "Code"				, "scCode" 			, "*!", ".T.", ".T." )
	=GetField( "GET" , "Libelle"			, "scLib" 			, "*!", ".T.", ".T." )
	=GetField( IIF(EMPTY(pcCustId),"","D") + ":GET" 			, "Client"		, "scThirdid" 	, "*!", "ContratValidThird()", ".T." )
	=GetField( "_D:GET" , "Nom"				, "scThirdName" 	, "*!", ".T.", ".T." )
	=GetField( IIF(EMPTY(pcArtId),"","D") + ":GET" 				, "Article"		, "scArtid" 	, "*!", "ContratValidArt()", ".T." )
	=GetField( "_D:GET" , "Nom"				, "scArtName" 		, "*!", ".T.", ".T." )
	=GetField( "GET" 	, "Tonnage"			, "snTonnage" 		, "9999999.99", ".T.", ".T." )
	=GetField( "GET" 	, "Prix unitaire"	, "snPu" 			, "9999999.99", ".T.", ".T." )
	=GetField( "GET"	, "D�but :"			, "sdDateStart"		, "@D", ".T." )
	=GetField( "GET"	, "Fin :"			, "sdDateEnd"		, "@D", ".T." )
	&&SetScrObj("READ","vValidContratFiche()","@* <A>;<O>") 
	
	IF SetScrObj("READ") THEN
	
		IF EMPTY(scCode) THEN
			ERROR("Le code doit �tre remplit")
			RETURN .F.
		ENDIF
		
		IF !USED("CONTRAT") THEN
			USE gcdatadir+"CONTRAT" SHARED AGAIN IN 0
		ENDIF
		
		SELECT CONTRAT
		SET ORDER TO CODE
		IF SEEK(PADR(scCode,LEN(CODE))) THEN
			INFO("Ce code de contrat existe d�j�, veuillez le modifier")
			RETURN .F.
		ENDIF
		APPEND BLANK
		REPLACE CODE 	WITH scCode
		REPLACE ARTID 	WITH scArtid
		REPLACE THIRDID WITH scThirdid
		REPLACE TONNAGE WITH snTonnage
		REPLACE PU 		WITH snPu
		REPLACE C_START WITH sdDateStart
		REPLACE C_END	WITH sdDateEnd
		 
		SetScrObj("REFRESH")
		
	ENDIF

ENDPROC
*-----------------------------------------------------------------
FUNCTION vValidContratFiche

	DO CASE
		CASE lnDo = 1 &&Mise � jour
	
			IF EMPTY(scCode) THEN
				ERROR("Le code doit �tre remplit")
				RETURN .F.
			ENDIF
			
			IF !USED("CONTRAT") THEN
				USE gcdatadir+"CONTRAT" SHARED AGAIN IN 0
	*			OPENTABLE("CONTRAT", "CODE", "_CONTRAT")
			ENDIF
			
			SELECT CONTRAT
			SET ORDER TO CODE
			IF SEEK(PADR(scCode,LEN(CODE))) THEN
				INFO("Ce code de contrat existe d�j�, veuillez le modifier")
				RETURN .F.
			ENDIF

			APPEND BLANK
			REPLACE CODE 	WITH scCode
			REPLACE ARTID 	WITH scArtid
			REPLACE THIRDID WITH scThirdid
			REPLACE TONNAGE WITH snTonnage
			REPLACE PU 		WITH snPu
			REPLACE C_START WITH sdDateStart
			REPLACE C_END	WITH sdDateEnd
			 
			SetScrObj("REFRESH")
	
			DO CLEAR_READ
			RETURN .T.
			
		CASE lnDo = 2 &&Quitter 
			DO CLEAR_READ
			RETURN .T.
	ENDCASE
			
	RETURN .T.
ENDFUNC
*-----------------------------------------------------------------
FUNCTION ContratValidThird

	LOCAL lcCustId 
	
	lcCustId 	= GetCustIdFullText(scThirdid , "(Customer=.T.)" )
	scThirdid	= gocache.CustGetFieldValue(lcCustId , "GROUPID", "--")
	scThirdName	= gocache.CustGetFieldValue(lcCustId , "NAME", "--")
	SetScrObj("REFRESH")

ENDFUNC
*-----------------------------------------------------------------
FUNCTION ContratValidArt

	LOCAL lcArtId
	
	scArtid		= GetArtIdFullText(scArtid)
	scArtName	= gocache.ArtGetFieldValue(scArtid, "NAME1", "--")
	SetScrObj("REFRESH")

ENDFUNC

FUNCTION InitFilter
	
	IF !USED("__JNL") THEN
		OPENTABLE("JNL", "JNL", "__JNL")
	ENDIF
	
	SELECT __JNL
	GO TOP

	DO WHILE !EOF()
		IF C_PESAGE THEN
			IF EMPTY(scFilter) THEN
				scFilter = "JNL = '" + __JNL.JNL + "'"
			ELSE
				scFilter = scFilter + " OR JNL = '" + __JNL.JNL + "'"
			ENDIF
		ENDIF
		SKIP    
	ENDDO
	vDocRefresh()
	
ENDFUNC
*-----------------------------------------------------------------                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
FUNCTION vDocRefresh

	SELECT DOCHEAD
	SET FILTER TO &scFilter
	GO BOTTOM
	SetScrObj("REFRESH")
	RETURN .T.

ENDFUNC
*-----------------------------------------------------------------                                      
FUNCTION PesageKeyPress
	LPARAMETERS pcKey
	
	DO CASE
		CASE pcKey = "F4"
			vImprimer()
		CASE pcKey = "F5"
			vModifier()
		CASE pcKey = "F9"
			vNouveau()
		CASE pcKey = "F12"
			vEffacer()
		CASE pcKey = "END"
			vSauver()
	
	ENDCASE
	
ENDFUNC                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 

**** BOUTONS ****   
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
FUNCTION vNouveau

	LOCAL lnOldSelect, lcCustid, lcNumeroImmatriculation, lcContrat 
	PRIVATE scJnl, snNumberReturn, scThirdid, scThirdName 
	
	lnOldSelect = SELECT()
	scJnl = PADR("",8)
	scThirdid = PADR("",20)
	scThirdName = PADR("",20)
	snNumberReturn = 0
	
	&&Selection du journal
	IF !USED("CURJNL") THEN
		OPENTABLE("JNL", "JNL", "CURJNL")
	ENDIF
	
	&&On choisi un journal parmis ceux disponible
	SELECT JNL FROM CURJNL WHERE C_PESAGE ORDER BY JNL INTO ARRAY laJnl
	SetScrObj("INIT", "Choix du journal")
	=GetField( "_GET", "Journal"    , "scJnl"   , "@^ FROM laJnl", ".T.", "vDocRefresh()" )
	SetScrObj("READ")
	
	&&On ajoute une ent�te de document et on r�cup�re son num�ro.
	gocache.AddDocHead(scJnl,@snNumberReturn)
	
	&&On s�lectionne une plaque
	lcNumeroImmatriculation = vImmatriculation(.T.)
	
	&&On affecte le num�ro de plaque dans l'ent�te du document cr��
	gocache.DocheadPutFieldValue(scJnl, snNumberReturn, "PLAQUEID", lcNumeroImmatriculation)
	
	&&On s�lectionne un tiers
	SetScrObj("INIT", "Choix du tiers")
	=GetField( ":GET" 	, "Client"		, "scThirdid" 	, "*!", "ContratValidThird()", ".T." )
	=GetField( "_D:GET" , "Nom"			, "scThirdName" , "*!", ".T.", ".T." )
	SetScrObj("READ")
	
	lcCustid = gocache.CustGetIdFromGroup(scThirdid, .T.) && pcGroupid, plCustomer, plSupplyer, plUseInSleep
	
	&&On S�lectionne un contrat

	lcContrat = vContrats("", lcCustid, .T.)
	
	&&On affecte le num�ro de contrat dans l'ent�te du document cr��
	gocache.DocheadPutFieldValue(scJnl, snNumberReturn, "CONTRAT", lcContrat )
	
	&&On affecte le tiers choisi au document
	gocache.DocHeadSetThird(scJnl, snNumberReturn, lcCustid ) &&PARAMETERS pcJnl, pnNumber, pcThirdid, pcPersid, pdDate
	
	&&Ajout du docdet
	AddDocDet(scJnl, snNumberReturn)
	
	&&Assignation de l'article
	DocdetSetArt(CONTRAT.ARTID)
	
	&&On rafraichis la fen�tre afin de voir ce nouveau document
	SetScrObj("REFRESH")
	
	CloseUsed("CURJNL")
	
	SELECT(lnOldSelect)
	
ENDFUNC   
*-----------------------------------------------------------------
FUNCTION AddDocDet
	LPARAMETERS pcJnl, pnNumber 
	
	IF !USED("CURDOCDET") THEN
		OPENTABLE("DOCDET", "DOCDETID", "CURDOCDET")
	ENDIF
	
	SELECT CURDOCDET
	APPEND BLANK IN  CURDOCDET
	REPLACE JNL 				WITH pcJnl
	REPLACE NUMBER 				WITH pnNumber
	REPLACE DOCDETID		 	WITH GetNewID("CURDOCDET") IN CURDOCDET
	DO FlexDb_ModDate
	 
	RETURN .T.    

ENDFUNC
*-----------------------------------------------------------------
FUNCTION DocdetSetArt
	LPARAMETERS pcArtId
	
	IF !USED("CURART") THEN
		OPENTABLE("ART", "ARTID", "CURART")
	ENDIF
	
	SELECT CURART
	SET ORDER TO TAG ArtId
	IF !SEEK(pcArtId, "CURART", "ARTID") THEN
		RETURN 
	ENDIF
	
	SELECT CURDOCDET
	REPLACE ARTID WITH pcArtId
	
	DO FlexDb_ModDate
	
ENDFUNC
*-----------------------------------------------------------------
FUNCTION vDupliquer
	INFO("vDupliquer")
ENDFUNC

*-----------------------------------------------------------------

FUNCTION vVal
	
	IF BETWEEN(C_caract.val,C_caract.valmin,C_caract.valmax) OR C_caract.val = 0
		RETURN .T.
	ELSE
		STOP("Valeur hors range")
		RETURN .F.
	ENDIF
	

*-----------------------------------------------------------------
FUNCTION vPeserChange
	goscrobj[gnscrobj].zoNewTare.visible = (snPese == 1)
	RETURN .T.
*-----------------------------------------------------------------
FUNCTION vPeserTypeChange
	goscrobj[gnscrobj].zoGetTare.visible = (snPese == 1) AND (snType == 2)  
	RETURN .T.
*-----------------------------------------------------------------
FUNCTION vPeserGetTare


	snWeight = gocache.tablegetfieldvalue("PLAQUE",VHEAD.PLAQUEID,"TARE",0)
	Setscrobj("refresh")
	RETURN .T.

*-----------------------------------------------------------------
FUNCTION vPeser

	PRIVATE snPese,snType,stDatePesage,snWeight, slSaveTare
	LOCAL lcPese,lcType,lcPeseField,lccmd
	LOCAL lcDocdetID, lcArtid
	
	slSaveTare = .F.
	
	IF !USED("docdet")
		USE gcdatadir+"docdet" SHARED AGAIN IN 0
	ENDIF
	IF !USED("caraart")
		USE gcdatadir+"caraart" SHARED AGAIN IN 0
	ENDIF
	IF !USED("caradet")
		USE gcdatadir+"caradet" SHARED AGAIN IN 0
	ENDIF
	
	SELECT docdetid, artid FROM docdet WHERE jnl+STR(number,8) = vhead.jnl+STR(vhead.number,8) AND !EMPTY(artid) INTO CURSOR c_dd
	
	IF !EOF("c_dd")
		lcdocdetid = c_dd.docdetid
		lcartid = TRIM(c_dd.artid)
	ENDIF
	
	snWeight = goScrObj[gnScrObj].loWeight.value
	
	stDatePesage = gocache.docheadgetfieldvalue(VHEAD.jnl,VHEAD.number,"C_DTPESAGE",DATETIME())
	IF EMPTY(stDatePesage)
		stDatePesage = DATETIME()
	ENDIF
		
	SELECT lib,valmax,valmin, PADR(TRANSFORM(valmin)+" ... "+TRANSFORM(valmax),30) as valrange,unite, space(10) as caradetid , caraartid ;
	FROM caraart ;
	WHERE caraart.artid = lcartid ;
	INTO TABLE (gcTempDir+"C_caract") READWRITE
	ALTER TABLE C_caract ADD COLUMN val N(12,4)
	
	DO WHILE !EOF("c_caract")		
		SELECT caradetid, val FROM caradet WHERE caraartid = c_caract.caraartid INTO CURSOR c_caraval
		IF _tally > 0
			REPLACE val WITH c_caraval.val, caradetid WITH c_caraval.caradetid IN c_caract
		ENDIF
		SKIP 1 IN c_caract	
	ENDDO
	SELECT C_caract

	GO TOP IN C_caract

	lcPese = "Tare"+IIF(EMPTY(VHEAD.C_WEIGHT1),""," (repesage)")+";Poids Brut"+IIF(EMPTY(VHEAD.C_WEIGHT2),""," (repesage)")
	*lcPese = "1er Pes�e"+IIF(EMPTY(VHEAD.C_WEIGHT1),""," (repesage)")+";2eme Pes�e"+IIF(EMPTY(VHEAD.C_WEIGHT2),""," (repesage)")
	lcType = "Automatique;Manuel"
	*lcType = "Automatique;Reprendre la tare stock�e;Manuel"
	snPese = 1
	snType = 1
	lcPeseField = ""
	
	=SetScrObj ( ":INIT" , "Option de pesage")
		=SetScrObj("9:GROUP")
			=SetScrObj( "V:GET", "Pes�e", "snPese", "@*R "+lcPese, snPese , 1, 10, ".T.", "vPeserChange()" )
		=SetScrObj("_9:GROUP")
			=SetScrObj( "_V:GET", "Type de pes�e", "snType", "@*R "+lcType , snType , 1, 10, ".T.", "vPeserTypeChange()" )
		=SetScrObj("9:GROUP")
			=SetScrObj( "GET", "Date de pes�e", "stDatePesage", "", stDatePesage, 1, 10, ".T.", ".T." )
		=SetScrObj("_9:GROUP")		
			=SetScrObj( "_V:GET:o=zoWeight", "Poids", "snWeight", "99999999.9999", snWeight , 1, 10, ".T.", ".T." )
			=SetScrObj("_:GET:o=zoGetTare", "", "", "@* Reprendre la Tare sauvegard�e de "+VHEAD.PLAQUEID, "", 1, 10, ".T.", "vPeserGetTare()")
		=SetScrObj("9:GROUP","Options")
			=SetScrObj(":GET:o=zoNewTare", "M�moriser ce poids comme TARE pour "+VHEAD.PLAQUEID, "slSaveTare", "@*C", slSaveTare, 1, 10, ".T.", ".T.")

		=SetScrObj("9:GROUP","Caract�ristiques du produit : "+c_dd.artid)		
			SetScrObj( ":WINLIST", "Caract�ristiques", "C_caract", "", 0, 15, 100, ".T.", ".T.", "C_caract" )
				SetScrObj( "WINCOL", "Description", "C_caract.lib", 20 )
				SetScrObj( ":WINCOL", "Valeur", "C_caract.val", 20,"vVal()",".T." )
				SetScrObj( "WINCOL", "Unit�", "C_caract.unite", 20 )
				SetScrObj( "WINCOL", "Range de Valeurs", "C_caract.valrange", 20 )
		
	IF !SetScrObj ( ":READ")
		RETURN .F.
	ENDIF
	
	DO CASE 
		CASE snPese = 1 
			lcPeseField = "C_WEIGHT1" && tare
		CASE snPese = 2
			lcPeseField = "C_WEIGHT2" && pds brut
	ENDCASE 
	
	*-*
	
	PRIVATE lcReturnWeight
	LOCAL loScale, lcCharToSend , lcCharToDelete, lnWeight 

	lcReturnWeight = ""
	lcCharToSend = ""
	lcCharToDelete = ""
	
	lnWeight = snWeight
	
	IF slSaveTare AND snPese = 1
		lnWeight = gocache.tableputfieldvalue("PLAQUE",VHEAD.PLAQUEID,"TARE",snWeight)
	ENDIF
	
	
*!*		loScale = CREATEOBJECT("Scale")
*!*		IF !loScale.InitCom() THEN
*!*			INFO("Probl�me d'initialisation de la balance : " + loScale.cError + CHR(13) + CHR(10) + "V�rifiez vos param�tres")
*!*			RETURN 0
*!*		ENDIF
*!*		snWeight = loScale.GetWeight(@lcReturnWeight, lcCharToSend, lcCharToDelete
	*------------------------------------------------

	gocache.DocHeadPutFieldValue(VHEAD.jnl,VHEAD.number,"C_DTPESAGE",stDatePesage)
	gocache.DocHeadPutFieldValue(VHEAD.jnl,VHEAD.number,lcPeseField,lnWeight )
	
	lcCmd = "REPLACE "+lcPeseField+" WITH "+TRANSFORM(lnWeight )+" IN VHEAD"
	&lcCmd
	
	** Update caract
	
	SELECT C_caract

	GO TOP IN C_caract

	DO WHILE !EOF("c_caract")
		IF EMPTY(c_caract.caradetid)
			IF !EMPTY(c_caract.val)
				SELECT 	caradet
				APPEND BLANK
				REPLACE caradetid WITH GETNEWID(), val WITH c_caract.val, caraartid WITH c_caract.caraartid, docdetid WITH lcdocdetid IN caradet
			ENDIF
		ELSE
			REPLACE val WITH c_caract.val FOR caradetid = c_caract.caradetid IN caradet
		ENDIF
		SKIP 1 IN C_caract
	ENDDO
	
	IF VHEAD.C_WEIGHT1 > 0 AND VHEAD.C_WEIGHT2 > 0
	
		gocache.docdetputfieldvalue(lcdocdetid,"qty",(VHEAD.C_WEIGHT2 - VHEAD.C_WEIGHT1))
		gocache.DocHeadCalcTot(VHEAD.jnl,VHEAD.number)
	
	ENDIF
	
	
	SetScrObj("REFRESH")
&&Affectation du poids � la ligne de document en cours.
*	gocache.DocdetPutFieldValue( CURDOCDET.DOCDETID, "lcPeseField", lnWeight)
	
	RETURN .T.
	
ENDFUNC
*-----------------------------------------------------------------
FUNCTION vImprimer
	INFO("vImprimer")
ENDFUNC
*-----------------------------------------------------------------
FUNCTION vEffacer
	INFO("vEffacer")
ENDFUNC
*-----------------------------------------------------------------
FUNCTION vModifier
	INFO("vModifier")
ENDFUNC                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 *-----------------------------------------------------------------              
FUNCTION vRepesage
	INFO("vRepesage")
ENDFUNC
*-----------------------------------------------------------------
FUNCTION vSauver
	INFO("vSauver")
ENDFUNC      



**////////////////////////////////////////////////////////////////////////////////
DEFINE CLASS Scale AS Custom

	cError 				= ""
	oOcxCOMM 			= NULL
	cTimeOutBefore		= ""
	cTimeOut			= ""
	nPort				= 0
	cSettings			= ""

	*------------------------------------------------
	PROCEDURE INIT

		This.cTimeOutBefore	= ALLTRIM(GetParam("NEURONICS_SCALE_READ_TIMEOUT_B", "0.200"))
		This.cTimeOut 		= ALLTRIM(GetParam("NEURONICS_SCALE_READ_TIMEOUT", "0.350"))
		This.nPort			= ROUND(GetParam("NEURONICS_SCALE_PORT", 6),0)
		This.cSettings		= ALLTRIM(GetParam("NEURONICS_SCALE_SETTINGS", "9600,O,7,1"))
		
	ENDPROC 

	*------------------------------------------------
	FUNCTION InitCom() AS Boolean

		This.cError = ""
	
		TRY
			This.oOcxCOMM  = CREATEOBJECT("FlexCom")
			This.oOcxCOMM.CommPort = This.nPort
			This.oOcxCOMM.Settings = This.cSettings
			
			IF This.oOcxCOMM.PortOpen THEN 
				This.oOcxCOMM.PortOpen = .F.
			ENDIF
	
			IF This.oOcxCOMM.PortOpen = .T.
				This.cError = l("12307^La balance en cours d'utilisation par un autre processus ! Impossible d'initialiser la communication")
			ENDIF
			
			This.oOcxCOMM.PortOpen = .T.
			
		CATCH TO loError
			This.cError = TRANSFORM(loError.Errorno)+" : "+loError.Message+CHR(13)+"Line : "+;
		      TRANSFORM(loError.lineno)+CHR(13)+"Procedure : "+TRANSFORM(loError.Procedure)+;
		      CHR(13)+"Line Contents : "+TRANSFORM(loError.LineContents)
		ENDTRY
		
		RETURN EMPTY(This.cError)
		
	ENDPROC

	*------------------------------------------------
	FUNCTION GetWeight() AS Bolean
		LPARAMETERS pcReturnWeight, pcCharToSend, pcCharToDelete
		
		LOCAL lcWeight, lcTimeOut, lnSecondsTo, llError, lnTest
		
		This.cError = ""
		lcWeight = ""
		lnSecondsTo = SECONDS()+8
		llError = .F.
		lnTest = 0
		pcReturnWeight = ""

		IF NOT This.NumSerAuthorized()
			This.cError = l("12306^Le programme n'est pas autoris� � utiliser les fonctionnalit�s de communication avec une balance Toledo, veuillez contacter votre revendeur.")
			RETURN .F.
		ENDIF
		
		DO WHILE EMPTY(VAL(lcWeight))
			llError = .F.
			lnTest = lnTest + 1
			DO CASE
				CASE SECONDS() > lnSecondsTo
					llError = .T.
					This.cError = l("12308^Echec de la lecture du poids : la stabilisation du poids sur la balance a probablement dur� plus de 8 secondes.")	
					lcWeight = "-999"
				CASE lnTest > 10
					llError = .T.
					This.cError = l("12309^Echec de la lecture du poids : arr�t automatique de la lecture apr�s 10 essais r�t�s.")	
					lcWeight = "-999"
				OTHERWISE
					This.cError = ""
					TRY
						lcTimeOut = "WAIT WINDOW '"+l("12310^Essai de lecture n�")+" "+TRANSFORM(lnTest)+"' TIMEOUT "+This.cTimeOutBefore
						&lcTimeOut
						
						This.oOcxCOMM.OUTPUT = IIF(EMPTY(pcCharToSend), "W",pcCharToSend + CHR(13) + CHR(10))
						
						lcTimeOut = "WAIT WINDOW '"+l("12311^Attente de la r�ponse de la lecture du poids...")+"' TIMEOUT "+This.cTimeOut
						&lcTimeOut
						
						lcWeight = This.oOcxCOMM.INPUT
						lcWeight = RIGHT(lcWeight ,LEN(lcWeight )-1)
						
						IF !EMPTY(pcCharToDelete) THEN
							lcWeight = STRTRAN(lcWeight, pcCharToDelete, "")
						ENDIF
						
						pcReturnWeight = lcWeight
						
					CATCH TO loError
						llError = .T.
						This.cError = TRANSFORM(loError.Errorno)+" : "+loError.Message+CHR(13)+"Line : "+;
					      TRANSFORM(loError.lineno)+CHR(13)+"Procedure : "+TRANSFORM(loError.Procedure)+;
					      CHR(13)+"Line Contents : "+TRANSFORM(loError.LineContents)
					ENDTRY
			ENDCASE
		ENDDO
		
		IF llError
			lcWeight = ""
			pcReturnWeight = ""
		ENDIF	
		
		RETURN NOT llError
		
	ENDPROC	

	*------------------------------------------------
	FUNCTION GetWeightNB() AS Bolean
		LPARAMETERS pcFinalPricePerKg, pcReturnWeight
		
		&& Balance chez Natura Bio / Alain Bernard
		
		LOCAL lcWeight, lcTimeOut, lnSecondsTo, llError, lnTest, lni, lcWeightRead
		
		This.cError = ""
		lcWeight = ""
		lnSecondsTo = SECONDS()+20
		llError = .F.
		lnTest = 0
		pcReturnWeight = ""
		lni = 0
		lcWeightRead = ""

		IF NOT This.NumSerAuthorized()
			This.cError = l("12306^Le programme n'est pas autoris� � utiliser les fonctionnalit�s de communication avec une balance Toledo, veuillez contacter votre revendeur.")
			RETURN .F.
		ENDIF
		
		* This.oOcxCOMM.OUTPUT = chr(6)+chr(13)+chr(10)  && � faire une seule fois lors de l'init
		
		DO WHILE EMPTY(VAL(lcWeight))
			llError = .F.
			lnTest = lnTest + 1
			DO CASE
				CASE SECONDS() > lnSecondsTo
					llError = .T.
					This.cError = l("12308^Echec de la lecture du poids : la stabilisation du poids sur la balance a probablement dur� plus de 8 secondes.")	
					lcWeight = "-999"
				CASE lnTest > 10
					llError = .T.
					This.cError = l("12309^Echec de la lecture du poids : arr�t automatique de la lecture apr�s 10 essais r�t�s.")	
					lcWeight = "-999"
				OTHERWISE
					This.cError = ""
					TRY
						lcTimeOut = "WAIT WINDOW '"+l("12310^Essai de lecture n�")+" "+TRANSFORM(lnTest)+"' TIMEOUT "+This.cTimeOutBefore
						&lcTimeOut
						
						This.oOcxCOMM.OUTPUT = "G"+pcFinalPricePerKg+chr(13)+chr(10)
						
						lcTimeOut = "WAIT WINDOW '"+l("12311^Attente de la r�ponse de la lecture du poids...")+"' TIMEOUT "+This.cTimeOut
						&lcTimeOut
						
						lcWeight		= ""
						lcWeightRead 	= This.oOcxCOMM.INPUT
						
						FOR lni = 1 TO LEN(lcWeightRead)
							IF BETWEEN(ASC(SUBSTR(lcWeightRead,lni,1)), 48, 57)
								lcWeight = lcWeight + SUBSTR(lcWeightRead,lni,1)
								IF LEN(lcWeight) >= 6
									EXIT
								ENDIF
							ENDIF
						ENDFOR

						lcWeight = STR(val(lcWeight)/10000,10,3)
						
						pcReturnWeight = lcWeight
						
					CATCH TO loError
						llError = .T.
						This.cError = TRANSFORM(loError.Errorno)+" : "+loError.Message+CHR(13)+"Line : "+;
					      TRANSFORM(loError.lineno)+CHR(13)+"Procedure : "+TRANSFORM(loError.Procedure)+;
					      CHR(13)+"Line Contents : "+TRANSFORM(loError.LineContents)
					ENDTRY
			ENDCASE
		ENDDO
		
		IF llError
			lcWeight = ""
			pcReturnWeight = ""
		ENDIF	
		
		RETURN NOT llError
		
	ENDPROC	
	
ENDDEFINE                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
