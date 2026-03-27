use in select('VALESPAC')
use dbf('vales') in 0 exclusive alias VALESPAC
ALTER TABLE VALESPAC ADD COLUMN fecCONF D 
ALTER TABLE VALESPAC  ADD COLUMN secconf n(4)
select VALESPAC
scan
	mvale = valespac.vale
	requery('vales_real')
	mfec = nvl(vales_real.VAL_fechaconforme,ctod("01/01/1900"))
	nsec = nvl(vales_real.VAL_verificaconfor,0)
	select valespac
	replace fecconf with mfec,secconf with nsec
endscan
copy to vales type xl5
