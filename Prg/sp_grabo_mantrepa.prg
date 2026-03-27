parameter mabm,mReparacion,midespe,mid
dimension cf(100)
store '' to cf

mfechatope = sp_busco_fecha_serv('DD')

DO CASE 
   CASE mabm = 1
		mret =	sqlexec(mcon1,"select Reparacion  from TabMantReparacion " +;
		" where Reparacion  = ?mReparacion  ","mwkMantReparacion")
		        IF RECCOUNT('mwkMantReparacion') > 0
		            MESSAGEBOX("Reparacion EXISTENTE",16,"VALIDACION")
		            grabo = .f.
		            RETURN
		        ENDIF
		mret =	sqlexec(mcon1,"insert into TabMantReparacion(Reparacion,idespecialidad  )" +;
			                  " values(?mReparacion,?midespe)")

   CASE mabm = 2
		mret =	sqlexec(mcon1,"update TabMantReparacion set Reparacion  = ?mReparacion ,idespecialidad  = ?midespe "+;
							  " where id = ?mid ")
   CASE mabm = 3
		mret =	sqlexec(mcon1,"delete from TabMantReparacion where id = ?mid ")
ENDCASE 
   
		mret =	sqlexec(mcon1,"select *  from TabMantReparacion " +;
		" where Reparacion  = ?mReparacion and idespecialidad = ?midespe " +;
		" ","mwkMantRepId")
if mret<1
	=aerr(eros)
	messagebox(eros(2))
endif
