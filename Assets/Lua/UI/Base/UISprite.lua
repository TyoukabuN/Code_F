--------------------------------------------------------
--Copyright (C)
--版本      : 1.0
--作者      : 
--创始日期  : 2017年5月3日11:44:42
--功能描述  : UI图形类
--------------------------------------------------------
require "UI/Base/UIBase"

UISprite = class("UISprite", UIBase)
--缓存加载的图片
UISprite.SpriteCaches = {}
UISprite.defauleIcon = nil

local quality2heximagepath = 
{
	[1] = "UI/Common/Sprite/XZK",
	[2] = "UI/Common/Sprite/XZK_L",
	[3] = "UI/Common/Sprite/XZK_Z",
	[4] = "UI/Common/Sprite/XZK_C",
	[5] = "UI/Common/Sprite/XZK_H",
}

UISprite.ConstUI = 
{
	"UI/Common/Sprite",
	"UI/Icon",
	"UI/MessageFrame/Sprite",
	"UI/Bubble/Sprite",
	"UI/XGNKQ/Sprite",
	"UI/Main/Sprite",
	"UI/Hud/Sprite",
}

function UISprite:ctor(obj)
	UISprite.base.ctor(self, obj)
	--加载默认图片
	-- if not UISprite.defauleIcon then
	-- 	UISprite.defauleIcon = ResMgr:Load("UI/Icon/DefaultIcon", typeof(Sprite))
	-- end
end

-- 动态设置图片
function UISprite:SetSprite(sprite)
	local image = self._gameObject:GetComponent("Image")
	if image and sprite then
		image.sprite = sprite
	end
end

function UISprite.LoadSprite(path)
	local sprite = UISprite.SpriteCaches[path]
	if not sprite then
		sprite = ResMgr:Load(path, typeof(Sprite))
		if not sprite then
			sprite = UISprite.defauleIcon
		end

		local flg = false
		for i,v in ipairs(UISprite.ConstUI) do
		 	if string.find(path, v) then
		 		flg = true
		 		break
		 	end
		end
		if flg then
			UISprite.SpriteCaches[path] = sprite
		end
	end
	return sprite
end

--设置Sprite
--path Sprite路径
function UISprite:SetSpriteByPath(path)
	if self.spritePath ~= nil and path == self.spritePath then
		return
	end

	local sprite = UISprite.LoadSprite(path)
	self:SetSprite(sprite)
	self.spritePath = path
end

-- 设置玩家头像
function UISprite:SetPlayerIcon(iconId)
	local conf = LuaConfig_avatar[iconId]
	if conf then
		self:SetSpriteByPath(conf.asset)		
	end
end

--20180620 设置货币图标 id:货币类型
function UISprite:SetFunctionIcon(id)
	self:SetSpriteByPath("UI/Icon/icon_flag_" .. id)
end

-- 物品图片显示接口
function UISprite:SetItemSprite(itemtype, itemid)
	if self.itemtype ~= nil and self.itemtype == itemtype and self.itemid == itemid then
		return
	end

	local path = ConfigUtils.GetItemSpritePath(itemtype, itemid)
	self.itemtype = itemtype
	self.itemid = itemid
	self:SetSpriteByPath(path)
end

-- 物品品质框接口
function UISprite:SetItemQualityColor(quality)
	if self.quality ~= nil and self.quality == quality then
		return
	end

	local color = ConfigUtils.GetItemQualityColor(quality)
	self:SetColor(color)
	self.quality = quality
end

-- 物品品质框接口
function UISprite:SetItemQuality(quality)
	if self.quality ~= nil and self.quality == quality then
		return
	end

	local path = quality2heximagepath[quality]
	self:SetSpriteByPath(path)
	self.quality = quality
end

--设置Sprite颜色
function UISprite:SetColor(color)
	if self.color ~= nil and self.color == color then
		return
	end

	local image = self._gameObject:GetComponent("Image")
	if image then
		image.color = color
	end
	self.color = color
end

--是否响应事件
function UISprite:SetRaycastTarget(flg)
	if self.raycast ~= nil and self.raycast == flg then
		return
	end

	local image = self._gameObject:GetComponent("Image")
	if image then
		image.raycastTarget = flg
	end

	self.raycast = flg
end

--设置FillAmount
function UISprite:SetFillAmount(vol)
	if self.fillAmount ~= nil and self.fillAmount == vol then
		return
	end

	local image = self._gameObject:GetComponent("Image")
	if image and type(vol) == "number" then
		image.fillAmount = vol-vol%0.0000001
	end
	self.fillAmount = vol
end

--获取FillAmount 2018年7月11日16:45:30 zjw
function UISprite:GetFillAmount()
	if self.fillAmount ~= nil then
		return self.fillAmount
	end
	local image = self._gameObject:GetComponent("Image")
	if image then
		self.fillAmount = image.fillAmount
	end
	return self.fillAmount
end

--取得Image组件
function UISprite:GetImage()
	return self._gameObject:GetComponent("Image")--self._image
end

--设置图像等比宽度	--2018年6月26日19:49:02 zjw
function UISprite:SetImageWidth(width)
	local image = self:GetImage()
	if(image==nil)then
		return false
	end
	image:SetNativeSize()
	local ratio = image.transform.sizeDelta.y / image.transform.sizeDelta.x
	image.transform.sizeDelta = Vector2.New(width, width * ratio)
	return true
end

--设置图像等比高度	--2018年6月26日19:49:02 zjw
function UISprite:SetImageHeight(height)
	local image = self:GetImage()
	if(image==nil)then
		return false
	end
	image:SetNativeSize()
	local ratio = image.transform.sizeDelta.x / image.transform.sizeDelta.y
	image.transform.sizeDelta = Vector2.New(height * ratio, height)
	return true
end



function UISprite:SetNativeSize()
	local image = self:GetImage()
	if(image==nil)then
		return false
	end
	image:SetNativeSize()
end
