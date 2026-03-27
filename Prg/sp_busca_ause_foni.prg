****
** listado de ausentismo de foniatria
****
Parameter mfecha, mcodesp
lcErrorAnt = ON("ERROR")
on error
mccpoamb   = ''
mccpoambtf = ''
magrup     = "codreserva"
mfaltas    = 2
mfecnul    = Ctod("01/01/1900")

If mxambito > 1
   mccpoamb   = " turnos.codambito = ?mxambito and "
   mccpoambtf = " where  codambito = ?mxambito "
Endif
mret = SQLExec(mcon1,'select FechaCierre,FechaProceso FROM TurnosFechas '+ ;
   ' &mccpoambtf order by fechacierre ','mwkctrlfecha')
If mret<1
   Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
   Return .F.
Endif
Go Bottom In mwkctrlfecha
Skip -1
mfechacan = mwkctrlfecha.fechacierre
mbusprest = ''
if mcodesp ="FONI"
    mbusprest = " or codprest = 31010201 "
endif
mret = SQLExec(mcon1,"SELECT ENT_descrient, ENT_codent FROM entidades" ,"MWKEntidades")
If mret<1
   Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
   Return .F.
Endif

mret = SQLExec(mcon1, "select fechatur, horatur, codreserva, confirmado, " + ;
   " nombre, reg_nombrepac,  reg_nrohclinica, afiliado,codent,fechatomado " + ;
   " from turnos, registracio, afiliacion, prestadores " + ;
   " where &mccpoamb ( turnos.codesp = ?mcodesp &mbusprest ) and codmed = prestadores.id and " + ;
   " afiliado = afiliacion.registracio and codent = afi_codentidad and " + ;
   " afiliacion.registracio = registracio.reg_nroregistrac " + ;
   " Group By &magrup,reg_nrohclinica,fechatur", "mwktodos1")

If mret<1
   Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
   Return .F.
Endif

*Select * From mwktodos Group By &magrup,reg_nrohclinica,fechatur Into Cursor mwktodos1
*!*	Select * From mwktodos Group By reg_nrohclinica,fechatur ;
*!*		where fechatur < mfecha Order By reg_nrohclinica,fechatur Desc;
*!*		into Cursor mwktodos2

mret = SQLExec(mcon1, "select fechatur, horatur, codreserva, confirmado, " + ;
   "prestadores.nombre, preregistra.nombre as reg_nombrepac,  turnos.afiliado,turnos.codent,fechatomado " + ;
   "from turnos, preregistra, prestadores " + ;
   "where &mccpoamb ( turnos.codesp = ?mcodesp &mbusprest ) and codmed = prestadores.id and " + ;
   "turnos.afiliado = preregistra.id " + ;
   "group by &magrup,turnos.afiliado,fechatur", "mwktodos2")

If mret < 1
   Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
   Return .F.
Endif

mret = SQLExec(mcon1, "select afiliado,"+;
   " feccancela  " + ;
   " from turnoscancel as turnos " + ;
   " where &mccpoamb fechatur > ?mfechacan " + ;
   " and ( codesp = ?mcodesp &mbusprest )  " + ;
   " and codcancela  = 6 " + ;
   " Group By afiliado "+;
   " Order By afiliado, feccancela Desc ", "mwkcance")
*mwkcancela10

If mret<1
   Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
   Return .F.
Endif

*!*	Select * From mwkcancela10 Order By afiliado, feccancela Desc Into Cursor mwkcancela1
*!*	Select * From mwkcancela1 Group By afiliado Into Cursor mwkcance

Select fechatur, horatur, codreserva, confirmado, nombre, reg_nombrepac,  ;
   reg_nrohclinica, afiliado,codent,fechatomado From mwktodos1 ;
   union All ;
   select fechatur, horatur, codreserva, confirmado, nombre, reg_nombrepac,  ;
   transf(afiliado,"99999999-9") As reg_nrohclinica, afiliado,codent,fechatomado From mwktodos2 ;
   into Cursor mwktodosprev

Select fechatur, horatur, codreserva, confirmado, nombre, reg_nombrepac,  ;
   reg_nrohclinica, mwktodosprev.afiliado,codent,fechatomado,feccancela ;
   from mwktodosprev;
   left Join mwkcance On mwktodosprev.afiliado = mwkcance.afiliado ;
   into Cursor mwktodosprevio

Select * From mwktodosprevio ;
   where Isnull(feccancela) Or fechatomado >= feccancela;
   into Cursor mwktodos

Select reg_nombrepac, &magrup, reg_nrohclinica,;
   sum(Iif(confirmado = 0 And fechatur < mfecha , 1, 0)) As falto,  ;
   sum(Iif(confirmado = 1 And fechatur < mfecha , 1, 0)) As vino, ;
   sum(Iif(fechatur >= mfecha , 1, 0)) As quedan  ;
   from mwktodos ;
   group By reg_nombrepac, &magrup;
   order By reg_nombrepac Having falto>0 And quedan  > 0  ;
   into Cursor mwkfaltas

Select reg_nombrepac, confirmado ,fechatur,&magrup,reg_nrohclinica,codent,ent_descrient,1 As Incl  ;
   from mwktodos ;
   left Join mwkentidades On codent = ent_codent;
   where &magrup In (Select &magrup From mwkfaltas) ;
   order By reg_nombrepac, &magrup, fechatur Desc;
   into Cursor mwkdetfaltas1

Select reg_nombrepac, confirmado ,fechatur,&magrup,reg_nrohclinica,codent,ent_descrient,0 As Incl  ;
   from mwktodos ;
   left Join mwkentidades On codent = ent_codent;
   where &magrup Not In (Select &magrup From mwkdetfaltas1) And fechatur>=mfecha;
   and reg_nombrepac In (Select reg_nombrepac From mwkdetfaltas1) Order By reg_nombrepac, &magrup, fechatur Desc;
   into Cursor mwkdetfaltas2


Select * From mwkdetfaltas1;
   union All ;
   select * From mwkdetfaltas2;
   into Cursor mwkdetfalta

Select * From mwkdetfalta;
   order By reg_nrohclinica, &magrup Desc, fechatur Desc ;
   into Cursor mwkdetfaltas

Select mwkdetfaltas
Go Top
mcodres   = &magrup
mpaciente = mwkdetfaltas.reg_nombrepac
mhclin    = mwkdetfaltas.reg_nrohclinica
presentes = 0
ausentes  = 0
mconf     = mwkdetfaltas.confirmado
ment      = mwkdetfaltas.ent_descrient
abandono  = 0
qqueda    = 0
lvino     = .F.
Do While !Eof()
   Do While mcodres = &magrup And !Eof()
      If fechatur < mfecha And Incl = 1
         If mwkdetfaltas.confirmado = 1
            lvino = .T.
         Endif
         presentes = presentes +Iif(mwkdetfaltas.confirmado =1 ,1,0)
         ausentes  = ausentes +Iif(mwkdetfaltas.confirmado =0 ,1,0)
         abandono  = abandono + Iif((mwkdetfaltas.confirmado =0 ) And !lvino ,1,0)
      Else
         qqueda = qqueda + Iif (fechatur < mfecha ,0,1)
      Endif
      mconf  = mwkdetfaltas.confirmado
      Skip
   Enddo
   If (mconf = 0 And presentes=0) Or abandono >= mfaltas
      *!*			If Inlist(reg_nrohclinica, '3104853-0' , '3367184-7')
      *!*				*Set Step On
      *!*			Endif
      If ausentes = 0 And presentes = 0 And abandono = 0 And qqueda > 0
         If mhclin # reg_nrohclinica
            qqueda = 0
         Endif
      Else
         Insert Into faltas(paciente,entidad,reserva,presen,ausen,aband,quedan,hclin);
            Values (mpaciente,ment,mcodres,-1,ausentes,abandono,qqueda,mhclin)
         qqueda    = 0
      Endif
   Else
      qqueda    = 0
   Endif
   mcodres	  = &magrup
   mpaciente = mwkdetfaltas.reg_nombrepac
   mhclin    = mwkdetfaltas.reg_nrohclinica
   ment      = mwkdetfaltas.ent_descrient
   mconf     = mwkdetfaltas.confirmado
   presentes = 0
   ausentes  = 0
   abandono  = 0
   lvino     = .F.
Enddo
Select * From faltas Order By paciente  Into Cursor faltas

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