** Obtiene los datos de un File interfaz de Vale Asistencial para impresión Impresión (vap file)
*  Devuelve los datos en una serie de cursores:
*  VAPHEAD1  = 1er. row del header
*  VAPHEAD2  = 2do. row del header
*  VAPPREST  = Items de Prestaciones (principales, asociadas, especiales,...)
*  VAPINSUM  = Items de Insumos/Medic (principales, asociados,...)
*  VAPFOOT1  = 1er. row del footer
*
Parameters InputFile

VapCreaCursores()
VapCargaCursores(m.InputFile)

return

********************************
