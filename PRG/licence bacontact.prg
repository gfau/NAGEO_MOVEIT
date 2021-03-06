IF !USED("ML") THEN
	USE "\\server-vstorage\WBVersionManager\Data\Modules.dbf" SHARED AGAIN IN 0 ALIAS ML
ENDIF

IF !USED("CL") THEN
	USE "\\server-vstorage\WBVersionManager\Data\Cust.dbf" SHARED AGAIN IN 0 ALIAS CL
ENDIF

SELECT CL
SELECT ML

lcSql = 'SELECT CL.Num_serie, CL.Nom_soc,CL.Adr1_soc, CL.CITY, CL.ZIPCODE, CL.num_tel,  CL.RefCompta, ML.iddate FROM CL, ML '+;
'WHERE '+;
'(ML.idarticle = "LOGB6")'+;
' AND ML.num_serie = CL.Num_serie ' +;
'AND !CL.isDealer AND cL.Master = "1" ORDER BY ML.iddate INTO TABLE c:\temp\CurLicence.dbf'

&lcSql
BROWSE
EXPORT TO c:\Licence_banksys.xls XL5


&&'(ML.idarticle = "LOGB6" OR ML.idarticle = "LOGY2")'+;