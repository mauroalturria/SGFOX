Parameters mWhere,mfechaCitaD,mfechaCitaH

mret  = sqlexec(mcon1,"select leg_apellido,leg_Nombre,Leg_id from legajos "  ,"MwkLegajo")
If mret < 0
	=aerr(eros)
	Messagebox(eros(3))
Endif

*set step on

mret  =  sqlexec(mcon1," SELECT Certificado,Diagnostico,JustifDias,JustifFechaD,FecHoraAtenc,"+;
	" ProbAltaFec,JustifFechaH,ReducHoraD ,TareaLivFechad,ReducHoraH,TareaLivFechah "+;
	",CitaFecha,CitaHora,ReducCantHora,Justificacion,Legajo,MedAsistente,ObservAlta,JustifObserv "+;
	"  ,TareaLiv,ReducHora,TipoCita,TipoDeConcu,FecAlta,Apto,AptoFecha,observaciones,justifhorad,"+;
	"justifhorah,CitaEstado,reg_nombrePac  as Personal,TabMlcita.id,registracio as leg_id ,CitaEstado  "+;
	"FROM TabMlcita left join registracio on registracio.registracio = TABmlcita.registracion "+;
	" where CitaFecha >=?mfechaCitaD and CitaFecha<?mfechaCitaD ","mwkBuscaCita01")


mret  =  sqlexec(mcon1," SELECT Certificado,Diagnostico,JustifDias,JustifFechaD,FecHoraAtenc,"+;
	" ProbAltaFec,JustifFechaH,ReducHoraD ,TareaLivFechad,ReducHoraH,TareaLivFechah "+;
	",CitaFecha,CitaHora,ReducCantHora,Justificacion,Legajo,MedAsistente,ObservAlta,JustifObserv "+;
	"  ,TareaLiv,ReducHora,TipoCita,TipoDeConcu,FecAlta,Apto,AptoFecha,observaciones,justifhorad,"+;
	"justifhorah,CitaEstado,TabMlcita.id,CitaEstado   "+;
	" FROM TabMlcita   "+;
	" where CitaFecha >=?mfechaCitaD and CitaFecha<?mfechaCitaH ","mwkBuscaCita_02")

Select *,leg_nombre as Personal,leg_id from mwkBuscaCita_02 ;
	left join MwkLegajo on leg_id = legajo into cursor mwkBuscaCita02

Select * from mwkBuscaCita01;
	union all ;
	select * from mwkBuscaCita02;
	into cursor mwkBuscaCita

lcCursor = " SELECT Personal,IIF(isnull(MLINE(Diagnostico,1)),'',MLINE(Diagnostico,1)) as Diagnostico,"+;
	" IIF(isnull(MLINE(observaciones,1)),'',MLINE(observaciones,1)) as observaciones,MedAsistente,Certificado,"+;
	" JustifDias,JustifFechaD,FecHoraAtenc,"+;
	" ProbAltaFec,JustifFechaH,ReducHoraD ,TareaLivFechad,ReducHoraH,TareaLivFechah "+;
	",CitaFecha,CitaHora,ReducCantHora,Justificacion,Legajo,"+;
	" ObservAlta,JustifObserv "+;
	" ,TareaLiv,ReducHora,TipoCita,TipoDeConcu,"+;
	" FecAlta,Apto,AptoFecha,justifhorad,"+;
	" justifhorah,CitaEstado,id,Fintrat  "+;
	" FROM mwkBuscaCita "+ mWhere + " into cursor mwkHoraCitaSelec "

&lcCursor
If mret < 0
	=aerr(eros)
	Messagebox(eros(3))
Endif
