****
** Grabo Conceptos
****
lparameters mdesc,mclave,mclase,mtipo,mabm,mid
if mabm = 1
	mid=0
ENDIF

mConcep = alltrim(mdesc)
mlong 	= lenc(mConcep )
if mlong<=250
	cconcat = "'"+alltrim(substr(mConcep ,1,250))+"'"
else
	mpri = substr(mConcep ,1,250)
	mresto = substr(mConcep ,251)
	cconcat = "{fn CONCAT( ?mpri"
	mcola = " ) } "
	i =1
	do while lenc(mresto)>0
		clin = "linea"+padl(i,3,"0")
		&clin = substr(mresto,1,250)
		mrestito = mresto
		mresto = substr(mrestito,251)
		if lenc(mresto)>0
			cconcat = cconcat+ ",{fn CONCAT( ?"+clin
			mcola = mcola + " ) } "
		else
			cconcat = cconcat+ ", ?"+clin
		endif
		i = i+1	
	enddo
	cconcat = cconcat+ mcola 
ENDIF

if !empty(cconcat)


	mfpasiva = ctot("01/01/1900")
	do case
		case mabm = 1   		&& Alta
			mret = sqlexec(mcon1, "SELECT id FROM SQLUser.TabPConce where concepto = ?mdesc " , "mwkcontrol")
			if RECCOUNT()>0
				messagebox('CONCEPTO EXISTENTE',48,'Validacion')
			else
				mret = sqlexec(mcon1, "insert into TabPConce (concepto,fechaPas,tipo,Clase,"+;
				 "PalabraClave) "+;
				" values("+ cconcat+ ", ?mfpasiva, ?mtipo, ?mclase, ?mclave )")
			endif
		case mabm = 2
			mret = sqlexec(mcon1, "SELECT id FROM SQLUser.TabPConce where concepto = ?mdesc "+;
				"and id <> ?mid " , "mwkcontrol")
			if RECCOUNT() >0
				messagebox('CONCEPTO EXISTENTE',48,'Validacion')
			else
				mret = sqlexec(mcon1, "update TabPConce set concepto = " + cconcat + ", tipo = ?mtipo"+;
					" ,Clase = ?mclase, PalabraClave = ?mclave where id=?mid ")
			endif
		case mabm = 3
		    mfpasiva 	= sp_busco_fecha_serv('DD')
			mret = sqlexec(mcon1, "update TabPConce set fechapas = ?mfpasiva where id=?mid ")
	endcase
	if mret < 0
		=aerr(eros)
		messagebox(eros(3))
		messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
	endif

endif