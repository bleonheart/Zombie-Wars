local ITEM = {}


ITEM.ID = "tool_radar"

ITEM.Name = "Wastelander Radar"
ITEM.ClassSpawn = "Wastelander"
ITEM.Scrap = 250
ITEM.Small_Parts = 175
ITEM.Chemicals = 75
ITEM.Chance = 100
ITEM.Info = "The SCXU 8034. The machine that goes... Ping!"
ITEM.Type = "tool"
ITEM.Remove = true
ITEM.Energy = 0
ITEM.Ent = "tool_radar"
ITEM.Model = "models/props_mining/antlion_detector.mdl"
ITEM.Script = ""
ITEM.Weight = 15

function ITEM.ToolCheck( p )
	-- This one returns required items.
	return {["intm_hudint"]=1, ["intm_elecboard"]=2, ["intm_servo"]=1}
end

function ITEM.Create( ply, class, pos )	
	local ent = ents.Create(class)
	ent:SetAngles(Angle(0,0,0))
	ent:SetPos(pos)
	ent:Spawn()
	ent:Activate()
	--ent:SetNetworkedString("Owner", ply:Nick())
	PNRP.SetOwner(ply, ent)
	
	PNRP.AddWorldCache( ply,ITEM.ID )
end


function ITEM.Use( ply )
	return true	
end


PNRP.AddItem(ITEM)