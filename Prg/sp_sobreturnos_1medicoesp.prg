*****************************
* Genera Sobre Turnos
* AUTOR:Claudia Antoniow
*****************************
* FECHA:13/02/2002
*****************************
Parameters vr_thorad, vr_thorah
mndiasem  = Dow(mdmasX)
mncanttur = 1
mnporc    = 0
mifecho =sp_busco_fecha_serv("DT")
If mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
Else
	mccpoamb = ''
Endif

*!*	Select Distinct codesp From mwkmedpresta1 Into Cursor mwkcodesp
*!*	Select mwkcodesp
*!*	mibuse ='('
*!*	Scan
*!*		mibuse = mibuse +"'"+Alltrim(codesp)+"',"
*!*	Endscan
*!*	mibuse = Left(mibuse ,Len(mibuse )-1)+")"
*!*	mret = SQLExec(mcon1,"SELECT ESP_porcenausentismo from Especialid where ESP_codesp in "+mibuse ,"MWKSobre")
*!*	Select MWKSobre
*!*	Calculate Max(ESP_porcenausentismo) To miporc
*!*	Select mwkmedpresta1
*!*	Go Top
*!*	mcantidad = Iif(miporc<5,0,Iif(miporc<10,1,Iif(miporc<25,2,4)))
mncodmed  = mwkmedpresta1.codmed
*!*	mnporc    = mcantidad 
mtfechatur= mdmasX
mret = SQLExec(mcon1,"SELECT horatur from turnos "+;
	" where codmed = ?mncodmed and fechatur = ?mtfechatur  order by horatur" ,"MWKturST")
Horadesde = vr_thorad && MWKturST.horatur
Go Bottom
Horahasta= vr_thorah &&MWKturST.horatur
thora     = Ttoc(Horadesde,2)
thorad = Horadesde
thorah = Horahasta 
*!*	If (Horahasta-Horadesde)/3600 <2 Or miporc = 0
*!*		Wait Windows  Mwkmedico.nombre+" menos de 2 horas "+ Transform(Horadesde)+"-"+Transform(Horahasta)+ " o Ausentismo CERO" Nowait
*!*		Return
*!*	ENDIF
*!*	IF mcantidad =  4
	mnporc    = round((Horahasta-Horadesde)/3600,0) && proporcional_horas(2,Horadesde,Horahasta,vr_thorad,vr_thorah)

*!*	endif
*!*	If mnporc    <mcantidad
*!*		mnporc     = mcantidad 
*!*	Endif
If mnporc >0
	If !(Isnull(thorad) And Isnull(thorah))
		mdHora_d=Datetime(Year(mtfechatur),Month(mtfechatur),Day(mtfechatur),Hour(Horadesde),Minute(Horadesde),0)
		mdHora_h=Datetime(Year(mtfechatur),Month(mtfechatur),Day(mtfechatur),Hour(Horahasta),Minute(Horahasta),0)
		If mxambito >1
			mccpoamb = "  codambito = ?mxambito and "
		Else
			mccpoamb = ''
		Endif

		mret=SQLExec(mcon1,"SELECT * FROM Turnos WHERE &mccpoamb Tipoturno=2 AND codmed=?mncodmed " + ;
			"AND fechatur = ?mtfechatur AND horatur between ?mdHora_d AND ?mdHora_h ",'MWKExisteTurnoa')
 		Select * From MWKExisteTurnoa Into Cursor MWKExisteTurno
 *		Select * From MWKExisteTurnoa WHERE  usuariogenera = 'CARMENA' Into Cursor MWKExisteTurnoPROC 

		Sele MWKExisteTurno
		Go Top
		ncantst = mnporc-Reccount('MWKExisteTurno') 
		
		IF ncantst> 0  &&Reccount('MWKExisteTurnoPROC')=0 &&
			 
				mnporc =ncantst 
			 
			Do sp_datos_sobretur.prg
			Sele MwkPorcSOfer
			Go Top
			If !Eof('MwkPorcSOfer') Or !Bof('MwkPorcSOfer')
				If MwkPorcSOfer.Cantur >0
					Do sp_cargo_sobretur With 2, mnporc, thorad, thorah
				Endif
			Endif
		Endif
	Endif
Endif
If Used('MWKExisteTurno')
	Sele MWKExisteTurno
	Use
Endif
mret=SQLExec(mcon1,"SELECT id FROM Turnos WHERE &mccpoamb Tipoturno=2 AND codmed=?mncodmed " + ;
	"AND fechatur = ?mtfechatur and fechagenera>=?mifecho ",'MWKExisteTurnoa')
If Used('MwkPorcSOfer')
	Sele MwkPorcSOfer
	Use
Endif
If Used('MWKHorasTr')
	Sele MWKHorasTr
	Use
Endif



Function proporcional_horas
Parameter vr_cant,vr_Horad,vr_Horah,vr_ohorad,vr_ohorah
vr_prop_calc= .15
vr_tot_minH = Hour(vr_Horah)*60 + Minute(vr_Horah)
vr_tot_minD = Hour(vr_Horad)*60 + Minute(vr_Horad)
vr_choras    = vr_tot_minH - vr_tot_minD
If vr_choras > 0
	vr_prop = vr_cant /(vr_choras/60)

	If vr_prop > 0
		vr_tot_min1 = Hour(vr_ohorah)*60 + Minute(vr_ohorah)
		vr_choras1  = vr_tot_min1 - vr_tot_minD
		vr_prop_calc= (vr_choras1/60) * vr_prop
	Else
		vr_prop_calc = 0
	Endif
Else
	vr_prop_calc = 0
Endif




If	Round(vr_prop_calc,0)>= 0.5
	Return Round(vr_prop_calc,0)
Else
	If Round(vr_prop_calc,1)>= 0.1
		Return 1
	Else
		Return 0
	Endif
Endif
Endfunc
