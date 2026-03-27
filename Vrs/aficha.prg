requery('pacientes2')
requery('ficha_influenza')
requery('ficha_gua')

select transform(val(left(fe_proto,7)),"999999-9") as admi,* from ficha_influenza into cursor ficha
select * from ficha,pacientes2 where admi=pac_codadmision order by pac_nombrepaciente into cursor fichasINT
