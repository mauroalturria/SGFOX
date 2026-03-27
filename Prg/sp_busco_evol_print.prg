****
** Armo evolucion del paciente
****
parameter madmis,msec,mdesde,mhasta,mfiltroe,mfiltroIC,mfiltroBH,mfiltroNur,mcopciones,mtipo,micur
* mtipo  M hce medica,E Epicrisis,N Enfermeria,R Resumen de historia


if vartype(mfiltroe)#"C"
	mfiltroe = ''
	mfiltroIC = ''
	mfiltroBH = ''
	mfiltroNur = ''
endif
mfiltroep = " and 1=2 "
mtipusu = 9
if !empty(mcopciones)
	mtipusu = IIF(mtipo="N",2,IIF(mtipo="M",1,0 ) )
	mfiltroep = "and EIP_tipoEvol in (&mcopciones) and EIP_fechah>= ?mdesde and EIP_fechah < ?mhasta "
endif
if vartype(lred)#"N"
	lred= 0
endif
do case
	case inlist(mtipo,'E','N','R')
		mret = sqlexec(mcon1, "SELECT pacientes.Pac_codhci,TabintHCE.*,TabintEvol.*"+;
			",Tabcie10.descrip as Eg_motconsulta,mte_descripcion "+;
			" FROM pacientes "+;
			" inner join TabintHCE on pacientes.pac_codadmision = tabintHCE.IH_admision " + ;
			" left join TabintEvol on tabintHCE.id = tabintevol.EI_idevol " + ;
			" left join TabCie10 on TabCie10.id = TabintHCE.IH_motIngreso " + ;
			" left join motivoegreso on  mte_codmotivo = pac_motivoalta " + ;
			" where pac_codadmision = ?madmis and IH_secuencia = ?msec " , "mwkEvolInt01")
		if mret < 0
			=aerr(eros)
			messagebox("ERROR de LECTURA , AVISAR A SISTEMAS", 48, "Validacion")
		else
			select mwkevolint01.*,datetime() as fechaevol,medcab.nombre as nombrecab,medcab.matriculas as matcab ;
				from mwkevolint01 ;
				INNER join mwkmedicointall as medcab on medcab.id = ih_codmed;
				order by mwkevolint01.id  ;
				GROUP by mwkevolint01.id  ;
				into cursor &micur
		endif
	case inlist(mtipo,'M')
		mret = sqlexec(mcon1, "select  TabIntAnam.* "+;
			" FROM pacientes "+;
			" inner join TabintHCE on pacientes.pac_codadmision = tabintHCE.IH_admision " + ;
			" inner join TabIntAnam on TabIntAnam.IA_idevol = tabintHCE.id"+;
			" where pac_codadmision = ?madmis "  , "mwkhistanam")

		mret = sqlexec(mcon1, "select  TabIntevolIC.*,nomape,tabusuario.idcodmed "+;
			" FROM pacientes "+;
			" inner join TabintHCE on pacientes.pac_codadmision = tabintHCE.IH_admision " + ;
			" inner join TabIntevolIC on TabIntevolIC.EIC_idevol = tabintHCE.id"+;
			" inner join tabusuario on tabusuario.id = TabIntevolIC.EIC_usuario " + ;
			" where pac_codadmision = ?madmis and IH_secuencia = ?msec "+mfiltroIC   +" group by TabIntevolIC.id", "mwkhistICa")
		mfiltroicK = strtran(mfiltroic,"EIC","EIK")
		mret = sqlexec(mcon1, "SELECT TabIntEvolKine.*,nomape,tabusuario.idcodmed "+;
			" FROM TabIntEvolKine"+;
			" inner join TabintHCE on  tabintHCE.id = TabIntEvolKine.EIK_idevol " + ;
			" inner join tabusuario on tabusuario.idcodmed = TabIntEvolKine. EIK_codmed " + ;
			" where tabintHCE.IH_admision = ?madmis  and IH_secuencia = ?msec "+mfiltroICK+;
			" group by TabIntEvolKine.id " , "mwkhistkinea")

		select val(dtos(EIK_fechaHora)) as id, iif(EIK_tipo=1,"AKR ","AKM ") as EIC_codesp,000000 as EIC_codpun,EIK_evoluc as EIC_evolIC, ;
			EIK_fechaHora as EIC_fechaHora,EIK_idevol as EIC_idevol,;
			EIK_codmed as EIC_usuario,nomape,idcodmed;
			from mwkhistkinea ;
			union all select * from mwkhistICa into cursor mwkhistICb
		select mwkhistICb.*,medic.matriculas ;
			from mwkhistICb ;
			INNER join mwkmedicointall as medic on medic.id = idcodmed;
			order by EIC_fechaHora  ;
			into cursor mwkhistIC

		mret = sqlexec(mcon1, "SELECT pacientes.Pac_codhci,TabintHCE.*,TabintEvol.*,TabintEvolmed.id as id2 "+;
			", EIM_GAtipoHD,EIM_Ccultivo,eim_fechah,eim_evol,eim_codmed,eim_aislamiento"+;
			",Tabcie10.descrip as Eg_motconsulta,mte_descripcion  "+;
			" FROM pacientes "+;
			" inner join TabintHCE on pacientes.pac_codadmision = tabintHCE.IH_admision " + ;
			" left join TabintEvol ON tabintHCE.id = tabintevol.EI_idevol  "+ ;
			" left join tabintevolmed on tabintevolmed.EIM_idevol = tabintHCE.id " + ;
			" left join TabCie10 on TabCie10.id = TabintHCE.IH_motIngreso " + ;
			" left join motivoegreso on  mte_codmotivo = pac_motivoalta " + ;
			" where pac_codadmision = ?madmis  and IH_secuencia = ?msec " +mfiltroe+" group by tabintevolmed.id", "mwkEvolInt01")
		if reccount("mwkEvolInt01")=0
			mret = sqlexec(mcon1, "SELECT pacientes.Pac_codhci,TabintHCE.*,TabintEvol.*,TabintEvolmed.id as id2 "+;
				", EIM_GAtipoHD,EIM_Ccultivo,eim_fechah,eim_evol,eim_codmed,eim_aislamiento "+;
				",Tabcie10.descrip as Eg_motconsulta,mte_descripcion,tabintevolmed.id "+;
				" FROM pacientes "+;
				" inner join TabintHCE on pacientes.pac_codadmision = tabintHCE.IH_admision " + ;
				" left join TabintEvol ON tabintHCE.id = tabintevol.EI_idevol  "+ ;
				" left join tabintevolmed on tabintevolmed.EIM_idevol = tabintHCE.id " + ;
				" left join TabCie10 on TabCie10.id = TabintHCE.IH_motIngreso " + ;
				" left join motivoegreso on  mte_codmotivo = pac_motivoalta " + ;
				" where pac_codadmision = ?madmis and IH_secuencia = ?msec  "+" group by tabintevolmed.id" , "mwkEvolInt01")
		endif

		if mret < 0
			=aerr(eros)
			messagebox("ERROR de LECTURA , AVISAR A SISTEMAS", 48, "Validacion")
		else
			select mwkevolint01.*,nvl(EIM_fechah,datetime()) as fechaevol,medcab.nombre as nombrecab,medcab.matriculas as matcab ;
				, medevol.nombre as nombreevol ,medevol.matriculas as matevol ;
				from mwkevolint01 ;
				INNER join mwkmedicointall as medcab on medcab.id = ih_codmed;
				left join mwkmedicointall as medevol on medevol.id = nvl(eim_codmed,1);
				order by fechaevol desc ;
				into cursor mwkevolint

			select * from mwkevolint ;
				group by id2 ;
				order by fechaevol desc;
				into cursor &micur

		endif
endcase
do case
	case inlist(mtipo,'N')

		mret = sqlexec(mcon1, "select EIN_codCIENanda,EIN_evolNurse ,EIN_fechaH, EIN_parAdmF ,EIN_parAlerg "+;
			",EIN_parAlergQue ,EIN_parOtros ,EIN_idevol ,EIN_usuario->nomape from TabIntEvolNurse"+;
			" inner join TabintHCE on EIN_idevol = TabintHCE.id "+;
			" inner join pacientes on pacientes.pac_codadmision = tabintHCE.IH_admision " + ;
			" where pac_codadmision = ?madmis and IH_secuencia = ?msec  &mfiltroNur order by EIN_fechaH "  , "mwkevolNur")
	case inlist(mtipo,'R')
		mret = sqlexec(mcon1, "SELECT top 10 TabIntResumenHC.*,nomape as nombre,idcodmed,tabusuario.codigovax  "+;
			" FROM TabIntResumenHC "+;
			" inner join tabusuario on tabusuario.id = TabIntResumenHC.RH_usuario " + ;
			" inner join TabintHCE on  tabintHCE.id = TabIntResumenHC.RH_idevol    " + ;
			" where tabintHCE.IH_admision = ?madmis  and IH_secuencia = ?msec "+;
			"group by TabIntResumenHC.id order by TabIntResumenHC.id desc ", "mwkreshc")
endcase

mret = sqlexec(mcon1, "select TabIntEvolParcial.* ,EIP_usuario->nomape  "+;
	" from TabIntEvolParcial "+;
	" inner join TabintHCE on EIP_idevol = TabintHCE.id "+;
	" where IH_admision = ?madmis and IH_secuencia = ?msec and  EIP_tipoUsuario = ?mtipusu  &mfiltroep order by EIP_fechaH "  , "mwkevolparcial")


if mret < 0
	=aerr(eros)
	messagebox("ERROR de LECTURA , AVISAR A SISTEMAS", 48, "Validacion")
endif


