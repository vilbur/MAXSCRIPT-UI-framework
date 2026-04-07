clearListener(); print("Cleared in: "+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../getHotkeysOfQuadMenus.ms" )	--"./../getHotkeysOfQuadMenus.ms"

filein( getFilenamePath(getSourceFileName()) + "/../../../MarkdownGenerator/MarkdownGenerator.ms" )	--"./../../../MarkdownGenerator/MarkdownGenerator.ms"

hotkeys_of_quad_menus = getHotkeysOfQuadMenus debug:true


hotkeys_list = for menu_name in sort hotkeys_of_quad_menus.keys collect
(
	hotkey = hotkeys_of_quad_menus[menu_name]
	
	clr = if matchPattern hotkey pattern:("*RMB*") then "lightgreen" else "#4da3ff"
	
	"<span style=\"color:"+clr+"\"><b>"+ hotkey +"</b></span>   " + menu_name
)

md_file_path = getDir #TEMP + "/md-generator-test.md"

--format "hotkeys_of_quad_menus.keys: %\n" (sort hotkeys_of_quad_menus.keys)
/*------------------------------------------------------------------------------
	RUN TEST
--------------------------------------------------------------------------------*/
MarkdownGenerator = MarkdownGenerator_v(md_file_path)

--MarkdownGenerator.generate hotkeys_of_quad_menus
MarkdownGenerator.generate ( Dictionary #( "Hotkeys - Quad menus ", hotkeys_list ))


/*------------------------------------------------------------------------------
	OUTPUT
--------------------------------------------------------------------------------*/

DOSCommand ("\""+md_file_path+"\"")

--DOSCommand ("notepad++ \""+md_file_path+"\"")