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



PRIVATE lcThirdid, lcThirdName, lcThirdGroup, scUtilisateur, scFilter, snWeight, scPesageJnl 
STORE "" TO lcThirdid, lcThirdName, lcThirdGroup, scFilter, snWeight, scPesageJnl 
scUtilisateur = PADR("",50)
snWeight = 0

scPesageJnl = GetPesageJnl()


TRY

	IF !USED("__DOCHEAD") THEN
		OPENTABLE("DOCHEAD", "JNL_NUM", "__DOCHEAD")
	ENDIF

	SELECT __DOCHEAD
	SET FILTER TO JNL = scPesageJnl 

	SetScrObj(":INIT","Move-It","","","","", "PesageKeyPress", "",170)
	
	=SetScrObj("C0:BEGINGROUP")
	
		=SetScrObj(":BEGINGROUP")
		=SetScrObj( "C:SAY", "")
		=SetScrObj( ":ENDGROUP" )
		=SetScrObj("F_:BEGINGROUP")
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
		=SetScrObj("_:BEGINGROUP")
		=SetScrObj( "_C:SAY", "")
		=SetScrObj( ":ENDGROUP" )

		=SetScrObj( ":BEGINGROUP" )
		=SetScrObj("_:GET:", "", "", "@*HN Nouveau (F9)"	, 1, 60, 60, "vNouveau()"			, ".T."  )
		=SetScrObj("_:GET:", "", "", "@*HN Dupliquer"		, "", 1, 60, "vDupliquer()"			, ".T."  )
		=SetScrObj("_:GET:", "", "", "@*HN Rechercher"		, "", 1, 60, "vRechercher()"		, ".T."  )
		=SetScrObj("_:GET:", "", "", "@*HN Peser"			, "", 1, 60, "vPeser()"				, ".T."  )
		=SetScrObj("_:GET:", "", "", "@*HN Contrats"		, "", 1, 60, "vContrats('', '', .F.)"			, ".T."  )
		=SetScrObj("_:GET:", "", "", "@*HN Immatriculation"	, "", 1, 60, "vImmatriculation()"	, ".T."  )
		=SetScrObj(":GET:", "", "", "@*HN Imprimer (F4)"	, "", 1, 60, "vImprimer()"			, ".T."  )
		=SetScrObj("_:GET:", "", "", "@*HN Effacer (F12)"	, "", 1, 60, "vEffacer()"			, ".T."  )
		=SetScrObj("_:GET:", "", "", "@*HN Modifier (F5)"	, "", 1, 60, "vModifier()"			, ".T."  )
		=SetScrObj("_:GET:", "", "", "@*HN Repesage"		, "", 1, 60, "vRepesage()"			, ".T."  )
		=SetScrObj("_:GET:", "", "", "@*HN Sauver (END)"	, "", 1, 60, "vSauver()"			, ".T."  )
		=SetScrObj( ":ENDGROUP" )

		=SetScrObj( "C0:BEGINGROUP" )
		=SetScrObj( ":WINLIST:O=zoDocuments", "", "" , "UPPER($)", "", 35, 140, ".T." , "RefreshMainGrid()", "__DOCHEAD" )
		=SetScrObj( "WINCOL" , l("JNL")			, 	"__DOCHEAD.JNL"				, 	8 )
		=SetScrObj( "WINCOL" , l("NUMBER")		, 	"__DOCHEAD.NUMBER"			, 	8 )
		=SetScrObj( "WINCOL" , l("ThirdId")		, 	"__DOCHEAD.THIRDID"			, 	25 )
		=SetScrObj( "WINCOL" , l("Plaque")		, 	"__DOCHEAD.PLAQUE"			, 	25 )
		=SetScrObj( "WINCOL" , l("Contrat")		, 	"__DOCHEAD.CONTRAT"			, 	25 )
		=SetScrObj( ":ENDGROUP" )
	
	=SetScrObj( ":ENDGROUP" )
	
	=SetScrObj( "C0:BEGINGROUP" )
		=SetScrObj( ":BEGINGROUP" )
		=GetField( "GET" , "Bordereau"	, "__DOCHEAD.JNL" 			, "*!", ".T.", ".F." )
		=GetField( "GET" , "Num�ro"		, "__DOCHEAD.NUMBER" 		, "99999999", ".T.", ".F." )
		=GetField( "GET" , "Client"		, "__DOCHEAD.THIRDNAME" 	, "*!", ".T.", ".F." )
		=SetScrObj( ":ENDGROUP" )

		=SetScrObj( "_:BEGINGROUP" )
		=GetField( "GET" , "Plaque du v�hicule"	, "__DOCHEAD.PLAQUE" , "", ".T.", ".T." )
		=GetField( "GET" , "Contrat"			, "__DOCHEAD.CONTRAT" , "", ".T.", ".T." )
		=GetField( "GET" , "R�f�rence"			, "__DOCHEAD.YOURREF" , "", ".T.", ".T." )
		=SetScrObj( ":ENDGROUP" )
	=SetScrObj( ":ENDGROUP" )

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

FUNCTION RefreshMainGrid
	SetScrObj("REFRESH")
	RETURN .T.
ENDFUNC

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
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
DEFINE CLASS RefreshTimer AS CUSTOM

	soScreen = NULL

	PROCEDURE INIT
		LPARAMETERS poScreen
		
		This.soScreen = poScreen
		
	ENDPROC

	PROCEDURE TimerAction
	
		LOCAL lnWeight 
		IF goScrObj[gnScrObj] = This.soScreen THEN
			lnWeight = This.GetWeight()
			This.soScreen.loWeight.value  = lnWeight 
		ENDIF
			
	ENDPROC
	
	FUNCTION GetWeight
	
		LOCAL lnWeight 
		lnWeight = INT(RAND() * 10000000)
		RETURN lnWeight 
	
	ENDFUNC
	
ENDDEFINE

PROCEDURE vImmatriculation
	LPARAMETERS plSelect

	IF !USED("_PLAQUE") THEN
		OPENTABLE("PLAQUE", "", "_PLAQUE")
	ENDIF
	
	SELECT _PLAQUE
	SET FILTER TO !INSLEEP
	SetScrObj("INIT", "Immatriculation", "", "", "", "", "", "", 150, 30)
	
	=SetScrObj(":VIEW:O=zoImmatriculation", "PLAQUE", "_PLAQUE", "!INSLEEP", "" )
	goScrObj[gnScrObj].zoImmatriculation.oViewGrid.columns[5].visible 	= .F.
	goScrObj[gnScrObj].zoImmatriculation.oViewGrid.columns[6].visible 	= .F.
	goScrObj[gnScrObj].zoImmatriculation.oViewGrid.columns[7].visible 	= .F.
	goScrObj[gnScrObj].zoImmatriculation.oViewGrid.columns[8].visible 	= .F.
	goScrObj[gnScrObj].zoImmatriculation.oViewGrid.columns[9].visible 	= .F.
	goScrObj[gnScrObj].zoImmatriculation.oViewGrid.columns[10].visible 	= .F.
	
	SetScrObj("READ","vValidImmatriculation()","@* <A>;<D>;<O>")
	
*!*		SetScrObj("INIT", "Immatriculation")
*!*		=SetScrObj( "C0:BEGINGROUP" )
*!*		=SetScrObj( ":WINLIST:O=zoImmatriculation", "", "" , "UPPER($)", "", 35, 180, ".T." , ".T.", "_PLAQUE" )
*!*		=SetScrObj( "WINCOL" , l("Num�ro")			, 	"_PLAQUE.NUMERO"			, 	20 )
*!*		=SetScrObj( "WINCOL" , l("Libell�")			, 	"_PLAQUE.LIBELLE"			, 	50 )
*!*		=SetScrObj( "WINCOL" , l("Tare")			, 	"_PLAQUE.TARE"				, 	50 )
*!*		=SetScrObj( "WINCOL" , l("Transporteur")	, 	"_PLAQUE.CODETRANS"		, 	50 )
*!*		=SetScrObj( ":ENDGROUP" )
*!*		&&=SetScrObj( "_C0:BEGINGROUP" )
*!*		&&=SetScrObj(":GET:", "", "", "@*HN Nouveau"		, 1, 60, 60, "vImmatriculationNouveau()"		, ".T."  )
*!*		&&=SetScrObj(":GET:", "", "", "@*HN Supprimer"	, 1, 60, 60, "vImmatriculationSupprimer()"		, ".T."  )
*!*		&&=SetScrObj( ":ENDGROUP" )
*!*		SetScrObj("READ","vValidImmatriculation()","@* <A>;<D>;<O>") 
	
	IF plSelect
		RETURN _PLAQUE.NUMERO
	ELSE
		RETURN .T.
	ENDIF

ENDPROC


PROCEDURE vValidImmatriculation
	SET STEP ON 
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
			RETURN .F.
			
		CASE lnDo = 3 &&Quitter 
			DO CLEAR_READ
			RETURN .T.
	ENDCASE
			
	RETURN .T.
	
ENDPROC

FUNCTION vImmatriculationSupprimer

	IF YesNo("Etes-vous sur de vouloir supprimer cette immatriculation ?") 
		REPLACE INSLEEP WITH .T.
	ENDIF
	SetScrObj("REFRESH")

ENDFUNC

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
	SetScrObj("READ","vImmatriculationAjout()","@* <A>;<O>") 
	SetScrObj("REFRESH")
	RETURN .T.
	
ENDPROC

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

PROCEDURE vTransporteurNouveau

	PRIVATE scTransCode, scTransLib
	STORE PADR("",50) TO scTransCode, scTransLib
	
	=SetScrObj("INIT", "Ajout d'un transporteur")
	GetField( "GET" , "Code"			, "scTransCode" 	, "*!", ".T.", ".T." )
	GetField( "GET" , "Libell�"			, "scTransLib" 		, "*!", ".T.", ".T." )
	SetScrObj("READ","vTransporteurAjout()","@* <A>;<O>") 
	SetScrObj("REFRESH")
	
ENDPROC

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

PROCEDURE vImmatriculationAjout

	LOCAL lnOldAlias
	lnOldAlias = SELECT()

	DO CASE
	
		CASE lnDo = 1
			IF !USED("_PLAQUE") THEN
				OPENTABLE("PLAQUE", "NUMERO", "_PLAQUE")
			ENDIF
			
			SELECT _PLAQUE
			SET ORDER TO NUMERO
			IF SEEK(PADR(scNumero,LEN(NUMERO))) THEN
				INFO("Ce num�ro de plaque existe d�j�, veuillez le modifier")
				RETURN .F.
			ENDIF
			
			SELECT _PLAQUE
			APPEND BLANK
			REPLACE NUMERO 		WITH scNumero
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

PROCEDURE vContrats
	LPARAMETERS pcArtId, pcGroupid, plSelect
	
	PRIVATE scGroupId , scArtId
	
	scGroupId 	= pcGroupid
	scArtId 	= pcArtId

	LOCAL lcFilter 
	
	IF !USED("_CONTRAT") THEN
		OPENTABLE("CONTRAT", "CODE", "_CONTRAT")
	ENDIF
	
	lcFilter = "!INSLEEP" + IIF(!EMPTY(scArtId), " AND ARTID = '" + scArtId+ "'", "") ;
	+ IIF(!EMPTY(scGroupId) , " AND THIRDID = '" + scGroupId + "'", "")
	
	SELECT _CONTRAT
	SET FILTER TO &lcFilter 
	SetScrObj("INIT", "Contrat")
	=SetScrObj( "C0:BEGINGROUP" )
	=SetScrObj( ":WINLIST:O=zoContrat", "", "" , "UPPER($)", "", 35, 180, ".T." , ".T.", "_CONTRAT" )
	=SetScrObj( "WINCOL" , l("Code")			, 	"_CONTRAT.CODE"			, 	20 )
	=SetScrObj( "WINCOL" , l("Libell�")			, 	"_CONTRAT.LIB"			, 	50 )
	=SetScrObj( "WINCOL" , l("Produit")			, 	"_CONTRAT.ARTID"		, 	20 )
	=SetScrObj( "WINCOL" , l("Tonnage")			, 	"_CONTRAT.TONNAGE"		, 	20 )
	=SetScrObj( "WINCOL" , l("Client")			, 	"_CONTRAT.THIRDID"		, 	20 )
	=SetScrObj( "WINCOL" , l("Prix unitaire")	, 	"_CONTRAT.PU"			, 	20 )
	=SetScrObj( "WINCOL" , l("Remise")			, 	"_CONTRAT.REMISE"		, 	20 )
	=SetScrObj( "WINCOL" , l("Date de d�but")	, 	"_CONTRAT.C_START"		, 	20 )
	=SetScrObj( "WINCOL" , l("Date de fin")		, 	"_CONTRAT.C_END"		, 	20 )
	=SetScrObj( ":ENDGROUP" )
	=SetScrObj("READ","vValidContrat()","@* <A>;<D>;<O>") 
	
	IF plSelect
		RETURN _CONTRAT.Code
	ELSE
		RETURN .T.
	ENDIF

ENDPROC

PROCEDURE vValidContrat

	DO CASE
		CASE lnDo = 1 &&Mise � jour
			vContratNouveau(scArtId, scGroupId)
			SetScrObj("REFRESH")
			RETURN .T.
		
		CASE lnDo = 2
			vContratSupprimer()
			SetScrObj("REFRESH")
			RETURN .F.
			
		CASE lnDo = 3 &&Quitter 
			DO CLEAR_READ
			RETURN .T.
	ENDCASE
			
	RETURN .T.

ENDPROC


PROCEDURE vContratSupprimer
	
	IF YesNo("Etes-vous sur de vouloir supprimer ce contrat ?") 
		REPLACE INSLEEP WITH .T.
	ENDIF
	SetScrObj("REFRESH")
	
ENDPROC

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
		
		IF !USED("_CONTRAT") THEN
			OPENTABLE("CONTRAT", "CODE", "_CONTRAT")
		ENDIF
		
		SELECT _CONTRAT
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

FUNCTION vValidContratFiche

	DO CASE
		CASE lnDo = 1 &&Mise � jour
	
			IF EMPTY(scCode) THEN
				ERROR("Le code doit �tre remplit")
				RETURN .F.
			ENDIF
			
			IF !USED("_CONTRAT") THEN
				OPENTABLE("CONTRAT", "CODE", "_CONTRAT")
			ENDIF
			
			SELECT _CONTRAT
			SET ORDER TO CODE
			IF SEEK(PADR(scCode,LEN(CODE))) THEN
				INFO("Ce code de contrat existe d�j�, veuillez le modifier")
				RETURN .F.
			ENDIF
			SET STEP ON 
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

FUNCTION ContratValidThird

	LOCAL lcCustId 
	
	lcCustId 	= GetCustIdFullText(scThirdid , "(Customer=.T.)" )
	scThirdid	= gocache.CustGetFieldValue(lcCustId , "GROUPID", "--")
	scThirdName	= gocache.CustGetFieldValue(lcCustId , "NAME", "--")
	SetScrObj("REFRESH")

ENDFUNC

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
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
FUNCTION vDocRefresh

	SELECT __DOCHEAD
	SET FILTER TO &scFilter
	GO BOTTOM
	SetScrObj("REFRESH")

ENDFUNC
                                      
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
	gocache.DocheadPutFieldValue(scJnl, snNumberReturn, "PLAQUE", lcNumeroImmatriculation)
	
	&&On s�lectionne un tiers
	SetScrObj("INIT", "Choix du tiers")
	=GetField( ":GET" 	, "Client"		, "scThirdid" 	, "*!", "ContratValidThird()", ".T." )
	=GetField( "_D:GET" , "Nom"			, "scThirdName" , "*!", ".T.", ".T." )
	SetScrObj("READ")
	
	lcCustid = gocache.CustGetIdFromGroup(scThirdid, .T.) && pcGroupid, plCustomer, plSupplyer, plUseInSleep
	
	&&On S�lectionne un contrat
	SET STEP ON 
	lcContrat = vContrats("", lcCustid, .T.)
	
	&&On affecte le num�ro de contrat dans l'ent�te du document cr��
	gocache.DocheadPutFieldValue(scJnl, snNumberReturn, "CONTRAT", lcContrat )
	
	&&On affecte le tiers choisi au document
	gocache.DocHeadSetThird(scJnl, snNumberReturn, lcCustid ) &&PARAMETERS pcJnl, pnNumber, pcThirdid, pcPersid, pdDate
	
	&&Ajout du docdet
	AddDocDet(scJnl, snNumberReturn)
	
	&&Assignation de l'article
	DocdetSetArt(_CONTRAT.ARTID)
	
	&&On rafraichis la fen�tre afin de voir ce nouveau document
	SetScrObj("REFRESH")
	
	CloseUsed("CURJNL")
	
	SELECT(lnOldSelect)
	
ENDFUNC   

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

FUNCTION vDupliquer
	INFO("vDupliquer")
ENDFUNC

FUNCTION vRechercher
	INFO("vRechercher")
ENDFUNC   

FUNCTION vPeser
	
	PRIVATE lcReturnWeight
	LOCAL loScale, lcCharToSend , lcCharToDelete, lnWeight 
	
	lcReturnWeight = ""
	lcCharToSend = ""
	lcCharToDelete = ""
	
	lnWeight = goScrObj[gnScrObj].loWeight.value
	
*!*		loScale = CREATEOBJECT("Scale")
*!*		IF !loScale.InitCom() THEN
*!*			INFO("Probl�me d'initialisation de la balance : " + loScale.cError + CHR(13) + CHR(10) + "V�rifiez vos param�tres")
*!*			RETURN 0
*!*		ENDIF
*!*		lnWeight = loScale.GetWeight(@lcReturnWeight, lcCharToSend, lcCharToDelete
	*------------------------------------------------
	INFO(TRANSFORM(lnWeight))
	
	IF !USED("CURDOCDET") OR (USED("CURDOCDET") AND !EMPTY(CURDOCDET.DOCDETID)) THEN
		RETURN 0
	ENDIF
	
	&&Affectation du poids � la ligne de document en cours.
	gocache.DocdetPutFieldValue( CURDOCDET.DOCDETID, "C_WEIGHT", lnWeight)
	
	RETURN lnWeight 
	
ENDFUNC

FUNCTION vImprimer
	INFO("vImprimer")
ENDFUNC

FUNCTION vRechercher
	INFO("vRechercher")
ENDFUNC

FUNCTION vEffacer
	INFO("vEffacer")
ENDFUNC

FUNCTION vModifier
	INFO("vModifier")
ENDFUNC                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
FUNCTION vRepesage
	INFO("vRepesage")
ENDFUNC

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
