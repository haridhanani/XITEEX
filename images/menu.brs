function init()
    m.MenuList = m.top.findnode("MenuList")
    m.MenuList.ObserveField("rowItemSelected","onRowItemSelected")
    m.test = m.top.findNode("test")
    m.profileImage = m.top.findnode("profileImage")
    m.drop = m.top.findnode("drop")
    m.MenuItems = ["Home","Live","On Demand","Catch Up","My List","Search"]
    SetupMenuList()
    m.global.ObserveField("profile","onProfileChanged",true)
end Function

Function onRowItemSelected(event as object)
    SetupMenuList()
End function

Function SetupMenuList()
    content = createobject("roSGNode","ContentNode")
    row = createobject("roSGNode","ContentNode")
    for each menuItem in m.MenuItems
        item = createobject("roSGNode","ContentNode")
        m.test.text = menuItem
        item.title = menuItem
        item.Update({
            FHDItemWidth: m.test.boundingRect().width
        }, true)
        if menuItem = "My List"
            if GetToken() <> ""
                row.appendchild(item)
            end if
        else
            row.appendchild(item)
        end if
    end for
    content.appendchild(row)
    m.MenuList.itemSize = [1800, 80]
    m.MenuList.content = content
end Function


function onkeyEvent(key as String, press as Boolean) as Boolean
    handled = false
    if press
        if key = "right"
            if m.MenuList.hasfocus()
                if m.profileImage.visible = true
                    m.profileImage.setfocus(true)
                    m.drop.blendcolor = "#3B66AF"
                    handled = true
                end if
            end if
        else if key = "right"
            if m.profileImage.visible = true and m.profileImage.hasfocus()
                m.MenuList.setfocus(true)
                m.drop.blendcolor = "#FFFFFF"
                handled = true
            end if
        end if
    end if
    return handled
end function


Function onProfileChanged(event as object)
    if GetToken() <> ""
        'm.profileImage.visible = true
        SetupMenuList()
    else
        'm.profileImage.visible = false
        SetupMenuList()
    end if
End function