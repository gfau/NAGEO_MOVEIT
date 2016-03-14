IF !USED("ML") THEN
	USE "\\server-vstorage\WBVersionManager\Data\Modules.dbf" SHARED AGAIN IN 0 ALIAS ML
ENDIF

IF !USED("CL") THEN
	USE "\\server-vstorage\WBVersionManager\Data\Cust.dbf" SHARED AGAIN IN 0 ALIAS CL
ENDIF

SELECT CL
SELECT ML

lcSql = 'SELECT CL.Num_serie, CL.Nom_soc, CL.RefCompta, ML.iddate FROM CL, ML WHERE ML.idarticle = "LOGR9" AND ML.num_serie = CL.Num_serie ' +;
'AND !CL.isDealer AND cL.Master = "1" INTO TABLE c:\temp\CurLicence.dbf'
&lcSql
BROWSE
EXPORT TO c:\Licence.xls XL5

*!*	=SetScrObj( ":INIT", "my view" )
*!*	=SetScrObj( ":SAY", "View")
*!*	=SetScrObj( "S:VIEW", "CurLicence", "MyCurLicence", ".T." )
*!*	            * pc2 = Table name
*!*	            * pc3 = Alias name
*!*	            * pc4 = Filter expression
*!*	            * pc5 = Table key
*!*	=SetScrObj( ":READ", "myViewValid()" )
 
CloseUsed("ML","CL")

*!*	FUNCTION myViewValid
*!*	     
*!*	      IF lnDo=1
*!*	            IF USED("MYCUST")
*!*	                  SELECT MYCUST
*!*	                  BROWSE NORMAL NOEDIT FOR ItemSelected
*!*	            ENDIF
*!*	      ENDIF
*!*	     
*!*	      DO CLEAR_READ
*!*	     
*!*	      RETURN .T.