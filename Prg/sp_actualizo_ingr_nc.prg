****
** actualizo ingredientes no compatibles con dietas
****

parameter  mtipo,mingred,mdieta,mabm

musuario = mwkusuario.codigovax

mfechanull = ctod("01/01/1900")
mfechahoy  = sp_busco_fecha_srv2('DD') 

do case
case mabm = 1		&& Alta

	mret= sqlexec(mcon1," insert into TabNutComp "+;
		"(TNC_idIngr,TNC_codPrest,TNC_fecPasiva,TNC_usuario,TNC_tipo ) " + ;
		" values ( ?mingred, ?mdieta, ?mfechanull ,?musuario, ?mtipo )" )

case mabm = 2		&&& =2 da de baja

	mret= sqlexec(mcon1," Update TabNutComp set TNC_fecPasiva = ?mfechahoy"+;
		", TNC_usuario = ?musuario " + ;
		" where TNC_idIngr= ?mingred and TNC_codPrest= ?mdieta "+;
		" and TNC_fecPasiva = ?mfechanull and TNC_tipo = ?mtipo ")

endcase

if mret < 0
	=aerr(eros)
	messagebox('NO SE ACTUALIZO.  REINTENTE', 16, 'Validacion')
	Messagebox(eros(3))
	mret = 0
endif