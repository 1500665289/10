--演示神通
local tbTable = GameMain:GetMod("MagicHelper");
local tbMagic = tbTable:GetMagic("Example_Magic2");

local _Scale = 5;--放大倍数

function tbMagic:Init()
end

--神通是否可用
function tbMagic:EnableCheck(npc)
    return true;
end

--目标合法检测 
--key: 位置key或对象ID
--t: 目标对象
function tbMagic:TargetCheck(key, t)	
    if t == nil or t.ThingType ~= CS.XiaWorld.g_emThingType.Npc then
        return false;
    end
    if t.IsDeath == true then
        return false;
    end
    if t.Race.RaceType ~= CS.XiaWorld.g_emNpcRaceType.Animal then
        return false;
    end
    return true;
end

--开始施展神通
function tbMagic:MagicEnter(IDs, IsThing)
    if IDs == nil or IDs.Count == 0 then
        return;
    end
    self.targetId = IDs[1]; -- Lua数组索引从1开始
end

--神通施展过程中，需要返回值
--返回值  0继续 1成功并结束 -1失败并结束
function tbMagic:MagicStep(dt, duration)	
    local castTime = self.magic.Param1 or 5.0; -- 默认5秒
    self:SetProgress(duration / castTime);
    if duration >= castTime then
        return 1;	
    end
    return 0;
end

--施展完成/失败 success是否成功
function tbMagic:MagicLeave(success)
    if success == true then		
        if self.targetId == nil then
            return;
        end
        local target = ThingMgr:FindThingByID(self.targetId);
        if target ~= nil and not target:IsDeath() then
            target.ScaleAddIM = target.ScaleAddIM + _Scale;
            print("成功放大目标体型");
        end
    end	
end

--存档 如果没有返回空 有就返回Table(KV)
function tbMagic:OnGetSaveData()
    if self.targetId == nil then
        return nil;
    end
    return {
        targetId = self.targetId
    };
end

--读档 tbData是存档数据 IDs和IsThing同进入
function tbMagic:OnLoadData(tbData, IDs, IsThing)	
    if IDs == nil or IDs.Count == 0 then
        return;
    end
    self.targetId = IDs[1]; -- Lua数组索引从1开始
    
    -- 如果存档中有数据，也尝试读取
    if tbData and tbData.targetId then
        self.targetId = tbData.targetId;
    end
end