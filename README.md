# Advanced Player Model Pools (TTT_APMP)
player model group managment tool (addon) for the "Trouble in Terrorist Town" gamemode of Garry's Mod.

## Roadmap
- rewrite gui and messaging system
- add a in-game configuration that generates a config file for usage after manual renaming or copying to the dedicated server


## (manual) model group configuration
under "GarrysMod/garrysmod/data/" create a lua-file called "ttt_apmp_shared.lua".
First, add **AddCSLuaFile()** to the first line, then define a table called pmp witch contains tables (our model groups). The first element of these inner tables is an string; the group name. The second element is (again) a table containing strings (the various paths to the player-models mdl files). The strings themselve are wrapped by the Model()-Function, just like for the default models of TTT.

Note that you should have little understanding of the lua scripting language and its syntax as mistakes done in this configuration file may have very bad effects on TTT. When the guided configuration is available it is recommended not to configure TTT_APMP manually!

### Example
Pretend you have subscribed player models that are categorizable to the following three groups: "super heroes", "females", and "anime males". A configuration could look like following
```
AddCSLuaFile()
pmp = {
  {"super heroes", { Model("models/player/superheroes/superman.mdl"),
  	Model("models/player/superheroes/flash.mdl"),
  	Model("models/player/superheroes/greenlantern.mdl"),
  	Model("models/player/superheroes/batman.mdl"),
  	Model("models/pechenko_121/deadpool/chr_deadpool2.mdl"),
  	Model("models/pechenko_121/deadpool/chr_deadpooldpooly.mdl"),
  	Model("models/pechenko_121/deadpool/chr_deadpoolultimate.mdl")
  }},
  { "females", { Model("models/player/lara_croft.mdl")
  	Model("models/player/doa5_kasumi.mdl"),
  	Model("models/player/doa_honoka_bunny.mdl"),
  	Model("models/mark2580/dmc4/dmc_lady_player.mdl")
  	Model("models/player/ratedr4ryan/catwoman_bak.mdl"),
  }},
  { "anime males", { Model("models/player/demonic/minato.mdl"),
  	Model("models/custom/naruto/male_01.mdl"),
  	Model("models/player/goku/goku_budokai.mdl"),
  	Model("models/player/b3frz/b3frz.mdl"),
  	Model("models/player/b3nap/b3nap.mdl")
  }}
}
```

some player models are known to cause a *too many incidences* error for gmod clients in a certain raidius. A workaround can be to disable blood splatter and bullet holes globally. To keep up gameflow and immersion you can make TTT_APMP disable decale effects when defined player models are currently being used.

TODO: add further instructions on pmp_indices_workaround variable in config file

## Notes for programmers
If you like to publish you own version on of TTT_APMP on steam. The gmodToolsLinux.bash script (written under Linux but may also work on MAC OS X) may help you. It just takes one argument: "create" (create the gma file) or "publish" (upload the created gma file to the steam workshop). *WIP*
