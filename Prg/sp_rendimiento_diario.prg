*rendomiento horario diario

select a.codesp,a.codmed,b.nombre,a.diasem,a.horadesde, ;
	a.horahasta,(a.horahasta -a.horadesde)/3600 as horas;
	from medpresta as a, prestadores as b;
	where diasem is not null and a.codmed=b.id and;
	fecvigend<=to_date('31/05/2002','dd/mm/yyyy') and;
	fecvigenh >=to_date('01/05/2002','dd/mm/yyyy') and;
	group by a.codesp,a.codmed,a.diasem, a.horadesde;
	order by codesp,codmed,diasem,horadesde
