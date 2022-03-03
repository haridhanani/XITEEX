Function init()
    m.top.ObserveField("wasShown", "OnWasShown")
    m.top.ObserveField("focusedChild", "OnFocusChange")

    m.YearFilterList = []
    m.genresFilterList = []
    m.Videos = []

    m.yearFilter = []
    m.genresFilter = []
    m.query = ""

    m.StringUtil = StringUtil()
    m.ArrayUtil = ArrayUtil()

    m.RowList = m.top.FindNode("RowList")
    m.SearchBox = m.top.findNode("SearchBox")
    m.SearchBox.ObserveField("text","OnTextChanged")

    m.GenreCheckList = m.top.findNode("GenreCheckList")
    m.GenreCheckList.ObserveField("itemselected","onGenreCheckListSelected")

    m.YearCheckList = m.top.findNode("YearCheckList")
    m.YearCheckList.ObserveField("itemselected","onYearCheckListSelected")

    m.spinnerGroup = m.top.findNode("spinnerGroup")
    m.spinner = m.top.findNode("spinner")

    m.noContent = m.top.findNode("noContent")

    m.test = m.top.findNode("test")
    m.FilterButton = m.top.findNode("FilterButton")
    m.FilterButton.ObserveField("buttonselected","onButtonSelected")

    m.FilterItemList = m.top.findNode("FilterItemList")
    m.FilterItemList.ObserveField("RowItemSelected","onFilterListItemSelected")
    

    m.filterFox = m.top.findNode("filterFox")
    m.filterFox.ObserveField("visible","filterFoxVisibleChanged")


    m.filterNoText = m.top.findNode("filterNoText")

    m.genre = {}

    GetData()

End Function    

Function filterFoxVisibleChanged(event as object)
    if event.getdata() = false
        Videos = VideoFilterByQuery()   
        SetupRowListGrid(Videos)
    end if
End Function

Function GetData()
    ShowBusySpinner(true)
    createTaskPromise("GetTask", {
        url : "https://raw.githubusercontent.com/XiteTV/frontend-coding-exercise/main/data/dataset.json"
    }).then(sub(task)
        results = task.output
        response = ParseJSON(results)
        if response <> invalid
            HandleResponse(response)
        end if
    end sub)
End Function


Function OnTextChanged(event as object)
    text = event.getdata()
    m.query = text

    Videos = VideoFilterByQuery()   
    SetupRowListGrid(Videos)
End Function


Function SetupFilterRowList()
    Items = GetFilters()

    content = createobject("roSGNode","ContentNode")
    row = createobject("roSGNode","ContentNode")
    for each menuItem in Items
        item = createobject("roSGNode","ContentNode")
        m.test.text = menuItem.title
        item.title = menuItem.title
        item.id = menuItem.id
        item.Update({
            FHDItemWidth: m.test.boundingRect().width+100, type : menuItem.type
        }, true)
        row.appendchild(item)
    end for
    content.appendchild(row)
    m.FilterItemList.itemSize = [1300, 80]
    m.FilterItemList.content = content

    if Items.count() = 0
        m.filterNoText.visible = true
        m.FilterItemList.content = invalid
    else 
        m.filterNoText.visible = false
    end if
end Function

Function GetFilters()
    items = []
    if m.yearFilter.count() > 0
        for each year in m.yearFilter
            item = {
                title: year
                id : year
                type : "year"
            }
            items.push(item)
        end for
    end if

    if m.genresFilter.count() > 0
        for each genre in m.genresFilter
            item = {
                title: m.genre[genre]
                id : genre
                type : "genre"
            }
            items.push(item)
        end for
    end if
    return items
End Function

Function onGenreCheckListSelected(event as object)
    index = event.getdata()
    data = event.getRoSGNode().content.getChild(index)
    if m.ArrayUtil.contains(m.genresFilter,data.id)
       index = m.ArrayUtil.indexOf(m.genresFilter,data.id)
       m.genresFilter.Delete(index)
    else
        m.genresFilter.push(data.id)
    end if
    SetupFilterRowList()
End Function

Function OnYearCheckListSelected(event as object)
    index = event.getdata()
    data = event.getRoSGNode().content.getChild(index)
    if m.ArrayUtil.contains(m.yearFilter,data.id)
       index = m.ArrayUtil.indexOf(m.yearFilter,data.id)
       m.yearFilter.Delete(index)
    else
        m.yearFilter.push(data.id)
    end if
    SetupFilterRowList()
End Function


Function onFilterListItemSelected(event as object)
    index = event.getdata()
    data = event.getRoSGNode().content.getChild(index[0]).getChild(index[1])
    if data.type = "year"
        if m.ArrayUtil.contains(m.yearFilter,data.id)
            index = m.ArrayUtil.indexOf(m.yearFilter,data.id)
            m.yearFilter.Delete(index)
         else
             m.yearFilter.push(data.id)
         end if
    else if data.type = "genre"
        if m.ArrayUtil.contains(m.genresFilter,data.id)
            index = m.ArrayUtil.indexOf(m.genresFilter,data.id)
            m.genresFilter.Delete(index)
         else
             m.genresFilter.push(data.id)
         end if
    end if

    SetupFilterRowList()

    if m.FilterItemList.content = invalid
        m.FilterButton.setfocus(true)
    end if

    Videos = VideoFilterByQuery()   
    SetupRowListGrid(Videos)
End Function




Function HandleResponse(data as object)

    if data.videos <> invalid
        m.Videos = data.videos
        GetYearsList(data.videos)
        setupYearFilterCheckList()
    end if

    if data.genres <> invalid
        m.genresFilterList = data.genres
        for each genre in data.genres
            m.genre.AddReplace(genre.id.tostr(),genre.name)
        end for
        setupGenresFilterList()
    end if

    Videos = VideoFilterByQuery()   
    SetupRowListGrid(Videos)

    ShowBusySpinner(false)
End Function

Function SetupRowListGrid(data as object)
    content = CreateObject("roSGNode","ContentNode")
    for i=0 to data.count()-1 step 4
        row = CreateObject("roSGNode","ContentNode")
        for j=i to j+3
            if data[j] <> invalid
                dataItem = {
                    image_url : data[j].image_url
                    title : data[j].title
                    artist : data[j].artist
                }
                item = CreateObject("roSGNode","ContentNode")
                item.update(dataItem,true)
                row.appendChild(item)
            end if
        end for
        if row.getchildCount() > 0
            content.appendChild(row)
        end if
    end for
    m.RowList.content = content

    if m.RowList.content.getchildCount() = 0
        m.RowList.content = invalid
        m.RowList.visible = false
        m.noContent.visible = true
    else
        m.noContent.visible = false
        m.RowList.visible = true
    end if
End Function


Function GetYearsList(data as object)
    if data <> invalid and data.count() > 0
        for each VideoItem in data
            if not m.ArrayUtil.contains(m.YearFilterList,VideoItem.release_year)
                m.YearFilterList.push(VideoItem.release_year)
            end if
        end for
        m.YearFilterList.Sort("r")
    end if
End Function


Function VideoFilterByQuery()   
    videos = []
    if m.query  <> ""
        for each VideoItem in m.Videos
            if (VideoItem.title <> invalid and m.StringUtil.contains(LCase(VideoItem.title.toStr()),Lcase(m.query),0)) or (VideoItem.artist <> invalid and m.StringUtil.contains(LCase(VideoItem.artist.toStr()),Lcase(m.query),0))
                if CheckVideoForYearFilter(VideoItem) and CheckVideoForGenre(VideoItem)
                    videos.push(VideoItem)
                end if
            end if
        end for
    else
        for each VideoItem in m.Videos
            if CheckVideoForYearFilter(VideoItem) and CheckVideoForGenre(VideoItem)
                videos.push(VideoItem)
            end if
        end for
    end if
    return videos
End Function


Function CheckVideoForYearFilter(videoItem as object) as boolean
    if videoItem.release_year <> invalid
        if m.yearFilter.count() = 0 
            return true
        else
            if m.ArrayUtil.contains(m.yearFilter, VideoItem.release_year.toStr())
                return true
            end if
        end if
    end if
    return false
End Function

Function CheckVideoForGenre(videoItem as object) as boolean
    if videoItem.genre_id <> invalid
        if m.genresFilter.count() = 0 
            return true
        else
            if m.ArrayUtil.contains(m.genresFilter,VideoItem.genre_id.toStr())
                return true
            end if
        end if
    end if
    return false
End Function

Function setupGenresFilterList()
    checkedState = []
    content = createobject("roSGNode","ContentNode")
    if m.genresFilterList.count() > 0
        for each genreItem in m.genresFilterList
            item = createobject("roSGNode","ContentNode")
            itemdata = {
                title : genreItem.name
                id : genreItem.id.tostr()
            }
            item.update(itemdata,true)
            if m.ArrayUtil.contains(m.genresFilter,itemdata.id) 
                checkedState.push(true)
            else
                checkedState.push(false)
            end if
            content.appendChild(item)
        end for
    end if
    m.GenreCheckList.checkedState = checkedState
    m.GenreCheckList.content = content
End Function


Function setupYearFilterCheckList()
    checkedState = []
    content = createobject("roSGNode","ContentNode")
    if m.YearFilterList.count() > 0
        for each yearItem in m.YearFilterList
            item = createobject("roSGNode","ContentNode")
            itemdata = {
                title : yearItem.tostr()
                id :yearItem.tostr()
            }
            item.update(itemdata,true)
            if m.ArrayUtil.contains(m.yearFilter,itemdata.id) 
                checkedState.push(true)
            else
                checkedState.push(false)
            end if
            content.appendChild(item)
        end for
    end if
    m.YearCheckList.checkedState = checkedState
    m.YearCheckList.content = content
End Function

function onkeyEvent(key as String, press as Boolean) as Boolean
    handled = false
    if press
       if key = "OK"
            if m.SearchBox.hasFocus()
                data = {
                    Textfield :  m.SearchBox
                    title : "Enter your search query"
                }
                m.global.setfields({dialog : data})
                handled = true
            else if m.FilterButton.hasFocus()
                m.filterFox.visible = true
                m.GenreCheckList.setfocus(true)
            end if
       else if key = "right"
            if m.GenreCheckList.isInFocusChain()
                m.YearCheckList.setfocus(true)
                handled = true
            else if m.FilterButton.isInFocusChain() and m.FilterItemList.content <> invalid
                m.FilterItemList.setfocus(true)
                handled = true
            end if
       else if key = "left"
            if m.YearCheckList.isInFocusChain()
                m.GenreCheckList.setfocus(true)
                handled = true
            end if
        else if key = "down"
            if m.SearchBox.isInFocusChain()
                m.FilterButton.setfocus(true)
            else if m.FilterButton.hasFocus() or m.FilterItemList.hasFocus()
                if m.RowList.content <> invalid
                    m.RowList.setfocus(true)
                    handled = true
                end if
            end if
        else if key = "up"
            if m.RowList.hasFocus()
                m.FilterButton.setfocus(true)
                handled = true
            else if m.FilterButton.hasFocus() or m.FilterItemList.hasFocus()
                m.SearchBox.setfocus(true)
                handled = true
            end if
        else if key = "back"
            if m.filterFox.visible = true
                m.FilterButton.setfocus(true)
                m.filterFox.visible = false
                handled = true
            end if
       end if
    end if
    return handled
end function

Function onButtonSelected(event as object)
    m.filterFox.visible = true
    m.GenreCheckList.setfocus(true)
End function

sub ShowBusySpinner(shouldShow as Boolean)
    if shouldShow then
        if not m.spinnerGroup.visible then
            m.spinnerGroup.visible = true
            m.spinner.control = "start"
        end if
    else
        m.spinnerGroup.visible = false
        m.spinner.control = "stop"
    end if
end sub