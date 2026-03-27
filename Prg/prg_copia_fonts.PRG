*!*	dirfonts = Alltrim(Getenv('windir'))+ '\fonts\Pf_i2of5.ttf'
*!*	Do prg_errorset
*!*	If !File(dirfonts) AND myip<>'172.16.1.7'
*!*	*	Copy File Pf_i2of5.ttf To &dirfonts
*!*	Endif
