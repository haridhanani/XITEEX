Function init()
    m.back = m.top.findnode("back")
    m.title = m.top.findnode("title")
    m.buttomImage = m.top.findnode("buttomImage")
    m.top.ObserveField("focusedChild", "OnFocusChange")
End function


Function OnFocusChange(event as object)
    if event.getdata() <> invalid
        m.back.backgroundColor = m.top.focusBackColor
        m.title.color = m.top.focusTextColor
        m.buttomImage.uri = "pkg:/images/buttonFocused.png"
    else
        m.back.backgroundColor = m.top.backColor
        m.title.color = m.top.textColor
        m.buttomImage.uri = "pkg:/images/button.png"
    end if
End function


Function onWidthChanged(event as object)
    ' if m.top.width = 542
    '     m.buttomImage.uri = "pkg:/images/buttonImage542.png"
    ' end if
End function

function onColorChanged()
    m.back.backgroundColor = m.top.backColor
    m.title.color = m.top.textColor
end function

function onKeyEvent(key as String, press as Boolean)
    handled = false
    if press 
        if key = "OK"
            if m.top.hasfocus()
                m.top.buttonselected = true
                if m.top.getParent() <> invalid
                    if m.top.getParent().hasField("buttonSelected")
                        m.top.getParent().buttonSelected = m.top.id
                    end if
                end if
                handle = true
            end if
        end if    
    end if
    return handle
end function