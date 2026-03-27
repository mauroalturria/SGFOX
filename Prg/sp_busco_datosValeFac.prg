LPARAMETERS mCodAdmision,mVale,mCodPrest


**Datos de Valesasist
USE IN SELECT("mwkDatosVale")

mRet = SQLEXEC(mcon1,"select valesasist.val_codservvale,valesasist.val_codmnemoserv,valesasist.val_codsector " +;
"from valesasist " + ;
"where valesasist.VAL_CODVALEASIST	= ?mVale","mwkDatosVale")

If mRet<=0
	Messagebox("ERROR EN LA BUSQUEDA DE DATOS DEL VALE",26,"ERROR")
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	RETURN .f.
Endif

**Datos del Afiliado
mCodent = mwkEntidad.entidad

USE IN SELECT("mwkAfiliado")
mret = SQLEXEC(mcon1,"select a.pac_codhci as nroregistrac,b.afi_nroafiliado, " + ;
"c.reg_nrohclinica,c.reg_telefonos,c.reg_domicilio,c.reg_numdocumento " + ;
"from pacientes as a " + ;
"inner join afiliacion as b on a.pac_codhci = b.registracio and b.afi_codentidad = ?mCodent " + ;
"left join registracio as c on b.registracio = c.reg_nroregistrac " + ;
"where a.pac_codadmision = ?mCodAdmision","mwkAfiliado")


If mRet<=0
	Messagebox("ERROR EN LA BUSQUEDA DE AFILIADO",26,"ERROR")
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	RETURN .f.
ENDIF

**Datos de Especialidad
USE IN SELECT("mwkEspecialidad")

mRet = SQLEXEC(mcon1,"select especialid.esp_descripcion " +;
"from PRESTACIONS " + ;
"left join especialid on prestacions.pre_especialidad = especialid.esp_codesp " + ;
"where prestacions.pre_codprest	= ?mCodPrest ","mwkEspecialidad")

If mRet<=0
	Messagebox("ERROR EN LA BUSQUEDA DE ESPECIALIDAD",26,"ERROR")
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	RETURN .f.
ENDIF


RETURN .t.