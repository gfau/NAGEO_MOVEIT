PRIVATE scCode
scCode = ""
SetScrObj("INIT", "Compilator","","","","", "", "",170,15)

GetField( "EDIT", l("Code")				,	"scCode",	"100/3",		".T.",		".T." )
=SetScrObj("_:GET:", "", "", "@*HN G�n�rer"		, "", 1, 60, "EvalFile()"		, ".T."  )

SetScrObj( "READ")


FUNCTION EvalFile

	LOCAL lnLines, lni
	
	lnLinesCount = OCCURS(CHR(13) + CHR(10),scCode)
	FOR lni = 1 TO lnLinesCount
		lcLine =GETWORDNUM(scCode,lni,CHR(13) + CHR(10))
		EVALUATE(lcLine)
	ENDFOR

ENDFUNC