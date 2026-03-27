*
* Volcado de información Proxys Logs, para posterior analisis de la misma
*
Dimension vdat[8], vmes[12],vmesI[12]
vmes[01]='ene'
vmes[02]='feb'
vmes[03]='mar'
vmes[04]='abr'
vmes[05]='may'
vmes[06]='jun'
vmes[07]='jul'
vmes[08]='ago'
vmes[09]='sep'
vmes[10]='oct'
vmes[11]='nov'
vmes[12]='dic'
vmesI[01]='jan'
vmesI[02]='feb'
vmesI[03]='mar'
vmesI[04]='apr'
vmesI[05]='may'
vmesI[06]='jun'
vmesI[07]='jul'
vmesI[08]='aug'
vmesI[09]='sep'
vmesI[10]='oct'
vmesI[11]='nov'
vmesI[12]='dec'

marchi = getdir('C:\','Directorio de Archivos Proxy')
If len(alltrim(marchi))>0
	mcantreg = adir(mvfile, marchi + '*.acc')
	For mcreg = 1 to mcantreg
		mfile = marchi + mvfile[mcreg,1]
		Create table c:\temp\web\mwktabla (campo c(254))
		Go top
		Zap
		Append from (mfile) sdf
		on error =aerr(eros)
		Select mwktabla
		on error
		mregtabla = reccount('mwktabla')
		mfil = 0
		Scan
			mfil = mfil + 1
			Wait "LEYENDO ARCHIVO PROXY LOG, Aguarde ... "  + str(mfil, 9) windows nowait
			Store '' to vdat
			If len(alltrim(campo)) > 35
				mdes = 6
				mhas = ATC('|',campo) - 1
				mcar = mhas - mdes
				vdat[1] = substr(campo,mdes,mcar)
				mdes = ATC('TCP',campo)
				mhas = ATC('User',campo) - 3
				mcar = mhas - mdes
				vdat[2] = substr(campo,mdes,mcar)
				mdes = ATC('User',campo) + 5
				mhas = ATC('{',campo) - 2
				mcar = mhas - mdes
				vdat[3] = alltrim(substr(campo,mdes,mcar))
				mdes = ATC('Time',campo) + 5
				mhas = ATC('}',campo) - 3
				mcar = mhas - mdes
				vdat[4] = alltrim(substr(campo,mdes,mcar))
				mdes = ATC('http',campo)
				mhas = ATC('/',campo,5)
				mcar = mhas - mdes
				vdat[5] = alltrim(substr(campo,mdes,mcar))
				mdes = ATC('http',campo)
				mhas = ATC('"',campo,2) - 1
				If mhas > 0
					mcar = mhas - mdes + 1
					vdat[6] = alltrim(substr(campo,mdes,mcar))
					mdes = ATC('"',campo,2) + 1
					mtext = alltrim(substr(campo,mdes))
					mbytes = val(Substr(mtext,at(" ",mtext,1))) 
					vdat[8] = Substr(mtext,1,at(" ",mtext,1)-1)
				Else
					vdat[6] = alltrim(substr(campo,mdes))
					vdat[8] = ''
					mbytes = 0
				Endif
				mdes = ATC('"',campo) + 1
				mhas = ATC('http',campo) - 1
				mcar = mhas - mdes
				vdat[7] = alltrim(substr(campo,mdes,mcar))
				mhora = right(alltrim(vdat[4]),8)
				mhh = val(left(mhora,2))
				mfech = substr(alltrim(vdat[4]),1,len(alltrim(vdat[4]))-9)
				mbmes = substr(mfech,4,3)
				mmes = ascan(vmes,lower(mbmes))
				mmes = iif(mmes = 0, ascan(vmesI,lower(mbmes)),mmes)
				mfec2 = ctod(left(mfech,2)+'/'+transf(mmes,"@L 99")+'/'+ right(mfech,4))	
				if !(inlist(alltrim(vdat[1]),"172.16.108.108","172.16.104.17") and at("update.services.openoffice.org",vdat[5])>0)
					mret  = sqlexec(mcon1,"insert into TabProxyLog"+;
						" (TPL_ip,TPL_estado,TPL_user,TPL_fecha,TPL_hora,TPL_url,TPL_urlfull,"+;
						"TPL_metodo,TPL_filler,TPL_hh,TPL_bytes)"+;
						" values (?vdat[1],?vdat[2],?vdat[3],?mfec2,?mhora,?vdat[5],?vdat[6],?vdat[7],?vdat[8],?mhh, ?mbytes)")
					If mret < 0
						=aerr(eros)
						messagebox("registro:"+transf(recno('mwktabla'))+"/"+transform(mregtabla)+" |IP "+transform(vdat[1])+" |estado " +transform(vdat[2])+" |user " +transform(vdat[3])+" |fecha " +;
							transform(mfec2)+" |hora " +transform(mhora)+" |url " +transform(vdat[5])+" |urlfull " +transform(vdat[6])+" |metodo " +;
							transform(vdat[7])+" |filler " +transform(vdat[8])+" |hh " +transform(mhh)+" |bytes "+ transform(mbytes))
						Do log_errores With eros(1), eros(2),eros(3),"FRMOPERA11", 0
			*			Messagebox("EN Insert 1 DE TabProxyLog",16,"ERROR")
						if messagebox("DESEA CANCELAR?", 4+48+256, "Validacion") = 6					
							Exit
						Endif	
					Endif	
				Endif	
			Endif
		Endscan
		If used('mwktabla')
			Use in mwktabla
		Endif
		If file('c:\temp\web\mwktabla.dbf')
			Delete file c:\temp\web\mwktabla.dbf
		Endif	
		If mret > 0
			marchf = sp_busco_fecha_serv('DT')
			mfecc2 = chrtran(ttoc(marchf),' /:','')
 			mfile2 = left(mfile,len(mfile)-4) + '-' +;
 			 left(mfecc2,8) + '-' + substr(mfecc2,9,4) + '.pro'
			Rename (mfile) to (mfile2)
		Endif
	Next mcreg
Endif
Release vdat, vmes
Return
