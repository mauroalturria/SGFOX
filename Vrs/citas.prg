Select interna
SET STEP ON 
Scan
	hoy = Datetime()
	fecha = Ttod(hoy)
	cantcitas = Ttod(fechahoraing)+17-Date()
	For i = 1 To cantcitas
		Insert Into  tabregctgagen(ZCA_ESTADO,ZCA_FECMODIF, ZCA_FECHA,ZCA_OBSERV,ZCA_REGISTRACION);
			VALUES (1,hoy, fecha+i,'',interna.ZCA_REGISTRACION)
	Next

Endscan

Select guardia
SET STEP ON 
Scan
	hoy = Datetime()
	fecha = Ttod(hoy)
	cantcitas = Ttod(fechahoraing)+21-Date()
	For i = 1 To cantcitas
		Insert Into  tabregctgagen(ZCA_ESTADO,ZCA_FECMODIF, ZCA_FECHA,ZCA_OBSERV,ZCA_REGISTRACION);
			VALUES (1,hoy, fecha+i,'',guardia.ZCA_REGISTRACION)
	Next

Endscan


mitiempo1 = seconds()
DO sp_busco_ficha_covid with 1
mitiempo2 = seconds()

mitiempo3 = seconds()
DO sp_busco_ficha_covid with  2
mitiempo4 = seconds()

MESSAGEBOX(TRANSFORM(mitiempo2 -mitiempo1)+"   " +TRANSFORM(mitiempo4 -mitiempo3))