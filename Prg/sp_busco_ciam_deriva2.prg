*
* Busqueda de Derivaciones por fecha / nombre aproximacion
*
Parameters mfedcon,mfehcon,mnom

mfed = prg_dtoc(mfedcon)
mfeh = prg_dtoc(mfehcon + 1)

mbuscar = " and TCD_fechapedido >= ?mfed and TCD_fechapedido < ?mfeh"

If !empty(mnom)
	mbuscar = " and TCD_nombrepac like '%" + alltrim(mnom) + "%'"
Endif

If used('mwkciam')
	Use in mwkciam
Endif

If used('mwkciam2')
	Use in mwkciam2
Endif

mret = sqlexec(mcon1,"select TabCiamDeriva.ID as Nropedido,TCD_fechapedido,TCD_nombrepac,TCD_documento,"+;
	"ENT_descrient,TCD_internacion,TCD_diagnostico,TCD_estado,TCD_traslado,TCD_origen,"+;
	"TCD_FecEstado,TCD_solicdetid,"+;
	"TCD_nroafi,TCD_txtedad,TCD_ubicacion,TCD_detalle,TCD_entidad"+;
	" from TabCiamDeriva, ENTIDADES"+;
	" where TCD_entidad = ENT_codent" + mbuscar,"mwkciam2")

*!* and TCD_fechapasiva is null

If mret < 0
	Messagebox("EN CONSULTA DE DERIVACIONES",16,"ERROR")
Else
	If used('mwkciam2')
		If reccount('mwkciam2')>0
			mwhere=' TCD_estado = mwkTabEstados.SubEstado and mwkTabEstados.Tipo >= 0 '
			mactual = sp_busco_fecha_serv('DT')
			Select Nropedido,TCD_fechapedido,TCD_nombrepac,TCD_documento,ENT_descrient,;
				mwksecint.descrip as TInternacion,;
				TCD_diagnostico,;
				iif(mwkTabEstados.Tipo=0,prg_dif_horaria(TCD_FecEstado,mactual,'D'),'') as TCD_dEstado,;
				iif(mwkTabEstados.Tipo=0,prg_dif_horaria(TCD_fechapedido,mactual,'D'),'') as TCD_dInicio,;
				mwkTabTraslado.descrip as TrasladoDes,mwkTabEstados.descrip as EstadoDes,;
				TCD_estado,TCD_traslado,TCD_internacion,TCD_origen,TCD_solicdetid ;
				,TCD_nroafi,TCD_txtedad,TCD_ubicacion,TCD_detalle,TCD_entidad ;
				from mwkciam2,mwkTabEstados,mwkTabTraslado,mwksecint ;
				where &mwhere and TCD_traslado=mwkTabTraslado.SubEstado and TCD_internacion = mwksecint.id;
				order by Nropedido desc into cursor mwkciam
		Endif
	Endif
Endif

