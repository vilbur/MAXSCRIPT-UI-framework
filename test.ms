clearListener(); print("Cleared in:\n"+getSourceFileName())

--hwnd = (for child in ( windows.getChildrenHWND 0) where child[5] == "Window Tilte" collect child[1])[1]

for child in ( windows.getChildrenHWND 0 parent:#max ) do
format "child[5]: %\n" child[5]

--format "hwnd: %\n" hwnd
--
--if hwnd == undefined then
--(
--	actionMan.executeAction 0 "40024"  -- Snaps: Grid and Snap Settings Toggle
--	
--	hwnd = (for child in ( windows.getChildrenHWND #max) where child[5] == "Grid and Snap Settings" collect child[1])[1]
--)
--
--	--children = windows.getChildrenHWND #max
--	for child in ( windows.getChildrenHWND hwnd ) do
--		format "child: %\n" child

	--format "children: %\n" children
	
