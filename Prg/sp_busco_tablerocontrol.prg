Lparameters mfdesde1,mfhasta1

mfdesde = Datetime(Year(mfdesde1),Month(mfdesde1),Day(mfdesde1),0,0,0)
mfhasta = Datetime(Year(mfhasta1),Month(mfhasta1),Day(mfhasta1),23,59,59)

* Cantidad de Altas (egresos) entre fechas:

Consulta = "select pac_fechaalta as fecha, count(*) as cantaltas "+;
	"from pacientes where exists(select 1 from pacientes where pac_fechaalta >= ?mfdesde and pac_fechaalta <= ?mfhasta) and pac_fechaalta >= ?mfdesde and pac_fechaalta <= ?mfhasta "+;
	"and pac_codadmision not like '0%' "+;
	"and pac_motivoalta <> 7 "+;
	"group by pac_fechaalta"


mret=SQLExec(mcon1,Consulta,"mwkAltas")
If mret < 1
	Messagebox("Error en consulta de Altas",16,"Error")
	Return .F.
Endif

* Cantidad de Admisiones entre fechas:

Consulta = "select pac_fechaadmision as fecha, count(*) as cantadmisiones "+;
	"from pacientes where exists(select 1 from pacientes where pac_fechaadmision >= ?mfdesde and pac_fechaadmision <= ?mfhasta) and pac_fechaadmision >= ?mfdesde and pac_fechaadmision <= ?mfhasta "+;
	"and pac_codadmision not like '0%' group by pac_fechaadmision"


mret=SQLExec(mcon1,Consulta,"mwkAdmisiones")
If mret < 1
	Messagebox("Error en consulta de Admisión",16,"Error")
	Return .F.
Endif


