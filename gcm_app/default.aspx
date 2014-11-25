<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="default.aspx.vb" Inherits="gcm_app._default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="/Content/bootstrap.min.css" rel="stylesheet" />
    <link href="/Content/bootstrap-theme.css" rel="stylesheet" />
    <link href="Content/gcm.css" rel="stylesheet" />
    <link href="Content/spinner.css" rel="stylesheet" />

     <link rel="stylesheet" type="text/css" href="http://angular-ui.github.com/ng-grid/css/ng-grid.css" />
    <script src="Scripts/jquery-2.1.1.js"></script>
    <script src="/Scripts/bootstrap.min.js"></script>

    <%--  <link href="/Content/ng-grid.min.css" rel="stylesheet" /> --%>

    <style type="text/css">
       
    </style>

</head>
<body>

    <form id="form1" runat="server">
        <div>
            <%--   <polylines models="church_lines" path="'path'" stroke="'stroke'" visible="'visible'"
                  geodesic="'geodesic'" fit="true" static="true" draggable="false" editable="false" icons="'icons'"></polylines>--%>

            <asp:HiddenField ID="hf_proxyticket" runat="server" />
            <asp:HiddenField ID="hf_api_url" runat="server" />
        </div>
        <div ng-app="gcmApp" ng-controller="gcmCtrl">
            <%--     <div ng-repeat="marker in church_markers track by marker.id" >
                 {{marker.id}}    {{marker.coords.longitude}}
                                       </div>--%>

            <script type="text/ng-template" id="field_renderer.html">
    <a href="" ng-click="loadAssignment(a)">{{a.name}}</a>
    <ul >
        <li ng-repeat="a in a.sub_ministries" ng-include="'field_renderer.html'"></li>
    </ul>
            </script>


            <nav class="navbar navbar-inverse navbar-static-top">
                <div class="container">


                  
                    <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                        <ul class="nav navbar-nav">
                            <li class="dropdown ">
                                <a href="" class="dropdown-toggle  ministry-title" data-toggle="dropdown">{{assignment.name}} <span class="caret"></span></a>
                                <ul class="dropdown-menu" role="menu">
                                    <li><a href="">Global</a></li>
                                    <li class="divider"></li>
                                    <li ng-repeat="a in assignments" ng-include="'field_renderer.html'"></li>
                                    <li class="divider"></li>
                                    <li><a href="" data-toggle="modal" data-target="#newAssignment">Add another location / ministry</a></li>

                                </ul>
                            </li>
                             <li class="dropdown">
                                <a href="" class="dropdown-toggle" data-toggle="dropdown">
                {{current_mcc}}<span class="caret"></span></a>
                                <ul class="dropdown-menu" role="menu">
                                    <li  ng-repeat="(mcc_code, mcc_name) in assignment.mccs"><a href="">{{mcc_name}}</a></li>
                                </ul>
                            </li>
                                

                           <li>
                                <a href="" ng-click="prevPeriod()">&lt;&lt;</a>
                           </li>
                            
                            <li class="dropdown">
                                <a href="" class="dropdown-toggle" data-toggle="dropdown"> {{current_period}} <span class="caret"></span></a>
                                <ul class="dropdown-menu" role="menu">
                                    
                                    <li ng-repeat="p in periods""><a href="" ng-click="$parent.current_period=p;">{{p}}</a></li>
                                  

                                </ul>
                            </li>
                            <li>
                                <a href="" ng-click="nextPeriod()">&gt;&gt;</a>
                           </li>
                        </ul>
                        <ul class="nav navbar-nav navbar-right">
                            <li><a href="">{{user.person.cas_username}}</a></li>
                            <li><a href="https://thekey.me/cas/logout">logout</a></li>
                        </ul>
                    </div>
                  



                    
                </div>

            </nav>
            <div class="container">

                <div>
                    <ul class="nav nav-tabs" role="tablist" id="myTab" class="map-ministries">
                        <li class="active"><a href="#/map" data-target="#">Church</a></li>
                        <li><a href="#/training" data-target="#" ng-show="assignment.team_role === 'leader' || assignment.team_role === 'inherited_leader'">Training</a></li>
                        <li><a href="#/measurements" data-target="#">Measurements</a></li>
                        <li><a href="#/stories" data-target="#">Stories</a></li>
                        <li><a href="#/admin" data-target="#" ng-show="assignment.team_role === 'leader' || assignment.team_role === 'inherited_leader'">Admin</a></li>
                    </ul>

                    <!-- Example row of columns -->
                    <div class="row">
                        <div class="col-md-12">
                            <!--Let it up to the Angular route provider to populate the view in the directive-->
                            <div ng-view></div>
                            <div class="spinner" ng-hide="is_loaded">
                                <div class="spinner-container container1">
                                    <div class="circle1"></div>
                                    <div class="circle2"></div>
                                    <div class="circle3"></div>
                                    <div class="circle4"></div>
                                </div>
                                <div class="spinner-container container2">
                                    <div class="circle1"></div>
                                    <div class="circle2"></div>
                                    <div class="circle3"></div>
                                    <div class="circle4"></div>
                                </div>
                                <div class="spinner-container container3">
                                    <div class="circle1"></div>
                                    <div class="circle2"></div>
                                    <div class="circle3"></div>
                                    <div class="circle4"></div>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>


                <footer>
                    <p>&copy; CCCi 2014</p>
                </footer>
            </div>
            <!-- /container -->

            <div class="modal fade" id="newAssignment" tabindex="-1" role="dialog" aria-labelledby="newAssignmentLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
                            <h4 class="modal-title" id="newAssignmentLabel">Join Ministry/Team</h4>
                            <p class="bg-info">
                                You can request create a provisional assignment to ministry/team here. 
                    Until this request has been approved by a leader of this team/ministry, your access will be read only. 
                    You can submit personal ministry measurements, but these values won't be included until your request has been approved.
                            </p>
                        </div>
                        <div class="modal-body form-horizontal">
                            <div class="form-group">
                                <label for="tbUserName" class="col-sm-4 control-label">Ministry/Team:</label>
                                <div class="col-sm-8">
                                    <div id="min_lookup">

                                        <input id="tbMinistry" type="text" class=" form-control" placeholder="Ministry/Team" ng-model="new_assignment.min_name"
                                            typeahead="min.name for min in ministries | filter:$viewValue | limitTo:8"
                                            typeahead-loading="loadingMinistries"
                                            typeahead-min-length="2" />
                                        <i ng-show="loadingMinistries" class="glyphicon glyphicon-refresh"></i>
                                    </div>

                                    <p class="help-block">Start typing to search for ministry</p>
                                </div>

                            </div>



                        </div>

                        <div class="modal-footer">
                            <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                            <button type="button" class="btn btn-primary" data-dismiss="modal" ng-click="newAssignment()">Join</button>
                        </div>
                    </div>
                </div>
            </div>



        </div>




        <script src="//ajax.googleapis.com/ajax/libs/angularjs/1.2.15/angular.min.js"></script>
        <script src="//ajax.googleapis.com/ajax/libs/angularjs/1.2.15/angular-route.min.js"></script>
        <script type="text/javascript" src="https://www.google.com/jsapi"></script>
        <script src="/gcm_app/gcmApp.js"></script>
        <script src="gcm_app/controllers/gcmCtrl.js"></script>
        <script src="/gcm_app/controllers/mapCtrl.js"></script>
        <script src="gcm_app/controllers/measurementsCtrl.js"></script>
        <script src="gcm_app/controllers/adminCtrl.js"></script>
        <script src="gcm_app/controllers/trainingCtrl.js"></script>
        <%--<script src="gcm_app/controllers/gcmMapCtrl.js"></script>--%>
        <script src="gcm_app/services/training.js"></script>
        <script src="gcm_app/controllers/storiesCtrl.js"></script>
        <script src="gcm_app/services/church.js"></script>
        <script src="gcm_app/services/measurement.js"></script>
        <script src="gcm_app/services/ministries.js"></script>
        <script src="gcm_app/services/assignments.js"></script>
        <script src="gcm_app/controllers/churchCtrl.js"></script>
        <script src="gcm_app/services/token.js"></script>
        <script src="Scripts/angular-ui/ui-bootstrap.min.js"></script>
        <script src="Scripts/angular-ui/ui-bootstrap-tpls.min.js"></script>
      
    <%--    <script src="Scripts/ng-grid.js"></script>--%>
        <script type="text/javascript" src="https://rawgithub.com/angular-ui/ng-grid/v2.0.13/build/ng-grid.debug.js"></script>

        
        <script src='//maps.googleapis.com/maps/api/js?sensor=false'></script>
        <script src="Scripts/lodash.min.js"></script>

        <script src="Scripts/markerwithlabel.js"></script>
        <script type="text/javascript">

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




        </script>

        <%--<script src="/gcm_app/controllers/gcmCtrl.js"></script>--%>
    </form>

</body>
</html>
