*****************************************************************************
do sp_conexion.prg

select nanda
scan 
	ccodcien= codcien
	cdescrip = descrip
	 mret=sqlexec(mcon1," INSERT INTO TabCieNanda (codcieN , descrip) values (?ccodcieN , ?Cdescrip) ")

endscan

select compon
scan 
	mnombre = Nombre 
	 mret=sqlexec(mcon1," INSERT INTO TabCiapCom (Nombre) values (?mnombre) ")

endscan
select capitulo
scan 
	mCapitulo = Capitulos
	mLetra = Letra
	 mret=sqlexec(mcon1," INSERT INTO TabCiapCap (Capitulo , Letra) values (?mCapitulo , ?mLetra) ")
endscan
select cie9
scan 

	mCodigo = code
	mComponente = component
	mCriterio = crit
	mDescrAbrev  = short
	mDescripcion = text
	mExcluye = Excl
	mIncluye = incl
	 mret=sqlexec(mcon1," INSERT INTO TabCiap2E (Codigo , Componente , Criterio , DescrAbrev , Descripcion , "+;
	 "Excluye , Incluye ) values (?mCodigo , ?mComponente , ?mCriterio , ?mDescrAbrev , ?mDescripcion , ?mExcluye , ?mIncluye ) ")
endscan
