local ITEM = {}


ITEM.ID = "tool_petpoisoncrab"

ITEM.Name = "Pet Poison Headcrab"
ITEM.ClassSpawn = "All"
ITEM.Scrap = 10
ITEM.Small_Parts = 10
ITEM.Chemicals = 10
ITEM.Chance = 100
ITEM.Info = "A neutered poison headcrab."
ITEM.Type = "misc"
ITEM.Remove = true
ITEM.Energy = 0
ITEM.Ent = "npc_hdvermin_poison"
ITEM.Model = "models/headcrabblack.mdl"
ITEM.Script = ""
ITEM.Weight = 1
ITEM.ShopHide = true

function ITEM.ToolCheck( p )
	return true
end

function ITEM.Create( ply, class, pos )
	local ent = ents.Create(class)
	ent:SetAngles(Angle(0,0,0))
	ent:SetPos(pos)
--	ent:SetModel( "models/headcrabblack.mdl" )
	ent:Spawn()
	
	PNRP.SetOwner(ply, ent)
	
	ent:SetNetVar("name", ply:Nick().."'s Pet Headcrab")
	
	ent:AddRelationship("npc_floor_turret D_LI 99")
	ent:AddRelationship("npc_hdvermin D_LI 99")
	ent:AddRelationship("player D_LI 99")
	
	for k, v in pairs(ents.FindByClass("npc_turret_floor")) do
		v:AddEntityRelationship(ent, D_LI, 99 )
	end
	
	PNRP.AddWorldCache( ply,ITEM.ID )
end

function ITEM.Use( ply )
	return true	
end


PNRP.AddItem(ITEM)