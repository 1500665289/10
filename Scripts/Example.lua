local tbExample = GameMain:NewMod("Example");

function tbExample:OnInit()
    print("Example init");
end

function tbExample:OnEnter()
    print("Example enter");
    
    -- 获取物品定义（添加错误检查）
    local itemdef = ThingMgr:GetDef(2, "Item_ModTestItem");
    if itemdef then
        print("Item name:", itemdef.ThingName);
    else
        print("Warning: Item_ModTestItem not found");
    end
    
    -- 窗口测试（添加错误检查）
    local windowsMod = GameMain:GetMod("Windows");
    if windowsMod then
        local sampleWindow = windowsMod:GetWindow("SampleWindow");
        if sampleWindow then
            sampleWindow:Show();
        else
            print("Warning: SampleWindow not found");
        end
    else
        print("Warning: Windows mod not found");
    end
end

function tbExample:OnSetHotKey()
    print("Example OnSetHotKey");
    
    local tbHotKey = {
        {
            ID = "Test",
            Name = "Mod测试按键",
            Type = "Mod",
            InitialKey1 = "LeftShift+A",
            InitialKey2 = "Equals"
        }
    };
    
    return tbHotKey;
end

function tbExample:OnHotKey(ID, state)
    if ID == "Test" then
        if state == "down" then
            print("=========== Test is down =============");
            -- 在这里添加按下热键时要执行的逻辑
        elseif state == "stay" then
            -- 按键持续按下的处理（如果需要）
        elseif state == "up" then
            print("=========== Test is up =============");
            -- 按键释放的处理（如果需要）
        end
    end
    -- 可以添加其他热键的处理
end

function tbExample:OnStep(dt)
    -- 谨慎处理step逻辑，避免影响游戏性能
    -- print("Example Step"..dt);
end

function tbExample:OnLeave()
    print("Example Leave");
end

function tbExample:OnSave()
    print("Example OnSave");
    -- 返回纯粹的KV结构
    local tbSave = {
        a = 1,
        b = 2,
        c = "aa"
    };
    return tbSave;
end

function tbExample:OnLoad(tbLoad)
    print("Example OnLoad");
    tbLoad = tbLoad or {a = 0, b = 0};
    print("Loaded data - a:", tbLoad.a, "b:", tbLoad.b, "c:", tbLoad.c or "nil");
end

function tbExample:Test(a, b)
    return a + b;
end

-- 演示代码（在实际MOD中应该注释或移除）
--[[
print("=== Module Access Demo ===");
local tbTest = GameMain:GetMod("Example");
if tbTest ~= nil then
    print("Test method result:", tbTest:Test(1, 3));
else
    print("Example mod not found");
end
--]]