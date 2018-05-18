local T, C, L = select(2, ...):unpack()
local ObjectiveTracker = CreateFrame("Frame", "TukuiObjectiveTracker", UIParent)
local Misc = T["Miscellaneous"]
local Movers = T["Movers"]

-- Lib Globals
local _G = _G
local unpack = unpack
local select = select

-- WoW Globals
local ObjectiveTrackerFrame = ObjectiveTrackerFrame
local ObjectiveTrackerFrameHeaderMenuMinimizeButton = ObjectiveTrackerFrame.HeaderMenu.MinimizeButton
local SCENARIO_CONTENT_TRACKER_MODULE = SCENARIO_CONTENT_TRACKER_MODULE
local QUEST_TRACKER_MODULE = QUEST_TRACKER_MODULE
local WORLD_QUEST_TRACKER_MODULE = WORLD_QUEST_TRACKER_MODULE
local DEFAULT_OBJECTIVE_TRACKER_MODULE = DEFAULT_OBJECTIVE_TRACKER_MODULE
local BONUS_OBJECTIVE_TRACKER_MODULE = BONUS_OBJECTIVE_TRACKER_MODULE
local SCENARIO_TRACKER_MODULE = SCENARIO_TRACKER_MODULE

-- Locals
local Class = select(2, UnitClass("player"))
local CustomClassColor = T.Colors.class[Class]

function ObjectiveTracker:Disable()
	ObjectiveTrackerFrameHeaderMenuMinimizeButton:Hide()
end

function ObjectiveTracker:OnEnter()
	--self:SetFadeInTemplate(1, 1)
	self.Backdrop.Border:SetBackdropBorderColor(unpack(CustomClassColor))
end

function ObjectiveTracker:OnLeave()
	--self:SetFadeOutTemplate(1, 0)
	self.Backdrop.Border:SetBackdropBorderColor(unpack(C.General.BorderColor))
end

function ObjectiveTracker:OnClick()
	if (ObjectiveTrackerFrame:IsVisible()) then
		ObjectiveTrackerFrame:Hide()
		
		self.Texture:Point("CENTER", self, 2, 0)
		self.Texture:SetTexture(C.Medias.PowerArrowLeft)
	else
		ObjectiveTrackerFrame:Show()
		
		self.Texture:Point("CENTER", self, -2, 0)
		self.Texture:SetTexture(C.Medias.PowerArrowRight)
	end
end

function ObjectiveTracker:CreateToggleButtons()
	local Button = CreateFrame("Button", nil, UIParent)
	Button:Size(16, 352)
	Button:Point("RIGHT", UIParent, -6, 0)
	Button:CreateBackdrop()
	Button:CreateShadow()
	Button:SetAlpha(0)
	
	Button:RegisterForClicks("AnyUp")
	Button:SetScript("OnClick", self.OnClick)
	Button:SetScript("OnEnter", self.OnEnter)
	Button:SetScript("OnLeave", self.OnLeave)
	
	Button.Texture = Button:CreateTexture(nil, "OVERLAY")
	Button.Texture:Size(14, 14)
	Button.Texture:Point("CENTER", Button, 2, 0)
	Button.Texture:SetVertexColor(unpack(CustomClassColor))
	Button.Texture:SetTexture(C.Medias.PowerArrowLeft)
end

function ObjectiveTracker:SetDefaultPosition()
	local GetTop = ObjectiveTrackerFrame:GetTop() or 0
	local ScreenHeight = GetScreenHeight()
	local GapFromTop = ScreenHeight - GetTop
	local MaxHeight = ScreenHeight - GapFromTop
	local SetObjectiveFrameHeight = min(MaxHeight, 480)

	local ObjectiveFrameHolder = CreateFrame("Frame", nil, UIParent)
	ObjectiveFrameHolder:Size(130, 22)
	ObjectiveFrameHolder:Point("TOPRIGHT", UIParent, -342, -342)

	ObjectiveTrackerFrame:ClearAllPoints()
	ObjectiveTrackerFrame:Point("TOP", ObjectiveFrameHolder)
	ObjectiveTrackerFrame:Height(SetObjectiveFrameHeight)

	hooksecurefunc(ObjectiveTrackerFrame, "SetPoint", function(_,_, Parent)
		if (Parent ~= ObjectiveFrameHolder) then
			ObjectiveTrackerFrame:ClearAllPoints()
			ObjectiveTrackerFrame:Point("TOP", ObjectiveFrameHolder, 0, 0)
		end
	end)
end

function ObjectiveTracker:Skin()
	local Frame = ObjectiveTrackerFrame.MODULES

	if (Frame) then
		for i = 1, #Frame do
		
			local Modules = Frame[i]
			if (Modules) then
				local Header = Modules.Header
				Header:SetFrameStrata("HIGH")
				Header:SetFrameLevel(10)
				
				local Background = Modules.Header.Background
				Background:SetAtlas(nil)
			
				local Text = Modules.Header.Text
				Text:SetFont(C.Medias.Font, 16)
				Text:SetDrawLayer("OVERLAY", 7)
				Text:SetParent(Header)

				if not (Modules.IsSkinned) then			
					local HeaderPanel = CreateFrame("Frame", nil, Header)
					HeaderPanel:SetFrameLevel(Header:GetFrameLevel() - 1)
					HeaderPanel:SetFrameStrata("BACKGROUND")
					HeaderPanel:SetOutside(Header, 1, 1)

					local HeaderBar = CreateFrame("StatusBar", nil, HeaderPanel)
					HeaderBar:Size(232, 4)
					HeaderBar:Point("CENTER", HeaderPanel, -6, -9)
					HeaderBar:SetStatusBarTexture(C.Medias.Blank)
					HeaderBar:SetStatusBarColor(unpack(CustomClassColor))
					HeaderBar:SetTemplate()
					
					HeaderBar:CreateShadow()
					
					Modules.IsSkinned = true
				end
			end
		end
	end
end

function ObjectiveTracker:SkinScenario()
	local StageBlock = _G["ScenarioStageBlock"]
	
	StageBlock.NormalBG:SetTexture("")
	
	StageBlock.FinalBG:SetTexture("")
	StageBlock.Stage:SetFont(C.Medias.Font, 17)
	StageBlock.GlowTexture:SetTexture("")
end

function ObjectiveTracker:UpdateQuestItem(block)
	local QuestItemButton = block.itemButton
	
	if (QuestItemButton) then
		local Icon = QuestItemButton.icon
		local Count = QuestItemButton.Count
	
		if not (QuestItemButton.IsSkinned) then
			QuestItemButton:Size(26, 26)
			QuestItemButton:SetTemplate()
			QuestItemButton:CreateShadow()
			QuestItemButton:StyleButton()
			QuestItemButton:SetShadowOverlay(26, 26)
			QuestItemButton:SetNormalTexture(nil)
			
			if (Icon) then
				Icon:SetTexCoord(.08, .92, .08, .92)
			end
		
			if (Count) then
				Count:ClearAllPoints()
				Count:Point("BOTTOMRIGHT", QuestItemButton, 0, 3)
				Count:SetFont(C.Medias.Font, 12)
			end

			QuestItemButton.IsSkinned = true
		end
	end
end
	
function ObjectiveTracker:UpdateProgressBar(_, line) 
	local Progress = line.ProgressBar
	local Bar = Progress.Bar
	
	if (Bar) then
		local Label = Bar.Label
		local Icon = Bar.Icon
		local IconBG = Bar.IconBG
		local Backdrop = Bar.BarBG
		local Glow = Bar.BarGlow
		local Sheen = Bar.Sheen
		local Frame = Bar.BarFrame
		local Frame2 = Bar.BarFrame2
		local Frame3 = Bar.BarFrame3
		local BorderLeft = Bar.BorderLeft
		local BorderRight = Bar.BorderRight
		local BorderMid = Bar.BorderMid
	
		if not (Bar.IsSkinned) then
			if (Backdrop) then Backdrop:Hide() Backdrop:SetAlpha(0) end
			if (IconBG) then IconBG:Hide() IconBG:SetAlpha(0) end
			if (Glow) then Glow:Hide() end
			if (Sheen) then Sheen:Hide() end
			if (Frame) then Frame:Hide() end
			if (Frame2) then Frame2:Hide() end
			if (Frame3) then Frame3:Hide() end
			if (BorderLeft) then BorderLeft:SetAlpha(0) end
			if (BorderRight) then BorderRight:SetAlpha(0) end
			if (BorderMid) then BorderMid:SetAlpha(0) end
	
			Bar:Height(20)
			Bar:SetStatusBarTexture(C.Medias.Blank)
			Bar:CreateBackdrop()
			Bar.Backdrop:CreateShadow()
			Bar.Backdrop:SetFrameStrata("BACKGROUND")
			Bar.Backdrop:SetFrameLevel(1)
			Bar.Backdrop:SetOutside(Bar)

			if (Label) then
				Label:ClearAllPoints()
				Label:Point("CENTER", Bar, 0, 0)
				Label:SetFont(C.Medias.Font, 12)
			end
	
			if (Icon) then
				Icon:Size(20, 20)
				Icon:SetMask("")
				Icon:SetTexCoord(.08, .92, .08, .92)
				Icon:ClearAllPoints()
				Icon:Point("RIGHT", Bar, 26, 0)
		
				if not (Bar.NewBorder) then
					Bar.NewBorder = CreateFrame("Frame", nil, Bar)
					Bar.NewBorder:SetTemplate()
					Bar.NewBorder:CreateShadow()
					Bar.NewBorder:SetOutside(Icon)
					Bar.NewBorder:SetShown(Icon:IsShown())
				end
			end
		
			Bar.IsSkinned = true
		elseif (Icon and Bar.NewBorder) then
			Bar.NewBorder:SetShown(Icon:IsShown())
		end
	end
end

function ObjectiveTracker:UpdateProgressBarColors(Min)
	if (self.Bar and Min) then		
		local R, G, B = T.ColorGradient(Min, 100, 0.8, 0, 0, 0.8, 0.8, 0, 0, 0.8, 0)
		self.Bar:SetStatusBarColor(R, G, B)
	end
end

local function SkinGroupFindButton(block)
	local HasGroupFinderButton = block.hasGroupFinderButton
	local GroupFinderButton = block.groupFinderButton

	if (HasGroupFinderButton and GroupFinderButton) then
		if not (GroupFinderButton.IsSkinned) then
			GroupFinderButton:SkinButton()
			GroupFinderButton:Size(18)
	
			GroupFinderButton.IsSkinned = true
		end
	end
end

local function UpdatePositions(block)
	local GroupFinderButton = block.groupFinderButton
	local ItemButton = block.itemButton

	if (ItemButton) then
		local PointA, PointB, PointC, PointD, PointE = ItemButton:GetPoint()
		ItemButton:Point(PointA, PointB, PointC, -6, -1)
	end
	
	if (GroupFinderButton) then
		local GPointA, GPointB, GPointC, GPointD, GPointE = GroupFinderButton:GetPoint()
		GroupFinderButton:Point(GPointA, GPointB, GPointC, -262, -4)
	end
end

function ObjectiveTracker:AddHooks()
	hooksecurefunc("ObjectiveTracker_Update", self.Skin)
	hooksecurefunc("ScenarioBlocksFrame_OnLoad", self.SkinScenario)
	hooksecurefunc(SCENARIO_CONTENT_TRACKER_MODULE, "Update", self.SkinScenario)
	hooksecurefunc(QUEST_TRACKER_MODULE, "SetBlockHeader", self.UpdateQuestItem)
	hooksecurefunc(WORLD_QUEST_TRACKER_MODULE, "AddObjective", self.UpdateQuestItem)
	hooksecurefunc(DEFAULT_OBJECTIVE_TRACKER_MODULE, "AddProgressBar", self.UpdateProgressBar)
	hooksecurefunc(BONUS_OBJECTIVE_TRACKER_MODULE, "AddProgressBar", self.UpdateProgressBar)
	hooksecurefunc(WORLD_QUEST_TRACKER_MODULE, "AddProgressBar", self.UpdateProgressBar)
	hooksecurefunc(SCENARIO_TRACKER_MODULE, "AddProgressBar", self.UpdateProgressBar)
	hooksecurefunc("BonusObjectiveTrackerProgressBar_SetValue", self.UpdateProgressBarColors)
	hooksecurefunc("ObjectiveTrackerProgressBar_SetValue", self.UpdateProgressBarColors)
	hooksecurefunc("ScenarioTrackerProgressBar_SetValue", self.UpdateProgressBarColors)
	hooksecurefunc("QuestObjectiveSetupBlockButton_FindGroup", SkinGroupFindButton)
	hooksecurefunc("QuestObjectiveSetupBlockButton_AddRightButton", UpdatePositions)
end

function ObjectiveTracker:Enable()
	self:AddHooks()
	self:Disable()
	self:CreateToggleButtons()
	self:SetDefaultPosition()
	self:SkinScenario()
end

Misc.ObjectiveTracker = ObjectiveTracker