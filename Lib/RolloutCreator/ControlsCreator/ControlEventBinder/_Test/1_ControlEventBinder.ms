clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../../RolloutCreator.ms" )


/** Create variables:
  *		_RolloutCreator
  *		_Rollout
  *		_Controls
  */
include "Library/MAXSCRIPT-UI-framework/Lib/RolloutCreator/_Test/includes/CreateTestRollout.ms"

EventTypes	= EventTypes_v()

_RolloutCreator.ControlsCreator = ControlCreator_v _Rollout:_Rollout 


_RolloutCreator.ControlsCreator.EventBinder.events_params	= EventTypes.getParamsOfEvents	(#checkbox)
_RolloutCreator.ControlsCreator.EventBinder.event_types	= EventTypes.getEventTypesOfControl	(#checkbox)

EventsCombiner = _RolloutCreator.ControlsCreator.EventBinder.EventsCombiner

format "EventsCombiner	= % \n" EventsCombiner


/* CREATE CONTROL */ 
_Control = Control_v type:#checkbox caption:"Test"
_Control.Events.add #changed 	"callbackwithValue"
_Control.Events.add #rightClick	"callbackNoValue"


_RolloutCreator.ControlsCreator.EventBinder._Control = _Control
_RolloutCreator.ControlsCreator.EventBinder._validateEvents()


/* CREATE CONTROL */ 
_RolloutCreator.ControlsCreator.EventBinder._setCallbackParamters()

format "_Control.Events	= % \n" _Control.Events


/**   
  *	
  */
for Event in _Control.Events.List do 
	format "Event	= % \n" Event.code