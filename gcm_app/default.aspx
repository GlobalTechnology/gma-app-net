<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="default.aspx.vb" Inherits="gcm_app._default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>

    <link href="gcm_app/vendor/bootstrap/dist/css/bootstrap.css" rel="stylesheet" />
    <link href="gcm_app/vendor/bootstrap/dist/css/bootstrap-theme.css" rel="stylesheet" />
    <link href="gcm_app/css/spinner.css" rel="stylesheet" />
    <link href="gcm_app/vendor/ng-grid/ng-grid.css" rel="stylesheet" />
    <link href="gcm_app/css/gcm.css" rel="stylesheet" />

    <script type="application/javascript" src="gcm_app/vendor/jquery/jquery.js"></script>
    <script type="application/javascript">
        var GCM_APP = window.GCM_APP = {
            ticket: <%= TICKET_VARIABLE_NAME %>, // CAS Service Ticket
            api_url: <%= API_URL %>, // API Url
            app_url: '/gcm_app' // Path to Angular app
        };
    </script>
</head>
<body>

    <form id="form1" runat="server">
        <div ng-app="gcmApp" ng-include="GCM_APP.app_url + '/template/gcm_app.html'">
        </div>

        <script type="application/javascript" src="https://www.google.com/jsapi"></script>
        <script type="application/javascript" src="https://maps.googleapis.com/maps/api/js?sensor=false"></script>
        <script type="application/javascript" src="gcm_app/vendor/bootstrap/dist/js/bootstrap.js"></script>

        <script type="application/javascript" src="gcm_app/vendor/angular/angular.js"></script>
        <script type="application/javascript" src="gcm_app/vendor/angular-route/angular-route.js"></script>
        <script type="application/javascript" src="gcm_app/vendor/angular-bootstrap/ui-bootstrap.js"></script>
        <script type="application/javascript" src="gcm_app/vendor/angular-bootstrap/ui-bootstrap-tpls.js"></script>
        <script type="application/javascript" src="gcm_app/vendor/ng-grid/ng-grid.css"></script>
        <script type="application/javascript" src="gcm_app/vendor/easy-markerwithlabel/src/markerwithlabel.js"></script>
        <script type="application/javascript" src="gcm_app/js/gcmApp.js"></script>

        <script type="application/javascript" src="gcm_app/js/controllers/adminCtrl.js"></script>
        <script type="application/javascript" src="gcm_app/js/controllers/churchCtrl.js"></script>
        <script type="application/javascript" src="gcm_app/js/controllers/gcmCtrl.js"></script>
        <script type="application/javascript" src="gcm_app/js/controllers/gcmMapCtrl.js"></script>
        <script type="application/javascript" src="gcm_app/js/controllers/mapCtrl.js"></script>
        <script type="application/javascript" src="gcm_app/js/controllers/measurementsCtrl.js"></script>
        <script type="application/javascript" src="gcm_app/js/controllers/storiesCtrl.js"></script>
        <script type="application/javascript" src="gcm_app/js/controllers/trainingCtrl.js"></script>
        <script type="application/javascript" src="gcm_app/js/services/assignments.js"></script>
        <script type="application/javascript" src="gcm_app/js/services/church.js"></script>
        <script type="application/javascript" src="gcm_app/js/services/measurement.js"></script>
        <script type="application/javascript" src="gcm_app/js/services/ministries.js"></script>
        <script type="application/javascript" src="gcm_app/js/services/token.js"></script>
        <script type="application/javascript" src="gcm_app/js/services/training.js"></script>

        <script type="text/javascript">

            (function($){

                $('.nav-tabs li').on('click', function (event) {
                    $('.nav-tabs li').removeClass('active'); // remove active class from tabs
                    $(this).addClass('active'); // add active class to clicked tab
                });

                function setActiveTab() {
                    var hash = window.location.hash;

                    var activeTab = $('.nav-tabs a[href="' + hash + '"]');
                    if (activeTab.length) {
                        activeTab.tab('show');
                    } else {
                        $('.nav-tabs a:first').tab('show');
                    }
                };

                //If a bookmark was used to a particular page, make sure to activate the correct tab:
                $(document).ready(function () {
                    setActiveTab();
                });

                //When history.pushState() activates the popstate event, switch to the currently
                //selected tab aligning with the page being navigated to from history.
                $(window).on('popstate', function () {
                    setActiveTab();
                });

            })(jQuery);

        </script>
    </form>

</body>
</html>
