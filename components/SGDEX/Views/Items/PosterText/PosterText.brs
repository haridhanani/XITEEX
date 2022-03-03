Function init()
    m.Poster = m.top.findnode("Poster")
    m.textbox = m.top.findnode("textbox")
    m.top.ObserveField("focusedChild", "OnFocusChange")
End Function


Function OnFocusChange(event as object)
    focus = event.getdata()
    if focus <> invalid
        m.Poster.uri = "pkg:/images/TextFieldFocused.png"
        m.textbox.active = true
    else
        m.Poster.uri = "pkg:/images/TextField.png"
        m.textbox.active = false
    end if
End Function

Function onWidthChange(event as object)
    width = event.getdata()
    m.textbox.width = width-60
    m.textbox.translation = [30,35]
End Function

Function onTextChange(event as object)
    m.textbox.cursorPosition = Len(event.getdata())
End Function