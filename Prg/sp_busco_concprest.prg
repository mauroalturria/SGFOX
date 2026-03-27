****
** Busco Condiciones de Pago
****
PARAMETERS mid

mret = sqlexec(mcon1, "SELECT tabprconce.*,concepto,fechapas  from tabpconce ,tabprconce where codconce = tabpconce.id AND Ccodigo =  ?mid"  , "mwkConcep")
mret = sqlexec(mcon1, "SELECT * from tabprprest,prestacions where pcodigo = ?mid and codprest = pre_codprest"+;
" and pre_fechapasiva is null" , "mwkPrest")
if mret < 0
	messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
endif