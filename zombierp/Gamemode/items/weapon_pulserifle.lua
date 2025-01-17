local ITEM = {}
local WEAPON = {}


ITEM.ID = "wep_pulserifle"

ITEM.Name = "PAR-War Pulse Rifle"
ITEM.ClassSpawn = "None"
ITEM.Scrap = 20
ITEM.Small_Parts = 75
ITEM.Chemicals = 30
ITEM.Chance = 100
ITEM.Info = "Special pulse batteries."
ITEM.Type = "weapon"
ITEM.Remove = true
ITEM.Energy = 25
ITEM.Ent = "weapon_pnrp_pulserifle"
ITEM.Model = "models/weapons/w_IRifle.mdl"
ITEM.Script = ""
ITEM.Weight = 7
ITEM.ShopHide = true

WEAPON.ID = ITEM.ID
WEAPON.AmmoType = "ar2"

function ITEM.ToolCheck( p )
	return true
end

function ITEM.Use( ply )
	local WepName = "weapon_pnrp_pulserifle"
	local gotWep = false
	for k, v in pairs(ply:GetWeapons()) do
		if v:GetClass() == WepName then gotWep = true end
	end
	if gotWep == false then 
		ply:Give(WepName) 
		ply:GetWeapon(WepName):SetClip1(0)
		return true
	else
		ply:ChatPrint("Weapon already equipped.")
		return false
	end
end

function ITEM.Create( ply, class, pos )
	local ent = ents.Create("ent_weapon")
	--ent:SetNetworkedInt("Ammo", self.Energy)
	ent:SetNetVar("WepClass", ITEM.Ent)
	ent:SetModel(ITEM.Model)
	ent:SetAngles(Angle(0,0,0))
	ent:SetPos(pos)
	ent:Spawn()
	
	return ent
end

PNRP.AddItem(ITEM)
PNRP.AddWeapon(WEAPON)