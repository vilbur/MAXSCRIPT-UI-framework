
/*------------------------------------------------------------------------------
	
	SAVE SELECTION TO VARIABLE
	
	GLOBAL_SELECTION_LAST is used ACROSS MULTIPLE SCRIPTS
	
--------------------------------------------------------------------------------*/


global GLOBAL_SELECTION_LAST_ENABLED = true
global GLOBAL_SELECTION_LAST
global GLOBAL_SELECTION_LAST_BUFFER


/** Set last selected objects to variable
 */
function setSelectionLast =
(
	--format "\n"; print "setSelectionLast()"

	if GLOBAL_SELECTION_LAST_ENABLED then
	(
		--print "setSelectionLast()"
		GLOBAL_SELECTION_LAST = GLOBAL_SELECTION_LAST_BUFFER

		if( selection.count > 0 ) then
			GLOBAL_SELECTION_LAST_BUFFER = for o in selection collect o

		--format "GLOBAL_SELECTION_LAST = % \n" GLOBAL_SELECTION_LAST
	)
)