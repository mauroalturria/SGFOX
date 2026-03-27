Create Cursor dias (codme N(4),fecha D,hhmm N(4),diase N(1),esta N(1),nombre c(50),bd D,bh D,bbd D ,bbh D,bhd N(4),bhh N(4))
Select * From medprestalima Group By codmed,diasem ,hhmmdes ,hhmmhas,fecvigend,fecvigenh Into Cursor agenda
Select agenda

mfecnul = Ctod("01/01/1900")
desdefecha = Ctod("22/11/2022")
Scan
	mcodmed = agenda.codmed
	mnom = agenda.nombre
	For i =1 To 38
		diaf = desdefecha +i-1
	
		Select feriados_año
		Locate For dia = diaf
		If !Found()
			dsem = Dow(diaf)
			If dsem = agenda.diasem And Between(diaf,agenda.fecvigend ,agenda.fecvigenh)
				dh = Int(agenda.hhmmdes)
				hh = Int(agenda.hhmmhas)
				For u = dh To hh-1 Step 15
					hora = u
					Select * From tabbloamb Where codmed = mcodmed And  diaf>=fvigend And diaf<=fvigenh;
						AND hora >=prg_time_mmhh(horadesde) And hora<prg_time_mmhh(horahasta) Into Cursor establo

					Select * From dias Where codme  = mcodmed And fecha =diaf And hhmm = hora Into Cursor esta
					If Reccount('esta')=0
						If Reccount('establo')=0
							Insert Into dias Values (mcodmed,diaf, hora,dsem,0,mnom,agenda.bloquedesde ,agenda.bloquehasta,mfecnul ,mfecnul ,0,0)
						Else
							Insert Into dias Values (mcodmed,diaf, hora,dsem,0,mnom,agenda.bloquedesde ,agenda.bloquehasta,;
								establo.fvigend  ,establo.fvigenh ,prg_time_mmhh(establo.horadesde),prg_time_mmhh(establo.horahasta))
						Endif
					Endif
				Next u
			Endif
		Endif
	Next i
Endscan

Select turnoidpresta.*  ,nombre From medprestalima,turnoidpresta Where medprestalima.codmed = turnoidpresta.codmed ;
	AND medprestalima.diasem = turnoidpresta.diasem And medprestalima.hhmmdes <= turnoidpresta.hhmmtur ;
	AND medprestalima.hhmmhas> turnoidpresta.hhmmtur And medprestalima.fecvigend <= turnoidpresta.fechatur ;
	AND medprestalima.fecvigenh>= turnoidpresta.fechatur AND medprestalima.codprest = turnoidpresta.codprest   Group By turnoidpresta.Id Into Cursor cambiojuni
Select * From dias Where Transform(codme,"9999")+Dtos(fecha)+Transform(hhmm) Not In ;
	(Select Transform(codmed,"9999")+Dtos(fechatur)+Transform(hhmmtur) From cambiojuni );
	ORDER By nombre,fecha Into Cursor falta
Select * From agenda Where 	Transform(codmed,"9999")+Transform(diasem) In (Select Transform(codme,"9999")+Transform(diase) From falta) ;
	INTO Cursor controla

Set Step On

Select Int(Val(Strtran(Left(Ttoc(horardesde,2),5),":",""))) As hrd, Int(Val(Strtran(Left(Ttoc(horarhasta,2),5),":",""))) As hrh,* ;
	FROM tabreservados Into Cursor reserva
Browse Last
Select turnoidm.*,hrd,hrh  From reserva,turnoidm Where reserva.codmed = turnoidm.codmed ;
	AND reserva.diasem = turnoidm.diasem And reserva.hrd <= turnoidm.hhmmtur ;
	AND reserva.hrh>= turnoidm.hhmmtur And reserva.fecvigend <= turnoidm.fechatur ;
	AND reserva.fecvigenh>= turnoidm.fechatur   And tipoturno= 20 Group By turnoidm.Id Into Cursor cambiojuni
Select turnoidm.*,hrd,hrh  From reserva,turnoidm Where reserva.codmed = turnoidm.codmed ;
	AND reserva.diasem = turnoidm.diasem And reserva.hrd <= turnoidm.hhmmtur ;
	AND reserva.hrh>= turnoidm.hhmmtur And reserva.fecvigend <= turnoidm.fechatur ;
	AND reserva.fecvigenh>= turnoidm.fechatur   And turnoidm.tipoturno= 20 Group By turnoidm.Id Into Cursor cambiojuni
Browse Last
Update turnoidm Set tipoturno = 6 Where  Id In (Select Id From cambiojuni)



Select b_turnoid.*,nombre,canturnos  From b_medpresta,b_turnoid Where b_medpresta.codmed = b_turnoid.codmed ;
	AND b_medpresta.diasem = b_turnoid.diasem And b_medpresta.hhmmdes <= b_turnoid.hhmmtur And b_medpresta.codprest = b_turnoid.codprest;
	AND b_medpresta.hhmmhas>  b_turnoid.hhmmtur And b_medpresta.fecvigend <= b_turnoid.fechatur ;
	AND b_medpresta.fecvigenh>= b_turnoid.fechatur  And b_medpresta.codprest = b_turnoid.codprest Group By b_turnoid.Id Into Cursor cambiojuni
Browse Last
Select * From cambiojuni Group By  codmed,fechatur,hhmmtur,codreserva Having Count(Id)>1
Select Count(Id) As cuantos,* From cambiojuni Group By codmed,fechatur,hhmmtur Having Count(Id)>1 Into Cursor varios
Select * From varios Where cuantos>canturnos Into Cursor masdeuno
Select * From cambiojuni Where Transform(codmed,"@L 9999")+Dtos(fechatur)+Transform(hhmmtur,"@L 9999");
	in (Select Transform(codmed,"@L 9999")+Dtos(fechatur)+Transform(hhmmtur,"@L 9999") From masdeuno) Order By fechatur,nombre,hhmmtur,fechatomado;
	into Cursor anular

Select turnoidpresta.*   From medprestalima,turnoidpresta Where medprestalima.codmed = turnoidpresta.codmed ;
	AND medprestalima.diasem = turnoidpresta.diasem And medprestalima.hhmmdes <= turnoidpresta.hhmmtur ;
	AND medprestalima.hhmmhas> turnoidpresta.hhmmtur And medprestalima.fecvigend <= turnoidpresta.fechatur ;
	AND medprestalima.fecvigenh>= turnoidpresta.fechatur AND medprestalima.codprest = turnoidpresta.codprest   Group By turnoidpresta.Id Into Cursor cambiojuni
SELECT * FROM turnoidpresta WHERE id NOT in (SELECT id FROM cambiojuni) AND usuario = 'TURNOSMARKEY' INTO CURSOR noestan
