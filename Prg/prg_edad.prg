****
** obtiene la edad
****
Parameter mfec,fechadia,mtipo

If Vartype(mtipo)#"C"
	mtipo = "C"
Endif
If Vartype(fechadia)#"D"
	= sp_busco_fecha_serv("DT")
	fechadia = Ttod(mwkfecserv.fechahora)
Endif

aa = Year(fechadia) - Year(mfec)
aa = aa - Iif(Month(fechadia) < Month(mfec),1,0)
mm = Iif(Month(fechadia) < Month(mfec),12 - Month(mfec) + Month(fechadia),Month(fechadia) - Month(mfec) )
mm = mm - Iif(Day(fechadia) < Day(mfec),1,0)
If mm = -1
	aa = aa -1
	mm = 11
Endif
dd = Iif(Day(fechadia) >= Day(mfec),Day(fechadia) - Day(mfec), ;
	day( Ctod("01/"+Padl(Month(mfec+31),2,"0")+"/"+Str(Year(mfec+31),4)) -1 )- Day(mfec)+ Day(fechadia))


Do Case
Case mtipo = "T"    &&Devuelve XXX años, XX meses, XX dias

	If (mfec < fechadia And Not Empty(mfec) )
		RETURN Alltrim(Transf(aa))+" años, " + Iif(mm<1,'',Alltrim(Transf(mm)) + " meses, ") + Alltrim(Transform(dd)) + " dias."
	Else
		Return "Error en Calculo"
	Endif

Case mtipo = "C"
	Return Alltrim(Transf(aa))+" años " + Iif(mm<1,'',Alltrim(Transf(mm)) + " meses")
Case mtipo = "N"
	Return (aa*100+ Iif(mm<1,0,mm))/100
Case mtipo = "AMD"
	Return Transf(aa*10000+ Iif(mm<1,0,mm*100)+ dd)
Case mtipo = "AM"
	Return Transf(aa)+"A " + Iif(mm<1,'',transf(mm)+"M")

Endcase

