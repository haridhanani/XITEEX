' ********** Copyright 2019 Roku Corp.  All Rights Reserved. **********

sub Show(args as Object)
    m.global.ObserveField("dialog","ondialogShow",true)

    ShowHomeScreen()

    if IsDeepLinking(args)
        PerformDeepLinking(args)
    end if

    m.top.signalBeacon("AppLaunchComplete")
end sub


Function ondialogShow(event as object)
    data = event.getData()
    if data.textfield <> invalid
        ShowsKeyboard(data)
    end if
End Function


function ShowsKeyboard(data as object)
    m.dialog = createObject("roSGNode", "KeyboardDialog")
    m.dialog.buttons = ["Enter","Cancel"]
    m.dialog.update(data,true)
    m.dialog.observeField("buttonSelected", "HandleKeyboardbutton")
    m.top.dialog = m.dialog
end function

function HandleKeyboardbutton(event as object)
    data = m.top.dialog
    if event.getData() = 0
        if data.Textfield <> invalid
            data.Textfield.text = data.text
        end if  
    end if
    m.top.dialog.close = true
end function

Function ShowHomeScreen()
    m.HomeScreen = CreateObject("roSGNode", "HomeScreen")
    m.top.ComponentController.CallFunc("show", {
        view: m.HomeScreen
    })
End Function