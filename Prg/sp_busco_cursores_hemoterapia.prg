* Armo Cursores de Hemoterapia.
parameters mHisCli

tcHC = mHisCli
msql_reg = ''

*** Datos Paciente ***

mbusco = " where REG_nrohclinica = '" + tcHC + "' and "
Do sp_busco_nombre_paciente With mbusco, 1 && mwkbuspacie

&msql_reg

Select * From mwkbuspacie1 Into Cursor mwkbuspacie_ht
Use In Select("mwkbuspacie")
Use In Select("mwkbuspacie1")


*** Grupo Sanguineo ***
USE IN SELECT('mwkhtgrupo')
lcsql = "Select *,  cast(htg_hora as char(8)) as htg_hora1  " + ;
	"From tabhtgrupo where tabhtgrupo.HTG_HC = ?tcHC Order By tabhtgrupo.HTG_Fecha desc, tabhtgrupo.HTG_hora desc "

If !Prg_EjecutoSql(lcsql,"mwkhtgrupo")
	Return .F.
Endif


*** Anticuerpos ***

lcsql = "Select *,  cast(hta_hora as char(8)) as hta_hora1  " + ;
	"From TabHTAnticuerpos where HTA_HC = ?tcHC Order By HTA_Fecha desc, HTA_hora desc "

USE IN SELECT('mwkhtantic')
If !Prg_EjecutoSql(lcsql,"mwkhtantic")
	Return .F.
Endif


*** Prueba de Coombs ***

lcsql = "Select *,  cast(htc_hora as char(8)) as htc_hora1  " + ;
	"From TabHTCoombsDirecta where HTC_HC = ?tcHC Order By HTC_Fecha desc, HTC_hora desc "

USE IN SELECT('mwkhtCoombs')
If !Prg_EjecutoSql(lcsql,"mwkhtCoombs")
	Return .F.
Endif

*** Transfusiones ***

lcsql = "Select *,  cast(htt_hora as char(8)) as htt_hora1 " + ;
	"From TabHTTransfusiones where HTt_HC = ?tcHC Order By HTt_Fecha desc, HTt_hora desc "
	

if used("mwkhttransf")
	use in mwkhttransf
endif

If !Prg_EjecutoSql(lcsql,"mwkhttransf")
	Return .F.
Endif

* Creo un Cursor Temporal de Transfusión para agregar la casilla de verificación para reportes

if used("mwkhttransf_provhtt")
	use in mwkhttransf_provhtt 
endif


select *, 0 As HTT_Verif From mwkhttransf Into Cursor mwkhttransf_provhtt

USE IN SELECT('mwkhttransf_temp')
Use Dbf("mwkhttransf_provhtt") Again In 0 Alias mwkhttransf_temp

*select mwkhttransf_temp

*use in mwkhttransf

*create cursor mwkhttransf (newint I) insert into dummy values (0) select * from 

*select * from mwkhttransf into cursor mwkhttransf_provhtt

*use dbf("mwkhttransf_provhtt") again in 0 alias mwkhttransf_temp

* EXECSCRIPT('alter table mwkhttransf_temp add HTT_Verif n(1)')



* ALTER TABLE mwkhttransf_temp ADD COLUMN HTT_Verif N(1)

* select * from mwkhttransf_temp

******************************************************************

*                    PARA LA VERSION 6 HACIA ATRAS

*	SELECT * FROM sample INTO CURSOR temp
*	USE DBF( "temp" ) AGAIN IN 0 ALIAS cur_readwrite
*	SELECT cur_readwrite
*	USE IN temp
*	CREATE CURSOR dummy ( newint I )INSERT INTO dummy VALUES (0) SELECT * FROM sample, dummy

******************************************************************





