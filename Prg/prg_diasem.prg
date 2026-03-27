****
** Dia de la semana
****
parameter mdia,mfto  &&& mfto = 1 dia largo 2 = dia corto 3 = dia corto may
if vartype(mfto)#"N"
	mfto = 1
endif
do case
	case mfto = 1
		cdia = iif(mdia = 2,'Lunes     ', iif(mdia =3,'Martes    ',;
			iif(mdia =4,'Miércoles ', iif(mdia =5,'Jueves    ',+;
			iif(mdia =6,'Viernes   ', iif(mdia =7,'Sábado    ','Domingo   '))))))
	case mfto = 2
		cdia = iif(mdia = 2,'Lun', iif(mdia =3,'Mar',;
			iif(mdia =4,'Mié', iif(mdia =5,'Jue',+;
			iif(mdia =6,'Vie', iif(mdia =7,'Sáb','Dom'))))))
	case mfto = 3
		cdia = iif(mdia = 2,'LUN', iif(mdia =3,'MAR',;
			iif(mdia =4,'MIE', iif(mdia =5,'JUE',+;
			iif(mdia =6,'VIE', iif(mdia =7,'SAB','DOM'))))))
endcase
return cdia
