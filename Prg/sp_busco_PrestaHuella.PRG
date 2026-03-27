Lparameters tnCodMed	
*--------------------------------------------------------------------------	
Local lcWhere
lcWhere = ""
If tnCodMed > 0
	lcWhere = " Where PH_CodMed = ?tnCodMed "
Endif 

mRet = Sqlexec(mcon1,"Select * from Tabprestahuellas " + lcWhere ,"mwkPrestaHuellas") 

If mRet <= 0
	Messagebox("ERROR DE LECTURA DE PRESTADORES - HUELLA",16,"ERROR")
	Return .f.
Endif 

Use In Select("mwkPrestaHuellas_Aux")

Select * ;
	From mwkPrestaHuellas ;
	Into Table ("C:\Temp\mwkPrestaHuellas_Aux")

Use In Select("mwkPrestaHuellas")
Use In Select("mwkPrestaHuellas_Aux")
lnHand = Fopen("C:\Temp\mwkPrestaHuellas_Aux.Dbf",1)
&& campo huella1 cache 5 anda
*fseek(lnHand,139)
fseek(lnHand,107)
fwrite(lnHand,'M')
fclose(lnHand)	

Use "C:\Temp\mwkPrestaHuellas_Aux.Dbf" In 0 Alias mwkPrestaHuellas 
