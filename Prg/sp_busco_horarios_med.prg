****
** Busco los horarios del medico con una prestacion
** 090218 GF - agrego TabTipoTurno en la consulta principal
****

Parameters mcodmed, mcodpres,ldrive,xcm
If Vartype(ldrive)#"N"
	ldrive= 0
ENDIF
If Vartype(xcm)#"N"
	mccpocmed = " and centromed = ?mxcentromedico "
Else
	mccpocmed = " and centromed = ?xcm "
Endif
mfecha = sp_busco_fecha_serv('DD')
If mxambito >1
	mccpoambm = " medpresta.codambito = ?mxambito and "
	mccpoambf = " franjahoraria.codambito = ?mxambito and "
	mcjoin = 	" and medpresta.codambito = franjahoraria.codambito "
Else
	mccpoambm = ''
	mcjoin = ''
	mccpoambf = ''
Endif
	 

mret = SQLExec(mcon1, "select medpresta.id,medpresta.diasem, medpresta.horadesde, medpresta.horahasta, "+;
	" medpresta.fecvigend, medpresta.fecvigenh, franjahoraria.tipoturno, medpresta.demanda, SALA,  "+;
	" TabTipoTurno.Abreviatura, TabTipoTurno.grupo,medpresta.reservados,generaagen,franjahoraria.Fechagraba  " + ;
	" ,medpresta.hhmmdes,medpresta.hhmmhas,medpresta.codmed, medpresta.usuario "+;
	" from TabTipoTurno,medpresta "+;
	" join franjahoraria on medpresta.codmed = franjahoraria.codmed "+;
	" and medpresta.diasem = franjahoraria.diasem "+ mcjoin + ;
	" and medpresta.horadesde = cast(franjahoraria.horadesde as time) "+;
	" and medpresta.horahasta = cast(franjahoraria.horahasta as time)"+;
	" where &mccpoambf &mccpoambf  medpresta.diasem is not null and medpresta.codmed = ?mcodmed "+;
	" and medpresta.codprest=?mcodpres AND medpresta.fecvigend <> medpresta.fecvigenH"+;
	" and ?mfecha < medpresta.fecvigenh AND franjahoraria.fecvigend <> franjahoraria.fecvigenH"+;
	" and medpresta.fecvigend between franjahoraria.fecvigend and franjahoraria.fecvigenh "+;
	" and franjahoraria.tipoturno = TabTipoTurno.TipoTurno " + mccpocmed +;
	" group by medpresta.diasem, medpresta.horadesde, medpresta.horahasta, medpresta.fecvigend "+;
	" ", "mwkhoradoc1")

If ldrive = 1

	mret = SQLExec(mcon1, "Select medpresta.id,medpresta.diasem, Zabfranjadrive.horadesde, Zabfranjadrive.horahasta, " + ;
		" medpresta.fecvigend, medpresta.fecvigenh, Zabfranjadrive.tipoturno, medpresta.demanda, SALA, " + ;
		" TabTipoTurno.Abreviatura,  TabTipoTurno.grupo,medpresta.reservados,generaagen,franjahoraria.Fechagraba  " + ;
		" ,Zabfranjadrive.hhmmdes,Zabfranjadrive.hhmmhas,medpresta.codmed "+;
		" from medpresta,Zabfranjadrive " + ;
		"    inner join TabTipoTurno on Zabfranjadrive.tipoturno = TabTipoTurno.TipoTurno " + ;
		" join franjahoraria on medpresta.codmed = franjahoraria.codmed,medpresta.usuario " + ;
		" and medpresta.diasem = franjahoraria.diasem "+ mcjoin + ;
		" and medpresta.horadesde = cast(franjahoraria.horadesde as time) " + ;
		" and medpresta.horahasta = cast(franjahoraria.horahasta as time) " + ;
		"    and franjahoraria.fecvigend <> franjahoraria.fecvigenH " + ;
		"    and medpresta.fecvigend between franjahoraria.fecvigend and franjahoraria.fecvigenh " + ;
		" where medpresta.codmed = Zabfranjadrive.codmed AND medpresta.diasem = Zabfranjadrive.diasem "+;
		" and not ( medpresta.hhmmhas < Zabfranjadrive.hhmmdes or  "+;
		" medpresta.hhmmdes > Zabfranjadrive.hhmmhas)  and medpresta.codmed = ?mcodmed "+;
		" and {fn CURDATE()} BETWEEN  medpresta.fecvigend and  medpresta.fecvigenh   and " + ;
		" Zabfranjadrive.fecvigenh > {fn CURDATE()}  and " + ;
		" exists (select 1 from medpresta where medpresta.diasem is not null and " + ;
		" medpresta.codprest = ?mcodpres  and medpresta.codmed = ?mcodmed AND " + ;
		" medpresta.fecvigend <> medpresta.fecvigenH and &mccpoambm " + ;
		" {fn CURDATE()} < medpresta.fecvigenh ) and " + ;
		" 	&mccpoambf &mccpoambm " + ;
		"    medpresta.diasem is not null and medpresta.codprest = ?mcodpres AND medpresta.fecvigend <> medpresta.fecvigenH "+;
		" and {fn CURDATE()} < medpresta.fecvigenh " + ;
		" group by medpresta.codmed, Zabfranjadrive.diasem, Zabfranjadrive.horadesde,"+;
		" Zabfranjadrive.horahasta, medpresta.fecvigend " , "mwkhoradoc2")

	Select  Val(Dtos(fecvigenh)+Transform(codmed,"@L 9999")+Transform(diasem)+Transform(hhmmdes,"@L 9999")) As clavemed,*;
		FROM mwkhoradoc2 Into Cursor mwkbasedrive
	Select  Val(Dtos(fecvigenh)+Transform(codmed,"@L 9999")+Transform(diasem)+Transform(hhmmdes,"@L 9999")) As clavemed,*;
		FROM mwkhoradoc1 Where Fechagraba>=Ctod('01/01/2021') Into Cursor mwknuevos
	Select * From mwkbasedrive Union All;
		SELECT * From mwknuevos Where clavemed Not In (Select clavemed From mwkbasedrive ) ;
		INTO Cursor mwkhoradoc1


Endif
If mret<1
	Messagebox('ERROR DE CONEXION, REINTENTE',16,'VALIDACION')
Else
	Select Iif(diasem=2,'Lunes     '  ,Iif(diasem=3,'Martes    ',Iif(diasem=4,'Miércoles ', ;
		iif(diasem=5,'Jueves    ' ,Iif(diasem=6,'Viernes   ' , Iif(diasem=7,'Sabado    ' ,'Domingo   ')))))) As dia, ;
		left(Ttoc(horadesde,2), 5) As desde,  ;
		left(Ttoc(horahasta,2), 5) As hasta, ;
		left(Dtoc(fecvigend), 10) As fdesde, ;
		left(Dtoc(fecvigenh), 10) As fhasta, ;
		abreviatura As Franja,grupo, ;
		iif(demanda = 1,'DE','  ') As demanda, sala, fecvigend, fecvigenh, ;
		iif(Isnull(reservados),0,reservados)As reservados,generaagen, diasem,usuario  ;
		from mwkhoradoc1 Order By diasem, horadesde;
		into Cursor mwkhoradoc
Endif
** ?mfecha >= fecvigend  and
