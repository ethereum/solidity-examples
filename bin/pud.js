"use strict";
exports.__esModule = true;
var jsondiffpatch = require("jsondiffpatch");
var files_1 = require("../script/utils/files");
var constants_1 = require("../script/constants");
var checkLatest = function () {
    var latest = files_1.readLatest(constants_1.PERF_LOGS);
    if (latest !== '') {
        var latestOptResults = files_1.readLog(latest, constants_1.RESULTS_NAME_OPTIMIZED);
        var latestUnOptResults = files_1.readLog(latest, constants_1.RESULTS_NAME_UNOPTIMIZED);
        var diff = jsondiffpatch.diff(latestUnOptResults, latestOptResults);
        if (diff) {
            var output = jsondiffpatch.formatters.console.format(diff);
            console.log(output);
        }
    }
};
checkLatest();
