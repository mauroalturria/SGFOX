*
* Busqueda de Incidentes Adversos
*

Lparameters mfechas, mestd, mopt1, mopt2, mbestado, mbasegura,mbusco

*set step on

mbusco = iif(vartype(mbusco)#"C","",mbusco)
mwhere = "where TIP_fecinf >= ?mfechas" + mbusco
*!*                                       1 ó 2      -       1, 2, 3 ó 4
mwhere = mwhere + iif(mestd=1," and TIP_estado < 3"  ," and TIP_estado <> 5")
mwhere = mwhere + iif(mopt1=2," and TIP_estado = ?mbestado","")
mwhere = mwhere + iif(mopt2=2," and TIP_area = ?mbasegura" ,"")

mret = sqlexec(mcon1,"select id as lid,TIP_fecinf,TIP_estado,"+;
	"REG_nombrepac,REG_numdocumento,REG_nrohclinica,TIP_idusuario "+;
	" from TabLGIncAdP"+;
	" left outer join registracio on REG_nroregistrac = TIP_nroregistrac " + mwhere,"mwklegalesi")

If mret < 0
	Messagebox("EN BUSQUEDA DE INCIDENTES ADVERSOS",16,"ERROR")
Else
   Select lid,TIP_fecinf,lestado,REG_nombrepac,REG_numdocumento,REG_nrohclinica,TIP_idusuario;
   From mwklegalesi left outer join mwkestados on lidestado = TIP_estado;
   into cursor mwklegalesi
Endif

