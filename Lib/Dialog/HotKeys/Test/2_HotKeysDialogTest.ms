clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../Dialog.ms" )

--global TEST_VAR = "VALUE-X"

/** Test callback
 */
function testCallback =
(
	format "\n"; print ".testCallback()"
	--format "val	= % \n" val
	--format "classOf val	= % \n" (classOf val)
)

Dialog 	= Dialog_v "Test Dialog"

Dialog.HotKey #(#ctrl, #space) "testCallback()"
--Dialog.HotKey #(#ctrl) "testCallback()"

Dialog.create()

--format "test_dialog.TEST_VAR	= % \n" test_dialog.TEST_VAR


--_string = ""
--
----substituteString "string" "from_string" "to_string"
--
--
--
--rci = rolloutCreator "test" "Test"
---- Start creating the rollout
--rci.begin()
--
----rci.addLocal "TEST_VAR" init:"\"My Button\""
----rci.addLocal "TEST_VAR" init:"\"print \\\"TEST VALUE\\\"\""
----rci.addLocal "TEST_VAR" init:"\"print \\\"TEST VALUE\\\"\""
----rci.addLocal "TEST_VAR" init:"@My Button@" filter:on 
--
--
--rci.end()
--
--CreateDialog rci.def
--
----execute ( test.TEST_VAR )
--
----format "test.TEST_VAR	= % \n" test.TEST_VAR
