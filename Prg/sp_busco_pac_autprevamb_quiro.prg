parameters mbusco1, mNomCur

if vartype(mNomCur)# "C"
	mNomCur = "mwkpacamb"
endif

mbusco1 = upper(iif(vartype(mbusco1)#"C",'',mbusco1))

if !empty(mbusco1) and not ("WHERE" $ mbusco1)
	mbusco1 = "WHERE " + mbusco1
endif
do sp_busco_estados with 23 ," order by descrip  ","mwkestACAdm"  &&& sub estados administrativos

mccpoamb = ''

mret = sqlexec(mcon1, "select " + ;
	"TabAutPrevias.* , Servicios.SER_descripserv, a.Descrip,a.estado,Tabmedexterno.nombre,prestadores.nombre as nommed, " + ;
	"tabbacteriotipomuestra.ID as IdTipoMuestra, tabbacteriotipomuestra.BAC_codigomuestra, tabbacteriotipomuestra.BAC_descripmuestra " +;
	"from TabAutPrevias " + ;
	"Inner join tabestados as a on (a.subestado = TabAutPrevias.APV_Estado and a.propietario = 28) " + ;
	"left join prestadores on prestadores.id = TabAutPrevias.APV_codmedicosolic "   +  ;
	"left join Tabmedexterno on Tabmedexterno.id = TabAutPrevias.APV_codmedicosolic "   +  ;
	" left join tabbacteriotipomuestra on TabAutPrevias.APV_codmuestra = tabbacteriotipomuestra.id " +;
	"inner join servicios on Servicios.SER_codserv = TabAutPrevias.APV_servicio  " + mbusco1 +  ;
	" ", "mwkpacautprov")

if mRet <= 0
	messagebox("ERROR DE LECTURA DE CB ",16,"ERROR")
	do log_errores with error(), message(), message(1), program(), lineno()
	return .f.
endif
select mwkpacautprov.*,mwkestACAdm.descrip as subestado from mwkpacautprov ;
	left join mwkestACAdm on mwkestACAdm.estado = mwkpacautprov.APV_subestadopend  ;
	ORDER BY APV_FechaCirugia desc, mwkpacautprov.ID;
	into cursor &mNomCur
