		adf1 = strtran(str(mwkfactu.ptovta, 4), ' ', '0')
				adf2 = allt(mwkfactu.abrevio)
				adf3 = allt(mwkfactu.letracte)
				adf4 = allt(str(mwkfactu.nrocte ,8))
				maplimpo = allt(str(mwkfactu.importe,6,2))
				maplifact = adf3 +" "+adf1 +"-"+adf4
									maplifact = transf(.TxtFactApli.value ,"@L 99999999")
					maplimpo	= ''
	