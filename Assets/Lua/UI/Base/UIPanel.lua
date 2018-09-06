require "UI/Base/UIView"

UIPanel = class("UIPanel",UIView)

local this = UIPanel

function this:ctor(go,...)
    this.base.ctor(self,go,...)
end