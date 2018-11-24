Tween = class("Tween")

TweenType = {
    Linear = 1,
    InQuad = 2,
    OutQuad = 3,
    InOutQuad = 4,
    InCubic = 5,
    OutCubic = 6,
    InOutCubic = 7,
    InQuart = 8,
    OutQuart = 9,
    InOutQuart = 10,
    InQuint = 8,
    OutQuint = 9,
    InOutQuint = 10,
    InSine = 11,
    OutSine =12,
    InOutSine = 13,
    InExpo = 14,
    OutExpo =15,
    InOutExpo = 16,
    InCirc = 17,
    OutCirc = 18,
    InOutCirc = 19,
    InElastic = 20,
    OutElastic = 21,
    InOutElastic = 22,
    InBack = 23,
    OutBack = 24,
    InOutBack = 25,
    InBounce = 26,
    OutBounce = 27,
    InOutBounce = 28,
}

TweenName = {
    [TweenType.Linear] = "Linear",
    [TweenType.InQuad] = "InQuad",
    [TweenType.OutQuad] = "OutQuad",
    [TweenType.InOutQuad] = "InOutQuad",
    [TweenType.InCubic] = "InCubic",
    [TweenType.OutCubic] = "OutCubic",
    [TweenType.InOutCubic] = "InOutCubic",
    [TweenType.InQuart] = "InQuart",
    [TweenType.OutQuart] = "OutQuart",
    [TweenType.InOutQuart] = "InOutQuart",
    [TweenType.InQuint] = "InQuint",
    [TweenType.OutQuint] = "OutQuint",
    [TweenType.InOutQuint] = "InOutQuint",
    [TweenType.InSine] = "InSine",
    [TweenType.OutSine] = "OutSine",
    [TweenType.InOutSine] = "InOutSine",
    [TweenType.InExpo] = "InExpo",
    [TweenType.OutExpo] = "OutExpo",
    [TweenType.InOutExpo] = "InOutExpo",
    [TweenType.InCirc] = "InCirc",
    [TweenType.OutCirc] = "OutCirc",
    [TweenType.InOutCirc] = "InOutCirc",
    [TweenType.InElastic] = "InElastic",
    [TweenType.OutElastic] = "OutElastic",
    [TweenType.InOutElastic] = "InOutElastic",
    [TweenType.InBack] = "InBack",
    [TweenType.OutBack] = "OutBack",
    [TweenType.InOutBack] = "InOutBack",
    [TweenType.InBounce] = "InBounce",
    [TweenType.OutBounce] = "OutBounce",
    [TweenType.InOutBounce] = "InOutBounce",
}

Tween.GetTweenFunc = function(tweenType)
    tweenType = tweenType or TweenType.Linear

    local pow = math.pow
    local   sqrt = math.sqrt
    local  sin = math.sin
    local  cos = math.cos
    local  PI = math.pi
    local  c1 = 1.70158
    local  c2 = c1 * 1.525
    local  c3 = c1 + 1
    local  c4 =(2 * PI)/ 3
    local  c5 =(2 * PI)/ 4.5

    local bounceOut =function(x)

        local n1 = 7.5625

        local d1 = 2.75

        if(x < 1/d1)then
            return n1*x*x
        elseif(x < 2/d1)then
            return n1*(x-(1.5/d1))*x + 0.75
        elseif(x < 2.5/d1)then
            return n1*(x-(2.25/d1))*x + 0.9375
        else
            return n1*(x-(2.625/d1))*x + 0.984375
        end

    end

    if(tweenType == TweenType.Linear)then
        return function(x) return x end
    end

    if(tweenType == TweenType.InQuad)then
        return function(x) return x^2 end
    end

    if(tweenType == TweenType.OutQuad)then
        return function(x) return 1 - (1-x)^2 end
    end

    if(tweenType == TweenType.InOutQuad)then
        return function(x)
            if(x<=0.5)then
                return 2*x^2
            end
            return 1 - ((-2*x+2)^2)/2
        end
    end

    if(tweenType == TweenType.InCubic)then
        return function(x) return x^3 end
    end

    if(tweenType == TweenType.OutCubic)then
        return function(x) return 1 - (1 - x)^3 end
    end

    if(tweenType == TweenType.InOutCubic)then
        return function(x)
                    if(x<=0.5)then
                        return 4*x^3
                    end
                    return 1 - ((-2*x+2)^3)/2
                end
    end


    if(tweenType == TweenType.InQuart)then
        return function(x) return x^4 end
    end

    if(tweenType == TweenType.OutQuart)then
        return function(x) return 1 - (1 - x)^4 end
    end

    if(tweenType == TweenType.InOutQuart)then
        return function(x)
                    if(x<=0.5)then
                        return 8*x^4
                    end
                    return 1 - ((-2*x+2)^4)/2
                end
    end

    if(tweenType == TweenType.InQuint)then
        return function(x) return x^5 end
    end

    if(tweenType == TweenType.OutQuint)then
        return function(x) return 1 - (1 - x)^5 end
    end

    if(tweenType == TweenType.InOutQuint)then
        return function(x)
                    if(x<=0.5)then
                        return 16*x^5
                    end
                    return 1 - ((-2*x+2)^5)/2
                end
    end

    if(tweenType == TweenType.InSine)then
        return function(x) return 1 - math.cos(x * math.pi/2) end
    end

    if(tweenType == TweenType.OutSine)then
        return function(x) return math.sin(x * math.pi/2) end
    end

    if(tweenType == TweenType.InOutSine)then
        return function(x)  return -(math.cos(math.pi*x)-1)/2 end
    end


    if(tweenType == TweenType.InExpo)then
        return function(x) return 2^(10 * x - 10) end
    end

    if(tweenType == TweenType.OutExpo)then
        return function(x) return 1 - 2^(-10 * x) end
    end

    if(tweenType == TweenType.InOutExpo)then
        return function(x)
                if(x<0.5)then
                    return 2^(10 * x - 6)
                end
                return 1 - 2^(-10 * x + 4)
            end
    end

    if(tweenType == TweenType.InCirc)then
        return function(x) return 1 - math.sqrt(1 -x^2) end
    end

    if(tweenType == TweenType.OutCirc)then
        return function(x) return math.sqrt(1 -(x - 1)^2) end
    end

    if(tweenType == TweenType.InOutCirc)then
        return function(x)
                if(x<0.5)then
                    return (1 - math.sqrt(1 - (2*x)^2))/2
                end
                return (math.sqrt(1 -(-2*x + 2)^2)+1)/2
            end
    end


    if(tweenType == TweenType.InElastic)then
        return function(x) return -(2^(10 * x - 10))* math.sin((x * 10 - 10.75)* c4) end
    end

    if(tweenType == TweenType.OutElastic)then
        return function(x) return (2^(-10 * x))* math.sin((x * 10 - 0.75)* c4) + 1 end
    end

    if(tweenType == TweenType.InOutElastic)then
        return function(x)
                if(x<0.5)then
                    return -(2^(20*x-10))*math.sin((20*x-11.125)*c5)/2
                end
                return (2^(-20*x+10))*math.sin((20*x-11.125)*c5)/2+1
            end
    end


    if(tweenType == TweenType.InBack)then
        return  function(x) return c3 * x^3 - c1 * x^2 end
    end

    if(tweenType == TweenType.OutBack)then
        return function(x) return 1 - c3 * -(x-1)^3 - c1 * -(x-1)^2 end
    end

    if(tweenType == TweenType.InOutBack)then
        return function(x)
                if(x<0.5)then
                    return -(2^(20*x-10))*math.sin((20*x-11.125)*c5)/2
                end
                return (2^(-20*x+10))*math.sin((20*x-11.125)*c5)/2+1
            end
    end


    if(tweenType == TweenType.InBounce)then
        return  function(x) return 1 - bounceOut(1 - x) end
    end

    if(tweenType == TweenType.OutBounce)then
        return function(x) return bounceOut(x) end
    end

    if(tweenType == TweenType.InOutBounce)then
        return function(x)
                if(x<0.5)then
                    return (1 - bounceOut(1 - 2 * x))/ 2
                end
                return (1 + bounceOut(2 * x - 1))/ 2
            end
    end
end

Tween.Do = function(getter,setter,beginVal,endVal,duration,tweenType)
    return Tweener.New(getter,setter,beginVal,endVal,duration,tweenType)
end

Tweener = class("Tweener")
function Tweener:ctor(getter,setter,beginVal,endVal,duration,tweenType)
    self.getter = getter
    self.setter = setter
    self.beginVal = beginVal
    self.endVal = endVal
    self.duration = duration
    self.tweenType = tweenType or TweenType.Linear
    --
    self.func = Tween.GetTweenFunc(self.tweenType)
    self.running = true
    self.counter = 0
    self.curVal = nil
end

function Tweener:SetType(tweenType)
    self.tweenType = tweenType
    self.func = Tween.GetTweenFunc(self.tweenType)
end

function Tweener:Tick()
    if(not self.running)then
        return
    end

    self.counter = self.counter + Time.deltaTime

    self.curVal = map(self.func(clamp(self.counter/self.duration,0,1)),0,1,self.beginVal,self.endVal)

    if(self.setter)then
        self.setter(self.curVal)
    end

    if(self.onUpdateCallback)then
        self.onUpdateCallback(self.curVal)
    end

    if(self.counter>self.duration or self.curVal == self.endVal)then
        self.running = false

        if(self.onCompleteCallback)then
            self.onCompleteCallback()
        end

        DeUpdate(self.Tick,self)
        return
    end
end

function Tweener:OnBegin(callback)
    self.onBeginCallback = callback
end

function Tweener:OnUpdate(callback)
    self.onUpdateCallback = callback
end

function Tweener:OnComplete(callback)
    self.onCompleteCallback = callback
end

function Tweener:Start()
    self:Replay()

    if(self.onBegin)then
        self.onBegin()
    end
end

function Tweener:Replay()
    self.running = true
    self.counter = 0
    EnUpdate(self.Tick,self)
end

function Tweener:Kill(isComplete)
    self.running = false
    DeUpdate(self.Tick,self)

    if(isComplete and self.onCompleteCallback)then
        self.onCompleteCallback()
    end
end
