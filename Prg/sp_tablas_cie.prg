lDisconnec = .f.
	If !used("mwkserver1")
		Do sp_conexion
		lDisconnec = .t.
	Endif
	mret = sqlexec(mcon1, "select ID , Capitulo , Letra from TabCiapCap ", "mwkTCiapCap")
	mret = sqlexec(mcon1, "select ID , Nombre  from TabCiapCom ", "mwkTCiapCom")
	mfecnul  = ctod("01/01/1900")
	WAIT windows "Un momento por favor... estamos configurando el sistema" nowait
	if mxambito = 1
		mret = sqlexec(mcon1, "select ID , Codigo,Componente , "+;
			"cast(nvl(Criterio,'') as char(254)) as Criterio,"+;
			"cast(nvl(trim(Incluye),'')as char(254)) as Incluye, "+;
			"cast(nvl(trim(Excluye),'')as char(254)) as Excluye, "+;
			"cast(nvl(trim(DescrAbrev),'')as char(50)) as DescrAbrev, "+;
			"cast(nvl(trim(Descripcion),'')as char(150)) as Descripcion,fecanula "+;
			" from  TabCiap2E where id>=1  ", "mwkCiap2ea")
		select  id , Codigo , Componente , Criterio , DescrAbrev , Descripcion , Excluye , Incluye,fecanula;
			from  mwkCiap2ea where fecanula = ctod('01/01/1900') order by DescrAbrev  into cursor mwkCiap2e

	else
		mret = sqlexec(mcon1, "Select ean_evolnurse from Tabambevolnurse where ean_proto = '1'","cAux")

		mresu = alltrim(cAux.ean_evolnurse )
		xmltocursor(mresu ,"mwkCiap2ea",4)
		select  id , Codigo , Componente , Criterio , DescrAbrev , Descripcion , Excluye , Incluye,fecanula;
			from  mwkCiap2ea order by DescrAbrev  into cursor mwkCiap2e

	endif
 WAIT clear
If lDisconnec 
	Do sp_desconexion WITH "ingresohceamb"
Endif
