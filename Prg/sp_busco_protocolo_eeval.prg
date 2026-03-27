Lparameters mfechades, mfechahas
*!*	clear
*!*	Do sp_conexion
*!*	mfechades = Date() - 4002
*!*	mfechahas = Date()

mf1 = prg_dtoc(mfechades)
mf2 = prg_dtoc(mfechahas+1)


mret = SQLExec(mcon1, "select Tabguaevol.Eg_Evolucion, guardia.protocolo, Val_CodAdmision, reg_nrohclinica," + ;
	"nroregistrac, fechahoraing, "+;
	"Registracio.Reg_NombrePac, Registracio.REG_nrohclinica, " + ;
	"Entidades.Ent_CodEnt, Entidades.Ent_Descrient, " + ;
	"guardia.FechaHoraing, guardia.FechaHoraate, " + ;
	"Prestadores.Nombre as Prof, Prestadores.Matriculas " + ;
	"from valesasist, Tabguaevol,Prestadores,guardia  " + ;
	"left outer join entidades 	on guardia.codent = entidades.ent_codent " + ;
	"left outer join  registracio on guardia.nroregistrac = registracio.reg_nroregistrac " + ;
	"left outer join guardiavale on guardia.protocolo = guardiavale.protocolo " + ;
	"where " + ;
	"Tabguaevol.Eg_NroRegistrac = guardia.nroregistrac And " + ;
	"Tabguaevol.Eg_Protocolo = guardia.protocolo And " + ;
	" Tabguaevol.EG_codMed = Prestadores.Id and " + ;
	"guardiavale.nrovale = val_codvaleasist and "+;
	"val_codservvale in ( 8000,2150,6500,9600) and "+;
	"guardia.fechahoraing >= ?mf1 and " + ;
	"guardia.fechahoraing < ?mf2 And " +  ;
	"EG_codmed > 0 And EG_codmed <= 9999 " + ;
	" Union All " + ;
"select Tabguaevol.Eg_Evolucion, guardia.protocolo, Val_CodAdmision, reg_nrohclinica," + ;
	"nroregistrac, fechahoraing, "+;
	"Registracio.Reg_NombrePac, Registracio.REG_nrohclinica, " + ;
	"Entidades.Ent_CodEnt, Entidades.Ent_Descrient, " + ;
	"guardia.FechaHoraing, guardia.FechaHoraate, " + ;
	"TabMedExterno.Nombre as Prof, TabMedExterno.Matricula as Matriculas " + ;
	"from guardia,valesasist,Tabguaevol,TabMedExterno  "+;
	"left outer join entidades on guardia.codent = entidades.ent_codent " + ;
	"left outer join  registracio on guardia.nroregistrac = registracio.reg_nroregistrac " + ;
	"left outer join guardiavale on guardia.protocolo = guardiavale.protocolo " + ;
	"where " + ;
	"Tabguaevol.Eg_NroRegistrac = guardia.nroregistrac And " + ;
	"Tabguaevol.Eg_Protocolo = guardia.protocolo And " + ;
	"guardiavale.nrovale = val_codvaleasist and "  +;
	"val_codservvale in ( 8000,2150,6500,9600) and "+;
	"guardia.fechahoraing >= ?mf1 and " + ;
	"guardia.fechahoraing < ?mf2 " + ;
	" And Tabguaevol.EG_codMed = TabMedExterno.Id " + ;
	" And EG_codmed > 9999 ", "mwkprotquir0")
	

If mRet < 0 
	MessageBox("ERROR EN LA GENERACION , AVISAR A SISTEMAS",16, "Validacion") 
	DO sp_desconexion WITH "error"
	Cancel 
else
	select * from mwkprotquir0 where !empty(nvl(EG_Evolucion));
		order by FechaHoraing into cursor mwkprotquir
EndIf