/*
 */
struct MacroscriptGenerator_v
(
    /* construct */
    ini_file,

    /* properties */
    mcr_file,

    --macroscripts= Dictionary(),
    macroscripts= #(),

    general_params= Dictionary(),

    keys_params = #( #category, #buttontext, #toolTip, #icon ),
    keys_filter = #( #IsVisible, #IsChecked, #isEnabled, #isIndeterminate ),
    keys_code   = #( #execute, #AltExecute ),

    /* dependency */
    /* reference */
    /* inhered */

    /** /** Generate macroscript file
    *
    */
    function generateMacroscriptFile =
    (
        --format "\n"; print "MacroscriptGenerator_v.generateMacroscriptFile()"
        sections = for _section in getINISetting ini_file collect _section as name

        this.setGeneralValues(sections)

        for macroscript_name in sections do
        this.parseMacroscript (macroscript_name as string )

        this.writeToFile()
    ),

    private

    /** Set general values
     *
     */
    function setGeneralValues sections =
    (
        --format "\n"; print "MacroscriptGenerator_v.setGeneralValues()"
        general_keys = if findItem sections #general > 0 then getINISetting ini_file "general" else #()

        if (index = findItem sections #general) > 0 then
        deleteItem sections index

        for key in general_keys where (general_value = getINISetting ini_file #general key) != "" do
        general_params[key as name ] = general_value

        /* Add macroscript name */
        if general_params[#macroscript] == undefined then
        general_params[#macroscript] = ""
    ),

    /** Parse macroscript
     *
     */
    function parseMacroscript macroscript_name =
    (
        --format "\n"; print "MacroscriptGenerator_v.parseMacroscript()"
        /** Get macroscript data
         *
         */
        function getMacroscriptData macroscript_name macro_keys =
        (
            --format "\n"; print "MacroscriptGenerator_v.getMacroscriptData()"
            macro_data = Dictionary()

            for key in macro_keys where (val = getINISetting ini_file macroscript_name key) != "" do
            macro_data[key as name] = val

            macro_data[#macroscript] = macroscript_name

            /* ADD BUTTONTEXT */
            if macro_data[#buttontext] == undefined then
            macro_data[#buttontext] = substituteString macroscript_name "_" " "

            macro_data --return
        )

        macro_keys = getINISetting ini_file macroscript_name

        if macro_keys.count == 0 then
            return undefined

        append macroscripts (getMacroscriptData(macroscript_name)( macro_keys ))
    ),



    --/** Merge data
    -- *
    -- */
    --function mergeData macro_data =
    --(
    ----format "\n"; print "MacroscriptGenerator_v.mergeData()"
    --
    --
    --for key in general_params.keys where not this.isFilter(key) do
    --(
    --macro_value = if macro_data[key] != undefined then macro_data[key] else ""
    --
    --space = if key == #macroscript or macro_value == "" then "" else " "
    --
    --macro_data[key] = general_params[key] + space + macro_value
    --)
    --
    --macro_data --return
    --),

    /** Write to file
    *
    */
    function writeToFile =
    (
        format "\n"; print "MacroscriptGenerator_v.writeToFile()"

        /* CREATE FILE */
        this.mcr_file = createFile(( trimRight ini_file "ini" ) + "mcr")

        /* WRITE FILE START */
        if general_params[#filein] != undefined then
        format "filein %\n\n" general_params[#filein] to:mcr_file

        try(

            /* WRITE EACH MACROSCRIPT */
            for macro_data in macroscripts do
            this.writeSectionsToFile(macro_data)

        )catch(

            format "\n——————————————— ERROR IN FILE ———————————————\n\n%\n" (getSourceFileName())
            format "\n————————————————— EXCEPTION —————————————————\n\n%\n" (getCurrentException())
            format "\n——————————————————— TRACE ———————————————————\n%\n"(getCurrentExceptionStackTrace())
            format "\n——————————————————— STACK ———————————————————\n%\n"(getCurrentExceptionCallStack())

            close this.mcr_file
        )

        /* CLOSE FILE */
        close this.mcr_file
    ),


    /** Write to file
    *
    */
    function writeSectionsToFile macro_data =
    (
        format "\n"; print "MacroscriptGenerator_v.writeToFile()"
        format "MACRO_DATA:% \n" macro_data

        /** Get data type
        *
        */
        function getDataType macro_data type =
        (
            --format "\n"; print "MacroscriptGenerator_v.getDataType()"
            data = Dictionary()

            for data_pair in macro_data where case type of (
                #param:findItem this.keys_params data_pair.key > 0
                #filter:matchPattern (data_pair.key as string ) pattern:"IS*"
                #execute: matchPattern (data_pair.key as string ) pattern:"*EXECUTE"
             )
            do data[data_pair.key] = data_pair.value

            data --return
        )

        macro_params= getDataType (macro_data) (#param)
        macro_filters = getDataType (macro_data) (#filter)
        macro_code = getDataType (macro_data) (#execute)

        --format "PARAMS_DATA:% \n" macro_params
        --format "FILTERS_DATA:% \n" macro_filters
        --format "EXECUTE_DATA:% \n" macro_code
        --/* WRITE COMMENT */
        format "/** %\n */\n"macro_data[#buttonText] to:mcr_file

        --/* WRITE MACROSCRIPT NAME */
        format "macroscript%\n"macro_data[#macroscript] to:mcr_file
        --
        --/* WRITE PARAMS */
        this.writeParams ( macro_params )

        --/* OPEN MACROSCRIPT BRACKET */
        this.writeOpenBracket()
        --
        --/* WRITE FILTERS */
        this.writeFilters ( macro_filters )

        /* WRITE COMMANDS */
        this.writeExecute ( macro_code )
        --/* CLOSE MACROSCRIPT BRACKET */
        this.writeCloseBracket()
    ),


    /** Get value
    *
    */
    function _getValue data key =
    (
        --format "\n"; print "MacroscriptGenerator_v.getValue()"
        if data[key] != undefined then data[key] else ""
    ),

    /** Write macroscript params
     */
    function writeParams macro_data =
    (
        format "\n"; print "MacroscriptGenerator_v.writeParams()"
        --format "GENERAL_PARAMS:% \n" general_params
        --format "GENERAL_PARAMS:% \n" general_params[#buttontext]

        for key in this.keys_params do
        (
            general_value = this._getValue (general_params)(key)
            macro_value= this._getValue (macro_data)(key)

            format "%:\"%\"\n" (key as string ) (general_value + macro_value ) to:mcr_file
        )
    ),

    /** Write macroscript filters
     */
     function writeFilters macro_data =
    (
        format "\n"; print "MacroscriptGenerator_v.writeFilters()"

        format "FILTERS_DATA:% \n" macro_data
        /** If contains
         *
         */
        function ifContains _string pattern =
        (
            --format "\n"; print "MacroscriptGenerator_v.ifContains()"
            matchPattern _string pattern:pattern
        )


        for key inthis.keys_filter do
        (
            general_value = this._getValue (general_params)(key)
            macro_value= this._getValue (macro_data)(key)

            operator = if macro_value != "" and general_value != "" andthen " and " else ""

            condition = case of
            (
                (macro_value == "" or general_value == ""):general_value + macro_value
                (ifContains macro_valuepattern:"or *"):general_value + " " + macro_value
                (ifContains general_value pattern:"or *"):macro_value + " " + general_value
                default: general_value + " and " + macro_value
            )


            format "on % do%\n" (key as string ) (condition) to:mcr_file
        )
    ),

    /** Write macroscript code
     */
    function writeExecute macro_data =
    (

        for key in this.keys_codedo
        (

        general_value = this._getValue (general_params)(key)
        macro_value= this._getValue (macro_data)(key)

        onCommand = if key == #altExecute then key as string + " type" else key as string

        format "\non % do (\n%\n)\n" onCommand (general_value + macro_value ) to:mcr_file
        )
    ),

    /** Write open bracket
     *
     */
    function writeOpenBracket =
    (
        --format "\n"; print "MacroscriptGenerator_v.writeOpenBracket()"
        format "(\n"to:mcr_file
    ),

    /** Write close bracket
     *
     */
    function writeCloseBracket =
    (
        --format "\n"; print "MacroscriptGenerator_v.writeCloseBracket()"
        format ")\n\n"to:mcr_file
    ),


    /**
     */
    on create do
    (
    --format "\n"; print "MacroscriptGenerator.onCreate()"
    --for prop in #() where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
    --throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )

        this.generateMacroscriptFile()
    )
)