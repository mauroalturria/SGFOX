public mcon1
do sp_conexion

mret = sqlexec(mcon1, "select REG_nrohclinica , REG_nombrepac , REG_numdocumento , "+;
 "AFI_fechabaja , REG_fecbajapadron , REG_nroregistrac , AFI_nroafiliado "+;
 " from registracio "+;
 " left outer join afiliacion on registracio . REG_nroregistrac = afiliacion . registracio "+;
 " where AFI_codentidad = 104" ,"plan104")
mret = sqlexec(mcon1, "select REG_nrohclinica , REG_nombrepac , REG_numdocumento , "+;
 "AFI_fechabaja , REG_fecbajapadron , REG_nroregistrac , AFI_nroafiliado "+;
 " from registracio "+;
 " left outer join afiliacion on registracio . REG_nroregistrac = afiliacion . registracio "+;
 " where AFI_codentidad = 100" ,"plan100")
 mret = sqlexec(mcon1, "select REG_nrohclinica , REG_nombrepac , REG_numdocumento , "+;
 "AFI_fechabaja , REG_fecbajapadron , REG_nroregistrac , AFI_nroafiliado "+;
 " from registracio "+;
 " left outer join afiliacion on registracio . REG_nroregistrac = afiliacion . registracio "+;
 " where AFI_codentidad = 101" ,"plan101")
 mret = sqlexec(mcon1, "select REG_nrohclinica , REG_nombrepac , REG_numdocumento , "+;
 "AFI_fechabaja , REG_fecbajapadron , REG_nroregistrac , AFI_nroafiliado "+;
 " from registracio "+;
 " left outer join afiliacion on registracio . REG_nroregistrac = afiliacion . registracio "+;
 " where AFI_codentidad = 102" ,"plan102")


