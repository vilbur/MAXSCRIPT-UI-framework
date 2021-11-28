filein( getFilenamePath(getSourceFileName()) + "/../Dialog/Dialog.ms" )

filein( getFilenamePath(getSourceFileName()) + "/ContentSubrollouts/ContentRollout/ContentRollout.ms" ) 

/** Load content to UI by file tree
  *
  * @property	string	dir	Directory where rollout directories are placed, rollouts are used if ends with "*"
  * @property	regEx	match	Only directories matching this regex are threaded as rollouts, rollout name is matching group if defined
  *
  * --------------------------------------------------------------------------------------------------------------------
  *
  *
  */
struct ContentLoader_v
(
	__construct = #( #path ),
	
	/* required properties */
	path, -- source dir of content
	ini,  -- path to ini file
	
	/*  properties */
	Dialog,

	/* depoendency */ 
	ContentRollout,

	/** Create
	 */
	function create pos: width: height: menu: bgcolor: fgcolor: bitmap: style: modal: escapeEnable: lockHeight: lockWidth: parent: =
	(
		print("ContentLoader_v.create()")

		if( ini != undefined ) then
			Dialog.RolloutMain.ini ini
		
		for Subrollouts_or_Controls in ContentRollout.Subrollouts_and_Controls do
			Subrollouts_or_Controls.addToUi Dialog.RolloutMain
			
		Dialog.create pos:pos width:width height:height menu:menu bgcolor:bgcolor fgcolor:fgcolor bitmap:bitmap style:style modal:modal escapeEnable:escapeEnable lockHeight:lockHeight lockWidth:lockWidth parent:parent
	
		Dialog --return
	),
	
	private
	
	/** Check if required properties are defined when an instance of the struct is created.
	 *	
	 * @example __construct = #( #property_name ) 
	 */
	function _checkConstctructProperties =
	(
		for prop in __construct where getProperty this prop == undefined do
			messageBox ("ContentLoader\nUndefined construct property !\n\n"+ ((filterString( classof this as string )"(:")[2]) +"."+ prop )
	),
	
	/**  
	 */
	on create do
	(
		--print("ContentLoader_v.onCreate()")

		this._checkConstctructProperties()
		
		ContentRollout =  ContentRollout_v path:path
		
		Dialog	= Dialog_v title:ContentRollout.title id:ContentRollout.title

		ContentRollout
	)
)