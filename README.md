# Advanced Player Model Pools (TTT_APMP)
player model group managment tool (addon) for the "Trouble in Terrorist Town" gamemode of Garry's Mod.

TODO: add more description on usage etc.

configuration:
under "GarrysMod/garrysmod/data/" create a lua-file called "ttt_apmp_shared.lua".
define a variable called pmp. This variable needs to be a an table that contains tables (these are our model groups). The first element of these inner tables is an string; the group name. The second Element is (again) a table containing strings (the path to the player model mdl files). Just like for the default models of TTT simply call the Model()-function with the string to the mdl as shown in the following example:
pmp = {
  {"super heroes", { Model("models/player/superheroes/superman.mdl"),
  	Model("models/player/superheroes/flash.mdl"),
  	Model("models/player/superheroes/greenlantern.mdl"),
  	Model("models/player/superheroes/batman.mdl"),
  	Model("models/player/ratedr4ryan/catwoman_bak.mdl"),
  	Model("models/pechenko_121/deadpool/chr_deadpool2.mdl"),
  	Model("models/pechenko_121/deadpool/chr_deadpooldpooly.mdl"),
  	Model("models/pechenko_121/deadpool/chr_deadpoolultimate.mdl")
  }},
  { "females", { Model("models/player/lara_croft.mdl")
  	Model("models/player/doa5_kasumi.mdl"),
  	Model("models/player/doa_honoka_bunny.mdl"),
  	Model("models/mark2580/dmc4/dmc_lady_player.mdl")
  }},
  { "anime males", { Model("models/player/demonic/minato.mdl"),
  	Model("models/custom/naruto/male_01.mdl"),
  	Model("models/player/goku/goku_budokai.mdl"),
  	Model("models/player/b3frz/b3frz.mdl"),
  	Model("models/player/b3nap/b3nap.mdl")
  }}
}
