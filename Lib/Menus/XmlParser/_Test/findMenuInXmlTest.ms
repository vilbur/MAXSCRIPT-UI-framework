clearListener(); print("Cleared in:\n"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../XmlParser.ms" )	--"./../XmlParser.ms"


menus_xml_file = ((getDir #temp)+"\\XmlParser-Test.mnux")

menuMan.saveMenuFile menus_xml_file

XmlParser = XmlParser_v(menus_xml_file)



/* GET ALL MENUS */ 
menus_all = XmlParser.getElements "Menu"
format "\nmenus_all.count: %\n" menus_all.count



/* GET ALL MENUS MATCHING "Help*" */ 
menus_mathcing_help = XmlParser.getElements "Menu" attr:"title" val:"Help*"
format "\nmenus_mathcing_help.count: %\n" menus_mathcing_help.count



/* GET ATTRIBUTE OF EACH ELEMENT */ 
for i = 1 to menus_mathcing_help.count do
(
	title = XmlParser.getAttribute menus_mathcing_help[i] "title"
	format "%: %\n" i title
)




/* GET SIGNLE ELEMENT BY ATTRIBUTE */ 
--menu_helpers = XmlParser.getElement "Menu" attr:"title" val:"Helpers"
menu_helpers = XmlParser.getElement "Menu" attr:"title" val:"Main Menu Bar"
format "menu_helpers: %\n" menu_helpers




/* GET CHILD ELEMENT */ 
menu_items = XmlParser.getChildren menu_helpers

for i = 1 to menu_items.count do
(
	modeName = XmlParser.getAttribute menu_items[i] "modeName"
	
	format "%: %\n" i modeName
)
