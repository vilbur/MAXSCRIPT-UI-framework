/*
	CONVERT JSON <-> DICTIONARY()
	
*/ 
struct JsonToDictionoray_v
(
	/*
		==========================================
		JSON FILE
		==========================================
	*/ 
	/** Json file to dict
	 */
	function jsonFileToDict file_path =
	(
		format "\n"; print "JsonToDictionoray_v.jsonFileToDict()"
		format "file_path: %\n" file_path
		content = ""
		
		if (file = openFile file_path mode:"rt") != undefined then
		(
			while not eof file do
				content += ( readLine file + "\n")
		
			--format "content: %\n" content
			close file
		)
		
		--content --return
		this.jsonToDict content --return
	),
	
	/*
		==========================================
		DICTIONARY TO JSON STRING
		==========================================
	*/ 
    function dictToJson dict =
	(
        jsonStr = "{"
        dictKeys = dict.keys
        isFirst = true
        
        for k in dictKeys do (
            if not isFirst then jsonStr += ", "
            
            -- Escape backslashes and quotes for the key (just in case)
            cleanKey = substituteString (k as string) "\\" "\\\\"
            cleanKey = substituteString cleanKey "\"" "\\\""
            
            jsonStr += "\"" + cleanKey + "\": "
            
            val = dict[k]
            
            -- If it's a nested dictionary, recurse
            if classOf val == Dictionary then (
                jsonStr += dictToJson val
            ) else (
                -- Convert value to string and escape for JSON compatibility
                cleanVal = val as string
                cleanVal = substituteString cleanVal "\\" "\\\\"
                cleanVal = substituteString cleanVal "\"" "\\\""
                jsonStr += "\"" + cleanVal + "\""
            )
            isFirst = false
        )
        jsonStr += "}"
        return jsonStr
    ),
    
	/*
		==========================================
		JSON STRING TO DICTIONARY
		==========================================
	*/ 
    function jsonToDict jsonString =
	(
        -- Load the standard .NET assembly for JSON parsing
        dotnet.loadAssembly "System.Web.Extensions"
        serializer = dotnetobject "System.Web.Script.Serialization.JavaScriptSerializer"
        
        parsedDotNetObj
        try (
            parsedDotNetObj = serializer.DeserializeObject jsonString
        ) catch (
            format "Error parsing JSON: %\n" (getCurrentException())
            return Dictionary #string
        )
        
        -- Ensure the root is an object (Dictionary) and not an array or scalar
        if classOf parsedDotNetObj == dotNetObject and matchPattern ((parsedDotNetObj.GetType()).FullName) pattern:"*Dictionary*" then (
            return this.convertNetDictToMxs parsedDotNetObj
        ) else (
            print "Warning: JSON root must be an object. Returning empty dictionary."
            return Dictionary #string
        )
    ),

	/*
		Nested Helper: Recursively convert the .NET dictionary to an MXS Dictionary
	*/ 
	function convertNetDictToMxs netDict =
	(
		mxsDict = Dictionary #string
		keys = netDict.Keys
		enumerator = keys.GetEnumerator()
		
		while enumerator.MoveNext() do (
			k = enumerator.Current
			val = netDict.get_Item k
			
			-- If the value is another .NET Dictionary (Nested Object)
			if classOf val == dotNetObject and matchPattern ((val.GetType()).FullName) pattern:"*Dictionary*" then (
				mxsDict[k] = this.convertNetDictToMxs val
			) else (
				-- Convert scalar values to MaxScript strings
				mxsDict[k] = val as string
			)
		)
		return mxsDict
	),
	
	/** Get file content
	 */
	function getFileContent =
	(
		--format "\n"; print "JsonToDictionoray_v.getFileContent()"
		content = ""
		
		if (file = openFile file_path mode:"rt") != undefined then
		(
			while not eof file do
				content += ( readLine file + "\n")
		
			close file
		)
	),
	
	on create do
	(
		--print("RolloutEventBinder_v.onCreate()")
	)
)