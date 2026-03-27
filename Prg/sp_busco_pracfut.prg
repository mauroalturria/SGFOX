Parameters tcAdm


Text To lcsql Textmerge Noshow Pretext 7

SELECT distinct nvl(ep_fechorarealiza,ep_fechoralta) as ep_fechorarealiza, servicios.SER_descripserv,
Cast((case when ep_fechorarealiza = null then 0 else 1 end) as integer)  as realiza,
Cast({fn TIMESTAMPDIFF(SQL_TSI_HOUR, getdate(),nvl(ep_fechorarealiza,ep_fechoralta))} as integer ) as dife, ser_codserv
FROM TabEstudiosSolic t
inner join PRESTACIONS p on p.pre_codprest = ep_codprest
inner join servicios on pre_codservicio = ser_codserv
WHERE exists(select 1 from TabEstudiosSolic where EP_ADMISION = ?tcAdm and nvl(ep_fechorarealiza,ep_fechoralta)>= DATEADD('mi',-60*12,getdate()) )
        and  EP_ADMISION = ?tcAdm and nvl(ep_fechorarealiza,ep_fechoralta)>= DATEADD('mi',-60*12,getdate())
        Order by nvl(ep_fechorarealiza,ep_fechoralta) desc

Endtext 


If !Prg_EjecutoSql(lcSql,"mwkAdmPrea1")
	Return .f.
Endif  