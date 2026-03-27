****
** busco internados
****
public mcon3
do sp_conexion_tablas
mfecha= ctod("01/01/2002")
mret = sqlexec(mcon3, "select PAC_nombrepaciente, " + ;
	"PAC_codhce,COB_codentidad, PAC_fechaalta " + ;
	"from COBERTURAS  " + ;
	"left join  pacientes on PAC_codadmision = cob_pacientes " + ;
	"where cob_codentidad = 971   " + ;
	" and PAC_fechaalta >=?mfecha group by PAC_nombrepaciente " , "mwkpacint0")
if mret<1
	=aerr(eros)
	messagebox(eros(3))

endif
&&, PAC_operadmision , idusuario
&&	"left join  tabusuario on PAC_operadmision = tabusuario.codigovax " +;
select mwkpacint0
scan
	totmin = 0
	totcost = 0
	mcodadm = mwkpacint0.PAC_codadmision
	do sp_busco_camas_paciente with mcodadm ,''
	mfecadm	= ctot(dtoc(mwkpacint0.pac_fechaadmision)+ " " + alltrim(ttoc(mwkpacint0.pac_horaadmision,2)))

	if reccount('mwkllamadas')>0
		select mwkcamas
		go top
		do while !eof('mwkcamas')
			mhabit= lug_habitacion
			mfechai = ctot(dtoc(lug_fechaingreso) +' '+  ttoc(lug_horaingreso,2))
			skip
			if !eof('mwkcamas')
				mfechae = ctot(dtoc(lug_fechaingreso) +' '+  ttoc(lug_horaingreso,2))
				select * from mwkllamadas ;
					where interno = mhabit and fecha_captura>=mfechai ;
					and fecha_captura<=mfechae into cursor mwkcallhab
			else
				select * from mwkllamadas ;
					where interno = mhabit and fecha_captura>=mfechai ;
					into cursor mwkcallhab
			endif

			if reccount('mwkcallhab')>0
				select mwkcallhab
				scan
					nmin= val(left(minutos,3))*60+ (val(right(minutos,2))*.60)
					nmin=iif(nmin>15,nmin-15,0)
					minuts = iif(left(alltrim(telefono),4)='0800' or nmin<0,0,round(nmin/60,2))
					costo  = iif(left(alltrim(telefono),4)='0800' or nmin<0,0,ceiling(nmin/120)*.23)
					costo  = costo  + iif(left(alltrim(telefono),2)='15', ceiling(nmin/60)*.5,0)
					totcost = totcost +costo
					totmin = totmin +minuts
				endscan
			endif
			select mwkcamas
		enddo
	endif		
	if totmin > 0
		select mwkpacint0
		oleapp.cells(i,2).value = PAC_nombrepaciente
		oleapp.cells(i,3).value = PAC_edad
		oleapp.cells(i,4).value = sec_descripsec
		oleapp.cells(i,5).value = PAC_habitacion
		oleapp.cells(i,6).value = ENT_descrient
		oleapp.cells(i,7).value = totmin
		oleapp.cells(i,8).value = totcost
		i=i+1
	endif
endscan
oleapp.Visible = .T.

		
FUNCTION fecha(cfecha)
	local dia,mes,aniohora
	dia=left(cfecha,2)
	aniohora= substr(cfecha,8)
	cmes =	lower(substr(cfecha,4,3))
	mes = iif(cmes = 'jan','01',iif(cmes = 'feb','02',iif(cmes = 'mar','03',iif(cmes = 'apr','04',;
	iif(cmes = 'may','05',iif(cmes = 'jun','06',iif(cmes = 'jul','07',iif(cmes = 'aug','08',;
	iif(cmes = 'sep','09',iif(cmes = 'oct','10',iif(cmes = 'nov','11',iif(cmes = 'dec','12','08'))))))))))))
	
	RETURN ctot(dia +'/'+ mes +'/'+ aniohora)
ENDFUNC

