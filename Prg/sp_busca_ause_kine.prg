****
** listado de ausentismo de foniatria
****
Parameter mfecha, mcodesp
lcErrorAnt = ON("ERROR")
On Error
mfecnul    = Ctod("01/01/1900")
mccpoamb   = ''
mccpoambtf = ''
lvino      = .F.
If mxambito > 1
   mccpoamb   = "  turnos.codambito = ?mxambito and "
   mccpoambtf = " where  codambito = ?mxambito "
Endif
mret = SQLExec(mcon1,'select FechaCierre,FechaProceso FROM TurnosFechas '+ ;
   ' &mccpoambtf  order by fechacierre ','mwkctrlfecha')
If mret < 1
   Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
   Return .F.
Endif
Go Bottom In mwkctrlfecha
Skip -1
mfechacan = mwkctrlfecha.fechacierre

mret    = SQLExec(mcon1,"SELECT ENT_descrient, ENT_codent FROM entidades" ,"MWKEntidades")
If mret < 1
   Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
   Return .F.
Endif
magrup  = Iif(mcodesp="KINE", "codreserva","REG_nrohclinica")
magrup2 = Iif(mcodesp="KINE", "codreserva","turnos.afiliado")
mfaltas = Iif(Inlist(mcodesp,"PSIC"), 2, Iif(Inlist(mcodesp,"VACU"), 1, 3))

mret = SQLExec(mcon1, "select fechatur, horatur, codreserva, confirmado, " + ;
   "nombre, REG_nombrepac,  REG_nrohclinica, afiliado,codent,fechatomado,PRE_descriprest " + ;
   "from turnos, registracio, afiliacion, prestadores,Prestacions " + ;
   "where &mccpoamb fecpasivap = ?mfecnul and turnos.codesp = ?mcodesp and codmed = prestadores.id and " + ;
   "afiliado = afiliacion.registracio and codent = AFI_codentidad and " + ;
   "afiliacion.registracio = registracio.REG_nroregistrac and turnos.codprest = PRE_codprest " + ;
   "group by &magrup,afiliado,fechatur", "mwktodos1")

If mret < 1
   Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
   Return .F.
Endif

mret = SQLExec(mcon1, "select fechatur, horatur, codreserva, confirmado, " + ;
   "prestadores.nombre, preregistra.nombre as REG_nombrepac, turnos.afiliado,turnos.codent,fechatomado,PRE_descriprest " + ;
   "from turnos, preregistra, prestadores,Prestacions " + ;
   "where &mccpoamb turnos.codesp = ?mcodesp and codmed = prestadores.id and " + ;
   "turnos.afiliado = preregistra.id and turnos.codprest = PRE_codprest " + ;
   "group by &magrup2,turnos.afiliado,fechatur", "mwktodos2")

If mret<1
   Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
   Return .F.
Endif
mret = SQLExec(mcon1, "select afiliado,feccancela  " + ;
   "from turnoscancel as turnos " + ;
   "where &mccpoamb fechatur > ?mfechacan " + ;
   "and codesp = ?mcodesp  " + ;
   "and codcancela  = 6 " + ;
   " Group By afiliado"+;
   " Order By afiliado, feccancela Desc", "mwkcance")

If mret < 1
   Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
   Return .F.
Endif

*!*	Select * From mwkcancela10 Order By afiliado, feccancela Desc Into Cursor mwkcancela1
*!*	Select * From mwkcancela1 Group By afiliado Into Cursor mwkcance

Select fechatur, horatur, codreserva, confirmado, nombre, REG_nombrepac,  ;
   REG_nrohclinica, afiliado,codent,fechatomado,PRE_descriprest From mwktodos1 ;
   union All ;
   select fechatur, horatur, codreserva, confirmado, nombre, REG_nombrepac,  ;
   transf(afiliado,"99999999-9") As REG_nrohclinica, afiliado,codent,fechatomado,PRE_descriprest From mwktodos2 ;
   into Cursor mwktodosprev

If Used('mwktodos2')
   Select mwktodos2
   Use
Endif

Select fechatur, horatur, codreserva, confirmado, nombre, REG_nombrepac,  ;
   REG_nrohclinica, mwktodosprev.afiliado,codent,fechatomado,feccancela,PRE_descriprest ;
   from mwktodosprev;
   left Join mwkcance On mwktodosprev.afiliado = mwkcance.afiliado ;
   into Cursor mwktodosprevio

Select * From mwktodosprevio ;
   where 	Isnull(feccancela) Or fechatomado>=feccancela;
   into Cursor mwktodos

Select REG_nombrepac, codreserva,REG_nrohclinica,  ;
   sum(Iif(confirmado = 0 And fechatur < mfecha , 1, 0)) As falto,  ;
   sum(Iif(confirmado = 1 And fechatur < mfecha , 1, 0)) As vino, ;
   sum(Iif(fechatur >= mfecha , 1, 0)) As quedan,PRE_descriprest ;
   from mwktodos ;
   group By REG_nombrepac,&magrup;
   order By REG_nrohclinica Having falto>0 And quedan > 0  ;
   into Cursor mwkfaltas

Select REG_nombrepac, confirmado ,fechatur,codreserva,REG_nrohclinica, codent,ENT_descrient,PRE_descriprest,1 As Incl  ;
   from mwktodos ;
   left Join mwkentidades On codent = ENT_codent;
   where &magrup In (Select &magrup From mwkfaltas) ;
   order By REG_nombrepac,&magrup, fechatur Desc;
   into Cursor mwkdetfaltas1

Select REG_nombrepac, confirmado ,fechatur,codreserva,REG_nrohclinica, codent,ENT_descrient,PRE_descriprest,0 As Incl  ;
   from mwktodos ;
   left Join mwkentidades On codent = ENT_codent;
   where &magrup Not In (Select &magrup From mwkdetfaltas1) And fechatur>=mfecha;
   and REG_nombrepac In (Select REG_nombrepac From mwkdetfaltas1) Order By REG_nrohclinica, &magrup, fechatur Desc;
   into Cursor mwkdetfaltas2


Select * From mwkdetfaltas1;
   union All ;
   select * From mwkdetfaltas2;
   into Cursor mwkdetfalta

Select * From mwkdetfalta;
   order By REG_nrohclinica, &magrup Desc, fechatur Desc ;
   into Cursor mwkdetfaltas

Select mwkdetfaltas
Go Top
mcodres   = &magrup
mpaciente = mwkdetfaltas.REG_nombrepac
mhclin    = mwkdetfaltas.REG_nrohclinica
presentes = 0
ausentes  = 0
mconf     = mwkdetfaltas.confirmado
ment      = mwkdetfaltas.ENT_descrient
abandono  = 0
qqueda    = 0
mpres      = mwkdetfaltas.PRE_descriprest

Do While !Eof()
   Do While mcodres = &magrup And mhclin = REG_nrohclinica And !Eof()
      If fechatur < mfecha And Incl = 1
         If confirmado = 1
            lvino = .T.
         Endif
         presentes = presentes + Iif(lvino  ,1,0)
         ausentes  = ausentes  + Iif(!lvino ,1,0)
         abandono  = abandono  + Iif(mwkdetfaltas.confirmado  = 0 And !lvino ,1,0)
      Else
         qqueda = qqueda + Iif (fechatur < mfecha ,0,1)
      Endif
      mconf  = mwkdetfaltas.confirmado
      Skip
   Enddo
   If (mconf=0 And presentes=0) Or abandono >= mfaltas
      *	if mconf=0 or abandono>=3
      If ausentes =0 And presentes=0 And abandono=0 And qqueda >0
         If mhclin # REG_nrohclinica
            qqueda = 0
         Endif
      Else
         Insert Into faltas(paciente , entidad, reserva ;
            , presen , ausen,aband,quedan,hclin,presta ) Values (mpaciente , ment,mcodres,presentes ;
            ,ausentes ,abandono,qqueda,mhclin,mpres )
         qqueda = 0
      Endif
   Else
      qqueda = 0
   Endif
   mcodres= &magrup
   mpaciente = mwkdetfaltas.REG_nombrepac
   mhclin = mwkdetfaltas.REG_nrohclinica
   ment = mwkdetfaltas.ENT_descrient
   mconf  = mwkdetfaltas.confirmado
   presentes = 0
   ausentes = 0
   abandono = 0
   lvino = .F.
   mpres      = mwkdetfaltas.PRE_descriprest

Enddo
*Select * From faltas Order By paciente  Into Cursor faltas
If Used('mwktodos2')
   Select mwktodos2
   Use
Endif
If Used('mwkdetfaltas1')
   Use In mwkdetfaltas1
Endif
If Used('mwktodos')
   Use In mwktodos
Endif
If Used('mwktodosprevio')
   Use In mwktodosprevio
Endif
If Used('mwktodosprev')
   Use In mwktodosprev
Endif
If Used('mwkdetfaltas2')
   Use In mwkdetfaltas2
Endif
If Used('mwkdetfaltas')
   Use In mwkdetfaltas
Endif
If Used('mwkdetfalta')
   Use In mwkdetfalta
Endif
On Error &lcErrorAnt
