
Parameter mFechaIngr,mAbm,mNroadm,mUsuario

mfechanula = ctot("01/01/1900")
mret = sqlexec(mcon1,"select id,hcmfechaIngr from TabHCIMovst " +;
	" where hcmnroadm = ?mnroadm ","mwkcontrol" )
select * from mwkcontrol where hcmfechaIngr = mfechanula into cursor mwkcontrol2
select mwkcontrol2
scan
	mid = mwkcontrol2.id
	mret = sqlexec(mcon1,"update TabHCIMovst set hcmfechaIngr = ?mfechaIngr,hcmusuario = ?mUsuario" +;
		" where id = ?mid " )
endscan
if used ('mwkcontrol')
	use in mwkcontrol
endif
If mret < 0
	Messagebox('NO SE ACTUALIZO REINTENTE',16,'Validacion')
Endif
