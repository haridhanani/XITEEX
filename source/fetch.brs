function fetch(options)
    timeout = options.timeout
    if timeout = invalid then timeout = 0

    response = invalid
    port = CreateObject("roMessagePort")
    request = CreateObject("roUrlTransfer")
    request.SetCertificatesFile("common:/certs/ca-bundle.crt")
    request.InitClientCertificates()
    request.RetainBodyOnError(true)
    request.SetMessagePort(port)
    if options.headers <> invalid
        for each header in options.headers
            val = options.headers[header]
            if val <> invalid then request.addHeader(header, val)
        end for
    end if
    if options.method <> invalid
        request.setRequest(options.method)
    end if
    request.SetUrl(options.url)

    requestSent = invalid
    if options.body <> invalid
        requestSent = request.AsyncPostFromString(options.body)
    else
        requestSent = request.AsyncGetToString()
    end if
    if (requestSent)
        msg = wait(timeout, port)
        status = -999
        body = "(TIMEOUT)"
        headers = {}
        if (type(msg) = "roUrlEvent")
            status = msg.GetResponseCode()
            headersArray = msg.GetResponseHeadersArray()
            for each headerObj in headersArray
                for each headerName in headerObj
                    val = {
                        value: headerObj[headerName]
                        next: invalid
                    }
                    current = headers[headerName]
                    if current <> invalid
                        prev = current
                        while current <> invalid
                            prev = current
                            current = current.next
                        end while
                        prev.next = val
                    else
                        headers[headerName] = val
                    end if
                end for
            end for
            body = msg.GetString()
            if status < 0 then body = msg.GetFailureReason()
        end if

        response = {
            _body: body,
            status: status,
            ok: (status >= 200 AND status < 300),
            headers: headers,
            text: function()
                return m._body
            end function,
            json: function()
                return ParseJSON(m._body)
            end function,
            xml: function()
                if m._body = invalid then return invalid
                xml = CreateObject("roXMLElement") '
                if NOT xml.Parse(m._body) then return invalid
                return xml
            end function
        }
    end if

    return response
end function
