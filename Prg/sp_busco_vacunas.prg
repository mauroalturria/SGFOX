Parameters lnRegPac, lnIDdx, lnCodMed

* Para Probar el cartel solamente habilitar esto:
*lnRegPac = 15
*lnIDdx = 91
*lnCodMed = 33
* --------------------------


* -------------------------------------
* Recordatorio de Vacunación
* 2017/03/10 - Fabián
* -------------------------------------

ldesconecto = .F.
** Verifico la conexión con el servidor
If !Used("mwkserver1")
	Do sp_conexion
	ldesconecto = .T.
Endif

** Verifico que esté habilitado el módulo

lcSQL = "select * from tabestados where propietario = 7 and tipo = 33 and subestado = 0"
If !Prg_EjecutoSql(lcSQL,"mwkTabEstadoVacTemp")
	If ldesconecto
		Do sp_desconexion
	Endif
	Return .F.
Endif

If !Reccount("mwkTabEstadoVacTemp")>0
	Use In Select("mwkTabEstadoVacTemp")
	If ldesconecto
		Do sp_desconexion
	Endif
	Return
Endif

Select mwkTabEstadoVacTemp
If !mwkTabEstadoVacTemp.estado = 1
	Use In Select("mwkTabEstadoVacTemp")
	Return
	If ldesconecto
		Do sp_desconexion
	Endif
Endif

Use In Select("mwkTabEstadoVacTemp")

** Importo base de datos (Archivo DBF) con los diagnósticos

*!*	Use c:\Users\mfcastelli\documents\cie9ambulatorio.Dbf Again In 0 Alias mwkCie9Ambu
*!*	Select Cast(iddiagnost As Int) As idciap,* From mwkCie9Ambu Into Cursor mwkCie9DBF Readwrite
*!*	Use In mwkCie9Ambu
*!*	** Busco el diagnóstico si está dentro dentro de los solicitados
*!*	Select * From mwkCie9DBF Where idciap = lnIDdx Into Cursor mwk_dx_temp


** Verifico si está el dx contemplado

lcSQL = "select * from TabCiapRel where CR_Fecpasiva = '1900-01-01' and CR_IdCie9 = ?lnIDdx and CR_TipoRel = 1"
If !Prg_EjecutoSql(lcSQL,"mwk_dx_temp")
	If ldesconecto
		Do sp_desconexion
	Endif
	Return .F.
Endif

If !Reccount("mwk_dx_temp")>0
	If ldesconecto
		Do sp_desconexion
	Endif
	Return
Endif

** Busco si el paciente ya fue informado (Uso tabla TabVacunacion)

lcSQL = "Select * from TabVacunacion"
If !Prg_EjecutoSql(lcSQL,"mwkTabVacuna")
	If ldesconecto
		Do sp_desconexion
	Endif
	Return .F.
Endif
If ldesconecto
	Do sp_desconexion
Endif
Use In Select('mwkVacPac')
Use In Select('mwkVacPac0a')

Select * From mwkTabVacuna Where VAC_regpac = lnRegPac And VAC_codmed = lnCodMed Into Cursor mwkVacPac0a
Use Dbf('mwkVacPac0a') In 0 Alias mwkVacPac Again

If Reccount("mwkVacPac")>0
	Use In Select("mwk_dx_temp")
	Use In Select("mwkcie9dbf")
	Use In Select("mwkvacpac")
	Use In Select("mwktabvacuna")
	Return
Endif

** Llamo al formulario para completar los datos y grabar
mform = 'frmambula77'
Do Form &mform With lnRegPac, lnCodMed
