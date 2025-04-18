
filein( getFilenamePath(getSourceFileName()) + "/../ConstructPropeties/ConstructPropeties.ms" )	--"./../ConstructPropeties/ConstructPropeties.ms"

filein( getFilenamePath(getSourceFileName()) + "/../Dialog/Dialog.ms" )	-- "./../Dialog/Dialog.ms"


filein( getFilenamePath(getSourceFileName()) + "/ContentSubrollouts/ContentRollout/ContentRollout.ms" )	-- "./ContentSubrollouts/ContentRollout/ContentRollout.ms"

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

	/* REQUIRED properties */
	path, -- source dir of content
	ini,  -- path to ini file

	/*  properties */
	Dialog, -- Dialog_v "./../Dialog/Dialog.ms"

	width  = unsupplied, -- unsupplied for compatibility with CreateDialog()
	height = unsupplied,

	min_size,
	max_size,

	/* dependency */
	ContentRollout,

	/* developent */
	DEBUG = false,
	--DEBUG = true,


	/** Create Dialog
	 */
	--function create width: height: pos: menu: bgcolor: fgcolor: bitmap: style: modal: escapeEnable: lockHeight: lockWidth: parent: =
	--function create width: height: pos: origin:#SCREEN bgcolor: fgcolor: bitmap: style: modal: escapeEnable:false escapekey:true lockHeight:false lockWidth:false parent: =

	function create \
		width:	\
		height:	\
		pos:	\
		origin:#SCREEN bgcolor:	\
		fgcolor:	\
		bitmap:	\
		bmpstyle:#bmp_tile  style:	\
		modal:	\
		escapeEnable:false	\
		escapekey:true	\
		lockHeight:false	\
		lockWidth:true	\
		parent: =
	(
		--print("ContentLoader_v.create()")

		Dialog.create \
			width:width 	\
			height:height 	\
			pos:pos 	\
			menu:menu 	\
			bgcolor:bgcolor 	\
			fgcolor:fgcolor 	\
			bitmap:bitmap 	\
			bmpstyle:bmpstyle 	\
			style:style 	\
			modal:modal 	\
			escapeEnable:escapeEnable 	\
			lockHeight:lockHeight 	\
			lockWidth:lockWidth 	\
			parent:parent

		Dialog --return
	),

	private


	/**
	 */
	on create do
	(
		--print("ContentLoader_v.onCreate()")
		--format "path: %\n" path

		ConstructPropeties test:this

		ContentRollout =  ContentRollout_v path:path

		Dialog	= Dialog_v title:ContentRollout.title ini:ini width:width height:height min_size:min_size max_size:max_size DEBUG:DEBUG
		
		--format "DIALOG.ID: %\n" Dialog.id
		
		for Subrollouts_or_Controls in ContentRollout.Subrollouts_and_Controls do
			Subrollouts_or_Controls.addToUi Dialog
	)
)












