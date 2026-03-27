CLOSE ALL

SET SAFETY OFF
SET CENTURY ON 
clear

mcon1=SQLCONNECT("catalogoPROD")
IF mcon1 < 1
  MESSAGEBOX("No se conectó a Cache")
  RETURN
endif

mfecdesde     = DATE()-30
mfechasta     = DATE()-1
mfechastamas1 = mfechasta + 1  && Por el campo FechaHora de Prealtas

mSqlQuery = "select pac_fechaalta, count(distinct pac_codadmision) as altas, " + ;
            "         count(distinct ipa_admision) as prealtas, " + ;
            "         min(cast(ipa_fechah as date)) as menorPrealta, " + ;
            "         max(cast(ipa_fechah as date)) as mayorPrealta " + ;
            "   from pacientes " + ;
            "      left join TabIntPreAlta on pac_codadmision = ipa_admision " + ;
            "  where pac_fechaalta between ?mfecdesde and ?mfechasta " + ;
            "     and pac_codadmision > '400000-0' " + ;
            "     and pac_sectorinternac not in ('EME','CEG','IQB','PRP','H10','NUR') " + ;
            "     and pac_motivoalta = 1 " + ;
            "  group by pac_fechaalta " 

&&? msqlquery

mok = SQLEXEC(mcon1,msqlquery,"curprealtas")
IF mok < 0
   =AERROR(v1)
   DISPLAY MEMORY LIKE v1
ENDIF

SELECT pac_fechaalta as fechaalta, altas as altasmedicas, ;
       prealtas as cantprealtas, prealtas/altas as pcntprealta, ;
       NVL(menorprealta,{}) as menorprealta, NVL(mayorprealta,{}) as mayorprealta ;
  FROM curprealtas ;
  INTO CURSOR cur2

SELECT cur2
COPY TO ("c:\work\reporte_prealtas_segun_fechaalta_"+DTOS(mfechasta)) TYPE xl5


mSqlQuery = "select ipa_admision, min(cast(ipa_fechah as date)) as MinPrealta, "+;
            "       max(cast(ipa_fechah as date)) as MaxPrealta,  pac_fechaalta "+;
            "   from TabIntPreAlta  "+;
            "    left join pacientes on ipa_admision = pac_codadmision "+;
            "   where IPA_fechah between ?mfecdesde and ?mfechastamas1 "+;
            "   group by ipa_admision, pac_fechaalta "+;
            "   order by 2 "
mok = SQLEXEC(mcon1,msqlquery,"curprealta2")
IF mok < 0
   =AERROR(v1)
   DISPLAY MEMORY LIKE v1
ENDIF

SELECT maxprealta as fecprealta, COUNT(*) as cantprealtas, ;
       SUM(IIF(isnull(pac_fechaalta),1,0)) as cantsinalta, ;
       SUM(IIF(not ISNULL(pac_fechaalta) AND pac_fechaalta=maxprealta,1,0)) as mismodia, ;
       SUM(IIF(not ISNULL(pac_fechaalta) AND pac_fechaalta-maxprealta=1,1,0)) as siguiente, ;
       SUM(IIF(not ISNULL(pac_fechaalta) AND pac_fechaalta-maxprealta=2,1,0)) as subsiguiente, ;
       SUM(IIF(not ISNULL(pac_fechaalta) AND pac_fechaalta-maxprealta>2,1,0)) as posteriores ;
   FROM curprealta2 ;
   GROUP BY 1 ;
   INTO CURSOR cur3

SELECT cur3
COPY TO ("c:\work\reporte_prealtas_segun_fechaPrealta_"+DTOS(mfechasta)) TYPE xl5


?SQLDISCONNECT(mcon1)

RETURN
