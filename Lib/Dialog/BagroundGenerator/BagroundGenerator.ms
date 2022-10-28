/** Uvw viewer
  
 */
struct BagroundGenerator_v
(
	/* construct */
	bitmap_size = [32,256],

	/* dependency */
	/* reference */
	/* inhered */
	/* properties */
	
	/** Draw UVW
	  * 
	  * @param	#( #( rollout_pos_y, rollout_height, rollout_color)) rollout_dimensions 2D matrix
	  *		1 = POSITION of subrollout in dialog
	  *		2 = HEIGHT of subrollout 
	  *		3 = COLOR of subrollout, if undefined then white is used
	 */
	function createBackground rollout_dimensions =
	(
		format "\n"; print "BagroundGenerator_v.createBackground()"
		--obj = selection[1]
		
		if( bg_bitmap != undefined ) then 
			unDisplay bg_bitmap
		
		--face_count = polyop.getNumMapFaces obj map_channel
		
		--format "face_count	= % \n" face_count
		global bg_bitmap = bitmap bitmap_size.x bitmap_size.y color:( color 13 13 13 ) -- NOTICE: 13 -> is value 68 in photoshop, 
				
		for rollout_dimension in rollout_dimensions do
		(
			--rollout_dimension = 32
			rollout_position	= rollout_dimension[1]
			rollout_height	= rollout_dimension[2]
			rollout_color	= if rollout_dimension.count == 3 then rollout_dimension[3] else white

			format "rollout_position	= % \n" rollout_position
			
			_line = for i = 1 to 16 collect rollout_color
			
			for y = rollout_position to rollout_position + rollout_height  do 
				setPixels bg_bitmap [ 0, y ] _line
				
			
		)
		format "bg_bitmap	= % \n" bg_bitmap
		--display bg_bitmap+
		bg_bitmap --return
	),

	/**  
	 */
	on create do
	(
		--print("BagroundGenerator_v.onCreate()")
	)
)

getDir #userScripts