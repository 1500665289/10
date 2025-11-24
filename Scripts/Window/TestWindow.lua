local SimpleWindow = GameMain:GetMod("SimpleWindow");
local tbWindow = SimpleWindow:CreateWindow("TestWindow");

function tbWindow:OnInit()
    -- 创建UI内容
    self.window.contentPane = UIPackage.CreateObject("TestUI", "NewWindow");
    
    -- 安全检查
    if not self.window.contentPane then
        print("Error: Failed to create window content pane")
        return false
    end
    
    -- 设置窗口属性
    self:SetTitle("窗口测试")
    self:SetSize(500, 500)
    
    -- 添加按钮
    self:AddButton("Bnt1", "Test", 100, 50)
    self:AddButton("Bnt2", "Test2", 100, 100)
    
    -- 设置HTML内容（修正引号问题）
    self:SetHtml([[
        <a href='xxx'>link text</a><br>
        <input type='button' value='标题' name='BntHtml'/><br>
        <p align='center'></p>
    ]])
    
    return true
end

function tbWindow:OnShowUpdate()
    -- 窗口显示时的更新逻辑
end

function tbWindow:OnShown()
    -- 窗口显示完成后的逻辑
end

function tbWindow:OnUpdate()
    -- 每帧更新逻辑
end

function tbWindow:OnHide()
    -- 窗口隐藏时的清理逻辑
end

-- 事件处理函数
function tbWindow:OnObjectEvent(t, obj, context)
    -- 参数安全检查
    if obj == nil then
        print("Warning: obj is nil in event", t)
        return
    end
    
    print("Event:", t, "Object:", obj.name)
    
    -- 处理不同事件类型
    if t == "onClick" then
        local name = obj.name or "Unknown"
        world:ShowMsgBox(name .. " Clicked", "onClick")
        
        -- 根据按钮名称处理不同逻辑
        if name == "Bnt1" then
            -- Bnt1的特殊处理
            print("Bnt1 clicked")
        elseif name == "Bnt2" then
            -- Bnt2的特殊处理
            print("Bnt2 clicked")
        elseif name == "BntHtml" then
            -- HTML按钮的处理
            print("HTML button clicked")
        end
        
    elseif t == "onClickLink" then
        local linkData = context.data or "No data"
        world:ShowMsgBox(linkData .. " Link Clicked", "onClickLink")
        print("Link clicked:", linkData)
        
    elseif t == "onRightClick" then
        print("Right click on:", obj.name)
        
    elseif t == "onKeyDown" then
        print("Key down event on:", obj.name)
    end
end