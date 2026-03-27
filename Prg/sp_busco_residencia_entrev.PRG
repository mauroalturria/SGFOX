*
* Residencias Entrevistas
*
Dimension vUniv[17]
Dimension vtesp[4,2]
Dimension vdime[3,2]

vUniv[01]='ADVENTISTA DEL PLATA'
vUniv[02]='AUSTRAL'
vUniv[03]='CATOLICA DE CORDOBA'
vUniv[04]='CEMIC'
vUniv[05]='CRUZ ROJA ARGENTINA'
vUniv[06]='DE BUENOS AIRES (UBA)'
vUniv[07]='DE LA PLATA'
vUniv[08]='DE MORON'
vUniv[09]='DEL SALVADOR (USAL)'
vUniv[10]='UNV. FAVALORO'
vUniv[11]='NAC. DEL NOROESTE (LITORAL)'
vUniv[12]='NAC. DE CORDOBA'
vUniv[13]='NAC. DE CUYO'
vUniv[14]='NAC. DE ROSARIO'
vUniv[15]='NAC. DE SAN LUIS'
vUniv[16]='NAC. DE TUCUMAN'
vUniv[17]='NAC. DEL COMAHUE'

If used('mwkresirep')
	Use in mwkresirep
Endif
Create cursor mwkresirep ( REP_apellido c(30),REP_nombre c(30),REP_dni n(8),REP_especialidad c(50),;
	REP_edad c(20),REP_Univ c(30),REP_egreso n(4),REP_promedio n(6,2),REP_nota n(3),REP_inco n(3),REP_anu n(3),;
	REP_clir n(3),REP_clip c(6),REP_cirr n(3),REP_cirp c(6),REP_tocr n(3),REP_tocp c(6),REP_pedr n(3),;
	REP_pedp c(6),REP_dim1r n(3),REP_dim1p c(6),REP_dim2r n(3),REP_dim2p c(6),REP_dim3r n(3),REP_dim3p c(6))
Select mwkentre1
Go top
Scan
	mtema  = mwkentre1.TBE_tema
	If used('mwkrespanu')
		Use in mwkrespanu
	Endif
	mret = sqlexec(mcon1,"select * from TabResAnu where TRA_tema=?mtema"+;
		" and TRA_anio=?mranio,TRA_evento=?mreven","mwkrespanu")
	If mret>0
		mcanu = reccount('mwkrespanu')
	Else
		mcanu = 0
		Messagebox("EN BUSQUEDA DE PREGUNTAS ANULADAS",16,"ERROR")
	Endif
	mdni = mwkentre1.TBE_dni
	mquery = ''
	For mi = 1 to 100
		mquery = mquery+"TBE_p"+alltrim(str(mi))+", "
	Endfor
	mquery = mquery+"TBE_tema,TBE_dni "
	mwhere = "where (TBE_dni=?mdni or TBE_dni>99999990) and TBE_tema=?mtema"
	If used('mwkresidencib')
		Use in mwkresidencib
	Endif
	mret = sqlexec(mcon1,"select "+mquery+" from TabResProfexa "+mwhere+;
		" and TBE_anio=?mranio and TBE_evento=?mreven"+;
		" order by TBE_dni desc","mwkresidencib")
	Select mwkresidencib
	Go top
	If mret > 0
		If used('mwkgesp')
			Use in mwkgesp
		Endif
		Create cursor mwkgesp (GSP_especialidad c(30), GSP_correctas N(2), GSP_porcentaje c(10))
		If used('mwkgdim')
			Use in mwkgdim
		Endif
		Create cursor mwkgdim (GDI_dimension c(30), GDI_correctas N(2), GDI_porcentaje c(10), GDI_total N(2))
		If used('mwkdistesp')
			Use in mwkdistesp
		Endif
		If used('mwkdistdim')
			Use in mwkdistdim
		Endif
		If mtema = 'F'
			mtabla = "TabResExaF"
		Else
			mtabla = "TabResExa"
		Endif
		mpaso = .f.
		mret = sqlexec(mcon1,"select distinct(TRE_especialidad) as Nombre from "+mtabla+;
			" where TRE_anio=?mranio and TRE_evento=?mreven","mwkdistesp")
		If mret > 0
			mret = sqlexec(mcon1,"select distinct(TRE_dimension) as Nombre from "+mtabla+;
				" where TRE_anio=?mranio and TRE_evento=?mreven","mwkdistdim")
			If mret > 0
				Dimension vdatesp[reccount('mwkdistesp'),2]
				Dimension vdatdim[reccount('mwkdistdim'),4]
				Dimension vdatpre[100]
				mcdim=reccount('mwkdistdim')
				mcesp=reccount('mwkdistesp')
				Store '' to vdatesp
				Store '' to vdatdim
				Store '' to vdatpre
				Select mwkdistesp
				Go top
				mi = 0
				Scan
					mi = mi + 1
					vdatesp[mi,1]=upper(mwkdistesp.Nombre)
					vdatesp[mi,2]=0
				Endscan
				Select mwkdistdim
				Go top
				mi = 0
				Scan
					mi = mi + 1
					vdatdim[mi,1]=upper(mwkdistdim.Nombre)  && Dimension
					vdatdim[mi,2]=0                         && preguntas para el examinado que responde a esa Dimension
					vdatdim[mi,3]=''                        && % sobre el total
					vdatdim[mi,4]=0                         && Total gral de esa Dimension
				Endscan
				mtem = mtema
				For mx = 1 to mi
					If used('mwktotal')
						Use in mwktotal
					Endif
					mbusca = vdatdim[mx,1]
					If mtem = '1' or mtem = 'F'
						mwhere = "and TRE_t1preguntanro "
					Else
						If mtem = '2'
							mwhere = "and TRE_t2preguntanro "
						Endif
					Endif
					mret = sqlexec(mcon1,"select count(*) as nTotal from "+mtabla+" where TRE_dimension=?mbusca"+;
						" and TRE_anio=?mranio and TRE_evento=?mreven "+;
						mwhere + "not in (select TRA_preguntanro from TabResAnu where TRA_tema=?mtem)","mwktotal")
					If mret > 0
						Select mwktotal
						Go top
						vdatdim[mx,4]=mwktotal.nTotal
					Endif
				Endfor
				Select mwkresidencib
				Go Top
				For mi = 1 to 100
					mcampo = "mwkresidencib.TBE_p"
					mcampo = mcampo + alltrim(str(mi))
					vdatpre[mi]=&mcampo
				Endfor
				Select mwkresidencib
				Go bottom
				For mi = 1 to 100
					mcampo = "mwkresidencib.TBE_p"
					mcampo = mcampo + alltrim(str(mi))
					If vdatpre[mi] = &mcampo
						If used('mwkveres')
							Use in mwkveres
						Endif
						If mtema = 'F' or mtema = '1'
							mret = sqlexec(mcon1,"select TRE_especialidad,TRE_dimension from "+mtabla+;
								" where TRE_t1preguntanro=?mi"+;
								" and TRE_anio=?mranio and TRE_evento=?mreven","mwkveres")
						Else
							mret = sqlexec(mcon1,"select TRE_especialidad,TRE_dimension from "+mtabla+;
								" where TRE_t2preguntanro=?mi"+;
								" and TRE_anio=?mranio and TRE_evento=?mreven","mwkveres")
						Endif
						If mret > 0
							If used('mwkveres')
								If reccount('mwkveres')>0
									For mt = 1 to mcesp
										If vdatesp[mt,1]=upper(mwkveres.TRE_especialidad)
											vdatesp[mt,2]=vdatesp[mt,2]+1
										Endif
									Endfor
									For mt = 1 to mcdim
										If vdatdim[mt,1]=upper(mwkveres.TRE_dimension)
											vdatdim[mt,2]=vdatdim[mt,2]+1
										Endif
									Endfor
								Endif
							Endif
						Endif
					Endif
				Endfor
				For mi = 1 to mcesp
					If mtem = 'F'
						mdato  = vdatesp[mi,2]*100/100
					Else
						mdato  = vdatesp[mi,2]*100/25
					Endif
					mdato1 = str(mdato,6,2)+" % "
					Insert into mwkgesp (GSP_especialidad,GSP_correctas,GSP_porcentaje) values (vdatesp[mi,1],vdatesp[mi,2],mdato1)
				Endfor
				For mi = 1 to mcdim
					mdato = vdatdim[mi,2]*100/vdatdim[mi,4]
					vdatdim[mi,3] = str(mdato,6,2)+" % "
					Insert into mwkgdim (GDI_dimension,GDI_correctas,GDI_porcentaje,GDI_total) values (vdatdim[mi,1],vdatdim[mi,2],vdatdim[mi,3],vdatdim[mi,4])
				Endfor
				For mv = 1 to 4
					vtesp[mv,1]=0
					vtesp[mv,2]=""
				Endfor
				For mv = 1 to 3
					vdime[mv,1]=0
					vdime[mv,2]=""
				Endfor
				Select * from mwkgesp order by GSP_especialidad into cursor mwkgesp
				Select mwkgesp
				Go top
				mi = 0
				Scan
					mi = mi + 1
					vtesp[mi,1]=mwkgesp.GSP_correctas
					vtesp[mi,2]=mwkgesp.GSP_porcentaje
				Endscan
				Select * from mwkgdim order by GDI_dimension into cursor mwkgdim
				Select mwkgdim
				Go top
				mi=0
				Scan
					mi = mi + 1
					vdime[mi,1]=mwkgdim.GDI_correctas
					vdime[mi,2]=mwkgdim.GDI_porcentaje
				Endscan
				medad = prg_edad(ctod(mwkentre1.INS_FecNac))
				If mwkentre1.INS_Universidad = 18
					muniv = alltrim(mwkentre1.INS_OtraUniv)
				Else
					muniv = vUniv[ mwkentre1.INS_Universidad ]
				Endif
				mfec = ctod(mwkentre1.INS_FecEgreso)
				megre = year(mfec)
				Insert into mwkresirep (REP_apellido,REP_nombre,REP_dni,REP_especialidad,;
					REP_edad,REP_Univ,REP_egreso,REP_promedio,REP_nota,REP_inco,REP_anu,;
					REP_clir,REP_clip,REP_cirr,REP_cirp,REP_tocr,REP_tocp,REP_pedr,;
					REP_pedp,REP_dim1r,REP_dim1p,REP_dim2r,REP_dim2p,REP_dim3r,REP_dim3p) ;
					values (alltrim(mwkentre1.TBE_apellido),alltrim(mwkentre1.TBE_nombre),mwkentre1.TBE_dni,;
					alltrim(mwkentre1.TBE_especialidad),medad,muniv,megre,mwkentre1.INS_PromSIAR,;
					mwkentre1.TBE_puntaje,(mwkentre1.TBE_incorrectas-mcanu),mcanu,;
					nvl(vtesp[2,1],0),nvl(vtesp[2,2],""),;
					nvl(vtesp[1,1],0),nvl(vtesp[1,2],""),;
					nvl(vtesp[4,1],0),nvl(vtesp[4,2],""),;
					nvl(vtesp[3,1],0),nvl(vtesp[3,2],""),;
					nvl(vdime[2,1],0),nvl(vdime[2,2],""),;
					nvl(vdime[1,1],0),nvl(vdime[1,2],""),;
					nvl(vdime[3,1],0),nvl(vdime[3,2],""))
			Else
				Messagebox("EN BUSQUEDA DE DATOS EN EXAMINADOS",16,"ERROR")
			Endif
		Endif
	Endif
Endscan
