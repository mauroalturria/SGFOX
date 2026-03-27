***
** busco valores de Coseguros
***
lparameters mtpc
if !empty(mtpc)
	cmtp  = " and tipopac = ?mtpc "
else 
	cmtp  = " "
endif
mret = sqlexec(mcon1,  "select Coseguros.*,ent_descrient, CosegurosTipoAtencion.Descripcion as Descripcion "+;
	" ,planes.descripcion as Denominacion from entidades, CosegurosTipoAtencion,Coseguros "+;
	" left join planes on planes.id = Coseguros.plan "+;
	" where entidad = ent_codent  "+cmtp  +;
	" and Coseguros.TipoAten = CosegurosTipoAtencion.tipoAten",'MwkCoseguros')

if mret < 0
	=aerr(eros)
	messagebox("ERROR AL BUSCAR LOS DATOS", 48, "Validacion")

endif

