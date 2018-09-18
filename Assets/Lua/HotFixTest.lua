local panel = UISystem.GetPanel(PanelName.Loading)
if(panel)then
    UISystem.CloseLoading()
else
    UISystem.OpenLoading()
end
