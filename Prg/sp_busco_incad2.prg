*
* Busqueda de Incidentes Adversos
*
Lparameters mwhere

*!*	mret = sqlexec(mcon1,"select TabLGIncAdP.id as lid,TIP_fechorainc,TIP_estado,TIP_area,TIP_idservicio,TIP_idhecho,TIP_idriesgo,"+;
*!*		"REG_nombrepac,REG_numdocumento,REG_nrohclinica,TIM_nombremed,TIP_idservicio2"+;
*!*		" from TabLGIncAdP"+;
*!*		" left outer join TabLGIncAdMed on TIM_idincidente=TabLGIncAdP.Id"+;
*!*		" left outer join registracio on REG_nroregistrac = TIP_nroregistrac " + mwhere,"mwkincadinf")


mret = SQLExec(mcon1,"select TabLGIncAdP.id as lid,TIP_fechorainc,TIP_estado,TIP_area,TIP_idservicio,TIP_idhecho,TIP_idriesgo,"+;
	"REG_nombrepac,REG_numdocumento,REG_nrohclinica,TIM_nombremed,TIP_idservicio2, TabLGIncAdCa.TIC_idincad as lidcaida "+;
	" from TabLGIncAdP"+;
	" left outer join TabLGIncAdCa on TIC_idincad = TabLGIncAdP.Id "+;
	" left outer join TabLGIncAdMed on TIM_idincidente=TabLGIncAdP.Id"+;
	" left outer join registracio on REG_nroregistrac = TIP_nroregistrac " + mwhere,"mwkincadinf")

If mret < 0
	
	Messagebox("EN BUSQUEDA DE INCIDENTES ADVERSOS",16,"ERROR")
	
Else

	Select lid,TIP_fechorainc,mwkestados.lestado As lestad2,;
		iif( TIP_area > 0, varea[TIP_area], 'N/D    ') As larea,;
		nvl(mwkServ.ser_descripserv,Space(30)) As lservicio,;
		nvl(mwkServicio.sdescripserv,Space(30)) As lservicio2,;
		nvl(mwkHechosg.TLH_descrip,Space(50)) As lhecho,;
		iif( TIP_idriesgo > 0, vriesgo[TIP_idriesgo], 'N/D    ') As lriesgo,;
		REG_nombrepac,REG_numdocumento,REG_nrohclinica,;
		nvl(TIM_nombremed,Space(40)) As lnombremed, Nvl(lidcaida,0) As idcaida  ;
		from mwkincadinf ;
		left Outer Join mwkestados On lidestado = TIP_estado;
		left Outer Join mwkServ On mwkServ.ser_codserv = TIP_idservicio;
		left Outer Join mwkServicio On mwkServicio.scodserv = TIP_idservicio2;
		left Outer Join mwkHechosg On mwkHechosg.TLH_idcod = TIP_idhecho;
		order By lid;
		into Cursor mwkincadinf2

Endif


