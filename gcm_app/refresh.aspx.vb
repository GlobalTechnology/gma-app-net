Imports System.IO
Imports System.Xml
Imports System.Net
Imports System.Web.Configuration.WebConfigurationManager
Public Class refresh
    Inherits System.Web.UI.Page
    Dim target_service = AppSettings("service_api") & "/token"

    Private Const Cashost As String = "https://thekey.me/cas/"
    Public _service As String = ""

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Response.Clear()
        Dim st = ""
        If Not String.IsNullOrEmpty(Session("pgt")) Then

            Dim validateurl As String = Cashost + "proxy?targetService=" & target_service & "&pgt=" & CStr(Session("pgt")).Trim().ToString()
            Dim reader1 As StreamReader = New StreamReader(New WebClient().OpenRead(validateurl))
            Dim doc As New XmlDocument()
            doc.Load(reader1)
            Dim namespaceMgr = New XmlNamespaceManager(doc.NameTable)
            namespaceMgr.AddNamespace("cas", "http://www.yale.edu/tp/cas")
            'Check for success
            Dim successNode = doc.SelectSingleNode("/cas:serviceResponse/cas:proxySuccess", namespaceMgr)
            If Not successNode Is Nothing Then
                st = successNode.InnerText




            End If
        End If
        If String.IsNullOrEmpty(st) Then


            _service = HttpContext.Current.Request.Url.AbsoluteUri.Replace("refresh.aspx", "default.aspx")
            If _service.Contains("?") Then
                _service = Left(_service, _service.IndexOf("?"))

            End If





            Response.StatusCode = HttpStatusCode.BadRequest
            Response.Write("{""error"": ""SESSION_EXPIRED"", ""login_url"": ""https://thekey.me/cas/login.htm?service=" & _service & """}")
        Else
            Response.Write("{""service_ticket"": """ & st & """}")
        End If
        Response.ContentType = "application/json"
        Response.End()
    End Sub

End Class