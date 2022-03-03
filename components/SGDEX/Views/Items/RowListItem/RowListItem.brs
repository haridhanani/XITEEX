' Copyright (c) 2018 Roku, Inc. All rights reserved.
Function init()
    m.poster = m.top.FindNode("poster")
    m.line1 = m.top.findNode("line1")
    m.line2 = m.top.findNode("line2")
End function


sub onContentSet()
    content = m.top.itemContent
    m.poster.uri = content.image_url
    m.line1.text = content.artist
    m.line2.text  = content.title
end sub

sub onWidthChange()
    m.poster.width      = m.top.width
    m.poster.loadWidth  = m.top.width
    m.line1.width = m.top.width
    m.line2.width = m.top.width
end sub

sub onHeightChange()
    m.poster.height = m.top.height
    m.poster.loadHeight  = m.top.height
end sub

