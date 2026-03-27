select gracedih 
go top
do while !eof()
	select tabestados
	replace descrip with "grace muerte intrahospitalaria",estado  with gracedih.porc  ,subestado with gracedih.valor*1000 ;
		tipo with 1
	skip 1
	select gracedih 
	skip 1
enddo

select tabestados
go top
do while !eof()
select tabestados350
	replace descrip with tabestados.descrip,estado  with tabestados.estado ,subestado with tabestados.subestado ;
		tipo with tabestados.tipo
	skip 1
	select tabestados
	skip 1
enddo
