Parameters tcDetalle

Local loMail && as Cusmail Of c:\desaguemes\lib\outlookmail.vcx

#DEFINE LF_CR CHR(10)+CHR(13)


lcAsunto = "Reinicio del llamador"
lcCuerpo = "Fecha " + Ttoc(Datetime()) + " " 
lcCuerpo = lcCuerpo + "Se reinicia el servidor del llamador " + ALLTRIM(myip)+"-"+SYS(0) + LF_CR + tcDetalle

loMail = Newobject("Cusmail","c:\desaguemes\lib\outlookmail.vcx")

lcMail   = "nrojas@silver-cross.com.ar"
*!*	lcMail   = "gfittipaldi@silver-cross.com.ar"

loMail.sendmail('','',lcMail,lcAsunto,lcCuerpo,"",.t.)

oMail = .f.
Release oMail

Do prg_reboot With .t.