
Public mConO, mConD
&& Prueba
mConO = sqlstringconnect("Driver={InterSystems ODBC};PORT=1972;SERVER=172.16.5.60;DATABASE=CATALOGO;Uid=_system;Pwd=sys")
&& ??? Real
mConD = sqlstringconnect("Driver={InterSystems ODBC};PORT=1972;SERVER=172.16.1.4;DATABASE=CATALOGO;Uid=_system;Pwd=sys")
set step on
Do While .t. 

	mret = Sqlexec(mConO, "Select tbe_dni, tbe_image From TabExaminados"+;
	" where tbe_anio=2009", "mwkExamO")
	If mret <= 0
		Exit
	Endif 
	
	Select mwkExamO
	Copy To C:\TEMP\mwkExamO 
	Use In mwkExamO
	
	LL = Fopen("C:\temp\mwkExamO.dbf",12)
	Fseek(LL,75)
	Fwrite(LL,'M')
	Fclose(LL)

	Use C:\TEMP\mwkExamO Exclusive In 0
	
	Select mwkExamO
	Scan All
			
			lwImage = mwkExamO.tbe_image
			mdni 	= mwkExamO.tbe_dni

			mRet = Sqlexec(mConD, "Update TabResProfExa Set tbe_image = ?lwImage "+;
				"Where tbe_dni = ?mdni and tbe_anio=2009 ")
			If mRet <= 0
				? "Error Id " + Str(mdni )
				Set Step On
			Endif 
	
		Select mwkExamO
	EndScan	
	
	Use In mwkExamO
	
	Exit
Enddo

Sqldisconnect(mConO)
Sqldisconnect(mConD)


Return 
*----------------------------------------------------------------------

