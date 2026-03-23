clearListener(); print("Cleared in: "+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../JsonToDictionoray.ms" )	--"./../JsonToDictionoray.ms"

test_json = ( getFilenamePath(getSourceFileName()) + "test.json" )	--"./test.json"

-- 1. Initialize the struct
jsonConverter = JsonToDictionoray_v()

-- ==========================================
-- TEST A: JSON String -> MaxScript Dictionary
-- ==========================================
rawJson = "{\"userName\": \"ArtStationUser\", \"renderSettings\": {\"engine\": \"V-Ray\", \"paths\": {\"output\": \"C:\\\\Renders\\\\Final\"}}}"

format "--- [TEST A] Original JSON ---\n%\n\n" rawJson

myMxsDict = jsonConverter.jsonToDict rawJson

format "--- [TEST A] Converted to MXS Dictionary ---\n"
format "User Name: %\n" myMxsDict["userName"]
format "Render Engine: %\n" myMxsDict["renderSettings"]["engine"]
format "Output Path: %\n\n" myMxsDict["renderSettings"]["paths"]["output"]


-- ==========================================
-- TEST B: MaxScript Dictionary -> JSON String
-- ==========================================
newDict = Dictionary #string
newDict["project"] = "Cyberpunk City"

-- Create a nested dictionary
configDict = Dictionary #string
configDict["resolution"] = "1920x1080"
configDict["fps"] = "60" -- Storing as string based on your requirements

-- Attach nested dict to main dict
newDict["config"] = configDict

format "--- [TEST B] MaxScript Dictionary to JSON ---\n"
generatedJson = jsonConverter.dictToJson newDict
format "%\n\n" generatedJson


/*
	==========================================


	TEST C: JSON FILE -> MaxScript Dictionary

	==========================================
*/ 
json_dictionary_file = jsonConverter.jsonFileToDict test_json
format "json_dictionary_file: %\n" json_dictionary_file
