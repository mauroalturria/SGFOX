parameter mDecr,mTipo,mStock,mid,mabm 
dimension cf(100)
store '' to cf

mfechatope = sp_busco_fecha_serv('DD')

DO CASE 
   CASE mabm = 1
		mret =	sqlexec(mcon1,"select descr from tabStComponente where descr = ?mDecr and TipoComp = ?mTipo ","mwkValidComp")
		        IF RECCOUNT('mwkValidComp') > 0
		            MESSAGEBOX("COMPONENTE EXISTENTE",16,"VALIDACION")
		            grabo = .f.
		            RETURN
		        ENDIF
		mret =	sqlexec(mcon1,"insert into tabStComponente (descr,tipocomp,stock)" +;
			                  " values(?mDecr,?mTipo,?mStock)")

   CASE mabm = 2
		mret =	sqlexec(mcon1,"update tabStComponente set descr= ?mDecr,tipocomp= ?mTipo,stock= ?mStock"+;
							  " where id = ?mid ")
   CASE mabm = 3
        mret =	sqlexec(mcon1," select * from tabStDetPuesto where idComp  = ?mid  ","mwkValidc")
				IF RECCOUNT('mwkValidc') > 0
		            MESSAGEBOX("COMPONENTE VINCULADO A UN PUESTO DE TRABAJO",16,"VALIDACION")
		            grabo = .f.
		            RETURN
		        ENDIF
		mret =	sqlexec(mcon1,"delete from tabStComponente where id = ?mid ")
ENDCASE 
   

if mret<1
	=aerr(eros)
	messagebox(eros(2))
endif
