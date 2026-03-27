Lparameters mOpcion, mId, mIdPase, mIdObj, mBusco, mCursor

mfecnull = Ctod("01/01/1900")

Do Case
	case mOpcion = 1 && para un pase
		mRet = Sqlexec(mcon1,"Select TabPasePrecinObj.*, " + ;
			"TabPaseObjPrecin.OPR_Descrip, " + ;
			"(piso || descrip || numero) as lugar " + ;
			"from TabPasePrecinObj " + ;
			"Left Join TabPaseObjPrecin on TabPaseObjPrecin.Id = TabPasePrecinObj.PRO_idobjprec " + ;
			"Left Join TabUbicacion on TabPaseObjPrecin.OPR_idubica = TabUbicacion.Id " + ;
			"Where PRO_idpase = ?mIdPase and PRO_FecPasiva = ?mfecnull" + mBusco + ;
			"", mCursor)

	case mOpcion = 2 && para un Id
		mRet = Sqlexec(mcon1,"Select TabPasePrecinObj.*, " + ;
			"TabPaseObjPrecin.OPR_Descrip, " + ;
			"(piso || descrip || numero) as lugar, " + ;
			"TabPaseObjPrecin.OPR_idubica, TabPasePrecinObj.PRO_idobjprec " + ;
			"from TabPasePrecinObj " + ;
			"Left Join TabPaseObjPrecin on TabPaseObjPrecin.Id = TabPasePrecinObj.PRO_idobjprec " + ;
			"Left Join TabUbicacion on TabPaseObjPrecin.OPR_idubica = TabUbicacion.Id " + ;
			"Where TabPasePrecinObj.Id = ?mId and PRO_FecPasiva = ?mfecnull " + mBusco + ;
			"", mCursor)

	case mOpcion = 3 && para un pase / Obj
		mRet = Sqlexec(mcon1,"Select TabPasePrecinObj.*, " + ;
			"TabPaseObjPrecin.OPR_Descrip, " + ;
			"(piso || descrip || numero) as lugar " + ;
			"from TabPasePrecinObj " + ;
			"Left Join TabPaseObjPrecin on TabPaseObjPrecin.Id = TabPasePrecinObj.PRO_idobjprec " + ;
			"Left Join TabUbicacion on TabPaseObjPrecin.OPR_idubica = TabUbicacion.Id " + ;
			"Where PRO_idpase = ?mIdPase and PRO_idobjprec = ?mIdObj and PRO_FecPasiva = ?mfecnull " + mBusco + ;
			"", mCursor)


	otherwise

endcase

	
If mRet <= 0
	Messagebox("ERROR DE LECTURA DE PRECINTOS DE UN OBJETO",48,"VALIDACION")
	Aerror(eros)
	Return .F.
Endif 	