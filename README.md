# OOP wrapper for maxscript dialogs

• **Painless coding maxscript dialogs**

• **Integrates many basic functionalities of dialog out of the box**

• **Generates rollouts and controls based on file structure**



## Basic dialog features out of box

- Save \ load UI state to ini file
  - **Dialog size, position and dock state**
  - Open \ close state of rollouts
  - Order of subrollouts
  - **Values and states of controls**


## Generates rollouts and controls based on file structure

	Directory → ROLLOUT
 
        .mcr file → GROUP OF CONTROLS
	 
            macroscript → CONTROL


## Widths of rollouts are maiximized
[SubolloutsCreator](Lib/RolloutCreator/SubolloutsCreator)

![maximized_rollout_width](Lib/RolloutCreator/SubolloutsCreator/_readme/maximized_rollout_width.jpg)




KNOWING ISSUES:
	Contentloader has bug with loading file into menu if fiule is named: "Menus.mcr"

