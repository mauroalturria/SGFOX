lparameters mabm,mtipo,mcodmed,madmision,midaut  ,mcid ,motra,mfrecuen,mdesde,mhasta, mcan,mobs,mdes,mdos,mcodinsu, mcodpuntero,mfecnul
if vartype(mfecnul )#"D"
	mfecnul = ctod("01/01/1900")
ENDIF
mret = 0
do case
	case mtipo = 1
		do case
			case mabm = 1
				MTABLA = "CUIDADOS DOMICILIARIOS PRESTACIONES - REGISTRO"
				mret = sqlexec(mcon1,"insert into TabAutCDP "+;
					"(ACP_admision , ACP_cantidad , ACP_codmed , ACP_desde , ACP_frecuencia ,"+;
					" ACP_hasta , ACP_idautprevia , ACP_idprest , ACP_observa , ACP_otrapre,ACP_pasivado) "+;
					" values "+;
					"(?madmision , ?mcan , ?mcodmed , ?mdesde ,?mfrecuen , ?mhasta , ?midaut ,?mcid , ?mobs , ?motra ,?mfecnul )")
			case mabm = 2
				mret = sqlexec(mcon1,"update TabAutCDP set "+;
					" ACP_cantidad = ?mcan , ACP_codmed = ?mcodmed , ACP_desde = ?mdesde , ACP_frecuencia = ?mfrecuen  ,"+;
					" ACP_hasta = ?mhasta , ACP_idautprevia = ?midaut , ACP_idprest = ?mcid  , ACP_observa = ?mobs, "+;
					"ACP_otrapre = ?motra,ACP_pasivado = ?mfecnul where id = ?mcid ")
			case mabm = 3 && solo agrega el registro de autprevia
				mret = sqlexec(mcon1,"update TabAutCDP set "+;
					" ACP_idautprevia = ?midaut where id = ?mcid  ")
		endcase
	case mtipo = 2
		MTABLA = "CUIDADOS DOMICILIARIOS EQUIPAMIENTO - REGISTRO"
		do case
			case mabm = 1
			mret = sqlexec(mcon1,"insert into TabAutCDE "+;
				"(ACE_admision , ACE_codmed , ACE_idautprevia , ACE_ideqp , ACE_otroeqp , ACE_pasivado )" +;
				" values " +;
				"(?madmision,?mcodmed ,?midaut,?mcid , ?motra , ?mfecnul )")
				case mabm = 2
				mret = sqlexec(mcon1,"update TabAutCDP set "+;
					" ACP_cantidad = ?mcan , ACP_codmed = ?mcodmed , ACP_desde = ?mdesde , ACP_frecuencia = ?mfrecuen  ,"+;
					" ACP_hasta = ?mhasta , ACP_idautprevia = ?midaut , ACP_idprest = ?mcid  , ACP_observa = ?mobs, "+;
					"ACP_otrapre = ?motra,ACP_pasivado = ?mfecnul where id = ?mcid ")
			case mabm = 3 && solo agrega el registro de autprevia
				mret = sqlexec(mcon1,"update TabAutCDP set "+;
					" ACP_idautprevia = ?midaut where id = ?mcid  ")
		endcase

	case mtipo = 3
		mltabla = "CUIDADOS DOMICILIARIOS INSUMOS "
		do case
			case mabm = 1
			mret = sqlexec(mcon1,"insert into TabAutCDI "+;
				"(ACI_admision , ACI_cantidad , ACI_codinsumo , ACI_codmed , ACI_codpuntero , "+;
				"ACI_codvale , ACI_desde , ACI_dosis , ACI_frecuencia , ACI_hasta ,  "+;
				"ACI_idautprevia , ACI_indicacion , ACI_pasivado) "+;
				" values "+;
				" (?madmision , ?mcan , ?mcodinsu , ?mcodmed , ?mcodpuntero , 0, ?mdesde,?mdos ,?mfrecuen  ,?mhasta"+;
				" , ?midaut,?mdes, ?mfecnul )")

			case mabm = 2
				mret = sqlexec(mcon1,"update TabAutCDI set "+;
					" ACI_cantidad = ?mcan , ACI_codmed = ?mcodmed , ACI_desde = ?mdesde , ACI_frecuencia = ?mfrecuen  ,"+;
					" ACI_hasta = ?mhasta , ACI_idautprevia = ?midaut ,  "+;
					"ACI_pasivado = ?mfecnul where id = ?mcid ")
			case mabm = 3 && solo agrega el registro de autprevia
				mret = sqlexec(mcon1,"update TabAutCDI set "+;
					" ACI_idautprevia = ?midaut where id = ?mcid  ")
			OTHERWISE && mat.descarta
				mret = 1		
		endcase
endcase
if mret < 0
	do Log_errores with error(), message(), message(1), program(), lineno()
	messagebox("EN LA "+mltabla +chr(10)+"AVISE A SISTEMAS",16,"ERROR")
endif
