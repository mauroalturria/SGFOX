Use "c:\mis documentos\bloqfran.dbf" In 0 Exclusive
Select 2
Browse Last
Update bloqfran Set horades = Val(Strtran(desde,":",""))
Update bloqfran Set horahas = Val(Strtran(hasta,":",""))
Browse Last
Modify View franja
Select * From franja,bloqfran Where diasem = dia And franja.codmed = bloqfran.codmed And Between(horades,hhmmdes,hhmmhas) And Between(horahas,hhmmdes,hhmmhas)
Select 2
Browse Last
Update bloqfran Set Regi = Recno()
Select * From franja,bloqfran Where diasem = dia And franja.codmed = bloqfran.codmed And Between(horades,hhmmdes,hhmmhas) And Between(horahas,hhmmdes,hhmmhas) Into Cursor datos
Select * From bloqfran  Where Regi Not In (Select Regi From datos) Into Cursor falta
Browse Last
Select * From franja Where Transform(codmed,"@L 9999")+Transform(dia) In (Select  Transform(codmed,"@L 9999")+Transform(dia)  From falta)
Select * From franja Where Transform(codmed,"@L 9999")+Transform(diasem) In (Select  Transform(codmed,"@L 9999")+Transform(dia)  From falta)
Select 3
Browse Last
Select * From bloqfran  Where Regi Not In (Select Regi From datos)  Order By codmed,diasem Into Cursor falta
Select * From bloqfran  Where Regi Not In (Select Regi From datos)  Order By codmed,dia Into Cursor falta
Select * From franja Where Transform(codmed,"@L 9999")+Transform(diasem) In (Select  Transform(codmed,"@L 9999")+Transform(dia)  From falta)
Select 8
Browse Last
Use c:\desaguemes\bloqfran.Dbf In 0 Exclusive
Select 4
Browse Last
Use
Use c:\desaguemes\bloqfran.Dbf In 0 Exclusive
Select 8
Browse Last
Select 4
Browse Last
Update d Set Regi = Recno()
Select 4
Browse Last
Update d Set horades = Val(Strtran(desde,":",""))
Update d Set horahas = Val(Strtran(hasta,":",""))
Browse Last
Select * From franja,d Where diasem = dia And franja.codmed = bloqfran.codmed And Between(horades,hhmmdes,hhmmhas) And Between(horahas,hhmmdes,hhmmhas) Into Cursor datos
Select * From d  Where Regi Not In (Select Regi From datos)  Order By codmed,dia Into Cursor falta
Select * From franja Where Transform(codmed,"@L 9999")+Transform(diasem) In (Select  Transform(codmed,"@L 9999")+Transform(dia)  From falta)
Select 8
Select 4
Select 8
Select 10
Browse Last
Select 4
Browse Last
Select * From franja Where Transform(codmed,"@L 9999")+Transform(diasem) In (Select  Transform(codmed,"@L 9999")+Transform(dia)  From d)
Select * From franja Where codmed = d.codmed And diasem = dia
Select * From franja Where codmed = d.codmed And diasem = d.dia
Select * From franja,d Where diasem = dia And franja.codmed = d.codmed And Between(horades,hhmmdes,hhmmhas) And Between(horahas,hhmmdes,hhmmhas) Into Cursor datos
Select * From d  Where Regi Not In (Select Regi From datos)  Order By codmed,dia Into Cursor falta
Select * From franja Where Transform(codmed,"@L 9999")+Transform(diasem) In (Select  Transform(codmed,"@L 9999")+Transform(dia)  From falta)
Select 9
Browse Last
Select * From franja Into Cursor faltantes
Select * From faltantes Union All Select * From  franja Into Cursor faltantes
Copy To faltntes Type Xl5
Copy To faltantes Type Xl5
Select 10
Browse Last
Select * From d,franja Where diasem = dia And franja.codmed = d.codmed And Between(horades,hhmmdes,hhmmhas) And Between(horahas,hhmmdes,hhmmhas) Into Cursor datos
Browse Last
Select * From d,franja Where diasem = dia And franja.codmed = d.codmed And Between(horades,hhmmdes,hhmmhas) And Between(horahas,hhmmdes,hhmmhas) Into Cursor datos
Select 4
Select 10
Select * From datos Group By Regi
Do c:\desaguemes\prg\0seteos_quirof.prg
Select * From datos Group By Regi
Select 10
Browse Last
Select * From d Where horades = horahas
Select 4
Browse Last
Locate For codmed = 38
Select * From d,franja Where diasem = dia And franja.codmed = d.codmed And Between(horades,hhmmdes,hhmmhas) And Between(horahas,hhmmdes,hhmmhas) Into Cursor datos
Browse Last
Select * From datos Group By Regi Having Count(Id)>1
Locate For codmed = 5544
Locate For codmed_a = 5544
Select 4
Locate For codmed = 5544
Browse Last
Select 11
Browse Last
Select 27
Locate For codmed_a = 1492
Browse Last
Select 7
Select * From d  Where Regi Not In (Select Regi From datos)  Order By codmed,dia Into Cursor falta
Browse Last
Select * From falta Union All Select *From d Where codmed Inlist(5544,373) Into Cursor faltas
Select * From falta Union All Select * From d Where codmed Inlist(5544,373) Into Cursor faltas
Select * From falta Union All Select * From d Where Inlist(codmed ,5544,373) Into Cursor faltas
Browse Last
Select * From falta Union All Select * From d Where Inlist(codmed ,5544,1492) Into Cursor faltas
Browse Last
Copy To faltas Type Xl5
Select * From  franja Where Id Not In (Select Id From datos)  Into Cursor noaplica
Browse Last
Modify View tabbloamb
Select * From  noaplica Where Id Not In (Select idfranja From tabbloamb)  Into Cursor noaplicamas
Select 31
Select 33
Browse Last
Select * From tabbloamb Order By fechagraba
Select * From tabbloamb Where fecvigenh<Date()
Update  tabbloamb Set bloqanulado = 1,fecanula = fecvigenh ,usuarioanula = 'CARMENA' Where fecvigenh<Date()
Select 27
Browse Last
Select * From datos,tabbloamb Where tipo = "DE" And datos.Id =  idfranja  Into Cursor bloquear

Select * From datos,bloqueosamb Where tipo = "TT" And datos.Id =  idfranja  Into Cursor nobloquear
Select * From datos,bloqueosamb Where tipo = "DE" And datos.Id =  idfranja  Into Cursor bloquear



Use Dbf('BLOQUEAR')  In 0 Again Alias ponerbloq
Select 9
Browse Last
Update SACARBLOQ Set TIPOSERVICIO = 9 Where horades=HDESB And horahas = HHASB
Select * From SACARBLOQ Where TIPOSERVICIO<>9
Select * From SACARBLOQ Where TIPOSERVICIO<>9 And horahas<HHASB
Select * From SACARBLOQ Where TIPOSERVICIO<>9 And horahas<HHASB And horades<=HDESB
Select * From SACARBLOQ Where TIPOSERVICIO<>9 And horahas<HHASB And horades<=HDESB Into Cursor hasta
Update SACARBLOQ Set TIPOSERVICIO = -1,HDESB= horahas Where id_a In (Select id_a From hasta)
Where TIPOSERVICIO<>9
SE
Select s TIPOSERVICIO<>9
Select Distinct TIPOSERVICIO   From SACARBLOQ
Select * From SACARBLOQ Where TIPOSERVICIO=1
Select * From SACARBLOQ Where TIPOSERVICIO=1 And horahas<hhmmhSA_A Into Cursor fractal
Select * From SACARBLOQ Where TIPOSERVICIO=1 And horahas<hhmmhas_A Into Cursor fractal
Update SACARBLOQ Set TIPOSERVICIO = -2,HHASB= horades Where TIPOSERVICIO=1
Append From Dbf('fractal')
Update SACARBLOQ Set TIPOSERVICIO = -3,HDESB= horahas Where TIPOSERVICIO=1
Browse Last
Select * From SACARBLOQ Order By codmed,diasem,horades
Select * From SACARBLOQ Order By codmed,diasem_a,horades
Copy To modibloq_turno
Select 9
Browse Last
Use Dbf('BLOQUEAR')  In 0 Again Alias ponerbloq
Select 9
Browse Last
Update ponerbloq Set TIPOSERVICIO = 0 Where horades=HDESB And horahas = HHASB
Select * From ponerbloq Where TIPOSERVICIO<>9
Select * From ponerbloq Where TIPOSERVICIO<>9 And horahas<HHASB
Select * From ponerbloq Where TIPOSERVICIO<>9 And horahas<HHASB And horades<=HDESB
Select * From ponerbloq Where TIPOSERVICIO<>9 And horahas<HHASB And horades<=HDESB Into Cursor hasta
Update ponerbloq Set TIPOSERVICIO = -1,HDESB= horahas Where id_a In (Select id_a From hasta)
Where TIPOSERVICIO<>9
SE
Select s TIPOSERVICIO<>9
Select Distinct TIPOSERVICIO   From SACARBLOQ
Select * From ponerbloq Where TIPOSERVICIO=1
Select * From ponerbloq Where TIPOSERVICIO=1 And horahas<hhmmhSA_A Into Cursor fractal
Select * From ponerbloq Where TIPOSERVICIO=1 And horahas<hhmmhas_A Into Cursor fractal
Update ponerbloq Set TIPOSERVICIO = -2,HHASB= horades Where TIPOSERVICIO=1
Append From Dbf('fractal')
Update ponerbloq Set TIPOSERVICIO = -3,HDESB= horahas Where TIPOSERVICIO=1
Browse Last
Select * From ponerbloq Order By codmed,diasem,horades
Select * From ponerbloq Order By codmed,diasem_a,horades
Copy To modibloq_turno
Select 9
Browse Last
Select * From ponerbloq Where TIPOSERVICIO=0 Order By codmed,diasem_a,horades
Select * From ponerbloq Where TIPOSERVICIO=1 Order By codmed,diasem_a,horades
Browse Last
Update ponerbloq  Set TIPOSERVICIO = -1,HHASB= horahas Where TIPOSERVICIO=1
Select * From ponerbloq Where TIPOSERVICIO=-1 Order By codmed,diasem_a,horades Into Cursor arreglo
Update ponerbloq  Set TIPOSERVICIO = -2 Where TIPOSERVICIO=-1 And hhmmhas_A>horahas
Select * From ponerbloq Where TIPOSERVICIO=-1 Order By codmed,diasem_a,horades Into Cursor arreglo
Browse Last
Update ponerbloq  Set HHASB= hhmmhas_A Where TIPOSERVICIO=-2
Update ponerbloq  Set HDESB=horades Where Where TIPOSERVICIO=-1
Update ponerbloq  Set HDESB=horades Where TIPOSERVICIO=-1
Select * From ponerbloq Where TIPOSERVICIO=1
Select 11
Copy To ponerbloqueo


Select * From medprestabk,franjadrive Where medprestabk.codmed = franjadrive.codmed ;
	AND medprestabk.diasem = franjadrive.diasem And medprestabk.hhmmdes < franjadrive.hhmmhas ;
	AND medprestabk.hhmmhas> = franjadrive.hhmmdes
Select * From franja,franjadrive Where franja.codmed = franjadrive.codmed ;
	AND franja.diasem = franjadrive.diasem And !(franja.hhmmdes < franjadrive.hhmmhas ;
	AND franja.hhmmhas> franjadrive.hhmmdes) Into Cursor cambio


Select * From medprestabk,franjadrive Where medprestabk.codmed = franjadrive.codmed
Select * From medprestabk,franjadrive Where medprestabk.codmed = franjadrive.codmed ;
	AND medprestabk.diasem = franjadrive.diasem
Select * From medprestabk,franjadrive Where medprestabk.codmed = franjadrive.codmed ;
	AND medprestabk.diasem = franjadrive.diasem And medprestabk.hhmmdes < franjadrive.hhmmhas
Modify View medprestabk
Select * From medprestabk,franjadrive Where medprestabk.codmed = franjadrive.codmed ;
	AND medprestabk.diasem = franjadrive.diasem And medprestabk.hhmmdes < franjadrive.hhmmhas ;
	AND medprestabk.hhmmhas> = franjadrive.hhmmdes Into Cursor cambio
Select * From medprestabk,franjadrive Where medprestabk.codmed = franjadrive.codmed ;
	AND medprestabk.diasem = franjadrive.diasem And medprestabk.hhmmdes < franjadrive.hhmmhas
Select * From medprestabk,franjadrive Where medprestabk.codmed = franjadrive.codmed ;
	AND medprestabk.diasem = franjadrive.diasem And medprestabk.hhmmdes < franjadrive.hhmmhas ;
	AND medprestabk.hhmmhas> = franjadrive.hhmmdes
Select * From medprestabk,franjadrive Where medprestabk.codmed = franjadrive.codmed ;
	AND medprestabk.diasem = franjadrive.diasem And medprestabk.hhmmdes < franjadrive.hhmmhas ;
	AND medprestabk.hhmmhas>= franjadrive.hhmmdes Into Cursor cambio
Browse Last
?Vartype(duracion)
Modify Command c:\desaguemes\prg\prg_hm_min.prg As 1252
Select Val(Left(duracion,2)+Substr(duracion,4,2)) As dura,* From medprestabk,franjadrive Where medprestabk.codmed = franjadrive.codmed ;
	AND medprestabk.diasem = franjadrive.diasem And medprestabk.hhmmdes < franjadrive.hhmmhas ;
	AND medprestabk.hhmmhas>= franjadrive.hhmmdes Into Cursor cambio
Browse Last
Select Val(Left(duracion,2)+Substr(duracion,4,2)) As dura,* From medprestabk,franjadrive Where medprestabk.codmed = franjadrive.codmed ;
	AND medprestabk.diasem = franjadrive.diasem And medprestabk.hhmmdes < franjadrive.hhmmhas ;
	AND medprestabk.hhmmhas>= franjadrive.hhmmdes Where dura<16 Into Cursor cambio
Select Val(Left(duracion,2)+Substr(duracion,4,2)) As dura,* From medprestabk,franjadrive Where medprestabk.codmed = franjadrive.codmed ;
	AND medprestabk.diasem = franjadrive.diasem And medprestabk.hhmmdes < franjadrive.hhmmhas ;
	AND medprestabk.hhmmhas>= franjadrive.hhmmdes Where  Val(Left(duracion,2)+Substr(duracion,4,2))<16 Into Cursor cambio
Select Val(Left(duracion,2)+Substr(duracion,4,2)) As dura,* From medprestabk,franjadrive Where medprestabk.codmed = franjadrive.codmed ;
	AND medprestabk.diasem = franjadrive.diasem And medprestabk.hhmmdes < franjadrive.hhmmhas ;
	AND medprestabk.hhmmhas>= franjadrive.hhmmdes Into Cursor cambio
Select * From cambio Where dura<16 Into Cursor cambiar
Browse Last
Select * From cambio Where dura<16 Group By id_a Into Cursor cambiar
Browse Last
Select Distinct codmed_a,NOMBRE From cambiar
Copy To MEDICAM Type Xl5
Select Val(Left(duracion,2)+Substr(duracion,4,2)) As dura,* From medprestabk,franjadrive Where medprestabk.codmed = franjadrive.codmed ;
	AND medprestabk.diasem = franjadrive.diasem And medprestabk.hhmmdes <= franjadrive.hhmmhas ;
	AND medprestabk.hhmmhas>= franjadrive.hhmmdes Into Cursor cambio
Select * From cambio Where dura<16 Group By id_a Into Cursor cambiar
Select Distinct codmed_a,NOMBRE From cambiar
Select Distinct codmed_a,NOMBRE Order By NOMBRE From cambiar
Use tipoturno Again In 0
Select tipoturno
Browse Last
Modify View turnoid
Modify View turnoent
Modify View turnobristoñ
Delete View turnobristoñ
Modify View turnoidp
Modify View turnoidrank
Select  turnoidrank
Select * From  turnoidrank Order By NOMBRE,diasem Group By By NOMBRE,diasem
Select * From  turnoidrank Order By NOMBRE,diasem Group By NOMBRE,diasem
Copy To turnoste Type Xl5
Select 2
Browse Last
Select * From medprestabk Where codmed = 5557
Select * From medprestabk Where Left(NOMBRE ,5)= 'PONCE'
Select * From medprestabk Where codesp= 'PEDI'
Select * From medprestabk Where codesp= 'PEDI' Group By codprest
Select 4
Browse Last
Select * From medprestabk,turnoidrank  Where medprestabk.codmed = turnoidrank.codmed  And medprestabk.diasem = turnoidrank.diasem
Select * From medprestabk,turnoidrank  Where medprestabk.codmed = turnoidrank.codmed  And medprestabk.diasem = turnoidrank.diasem;
	order By duracion
Select 6
Select 4
Browse Last
Select * From medprestabk Where At('EXTERNA',pre_descriprest)>0
Select * From medprestabk Where At('EXTERNA',pre_descriprest)>0 Order By pre_descriprest
Update medprestabk Set cantidad = 1 Where At('EXTERNA',pre_descriprest)>0
Update medprestabk Set cantidad = 1 Where At('NIÑO SANO',pre_descriprest)>0
Select * From medprestabk Where At('NIÑO SANO',pre_descriprest)>0
Modify View ctrlunif
Select * From medprestabk Where At('EXTERNA',pre_descriprest)>0
Select * From medprestabk Where At('EXTERNA',pre_descriprest)>0 Order By duracion, pre_descriprest
Select * From medprestabk Where At('DISTANC',pre_descriprest)>0 Order By duracion, pre_descriprest
Update medprestabk Set cantidad = 1  Where At('DISTANC',pre_descriprest)>0
Select * From medprestabk Where At('DISTANC',pre_descriprest)>0 Order By duracion, pre_descriprest
Select * From medprestabk Where codesp= 'PSIC' Group By duracion,codprest
Select * From medprestabk Where Inlist(codprest,   42010148,   42010185 )
Select * From medprestabk Where Inlist(codprest,   42010148,   42010185 ) Order By duracion, pre_descriprest
Modify View medprestabk
Select * From medprestabk Where At('ART',pre_descriprest)>0 Order By duracion, pre_descriprest
Update medprestabk Set cantidad = 1  Where codprest =    42030729
Select * From medprestabk Where At('CONSULTA CONTROL',pre_descriprest)>0 Order By duracion, pre_descriprest
Select * From medprestabk Where At('CONSULTA CONTROL DEL RECIEN NACIDO',pre_descriprest)>0 Order By duracion, pre_descriprest
Update medprestabk Set cantidad = 1  Where At('CONSULTA CONTROL DEL RECIEN NACIDO',pre_descriprest)>0
Select * From medprestabk Where At('INTERDISCI',pre_descriprest)>0 Order By duracion, pre_descriprest
Update medprestabk Set cantidad = 1  Where At('INTERDISCI',pre_descriprest)>0
Update medprestabk Set cantidad = Null  Where At('INTERDISCI',pre_descriprest)>0
Select * From medprestabk Where At('INTERDISCI',pre_descriprest)>0 Order By duracion, pre_descriprest
Select * From medprestabk Where At('CONSULTA CONTROL',pre_descriprest)>0 Order By duracion, pre_descriprest
Update medprestabk Set cantidad = Null  Where At('CONSULTA CONTROL DEL RECIEN NACIDO',pre_descriprest)>0
Select * From medprestabk Where At('CONSULTA CONTROL',pre_descriprest)>0 Order By duracion, pre_descriprest
Select * From medprestabk Where At('CONSULTA CONTROL DEL RECIEN NACIDO',pre_descriprest)>0 Order By duracion, pre_descriprest
Update medprestabk Set duracion ='01:00:00' Where At('CONSULTA CONTROL DEL RECIEN NACIDO',pre_descriprest)>0
Select * From medprestabk Where At('CONSULTA CONTROL DEL RECIEN NACIDO',pre_descriprest)>0 Order By duracion, pre_descriprest
Select * From medprestabk Where At('INTERDISCI',pre_descriprest)>0 Order By duracion, pre_descriprest
Update medprestabk Set duracion ='01:00:00' Where At('INTERDISCI',pre_descriprest)>0
Select * From medprestabk Where At('INTERDISCI',pre_descriprest)>0 Order By duracion, pre_descriprest
Select * From medprestabk Where At('NIÑO SANO',pre_descriprest)>0
Select Val(Left(duracion,2)+Substr(duracion,4,2)) As dura,* From medprestabk,franjadrive Where medprestabk.codmed = franjadrive.codmed ;
	AND medprestabk.diasem = franjadrive.diasem Group By medprestabk.Id Into Cursor cambio
Browse Last
Select Val(Left(duracion,2)+Substr(duracion,4,2)) As dura,* From medprestabk,franjadrive Where medprestabk.codmed = franjadrive.codmed ;
	AND medprestabk.diasem = franjadrive.diasem And Isnull(cantidad) Group By medprestabk.Id Into Cursor cambio
Browse Last
Select * From cambio Order By dura
Select * From cambio Where hhmmdes_a <=  hhmmhas_b ;
	AND hhmmhas_A>= hhmmdes_b Order By dura
Select * From cambio Where hhmmdes_a <  hhmmhas_b ;
	AND hhmmhas_A>= hhmmdes_b Order By dura
Select * From cambio Where hhmmdes_a <  hhmmhas_b ;
	AND hhmmhas_A>= hhmmdes_b Order By codmed_a,diasem_a,hhmmdes_a
Select * From cambio Where hhmmdes_a <  hhmmhas_b ;
	AND hhmmhas_A>= hhmmdes_b Order By codmed_a,diasem_a,hhmmdes_a Where dura<16
Select * From cambio Where hhmmdes_a <  hhmmhas_b And dura<16;
	AND hhmmhas_A>= hhmmdes_b Order By codmed_a,diasem_a,hhmmdes_a   dura<16
Select * From cambio Where hhmmdes_a <  hhmmhas_b And dura<16;
	AND hhmmhas_A>= hhmmdes_b Order By codmed_a,diasem_a,hhmmdes_a
Select * From medprestabk Where Id In (Select id_a
Select * From cambio Where hhmmdes_a <  hhmmhas_b And dura<16;
	AND hhmmhas_A>= hhmmdes_b Order By codmed_a,diasem_a,hhmmdes_a Into Cursor cambiadur
Select * From medprestabk Where Id In (Select id_a From cambiadur)
Select * From medprestabk Where At('EXTERNA',pre_descriprest)>0
Select * From medprestabk Where At('EXTERNA',pre_descriprest)>0 Order By duracion, pre_descriprest
Select * From medprestabk Where At('EXTERNA',pre_descriprest)>0 Order By  pre_descriprest
Update medprestabk Set cantidad = Null  Where At('EXTERNA',pre_descriprest)>0
Update medprestabk Set cantidad = 1  Where codprest =    42030455
Select * From medprestabk Where At('EXTERNA',pre_descriprest)>0 Order By  pre_descriprest
Select Val(Left(duracion,2)+Substr(duracion,4,2)) As dura,* From medprestabk,franjadrive Where medprestabk.codmed = franjadrive.codmed ;
	AND medprestabk.diasem = franjadrive.diasem And Isnull(cantidad) Group By medprestabk.Id Into Cursor cambio
Select * From cambio Where hhmmdes_a <  hhmmhas_b And dura<16;
	AND hhmmhas_A>= hhmmdes_b Order By codmed_a,diasem_a,hhmmdes_a Into Cursor cambiadur
Select * From medprestabk Where Id In (Select id_a From cambiadur)
Copy To duracionanterior
Copy To duracionanterior Type Xl5
Select * From medprestabk  Where Id In (Select id_a From cambiadur)
Select * From medprestabk  Where Id In (Select id_a From cambiadur) Order By codesp,NOMBRE
Modify View medpresta
Select * From medprestabk  Where Id In (Select id_a From cambiadur) And codmed = 843 Order By codesp,NOMBRE
Modify View turnoid
Modify View turnoidrank
Select * From medprestabk  Where Id In (Select id_a From cambiadur) And Left(codesp,2)="EC" Order By codesp,NOMBRE
Select 2
Browse Last
Select * From cambio Where hhmmdes_a <  hhmmhas_b And dura<16 And codserv<>7900;
	AND hhmmhas_A>= hhmmdes_b Order By codmed_a,diasem_a,hhmmdes_a Into Cursor cambiadur
Browse Last
Select * From cambio Where hhmmdes_a <  hhmmhas_b And dura<16 And !Inlist(codserv,7900,7300);
	AND hhmmhas_A>= hhmmdes_b Order By codmed_a,diasem_a,hhmmdes_a Into Cursor cambiadur
Browse Last
Select * From cambio Where hhmmdes_a <  hhmmhas_b And dura<16 And !Inlist(codserv,2200,7900,7300);
	AND hhmmhas_A>= hhmmdes_b Order By codmed_a,diasem_a,hhmmdes_a Into Cursor cambiadur
Browse Last
Select * From cambio Where hhmmdes_a <  hhmmhas_b And dura<16 And !Inlist(codserv,2200,7900,7300);
	AND hhmmhas_A>= hhmmdes_b Order By codmed_a,diasem_a,hhmmdes_a Group By codserv Into Cursor cambiadur
Browse Last
Select * From cambio Where hhmmdes_a <  hhmmhas_b And dura<16 And !Inlist(codserv,7900,7300);
	AND hhmmhas_A>= hhmmdes_b Order By codmed_a,diasem_a,hhmmdes_a Group By codserv Into Cursor cambiadur
Modify View gua_pac
Select * From cambio Where hhmmdes_a <  hhmmhas_b And dura<16 And !Inlist(codserv,7900,7300);
	AND hhmmhas_A>= hhmmdes_b Order By codmed_a,diasem_a,hhmmdes_a Group By codserv Into Cursor cambiadur
Copy To cambiadura
Select * From medprestabk  Where Id In (Select id_a From cambiadur) And codserv = 7300 Order By codesp,NOMBRE
Select * From medprestabk  Where  codserv = 7300 Order By codesp,NOMBRE
Select * From cambio Where hhmmdes_a <  hhmmhas_b And dura<16 And !Inlist(codserv,7900);
	AND hhmmhas_A>= hhmmdes_b Order By codmed_a,diasem_a,hhmmdes_a Group By codserv Into Cursor cambiadur
Select * From medprestabk  Where Id In (Select id_a From cambiadur) Order By codesp,NOMBRE
Select * From cambio Where hhmmdes_a <  hhmmhas_b And dura<16 And !Inlist(codserv,7900,7300);
	AND hhmmhas_A>= hhmmdes_b Order By codmed_a,diasem_a,hhmmdes_a  Into Cursor cambiadur
Select * From medprestabk  Where Id In (Select id_a From cambiadur) Order By codesp,NOMBRE
Select 13
Copy To cambiadur
Copy To duracionanterior
Copy To duracionanterior Type Xl5
Update  medprestabk  Set duracion = '00:30:00' ,cantidad = 1 Where Id In (Select id_a From cambiadur)
Use franjadrive Again In 0 Alias Franjadrive_a
Select Franjadrive_a
Browse Last
Select 13
Create View Remote
Modify View medprestabk
Select 13
Select 1
Select * From franjadrive Where codmed = ?codmed And diasem =?diasem
Select * From franjadrive Where codmed = view18.codmed And diasem =view18.diasem
Select * From franjadrive Where codmed = 256
Select * From franjadrive Where codmed = 135
Select * From franjadrive Where codmed = 208
Select * From franjadrive Where codmed = 100
Modify View medprestapp
Modify Command c:\desaguemes\vrs\bloqfran.prg As 1252
Modify Command c:\desaguemes\vrs\desbloq.prg As 1252
Update medprestapp Set duracion ='01:00:00' Where At('NIÑO SANO',pre_descriprest)>0
Update medprestapp Set duracion ='01:00:00' Where At('CONSULTA CONTROL DEL RECIEN NACIDO',pre_descriprest)>0
Update medprestapp Set duracion ='00:15:00' Where codprest = 42030729
Update medprestapp Set duracion ='00:15:00' Where At('DISTANC',pre_descriprest)>0

Select Val(Left(duracion,2)+Substr(duracion,4,2)) As dura,* From medprestabk,franjadrive Where medprestabk.codmed = franjadrive.codmed ;
	AND medprestabk.diasem = franjadrive.diasem And Isnull(cantidad) Group By medprestabk.Id Into Cursor cambio
Select * From cambio Where hhmmdes_a <  hhmmhas_b And dura<16;
	AND hhmmhas_A>= hhmmdes_b Order By codmed_a,diasem_a,hhmmdes_a Into Cursor cambiadur
Select * From medprestabk Where Id In (Select id_a From cambiadur)
Update  medprestabk  Set duracion = '00:30:00' ,cantidad = 1 Where Id In (Select id_a From cambiadur)
Select * From medprestabk Where generaagen= 1 And Id Not In (Select id_a From medfran) ;
	AND codmed Not In (Select codmed From franjadrive) And !Like('EC*',codesp) And !Like('R*',codesp);
	INTO Cursor nofranmed
Select Distinct codesp From nofranmed
Select * From medprestabk Where generaagen= 1 And Id Not In (Select id_a From medfran) ;
	AND codmed Not In (Select codmed From franjadrive) And !Like('EC*',codesp) And !Like('R*',codesp) And !Inlist(codesp,'VACU','TOMO');
	INTO Cursor nofranmed
Select Distinct codesp From nofranmed
Select * From medprestabk Where generaagen= 1 And Id Not In (Select id_a From medfran) ;
	AND codmed Not In (Select codmed From franjadrive) And !Like('EC*',codesp) And !Like('R*',codesp) And !Inlist(codesp,'INVE'.'VACU','TOMO');
	INTO Cursor nofranmed
Select Distinct codesp From nofranmed
Select * From medprestabk Where generaagen= 1 And Id Not In (Select id_a From medfran) ;
	AND codmed Not In (Select codmed From franjadrive) And !Like('EC*',codesp) And !Like('R*',codesp) And !Inlist(codesp,'INVE','VACU','TOMO');
	INTO Cursor nofranmed
Select Distinct codesp From nofranmed
Select 6
Browse Last
Select  * From franja,franjadrive Where franjapp.codmed = franjadrive.codmed ;
	AND franjapp.diasem = franjadrive.diasem And franjapp.hhmmdes < franjadrive.hhmmhas ;
	AND franjapp.hhmmhas>= franjadrive.hhmmdes Into Cursor cambioS
Modify View franja
Select 10
Select 11
Select 6
Browse Last
Select franja.* From franja,nofranmed Where franja.codmed = nofranmed.codmed ;
	AND franja.diasem = nofranmed.diasem And franja.hhmmdes < nofranmed.hhmmhas ;
	AND franja.hhmmhas>= nofranmed.hhmmdes Into Cursor cambioS
Browse Last
Select franja.* From franja,nofranmed Where franja.codmed = nofranmed.codmed ;
	AND franja.diasem = nofranmed.diasem And franja.hhmmdes < nofranmed.hhmmhas ;
	AND franja.hhmmhas>= nofranmed.hhmmdes Group By codmed,diasem,hhmmdes Into Cursor cambioS
Select franja.* From franja,nofranmed Where franja.codmed = nofranmed.codmed ;
	AND franja.diasem = nofranmed.diasem And franja.hhmmdes < nofranmed.hhmmhas ;
	AND franja.hhmmhas>= nofranmed.hhmmdes Group By franja.codmed,franja.diasem,franja.hhmmdes Into Cursor cambioS
Select 14
Browse Last
Copy To BAJAR Type Xl5
Select 3
Browse Last
Select franja.* From franja,nofranmed Where franja.codmed = nofranmed.codmed ;
	AND franja.diasem = nofranmed.diasem And franja.hhmmdes < nofranmed.hhmmhas ;
	AND franja.hhmmhas>= nofranmed.hhmmdes Order By franja.codmed,franja.diasem,franja.hhmmdes Group By franja.codmed,franja.diasem,franja.hhmmdes Into Cursor cambioS
Browse Last
Copy To BAJAR Type Xl5
Select Distinct codesp From nofranmed
Select 6
Select * From medprestabk Where generaagen= 1 And Id Not In (Select id_a From medfran) ;
	AND codmed Not In (Select codmed From franjadrive) And !Like('EC*',codesp) And !Like('R*',codesp) And !Inlist(codesp,'MEDN','INVE','VACU','TOMO');
	INTO Cursor nofranmed
Browse Last
Select franja.*,nofranmed.codesp From franja,nofranmed Where franja.codmed = nofranmed.codmed ;
	AND franja.diasem = nofranmed.diasem And franja.hhmmdes < nofranmed.hhmmhas ;
	AND franja.hhmmhas>= nofranmed.hhmmdes Order By franja.codmed,franja.diasem,franja.hhmmdes Group By franja.codmed,franja.diasem,franja.hhmmdes Into Cursor cambioS
Browse Last
Copy To BAJAR Type Xl5


Select * From medprestabk,turnos_vacunas Where medprestabk.codmed = turnos_vacunas.codmed ;
	AND medprestabk.diasem = turnos_vacunas.diasem And medprestabk.hhmmdes <= turnos_vacunas.hhmmtur ;
	AND medprestabk.hhmmhas>= turnos_vacunas.hhmmtur And medprestabk.fecvigend <= turnos_vacunas.fechatur ;
	AND medprestabk.fecvigenh>= turnos_vacunas.fechatur Order By turnos_vacunas.Id Into Cursor cambio

Select * From cambio Where Nvl(codprest_b,0)=0 And codprest_a=20024 Into Cursor dosis1
Select * From cambio Where Nvl(codprest_b,0)=0 And codprest_a=20025 Into Cursor dosis2
Select * From dosis1,dosis2 Where dosis1.id_b = dosis2.id_b
Update turnos_vacunas Set codprest = 20024 Where Id In (Select id_b From dosis1)
Update turnos_vacunas Set codprest = 20025 Where Id In (Select id_b From dosis2)
Select * From turnos_vacunas  Where Nvl(codprest,0)=0


Select franja.* From franja,franjadrive Where franja.codmed = franjadrive.codmed ;
	AND franja.diasem = franjadrive.diasem And franja.hhmmdes < franjadrive.hhmmhas ;
	AND franja.hhmmhas>= franjadrive.hhmmdes Into Cursor cambioS


Select franjapp.*,franjadrive .tipoturno From franjapp,franjadrive Where franjapp.codmed = franjadrive.codmed ;
	AND franjapp.diasem = franjadrive.diasem And franjapp.hhmmdes < franjadrive.hhmmhas ;
	AND franjapp.hhmmhas>= franjadrive.hhmmdes Group By franjapp.Id Into Cursor cambioS

Select * From cambioS Where tipoturno_b =0 Into Cursor algo

Update franjapp Set tipoturno =0 Where Id In (Select Id From algo)

Select * From franjapp,franjadrive Where franjapp.codmed = franjadrive.codmed ;
	AND franjapp.diasem = franjadrive.diasem And franjapp.hhmmdes < franjadrive.hhmmhas ;
	AND franjapp.hhmmhas> franjadrive.hhmmdes Group By franjapp.Id Order By NOMBRE,franjadrive.diasem;
	INTO Cursor cambioS



Select * From franjapp,tabreserv350 Where franjapp.codmed = tabreserv350.codmed ;
	AND franjapp.diasem = tabreserv350.diasem And Ttoc(franjapp.horadesde,2) < Ttoc(tabreserv350.horarhasta,2) ;
	AND Ttoc(franjapp.horahasta,2)> Ttoc(tabreserv350.horardesde,2) Group By franjapp.Id Order By NOMBRE,tabreserv350.diasem;
	INTO Cursor cambior

Select * From cambior Union All ;
	SELECT * From cambior Into Cursor reasactivo

Select * From tabreserv350 Where codmed  In (Select codmed From franjadrive) Into Cursor BAJAR


Update tabreserv350 Set fecvigenh = Date()-1 Where Id In (Select Id From BAJAR)


Select Val(Left(duracion,2))*60  +Val(Substr(duracion,4,2)) As dura,;
	VAL(Dtos(fecvigenh)+Transform(codmed,"@L 9999")+Transform(diasem)+Transform(hhmmdes,"@L 9999")) As clavemed;
	,* From medprestabk Into Cursor cambio

Select * From cambio Where dura<>pre_duracion And pre_duracion<60 And codprest In (Select codigo From Base) Into Cursor cambiar


Select * From cambio Where dura<pre_duracion And pre_duracion /2<>dura  And !Like('EC*',codesp) And !Like('R*',codesp) And !Inlist(codesp,'INVE','VACU','TOMO');
	INTO Cursor cambiar
Select * From cambio Where dura<pre_duracion And pre_duracion /2<>dura  And !Like('ON*',codesp)   And !Like('EC*',codesp) And !Like('R*',codesp) And !Inlist(codesp,'INVE','VACU','TOMO');
	INTO Cursor cambiar


Select Val(Left(duracion,2))*60  +Val(Substr(duracion,4,2)) As dura ,;
	VAL(Dtos(fecvigenh)+Transform(codmed,"@L 9999")+Transform(diasem)+Transform(hhmmdes,"@L 9999")) As clavemed;
	,* From medprestabk  ;
	WHERE   pre_duracion /2<>Val(Left(duracion,2))*60  +Val(Substr(duracion,4,2))  And !Like('R*',codesp) And !Inlist(codesp,'INVE','VACU','TOMO');
	AND !Like('ON*',codesp)   And !Like('EC*',codesp) Into Cursor medpre

Select * From prestacion,Base Where pre_codprest = codigo Into Cursor prestas
Select * From prestas Where pre_duracion<>dura Into Cursor difprest


Select Val(Left(duracion,2))*60  +Val(Substr(duracion,4,2)) As dura,;
	VAL(Dtos(fecvigenh)+Transform(codmed,"@L 9999")+Transform(diasem)+Transform(hhmmdes,"@L 9999")) As clavemed;
	,* From medprestabk Into Cursor cambio

Select * From cambio Where pre_duracion /2<>dura And dura<>pre_duracion ;
	AND pre_duracion<60 And codprest In (Select codigo From Base) Into Cursor cambiar

Select * From cambio Where  dura<>pre_duracion ;
	AND pre_duracion<60 And codprest In (Select codigo From Base) Into Cursor cambiar

Select * From cambio Where  dura<>pre_duracion ;
	AND pre_duracion<60 And codesp = 'CLIN' Into Cursor cambiar

Select * From cambiar Where pre_duracion=30 Into Cursor cambiadur
Select * From medprestabk  Where Id In (Select Id From cambiadur)
Update  medprestabk  Set duracion = '00:30:00' ,cantidad = 11 Where Id In (Select Id From cambiadur)

Select * From cambio Group By clavemed,dura Into Cursor medgro
Select * From medgro Group By clavemed Having Coun(Id)>1 Into Cursor dosdura

Select * From cambio Where clavemed In (Select clavemed From dosdura) Into Cursor acambiar

Select * From medprestabk  Where codprest  In (Select codigo  From presta ) And fecvigenh>Ctod("18/08/2021") Into Cursor cambioa
Update  medprestabk  Set fecvigenh=Ctod("18/08/2021")  Where Id In (Select Id From cambioa)



Update  medprestabk  Set duracion = '00:15:00'   Where codmed In (Select codmed From cambia)







Select * From medpresta ,franjadrive Where medpresta .codmed = franjadrive.codmed ;
	AND medpresta .diasem = franjadrive.diasem And !(medpresta .hhmmdes < franjadrive.hhmmhas ;
	AND medpresta .hhmmhas> franjadrive.hhmmdes) Into Cursor todas
Select * From medpresta ,franjadrive Where medpresta .codmed = franjadrive.codmed ;
	AND medpresta .diasem = franjadrive.diasem And  medpresta .hhmmdes >= franjadrive.hhmmdes ;
	AND medpresta .hhmmhas<= franjadrive.hhmmhas Into Cursor incluidas
Select * From todas Where Id Not In (Select Id From incluidas)
Browse Last
Select 16
Select 18
Select 19
Copy To cambioS Type Xl5
Modify Command c:\desaguemes\prg\0seteos_quirof.prg As 1252
Select *,prg_diasem(diasem) As dia  From todas Where Id Not In (Select Id From incluidas)
Modify Command c:\desaguemes\prg\prg_diasem.prg As 1252
Select *,c:\desaguemes\prg\prg_diasem(diasem) As dia  From todas Where Id Not In (Select Id From incluidas)
Select *   From todas Where Id Not In (Select Id From incluidas)
Set Default To Getdir
Set Default To Getdir()
Select *,prg_diasem(diasem) As dia  From todas Where Id Not In (Select Id From incluidas)
Select *,prg_diasem(diasem_a) As dia  From todas Where Id Not In (Select Id From incluidas)
Copy To cambioS Type Xl5
Select * From medpresta ,franjadrive Where medpresta .codmed = franjadrive.codmed ;
	AND medpresta .diasem = franjadrive.diasem  Into Cursor todas
Select *,prg_diasem(diasem_a) As dia  From todas Where Id Not In (Select Id From incluidas)
Browse Last
Copy To Drive  Type Xl5
Go Bottom
SELECT prg_diasem(diasem),* FROM medpresta WHERE codmed in (SELECT codmed FROM franjadrive);
group BY codmed,diasem,hhmmdes,fecvigenh INTO CURSOR controlo readwrite
UPDATE controlo SET fecpasivap=CTOD("01/01/1900"),pre_fechapasiva =CTOD("01/01/1900")

Select controlo
Set Step On
Scan
	Select * From franjadrive Where codmed = controlo.codmed  ;
		AND diasem = controlo.diasem  And (hhmmhas >= controlo.hhmmhas  ;
		AND hhmmdes  <= controlo.hhmmdes) Into Cursor estan
	If Reccount('ESTAN')>0
		Select controlo
		If  fecpasivap >= Date()
			Set Step On
		Endif
		Replace fecpasivap With Date()

	Endif
Endscan

Select * From controlo Where fecpasivap =Date() Into Cursor incluidas
Select controlo
Go Top
Scan
	Select * From franjadrive Where codmed = controlo.codmed  ;
		AND diasem = controlo.diasem  And (hhmmdes < controlo.hhmmhas  ;
		AND  hhmmhas  > controlo.hhmmdes) Into Cursor estan
	If Reccount('ESTAN')>0
		Select controlo
		Replace pre_fechapasiva With Date()

	Endif
Endscan

Select * From controlo Where pre_fechapasiva =Date()  Into Cursor interser

SELECT * FROM controlo WHERE fecpasivap=CTOD("01/01/1900") AND pre_fechapasiva =CTOD("01/01/1900") INTO CURSOR bajas

 SELECT  bajas.*  FROM bajas,turnoid WHERE bajas.codmed = turnoid.codmed ;
AND bajas.diasem = turnoid.diasem AND bajas.hhmmdes <= turnoid.hhmmtur ;
AND bajas.hhmmhas> turnoid.hhmmtur AND bajas.fecvigend <= turnoid.fechatur   ;
AND bajas.fecvigenh>= turnoid.fechatur AND bajas.fecvigenh>CTOD("16/12/2021") AND turnoid.fechatur >=DATE();
ORDER BY  bajas.codmed,bajas.diasem,bajas.hhmmdes GROUP BY bajas.id  INTO CURSOR nosaco

SELECT * FROM bajas WHERE id NOT in (SELECT id FROM nosaco) AND AT("EC",codesp)<>1 INTO cursor sacar readwrite


Select sacar
Scan
	Requery('franja')
	If Reccount('franja')>0
		Update franja Set fecvigenh = Ctod("16/12/2021"),estructura = "X"
		ELSE 
		replace demanda with 9
	Endif

	Requery('medpresta')
	If Reccount('medpresta')>0
		Update medpresta Set fecvigenh = Ctod("16/12/2021"),demanda = 2
		ELSE 
		replace demanda with 9
	Endif
ENDSCAN


Select sigo
Scan
	 

	Requery('medpresta')
	If Reccount('medpresta')>0
		Update medpresta Set fechaUltAgenda= Ctod("05/06/2022") 
	 
	Endif
ENDSCAN
Select tabbloamb.*,medprestabk.codesp From tabbloamb LEFT JOIN medprestabk ON (tabbloamb.codmed = medprestabk.codmed ;
	AND tabbloamb.diasem = medprestabk.diasem And tabbloamb.hhmmdes < medprestabk.hhmmhas ;
	AND tabbloamb.hhmmhas>= medprestabk.hhmmdes) GROUP BY tabbloamb.id 	Into Cursor cambioS