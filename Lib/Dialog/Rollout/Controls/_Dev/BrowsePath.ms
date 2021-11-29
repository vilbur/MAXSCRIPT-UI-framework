clearListener()

/** Browse path is fired on Enter|Tab|Space|Backspace ONLY WHEN FILED IS EMPTY
  */
try(destroyDialog browse_path) catch()

rollout browse_path "Browse path if filed is empty"
(
	
	local edit_text_prev_state = ""
	
	function browsePath edit_text_text =
	(
		function rxMatch _string =
		(
			(( dotNetClass "System.Text.RegularExpressions.RegEx").matches _string "^\s+$|^$" ).count == 1
		)
		
		if( rxMatch edit_text_text and rxMatch edit_text_prev_state ) then
			if( (browsed_path = getSavePath caption:"browse path" initialDir:"$scripts") != undefined ) do
				edit_text.text = browsed_path
		
		else
			edit_text_prev_state = edit_text.text
	)
		
	group "Locals and Functions must be defined out of group"
	(
		edittext edit_text  "Browse"	text:""
		
		edittext test_focus "Test	 "	text:"Test focus change with Tab key"
		   
		on edit_text changed text do
			 browsePath text
		
		on edit_text entered text do 
			 browsePath text
			
	)
)

CreateDialog browse_path width:320