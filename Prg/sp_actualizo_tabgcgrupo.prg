* Actualizacion de la tabla de perfiles tabgcgrupo.
* Parametros : Id de la tabla (en el caso que sea modificacion) y Descripcion.
LPARAMETERS nID,strDescr
LOCAL mDescID as String
LOCAL mIdGrupo as Number

If nID = 0   &&damos de alta. Ver de actualizar tabgcgrupodoc

* Por las dudas que no hayan sido cerradas.
	Use In Select("mwktmpproc")

	Use In Select("mwktmpgrupo")

* Creamos una descripcion identificable para luego obtener el ID.
	mDescID = Alltrim(strDescr)+ mwkusuario.idusuario + Ttoc(sp_busco_fecha_serv("DT"))

* Insertamos el registro.
	mRet = SQLExec(mcon1,"insert into tabgcgrupo (descr) values (?mDescID)")

	If mRet = 1
        * Obtenemos el Id para actualizar tabgcgrupo
		mRet = SQLExec(mcon1,"select id from tabgcgrupo where descr = ?mDescID","mwktmpgrupo")
		mIdGrupo = mwktmpgrupo.Id
	Endif

	If mRet = 1
        * Acualizo correctamente la descripcion de la tabla tabgcgrupo, quitandole el usuario y fecha.
		mRet = SQLExec(mcon1,"update tabgcgrupo set descr = ?strDescr where id = ?mIdGrupo")
	Endif

*!*	   If mRet = 1
*!*	   * Obtener todos los procedimiento para TIPO = 1 y 2.
*!*	   	mRet = SQLExec(mcon1,"select id,tipo from tabgcproc where tipo in (1,2)","mwktmpproc")
*!*	   Endif

*!*	   If mRet = 1
*!*	   * Iteramos sobre el cursor y grabamos el documento.
*!*	   	Select ("mwktmpproc")
*!*	   	Scan
*!*	   		Do sp_actualizo_tabgcgrupodoc With mwktmpproc.Id,mwktmpgrupo.Id,Ctod("01/01/1900")
*!*	   	Endscan
*!*	   Endif
*!*
*!*	   * Cerramos las areas en usadas temporalmente.
*!*	   USE IN SELECT("mwktmpproc")

	Use In Select("mwktmpgrupo")


Else   &&modificamos.
	mRet = SQLExec(mcon1,"update tabgcgrupo set descr = ?strDescr where ID = ?nID")
Endif

If mRet<=0
	Messagebox("ERROR EN LA ACTUALIZACION DE DATOS. AVISE A SISTEMAS.",26,"ERROR")
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Else
	Return .T.
Endif