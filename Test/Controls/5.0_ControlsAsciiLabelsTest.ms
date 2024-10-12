clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../Lib/Dialog/Dialog.ms" )	-- "./../../Lib/Dialog/Dialog.ms"

/** TEST HOW ASCCII IS INTERPRETED IN MAX
  *
  *  ASCII SOURCE: https://www.alt-codes.net/
  *
  */

/* DIALOG */
Dialog 	    = Dialog_v title:"Test" ini:(getSourceFileName())
--Dialog 	    = Dialog_v title:"Test"


/* CONTROLS */
--Controls   = Dialog.Controls group:"Main Controls"
Controls   = Dialog.Controls()

/*------ GROUPBOX ------*/
--Controls.control #Groupbox "Groupbox Test" height:64
--Controls.control #button "Button in Groupbox" params:#(#groupbox, "Groupbox Test")
--
--
--Controls.control #Groupbox "[Groupbox Hidden Label]" height:64
--Controls.control #button "Group Box without Label" params:#(#groupbox, "[Groupbox Hidden Label]") width:128 offset:[-32,0]


/*------ BUTTON ------*/
--Controls.control #button "Button" id:#button_1

Controls.Default #across 1 type:#button
Controls.Default #width 512 type:#button
--Controls.Default #align #center

Controls.control #button "➤ ➥ ➧ ➲ ⟲ ⥀ ⦽ ⧪ ⬲ ⧭ ♁ ☉ ☀ ☼ ♥ ♡ ☻ ☺" id:#button_test

Controls.control #button "◆ ⬟ ☰ ⬣ ⬡ ⬢ ▩ ⛞ ⌛ ⏰ ⏲" id:#button_iamegs

Controls.control #button " ✅♻ ☼ ☀ ☉ ☢ ✔ ⬕" id:#button_items

Controls.control #button "⬆⬇ ⬅▲ ▼ ► ◄ ↑ ↓ → ← ↔ ↕ ↨  ➡  ⇦ ⇧ ⇨ ⇩ ➤ ➥ ➧ ➲ ⟲ ⥀ ⦽ ⧪ ⬲ ⧭" id:#button_arrows --https://www.alt-codes.net/arrow_alt_codes.php

Controls.control #button "⭐★≛ ⋆ ⍟ ⍣  ☆ ✦ ✪ ✫ ✬ ✯ ✰ ✴ ✵ ✶ ✷ ✸ - ✹ ❂" id:#button_star -- https://www.alt-codes.net/star_alt_code.php




/*------ CECKBUTTON ------*/
--Controls.control #checkbutton "checkbutton"

/*------ CHECKBOX ------*/
--Controls.control #checkbox "Checkbox"

/*------ RADIOBUTTONS ------*/
--Controls.control #radioButtons "RadioButtons"	items:#("Item 1","Item 2")

/*------ DROPDOWN ------*/
--Controls.control #Dropdownlist "Dropdownlist"

/*------ EDITTEXT ------*/
--Controls.control #Edittext "Edittext"

/*------ SLIDER ------*/
--Controls.control #slider "Slider"



/*------ BROWSEATH ------*/
--Controls.control #browsePath "browsePath"

/*------ COLORPICKER ------*/
-- Controls.control #ColorPicker "ColorPicker A" value: [ 64, 128, 0 ]	across:1
-- Controls.control #ColorPicker "ColorPicker B"  params:#(#color, ( color 255 0 128 ))	across:1
-- Controls.control #ColorPicker "ColorPicker C"  params:#(#color, [0,128,0 ] )	across:1

/*------ BITMAP ------*/
--Controls.Control #bitmap "_bitmap_test" params:#(#bitmap, "(bitmap 50 50 color:green)" )
--Controls.Control #bitmap "_bitmap_test" params:#(#bitmap, (bitmap 50 50 color:orange) )
--Controls.Control #bitmap "_bitmap_test" value: (bitmap 50 50 color:blue)




/* IMPORTANT: IF PICKER IS NOT DISPLAYED
 *
 * If picker is wider then its allocated space, then only label is shown
 *
 * SOLUTION: Set lower across parameter or wider rollout
 *
*/
-- Controls.control #ColorPicker "THERE IS NOT PICKER SHOWN" value: [ 64, 128, 0 ] across:4



/* DIALOG CREATE */
--Dialog.create()
Dialog.create   width:512
--Dialog.create   width:1024
