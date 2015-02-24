<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="default.aspx.vb" Inherits="gcm_app._default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>

    <link href="gcm_app/vendor/bootstrap/dist/css/bootstrap.css" rel="stylesheet" />
    <link href="gcm_app/vendor/bootstrap/dist/css/bootstrap-theme.css" rel="stylesheet" />
    <link href="gcm_app/css/spinner.css" rel="stylesheet" />
    <link href="gcm_app/css/gcm.css" rel="stylesheet" />

    <script type="application/javascript" src="gcm_app/vendor/jquery/dist/jquery.js"></script>
    <script type="application/javascript">
        var GCM_APP = window.GCM_APP = {
            ticket: '<%= st%>', // CAS Service Ticket
            api_url: '<%= System.Web.Configuration.WebConfigurationManager.AppSettings("service_api")%>', // API Url
            app_url: '/gcm_app', // Path to Angular app
            refresh_url: '/refresh.aspx', // endpoint to refresh cas ticket (GET)
            cas_logout: 'https://thekey.me/cas/logout'  // logout url
        };
    </script>
</head>
<body>

    <form id="form1" runat="server">
        <div ng-include="GCM_APP.app_url + '/template/gcm_app.html'">
        </div>
        <script type="application/javascript" data-main="/gcm_app/js/main.js" src="/gcm_app/vendor/requirejs/require.js"></script>
    </form>

</body>
</html>
