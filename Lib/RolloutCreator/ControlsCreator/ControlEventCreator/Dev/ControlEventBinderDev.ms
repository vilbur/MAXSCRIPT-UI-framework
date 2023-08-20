clearListener(); print("Cleared in:"+getSourceFileName())


/** Button test
 */
function CallbackNoParam = print "CallbackNoParam"


/** on value changed
 */
function CallbackWithValue val = format "CallbackWithValue: % \n" val

/** on value changed
 */
function CallbackWith2Params arg_1 arg_2 = format "arg_1: % \narg_2: % \n" arg_1 arg_2



rci = rolloutCreator "myRollout" "My Rollout"
rci.begin()



rci.addControl #button #myButton "My Button"
--rci.addHandler #myButton #pressed filter:on codeStr:"CallbackNoParam()"
rci.addHandler #myButton #pressed filter:on codeStr:"CallbackWithValue(@PRAM VALUE@)"  --paramStr:"val"



rci.addControl #checkbox #myCheckbox "My Checkbox"
rci.addHandler #myCheckbox #changed codeStr:"print val" paramStr:"val"


rci.addControl #spinner #mySpinner "My Spinner"

--rci.addHandler #mySpinner #changed codeStr:"CallbackWith2Params(@VALUE A@)(@VALUE B@)"
rci.addHandler #mySpinner #changed codeStr:"CallbackWith2Params(val)(inspin)" paramStr:"val inspin"

rci.addHandler #mySpinner #changed codeStr:"print val" paramStr:"val inspin"


createDialog (rci.end())








