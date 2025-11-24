local Windows = GameMain:GetMod("Windows");
local tbWindow = Windows:CreateWindow("SampleWindow");

-- 定义局部函数（推荐方案）
local function OnClick(context)
    print('you click', context)
    world:ShowMsgBox(context.sender.name.." Clicked","onClick");
end

local function ClickSelectItem(context)
    print('you click', context)
    if context.data then
        world:ShowMsgBox(context.data.title.." Clicked","onClick");
    else
        world:ShowMsgBox("Item Clicked","onClick");
    end
end

function tbWindow:OnInit()
    -- 创建UI内容
    self.window.contentPane = UIPackage.CreateObject("Sample", "SampleWindow");
    
    -- 安全检查
    if not self.window.contentPane then
        print("Error: Failed to create window content pane")
        return false
    end
    
    -- 获取关闭按钮
    local frame = self:GetChild("frame")
    if frame then
        self.window.closeButton = frame:GetChild("n5")
    end
    
    -- 按钮1
    local bnt1 = self:GetChild("bnt_1");
    if bnt1 then
        bnt1.onClick:Add(OnClick);
    else
        print("Warning: bnt_1 not found")
    end
    
    -- 按钮2
    local bnt2 = self:GetChild("bnt_2");
    if bnt2 then
        bnt2.onClick:Add(OnClick);
    else
        print("Warning: bnt_2 not found")
    end
    
    -- 按钮3
    local bnt3 = self:GetChild("bnt_3");
    if bnt3 then
        bnt3.onClick:Add(OnClick);
        bnt3.icon = "Spr/Object/object_test.png";
    else
        print("Warning: bnt_3 not found")
    end
    
    -- 图片加载器
    local loader = self:GetChild("loader");
    if loader then
        loader.url = "Spr/Building/building_test.png";
    end
    
    -- 标签
    local label = self:GetChild("label_1");
    if label then
        label.text = "这也是一个[color=#FF0000]Label[/color]";
    end
    
    -- 列表
    local list = self:GetChild("list");
    if list then
        for i = 1, 20 do
            local item = list:AddItemFromPool();
            if item then
                item.icon = "thing://2,Item_SmallBell,Item_IronBlock";		
                item.title = "物品"..i;
                item.tooltips = "物品"..i;
            end
        end
        list.onClickItem:Add(ClickSelectItem);
    else
        print("Warning: list not found")
    end
    
    -- 进度条
    self.progressbar = self:GetChild("progressbar_1");
    if not self.progressbar then
        print("Warning: progressbar_1 not found")
    end
    
    return true
end

function tbWindow:OnShowUpdate()
    -- 窗口显示时的更新逻辑
end

function tbWindow:OnShown()
    -- 窗口完全显示后的逻辑
end

function tbWindow:OnUpdate(dt)
    -- 更新进度条
    if self.progressbar then
        local v = self.progressbar.value + 20 * dt;
        if v > 100 then
            v = 0;
        end
        self.progressbar.value = v;
    end
end

function tbWindow:OnHide()
    -- 窗口隐藏时的清理逻辑
end