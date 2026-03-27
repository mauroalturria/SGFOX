*******************
** Generar turnos
** Dr. o Dra.
*******************
do sp_conexion
mcafil=0
mncodent=0
mccodesp=''
mncodmed=48
mncodserv=0
mtfechatur=ctod('19/09/2002')
mddiasem=DOW(mtfechatur)
mthorad=datetime(year(mtfechatur),month(mtfechatur),day(mtfechatur),12,0,0)
mthorah=datetime(year(mtfechatur),month(mtfechatur),day(mtfechatur),14,0,0)
mtdura=datetime(year(mtfechatur),month(mtfechatur),day(mtfechatur),0,15,0)
mntipotur=0
midusu='Cantoniow'
mdia=datetime()

do while mthorad < mthorah
	mret=sqlexec(mcon1,"INSERT INTO turnos (afiliado,codent,codesp,codmed,codserv,confirmado,diasem,fechatur,horatur,tipoturno,usuariogenera,fechagenera) " + ;
				   "VALUES (?mcafil,?mncodent,?mccodesp,?mncodmed,?mncodserv,0,?mddiasem,?mtfechatur,?mthorad,?mntipotur,?midusu,?mdia)")

	if mret < 0
		messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion") 
		mret=0
	endif

	mthorad = SumaTime(mthorad,mtdura,mtfechatur,0)
enddo	
=sqldisconnect(mcon1)


************************************************************
************************************************************
Function SumaTime(vrFechaHr1,vrFechaHr2,vrFechaX,vrMinu_mas)
************************************************************
mttot_min1 =0
mttot_min2 =0
if !isblank(vrfechax)
	mddate = vrFechaX
else
	mddate = date()	
endif	
if !isblank(vrFechaHr1)
	mttot_min1 = hour(vrFechaHr1)*60 + minute(vrFechaHr1)
endif
if !isblank(vrFechaHr2)
	mttot_min2  = hour(vrFechaHr2)*60 + minute(vrFechaHr2)
endif
mnsumat    = mttot_min1 + mttot_min2+vrMinu_mas

if mnsumat > 0  
  if int(mnsumat/60) >= 24
  	 mthr  = int(mnsumat/60)%24     &&Modulo 24
  else
   	 mthr  = int(mnsumat/60)
  endif 	 
  mtmin = (mnsumat % 60)   &&Modulo 60
  
  mdtime= datetime(year(mddate),month(mddate),day(mddate),mthr,mtmin,0)
****************************
* Armo el string del time
*****************************
  mchr  = strtran(str(mthr,2),' ','0')
  mcmin = strtran(str(mtmin,2),' ','0')
  mttime = mchr + ':' + mcmin + ':00' 
endif
RETURN mdtime