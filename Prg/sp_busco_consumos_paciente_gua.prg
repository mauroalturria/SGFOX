****
** busco consumo por paciente guardia x fehca
****

Parameters mregistracio, msql_cons,mxfecd,mxfech

mret = SQLExec(mcon1, "select  ser_descripserv,val_operadorcarga,idusuario,VAL_codservvale ,val_estado "+;
	", VAL_codvaleasist ,val_fechasolicitud,val_horasolicitud,val_medicosolicit,VAL_codadmision,nombre"+;
	" from pacientes, servicios, histambgua, " + ;
	" valesasist left outer join prestadores " + ;
	" on valesasist.VAL_prestador = prestadores.id " + ;
	" left join tabusuario on valesasist.val_operadorcarga= tabusuario.codigovax "+;
	" where his_codadmision = PAC_codadmision and " + ;
	" VAL_fechasolicitud between ?mxfecd and ?mxfech and " + ;
	" (VAL_codsector = 'GUA') and " + ;
	" PAC_codadmision = VAL_codadmision and " + ;
	" VAL_codservvale = ser_codserv and " + ;
	" his_nroregistrac = ?mregistracio " + ;
	" order by VAL_fechasolicitud desc ", "mwkvalesg")

Select VAL_codvaleasist As nrovale, ser_descripserv,val_operadorcarga,idusuario,VAL_codservvale As codserv,;
	val_fechasolicitud,val_horasolicitud,val_medicosolicit,VAL_codadmision,'GUA' as val_codsector,nombre,Iif(val_estado=3,"C"," ") As conforme;
	from mwkvalesg Order By conforme,val_fechasolicitud Desc Into Cursor mwkvaleg

mret = SQLExec(mcon1, "select VAL_codvaleasist ,pia_codprest, pia_cantsolicitada,PIA_fechaconforme,PIA_horaconforme,"+;
	"pre_descriprest,VAL_codadmision "+;
	",VAL_codservvale "+;
	" from valesasist,histambgua, presinsuvas,prestacions  " + ;
	" where valesasist.VAL_codpun  = presinsuvas.pia_valesasist and " + ;
	" his_codadmision = VAL_codadmision and his_nroregistrac = ?mregistracio and " + ;
	" pre_codprest = pia_codprest and VAL_codservvale<> 5410 " , "mwkvaldetp")

If mret < 0
	=Aerr(eros)
	Messagebox(eros(3))
	Do sp_desconexion With "Err sp_busco_protocolo_historia"
	Cancel
Endif
mret = SQLExec(mcon1, "select VAL_codvaleasist,pia_codprest, pia_cantsolicitada,PIA_fechaconforme,PIA_horaconforme,"+;
	"INS_descriinsumo as pre_descriprest,VAL_codadmision,ins_codinsumo "+;
	",VAL_codservvale "+;
	" from valesasist,histambgua, presinsuvas, insumos " + ;
	" where valesasist.VAL_codpun  = presinsuvas.pia_valesasist and " + ;
	" pia_codinsumo = insumos and VAL_codservvale = 5410 and "  + ;
	" his_codadmision = VAL_codadmision and his_nroregistrac = ?mregistracio " + ;
	"  ", "mwkvaldeti")

Select VAL_codvaleasist As nrovale, Padr(Transform(pia_codprest),11) As pia_codprest, pia_cantsolicitada,PIA_fechaconforme,PIA_horaconforme,;
	left(pre_descriprest,45) As pre_descriprest,VAL_codservvale  As codserv,VAL_codadmision,'GUA' as val_codsector;
	, VAL_codvaleasist As idgv  From mwkvaldetp ;
	union Select VAL_codvaleasist As nrovale,ins_codinsumo  As  pia_codprest, pia_cantsolicitada,PIA_fechaconforme,PIA_horaconforme,;
	left(pre_descriprest,45) As pre_descriprest,VAL_codservvale  As codserv,VAL_codadmision,'GUA' as val_codsector;
	, VAL_codvaleasist As idgv ;
	from mwkvaldeti ;
	into Cursor mwkvaledetg
