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

--print("DEBUG TTT_APMP_client loaded")
include ("../data/ttt_apmp_shared.lua")
CreateClientConVar("TTT_APMP_selected", 1, true, true, "TTT player model pool selection; is evaluated by the server")  -- Send choice to server
CreateConVar("TTT_APMP_selected_display_text", "TTT default")
CreateConVar("TTT_APMP_PREVIEW_NUM", 1)

local lastGroupElection = nil
net.Receive("TTT_APMP_ELECTIONS_MSG", function()
  lastGroupElection = net.ReadString()
  --print("DEBUG received "..lastGroupElection)
  lastGroupElection = util.JSONToTable(lastGroupElection)
  --print("DEBUG TTT_APMP_client table is:")
  --print(table.ToString(lastGroupElection))
end)

local function checkConVars()
  -- test if TTT_APMP_selected_display_text still matches the persistent TTT_APMP_selected index
  local pmp_selected_index = GetConVar("TTT_APMP_selected"):GetInt()
  if pmp_selected_index > 1 then
    if pmp_selected_index > #pmp+1 then
      RunConsoleCommand("TTT_APMP_selected_display_text", "TTT default")
      RunConsoleCommand("TTT_APMP_selected", 1)
      pmp_selected_index = 1
    elseif pmp[pmp_selected_index-1][1] != GetConVar("TTT_APMP_selected_display_text"):GetString() then
      RunConsoleCommand("TTT_APMP_selected_display_text", pmp[pmp_selected_index-1][1])
      print("INFO TTT_APMP_client sel mismatch: corrected TTT_APMP_selected_display_text to TTT_APMP_selected")
    end
  end
end

local function getGroupDisplayNames(i)
  if i>1 then
    if lastGroupElection == nil then
      return pmp[i-1][1]
    else
      return "( got "..lastGroupElection[i][2].." votes) "..pmp[i-1][1]
    end
  else
    if lastGroupElection == nil then
      return "TTT default"
    else
      return "( got "..lastGroupElection[1][2].." votes) ".."TTT default"
    end
  end
end

--hook to TTTSettingsTabs: add Player Model tab to settings menu
hook.Add("TTTSettingsTabs", "ttt advanced player model pool client settings panel", function(dtabs)
  if pmp ~= nil then
    print("DEBUG TTT_APMP_client: Player model tab added to settings")
    checkConVars()
    local lastSelectedModelGroup = GetConVar("TTT_APMP_selected"):GetInt()
    local lastValidModelIndex = GetConVar("TTT_APMP_PREVIEW_NUM"):GetInt()

    local ttt_defaultmodels = {"models/player/phoenix.mdl","models/player/arctic.mdl","models/player/guerilla.mdl","models/player/leet.mdl"}  -- ttt_defaultmodels taken from shared.lua

    local DPanelList = vgui.Create("DPanelList", dtabs)
    DPanelList:StretchToParent(0, 0, dtabs:GetPadding()*2, 0)
    DPanelList:EnableVerticalScrollbar(false)
    DPanelList:SetPadding(10)
    DPanelList:SetSpacing(10)

-- PM group selection
    local DFormPMSel = vgui.Create("DForm", DPanelList)
    DFormPMSel:SetName("Player model group selection")
    local DComboBoxGroups = DFormPMSel:ComboBox("Player Model Pool", "TTT_APMP_selected_display_text")
    DComboBoxGroups:SetTooltip("vote for a player model group")
    DComboBoxGroups:SetSortItems(false)

    DComboBoxGroups:AddChoice(getGroupDisplayNames(1))
    for i=2,#pmp+1 do
      DComboBoxGroups:AddChoice(getGroupDisplayNames(i))
    end

    DPanelList:AddItem(DFormPMSel)

-- Model Group Preview
    local DFormPreview = vgui.Create("DForm", DPanelList)
    DFormPreview:SetName("Preview of your selected models")
    local modelNumber
    if lastSelectedModelGroup > 1 then
      modelNumber = DFormPreview:NumSlider("Model number", "TTT_APMP_PREVIEW_NUM", 1, #pmp[lastSelectedModelGroup-1][2], 0)
    else
      modelNumber = DFormPreview:NumSlider("Model number", "TTT_APMP_PREVIEW_NUM", 1, 4, 0)   -- default TTT val
    end
    modelNumber:SetDefaultValue(1)
    DPanelList:AddItem(DFormPreview)

    local DPanelPreview = vgui.Create("DModelPanel")
    function DPanelPreview:LayoutEntity( Entity ) return end	-- Disable cam rotation
    function DPanelPreview:TryToSetModel()   -- wraper to set our models properly
      local mdl = nil
      if lastSelectedModelGroup == 1 then
        mdl = ttt_defaultmodels[lastValidModelIndex]
        if mdl ~= nil then
          self:SetModel(mdl)
        else
          print("ERROR: model from default TTT group was nil")
          return
        end
      else
        mdl = pmp[lastSelectedModelGroup-1][2][lastValidModelIndex]
        if mdl ~= nil then
          self:SetModel(mdl)
        else
          print("ERROR: apmp["..(lastSelectedModelGroup-1).."][2]["..lastValidModelIndex.."] was nil")
          return
        end
      end
      -- center model in preview
      local headpos = self.Entity:GetBonePosition( self.Entity:LookupBone( "ValveBiped.Bip01_Spine" ) )
      self:SetLookAt( headpos+Vector(0,0,3) )
      self:SetCamPos( headpos-Vector(-115,0,0) )	-- Move cam away
    end
    DPanelPreview:SetSize(218,218)
    DPanelPreview:TryToSetModel()

    DPanelList:AddItem(DPanelPreview)

-- on select and value changed methods
    DComboBoxGroups.OnSelect = function(panel, index, value)
      RunConsoleCommand("TTT_APMP_selected_display_text", value)
      RunConsoleCommand("TTT_APMP_selected", index)
      lastSelectedModelGroup = index
      --print("DEBUG TTT_APMP_client DFormPMSel: value: "..value..", index: "..index)

      if index > 1 then
        modelNumber:SetMax(#pmp[index-1][2])
      else
        modelNumber:SetMax(4)
      end
      modelNumber:ResetToDefaultValue()
      DPanelPreview:TryToSetModel()
    end

    function modelNumber:OnValueChanged(val)
      -- this nasty thing is called even when val has only changed by 0.0001
      if val-math.floor(val)<0.5 then
        val = math.floor(val)
      else
        val = math.ceil(val)
      end
      modelNumber:SetValue(val)

      if lastValidModelIndex != val then
        --print("DEBUG: Model number changed from "..lastValidModelIndex.." to "..val..", lastSelectedModelGroup is "..lastSelectedModelGroup)
        lastValidModelIndex = val
        DPanelPreview:TryToSetModel()
      end
    end

    dtabs:AddSheet("Player Model", DPanelList, "icon16/user.png", false, false, "Make or change your vote for a player model group")
  end
end)
