Function init()
    m.buttomImage = m.top.findnode("buttomImage")
    m.buttonTitle = m.top.findnode("buttonTitle")
    m.close = m.top.findnode("close")
End Function


Function OnitemHasFocus(event as object)
    focus = event.getdata()
    if focus = true
        m.buttomImage.backgroundColor = "#FFFFFF"
        m.buttonTitle.color = "#213A64"
        m.close.blendcolor = "#213A64"
    else
        m.buttomImage.backgroundColor = "#213A64"
        m.buttonTitle.color = "#FFFFFF"
        m.close.blendcolor = "#FFFFFF"
    end if
End Function


Function OnContentSet(event as object)
    contentItem = event.getdata()
    m.buttonTitle.text = contentItem.title
End Function


Function onWidthChange()
    m.buttomImage.width = m.top.width
End Function    


Function onHeightChange()
    m.buttomImage.height = m.top.height
    m.buttonTitle.height = m.top.height
End Function