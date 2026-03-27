*!*	do sp_conexion
*!*	do sp_busco_medrempzt with 2,0,ctod("01/11/2007")
*!*	do sp_desconexion
*!*	select * from tabguaevol left join mwkMedicogua on egm_codmed = mwkMedicogua.id into cursor evol1
select evol1
i=1
mcarch = "evo"+ alltrim(dtos(date()))+'.txt'
do while file(mcarch )
	i=i+1
	mcarch = "evo"+ alltrim(dtos(date()))+alltrim(str(i,2,0))+'.txt'
enddo
mnarch = fcreate(mcarch)
messagebox(transf(mnarch))
select evol1
scan
	mccad ="H.Clinica" + chr(9) + "Paciente" + chr(9) +"Mot.Consulta"  + chr(9) + "Ex.Fisico";
	 + chr(9) + "Anteced." + chr(9) + "F.Evol" + chr(9) +  "Profesional"+ chr(9) + "Evolucion"

	mccad = mccad  +	reg_nrohclinica+ chr(9) +reg_nombrepac+ chr(9)
	nlin = alines(mimat,EG_motConsulta,.t.)
	for i = 1 to nlin
		if !empty(mimat(i))
			npos32 = rat(" ",left(mimat(i),250))
			npos32 = iif(npos32>0 and len(alltrim(left(mimat(i),250))) = 250 ,npos32,250)
			mccad = mccad  +" "+ left(mimat(i),npos32)
			if len(alltrim(mimat(i)))>250
				mimati = substr(alltrim(mimat(i)),npos32 +1 )
				do while len(mimati)>1
					npos32 = rat(" ",left(mimati,250))
					npos32 = iif(npos32>0 and len(alltrim(left(mimati,250))) = 250 ,npos32,250)
					mccad = mccad  +" "+  left(mimati,npos32 )
					mimati = substr(alltrim(mimati),npos32 +1)
				enddo
			endif
		endif
	next
	mccad = mccad + chr(9) 
	nlin = alines(mimat,EG_exfisico,.t.)
	for i = 1 to nlin
		if !empty(mimat(i))
			npos32 = rat(" ",left(mimat(i),250))
			npos32 = iif(npos32>0 and len(alltrim(left(mimat(i),250))) = 250 ,npos32,250)
			mccad = mccad  + " "+left(mimat(i),npos32)
			if len(alltrim(mimat(i)))>250
				mimati = substr(alltrim(mimat(i)),npos32 +1 )
				do while len(mimati)>1
					npos32 = rat(" ",left(mimati,250))
					npos32 = iif(npos32>0 and len(alltrim(left(mimati,250))) = 250 ,npos32,250)
					mccad = mccad+" "  +  left(mimati,npos32 )
					mimati = substr(alltrim(mimati),npos32 +1)
				enddo
			endif
		endif
	next
	mccad = mccad + chr(9) 
	nlin = alines(mimat,EG_anteceden,.t.)
	for i = 1 to nlin
		if !empty(mimat(i))
			npos32 = rat(" ",left(mimat(i),250))
			npos32 = iif(npos32>0 and len(alltrim(left(mimat(i),250))) = 250 ,npos32,250)
			mccad = mccad  + " "+left(mimat(i),npos32)
			if len(alltrim(mimat(i)))>250
				mimati = substr(alltrim(mimat(i)),npos32 +1 )
				do while len(mimati)>1
					npos32 = rat(" ",left(mimati,250))
					npos32 = iif(npos32>0 and len(alltrim(left(mimati,250))) = 250 ,npos32,250)
					mccad = mccad+" "  +  left(mimati,npos32 )
					mimati = substr(alltrim(mimati),npos32 +1)
				enddo
			endif
		endif
	next
	mccad = mccad + chr(9) + ttoc(egm_fechah)+ chr(9) + iif(isnull(nombre),transf(egm_codmed),nombre)+ chr(9) + "Evol:"
	nlin = alines(mimat,EGm_evol,.t.)
	for i = 1 to nlin
		if !empty(mimat(i))
			npos32 = rat(" ",left(mimat(i),250))
			npos32 = iif(npos32>0 and len(alltrim(left(mimat(i),250))) = 250 ,npos32,250)
			mccad = mccad  + " "+left(mimat(i),npos32)
			if len(alltrim(mimat(i)))>250
				mimati = substr(alltrim(mimat(i)),npos32 +1 )
				do while len(mimati)>1
					npos32 = rat(" ",left(mimati,250))
					npos32 = iif(npos32>0 and len(alltrim(left(mimati,250))) = 250 ,npos32,250)
					mccad = mccad+" "  +  left(mimati,npos32 )
					mimati = substr(alltrim(mimati),npos32 +1)
				enddo
			endif
		endif
	next

	fputs(mnarch, mccad)

endscan

fclose(mnarch)
