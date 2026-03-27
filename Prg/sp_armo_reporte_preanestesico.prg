Lparameters paciente,hclinica

* prg: sp_armo_reporte_preanestesico
* 2019/11/21
* ----------------------------------

If !Used('mwkzabanestesia')
	Return .F.
Endif

If !Reccount('mwkzabanestesia')>0
	Return .F.
Endif

Public mPaciente,mHC,mVentilacion,mfechaimpre,mBarba

mBarba = 1

mPaciente = paciente
mHC = hclinica
mfechaimpre = sp_busco_fecha_serv('DD')

Select mwkzabanestesia

mVentilacion = ''
clinea = Chr(10)

If mwkzabanestesia.Zan_barba = 1
mVentilacion = mVentilacion + '- Presencia de Barba' + clinea
Endif

If mwkzabanestesia.Zan_edad55 = 1
mVentilacion = mVentilacion + '- Edad > a 55 años' + clinea
Endif

If mwkzabanestesia.Zan_obesidad = 1
mVentilacion = mVentilacion + '- Obesidad > 20%' + clinea
Endif

If mwkzabanestesia.Zan_FaltaDientes = 1
mVentilacion = mVentilacion + '- Falta de Dientes' + clinea
Endif

If mwkzabanestesia.Zan_Hroncador = 1
mVentilacion = mVentilacion + '- Historial de Roncador' + clinea
Endif

Report Form reppreanes1.frx To Printer Prompt Nodialog Preview