*
* Profesionales Medicos activos, por ingreso desde Módulo de Habilitaciones
*

If used('mwkbusmedall')
  Use in mwkbusmedall
Endif
mfecnul = ctot("01/01/1900")
mret = sqlexec(mcon1,"select * from TabGuaFich where tgf_fichasal = ?mfecnul " ,"mwkbusmedall")

If mret < 1
  messagebox("EN BUSQUEDA DE PROFESIONALES HABILITADOS",16,"ERROR")
Endif

