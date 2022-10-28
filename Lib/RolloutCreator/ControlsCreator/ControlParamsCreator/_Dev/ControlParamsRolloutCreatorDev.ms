clearListener()

try( destroyDialog test )catch()


rci = rolloutCreator "test" "Test Rollout"
rci.begin()


--rci.addControl #button #myButton "My Button"
rci.addControl #bitmap #bitmap_test "My Button" paramStr:"bitmap: (bitmap 50 50 color:blue)"


createDialog (rci.end())