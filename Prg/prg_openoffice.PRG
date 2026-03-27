*
* API Open Office + Ejemplos
*
Lparameters marchivo, mtipo

* marchivo : nombre del archivo
* mtipo    : doc, txt, xls, etc.

Local oDoc
Local oTxt
Local oRng
Local oCursor
Local oSourceframe
Local oDisp

Local ARRAY argsinsert[1]
Local ARRAY NoArg[1]
Local ARRAY DownArg[2]
Local  SrcFile
Local cInsertfilename

Local ARRAY aOneArg[1]
Local cFile, cURL

#Define CR CHR(13)
#Define wdTAB CHR(9)

#Define PARAGRAPH_BREAK 0
#Define LINE_BREAK  1
#Define HARD_HYPHEN 2
#Define SOFT_HYPHEN 3
#Define HARD_SPACE  4
#Define APPEND_PARAGRAPH  5

loManager = CREATEOBJECT( "com.sun.star.ServiceManager" )
loDesktop = loManager.createInstance( "com.sun.star.frame.Desktop" )

march = "C:\temp\informes\"+alltrim(marchivo)+"."+mtipo

If file( march )

*	mofarch = "file:///c:/temp/informes/"+marchivo+"."+mtipo

	mofarch = "c:/temp/informes/"+marchivo+"."+mtipo
	oDoc = OOoOpenFile( mofarch )

*	oDoc = OOoOpenURL( mofarch )
*	oTxt = oDoc.getText
*	oCursor = oTxt.createTextCursor()

Else && Archivo Nuevo / Validado para Write
*!*		if mtipo = "doc"
*!*		   messagebox("RECUERDE AL GUARDAR DE ESTABLECER"+chr(10)+"FORMATO MS-OFFICE, WORD",48,"Validación")
*!*		endif  
	mofarch = "file:///c:/temp/informes/"+marchivo+"."+mtipo
	if  mtipo="doc" or mtipo="txt" or mtipo="odt"
		oDoc = OOoCreateNewWriterDocument()
		oTxt = oDoc.getText
		oCursor = oTxt.createTextCursor()
		oDoc.TEXT.InsertString( oCursor, "." , .F. )
		aOneArg[1] = OOoPropertyValue( "Overwrite", .T. )
		oDoc.storeAsURL( mofarch, @aOneArg )
	Else
		Messagebox("EXTENSION DE ARCHIVO NO VALIDADA"+chr(10)+"AVISE A SISTEMAS",48,"Validación")
		Return
	Endif
Endif

Release oDcon

Return

*
*  Library of routines to manipulate OpenOffice.org.
*
*  Public API
*  High level routines.
*
*  Return .T. if OpenOffice.org is installed.
*  Return .F. if not installed.

Function OOoIsInstalled()
Local oServiceManager
oServiceManager = .NULL.

Local cOldErrHandler
cOldErrHandler = ON( "ERROR" )
On ERROR = DoNothing__ErrorHandler( ERROR(), MESSAGE(), LINENO(), SYS(16), PROGRAM(), SYS(2018) )
oServiceManager = OOoGetServiceManager()
On ERROR &cOldErrHandler
* If we could create a Service Manager,
*  then OpenOffice.org must be installed.
Return NOT ISNULL( oServiceManager )
Endfunc
* Easy way to create a new Draw document.
Function OOoCreateNewDrawDocument()
Local oDrawDoc
oDrawDoc = OOoOpenURL( "private:factory/sdraw" )
Return oDrawDoc
Endfunc
* Easy way to create a new Writer document.
Function OOoCreateNewWriterDocument()
Local oWriterDoc
oWriterDoc = OOoOpenURL( "private:factory/swriter" )
Return oWriterDoc
Endfunc
* Easy way to create a new Calc document.
Function OOoCreateNewCalcDocument()
Local oCalcDoc
oCalcDoc = OOoOpenURL( "private:factory/scalc" )
Return oCalcDoc
Endfunc
* Easy way to create a new Impress document.
Function OOoCreateNewImpressDocument()
Local oImpressDoc
oImpressDoc = OOoOpenURL( "private:factory/simpress" )
Return oImpressDoc
Endfunc
Function OOoOpenFile( cFilename )
Local cURL
cURL = OOoConvertToURL( cFilename )

Local oDoc
oDoc = OOoOpenURL( cURL )
Return oDoc
Endfunc
Procedure OOoTerminateProgram()
Local oDesktop
oDesktop = OOoGetDesktop()
oDesktop.Terminate()
=__OOoReleaseCachedVars()
Endproc
* Convert a local filename to an OOo URL.
Function OOoConvertToURL( cFilename )
* Ensure leading slash.
If LEFT( cFilename, 1 ) != "/"
	cFilename = "/" + cFilename
Endif

Local cURL
cURL = CHRTRAN( cFilename, "\", "/" )	&& change backslashes to forward slashes.
cURL = "file://" + cURL
Return cURL
Endfunc
*############################################################
*	Draw specific tools
*############################################################
* Page zero is the first page.
* Once you have a drawing document, obtain one of its pages.
Function OOoGetDrawPage( oDrawDoc, nPageNum )
Local oPages
oPages = oDrawDoc.GetDrawPages()
Local oPage
oPage = oPages.GetByIndex( nPageNum )
Return oPage
Endfunc
* Given a draw document, create a shape.
* The shape must be added to the draw page, by calling
* the draw page's Add() method.
* The oPosition and oSize arguments are optional, but you may
* pass a Point and Size struct for these arguments.
Function OOoMakeRectangleShape( oDrawDoc, oPosition, oSize )
Local oShape
oShape = OOoMakeShape( oDrawDoc, "com.sun.star.drawing.RectangleShape", oPosition, oSize )
Return oShape
Endfunc
Function OOoMakeEllipseShape( oDrawDoc, oPosition, oSize )
Local oShape
oShape = OOoMakeShape( oDrawDoc, "com.sun.star.drawing.EllipseShape", oPosition, oSize )
Return oShape
Endfunc
Function OOoMakeLineShape( oDrawDoc, oPosition, oSize )
Local oShape
oShape = OOoMakeShape( oDrawDoc, "com.sun.star.drawing.LineShape", oPosition, oSize )
Return oShape
Endfunc
Function OOoMakeTextShape( oDrawDoc, oPosition, oSize )
Local oShape
oShape = OOoMakeShape( oDrawDoc, "com.sun.star.drawing.TextShape", oPosition, oSize )
Return oShape
Endfunc
* Create and return a Point struct.
Function OOoPosition( nX, nY )
Local oPoint
oPoint = OOoCreateStruct( "com.sun.star.awt.Point" )
oPoint.X = nX
oPoint.Y = nY
Return oPoint
Endfunc
* Create and return a Size struct.
Function OOoSize( nWidth, nHeight )
Local oSize
oSize = OOoCreateStruct( "com.sun.star.awt.Size" )
oSize.Width = nWidth
oSize.Height = nHeight
Return oSize
Endfunc
* Given a shape, alter its position.
Procedure OOoSetPosition( oShape, nX, nY )
Local oPosition
oPosition = oShape.Position
oPosition.X = nX
oPosition.Y = nY
oShape.Position = oPosition
Endproc
* Given a shape, alter its size.
Procedure OOoSetSize( oShape, nWidth, nHeight )
Local oSize
oSize = oShape.Size
oSize.Width = nWidth
oSize.Height = nHeight
oShape.Size = oSize
Endproc
* Given a draw document, create a shape.
* Optional:  oPosition, oSize can receive a Point or Size struct.
Function OOoMakeShape( oDrawDoc, cShapeClassName, oPosition, oSize )
Local oShape
oShape = oDrawDoc.createInstance( cShapeClassName )

If (TYPE([oPosition])="O")  AND  (NOT ISNULL( oPosition ))
	oShape.Position = oPosition
Endif
If (TYPE([oSize])="O")  AND  (NOT ISNULL( oSize ))
	oShape.Size = oSize
Endif

Return oShape
Endfunc

*############################################################
*	Color conversion utilities
*	--------------------------
*	Visual FoxPro and OpenOffice.org do not represent
*	 color values the same way.
*	Conversion routines in both directions are provided
*	 to keep things easy.
*	In addition, extremely convenient HSV routines are provided.
*	See LibGraphics for discussion of HSV color model.
*############################################################
* Similar to VFP's built in RGB() function.
* Pass in R,G,B values and out comes an OpenOffice.org color value.
* Note that this is DIFFERENT from how VFP constructs color values.
Function OOoRGB( nRed, nGreen, nBlue )
Return BITOR( BITOR( BITLSHIFT( nRed, 16 ), BITLSHIFT( nGreen, 8 ) ), nBlue )
Endfunc
* Translate between a Visual FoxPro color and an OpenOffice.org color
*  by using a simple formula.
* Pass in a VFP color, out comes an OOo color.  And vice versa.
Function OOoColor( nColor )
Local nTranslatedColor
nTranslatedColor = (INT( nColor / 65536 )) + (INT( INT( nColor / 256 ) % 256 ) * 256) + (INT( nColor % 256 ) * 65536)
Return nTranslatedColor
Endfunc
* Extract the Red component from an OpenOffice.org color.
* SImilar to the RGBRed() function in LibGraphics.
Function OOoRed( nOOoColor )
*	RETURN INT( nOOoColor / 65536 )
Return BITRSHIFT( BITAND( nOOoColor, 0x00FF0000 ), 16 )
Endfunc

* Extract the Green component from an OpenOffice.org color.
* SImilar to the RGBGreen() function in LibGraphics.
Function OOoGreen( nOOoColor )
*	RETURN INT( INT( nOOoColor / 256 ) % 256 )
Return BITRSHIFT( BITAND( nOOoColor, 0x0000FF00 ), 8 )
Endfunc

* Extract the Blue component from an OpenOffice.org color.
* SImilar to the RGBBlue() function in LibGraphics.
Function OOoBlue( nOOoColor )
*	RETURN INT( nOOoColor % 256 )
Return BITAND( nOOoColor, 0x000000FF )
Endfunc

* Convenient way to construct an OOo color from HSV components.
* See LibGraphics for information about HSV.
* Note nHue is a number from 0.0 to 1.0.

Function OOoHSV( nHue, nSaturation, nBrightness )
Local nColor
*!*	nColor = MakeHSVColor( nHue * 6.0, nSaturation, nBrightness )
*!*	nColor = OOoColor( nColor )
ncolor = 255
ncolor = OOoColor( nColor )
Return nColor
Endfunc

* Convenient way to extract the Hue component from an OOo color.
* See LibGraphics for information about HSV.
* Note nHue is a number from 0.0 to 1.0.
Function OOoHue( nOOoColor )
Return HSVHue( OOoColor( nOOoColor ) ) / 6.0
Endfunc

* Convenient way to extract the Saturation component from an OOo color.
* See LibGraphics for information about HSV.
Function OOoSaturation( nOOoColor )
Return HSVSaturation( OOoColor( nOOoColor ) )
Endfunc

* Convenient way to extract the Brightness component from an OOo color.
* See LibGraphics for information about HSV.
Function OOoBrightness( nOOoColor )
Return HSVValue( OOoColor( nOOoColor ) )
Endfunc

*############################################################

Procedure DoNothing__ErrorHandler( pnError, pcErrMessage, pnLineNo, pcProgramFileSys16, pcProgram, pcErrorParamSys2018 )
Endproc
* Return the OpenOffice.org service manager object.
* Cache it in a global variable.
* Create it if not already cached.
Function OOoGetServiceManager()
If (TYPE([goOOoServiceManager])!="O")  OR  ISNULL( goOOoServiceManager )
	Public goOOoServiceManager
	goOOoServiceManager = CREATEOBJECT( "com.sun.star.ServiceManager" )
Endif
Return goOOoServiceManager
Endfunc

* Sugar coated routine to ask the service manager to
*  create you an instance of some other OpenOffice.org UNO object.
Function OOoServiceManager_CreateInstance( cServiceName )
Local oServiceManager
oServiceManager = OOoGetServiceManager()

Local oInstance
oInstance = .NULL.

Local cOldErrHandler
cOldErrHandler = ON( "ERROR" )
On ERROR = DoNothing__ErrorHandler( ERROR(), MESSAGE(), LINENO(), SYS(16), PROGRAM(), SYS(2018) )
oInstance = oServiceManager.createInstance( cServiceName )
On ERROR &cOldErrHandler

If ISNULL( oInstance )
	=__OOoReleaseCachedVars()
	oServiceManager = OOoGetServiceManager()
	oInstance = oServiceManager.createInstance( cServiceName )
Endif

Return oInstance
Endfunc


* Sugar coated routine to create any UNO struct.
* Use the Bridge_GetStruct() feature of the OLE-UNO bridge.
Function OOoCreateStruct( cTypeName )
Local oServiceManager
oServiceManager = OOoGetServiceManager()

Local oStruct
oStruct = .NULL.

Local cOldErrHandler
cOldErrHandler = ON( "ERROR" )
On ERROR = DoNothing__ErrorHandler( ERROR(), MESSAGE(), LINENO(), SYS(16), PROGRAM(), SYS(2018) )
oStruct = oServiceManager.Bridge_GetStruct( cTypeName )
On ERROR &cOldErrHandler

If ISNULL( oStruct )
	=__OOoReleaseCachedVars()
	oServiceManager = OOoGetServiceManager()
	oStruct = oServiceManager.Bridge_GetStruct( cTypeName )
Endif

Return oStruct
Endfunc


* Return the OpenOffice.org desktop object.
* Cache it in a global variable.
* Create it if not already cached.
Function OOoGetDesktop()
If (TYPE([goOOoDesktop])!="O")  OR  ISNULL( goOOoDesktop )
	Public goOOoDesktop
	goOOoDesktop = OOoServiceManager_CreateInstance( "com.sun.star.frame.Desktop" )
	COMARRAY( goOOoDesktop, 10 )
Endif
Return goOOoDesktop
Endfunc


*!*	* Return an instance of com.sun.star.reflection.CoreReflection.
*!*	* Cache it in a global variable.
*!*	* Create it if not already cached.
*!*	FUNCTION OOoGetCoreReflection()
*!*		IF (TYPE([goOOoCoreReflection])!="O")  OR  ISNULL( goOOoCoreReflection )
*!*			PUBLIC goOOoCoreReflection
*!*			goOOoCoreReflection = OOoServiceManager_CreateInstance( "com.sun.star.reflection.CoreReflection" )
*!*			COMARRAY( goOOoCoreReflection, 10 )
*!*		ENDIF
*!*		RETURN goOOoCoreReflection
*!*	ENDFUNC


*!*	* Create a UNO struct object and return it.
*!*	* This routine is now obsolete.
*!*	* See a superior implementation of this routine elsewhere
*!*	*  which uses the Bridge_GetStruct() feature of the OLE-UNO bridge.
*!*	FUNCTION OOoCreateStruct( cTypeName )
*!*		* Ask service manager for a CoreReflection object.
*!*		LOCAL oCoreReflection
*!*		oCoreReflection = OOoGetCoreReflection()
*!*
*!*		* Get the IDL Class for the type name.
*!*		LOCAL oXIdlClass
*!*		oXIdlClass = .NULL.

*!*		LOCAL cOldErrHandler
*!*		cOldErrHandler = ON( "ERROR" )
*!*		ON ERROR = DoNothing__ErrorHandler( ERROR(), MESSAGE(), LINENO(), SYS(16), PROGRAM(), SYS(2018) )
*!*			oXIdlClass = oCoreReflection.forName( cTypeName )
*!*		ON ERROR &cOldErrHandler
*!*
*!*		IF ISNULL( oXIdlClass )
*!*			=__OOoReleaseCachedVars()
*!*			oCoreReflection = OOoGetCoreReflection()
*!*			oXIdlClass = oCoreReflection.forName( cTypeName )
*!*		ENDIF
*!*
*!*		* Create a variable to hold the created Struct.
*!*		* Assign it some initial value.
*!*		LOCAL oStruct
*!*		oStruct = CREATEOBJECT( "relation" ) && assign some kind of object initially

*!*		* Ask the class definition to create an instance.
*!*		oXIdlClass.CreateObject( @oStruct )
*!*
*!*		RETURN oStruct
*!*	ENDFUNC


* Create a com.sun.star.beans.PropertyValue struct and return it.
Function OOoPropertyValue( cName, uValue, nHandle, nState )
Local oPropertyValue
oPropertyValue = OOoCreateStruct( "com.sun.star.beans.PropertyValue" )

oPropertyValue.Name = cName
oPropertyValue.Value = uValue

If TYPE([nHandle])="N"
	oPropertyValue.Handle = nHandle
Endif
If TYPE([nState])="N"
	oPropertyValue.State = nState
Endif

Return oPropertyValue
Endfunc

* Open or Create a document from it's URL.
* New documents are created by URL's such as:
*	private:factory/sdraw
*	private:factory/swriter
*	private:factory/scalc
*	private:factory/simpress
Function OOoOpenURL( cURL )
*	LOCAL oPropertyValue
*	oPropertyValue = OOoCreateStruct( "com.sun.star.beans.PropertyValue" )

*	LOCAL ARRAY aNoArgs[1]
*	aNoArgs[1] = oPropertyValue
*	aNoArgs[1].Name = "ReadOnly"
*	aNoArgs[1].Value = .F.

* These two lines replace the alternate version above,
*  which are left commented for the insight they provide.
Local ARRAY aNoArgs[1]
aNoArgs[1] = OOoPropertyValue( "Hidden", .F. )

Local oDesktop
oDesktop = OOoGetDesktop()

Local oDoc
oDoc = oDesktop.LoadComponentFromUrl( cURL, "_blank", 0, @ aNoArgs )

* Make sure that arrays passed to this document are passed zero based.
COMARRAY( oDoc, 10 )

Return oDoc
Endfunc


Procedure __OOoReleaseCachedVars()
Release goOOoServiceManager, goOOoDesktop, goOOoCoreReflection
Endproc



*############################################################


* Experimental stuff



*SET PROCEDURE TO LibOOo ADDITIVE
*oDoc = OOoOpenFile( GetDesktopFolderPathname() + "test.sxw" )


* This is an attempt to print a document.
Procedure PrintExperiment( oDoc )
Local ARRAY aArgs[1]
aArgs[1] = OOoPropertyValue( "CopyCount", 1, -1, 0 )
*	aArgs[1] = OOoPropertyValue( "Collate", .F. )

oDoc.Print( @ aArgs )
Endproc


*############################################################


Procedure TestOOoDraw()
* Create a drawing.
Local oDoc
oDoc = OOoCreateNewDrawDocument()

* Get the first page of the drawing.
Local oPage
oPage = OOoGetDrawPage( oDoc, 0 )

Local nHue, nSaturation, nBrightness
Local nRow, nCol
Local oShape

* Now let's draw some rectangles.

*-----
*	Notes about HSV color notation.
* Imagine hue is a "rainbow" of colors, from 0.0 to 1.0.
* 0.0 is red, then you progress to orange, yellow, green, blue, purple, and
*  then back to red again.  (Not like a real rainbow.)  1.0 is red also.
* HSV colors are easy for HUMANS, while RGB colors are easy for COMPUTERS.
* Quick, what is the RGB for Pink?  Brown?
* In HSV, you would think Pink is a low-saturation red at full brightness,
*  thus you could say H=0.0, S=0.5, B=1.0; and that's off the top of my head.
* Brown is a low brightness Orange, so H=0.0888, S=1.0, B=0.6; right out of thin air.
* Need a highly contrasting color?  Easy in HSV coordinates.
* Just pick the opposite hue, maybe maximize saturation (opposite of other color),
*  and maybe also a min or max brightness.  Can't easily come up with highly
*  contrasting colors in RGB coordinates in RGB space.
* Need to "soften" colors?  Take each HSV coordinate, and lower the saturation
*  by 10 %.
* Need to "darken" colors?  Lower the brightness of each pixel by 10 %.
*-----

* Let's vary the hue and saturation, while keeping the brightness constant.
* But you could vary any two parameters, while keeping the third constant.

nBrightness = 1.0 && full brightness
For nRow = 0 TO 9
	For nCol = 0 TO 9
* Create a shape
		oShape = OOoMakeRectangleShape( oDoc )
* Calculate color
		nHue = nCol / 9 && hue varies *across* by column
		nSaturation = nRow / 9 && saturation varies *down* by row
* set color of shape
* oShape.FillColor = OOoRGB( 255, 255, 255 )
		oShape.FillColor = OOoHSV( nHue, nSaturation, nBrightness )
* Position and size the shape
		OOoSetSize( oShape, 500, 500 ) && 1/2 cm by 1/2 cm
		OOoSetPosition( oShape, 1000 + nCol * 600, 1000 + nRow * 600 )
* Add shape to page
		oPage.Add( oShape )
	Endfor
Endfor


* Let's vary the hue and saturation, while keeping the brightness constant.
* This time, we'll use less-brightness
* But you could vary any two parameters, while keeping the third constant.

nBrightness = 0.7 && less brightness
For nRow = 0 TO 9
	For nCol = 0 TO 9
* Create a shape
		oShape = OOoMakeRectangleShape( oDoc )
* Calculate color
		nHue = nCol / 9 && hue varies *across* by column
		nSaturation = nRow / 9 && saturation varies *down* by row
* set color of shape
		oShape.FillColor = OOoHSV( nHue, nSaturation, nBrightness )
* Position and size the shape
		OOoSetSize( oShape, 500, 500 ) && 1/2 cm by 1/2 cm
		OOoSetPosition( oShape, 9000 + nCol * 600, 1000 + nRow * 600 )
* Add shape to page
		oPage.Add( oShape )
	Endfor
Endfor


* Let's vary the hue and brightness, while keeping the saturation constant.
* But you could vary any two parameters, while keeping the third constant.

nSaturation = 1.0 && full saturation
For nRow = 0 TO 9
	For nCol = 0 TO 9
* Create a shape
		oShape = OOoMakeRectangleShape( oDoc )
* Calculate color
		nHue = nRow / 9 && hue varies *down* by row
		nBrightness = nCol / 9 && brightness varies *across* by column
* set color of shape
		oShape.FillColor = OOoHSV( nHue, nSaturation, nBrightness )
* Position and size the shape
		OOoSetSize( oShape, 500, 500 ) && 1/2 cm by 1/2 cm
		OOoSetPosition( oShape, 1000 + nCol * 600, 9000 + nRow * 600 )
* Add shape to page
		oPage.Add( oShape )
	Endfor
Endfor


* Let's vary the saturation and brightness, while keeping the hue constant.
* The hue will be yellow.
* But you could vary any two parameters, while keeping the third constant.

nHue = 0.1666 && yellow
For nRow = 0 TO 9
	For nCol = 0 TO 9
* Create a shape
		oShape = OOoMakeRectangleShape( oDoc )
* Calculate color
		nSaturation = nRow / 9 && saturation varies *down* by row
		nBrightness = nCol / 9 && brightness varies *across* by column
* set color of shape
		oShape.FillColor = OOoHSV( nHue, nSaturation, nBrightness )
* Position and size the shape
		OOoSetSize( oShape, 500, 500 ) && 1/2 cm by 1/2 cm
		OOoSetPosition( oShape, 9000 + nCol * 600, 9000 + nRow * 600 )
* Add shape to page
		oPage.Add( oShape )
	Endfor
Endfor


* Gee, you don't suppose someone out there could take the knowledge represented
*  by this code and figure out how to make OpenOffice.org draw bar charts?

Endproc


Procedure TestOOoCalc()
* Create a spreadsheet.
Local oDoc
oDoc = OOoCreateNewCalcDocument()

* Get first sheet
Local oSheet
oSheet = oDoc.getSheets().GetByIndex( 0 )

* Plug in some stuff...
oSheet.getCellByPosition( 0, 0 ).setFormula( "Month" )
oSheet.getCellByPosition( 1, 0 ).setFormula( "Sales" )
oSheet.getCellByPosition( 0, 1 ).setFormula( "Jan" )
oSheet.getCellByPosition( 0, 2 ).setFormula( "Feb" )
oSheet.getCellByPosition( 0, 3 ).setFormula( "Mar" )
oSheet.getCellByPosition( 0, 4 ).setFormula( "Apr" )
oSheet.getCellByPosition( 0, 5 ).setFormula( "May" )
oSheet.getCellByPosition( 0, 6 ).setFormula( "Jun" )
oSheet.getCellByPosition( 1, 1 ).setValue( 3826 )
oSheet.getCellByPosition( 1, 2 ).setValue( 3504 )
oSheet.getCellByPosition( 1, 3 ).setValue( 2961 )
oSheet.getCellByPosition( 1, 4 ).setValue( 2504 )
oSheet.getCellByPosition( 1, 5 ).setValue( 2102 )
oSheet.getCellByPosition( 1, 6 ).setValue( 1756 )

Local ARRAY aOneArg[1]
Local cFile, cURL

*	cFile = GetDesktopFolderPathname()+"example"
cFile = "c:\example"

* Now save the spreadsheet.
cURL = OOoConvertToURL( cFile + ".sxw" )
aOneArg[1] = OOoPropertyValue( "Overwrite", .T. )
oDoc.storeToUrl( cURL, @ aOneArg )

* Now save it as Excel
cURL = OOoConvertToURL( cFile + ".xls" )
aOneArg[1] = OOoPropertyValue( "FilterName", "MS Excel 97" )
oDoc.storeToUrl( cURL, @ aOneArg )
Endproc

Procedure CreateHueRainbow()
* Create a drawing.
Local oDoc
oDoc = OOoCreateNewDrawDocument()

* Get the first page of the drawing.
Local oPage
oPage = OOoGetDrawPage( oDoc, 0 )

Local nHue, nSaturation, nBrightness
Local nCol
Local oShape

* Now let's draw some rectangles.

* Let's vary the hue and saturation, while keeping the brightness constant.
* But you could vary any two parameters, while keeping the third constant.

nBrightness = 1.0 && full brightness
nSaturation = 1.0 && full saturation
For nCol = 0 TO 200
* Create a shape
	oShape = OOoMakeRectangleShape( oDoc )
* Calculate color
	nHue = nCol / 200 && hue varies *across* by column
* set color of shape
* oShape.FillColor = OOoRGB( 255, 255, 255 )
	oShape.FillColor = OOoHSV( nHue, nSaturation, nBrightness )
* Position and size the shape
	OOoSetSize( oShape, 52, 2000 ) && 0.05 cm by 2 cm
	OOoSetPosition( oShape, 1000 + nCol * 50, 1000 )
	oShape.LineStyle = 0
* Add shape to page
	oPage.Add( oShape )
Endfor

Local cFile, cURL
*	cFile = GetDesktopFolderPathname()+"hue rainbow"
cFile = "c:\hue rainbow"
cURL = OOoConvertToURL( cFile + ".sxd" )
Local ARRAY aOneArg[1]
aOneArg[1] = OOoPropertyValue( "Overwrite", .T. )
oDoc.storeAsURL( cURL, @ aOneArg )
*	oDoc.dispose()
Endproc


Function HSVHUE( nOOoColor )
Return nOOoColor
Endfunc

Function HSVSATURATION( nOOoColor )
Return nOOoColor
Endfunc

Function HSVVALUE( nOOoColor )
Return nOOoColor
Endfunc





