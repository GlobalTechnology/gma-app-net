(function () {

    var token = function ($http) {

        var getSession = function () {
            this._apiResourceUrl = "http://localhost:52195/api/measurements/token?st=" + $('#hf_proxyticket').val()
            return $http.get(this._apiResourceUrl, { withCredentials: true })
                .then(function (response) {
                    
                    return response.data;

                });
        }

      

        return {
            getSession: getSession
          
        };

    };

    var app = angular.module("gcmApp");
    //Of the 20 ways you can register a service you create in Angular, this is by far the easiest
    app.factory("token", token);

}());