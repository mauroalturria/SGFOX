**********
*** Busco cie10
**********
if !used("mwkCie9aa")
	mret = sqlexec(mcon1, "select * from  tabcie10 ", "mwkCie9aa")
endif
	SELECT * FROM mwkCie9aa where tipo = 3 INTO CURSOR mwkCie9
	use in select("mwkCie9C")
	SELECT * FROM mwkCie9aa where tipo = 2 INTO CURSOR mwkCie9C
	use in select("mwkCie9a")
	SELECT * FROM mwkCie9aa where tipo = 1 INTO CURSOR mwkCie9a
	
use in select("mwkTCiapCap")

mret = sqlexec(mcon1, "select ID , Capitulo , Letra from TabCiapCap ", "mwkTCiapCap")
use in select("mwkTCiapCom")

mret = sqlexec(mcon1, "select ID , Nombre  from TabCiapCom ", "mwkTCiapCom")
if used("mwkCiap2e")
	use in mwkCiap2e
endif
mfecnul = CTOD("01/01/1900")

if !used("mwkCiap2ea")
	mret = sqlexec(mcon1, "select  ID , Codigo , Componente , Criterio , "+;
		"DescrAbrev , Descripcion , Excluye , Incluye,fecanula "+;
		" from  TabCiap2E  where id>=1 ", "mwkCiap2ea")
endif

	select  ID , Codigo , Componente , Criterio , DescrAbrev , Descripcion , Excluye , Incluye,fecanula;
		from  mwkCiap2ea where fecanula = ctod('01/01/1900') order by DescrAbrev  INTO CURSOR mwkCiap2e
*!*	endif

