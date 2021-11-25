clearListener()

/** Browse path is fired on Enter|Tab|Space|Backspace ONLY WHEN FILED IS EMPTY
  */
try(destroyDialog browse_path) catch()

rollout browse_path "Browse path if filed is empty" width:200
(
	edittext edit_text  text:""
	edittext test_focus text:"Test focus change with Tab key"
	   
	local prev_state = ""
	
	function browsePath edit_text_text =
	(
		/** Rx match
		 */
		function rxMatch _string =
		(
			(( dotNetClass "System.Text.RegularExpressions.RegEx").matches _string "^\s+$|^$" ).count == 1
		)
		
		if( rxMatch edit_text_text and rxMatch prev_state ) then
		(
			browsed_path = getSavePath caption:"my title" initialDir:"$scripts"
			
			if( browsed_path != undefined ) then
				edit_text.text = browsed_path
		)
		else
			prev_state = edit_text.text
	)

	
   on edit_text changed text do
		browsePath text
   
   on edit_text entered text do 
		browsePath text

)
CreateDialog browse_path width:256

