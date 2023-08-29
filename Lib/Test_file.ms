clearListener()



--dialogs_hwnd = UIAccessor.GetPopupDialogs()
actionMan.executeAction 0 "59245"  -- Customize User Interface: Hotkey Editor



if (hotkey_dialog = (for hwnd in UIAccessor.GetPopupDialogs() where UIAccessor.GetWindowText hwnd == "Hotkey Editor" collect hwnd)[1]) != undefined then
	UIAccessor.CloseDialog hotkey_dialog