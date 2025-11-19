filein( getFilenamePath(getSourceFileName()) + "/../../XmlParser/XmlParser.ms" )	--"./../../XmlParser/XmlParser.ms"

/** Convert menu to rc menu
  
	PROBLEM: menuMan is not able to get action of menu item
  
	SOLUTION: *.mnux file contains action of items
		Save menus to file xml file and prase it back to menu
	
 */
struct MenuToRcLoader_v
(
	/* construct */
	MenuRc, --"./../RcMenu.ms"
	
	/* required */
	
	/* properties */
	
	
	/* private */
	/* dependency */
	/* reference */
	/* inhered */
	XmlParser,

	/** Load existing menu to Rightclick menu
	 */
	function loadMenu =
	(
		--format "\n================================================================================================\y\n"
		--format "\n"; print "RcMenu_v.loadMenu()"
		--format "MenuRc.name: %\n" MenuRc.name
		
		if ( _menu = menuMan.findMenu MenuRc.name) != undefined then
		(
			--format "this.name: %\n" this.name
			/* Path to *.mnux file */ 
			menus_xml_file = ((getDir #temp)+"\\XmlParser-Test.mnux")
			--format "menus_xml_file:\n%\n" menus_xml_file
	
			/* SAVE MENUS TO FILE */ 
			menuMan.saveMenuFile menus_xml_file
			
			/* LOAD FILE TO PARSER */ 
			this.XmlParser = XmlParser_v(menus_xml_file)
			
			/* ADD MENU ITEMS */ 
			this.addMenuXML MenuRc.name MenuRc
			
			/* ADD SUFFIX TO PREVENT ERROR - RC menu must has different name then classic menu */ 
			MenuRc.name += "Rc"
		
			/* CLEANUP */ 
			deleteFile menus_xml_file
		)
		
		--format "\n******\n"
	),
	
	/** Add menu
	 */
	function addMenuXML menu_name &_MenuRc =
	(
		--format "\n"; print "RcMenu_v.addMenuXML()"
		--format "menu_name: %\n" menu_name
		
		/* LOAD Menu from xml */ 
		menu_xml = this.XmlParser.getElement "Menu" attr:"title" val:menu_name
		
		
		if menu_xml != undefined then
		(
			menu_items = this.XmlParser.getChildren menu_xml
			--format "menu_items.count: %\n" menu_items.count
			/* ITEM OR SUBMENU */ 
			for item in menu_items do
			(
				--format "\n------------------------\n"
				mode_name = this.XmlParser.getAttribute item "modeName"
				--format "mode_name: %\n" mode_name
				
				/* ADD ITEM OR SUBMENU */ 
				if mode_name != "AM_SEPARATOR" then
				(
					/* TITLE OF ITEM */ 
					customTitle = this.XmlParser.getAttribute item "customTitle"
					--format "customTitle: %\n" customTitle
					
					/* GET ACTION OF ITEM */ 
					actionID = this.XmlParser.getAttribute item "actionID"
					--format "actionID: %\n" actionID
					
					/* SPLIT ACTION to get maxscript name and category */ 
					if actionID != undefined then
						macro_name_and_category	= filterString actionID "`"
					--format "macro_name_and_category: %\n" macro_name_and_category
					
					/* USE CUSTOM TITLE OR MAXSCRIPT NAME */ 
					title = if  customTitle != undefined then customTitle else macro_name_and_category[1]
					--format "title: %\n" title
					/*------------------------------------------------------------------------------
						ADD ITEM OR SUBMENU
					--------------------------------------------------------------------------------*/
					case mode_name of
					(
						"AM_ITEM":	_MenuRc.item title ("macros.run \""+macro_name_and_category[2]+"\" \""+macro_name_and_category[1]+"\"" )
					
						"AM_SUBMENU": _MenuRc.menu title -- submenu is loaded on create of "./../RcMenu.ms"
					)
					
				)
				/*------------------------------------------------------------------------------
					ADD SEPARATOR
				--------------------------------------------------------------------------------*/
				else
					_MenuRc.separator()
				
			)
		)
		else
			FORMAT "\nWARNING: RcMenu_v.addMenuXML() -> MENU DOES NOT EXISTS: RcMenu_v: \"%\"\n" menu_name
		
		
		_MenuRc --return
	),
	
	
	private
	

	/**
	 */
	on create do
	(
		--format "\n"; print "MenuToRcLoader.onCreate()"
		this.loadMenu()
	)
)
