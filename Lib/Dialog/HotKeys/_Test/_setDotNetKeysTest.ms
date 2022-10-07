clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../HotKeys.ms" )
--HotKeys 	= HotKeys_v()


--translated_keys = (HotKeys_v())._simplifyModifierKeys #(#ControlKey, #LControlKey)
--translated_keys = (HotKeys_v())._simplifyModifierKeys #(#ControlKey, #LControlKey, #Q)
translated_keys = (HotKeys_v())._simplifyModifierKeys #(#ControlKey, #LControlKey, #Alt, #Q)

format "translated_keys	= % \n" translated_keys



