"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var jsondiffpatch = require("jsondiffpatch");
var io_1 = require("../script/utils/io");
var constants_1 = require("../script/constants");
var checkLatest = function () {
    var latest = io_1.readLatest(constants_1.PERF_LOGS);
    if (latest !== '') {
        var latestOptResults = io_1.readLog(latest, constants_1.RESULTS_NAME_OPTIMIZED);
        var latestUnOptResults = io_1.readLog(latest, constants_1.RESULTS_NAME_UNOPTIMIZED);
        var diff = jsondiffpatch.diff(latestUnOptResults, latestOptResults);
        if (diff) {
            var output = jsondiffpatch.formatters.console.format(diff);
            console.log(output);
        }
    }
};
checkLatest();
