clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../Lib/Dialog/Dialog.ms" )	-- "./../../Lib/Dialog/Dialog.ms"

/** TEST HOW ASCCII IS INTERPRETED IN MAX
  *
  *  ASCII SOURCE: https://www.alt-codes.net/
  *
  */

/* DIALOG */
Dialog 	    = Dialog_v title:"Test"


/* CONTROLS */
Controls   = Dialog.Controls()

Controls.Default #across 1 type:#button
Controls.Default #width 512 type:#button


Controls.control #button "➤ ➥ ➧ ➲ ⟲ ⥀ ⦽ ⧪ ⬲ ⧭ ♁ ☉ ☀ ☼ ♥ ♡ ☻ ☺" id:#button_test

Controls.control #button "◆ ⬟ ☰ ⬣ ⬡ ⬢ ■ ▩ ⛞ ⌛ ⏰ ⏲" id:#button_iamegs

Controls.control #button "✅ × ♻ ☼ ☀ ☉ ☢ ✔ ⬕" id:#button_items

Controls.control #button " ⬒ ◧ ◨ ▾ ▴" id:#button_items_b

Controls.control #button "= ⮄ ⮆ ⬆⬇ ⬅▲ ▼ ► ◄ ↑ ↓ → ← ↔ ↕ ↨  ➡  ⇦ ⇧ ⇨ ⇩ ➤ ➥ ➧ ➲ ⟲ ⥀ ⦽ ⧪ ⬲ ⧭" id:#button_arrows --https://www.alt-codes.net/arrow_alt_codes.php

Controls.control #button "✚ + ⭐★≛ ⋆ ⍟ ⍣  ☆ ✦ ✪ ✫ ✬ ✯ ✰ ✴ ✵ ✶ ✷ ✸ - ✹ ❂" id:#button_star -- https://www.alt-codes.net/star_alt_code.php





/* DIALOG CREATE */
Dialog.create   width:512