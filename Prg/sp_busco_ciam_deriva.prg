*
* Armo cursor maestro Derivaciones Ciam
*
Lparameters mfecha,mpendien,moptg1,moptg2,mcbo1,mcbo2

If used('mwkciam')
	Use in mwkciam
Endif

If used('mwkciam0')
	Use in mwkciam0
Endif

mret = sqlexec(mcon1,"select TabCiamDeriva.ID as Nropedido,TCD_fechapedido,TCD_nombrepac,"+;
	"TCD_documento,ENT_descrient,TCD_internacion,TCD_diagnostico,TCD_estado,TCD_traslado,"+;
	"TCD_origen,TCD_FecEstado,TCD_solicdetid"+;
	" from TabCiamDeriva, ENTIDADES where TCD_entidad = ENT_codent"+;
	" and TCD_fechapedido >= ?mfecha","mwkciam0")
	
*!* " and TCD_fechapasiva is null"+;
*!*	Se quito la validación x fecha pasiva, ya que no se implementa la posibilidad de pasivar movimientos,
*!* caso contrario hay que crear un indice, conversado c/Nico

If mret < 0
	Messagebox("ERROR EN BUSQUEDA DE DERIVACIONES, AVISE A SISTEMAS",0+48,"Validación")
	Return
Endif

If reccount('mwkciam0') > 0
	If used('mwkciam')
		Use in mwkciam
	Endif
	
	If mpendien = 1 && Solo pendientes
		mwhere='TCD_estado = mwkTabEstados.SubEstado and mwkTabEstados.Tipo = 0 '
	Else            && Todos, por ahora valido tipo 0 y 1
		mwhere='TCD_estado = mwkTabEstados.SubEstado and mwkTabEstados.Tipo >= 0 '
	Endif
	If moptg1 = 2 && Estado Todos ó Uno
		mwhere = mwhere +'and TCD_estado = mcbo1 '	 && Si es Uno
	Endif
	If moptg2 = 2 && Tipo de Internacion Todos ó Uno
		mwhere = mwhere + 'and TCD_internacion = mcbo2' && Si es Uno
	Endif

	mactual = sp_busco_fecha_serv('DT')

	Select Nropedido,TCD_fechapedido,TCD_nombrepac,TCD_documento,ENT_descrient,mwksecint.descrip as TInternacion,;
		TCD_diagnostico,;
		iif(mwkTabEstados.Tipo=0,prg_dif_horaria(TCD_FecEstado  ,mactual,'D',3),space(12)) as TCD_dEstado,;
		iif(mwkTabEstados.Tipo=0,prg_dif_horaria(TCD_fechapedido,mactual,'D'),space(12)) as TCD_dInicio,;
		mwkTabTraslado.descrip as TrasladoDes,mwkTabEstados.descrip as EstadoDes,;
		TCD_estado,TCD_traslado,TCD_internacion,TCD_origen,TCD_solicdetid ;
		from mwkciam0,mwkTabEstados,mwkTabTraslado,mwksecint ;
		where &mwhere and TCD_traslado=mwkTabTraslado.SubEstado and TCD_internacion = mwksecint.id;
		order by Nropedido desc into cursor mwkciam
		
	Select Nropedido,TCD_fechapedido,TCD_nombrepac,TCD_documento,ENT_descrient,TInternacion,;
		TCD_diagnostico,left(TCD_dEstado,8) as TCD_dEstado,left(TCD_dInicio,8) as TCD_dInicio,;
		TrasladoDes,EstadoDes,TCD_estado,TCD_traslado,;
		TCD_internacion,TCD_origen,TCD_solicdetid,right(TCD_dEstado,1) as TCD_pcontrol from mwkciam;
		into cursor mwkciam
				
Endif

Return
