*!*	 Indice de Masa Física 
Parameters lnPesoKg, lnAlturaMt, lbEsCm

Local lnBMI
lnBMI = 0

If lnAlturaMt > 0
	lnBMI = lnPesoKg / (lnAlturaMt * lnAlturaMt)
Endif 	
If lbEsCm
	lnBMI = lnBMI * 10000
Endif 

Return lnBMI