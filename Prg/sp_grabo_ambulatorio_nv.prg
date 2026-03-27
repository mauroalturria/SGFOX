*
* Graba protocolo de la atencion
*
Parameters  mregi, mfate, mfing, mcodent, mcpre, mcmed, mcodpun,;
	mcest, musua, mcua, mprotocolo, mdemanda

mfHoy     = sp_busco_fecha_serv('DD')
mprot_aux = left(allt(mwkusuario.idusuario),5)+padl(int(seconds()),5,'0')
mfctrl    = mfing - 3600

If mcua = 1
	If used("mwkambctrl")
		Use in mwkambctrl
	Endif
	mret = sqlexec(mcon1,"select id,protocolo from TabAtencion where"+;
		" codent = ?mcodent"+;
		" and nroregistrac = ?mregi"+;
		" and codmed = ?mcmed"+;
		" and fechahoraing >= ?mfctrl and codestado = 1 "+;
		" and usuario = ?musua","mwkambctrl")
	If mret < 0
		Messagebox("EN CONSULTA AMBULATORIO, PROTOCOLOS PREVIOS"+chr(10)+;
			"AVISE A SISTEMAS",16,"ERROR")
	Else
		If used("mwkambctrl")
			If reccount("mwkambctrl")>0
				Select mwkambctrl
				Go top 
				mid = mwkambctrl.id	
				mret = sqlexec(mcon1, "Select Protocolo from TabAtencion Where id = ?mId ", "mwkAuxAmb" )
				mprotocolo = mwkambctrl.protocolo
				mcua = 2
			Endif
			Use in mwkambctrl
		Endif
	Endif
Endif

mcest = iif(mcua < 3, 1, mcua)
mprot = iif(mcua = 1, alltrim(mprot_aux), mprotocolo)
&& codCIE9, codent, codestado,codmed, fechahoraate, fechahoraing,tipoPac,usuario
mret = sqlexec(mcon1, "insert into TabAtencion (" + ;
	"protocolo, nroregistrac,fechahoraate, fechahoraing, tipoPac, " + ;
	"codent, codmed, nrovale, codestado, usuario) " + ;
	"values(" + ;
	"?mprot ,?mregi,?mfate, ?mfing, 'AMB', " + ;
	"?mcodent, ?mcmed, ?mcodpun, ?mcest, ?musua)")
mret = sqlexec(mcon1, "insert into TabAtencion (" + ;
	"protocolo, nroregistrac,demanda, fechahoraate, fechahoraing, " + ;
	"codent, codprest, codmed, nrovale, codestado, usuario) " + ;
	"values(" + ;
	"?mprot ,?mregi,?mdemanda, ?mfate, ?mfing, " + ;
	"?mcodent, ?mcpre, ?mcmed, ?mcodpun, ?mcest, ?musua)")

If mret < 0
	=aerr(eros)
	mmsgerr  = eros(3)
	mdetalle = mprot + chr(9) + transform(mregi) + chr(9) + transform(mfate) ;
		+ chr(9) + transform(mfing) + chr(9) + transform(mcodent) ;
		+ chr(9) + transform(mcpre) + chr(9) + transform(mcest)

	Do sp_insert_tabCtrlErr with mdetalle, mmsgerr , mwkusuario.idusuario, program(0)

	Messagebox("ERROR EN LA ACTUALIZACION",48, "VALIDACION")
*!*	Do prg_cancelo

Endif

If  mcua = 1
&& Actualizo el Protocolo
	mret = sqlexec(mcon1, "Select * from TabAtencion Where Protocolo = ?mprot_aux ", "mwkAuxAmb" )
	If mret < 0
		Messagebox("ERROR EN LA LECTURA",48, "VALIDACION")
	Endif
	Select mwkAuxAmb
	Go bottom
	mProto = padl(alltrim(str(id)),8,"0") + "-" + right(dtoc(mfHoy),2)
	mId  = id
	mret = sqlexec(mcon1, "Update TabAtencion Set Protocolo = ?mProto Where id = ?mid " )
	mret = sqlexec(mcon1, "Select Protocolo from TabAtencion Where id = ?mId ", "mwkAuxAmb" )
Endif
