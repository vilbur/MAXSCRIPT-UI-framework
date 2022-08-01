clearListener()


filein( getFilenamePath(getSourceFileName()) + "/../../../RolloutCreator.ms" )

/** Create variables:
  *		_RolloutCreator
  *		_Rollout
  *		_Controls
  */
include "Library/MAXSCRIPT-UI-framework/Lib/RolloutCreator/_Test/includes/CreateTestRollout.ms" -- "../../../_Test/includes/CreateTestRollout.ms"

/** Multilistbox
 */
function Cratemultilistbox prefix =
(
	
	_Controls.Default #height 2 type:#list -- type is mask and must match control type E.G.: match #listbox|#multilistbox|#dropdownlist if type==#list
	_Controls.Default #across 3 type:#list  -- match dropdownlist|listbox|multilistbox
	--_Controls.Default #across 3 type:#dropdownlist 
	_Controls.Default #across 2 type:#listbox 
	_Controls.Default #across 1 type:#multilistbox 


	_Controls.control #dropdownlist ("FULL WIDTH " + prefix as string  ) params:#(#across, 1)

	_Controls.control #listbox ("THIS iS HALF " + prefix as string  )

	_Controls.control #multilistbox ("THIS iS FULL WIDTH " + prefix as string  )
	
	_Controls.control #dropdownlist ("THIRD " + prefix as string  )
	_Controls.control #listbox ("THIS iS HALF TOO " + prefix as string  )
)
 

/** Controls without fakes
 *  make upside down pyramid of controls 
 */
function eachRowDifferenCountOfControls count prefix:"" across:4 =
(
	_Controls.Default #border true 

	--across = 4

	for i = 1 to count do 
	(
		if( i > 4  ) then across = 3
		if( i > 7  ) then across = 2
		if( i > 9  ) then across = 1
		
		_Controls.Default #width 96 type:#button
		_Button1    = _Controls.control #button ( prefix + i as string +" of  "+ count as string + " across:" +across as string) params:#(#across, across)
		-- _Button1    = _Controls.control #button ( prefix + i as string +" of  "+ count as string) params:#(#across, across)
		--_Button1    = _Controls.control #button ( prefix + i as string ) params:#(#across, across)
	)
)


/** Add controls
 */
function testFakeControlsOnEndOfGroup _Controls count across =
(
	for i = 1 to count do
		-- _Controls.control #button ( i as string + " of "+ count as string +" across:"+ across as string ) params:#(#across, across)
		_Controls.control #button ( "_" + i as string + " of "+ count as string +" across:"+ across as string ) params:#(#across, across)
)



/*------------------------------------------------------------------------------
	TESTS DEFINITION
--------------------------------------------------------------------------------*/
/** CreateOnlyButtons
 */
function onlyButtons count prefix:"" across:4 =
(
	eachRowDifferenCountOfControls count prefix:prefix across:across
)


/** Test break across if next control has different across
  *
  * REASON:	Across parameter ignores new value unless it completes his row
  * WHAT IS DONE:	Fake controls are generated to complete and fill row of previous across
  *
  * BENEFITS: This allows has for example #listbox control width:
 */
function myltipleListboxes count =
(
	for i = 2 to count+1 do
		Cratemultilistbox(i)
)

/** Create controls goups
 */
function createControlsGoups _groups =
(
	for i = 1 to _groups do
		testFakeControlsOnEndOfGroup(_Rollout.Controls group:("Group of "+(i+1) as string )  ) (i+2) (i+1)
)

/** Create controls goups
 */
function createControlsGoupsWithAcross _groups =
(
	for i = 1 to _groups do
		testFakeControlsOnEndOfGroup(_Rollout.Controls group:("Across Group of "+(i+1) as string )  ) (i+2) (i+1)
		
		Groupbox = _Rollout.Controls group:"Across"
		
		Groupbox.control #button "groupbox test"params:#(#across, 2)
)

/** Createsubrollouts
 */
function subrolloutsControls =
(
	--format "_Rollout	= % \n" _Rollout
	Subrollouts_1 = _Rollout.Subrollouts()
	
	Subrollout_1 = Subrollouts_1.Roll "Subrollout1"
	
	_Controls = Subrollout_1.controls group:"Subrollouts test"
	
	for i = 1 to 1 do 
		_Button1    = _Controls.control #button ( "Subrollouts "+ i as string) --params:#(#across, across)
)


/** Bug with first control
 */
function firstControlSingleInRow =
(
	--format "\n"; print ".firstControlSingleInRow()"
	_Controls = _Rollout.Controls group:"Label and full widthr control bellow"

	
	_Controls.control #label "Label in 1st row" align:#left across:4
	--_Controls.control #label "Label in 1st row" align:#left across:1 
	--_Controls.control #label "Label in 1st row" align:#left across:1 
	
	_Controls.control #Edittext "Edit Text" across:1
	--_Controls.control #Edittext "Edittext"


)





/*------------------------------------------------------------------------------
	RUN TESTS 
--------------------------------------------------------------------------------*/

onlyButtons(5) prefix:"A"
-- onlyButtons(3) prefix:"B" across:2
-- onlyButtons(5) prefix:"C" across:3
-- onlyButtons(10) prefix:"D"

--myltipleListboxes(1)
--myltipleListboxes(1)


groups_count = 3
-- groups_count = 1
createControlsGoups(groups_count)

--createControlsGoupsWithAcross(2)
 

-- firstControlSingleInRow()

--subrolloutsControls()






/*------------------------------------------------------------------------------
	CREATE DIALOG
--------------------------------------------------------------------------------*/
dialog_width = 420
dialog_height = 1600
--dialog_height = 1024
include "Library/MAXSCRIPT-UI-framework/Lib/RolloutCreator/_Test/includes/CreateTestDialog.ms"