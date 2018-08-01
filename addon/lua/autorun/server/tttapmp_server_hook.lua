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

--print("DEBUG TTT_APMP_server loaded")
--AddCSLuaFile("../data/ttt_apmp_shared.lua") this does not seem to work... for now in shared conf itself!!!
include ("../data/ttt_apmp_shared.lua")
CreateConVar("TTT_APMP_INDICES_WA", "")
-- set message name for net Library (https://wiki.garrysmod.com/page/Net_Library_Usage):
util.AddNetworkString("TTT_APMP_ELECTIONS_MSG")


local function tooManyIndicesWorkAround()
	if pmp_indices_workaround ~= nil then
		if GAMEMODE.playermodel ~= GetConVar("TTT_APMP_INDICES_WA"):GetString() then		-- player model has changed
			--print("DEBUG TTT_APMP_server: to-many-indices-workaround, a change...")
			if pmp_indices_workaround[GAMEMODE.playermodel] ~= nil and pmp_indices_workaround[GetConVar("TTT_APMP_INDICES_WA"):GetString()] == nil then
				print("DEBUG TTT_APMP_server: apply to-many-indices-workaround")
				for i,v in ipairs(player.GetHumans()) do
					v:SendLua("RunConsoleCommand('r_drawmodeldecals', 0)")
				end
			elseif pmp_indices_workaround[GAMEMODE.playermodel] == nil and pmp_indices_workaround[GetConVar("TTT_APMP_INDICES_WA"):GetString()] ~= nil then
				print("DEBUG TTT_APMP_server: undo to-many-indices-workaround")
				for i,v in ipairs(player.GetHumans()) do
					v:SendLua("RunConsoleCommand('r_drawmodeldecals', 1)")
				end
			end
			RunConsoleCommand("TTT_APMP_INDICES_WA", GAMEMODE.playermodel)		-- save plaver model to compare to in next round
		end
	end
end

-- function evaluatePlayerModelPool returns the player model group with most votes
-- TODO this function is very ugly... tidy up soon!
-- might https://wiki.garrysmod.com/page/Tables:_Bad_Habits help?
local function evaluatePlayerModelPool()
	local buf	-- used multiple times
	local results = {} -- will take two elemented tables as elements: first is the pm-group-index, second is the vote amount for this group
	for i=1,#pmp+1 do
		buf = {i,0}
		table.insert(results, buf)
	end

	for k,v in ipairs(player.GetHumans()) do
		buf = v:GetInfoNum("TTT_APMP_selected", 1)
		results[buf][2] = results[buf][2]+1
		--print("DEBUG TTT_APMP_server evaluatePlayerModelPool loop: results["..buf.."][2]="..results[buf][2])
	end

	-- send results to players (transitional implementation (TODO reimplement))
	net.Start("TTT_APMP_ELECTIONS_MSG")
	net.WriteString(util.TableToJSON(results))
	net.Broadcast()

	-- find group with most votes
	buf = 0
	for i=1,#results do
		if buf<results[i][2] then
			buf=results[i][2]
		end
	end

	-- reducing results to winner(s)
	for i=#results,1,-1 do
		if results[i][2]~=buf then
			table.remove(results, i)
		end
	end
	return (table.Random(results)[1])
end

-- hook to TTTPrepareRound: set global TTT pmodel
hook.Add("TTTPrepareRound", "TTT_APMP core function",  function()
	if pmp ~= nil then
		local pmp_winner = evaluatePlayerModelPool()
		print("INFO TTT_APMP_server: result of evaluatePlayerModelPool: ".. pmp_winner)
		-- 1 is the default ttt group, so our first group starts with index 2
		if pmp_winner != 1 then
			local pm_roll = pmp[pmp_winner-1][2]	-- -1: resolve the shift mentioned above
			if pm_roll != nil then
				GAMEMODE.playermodel = table.Random(pm_roll)
				tooManyIndicesWorkAround()
			else
				print("Error TTT_APMP_server: unknown player model pool")
			end
		end
		print("INFO TTT_APMP_server: roll for this round is " .. GAMEMODE.playermodel)
	end
end)

hook.Add("PlayerInitialSpawn", "TTT_APMP too many indices workaround at firt time connect",  function(ply)
	if pmp_indices_workaround ~= nil then
		if pmp_indices_workaround[GAMEMODE.playermodel] ~= nil then
			ply:SendLua("RunConsoleCommand('r_drawmodeldecals', 0)")
		end
	end
end)
