Parameters tdFecha, tnDocu, tcCurName 

lcSql = "SELECT TNL_Numerador, TABTURNEROLOG.Id, " + ;
	"TABTURNEROLOG.TNL_Tipo, TABTURNEROLOG.TNL_numdocumento, TABTURNEROLOG.TNL_FechaHoraIng, " + ;
	"TabLlamador.LLA_FechaSol, TabLlamador.LLA_FechaPant, " + ;
	"cast(TabLlamador.LLA_FechaPant as time) as p, " + ;
	"cast(TABTURNEROLOG.TNL_FechaHoraIng as time) as p1, " + ;
	"(cast(TabLlamador.LLA_FechaPant as time) - cast(TABTURNEROLOG.TNL_FechaHoraIng as time)) / 60 as dif, tABTURNEROLOG.Tnl_IdLlama " + ;
	"FROM TABTURNEROLOG " + ;
	"Inner join TabLlamador on TabLlamador.Id = TABTURNEROLOG.Tnl_IdLlama " + ;
	"Where Cast(TABTURNEROLOG.TNL_FechaHoraIng  as Date) = ?tdFecha and TNL_numdocumento = ?tnDocu " + ;
	"Order by TABTURNEROLOG.id desc " 


If!Prg_EjecutoSql(lcSql,tcCurName,.F.)
	Return .F.
Endif