mret = sqlexec(mcon3, "select lug_pacientes , lug_fechaingreso , lug_horaingreso , " + ;
	" lug_fechaegreso , lug_horaegreso from lugarintern  " + ;
	" left join pacientes on lug_pacientes = pac_codadmision " + ;
	" left join coberturas on pac_codadmision = cob_pacientes " + ;
	" where lug_categoria = 'I' and cob_codentidad = 905 " + ;
	" and lug_fechaegreso is null " + ;
	"", "mwkind01")
	if mret < 0
		=aerr(eros)
		messagebox(eros(2))
		messagebox(eros(3))
	endif
select *;
,iif(lug_fechaingreso<ctod("01/01/2005"),ctod("01/01/2005"),lug_fechaingreso) as fi;
,iif(lug_fechaegreso>ctod("31/01/2005"),ctod("31/01/2005"),lug_fechaegreso) as fe;
from mwkind01 into cursor mwkind011

select *,fe-fi+1  as dias from mwkind011 into cursor dias01
copy to c:\ale\das01 type xls