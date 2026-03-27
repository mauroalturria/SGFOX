*
* Busqueda de Pacientes derivados a otro profesional
*
Lparameters mmedcab,mprotoc

If used('mwkguaderivb')
	Use in mwkguaderivb
Endif

mret = sqlexec(mcon1,"select * from TabguaDeriv where TGD_medDer=?mmedcab and TGD_estado=1 "+;
	"and TGD_protocolo=?mprotoc","mwkguaderivb")
