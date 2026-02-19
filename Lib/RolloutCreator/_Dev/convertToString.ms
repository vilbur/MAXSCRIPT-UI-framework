clearListener(); print("Cleared in:\n"+getSourceFileName())

--hwnd = (for child in ( windows.getChildrenHWND 0) where child[5] == "Window Tilte" collect child[1])[1]


fn convertToString val =
(
	local val_string = val as string
	
	if classOf val == String  then
	(
		val_string = substituteString val_string "\\" "\\\\"
		val_string = substituteString val_string "\"" "\\\""
		val_string = "\"" + val_string + "\""
	)
	else
		val_string = substituteString val_string "\"" "\\\""
	
	return val_string
)

-- Define some complex test data
myStr   = "Line 1\n\"Line 2\"" -- String with newlines and quotes
myArray = #("Item A", "Item \"B\"", 100) -- Array with strings and quotes
myColor = (color 255 128 0)
myPoint = [10, 20, 30]


convertToString myStr
convertToString myArray
convertToString myColor
convertToString myPoint

