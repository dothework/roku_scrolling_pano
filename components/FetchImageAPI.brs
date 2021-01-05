
function uriImageToTemp() as void
    ' ?"uriImageToTemp::m.top.uri", m.top.uri
    ' ?"uriImageToTemp::m.top.filename", m.top.filename
    if m.top.uri <> "" then
        files = CreateObject("roFileSystem")
        ' ? "files.Exists?", m.top.lastfilename, files.Exists(m.top.lastfilename)
        if files.Exists(m.top.lastfilename) then
            success = files.Delete(m.top.lastfilename)
            ' ?"delete success", success
        end if
        w = "2560"
        h = "760"
        if m.global.GetUIResolution.name = "FHD" then
            w = "3840"
            h = "1080"
        end if
        uri = mid(m.top.uri, 1, Instr(1, m.top.uri, "?"))
        uri += "crop=entropy&cs=tinysrgb&fit=crop&fm=jpg&ixid=MXwxOTU2Nzd8MHwxfGNvbGxlY3Rpb258MXwxMjgwMjg5fHx8fHwyfA&ixlib=rb-1.2.1&q=90&h="+h+"&w="+w+"&max-w="+w
        ' ?uri
        fetchURL = CreateObject("roUrlTransfer")
        fetchURL.SetPort(CreateObject("roMessagePort"))
        fetchURL.SetUrl(uri)
        fetchURL.SetCertificatesFile("common:/certs/ca-bundle.crt")
        fetchURL.InitClientCertificates()
        fetchURL.AsyncGetToFile(m.top.filename)
        wait(0, fetchURL.GetPort())
        m.top.transferComplete = true
    end if
end function