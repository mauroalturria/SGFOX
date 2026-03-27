
mret = sqlexec(mcon1, 'select id, codpres, pre_descriprest, trim(descrip) as descri ' + ;
						'from turnosprepara, prestacions ' + ;
						'where codpres = pre_codprest and fecbaja = ?mfecha2', 'mwkmensaje')
