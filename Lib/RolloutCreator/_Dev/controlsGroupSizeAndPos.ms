/* ISLANDS VIA VERTS */
clearListener(); print("Cleared in:\n"+getSourceFileName())


try( destroyDialog testRollout )catch()

rollout testRollout "Test"
(
  group "Test"
  (
    button btn_button "Press Me If You Can"  offset:[0,10] across:2
  )--end group
)--end rollout
createDialog testRollout width:200

testRollout.controls[1].pos.y  += 10
testRollout.controls[3].pos.y  -= 10

testRollout.controls[3].pos.x  -= 10

