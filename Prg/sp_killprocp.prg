local awin_apps, vfp_handle, ln_current_window,ln_window_count,ln_hay
dimension awin_apps[1]
ln_hay = .f.
vfp_handle=0
* Declare API Functions
declare integer FindWindow in win32api integer nullpointer, string cwindow_name
declare integer GetWindow  in win32api integer ncurr_window_handle, integer ndirection
declare integer GetWindowText in win32api integer n_win_handle, string @ cwindow_title, ;
	integer ntitle_length

* Get handle for current application
vfp_handle=findwindow(0,_screen.caption)
ln_current_window=vfp_handle
ln_window_count=0
do while ln_current_window>0
	lc_window_title=space(255)
	ln_length=getwindowtext(ln_current_window, ;
		@lc_window_title,len(lc_window_title))
	if ln_length>0
		lc_window_title=strtran(trim(lc_window_title),chr(0),"")
	else
		lc_window_title=""
	endif
	if ln_current_window>0 .and. !empty(lc_window_title) ;
		and (at(upper("Microsoft Internet Explorer"),upper(lc_window_title)) > 0 or at("EXPLORE",upper(lc_window_title))>0) 
		ln_window_count=ln_window_count+1
		dimension awin_apps(ln_window_count)
		ln_hay = .t.
		awin_apps[ln_Window_Count]=lc_window_title
	endif
	ln_current_window=getwindow(ln_current_window,2)
enddo
nwindows = alen(awin_apps) 
if nwindows >0 and ln_hay
	for i= 1 to nwindows 
		messagebox ("Cerrando "+awin_apps(i))
		do sp_killproc with "Microsoft Internet Explorer"
	next i
	wait clear
endif

