****
**  Actualizacion de preparaciones
****

parameter mcual, mid,mtexdos,mtex3 ,mtex4

mfecha1 = sp_busco_fecha_serv('DT')
mfecha2 = ctot('01/01/1900')
musub	= ''
if type ('mtexdos')#"C"
	mtexdos=''
endif
if mcual = 1
	mret = sqlexec(mcon1,'insert into turnosprepara ( codpres , descrip , fecalta , fecbaja , usualta , usubaja ) ' + ;
					'values(?mcodpre, {fn CONCAT(?mtexto, {fn CONCAT(?mtexdos ,{fn CONCAT(?mtex3 , ?mtex4 )}  )} )}, ?mfecha1, ?mfecha2, trim(?midusu), ?musub)')
endif	
if mcual = 2
	mret = sqlexec(mcon1,'update turnosprepara ' + ;
					'set descrip = {fn CONCAT(?mtexto, {fn CONCAT(?mtexdos ,{fn CONCAT(?mtex3 , ?mtex4 )}  )} )}, usualta = ?midusu, fecalta = ?mfecha1 ' + ;
					'where id = ?mid')
endif
if mcual = 3
	mret = sqlexec(mcon1,'update turnosprepara ' + ;
					'set usubaja = ?midusu, fecbaja = ?mfecha1 ' + ;
					'where id = ?mid')
endif

if mret < 0
	messagebox('ERROR EN LA ACTUALIZACION DE PREPARACIONES, AVISE EN SISTEMAS',16,'Validacion')
	CANCEL
endif