TweenTestPanel = class("TweenTestPanel",TestPanel)

local this = TweenTestPanel

function this:Init(go,...)
    this.base.Init(self,...)
    self.circle = self:GetSprite(3)
end

function this:AfterInit()
    this.base.AfterInit(self)
    -- self._optionPool:Get():SetContent("算法动画 - 函数曲线"):GetButton():SetClickCB(function()  end)
    -- self._optionPool:Get():SetContent("重置"):GetButton():SetClickCB(function() self:ResetCircle() end)
    -- self._optionPool:Get():SetContent("线性（基于帧）"):GetButton():SetClickCB(function() self:L1() end)
    -- self._optionPool:Get():SetContent("线性（基于时间）"):GetButton():SetClickCB(function() self:L2() end)
    -- self._optionPool:Get():SetContent("加速运动"):GetButton():SetClickCB(function() self:L3() end)
    -- self._optionPool:Get():SetContent("函数曲线 Sin"):GetButton():SetClickCB(function() self:L4() end)
    -- self._optionPool:Get():SetContent("2^-10x + cos(x*20)"):GetButton():SetClickCB(function() self:L5() end)
    -- self._optionPool:Get():SetContent("-x+1 + cos(x*20)"):GetButton():SetClickCB(function() self:L6() end)

    self._optionPool:Get():SetContent("缓动算法"):GetButton():SetClickCB(function()      if(self.tweener)then
        self.tweener:Kill(false)
        self.tweener = nil
    end
end)

    -- self._optionPool:Get():SetContent("Linear"):GetButton():SetClickCB(function() self:TweenerTest(TweenType.Linear)  end)
    -- self._optionPool:Get():SetContent("InQuad"):GetButton():SetClickCB(function() self:TweenerTest(TweenType.InQuad)  end)
    -- self._optionPool:Get():SetContent("OutQuad"):GetButton():SetClickCB(function() self:TweenerTest(TweenType.OutQuad)  end)
    -- self._optionPool:Get():SetContent("InOutQuad"):GetButton():SetClickCB(function() self:TweenerTest(TweenType.InOutQuad)  end)

    for key,value in pairs(TweenName)do
        self._optionPool:Get():SetContent(value):GetButton():SetClickCB(function() self:TweenerTest(key)  end)
    end
end

function this:TweenerTest(type)
    if(self.tweener)then
        self.tweener:Kill(false)
        self.tweener = nil
    end

    self.tweener = Tween.Do(function() return self.circle:GetAnchoredPosition().x end,
                    function(val) return self.circle:SetAnchoredPosition(val) end,
                    50,
                    700,
                    3,
                    type)

    self.tweener:Start()
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

