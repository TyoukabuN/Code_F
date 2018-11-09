TweenTestPanel = class("TweenTestPanel",TestPanel)

local this = TweenTestPanel

function this:Init(go,...)
    this.base.Init(self,...)
    self.circle = self:GetSprite(3)
end

function this:AfterInit()
    this.base.AfterInit(self)
    self._optionPool:Get():SetContent("算法动画 - 函数曲线"):GetButton():SetClickCB(function()  end)
    self._optionPool:Get():SetContent("重置"):GetButton():SetClickCB(function() self:ResetCircle() end)
    self._optionPool:Get():SetContent("线性（基于帧）"):GetButton():SetClickCB(function() self:L1() end)
    self._optionPool:Get():SetContent("线性（基于时间）"):GetButton():SetClickCB(function() self:L2() end)
    self._optionPool:Get():SetContent("加速运动"):GetButton():SetClickCB(function() self:L3() end)
    self._optionPool:Get():SetContent("函数曲线 Sin"):GetButton():SetClickCB(function() self:L4() end)
    self._optionPool:Get():SetContent("2^-10x + cos(x*20)"):GetButton():SetClickCB(function() self:L5() end)
    self._optionPool:Get():SetContent("-x+1 + cos(x*20)"):GetButton():SetClickCB(function() self:L6() end)
end

--X:50 - 700   Y:980
function this:ResetCircle()
    if(self._updatefunc)then
        DeUpdate(self._updatefunc,self)
        self._updatefunc = nil
    end
    self.circle:SetAnchoredPosition(50,980)
end

function this:L1()
    self:ResetCircle()

    self._updatefunc = function()
        local speed = 2
        self:MoveX(speed)
    end

    EnUpdate(self._updatefunc,self)
end

function this:L2()
    self:ResetCircle()
    self._time = 0
    self._updatefunc = function()
        self._time = self._time + Time.deltaTime
        local x = clamp(map(self._time,0,3,50,700),50,700)
        self:SetX(x)
    end

    EnUpdate(self._updatefunc,self)
end


function this:L3()
    self:ResetCircle()
    self._speed = 0
    self._updatefunc = function()
        local acc = 0.2
        self._speed = self._speed + acc
        local dis = self._speed
        self:MoveX(dis)
    end
    EnUpdate(self._updatefunc,self)
end

function this:L4()
    self:ResetCircle()
    self._time = 0
    local time = 2
    self._updatefunc = function()
        self._time = self._time + Time.deltaTime
        local x = map(self._time,0,time,-1*math.pi/2,math.pi/2)
        x = clamp(map(math.sin(x),-1,1,50,700))
        if(self._time>=time)then
            x = 700
        end
        self:SetX(x)
    end
    EnUpdate(self._updatefunc,self)
end

function this:L5()
    self:ResetCircle()
    local time = 2
    self._time = 0
    self._updatefunc = function()
        self._time = self._time + Time.deltaTime
        if(self._time>=time)then
            self:ClearUpdate()
            return
        end
        local ratio = self._time/time
        local x = map(math.cos(ratio*20) * 2^(-10*ratio),1,0,50,700)
        self.circle:SetAnchoredPosition(x,980)
    end
    EnUpdate(self._updatefunc,self)
end

function this:L6()
    self:ResetCircle()
    local time = 2
    self._time = 0
    self._updatefunc = function()
        self._time = self._time + Time.deltaTime
        if(self._time>=time)then
            self:ClearUpdate()
            return
        end
        local ratio = self._time/time
        local x = map(math.cos(ratio*20) * (-ratio + 1),1,0,50,700)
        self.circle:SetAnchoredPosition(x,980)
    end
    EnUpdate(self._updatefunc,self)
end

function this:ClearUpdate( ... )
    if(self._updatefunc)then
        DeUpdate(self._updatefunc,self)
        self._updatefunc = nil
    end
end

function this:MoveX(val)
    local pox = self.circle:GetAnchoredPosition()
    if(pox.x+val>700)then
        self.circle:SetAnchoredPosition(700,980)
        self:ClearUpdate()
        return
    end

    self.circle:SetAnchoredPosition(pox.x+val,980)
end

function this:SetX(val)
    printc(val)
    local pox = self.circle:GetAnchoredPosition()
    if(pox.x>=700)then
        self.circle:SetAnchoredPosition(700,980)
        -- self:ClearUpdate()
        return
    end

    self.circle:SetAnchoredPosition(val,980)
end

--比例映射
map = function(val,val1_1,val1_2,val2_1,val2_2)
    local x = math.abs(val-val1_1)/math.abs(val1_2-val1_1) * math.abs(val2_2-val2_1)
    x = x + val2_1
    return x
end

--区间限制
clamp = function(value,min,max)
    if(min and value<min)then
        value = min
    end

    if(max and value>max)then
        value = max
    end

    return value
end


