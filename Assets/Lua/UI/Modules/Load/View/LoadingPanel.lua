LoadingPanel = class("LoadingPanel",UIPanel)

local this = LoadingPanel

function this:Init(...)
    self.sprite_loading = self:GetSprite(0)
end

function this:Open(...)
    this.base.Open(self,...)
    if(self._tweener)then
        return
    end
    self.sprite_loading._transform.localRotation = Quaternion.Euler(0, 0, 0)
    self._tweener = self.sprite_loading._transform:DORotate(Vector3(0, 0, -180),0.7,DG.Tweening.RotateMode.Fast)
    self._tweener:SetLoops(-1)
    self._tweener:SetEase(DG.Tweening.Ease.Linear)
end

function this:Close(...)
    this.base.Close(self,...)
    if(self._tweener)then
        self._tweener:Kill(false)
        self._tweener = nil
    end
end