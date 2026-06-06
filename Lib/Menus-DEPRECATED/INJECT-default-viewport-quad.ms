clearListener(); print("Cleared in: "+getSourceFileName())


macroScript QviTestBox
category:"_QVI_TEST_CATEGORY"
toolTip:"QVI Test Box"
(
	on execute do
	(
		box name:"QVI_Test_Box"
	)
)

macroScript QviTestSphere
category:"_QVI_TEST_CATEGORY"
toolTip:"QVI Test Sphere"
(
	on execute do
	(
		sphere name:"QVI_Test_Sphere"
	)
)

global QuadViewportInjector_v
global quadViewportInjector

struct QuadViewportInjector_v
(
	viewport_context_id = "ac7c70f8-3f86-4ff5-a510-e4fd6a9c368e",
	action_table_id = 647394,

	/**
	Build macro action id string.
	Format is macroName`categoryName.
	*/
	function makeActionId macro_name category_name =
	(
		((macro_name as string) + "`" + (category_name as string)) -- return
	),

	/**
	Create macro action in menu.
	Uses stable action GUID to avoid duplicated menu transformations.
	*/
	function createMacroAction menu_value action_guid macro_name category_name title: =
	(
		action_id_string = makeActionId macro_name category_name

		if title == unsupplied then
		(
			menu_value.CreateAction action_guid action_table_id action_id_string
		)
		else
		(
			menu_value.CreateAction action_guid action_table_id action_id_string title:title
		)
	),

	/**
	Create separator in menu.
	Uses stable separator GUID to avoid duplicated menu transformations.
	*/
	function createMenuSeparator menu_value separator_guid =
	(
		menu_value.CreateSeparator separator_guid -- return
	),

	/**
	Inject custom items into default viewport RMB quad.
	This must run from #cuiRegisterQuadMenus callback.
	*/
	function injectToDefaultViewportQuad =
	(
		quad_menu_mgr = callbacks.notificationParam()

		if quad_menu_mgr == undefined then
		(
			format "QuadViewportInjector: quad_menu_mgr is undefined.\n"
			false -- return
		)
		else
		(
			viewport_context = quad_menu_mgr.GetContextById viewport_context_id

			if viewport_context == undefined then
			(
				format "QuadViewportInjector: viewport context not found.\n"
				false -- return
			)
			else
			(
				default_quad = viewport_context.GetRightClickMenuByModifiers #nonePressed

				if default_quad == undefined then
				(
					format "QuadViewportInjector: default viewport quad not found.\n"
					false -- return
				)
				else
				(
					top_right_menu = default_quad.GetMenuByPos #TopRight
					bottom_right_menu = default_quad.GetMenuByPos #BottomRight

					if top_right_menu != undefined then
					(
						createMenuSeparator top_right_menu "109e707e-1d54-4cc6-baf7-4f266e920111"
						createMacroAction top_right_menu "6c1a19d8-3060-4815-9cd1-56e4ff7d0111" "QviTestBox" "_QVI_TEST_CATEGORY" title:"QVI Test Box"
						createMacroAction top_right_menu "af9ced44-d79b-4907-b4a4-55aaab440111" "QviTestSphere" "_QVI_TEST_CATEGORY" title:"QVI Test Sphere"
					)

					if bottom_right_menu != undefined then
					(
						createMenuSeparator bottom_right_menu "be6c3f3e-9f91-419f-9219-7c52727f0222"
						createMacroAction bottom_right_menu "bf2af086-8d89-4468-b7d5-d9e4d5ef0222" "QviTestBox" "_QVI_TEST_CATEGORY" title:"QVI Bottom Box"
					)

					format "QuadViewportInjector: injected into default viewport quad.\n"
					true -- return
				)
			)
		)
	),

	/**
	Register quad menu injection callback.
	Put this file into scripts\\Startup and restart 3ds Max.
	*/
	function registerCallback =
	(
		callbacks.removeScripts id:#quadViewportInjector
		callbacks.addScript #cuiRegisterQuadMenus "quadViewportInjector.injectToDefaultViewportQuad()" id:#quadViewportInjector

		format "QuadViewportInjector: callback registered. Restart 3ds Max if quad was already built.\n"
		true -- return
	),

	on create do
	(
	)
)

quadViewportInjector = QuadViewportInjector_v()
quadViewportInjector.registerCallback()