lcRutaXp = "C:\Archivos de programa\Archivos comunes\Microsoft Shared\VFP\"
lcRutaW7 = "c:\Program Files\Common Files\microsoft shared\VFP\" 

lcArch = "VFP9r.dll"
lbResu = File(lcRutaXp + lcArch) 
lbResu = lbResu Or File(lcRutaW7 + lcArch)

lcDescrip = Iif(lbResu, "VFP9 INSTALADO","NO TIENE VFP9") 
lnTipo = 11
ldfechoy  = sp_busco_fecha_serv('DD')

If !sp_busco_stprogram(3, ldfechoy, 11)   && MwkStProg
	Return .f.
Endif 

Select MwkStProg
Go Top
lnId = MwkStProg.Id 

Select MwkStProg
Use
   
Do sp_update_stprogram With lnId, MyIp, lcDescrip, lnTipo, ldfechoy

