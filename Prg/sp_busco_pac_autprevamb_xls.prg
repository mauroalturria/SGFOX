parameters mbusco1, mNomCur

if vartype(mNomCur)# "C"
	mNomCur = "mwkpacamb"
endif

mbusco1 = upper(iif(vartype(mbusco1)#"C",'',mbusco1))

if !empty(mbusco1) and not ("WHERE" $ mbusco1)
	mbusco1 = "WHERE " + mbusco1
endif
if !used('mwkMedrpzte')
	do sp_busco_medrempzt_amb with ctod("01/01/1900"),'mwkMedamb' && MWKMEDRPZT
	do sp_busco_medrempzt with 1,,,,"INT"
	SELECT id, nombre, codesp, codespe, matricula,codambitomed  FROM mwkMedamb ;
	UNION ALL SELECT id, nombre,codesp,codespe,matricula ,1 as codambitomed ;
	FROM mwkMedicogua WHERE id NOT in (SELECT id FROM mwkMedamb  );
	INTO CURSOR mwkMedrpzte
endif
if !used('mwkserv')
	do sp_servicio with 4
endif

mccpoamb = ''
if mxambito >1
	mccpoamb = "  and Tabambulatorio.codambito = ?mxambito "
endif
use in select("tabestadosac")
use in select("Servicios")
USE IN SELECT("mwkpacac")
do sp_busco_estados with 26 , " order by descrip  ","Servicios"
do sp_busco_estados with 28 , " order by descrip  ","tabestadosac"
do sp_busco_estados with 23 ," order by descrip  ","tabsubestadosac"  &&& sub estados administrativos

msql =  "select " + ;
	"REGISTRACIO.REG_nroregistrac, REGISTRACIO.REG_nombrepac, REGISTRACIO.REG_email,  " + ;
	"REGISTRACIO.REG_nrohclinica, REGISTRACIO.REG_sexo, REGISTRACIO.REG_fecnacimiento, " + ;
	"Registracio.REG_numdocumento, REGISTRACIO.REG_telefonos,tabambulatorio.codent,"+;
	"TabAutPrevias.*,APL_Estado, APL_FecHora, APL_Observaciones,APL_Operador " + ;
	",INS_descriinsumo,pre_descriprest,descrabrev "+;
	"from TabAutPrevias " + ;
	"inner join registracio on TabAutPrevias.APV_registracio = REGISTRACIO.REG_nroregistrac " + ;
	"inner join tabambulatorio on TabAutPrevias.APV_protocolo = tabambulatorio.protocolo " + ;
	"inner join tabciap2e on tabciap2e.id = tabambulatorio.codcie9 " + ;
	"left join Tabautprevlog on tabciap2e.id = Tabautprevlog.APL_IdAutPrev " + ;
	" left join prestacions on TabAutPrevias.APV_CodPrestSolic = prestacions.PRE_codprest "+;
	" left join Insumos on Tabautprevias.APV_CodInsuSolic = Insumos.INS_codpuntero "+mccpoamb + mbusco1 


mret = sqlexec(mcon1,msql,"mwkpacacamb")
if mRet <= 0
	messagebox("ERROR DE LECTURA DE CB ",16,"ERROR")
	do log_errores with error(), message(), message(1), program(), lineno()
	return .f.
endif
msql =  "select " + ;
	"REGISTRACIO.REG_nroregistrac, REGISTRACIO.REG_nombrepac, REGISTRACIO.REG_email,  " + ;
	"REGISTRACIO.REG_nrohclinica, REGISTRACIO.REG_sexo, REGISTRACIO.REG_fecnacimiento, " + ;
	"Registracio.REG_numdocumento, REGISTRACIO.REG_telefonos,guardia.codent,"+;
	"TabAutPrevias.*,APL_Estado, APL_FecHora, APL_Observaciones,APL_Operador " + ;
	",INS_descriinsumo,pre_descriprest,descrabrev "+;
	"from TabAutPrevias " + ;
	"inner join registracio on TabAutPrevias.APV_registracio = REGISTRACIO.REG_nroregistrac " + ;
	"inner join guardia on TabAutPrevias.APV_protocolo = guardia.protocolo " + ;
	"inner join tabciap2e on tabciap2e.id = guardia.codcie9 " + ;
	"left join Tabautprevlog on tabciap2e.id = Tabautprevlog.APL_IdAutPrev " + ;
	" left join prestacions on TabAutPrevias.APV_CodPrestSolic = prestacions.PRE_codprest "+;
	" left join Insumos on Tabautprevias.APV_CodInsuSolic = Insumos.INS_codpuntero "+mccpoamb + mbusco1 


mret = sqlexec(mcon1,msql,"mwkpacacgua")
if mRet <= 0
	messagebox("ERROR DE LECTURA DE CB ",16,"ERROR")
	do log_errores with error(), message(), message(1), program(), lineno()
	return .f.
endif
Select * From mwkpacacamb Union All;
	SELECT * From mwkpacacgua ;
	into Cursor mwkpacac

select mwkpacac.*,Nombre,'' as medrempl,tabestadosac.descrip,matricula,tabestadosac.estado,;
    padr(alltrim(nvl(apv_descripsolic,''))+alltrim(nvl(ins_descriinsumo,''))+alltrim(nvl(pre_descriprest,'')),250) as solicitado,;
	Servicios.descrip as SER_descriprubro,ser_descripserv, ENT_descrient,ENT_nroprestadorexterno,ENT_codagrup,tabsubestadosac.Descrip as dessubestado ;
	,tabsubestadosac.tipo as tipocp,tabsubestadosac.subestado as subestadocp;
	from mwkpacac;
	left join mwkserv ON APV_servicio= ser_codserv ;
	left join Servicios on subestado = APV_servicio ;
	left join mwkMedrpzte on  APV_CodMedicoSolic = mwkMedrpzte.id;
	left join tabestadosac ON tabestadosac.subestado = APV_Estado ;
	left join tabsubestadosac on tabsubestadosac.estado = APV_subestadopend  ;
	left join mwkentidad on mwkpacac.codent = mwkentidad.ent_codent ;
	GROUP BY mwkpacac.id,APL_FecHora,APL_Estado;
	into  cursor &mNomCur
use in select("tabestadosac")
use in select("Servicios")
use in select("tabsubestadosac")
