

SELECT Turnos.diasem, Turnos.fechatur, Turnos.tipoturno, Turnos.ID,;
  Turnos.afiliado, Turnos.hhmmTur, Turnos.codreserva, Turnos.usuariogenera,;
  Turnos.fechagenera, Turnos.codent, Turnos.codmed;
 FROM ;
     SQLUser.Turnos Turnos ;
    INNER JOIN SQLUser.TabTipoturno Tabtipoturno ;
   ON  Turnos.tipoturno = Tabtipoturno.tipoturno;
 WHERE  Turnos.fechatur >= {fn curdate()};
   AND  Turnos.tipoturno = 20
   
medprestalima
SELECT Medpresta.ID, Medpresta.diasem, Medpresta.duracion,;
  Medpresta.hhmmDes, Medpresta.hhmmHas, Medpresta.fecVigend,;
  Medpresta.fecVigenH, Medpresta.codmed, Medpresta.cantidad,;
  Medpresta.fechaUltAgenda, Medpresta.codprest,;
  Prestacions.PRE_descriprest, Prestacions.PRE_duracion,;
  Medpresta.codesp, Medpresta.codserv, Prestadores.nombre,;
  Medpresta.demanda, Medpresta.GeneraAgen, Medpresta.canturnos,;
  Prestadores.fecpasivap, Prestacions.PRE_fechapasiva, Medpresta.sala,;
  Prestadores.bloquedesde, Prestadores.bloquehasta;
 FROM ;
     SQLUser.MedPresta Medpresta ;
    INNER JOIN SQLUser.PRESTADORES Prestadores ;
   ON  Medpresta.codmed = Prestadores.ID ;
    INNER JOIN SQLUser.PRESTACIONS Prestacions ;
   ON  Medpresta.codprest = Prestacions.PRE_codprest;
 WHERE  Medpresta.fecVigenH > Medpresta.fecVigend;
   AND  (  Medpresta.fecVigenH >= {fn curdate()};
   AND  (  Medpresta.GeneraAgen = ( 1 );
   AND  Medpresta.codserv = 1130 ) );
 ORDER BY Medpresta.codmed, Medpresta.diasem, Medpresta.hhmmDes
 
   
   
   Select turnoid.*,nombre,pre_descriprest  From medprestalima,turnoid Where medprestalima.codmed = turnoid.codmed ;
	AND medprestalima.diasem = turnoid.diasem And medprestalima.hhmmdes <= turnoid.hhmmtur ;
	AND medprestalima.hhmmhas>  turnoid.hhmmtur And medprestalima.fecvigend <= turnoid.fechatur ;
	AND medprestalima.fecvigenh>= turnoid.fechatur     group By turnoid.Id Into Cursor cambiojuni

UPDATE turnoidm SET tipoturno=0 WHERE id in (select id from cambiojuni)

*PARA turnos Lima
UPDATE turnoidm SET tipoturno=20 WHERE id in (select id from cambiojuni)
* si hay usuariogenera = TURNOSMARKEY
UPDATE turnoidm SET tipoturno=21 WHERE id in (select id from cambiojuni)

  Select turnoidm.*,codesp,,pre_descriprest  From medprestabk,turnoidm Where medprestabk.codmed = turnoidm.codmed ;
	AND medprestabk.diasem = turnoidm.diasem And medprestabk.hhmmdes <= turnoidm.hhmmtur ;
	AND medprestabk.hhmmhas>  turnoidm.hhmmtur And medprestabk.fecvigend <= turnoidm.fechatur ;
	AND medprestabk.fecvigenh>= turnoidm.fechatur    group By turnoidm.Id Into Cursor cambiojuni
