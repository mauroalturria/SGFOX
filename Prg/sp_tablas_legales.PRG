****
** Busco TabEstados para LEGALES, Propietario = 37
****

Lparameters mproviene

* ASEGURADORA
If used('mwkAsegura')
	Use in mwkAsegura
Endif
If mproviene = 2   && Responsabilidad Civil
	mestado = 2
Else               && Mala Praxis
	mestado = 1
Endif
mret = sqlexec(mcon1,"select *,id as lid from TabLGAseg where TLA_tipo=?mestado","mwkAsegura")
If mret<1
	Messagebox("EN LA TABLA ASEGURADORAS"+chr(10)+", AVISE A SISTEMAS",16,"ERROR")
Endif

* ESTADO ACTUAL
mestado = 6
If used('mwkEstado')
	Use in mwkEstado
Endif
mret = sqlexec(mcon1,"select * from TabEstados where propietario = 37"+;
	" and estado = ?mestado order by subestado", "mwkEstado")
If mret<1
	Messagebox("EN LA TABLA ESTADOS"+chr(10)+", AVISE A SISTEMAS",16,"ERROR")
Endif

* MONTOS ( Requerido, Acordado, a/c Silver )
mestado = 3
If used('mwkMontosr0')
	Use in mwkMontosr0
Endif
mret = sqlexec(mcon1,"select * from TabEstados where propietario = 37"+;
	" and estado = ?mestado order by subestado", "mwkMontosr0")
If mret < 0
	Messagebox("EN LA TABLA MONTOS (Requerido,Acordado,a/c Silver)"+chr(10)+"AVISE A SISTEMAS",16,"ERROR")
Else

	If used('mwkMontosr1')
		Use in mwkMontosr1
	Endif
	mret = sqlexec(mcon1,"select * from TabEstados where propietario = 37"+;
		" and estado = ?mestado order by subestado", "mwkMontosr1")

	If used('mwkMontosr2')
		Use in mwkMontosr2
	Endif
	mret = sqlexec(mcon1,"select * from TabEstados where propietario = 37"+;
		" and estado = ?mestado order by subestado", "mwkMontosr2")

	If used('mwkMontosr3')
		Use in mwkMontosr3
	Endif
	mret = sqlexec(mcon1,"select * from TabEstados where propietario = 37"+;
		" and estado = ?mestado order by subestado", "mwkMontosr3")

Endif

* RIESGO MEDICO
mestado = 4
If used('mwkRiesgo')
	Use in mwkRiesgo
Endif
mret = sqlexec(mcon1,"select * from TabEstados where propietario = 37"+;
	" and estado = ?mestado order by subestado", "mwkRiesgo")
If mret<1
	Messagebox("EN LA TABLA RIESGO MEDICO"+chr(10)+"AVISE A SISTEMAS",16,"ERROR")
Endif

* MONTOS ( Sentencia, Sentencia a/c Silver )
mestado = 5

If used('mwkMontose0')
	Use in mwkMontose0
Endif
mret = sqlexec(mcon1,"select * from TabEstados where propietario = 37"+;
	" and estado = ?mestado order by subestado", "mwkMontose0")
If mret<1
	Messagebox("EN LA TABLA DE MONTOS (Sentencia, Sentencia a/c Silver)"+chr(10)+"AVISE A SISTEMAS",16,"ERROR")
Else
	If used('mwkMontose1')
		Use in mwkMontose1
	Endif
	mret = sqlexec(mcon1,"select * from TabEstados where propietario = 37"+;
		" and estado = ?mestado order by subestado", "mwkMontose1")

Endif

* HECHO GENERADOR DEL REQUERIMIENTO
* mtipo = 5

If used('mwkHechosg')
	Use in mwkHechosg
Endif
mret = sqlexec(mcon1,"select *,ID as TLH_idcod from TabLGHechos", "mwkHechosg")
If mret<1
	Messagebox("EN LA TABLA HECHOS GENERADOR DEL REQUERIMIENTO"+chr(10)+"AVISE A SISTEMAS",16,"ERROR")
Endif

* PARENTESCOS
If used('mwkFamiliar')
	Use in mwkFamiliar
Endif
mret = sqlexec(mcon1,"select * from TabFamiliar where TFM_relacion = 0", "mwkFamiliar")
If mret<1
	Messagebox("EN LA TABLA PARENTESCOS"+chr(10)+"AVISE A SISTEMAS",16,"ERROR")
Endif

* Entidades / Obras Sociales
If used('mwkentidad1')
	Use in mwkentidad1
Endif
mret = sqlexec(mcon1,"select ENT_codent, ENT_descrient from entidades " + ;
	"where ENT_fecpas is null and (ENT_capita is null or ENT_capita <> 'S') and " + ;
	"(ENT_turnoshabilit is null or ENT_turnoshabilit <> 'S') " + ;
	"order by ENT_descrient", "mwkentidad1")

If mret<1
	Messagebox("EN LA TABLA ENTIDADES - O.S."+chr(10)+"AVISE A SISTEMAS",16,"ERROR")
Endif

* Tipos de documento
If used('mwkdocu')
	Use in mwkdocu
Endif
mret = sqlexec(mcon1,"select abrevio, descrip, codigovax, id " + ;
	"from tabdocumentos where id<100000 order by id", "mwkdocu")

If mret<1
	Messagebox("EN LA TABLA TIPOS DE DOCUMENTO"+chr(10)+"AVISE A SISTEMAS",16,"ERROR")
Endif


* Beneficios a Litigar sin gastos
mestado = 7
If used('mwkblsg')
	Use in mwkblsg
Endif
mret = sqlexec(mcon1,"select * from TabEstados where propietario = 37"+;
	" and estado = ?mestado order by subestado", "mwkblsg")
If mret<1
	Messagebox("EN LA TABLA DE B.L. s/G."+chr(10)+"AVISE A SISTEMAS",16,"ERROR")
Endif

