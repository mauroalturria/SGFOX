USE c:\desaguemes\mails_junio.dbf IN 0 SHARED
BROWSE LAST
select nvl(reg_email,"NO TIENE") as mail,* from turnopac ;
where mail#"NO TIENE" and afiliado not in (select afiliado from turnoid) into cursor mails
select nvl(reg_email,"NO TIENE") as mail,* from turnopac ;
where afiliado not in (select afiliado from turnoid) into cursor mails
browse
select * from mails where mail#"NO TIENE"
copy to mails_julio type xls
select afiliado from mails into cursor julio
BROWSE LAST
SELECT 2
BROWSE LAST
select * from julio union select * from turnoid into cursor acu
select * from julio where mail#"NO TIENE" union select * from turnoid into cursor acu
select * from mails where mail#"NO TIENE" into cursor dd
select afiliado from mails where mail#"NO TIENE" union select * from turnoid into cursor acu
select * from acu group by afiliado into cursor mailsss
copy to mails_acumula
