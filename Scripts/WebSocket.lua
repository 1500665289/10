local tbTable = GameMain:GetMod("TestWebSocket");

function tbTable:OnEnter()		
    -- 可以选择在这里或需要时启动
    -- self:Start()
end

function tbTable:Start()
    -- 检查是否已存在连接
    if self.ws ~= nil then
        print("WebSocket already exists, closing previous connection...")
        self:CloseWebSocket()
    end
    
    self.ws = CS.WebSocketSharp.WebSocket("ws://localhost:8080/socket")
    
    -- 保存回调引用以便后续清理
    self.messageCallback = function(obj, e)
        self:OnMessage(obj, e)
    end
    
    self.openCallback = function(obj, e)
        self:OnOpen(obj, e)
    end
    
    self.closeCallback = function(obj, e)
        self:OnClose(obj, e)
    end
    
    self.errorCallback = function(obj, e)
        self:OnError(obj, e)
    end
    
    -- 绑定事件
    self.ws:OnMessage("+", self.messageCallback)
    self.ws:OnOpen("+", self.openCallback)
    self.ws:OnClose("+", self.closeCallback)
    self.ws:OnError("+", self.errorCallback)
    
    print("Connecting to WebSocket...")
    self.ws:Connect()
end

function tbTable:OnMessage(obj, e)
    print("OnMessage: "..tostring(e.Data))
    
    -- 可以在这里处理接收到的消息
    -- 例如：解析JSON、更新UI、触发游戏事件等
end

function tbTable:OnOpen(obj, e)
    print("OnOpen: WebSocket connection established")
    
    -- 连接建立后发送初始消息
    self.ws:SendString("Hello Server from GameMain")
end

function tbTable:OnClose(obj, e)
    print("OnClose: WebSocket connection closed")
    print("Close reason: "..tostring(e.Reason))
    
    -- 清理资源
    self.ws = nil
    self.messageCallback = nil
    self.openCallback = nil
    self.closeCallback = nil
    self.errorCallback = nil
end

function tbTable:OnError(obj, e)
    print("OnError: "..tostring(e.Message))
    
    -- 可以在这里处理错误，比如重连逻辑
end

function tbTable:SendMessage(message)
    if self.ws == nil then
        print("Error: WebSocket is not connected")
        return false
    end
    
    if self.ws.ReadyState ~= CS.WebSocketSharp.WebSocketState.Open then
        print("Error: WebSocket is not in open state")
        return false
    end
    
    self.ws:SendString(message)
    return true
end

function tbTable:CloseWebSocket()
    if self.ws == nil then
        return
    end
    
    -- 移除事件监听
    if self.messageCallback then
        self.ws:OnMessage("-", self.messageCallback)
    end
    if self.openCallback then
        self.ws:OnOpen("-", self.openCallback)
    end
    if self.closeCallback then
        self.ws:OnClose("-", self.closeCallback)
    end