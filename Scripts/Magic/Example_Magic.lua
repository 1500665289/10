--演示神通
local tbTable = GameMain:GetMod("MagicHelper");
local tbMagic = tbTable:GetMagic("Example_Magic");
local g_emPlantKind = CS.XiaWorld.g_emPlantKind;

function tbMagic:Init()
end

function tbMagic:EnableCheck(npc)
    return true;
end

function tbMagic:TargetCheck(k, t)	
    return true;
end

function tbMagic:MagicEnter(IDs, IsThing)
    self.curIndex = 0;
    self.jump = 0;
    self.grids = IDs;
end

function tbMagic:MagicStep(dt, duration)
    -- 添加安全检查
    if self.grids == nil then
        return -1;
    end
    
    self:SetProgress(self.curIndex / self.grids.Count);
    self.jump = self.jump + dt;
    
    if self.jump >= 0.1 then
        local key = self.grids[self.curIndex];
        if self:CreateMine(key) then
            self.jump = 0;
        end
        
        self.curIndex = self.curIndex + 1;
        
        if self.curIndex >= self.grids.Count then
            return 1;
        end
    end
    return 0;
end

function tbMagic:MagicLeave(success)
    if success == true then
        world:ShowStoryBox("成功施展了演示神通", "演示神通", {"我懂了","我没懂"},
            function(s)
                if s == 0 then
                    return nil;
                end
                return "再看看吧";
            end
        );
    end
    self.grids = nil;
end

function tbMagic:OnGetSaveData()
    return {
        Index = self.curIndex or 0,
        Jump = self.jump or 0
    };
end

function tbMagic:OnLoadData(tbData, IDs, IsThing)
    self.grids = IDs;
    self.curIndex = tbData.Index or 0;
    self.jump = tbData.Jump or 0;
    
    -- 数据完整性检查
    if self.curIndex < 0 then self.curIndex = 0 end
    if self.jump < 0 then self.jump = 0 end
end

function tbMagic:CreateMine(key)
    if Map:CheckGridWalkAble(key, false) == false then
        return false;
    end
    
    local Things = Map.Things;
    
    -- 检查建筑
    local oldbuilding = Things:GetThingAtGrid(key, 4);
    if oldbuilding ~= nil then
        return false;
    end
    
    -- 检查植物
    local oldplant = Things:GetThingAtGrid(key, 3);
    if oldplant ~= nil then
        if oldplant.def.Plant.Kind == g_emPlantKind.Mine then
            return false; -- 已经有矿了
        else
            ThingMgr:RemoveThing(oldplant, false, false); -- 移除其他植物
        end
    end
    
    -- 处理物品
    local olditem = Things:GetThingAtGrid(key, 2);
    if olditem ~= nil then
        olditem:PickUp();
        Map:DropItem(olditem, key);
    end
    
    -- 创建矿
    ThingMgr:AddPlantThing(key, "RockBrown", nil);
    world:PlayEffect(34, key, 5);
    return true;
end