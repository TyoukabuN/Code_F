
ResourceUtilty = class("ResourceUtilty")

Res = ResourceUtilty

Res.Load = function(path,type)
    local obj = ResourceManager.Load(path, typeof(GameObject))
    return Res.Instantiate(obj)
end

Res.LoadAsync = function(path,type,callback)
    local afterLoad = function(obj)
        if(obj == nil)then
            return
        end

        local gobj = Res.Instantiate(obj)
        if(callback and gobj ~= nil)then
            callback(obj)
        end
    end

    ResourceManager.LoadAsync(path, typeof(GameObject),afterLoad)
Res.

Res.Instantiate = function(asset)
    local gobj = GameObject.Instantiate(asset)
    if(not gobj)then
        Debug.LogError("failed to instantiate asset")
        return
    end

    gobj.name = asset.name

    return gobj
end