/** Uvw viewer
  
 */
struct BagroundGenerator_v
(
	--__construct = #( #property_name ),

	/* construct */
	bitmap_size = [256,256],

	/* dependency */
	/* reference */
	/* inhered */
	/* properties */
	
	/** Draw UVW
	 */
	function createBackground rollout_positions =
	(
		format "\n"; print "BagroundGenerator_v.createBackground()"
		--obj = selection[1]
		
		if( bg_bitmap != undefined ) then 
			unDisplay bg_bitmap
		
		--face_count = polyop.getNumMapFaces obj map_channel
		
		--format "face_count	= % \n" face_count
		global bg_bitmap = bitmap bitmap_size.x bitmap_size.y color:( color 0 0 0 )
		
		pos_y = 32
		height = 128
		
		pixels = for i = 1 to bitmap_size.x collect white
		
		for y = pos_y to pos_y + height do 
			setPixels bg_bitmap [ 0, y ] pixels
			
		display bg_bitmap
		bg_bitmap --return
	),

	/**  
	 */
	on create do
	(
		--print("BagroundGenerator_v.onCreate()")
	)
)