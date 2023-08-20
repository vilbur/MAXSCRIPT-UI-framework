clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../../RolloutCreator.ms" )


/** Create variables:
  *		_RolloutCreator
  *		_Rollout
  *		_Controls
  */
include "MAXSCRIPT-UI-framework/Lib/RolloutCreator/_Test/includes/CreateTestRollout.ms"
filein( getFilenamePath(getSourceFileName()) + "/../../../../Ini/Ini.ms" )

/** SETUP OF TEST
  *	
  */
EventTypes	= EventTypes_v()

_RolloutCreator.ControlsCreator = ControlCreator_v _Rollout:_Rollout Ini:(Ini_v())

_RolloutCreator.ControlsCreator.EventBinder.events_params	= EventTypes.getParamsOfEvents	(#checkbox)
_RolloutCreator.ControlsCreator.EventBinder.event_types	= EventTypes.getEventTypesOfControl	(#checkbox)

EventBinder    = _RolloutCreator.ControlsCreator.EventBinder


/*
	CREATE CONTROLS
*/ 
--_Control = Control_v type:#checkbox caption:"Test"
_Control = Control_v type:#spinner caption:"Test"

_Control.Events.add #changed 	"callbackwithValues(inSpin)"	-- result: callbackwithValues(inSpin)
_Control.Events.add #entered 	"callbackwithValues"	-- result: callbackwithValues (inSpin) (inCancel)
_Control.Events.add #buttonup 	"macros.run \"fooCategory\" \"fooScript\""	-- result: macros.run "fooCategory" "fooScript"
_Control.Events.add #buttondown	"callbackNoValue"	-- result: callbackNoValue()



/** TESTED METHODS
  */
--EventBinder._validateEvents() -- private method
--EventBinder._setEventsParamters() -- private method
EventBinder.combineEvents(_Control) -- private method


/**   OUTPUT
  *	
  */
for Event in _Control.Events.List do
(
	format "\n\nTEST RESULT:"
	format "\nEvent.type   = %" Event.type
	format "\nEvent.params = %" Event.params
	format "\nEvent.code   = %" Event.code
	
)