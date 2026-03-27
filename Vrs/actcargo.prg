mimed = 0
set step on
select cargo
scan
	if mimed # idmedico
		mimed = idmedico
		update presta_cargo set codambito = 9 where codprof = mimed
	endif
	select cargo	
	mcodesp = codesp
	mid = id
	mamb = amb
	mgua = gua
	mint = int
	if mamb = 1
		insert into presta_cargo (codambito,codarea,codcargo,codprof,codiesp) ;
			values (1,1,mid,mimed,mcodesp)
	endif
	if mgua = 1
		insert into presta_cargo (codambito,codarea,codcargo,codprof,codiesp) ;
			values (1,2,mid,mimed,mcodesp)
	endif
	if mint = 1
		insert into presta_cargo (codambito,codarea,codcargo,codprof,codiesp) ;
			values (1,3,mid,mimed,mcodesp)
	endif
	select cargo
endscan
