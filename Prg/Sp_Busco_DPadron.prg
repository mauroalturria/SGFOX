Lparameters pOpcion
*!*	========================================================

Do Case
	Case pOpcion = 1
		&& Parametros mNroAfil, mCodEnt, mCursor
		
		mRet = Sqlexec(mCon1,"Select documento, fecegreso, nroafiliado From PadCabe Where nroafiliado = ?mNroAfil " + ;
			"and Entidad = ?mCodEnt", mCursor )  

	Case pOpcion = 2
		&& mDocu, mCodEnt, mCursor
		mRet = Sqlexec(mCon1,"Select documento, fecegreso, nroafiliado From PadCabe Where Documento = ?mDocu " + ;
			"and Entidad = ?mCodEnt", mCursor )  
	
Endcase
	
If  mRet < 0
	=Aerr(eros)
	Messagebox(eros(3))
	Canc
Endif 

Return 
