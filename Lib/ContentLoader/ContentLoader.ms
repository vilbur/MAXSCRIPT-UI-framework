filein( getFilenamePath(getSourceFileName()) + "/../ConstructPropeties/ConstructPropeties.ms" )

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

	/* dependency */ 
	ContentRollout,

	/** Create Dialog
	 */
	function create pos: menu: bgcolor: fgcolor: bitmap: style: modal: escapeEnable: lockHeight: lockWidth: parent: =
	(
		--print("ContentLoader_v.create()")

		
		Dialog.create pos:pos menu:menu bgcolor:bgcolor fgcolor:fgcolor bitmap:bitmap style:style modal:modal escapeEnable:escapeEnable lockHeight:lockHeight lockWidth:lockWidth parent:parent
	
		Dialog --return
	),
	
	private

	
	/**  
	 */
	on create do
	(
		--print("ContentLoader_v.onCreate()")

		ConstructPropeties test:this
		
		ContentRollout =  ContentRollout_v path:path
		
		Dialog	= Dialog_v title:ContentRollout.title id:ContentRollout.title ini:ini
		
		for Subrollouts_or_Controls in ContentRollout.Subrollouts_and_Controls do
			Subrollouts_or_Controls.addToUi Dialog.RolloutMain
	)
)