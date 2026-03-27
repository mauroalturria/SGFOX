parameter mDecr,mId,mabm 
dimension cf(100)
store '' to cf

mfechatope = sp_busco_fecha_serv('DD')

DO CASE 
   CASE mabm = 1
		mret =	sqlexec(mcon1,"select descr from tabStMod where descr = ?mDecr  ","mwkValidMod")
		        IF RECCOUNT('mwkValidMod') > 0
		            MESSAGEBOX("MODELO EXISTENTE",16,"VALIDACION")
		            grabo = .f.
		            RETURN
		        ENDIF
		mret =	sqlexec(mcon1,"insert into tabStMod (descr)" +;
			                  " values(?mDecr)")

   CASE mabm = 2
		mret =	sqlexec(mcon1,"update tabStMod set descr= ?mDecr "+;
							  " where id = ?mid ")
   CASE mabm = 3
        mret =	sqlexec(mcon1," select * from tabStPuesto where idModelo  = ?mid  ","mwkValid")
				IF RECCOUNT('mwkValid') > 0
		            MESSAGEBOX("MODELO VINCULADO A UN PUESTO DE TRABAJO",16,"VALIDACION")
		            grabo = .f.
		            RETURN
		        ENDIF
		mret =	sqlexec(mcon1,"delete from tabStMod where id = ?mid ")
ENDCASE 
   

if mret<1
	=aerr(eros)
	messagebox(eros(2))
endif
