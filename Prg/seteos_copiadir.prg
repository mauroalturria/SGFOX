	lcfile = 'https://cup.pami.org.ar/controllers/loginController.php?redirect=https://pe.pami.org.ar'
	                                                                                                               
	loBrowser = createobject("InternetExplorer.Application")
			loBrowser.Navigate(lcfile)
			loBrowser.visible=.t.
			release loBrowser
*!*	If File(mrun)
*!*		run /n &mrun 
*!*	Endif	