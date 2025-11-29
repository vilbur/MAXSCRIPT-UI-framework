# Events default for rollout\dialog  


## HOW RESIZE AND DOCK EVENTS WORKS  

Maxscript fires #RESIZED event when dialog is RESIZED OR DOCKED \ UNDOCKED  


1) Call waitForResizeEndTimer() #RESIZE event --"./waitForResizeEndTimer.ms"  

2) Start timer and wait then user stop resizing rollout --"./Callbacks/fitSubrolloutSlotToRolloutCallback.ms"  

3) Call correct rollout event #RESIZE | #DOCKED | #UNDOCKED  