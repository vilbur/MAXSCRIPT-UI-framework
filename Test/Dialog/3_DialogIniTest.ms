clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../Lib/Dialog/Dialog.ms" ) -- "./../../Lib/Dialog/Dialog.ms"


/* DIALOG */
 Dialog_ini = Dialog_v title:"Test with ini"  ini:(getSourceFileName())


/* DELETE INI FILE */
Dialog_ini.ini.deleteIni()


 /* ROLLOUT */
 _Rollouts	 = Dialog_ini.Rollouts()
 _Rollouts	 = Dialog_ini.Rollouts height:512
 _Rollout    = _Rollouts.Roll "Subrollout"
 _Controls   = _Rollout.Controls group:"Rollout Controls"
 _Button     = _Controls.control #button "Rollout" id:#button_2


Dialog_ini.create()