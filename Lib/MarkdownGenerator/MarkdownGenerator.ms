

/*------------------------------------------------------------
  Markdown generator from native Dictionary().
  Supports:
  - Nested headers
  - Ordered lists via #integer keys
  - Unordered lists via Array values
  - HTML passthrough
------------------------------------------------------------*/
struct MarkdownGenerator_v
(
	md_file_path,
	
    output = "",

    /*------------------------------------------------------------
      Public generator
    ------------------------------------------------------------*/
	
    function generate dict =
    (
        output = ""
        this.parseDict dict 1
        
		if md_file_path != undefined then 
			this.writeToMarkdownFile()
		
        output -- return
    ),

	/** Write to markdown file
	 */
	function writeToMarkdownFile =
	(
		--format "\n"; print "MarkdownGenerator_v.writeToMarkdownFile()"
		md_file = createFile md_file_path
		
		format "%" output to:md_file
		
		close md_file
	),
	
    /*------------------------------------------------------------
      Converts header level to markdown prefix
    ----------------------------------------------------------*/
    function getHeaderPrefix level =
    (
        local prefix = ""
        for i = 1 to level do
        (
            prefix += "#"
        )
        prefix
        -- return
    ),
    
    /*------------------------------------------------------------
      Append line with newline
    ------------------------------------------------------------*/
    function appendLine text =
    (
        output += (text as string) + "\n"
        true
        -- return
    ),
    
    /*------------------------------------------------------------
      Detect if dictionary represents ordered list
    ------------------------------------------------------------*/
    function isOrderedDict dict =
    (
        for k in dict.keys do
        (
            if (classOf k) != Integer then
            (
                return false
            )
        )
        true
        -- return
    ),
    
    /*------------------------------------------------------------
      Process unordered list (Array)
    ------------------------------------------------------------*/
    function parseArray arr level =
    (
        for item in arr do
        (
            this.appendLine ("- " + (item as string))
        )
        this.appendLine ""
        true
        -- return
    ),
    
    /*------------------------------------------------------------
      Process ordered list (Dictionary with integer keys)
    ------------------------------------------------------------*/
    function parseOrderedDict dict level =
    (
        --local keys_sorted = for k in dict.keys collect k
		
        --qsort keys_sorted (fn a b => a < b)
		
        local keys_sorted = dict.keys
    
        for i = 1 to keys_sorted.count do
        (
            local value = dict[keys_sorted[i]]
			
            this.appendLine ((i as string) + ". " + (value as string))
        )
        this.appendLine ""
        true
        -- return
    ),
    
    /*------------------------------------------------------------
      Recursive parser
    ------------------------------------------------------------*/
    function parseValue key value level =
    (
        if (isKindOf value Dictionary) then
        (
            this.appendLine (getHeaderPrefix level + " " + key)
            this.appendLine ""
    
            if this.isOrderedDict value then
            (
                this.parseOrderedDict value level
            )
            else
            (
               this.parseDict value (level + 1)
            )
        )
        else if (isKindOf value Array) then
        (
            this.appendLine (getHeaderPrefix level + " " + key)
            this.appendLine ""
            this.parseArray value level
        )
        else
        (
            this.appendLine (getHeaderPrefix level + " " + key)
            this.appendLine ""
            this.appendLine (value as string)
            this.appendLine ""
        )
        true
        -- return
    ),
    
    /*------------------------------------------------------------
      Parse dictionary
    ------------------------------------------------------------*/
    function parseDict dict level =
    (
        for k in dict.keys do
        (
            this.parseValue (k as string) dict[k] level
        )
        true
        -- return
    ),

    on create do
    (
        --output = ""
    )
)
