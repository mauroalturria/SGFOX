parameters mbusco1,mfechacir, mNomCur

if vartype(mNomCur)# "C"
	mNomCur = "mwkpacquir"
endif
mfechacir= mfechacir-30
mbusco1 = upper(iif(vartype(mbusco1)#"C",'',mbusco1))

if !empty(mbusco1) and not ("WHERE" $ mbusco1)
	mbusco1 = "WHERE " + mbusco1
endif
do sp_busco_estados with 27 ," order by descrip  ","mwkestACint"  &&& sub estados
mccpoamb = ''

mret = sqlexec(mcon1, "select " + ;
	"AutPrevias.*  " + ;
	"from AutPrevias " + ;
	mbusco1 , "mwkpacautprov")

if mRet <= 0
	messagebox("ERROR DE LECTURA DE CB ",16,"ERROR")
	do log_errores with error(), message(), message(1), program(), lineno()
	return .f.
endif
select mwkpacautprov.*, a.Descrip,a.estado,PADR(IIF(apv_presinsu="M","MATERIALES","PROCEDIMIENTO QUIRURGICO"),30) as SER_descripserv,b.descrip as subestado from mwkpacautprov ;
	left join mwkestACint a on a.id = mwkpacautprov.APV_Estado ;
	left join mwkestACint b on a.id = mwkpacautprov.APV_subestadopend  ;
	WHERE  APV_FechaCirugia>= mfechacir into cursor &mNomCur
