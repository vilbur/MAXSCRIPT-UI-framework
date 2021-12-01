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
	_Controls.Default #height 2 type:#list -- type is mask and must match control type E.G.: match #listbox|#multilistbox|#dropdownlist if type==#list

	_Controls.Default #across 1 type:#multilistbox 
	_Controls.control #multilistbox ("THIS iS FULL WIDTH " + prefix as string  )
--	
	_Controls.Default #across 2 type:#listbox 
	_Controls.control #listbox ("THIS iS LEFT HALF " + prefix as string  )
	_Controls.control #listbox ("THIS iS RIGHT HALF " + prefix as string  )
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
	_Controls.Default #width 96 type:#button
	_Controls.Default #width 96 type:#label
		_Button1    = _Controls.control #button ( i as string +" of  "+ count as string) params:#(#across, across)
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
		_Control    = _Controls.control #button ( i as string + " of "+ count as string +" across "+ across as string ) params:#(#across, across)

		--_Control = _Controls.control #button ( count as string  + " " + i as string ) params:#(#across, across)
)



/*------------------------------------------------------------------------------
	RUN TESTS 
--------------------------------------------------------------------------------*/
/** make upside down pyramid of controls 
  */	
eachRowDifferenCountOfControls 10


/* Across works as columns

*/ 
for i = 1 to 8 do
	testBreakAcross(i)

/** TEST END OF OF GROUUP 
  *	
  */
testFakeControlsOnEndOfGroup(_Rollout.Controls group:"A") 2 4
testFakeControlsOnEndOfGroup(_Rollout.Controls group:"B") 3 5
testFakeControlsOnEndOfGroup(_Rollout.Controls group:"C") 7 5


/** Create dialog from _Rollout
  */
dialog_width = 420
dialog_height = 1920
include "Library/MAXSCRIPT-UI-framework/Lib/RolloutCreator/_Test/includes/CreateTestDialog.ms"