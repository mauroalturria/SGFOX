parameter InpFile

*  cursor VAPHEAD1  = 1er. row del header: Datos inherentes al vale
select VapHead1
append from (m.InpFile) for TipoReg = 1 type delimited with tab

*  cursor VAPHEAD2  = 2do. row del header: Datos inherentes al Paciente
select VapHead2
append from (m.InpFile) for TipoReg = 2 type delimited with tab

*  cursor VAPPRES3  = Prestaciones principales (tipo 3) (NO vales de Farmacia)
select VapPres3
append from (m.InpFile) for TipoReg = 3 type delimited with tab

*  cursor VAPINSU4  = Insumos principales (tipo 4) (vales de Farmacia)
select VapInsu4
append from (m.InpFile) for TipoReg = 4 type delimited with tab

*  cursor VAPPASO5  = Prestaciones Asociadas (tipo 5) (NO vales de Farmacia)
select VapPAso5
append from (m.InpFile) for TipoReg = 5 type delimited with tab

*  cursor VAPIASO6  = Insumos Asociados (tipo 6) (NO vales de Farmacia)
select VapIAso6
append from (m.InpFile) for TipoReg = 6 type delimited with tab

*  cursor VAPPESP7  = Prestaciones Especiales Asociadas al VALE (tipo 7) (NO vales de Farmacia)
select VapPEsp7
append from (m.InpFile) for TipoReg = 7 type delimited with tab

return

*********************************************
