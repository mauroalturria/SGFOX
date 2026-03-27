****
** busco AC Prestaciones
****  
parameters madmis, mnrovale,midag,misubes,mNomCur
if vartype(mNomCur)#"C"
	mNomCur = "mwkACObs"
endif
mret = sqlexec(mcon1, "select APV_CodPrestSolic , APV_Estado , APV_IdAutPrevias"+;
	", PRE_descriprest, APV_CantAutorizada, APV_subestadopend,APV_CodAdmision,APV_CodPrestSolic   "+;
	", EstSE.descrip , EstSE.subestado,APV_IdAgrupador "+;
	", AutPrevias.id as autID, PRE_codservicio,TabAutObs.observa"+;
	"  "+;
	" from AutPrevias " + ;
	" inner join Prestacions on Pre_CodPrest = APV_CodPrestSolic "+;
	" inner join TabAutObs on Autprevias.ID = Tabautobs.IdAutPrevias "+;
	" inner Join TabEstados as EstSE on EstSE.Id = Tabautobs.estado "+;
	" where Autprevias.APV_Estado = 3 and EstSE.estado = 3 and APV_CodAdmision = ?madmis "+;
	" ", "mwkobsac")
 
if mret<1
	do Log_errores with error(), message(), message(1), program(), lineno()
	messagebox("ERROR EN LA GENERACION DEL CURSOR",48,"VALIDACION")
	return .f.
endif

select *,prg_busco_dato_estsolic(APV_CodAdmision ,apv_idautprevias,APV_CodPrestSolic ,1) as apv_codlado ;
	from mwkobsac;
	where APV_IdAgrupador = midag and APV_subestadopend= misubes and at( mnrovale,observa)>0 ;
	group by APV_CodPrestSolic order by APV_IdAutPrevias ;
	into cursor &mNomCur

