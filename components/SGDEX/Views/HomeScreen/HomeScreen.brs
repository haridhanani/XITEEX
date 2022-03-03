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

    GetData()
End Function    

Function GetData()
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


Function HandleResponse(data as object)
    if data.videos <> invalid
        m.Videos = data.videos
        GetYearsList(data.videos)
    end if

    if data.genres <> invalid
        m.genresFilterList = data.genres
    end if

    VideoFilterByQuery()   
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
                    ? VideoItem
                end if
            end if
        end for
    else
        for each VideoItem in m.Videos
            if CheckVideoForYearFilter(VideoItem) and CheckVideoForGenre(VideoItem)
                videos.push(VideoItem)
                ? VideoItem
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