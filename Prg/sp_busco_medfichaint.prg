*
* Fichadas de Medicos de Guardia
*

lparameters mcodmed,msalida,mbusco

if used('mwkbuscamed')
	use in mwkbuscamed
endif
if vartype(mbusco)#"C"
	mbusco = ""
endif
	mbusca = ''
IF mcodmed > 1
	mbusca = " where TII_usuario =?mcodmed   "
ENDIF
if inlist(vartype(msalida),"D","T")
	mbusca = IIF(EMPTY(mbusca)," Where "," and ")+" TII_fichasal=?msalida "
ENDIF
mbusca = mbusca +mbusco 
mret = sqlexec(mcon1,"select ID,TII_fichaEnt, TII_fichaSal, TII_sector, TII_supervisor, TII_tipo, TII_usuario,TII_usuario->nomape  "+;
	"FROM ZabIntIEMed "+;
	mbusca + " order by TII_fichaEnt desc ","mwkbuscamed")

if mret < 0
*	messagebox("ERROR DE LECTURA DEL PROFESIONAL EN FICHADAS",16,"ERROR")
	do log_errores with error(), message(), message(1), program(), lineno()
endif
