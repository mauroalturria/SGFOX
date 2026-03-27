********************
* Actualizo los datos de los medicos de gerenciadoras
*
********************
parameter mgerenc,mfecalta
if type('mfecalta')#"D"
	mfecdia = ttod(mwkfecserv.fechahora)
else
	mfecdia	= mfecalta
endif 
select 	medicos_gerencia
scan
	select 	medicos_gerencia
	mtipomatri 	= iif(!empty(cmatnac),"MN",iif(!empty(cmatpro),"MP",""))
	mmatricula 	= iif(cmatnac>0,cmatnac,cmatpro)
*	mfecdia		= ttod(mwkfecserv.fechahora)
	mfecnull 	= ctod("01/01/2100")
	mnombre 	= cnombre
	if mmatricula>0
		mret = sqlexec(mcon1," SELECT id,fechaBaja FROM TabMedExterno "+ ;
			" WHERE matricula = ?mmatricula and tipoMat =?mtipomatri  " +;
			" and fechaBaja= ?mfecnull ", "Mwkmedexis")
		if !empty(medicos_gerencia.baja) and reccount ("Mwkmedexis")>0
			mid = Mwkmedexis.id
			mret = sqlexec(mcon1," update TabMedExterno "+ ;
				"set fechaBaja = ?mfecdia WHERE id = ?mid" )
		else
			if reccount ("Mwkmedexis")= 0
				mfecnull 	= iif( empty(medicos_gerencia.baja), ctod("01/01/2100"), mfecdia )
				mret= sqlexec(mcon1,'INSERT INTO TabMedExterno(codesp, fechaBaja,'+;
					' fechaIngreso, gerenciadora, matricula, nombre, tipoMat, usuarpas ) '+;
					'VALUES("", ?mfecnull ,?mfecdia ,?mgerenc,?mmatricula ,?mnombre,'+;
					'?mtipomatri ,"")')
				if mret < 0
					=aerr(eros)
					messagebox ( eros(3))
				endif
			endif
		endif
	endif
endscan
