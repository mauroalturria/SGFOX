select * from cosepracpad group by prestacion into table osut
update osut set entidad = 909 &&&  945
select * from osut order by fecha
browse last

arreglar nulos

select cosepracfp
append from osut
requery('cosepracfp')

select cosepracpad
scan
miprest = prestacion
mival = tipoatenamb
update cosepracfp set tipoatenamb = mival where prestacion = miprest
endscan
requery('cosepracfp')
select cosepracfp
browse last
