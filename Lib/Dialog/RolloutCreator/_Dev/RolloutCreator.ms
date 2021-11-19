clearListener()


rci = rolloutCreator "myRollout" "My Rollout"
rci.begin()


/* Group 1 */ 
rci.addText "group @Group 1@(" filter:on

rci.addControl #button #button_1 "Button 1"

rci.addText ")" filter:on



/* Group 2 */ 
rci.addText "group @Group 2@(" filter:on

rci.addControl #button #button_2 "Button 2"

rci.addText ")" filter:on


createDialog (rci.end())
