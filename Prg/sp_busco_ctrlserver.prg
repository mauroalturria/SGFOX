*
* Busco datos en TabCtrlServer segun area
*
Lparameters mf1,mf2

If used('mwkTCS0')
	Use in mwkTCS0
Endif

&& mlarea,

mret = sqlexec(mcon1,"select * from TabCtrlServer "+;
"where TCS_Fechah >= ?mf1 and TCS_Fechah <= ?mf2","mwkTCS0")

&& TCS_Name = ?mlarea and 
&& "and TCS_Usuario<>0"


If mret < 0
	Messagebox("EN CONSULTA CTRL SERVER",16,"ERROR")
Endif
