clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../ControlParamsParser.ms" )


global params_input = #(
	"undefined: undefined",
	"unsupplied: unsupplied",
	"#event: #rightclick",
	"#width:128 ",
	"float : 1.23",
    " border:true",
    " point2:[1,2]",
    " point3:[1,2,3.0]",
	"items: #('item1', 2, 3.0, true )",
	"color: color 128 128 128",
	"string: Select objects"
)

global datatypes = #(
	undefined,
	unsupplied,
	#name,
	1,
	1.0,
	true,
    [1,2],
    [1,2,3],
	#("A",1),
	color 128 128 128,
	"string"
)

/** Join array
 */
function joinArray =
(
	--format "\n"; print ".joinArray()"
	params_string = ""

	for param in params_input do params_string += param + "|"

	trimRight params_string "|"
)



/** RUN TEST
  *
  */

ControlParamsParser = ControlParamsParser_v()

params_output = ControlParamsParser.parse ( joinArray() ) "foo_macro"


for i = 1 to params_output[1].count do
(
	print ("INPUT: " + params_input[i])

	format "param: %\n" params_output[1][i]
	format "value: %\n" params_output[2][i]
	format "class: %\n" (classOf params_output[2][i])

	if classOf params_output[2][i] != classOf datatypes[i]  then
		print "!!! TEST FALSE !!!"

	format "\n"
)