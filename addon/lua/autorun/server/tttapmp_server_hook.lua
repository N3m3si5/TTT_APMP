--[[ Copyright and license:
Copyright 2018 Christian Luca Lützenkirchen
This file is part of the AddOn "Advanced Player Model Pool" (TTT_APMP) for
"Trouble in Terrorist Town" (a "Garry's Mod" game mode).

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
--AddCSLuaFile("../data/ttt_apmp_shared.lua") this does not seem to work... for now in shared conf itself!!!
include ("../data/ttt_apmp_shared.lua")
CreateConVar("ttt_pmodel", "default")
-- Net Library: https://wiki.garrysmod.com/page/Net_Library_Usage
-- set message name for net Library:
util.AddNetworkString("TTT_APMP_NET_MSG")

--[[
local pmp_config = nil
local function conf_File_IO()
	if file.Exists("ttt_apmp_conf.txt", "DATA") then
		-- read to conf
		pmp_config = file.Read("ttt_apmp_conf.txt", "DATA")
	else
		-- write default config
		file.Write("ttt_apmp_conf.txt", util.TableToJSON(pmp_zelda))
	end
end
]]

-- hook to Initialize to do initial stuff on map load as well
hook.Add("Initialize", "TTT_APMP assosiated maps with player model pools",  function()
	--conf_File_IO()
-- PlayerModelPools that are assosiated with certain maps
-- TODO reimplement to new structure
--[[	local ttt_pmodel_maps = {["ttt_outset_island"] = "zelda",
		["ttt_lttp_kakariko_a4"] = "zelda",
		["ttt_lostwoods"] = "zelda",
		["ttt_hyrulecastle"] = "zelda",
		["ttt_clocktown_swsw"] = "zelda"}
	if ttt_pmodel_maps[game.GetMap()] ~= nil then
		print("DEBUG: current map is assosiated with a player model pool!\n\t=> setting ttt_pmodel to " .. ttt_pmodel_maps[game.GetMap()] )
		RunConsoleCommand("ttt_pmodel", ttt_pmodel_maps[game.GetMap()] )
		print("DEBUG ttt_pmodel is " .. GetConVar("ttt_pmodel"):GetString() )
	end]]
end)

-- Send available player model groups to connecting clients
hook.Add("PlayerInitialSpawn", "TTT_APMP send pm list to player", function(ply)
	print("DEBUG TTT_APMP_server, sending available pm groups to player "..ply:Nick())
	net.Start("TTT_APMP_NET_MSG")
	-- write a message to client, for later use
	net.WriteString("dummy msg from srv to client")
	net.Send(ply)
end)

-- function evaluatePlayerModelPool returns the player model group with most votes
-- TODO this function is very ugly... tidy up soon!
-- might https://wiki.garrysmod.com/page/Tables:_Bad_Habits help?
local function evaluatePlayerModelPool()
	local results = {} -- will take two elemented tables as elements: first is the pm-group-index, second is the vote amount for this group
	for i=1,#pmp+1 do
		local buf = {i,0}
		table.insert(results, buf)
	end

	for k,ply in ipairs(player.GetHumans()) do
		local plyVote = ply:GetInfoNum("TTT_APMP_selected", 1)
		results[plyVote][2] = results[plyVote][2]+1
		print("DEBUG TTT_APMP_server evaluatePlayerModelPool loop: results["..plyVote.."][2]="..results[plyVote][2])
	end

	local mostVotes = 0
	for i=1,#results do
		if mostVotes<results[i][2] then
			mostVotes=results[i][2]
		end
	end

	for i=#results,1,-1 do
		--print("DEBUG DEBUG tabele "..table.ToString(results))
		if results[i][2]~=mostVotes then
			table.remove(results, i)
		end
	end

	return (table.Random(results)[1])
end

-- hook to TTTPrepareRound: set global TTT pmodel
hook.Add("TTTPrepareRound", "TTT_APMP core function",  function()
	if pmp ~= nil then
		local playerPoolIndex = evaluatePlayerModelPool()
		print("DeBUG TTT_APMP_server: result of evaluatePlayerModelPool: ".. playerPoolIndex)
		-- 1 is the default ttt group, so our first group starts with index 2
		if playerPoolIndex != 1 then
			local pm_roll = pmp[playerPoolIndex-1][2]	-- -1: resolve the shift mentioned above
			if pm_roll != nil then
				GAMEMODE.playermodel = table.Random(pm_roll)
			else
				print("Error TTT_APMP_server: unknown player model pool")
			end
		end
		print("INFO TTT_APMP_server: roll for this round is " .. GAMEMODE.playermodel)
	end
end)
