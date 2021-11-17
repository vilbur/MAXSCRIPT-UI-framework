clearListener()


rci = rolloutCreator "myRollout" "My Rollout"
rci.begin()

rci.addText "group @Group 1@(" filter:on

rci.addControl #button #myButton "My Button"

rci.addText ")" filter:on


createDialog (rci.end())
