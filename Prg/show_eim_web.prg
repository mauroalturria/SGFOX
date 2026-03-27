Parameters tnIdEvol

lbDesarrollo = .F. && conecta
If lbDesarrollo
	zzvolumen = "C:"
	tnIdEvol = 12
	
	tnIdEvol = 449 && Real
Endif
lbIe = .F. && externo

lcDirO = Proper(Alltrim(zzvolumen) + "\qepd1a1\xlt\")
lcFileO = "base_int.html"
lcFileCSS = 'sg_clases_int.css'
*-
lcDirD   = "c:\Temp\interna\"
lcFileD = 'int_' + Transform(tnIdEvol) + Strtran(Time(),":","") + '_.html'

If File(lcDirO + lcFileO)
	Copy File(lcDirO + lcFileO) To (lcDirD + lcFileO)
Endif
If File(lcDirO + lcFileCSS)
	Copy File(lcDirO + lcFileCSS ) To (lcDirD + lcFileCSS )
Endif

lcDirO   = "c:\Temp\interna\"

*!*	lcDirO   = "c:\wamp\www\maquetado\"
*!*	lcFileO = 'base_int.html'
*!*	lcDirD   = "c:\wamp\www\maquetado\"
*!*	lcFileD = 'index2.html'

If lbDesarrollo
	Do sp_conexion
Endif

* tnIdEvol = 80
* On Error

TEXT To lcsql Noshow Textmerge
	Select tabintevolMed.Id, tabintevolMed.Eim_CodMed, tabintevolMed.Eim_Html, tabintevolMed.EIM_fechaH
		From tabintevolMed
		Where EIM_IdEvol = ?tnIdEvol
		Order by tabintevolMed.EIM_fechaH Desc
ENDTEXT

If !prg_ejecutosql(lcsql, 'mwkEvolsd')
	Return .F.
Endif
if !used('mwkMedicointall')
	do sp_busco_med_pisos &&  with sp_busco_fecha_serv("DD")
	select  id, nombre,codesp,matricula as matriculas  from mwkmedicoint where 1=2 into cursor mwkMedicouno
	use in select("mwksinmed")
	use dbf('mwkMedicouno') in 0 again alias mwksinmed
	select mwksinmed
	insert into mwksinmed (id, nombre,codesp,matriculas  ) values (1,"MEDICO INTERNACION","",0)
	select  id, nombre,codesp,matricula as matriculas  from mwkmedicoint union all;
		select * from mwksinmed into cursor mwkMedicointall
	use in select("mwksinmed")
	use in select("mwkMedicouno")
endif
SELECT mwkEvolsd.*,nombre,matriculas from mwkEvolsd left join mwkMedicointall on Eim_CodMed = mwkMedicointall.id into cursor mwkEvols

lcSep = Chr(10)
lcHtmlBase = ''

lcArray1 = ''
lcArray2 = ''
lcArray3 = ''
lcArray4 = ''
lcArray5 = ''
lcArray6 = ''

lnUltimo = 0

Select mwkEvols
Count To lnUltimo

If lnUltimo = 0
	Messagebox("NO EXISTEN EVOLUCIONES REGISTRADAS",48,"ATENCION")
	Return
Endif

Select mwkEvols
Scan All
	lcCab = Iif(Mod(Id,2) = 0, '', '2')
	lcHtmlBase = lcHtmlBase + '<div class="cabecera' + lcCab + '" id = "' + Transform(mwkEvols.Id) + '" >' + lcSep
	lcHtmlBase = lcHtmlBase + '<h6>' + Transform(EIM_fechaH) + ' - ' + nombre + IIF(NVL(matriculas,0)<>0, " M.N.:"+transform(matriculas),"")+ ' </h6>' + lcSep
	lcHtmlBase = lcHtmlBase +  Eim_Html + lcSep
	lcHtmlBase = lcHtmlBase + '</div>' + lcSep
	lcHtmlBase = lcHtmlBase + '<hr>' + lcSep

	lcComa = ',' + lcSep
	If lnUltimo = Recno()
		lcComa = ''
	Endif
	lcArray1 = lcArray1 + "document.getElementById('mdiv1_" + Transform(mwkEvols.Id) + "')" + lcComa
	lcArray2 = lcArray2 + "document.getElementById('mdiv2_" + Transform(mwkEvols.Id) + "')" + lcComa
	lcArray3 = lcArray3 + "document.getElementById('mdiv3_" + Transform(mwkEvols.Id) + "')" + lcComa
	lcArray4 = lcArray4 + "document.getElementById('mdiv4_" + Transform(mwkEvols.Id) + "')" + lcComa
	lcArray5 = lcArray5 + "document.getElementById('mdiv5_" + Transform(mwkEvols.Id) + "')" + lcComa
	lcArray6 = lcArray6 + "document.getElementById('mdiv6_" + Transform(mwkEvols.Id) + "')" + lcComa

	marmohtml = .T.
	Select mwkEvols
Endscan

lcArrayTodos = lcArray1 + "," + lcSep  + lcArray2 + "," + lcSep + lcArray3 + "," + lcSep + lcArray4 + "," + lcSep + lcArray5 + "," + lcSep + lcArray6 + lcSep

lcHtml = Filetostr( lcDirO + lcFileO )
lcHtmlFinal = Strtran(lcHtml, '<<ARMADO>>' ,lcHtmlBase)
lcHtmlFinal = Strtran(lcHtmlFinal, '<<SCRIPT>>' ,AgregoScrip())
Strtofile(lcHtmlFinal, (lcDirD + lcFileD ))

If lbDesarrollo
	Do Sp_Desconexion
Endif
Use In Select("mwkEvols")

If lbIe

	Declare Integer SetParent In user32;
		INTEGER hWndChild,;
		INTEGER hWndNewParent

	Public oWeb As InternetExplorer.Application
	oWeb = Createobject("InternetExplorer.Application")
	oWeb.Toolbar = 0
	oWeb.StatusBar = 0
	oWeb.Silent = .T.
	oWeb.RegisterAsBrowser = 1

	oWeb.Navigate2("c:\wamp\www\maquetado\index2.html",16)
	SetParent(oWeb.HWnd, _Screen.HWnd)
	oWeb.Visible = .T.

Else

	Do Form frmWeb01 With 'EVOLUCION', (lcDirD + lcFileD )

	If File(lcDirD + lcFileD )
		Delete File (lcDirD + lcFileD )
	Endif

*!*	oWeb.Width = frmWeb01.Width - 2
*!*	oWeb.Height = frmWeb01.Height - frmWeb01.image1.Height - 2
*!*	oWeb.Top =  -190
*!*	oWeb.Left = 0
*   frmWeb01.show(0)

Endif


Procedure AgregoScrip

lcSep = Chr(10)
lcScrip = '	<script type="text/javascript"> ' + lcSep
lcScrip = lcScrip + 'function _viewdivs(mclase1, mclase2, mcheck){' + lcSep
lcScrip = lcScrip + 'var mele ' + lcSep
lcScrip = lcScrip + " if (mclase2 != 'vetodo') " + lcSep
lcScrip = lcScrip + '{'  + lcSep

lcScrip = lcScrip + "if (mclase2 == 'apaneu')" + lcSep
lcScrip = lcScrip + '{' + lcSep
lcScrip = lcScrip + "var mele = new Array(" + lcArray1 + "); " + lcSep
lcScrip = lcScrip + '}' + lcSep

lcScrip = lcScrip + "if (mclase2 == 'apares')" + lcSep
lcScrip = lcScrip + '{' + lcSep
lcScrip = lcScrip + "var mele = new Array(" + lcArray2 + "); " + lcSep
lcScrip = lcScrip + '}' + lcSep

lcScrip = lcScrip + "if (mclase2 == 'apacar')" + lcSep
lcScrip = lcScrip + "{" + lcSep
lcScrip = lcScrip + "var mele = new Array(" + lcArray3 + "); " + lcSep
lcScrip = lcScrip + '}' + lcSep

lcScrip = lcScrip + "if (mclase2 == 'apauri')" + lcSep
lcScrip = lcScrip + "{" + lcSep
lcScrip = lcScrip + "var mele = new Array(" + lcArray4 + "); " + lcSep
lcScrip = lcScrip + '}' + lcSep

lcScrip = lcScrip + "if (mclase2 == 'evolucion')" + lcSep
lcScrip = lcScrip + "{" + lcSep
lcScrip = lcScrip + "var mele = new Array(" + lcArray5 + "); " + lcSep
lcScrip = lcScrip + '}' + lcSep

lcScrip = lcScrip + "if (mclase2 == 'scores')" + lcSep
lcScrip = lcScrip + "{" + lcSep
lcScrip = lcScrip + "var mele = new Array(" + lcArray6 + "); " + lcSep
lcScrip = lcScrip + '}' + lcSep

lcScrip = lcScrip + "}" + lcSep
lcScrip = lcScrip + "else" + lcSep
lcScrip = lcScrip + "{" + lcSep
lcScrip = lcScrip + "var mele = new Array( " + lcSep

lcScrip = lcScrip + lcArrayTodos + ")"+ lcSep
lcScrip = lcScrip + "}"	 + lcSep

lcScrip = lcScrip + "var oldstatus = mcheck.checked?'0':'1' ; " + lcSep
lcScrip = lcScrip + "newstatus = oldstatus=='0'?'1':'0'; " + lcSep
lcScrip = lcScrip + "if (mclase2 == 'vetodo') " + lcSep
lcScrip = lcScrip + "{" + lcSep
lcScrip = lcScrip + "document.getElementById('chk1').checked = mcheck.checked; " + lcSep
lcScrip = lcScrip + "document.getElementById('chk2').checked = mcheck.checked; " + lcSep
lcScrip = lcScrip + "document.getElementById('chk4').checked = mcheck.checked; " + lcSep
lcScrip = lcScrip + "document.getElementById('chk5').checked = mcheck.checked; " + lcSep
lcScrip = lcScrip + "document.getElementById('chk6').checked = mcheck.checked; " + lcSep
lcScrip = lcScrip + "document.getElementById('chk7').checked = mcheck.checked; " + lcSep
lcScrip = lcScrip + "}"	 + lcSep
lcScrip = lcScrip + "else" + lcSep
lcScrip = lcScrip + "{" + lcSep
lcScrip = lcScrip + "document.getElementById('chk3').checked = false;" + lcSep
lcScrip = lcScrip + "}"	 + lcSep
lcScrip = lcScrip + "for (index = 0; index < mele.length; ++index) { " + lcSep
lcScrip = lcScrip + "if(mele[index]){ "
lcScrip = lcScrip + "mele[index].style.display = newstatus=='0'?'none':'block'; " + lcSep
lcScrip = lcScrip + "}"	 + lcSep
lcScrip = lcScrip + "}" + lcSep
lcScrip = lcScrip + "}" + lcSep
lcScrip = lcScrip + "</script> " + lcSep

Return lcScrip

