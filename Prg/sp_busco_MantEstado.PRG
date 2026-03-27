*
* Busco Estados de Mantenimiento, ordenado por campo Orden no contempla pasivados
*

If used('mwkreclest')
	Use in mwkreclest
Endif

mfecnull = ctod("01/01/1900")

mret = sqlexec(mcon1,"select * from TabMantEst "+;
	"where fecpasiva = ?mfecnull order by orden","mwkreclest")

If mret < 1
*   =aerr(eros)
	Messagebox('ERROR EN CONSULTA DE ESTADOS'+chr(10)+'AVISE A SISTEMAS', 64,'Validacion')
Endif


