---------------------------------------------------------------------------------------------
-- AsphyxiaUI
---------------------------------------------------------------------------------------------

local S, C, L, G = unpack( Tukui )

local width, height, showParty, showRaid, showPlayer, xOffset, yOffset, point, columnSpacing, columnAnchorPoint

if( C["global"]["unitframelayout"] == "asphyxia" or C["global"]["unitframelayout"] == "asphyxia2" or C["global"]["unitframelayout"] == "asphyxia3" or C["global"]["unitframelayout"] == "asphyxia4" ) then
	print("raid layout: asphyxia")

	width = S.Scale( 69 * C["unitframes"]["gridscale"] * S.raidscale )
	height = S.Scale( 20 * C["unitframes"]["gridscale"] * S.raidscale )
	showParty = true
	showRaid = true
	showPlayer = true
	xOffset = S.Scale( 7 )
	yOffset = S.Scale( -5 )
	point = "LEFT"
	columnSpacing = S.Scale( 4 )
	columnAnchorPoint = "TOP"

elseif( C["global"]["unitframelayout"] == "duffed" or C["global"]["unitframelayout"] == "duffed2" or C["global"]["unitframelayout"] == "merith" or C["global"]["unitframelayout"] == "merith2" ) then
	print("raid layout: duffed")

	width = 68
	height = 32
	showParty = true
	showRaid = true
	showPlayer = true
	xOffset = 7
	yOffset = -5
	point = "LEFT"
	columnSpacing = 5
	columnAnchorPoint = "TOP"

elseif( C["global"]["unitframelayout"] == "jasje" ) then
	print("raid layout: jasje")

	width = 68
	height = 32
	showParty = true
	showRaid = true
	showPlayer = true
	xOffset = 7
	yOffset = -5
	point = "LEFT"
	columnSpacing = 5
	columnAnchorPoint = "TOP"

elseif( C["global"]["unitframelayout"] == "sinaris" ) then
	print("raid layout: sinaris")

elseif( C["global"]["unitframelayout"] == "smelly" ) then
	print("raid layout: smelly")

end

S.RaidFrameAttributes = function()
	return
		"TukuiRaid",
		nil,
		"solo,raid,party",
		"oUF-initialConfigFunction", [[
			local header = self:GetParent()
			self:SetWidth( header:GetAttribute( "initial-width" ) )
			self:SetHeight( header:GetAttribute( "initial-height" ) )
		]],
		"initial-width", S.Scale( width * C["unitframes"].gridscale * S.raidscale ),
		"initial-height", S.Scale( height * C["unitframes"].gridscale * S.raidscale ),
		"showParty", true,
		"showRaid", true,
		"showPlayer", true,
		"showSolo", true,
		"xoffset", S.Scale( 3 ),
		"yOffset", S.Scale( -3 ),
		"point", point,
		"groupFilter", "1,2,3,4,5,6,7,8",
		"groupingOrder", "1,2,3,4,5,6,7,8",
		"groupBy", "GROUP",
		"maxColumns", 8,
		"unitsPerColumn", 5,
		"columnSpacing", S.Scale( columnSpacing ),
		"columnAnchorPoint", columnAnchorPoint
end

S.PostUpdateRaidUnit = function( self )
	if( C["global"]["unitframelayout"] == "asphyxia" or C["global"]["unitframelayout"] == "asphyxia2" or C["global"]["unitframelayout"] == "asphyxia3" or C["global"]["unitframelayout"] == "asphyxia4" ) then
		print("raid layout: asphyxia")

		------------------------------
		-- misc
		------------------------------
		self.panel:Kill()
		self:SetBackdropColor( 0.0, 0.0, 0.0, 0.0 )
		self.Power:Kill()

		------------------------------
		-- health
		------------------------------
		self.Health:ClearAllPoints()
		self.Health:SetAllPoints( self )
		self.Health:SetStatusBarTexture( C["media"]["normal"] )
		self.Health:CreateBorder( true )

		self.Health.colorDisconnected = false
		self.Health.colorClass = false
		self.Health:SetStatusBarColor( 0.2, 0.2, 0.2, 1 )
		self.Health.bg:SetTexture( 0.6, 0.6, 0.6 )
		self.Health.bg:SetVertexColor( 0, 0, 0 )

		self.Health.value:Point( "CENTER", self.Health, 1, -5 )
		self.Health.value:SetFont( S.CreateFontString() )

		if( C["unitframes"]["unicolor"] == true ) then
			self.Health.colorDisconnected = false
			self.Health.colorClass = false
			self.Health:SetStatusBarColor( 0.150, 0.150, 0.150, 1 )
			self.Health.bg:SetVertexColor( 0, 0, 0, 1 )
		else
			self.Health.colorDisconnected = true
			self.Health.colorClass = true
			self.Health.colorReaction = true
		end

		if( C["unitframes"]["gradienthealth"] == true and C["unitframes"]["unicolor"] == true ) then
			self:HookScript( "OnEnter", function( self )
				if( not UnitIsConnected( self.unit ) or UnitIsDead( self.unit ) or UnitIsGhost( self.unit ) ) then return end
				local hover = RAID_CLASS_COLORS[select( 2, UnitClass( self.unit ) )]
				if( not hover ) then return end
				self.Health:SetStatusBarColor( hover.r, hover.g, hover.b )
			end)

			self:HookScript( "OnLeave", function( self )
				if( not UnitIsConnected( self.unit ) or UnitIsDead( self.unit ) or UnitIsGhost( self.unit ) ) then return end
				local r, g, b = oUFTukui.ColorGradient( UnitHealth( self.unit ) / UnitHealthMax( self.unit ), unpack( C["unitframes"]["gradient"] ) )
				self.Health:SetStatusBarColor( r, g, b )
			end )
		end

		------------------------------
		-- name
		------------------------------
		self.Name:SetParent( self.Health )
		self.Name:ClearAllPoints()
		self.Name:SetPoint( "TOP", 0, 8 )
		self.Name:SetPoint( "BOTTOM" )
		self.Name:SetPoint( "LEFT", 4, 0 )
		self.Name:SetPoint( "RIGHT" )
		self.Name:SetShadowOffset( 1.25, -1.25 )
		self.Name:SetFont( S.CreateFontString() )

		------------------------------
		-- debuffs
		------------------------------
		if( C["unitframes"]["raidunitdebuffwatch"] == true ) then
			self.RaidDebuffs:Height( 21 * C["unitframes"]["gridscale"] )
			self.RaidDebuffs:Width( 21 * C["unitframes"]["gridscale"] )
			self.RaidDebuffs:Point( "CENTER", self.Health, 2, 1 )

			self.RaidDebuffs.count:ClearAllPoints()
			self.RaidDebuffs.count:SetPoint( "CENTER", self.Raiddebuff, -6, 6 )
			self.RaidDebuffs.count:SetFont( S.CreateFontString() )

			self.RaidDebuffs.time:ClearAllPoints()
			self.RaidDebuffs.time:SetPoint( "CENTER", self.Raiddebuff, 2, 0 )
			self.RaidDebuffs.time:SetFont( S.CreateFontString() )
		end

		------------------------------
		-- icons
		------------------------------
		local leader = self.Health:CreateTexture( nil, "OVERLAY" )
		leader:Height( 12 * S.raidscale )
		leader:Width( 12 * S.raidscale )
		leader:SetPoint( "TOPLEFT", 0, 6 )
		self.Leader = leader

		local LFDRole = self.Health:CreateTexture( nil, "OVERLAY" )
		LFDRole:Height( 15 * S.raidscale )
		LFDRole:Width( 15 * S.raidscale )
		LFDRole:Point( "TOP", 0, 10 )
		LFDRole:SetTexture( "Interface\\AddOns\\Tukui\\medias\\textures\\lfdicons.blp" )
		self.LFDRole = LFDRole

		local MasterLooter = self.Health:CreateTexture( nil, "OVERLAY" )
		MasterLooter:Height( 12 * S.raidscale )
		MasterLooter:Width( 12 * S.raidscale )
		self.MasterLooter = MasterLooter
		self:RegisterEvent( "PARTY_LEADER_CHANGED", S.MLAnchorUpdate )
		self:RegisterEvent( "PARTY_MEMBERS_CHANGED", S.MLAnchorUpdate )

		local Resurrect = CreateFrame( "Frame", nil, self.Health )
		Resurrect:SetFrameLevel( self.Health:GetFrameLevel() + 1 )
		Resurrect:Size( 20 )
		Resurrect:SetPoint( "CENTER" )

		local ResurrectIcon = Resurrect:CreateTexture( nil, "OVERLAY" )
		ResurrectIcon:SetAllPoints()
		ResurrectIcon:SetDrawLayer( "OVERLAY", 7 )
		self.ResurrectIcon = ResurrectIcon

	elseif( C["global"]["unitframelayout"] == "duffed" or C["global"]["unitframelayout"] == "duffed2" or C["global"]["unitframelayout"] == "merith" or C["global"]["unitframelayout"] == "merith2" ) then
		print("raid layout: duffed")

	elseif( C["global"]["unitframelayout"] == "jasje" ) then
		print("raid layout: jasje")

		------------------------------
		-- misc
		------------------------------
		self.panel:Kill()
		self:SetBackdropColor( 0.0, 0.0, 0.0, 0.0 )

		------------------------------
		-- health
		------------------------------
		self.Health:ClearAllPoints()
		self.Health:SetAllPoints( self )
		self.Health:SetStatusBarTexture( C["media"]["glamour"] )
		self.Health:CreateBorder()

		self.Health.colorDisconnected = false
		self.Health.colorClass = false
		self.Health:SetStatusBarColor( 0.2, 0.2, 0.2, 1 )
		self.Health.bg:SetTexture( 0.6, 0.6, 0.6 )
		self.Health.bg:SetVertexColor( 0, 0, 0 )

		self.Health.value:Point( "CENTER", self.Health, 1, -5 )
		self.Health.value:SetFont( S.CreateFontString() )

		self.Health.Smooth = true

		------------------------------
		-- power
		------------------------------
		self.Power:ClearAllPoints()
		self.Power:Height( 1 )
		self.Power:CreateBorder()
		self.Power:Point( "BOTTOMLEFT", self.Health, "BOTTOMLEFT", 4, 4 )
		self.Power:Point( "BOTTOMRIGHT", self.Health, "BOTTOMRIGHT", -4, 4 )
		self.Power:SetStatusBarTexture( C["media"]["glamour"] )
		self.Power:SetFrameLevel( self.Health:GetFrameLevel() + 1 )

		self.Power.bg:SetAllPoints( self.Power )
		self.Power.bg:SetTexture( C["media"]["glamour"] )
		self.Power.bg:SetAlpha( 1 )
		self.Power.bg.multiplier = 0.4
		self.Power.colorClass = true
		self.Power.bg.multiplier = 0.1

		self.Power.Smooth = true

		------------------------------
		-- name
		------------------------------
		self.Name:SetParent( self.Health )
		self.Name:ClearAllPoints()
		self.Name:SetPoint( "TOP", 0, -5 )
		self.Name:SetFont( S.CreateFontString() )

		------------------------------
		-- debuffs
		------------------------------
		self.RaidDebuffs.count:ClearAllPoints()
		self.RaidDebuffs.count:SetPoint( "CENTER", self.Raiddebuff, -6, 6 )
		self.RaidDebuffs.count:SetFont( S.CreateFontString() )

		self.RaidDebuffs.time:ClearAllPoints()
		self.RaidDebuffs.time:SetPoint( "CENTER", self.Raiddebuff, 2, 0 )
		self.RaidDebuffs.time:SetFont( S.CreateFontString() )

		------------------------------
		-- icons
		------------------------------
		local Resurrect = CreateFrame( "Frame", nil, self.Health )
		Resurrect:SetFrameLevel( self.Health:GetFrameLevel() + 1 )
		Resurrect:Size( 20 )
		Resurrect:SetPoint( "CENTER" )

		local ResurrectIcon = Resurrect:CreateTexture( nil, "OVERLAY" )
		ResurrectIcon:SetAllPoints()
		ResurrectIcon:SetDrawLayer( "OVERLAY", 7 )
		self.ResurrectIcon = ResurrectIcon

	elseif( C["global"]["unitframelayout"] == "sinaris" ) then
		print("raid layout: sinaris")

	end
end

local AsphyxiaUIRaidPosition = CreateFrame( "Frame" )
AsphyxiaUIRaidPosition:RegisterEvent( "PLAYER_LOGIN" )
AsphyxiaUIRaidPosition:SetScript( "OnEvent", function( self, event )
	local raid = G.UnitFrames.RaidUnits
	local pets = G.UnitFrames.RaidPets
	raid:ClearAllPoints()

	if( C["global"]["unitframelayout"] == "asphyxia" or C["global"]["unitframelayout"] == "asphyxia2" or C["global"]["unitframelayout"] == "asphyxia3" or C["global"]["unitframelayout"] == "asphyxia4" ) then
		print("raid layout: asphyxia")

		raid:SetPoint( "BOTTOMLEFT", TukuiChatBackgroundLeft, "TOPLEFT", 2, 14 )
	
	elseif( C["global"]["unitframelayout"] == "duffed" or C["global"]["unitframelayout"] == "duffed2" or C["global"]["unitframelayout"] == "merith" or C["global"]["unitframelayout"] == "merith2" ) then
		print("raid layout: duffed")
	
	elseif( C["global"]["unitframelayout"] == "jasje" ) then
		print("raid layout: jasje")
	
		raid:SetPoint( "CENTER", UIParent, "CENTER", -250, 20 )
	
	elseif( C["global"]["unitframelayout"] == "sinaris" ) then
		print("raid layout: sinaris")
	
	elseif( C["global"]["unitframelayout"] == "smelly" ) then
		print("raid layout: smelly")
	
	end
end )