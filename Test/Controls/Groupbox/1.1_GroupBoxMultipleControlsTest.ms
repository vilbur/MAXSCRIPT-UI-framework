clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../../Lib/Dialog/Dialog.ms" )

/* DIALOG */
Dialog 	= Dialog_v title:(getFilenameFile(getSourceFileName()))

/* CONTROLS */
_Controls = Dialog.Controls group:"Test Dialog"

/* GROUPBOX */
_GroupBox_A1 = _Controls.control #GroupBox (groupbox_name = "Groupbox A 1") params:#( #height, 128 )
--_GroupBox_A2 = _Controls.control #GroupBox (groupbox_name = "Groupbox A 2") params:#( #height, 128 )

/* BUTTON */
_Controls.control #button ("Button 1") across:1 params:#(#groupbox, groupbox_name)
_Controls.control #button ("Button 2") across:1 params:#(#groupbox, groupbox_name)


--/* CONTROLS */
--_Controls_2 = Dialog.Controls group:"Controls 2"
--
--/* GROUPBOX */
--_GroupBox = _Controls_2.control #GroupBox (groupbox_name_2 = "Groupbox 2") params:#( #height, 128 )
--
--/* BUTTON */
--_Controls_2.control #button ("Button Controls 2") across:1 params:#(#groupbox, groupbox_name_2)
--

/* CREATE DIALOG */
--Dialog.create()
Dialog.create width:320

