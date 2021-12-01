clearListener()


filein( getFilenamePath(getSourceFileName()) + "/../../../RolloutCreator.ms" )

/** Create variables:
  *		_RolloutCreator
  *		_Rollout
  *		_Controls
  */
include "Library/MAXSCRIPT-UI-framework/Lib/RolloutCreator/_Test/includes/CreateTestRollout.ms"

/** Multilistbox
 */
function Cratemultilistbox prefix =
(
	_Controls.Default #across 1 type:#multilistbox 
	_Controls.Default #height 3 type:#multilistbox 
	
	_Controls.control #multilistbox ("multilistbox" + prefix as string  )
)


/** Controls without fakes
 */
function eachRowDifferenCountOfControls count =
(
	across = 4

	for i = 1 to count do
	(
		if( i > 4  ) then across = 3
		if( i > 7  ) then across = 2
		if( i > 9  ) then across = 1
		
		_Button1    = _Controls.control #button ( "Button "+ count as string + i as string ) params:#(#across, across)
	)
)


/** Test break across if next control has different across
  *
  * REASON:	Across parameter ignores new value unless it completes his row
  * WHAT IS DONE:	Fake controls are generated to complete and fill row of previous across
  *
  * BENEFITS: This allows has for example #listbox control width:
 */
function testBreakAcross count =
(
	eachRowDifferenCountOfControls count
	
	Cratemultilistbox(count)
)


/** Add controls
 */
function testFakeControlsOnEndOfGroup _Controls count across =
(
	for i = 1 to count do
		_Control = _Controls.control #button ( count as string  + " " + i as string ) params:#(#across, across)
)



/*------------------------------------------------------------------------------
	RUN TESTS 
--------------------------------------------------------------------------------*/
/** make upside down pyramid of controls 
  */	
eachRowDifferenCountOfControls 10


for i = 1 to 7 do
	testBreakAcross(i)




testFakeControlsOnEndOfGroup(_Rollout.Controls group:"A") 6 4
testFakeControlsOnEndOfGroup(_Rollout.Controls group:"B") 3 5
testFakeControlsOnEndOfGroup(_Rollout.Controls group:"B") 7 5


/** Create dialog from _Rollout
  */
dialog_width = 384
dialog_height = 1920
include "Library/MAXSCRIPT-UI-framework/Lib/RolloutCreator/_Test/includes/CreateTestDialog.ms"