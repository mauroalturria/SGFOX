****
** Actualizo TabCmdFrm
****

parameter mcmd, mdescri,minv
if type('minv')# "N"
	minv = 0
endif

mret = sqlexec(mcon1, "select * from tabcmdfrm where cmdnombre=?mcmd ","mwkcontrol")
if reccount('mwkcontrol')>0
	mid = mwkcontrol.id
	mret = sqlexec(mcon1, "update tabcmdfrm set cmdnombre= ?mcmd , descrip= ?mdescri,"+;
				" cmdinv = ?minv where id = ?mid ")
else

	mret = sqlexec(mcon1, "insert into tabcmdfrm(cmdnombre, descrip,cmdinv ) " + ;
						"values(?mcmd, ?mdescri, ?minv )")
endif						