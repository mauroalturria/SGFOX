*****
** Busco Protocolo - Historia de Vales - Consumos
****

Parameter madmision,msec

mret = sqlexec(mcon1, "select pac_codadmision, REG_nombrepac, EI_fechaHora , EI_horaCierre , EI_secuencia," + ;
	" nombre, EI_codestado, EI_codcie, EI_codmed,  EI_codmedcie,REG_nroregistrac, REG_nrohclinica,"+;
	" reg_domicilio,reg_telefonos,reg_fecnacimiento,TPV_Estado,reg_sexo," + ;
	" reg_localidad,reg_provincia "+;
	" from pacientes "+;
	" inner join registracio on pac_codhci = REG_nroregistrac  "+ ;
	" left outer join TabPacVip on registracio.REG_nroregistrac = TabPacVip.TPV_NroReg " + ;
	" left join TabintHCE on pacientes.pac_codadmision = tabintHCE.IH_admision " + ;
	" left outer join TabIntEvol on tabintHCE.id = TabIntEvol.EI_idevol " + ;
	" left outer join prestadores on TabIntEvol.EI_codmed = prestadores.id " + ;
	" left outer join motivoegreso on TabIntEvol.EI_codestado = motivoegreso.id " + ;
	"where pac_codadmision = ?madmision"  , "mwkintevol")
	
If mret < 0
	=aerr(eros)
	Messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16,"Validacion")
	Messagebox(eros(3))
	Do sp_desconexion with "Err sp_busco_protocolo_historia"
	Cancel
Endif

select * from mwkintevol  where NVL(ei_secuencia,1)=msec INTO CURSOR  mwkveoproto

mret = sqlexec(mcon1, "select ser_descripserv,val_operadorcarga,idusuario,VAL_codservvale "+;
	", VAL_codvaleasist ,val_fechasolicitud,val_horasolicitud,val_medicosolicit,VAL_codadmision,nombre"+;
	" from valesasist inner join servicios on VAL_codservvale = ser_codserv " + ;
	" left join prestadores on valesasist.val_medicosolicit= prestadores.id "+;
	" left join tabusuario on valesasist.val_operadorcarga= tabusuario.codigovax "+;
	" where VAL_codadmision = ?madmision   " + ;
	"  ", "mwkvales")

If mret < 0
	=aerr(eros)
	Messagebox(eros(3))
	Do sp_desconexion with "Err sp_busco_protocolo_historia"
	Cancel
Endif

select VAL_codvaleasist as nrovale, ser_descripserv,val_operadorcarga,idusuario,VAL_codservvale as codserv,;
 val_fechasolicitud,val_horasolicitud,val_medicosolicit,VAL_codadmision,nombre;
	from mwkvales INTO CURSOR mwkvale

mret = sqlexec(mcon1, "select VAL_codvaleasist ,pia_codprest, pia_cantsolicitada,"+;
	"pre_descriprest,VAL_codadmision "+;
	",VAL_codservvale "+;
	" from valesasist, presinsuvas,prestacions  " + ;
	" where valesasist.VAL_codpun  = presinsuvas.pia_valesasist and " + ;
	" pre_codprest = pia_codprest and VAL_codservvale<> 5410 and " + ;
	" VAL_codadmision = ?madmision ", "mwkvaldetp")

If mret < 0
	=aerr(eros)
	Messagebox(eros(3))
	Do sp_desconexion with "Err sp_busco_protocolo_historia"
	Cancel
Endif
mret = sqlexec(mcon1, "select VAL_codvaleasist,pia_codprest, pia_cantsolicitada,"+;
	"INS_descriinsumo as pre_descriprest,VAL_codadmision "+;
	",VAL_codservvale "+;
	" from valesasist, presinsuvas, insumos " + ;
	" where valesasist.VAL_codpun  = presinsuvas.pia_valesasist and " + ;
	" pia_codinsumo = insumos and VAL_codservvale = 5410 and "  + ;
	" VAL_codadmision = ?madmision ", "mwkvaldeti")

If mret < 0
	=aerr(eros)
	Messagebox(eros(3))
	Do sp_desconexion with "Err sp_busco_protocolo_historia"
	Cancel
Endif

Use in select("mwkintevolpro")
mret = sqlexec(mcon1, "select IH_horaCierre from TabIntHCE "+;
	" where IH_admision = ?madmision and IH_secuencia = ?msec", "mwkintevolpro" )
If mret < 0
	=aerr(eros)
	Messagebox(eros(3))
	Do sp_desconexion with "Err sp_busco_protocolo_historia"
	Cancel
Endif

Select VAL_codvaleasist as nrovale, pia_codprest, pia_cantsolicitada,;
	left(pre_descriprest,45) as pre_descriprest,VAL_codservvale  as codserv,val_codadmision;
	, VAL_codvaleasist as idgv  from mwkvaldetp ;
	union select VAL_codvaleasist as nrovale, pia_codprest, pia_cantsolicitada,;
	left(pre_descriprest,45) as pre_descriprest,VAL_codservvale  as codserv,val_codadmision;
	, VAL_codvaleasist as idgv ;
	from mwkvaldeti ;
	into cursor mwkvaledet
