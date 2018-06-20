--[[ Copyright and license:
Copyright 2018 Christian Luca Lützenkirchen
This file is part of the "Trouble in Terrorist Town" AddOn "Advanced Player Model Pool" (TTT_APMP).

    TTT_APMP is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or any later version.

    TTT_APMP is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with TTT_APMP.  If not, see <http://www.gnu.org/licenses/>.
]]

-- TODO engine.ActiveGamemode()

print("DEBUG TTT_APMP_server loaded")
CreateConVar("ttt_pmodel", "default")
-- Net Library: https://wiki.garrysmod.com/page/Net_Library_Usage
-- set message name for net Library:
util.AddNetworkString("TTT_APMP_NET_MSG")

--TODO: our hard coded model pools
local pmp_male = {
	Model("models/player/daedric.mdl"),
	Model("models/thresh/thresh.mdl"),
	Model("models/models/konnie/savini/savini.mdl"),
	Model("models/player/anon/anon.mdl"),
	Model("models/player/lich_king_wow_masked.mdl"),
	Model("models/lskovfoged/dmc4/dante/dante.mdl"),
	Model("models/player/bobert/aojoker.mdl"),
	Model("models/player/ezio.mdl"),
	Model("models/player/darth_vader.mdl"),
	Model("models/jazzmcfly/jka/darth_maul/jka_maul.mdl"),
	Model("models/player/lenoax_gordon.mdl")}

local pmp_female = {
	Model("models/kuma96/2b/2b_pm.mdl"),
	Model("models/kuma96/lightningetro/lightningetro_pm.mdl"),
	Model("models/kuma96/serah2/serah2_pm.mdl"),
	Model("models/player_zsssamusu.mdl"),
	Model("models/kerrigan_pmodel/kerrigan_pm.mdl"),
	Model("models/dpfilms/characters/playermodels/pm_mileena.mdl"),
	Model("models/mark2580/resident2/moira_ninja_player.mdl"),
	Model("models/player/doa5_kasumi.mdl"),
	Model("models/player/doa_honoka_bunny.mdl"),
	Model("models/player/truebobert/injustice_harley.mdl"),
	Model("models/mark2580/dmc4/dmc_lady_player.mdl"),
	Model("models/player/korka007/chloe.mdl"),
	Model("models/player_ashe.mdl"),
	Model("models/lightningplayer/lightningplayer.mdl"),
	Model("models/player/lara_croft.mdl") }

local pmp_superh = {
	Model("models/player/superheroes/superman.mdl"),
	Model("models/player/superheroes/flash.mdl"),
	Model("models/player/superheroes/greenlantern.mdl"),
	Model("models/player/superheroes/batman.mdl"),
	Model("models/player/ratedr4ryan/catwoman_bak.mdl"),
	Model("models/pechenko_121/deadpool/chr_deadpool2.mdl"),
	Model("models/pechenko_121/deadpool/chr_deadpooldpooly.mdl"),
	Model("models/pechenko_121/deadpool/chr_deadpoolultimate.mdl") }

local pmp_animef = {
	Model("models/player_sinonsao.mdl"),
	Model("models/jazzmcfly/kantai/kashima/kashima.mdl"),
	Model("models/jazzmcfly/bgs/bgs.mdl"),
	Model("models/player_compa.mdl"),
	Model("models/player_noire.mdl"),
	Model("models/captainbigbutt/vocaloid/miku_classic.mdl"),
	Model("models/captainbigbutt/vocaloid/miku_carbon.mdl"),
	Model("models/captainbigbutt/vocaloid/kuro_miku_append.mdl"),
	Model("models/captainbigbutt/vocaloid/haku_append.mdl"),
	Model("models/jazzmcfly/rwby/weiss_schnee.mdl") }

local pmp_animem = {
	Model("models/player/demonic/minato.mdl"),
	Model("models/custom/naruto/male_01.mdl"),
	Model("models/player/goku/goku_budokai.mdl"),
	Model("models/player/b3frz/b3frz.mdl"),
	Model("models/player/b3nap/b3nap.mdl") }

local pmp_metalgear = {
	Model("models/player/big_boss.mdl"),
	Model("models/ninja/raidenmgr.mdl"),
	Model("models/ninja/raidenmgrprologue.mdl"),
	Model("models/ninja/raidenmgrprologuesuit.mdl"),
	Model("models/ninja/raidenmgs4.mdl"),
	Model("models/player/meryl.mdl"),
	Model("models/player/meryl_servicedress.mdl") }

local pmp_zelda = {
	Model("models/player_link.mdl"),
	Model("models/sinful/toonlink.mdl"),
	Model("models/darklinkoot/darklinkoot.mdl"),
	Model("models/linkoot/linkoot.mdl"),
	Model("models/player/hw_zeldaqueen.mdl"),
	Model("models/hwzeldatp/hwzeldatp.mdl"),
	Model("models/player/ganondorf/ganondorf.mdl"),
	Model("models/player/hw_hildaqueen.mdl") }

-- PlayerModelPools that are assosiated with certain maps
-- TODO reimplement to new structure
--[[hook.Add("Initialize", "TTT_APMP assosiated maps with player model pools",  function()
	local ttt_pmodel_maps = {["ttt_outset_island"] = "zelda",
		["ttt_lttp_kakariko_a4"] = "zelda",
		["ttt_lostwoods"] = "zelda",
		["ttt_hyrulecastle"] = "zelda",
		["ttt_clocktown_swsw"] = "zelda"}
	if ttt_pmodel_maps[game.GetMap()] ~= nil then
		print("DEBUG: current map is assosiated with a player model pool!\n\t=> setting ttt_pmodel to " .. ttt_pmodel_maps[game.GetMap()] )
		RunConsoleCommand("ttt_pmodel", ttt_pmodel_maps[game.GetMap()] )
		print("DEBUG ttt_pmodel is " .. GetConVar("ttt_pmodel"):GetString() )
	end
end)
]]

-- Send available player model groups to connecting clients
hook.Add("PlayerInitialSpawn", "TTT_APMP send pm list to player", function(ply)
	print("DEBUG TTT_APMP_server, sending available pm groups to player "..ply:Nick())
	net.Start("TTT_APMP_NET_MSG")
	-- the message to the clients itself TODO from config
	net.WriteString("male,female,anime (male),anime (female),superheroes,metal gear,zelda")
	net.Send(ply)
end)

-- function evaluatePlayerModelPool returns the player model group with most votes
-- TODO this function is very ugly... tidy up soon!
-- might https://wiki.garrysmod.com/page/Tables:_Bad_Habits help?
local function evaluatePlayerModelPool()
	local results = {0,0,0,0,0,0,0,0}
	--if(results[1] != nil) then
		for key,ply in pairs(player.GetAll()) do
			local plyRes = ply:GetInfoNum("TTT_APMP_selected", 1)
			print("INFO TTT_APMP_server evaluatePlayerModelPool loop: plyRes="..plyRes.." results="..results[1])
			results[plyRes] = results[plyRes]+1
		end
	--end
	local mostVotesIndex = 0
	local mostVotesCounter = 0
	for key,ele in pairs(results) do
		if mostVotesCounter <= ele then
			mostVotesIndex = key
			mostVotesCounter = ele
		end
	end
	return mostVotesIndex
end

-- TTT_APMP core function hooked to PrepareRound
hook.Add("TTTPrepareRound", "TTT_APMP core function",  function()
	--print("DEBUG TTT_APMP_server: customPlayerModel()\n\tttt_pmodel = " .. GetConVar("ttt_pmodel"):GetString() )
	local playerPoolIndex = evaluatePlayerModelPool()
	print("DeBUG TTT_APMP_server: result of evaluatePlayerModelPool: ".. playerPoolIndex)
	if playerPoolIndex != 1 then
		local pm_roll = nil

		if playerPoolIndex == 2 then
			pm_roll = pmp_male
		elseif playerPoolIndex == 3 then
			pm_roll = pmp_female
		elseif playerPoolIndex == 4 then
			pm_roll = pmp_animem
		elseif playerPoolIndex == 5 then
			pm_roll = pmp_animef
		elseif playerPoolIndex == 6 then
			pm_roll = pmp_superh
		elseif playerPoolIndex == 7 then
			pm_roll = pmp_metalgear
		elseif playerPoolIndex == 8 then
			pm_roll = pmp_zelda
		end
		if pm_roll != nil then
			GAMEMODE.playermodel = table.Random(pm_roll)
		else
			print("Error TTT_APMP_server: unknown player model pool")
		end
	end
	print("INFO TTT_APMP_server: roll for this round is " .. GAMEMODE.playermodel)
end)
