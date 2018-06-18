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
print("INFO TTT_APMP: client loaded")
CreateClientConVar("TTT_APMP_selected", 1, false, true, "TTT player model pool selection; is evaluated by the server")  -- Send choice to server
CreateConVar("TTT_APMP_selected_display_text", "")

hook.Add("TTTSettingsTabs", "ttt advanced player model pool client settings panel", function(dtabs)
  print("DEBUG: settings tab function hook called")

  local DPanelList = vgui.Create("DPanelList", dtabs)
  DPanelList:StretchToParent(0,0,padding,0)
  DPanelList:EnableVerticalScrollbar(true)
  DPanelList:SetPadding(10)
  DPanelList:SetSpacing(10)

  local cb = nil

  local DFormPMSel = vgui.Create("DForm", DPanelList)
  DFormPMSel:SetName("Player model group selection")
  cb = DFormPMSel:ComboBox("Player Model Pool", "TTT_APMP_selected_display_text")
  cb:SetTooltip("select your wanted player model pool")
  cb:SetSortItems(false)
  cb:AddChoice("")
  -- hard coded choices (TODO)
  cb:AddChoice("male")
  cb:AddChoice("female")
  cb:AddChoice("Anime (male)")
  cb:AddChoice("Anime (female)")
  cb:AddChoice("Super Heroes")
  cb:AddChoice("Metal Gear")
  cb:AddChoice("Zelda")
  cb.OnSelect = function(panel, index, value)
    RunConsoleCommand("TTT_APMP_selected_display_text", value)
    RunConsoleCommand("TTT_APMP_selected", index) -- for now we simply send the index to the server
    print("DEBUG DFormPMSel: value: "..value..", index: "..index)
  end
  DPanelList:AddItem(DFormPMSel)

  local DFormPreview = vgui.Create("DForm", DPanelList)
  DFormPreview:SetName("Preview of your selected models (coming soon)")
  DPanelList:AddItem(DFormPreview)

  dtabs:AddSheet("Player Model", DPanelList, "icon16/gun.png", false, false, "Select your vote for one player model group and send it to the server")
end)
