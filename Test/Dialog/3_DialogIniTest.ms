clearListener()

filein( "$userscripts\Library\MAXSCRIPT-UI-framework\Lib\Dialog\Dialog.ms" )


/* DIALOG */ 
Dialog     = Dialog_v title:"Test without ini"
-- Dialog.create()


-- Dialog_ini = Dialog_v title:"Test with ini"  ini:(getSourceFileName())
Dialog_ini = Dialog_v title:"Test with ini"  ini:(getSourceFileName()) width:256 height:128 -- dialog size works as init and minimal size of dialog

-- /* ROLLOUT */ 
-- _Rollouts	 = Dialog_ini.Rollouts()
-- _Rollouts	 = Dialog_ini.Rollouts height:512
-- _Rollout    = _Rollouts.Roll "Subrollout"
-- _Controls   = _Rollout.Controls group:"Rollout Controls"
-- _Button     = _Controls.control #button "Rollout" id:#button_2




Dialog_ini.create()