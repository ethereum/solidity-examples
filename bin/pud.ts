import * as jsondiffpatch from 'jsondiffpatch';

import {readLatest, readLog} from "../script/utils/io";
import {PERF_LOGS, RESULTS_NAME_OPTIMIZED, RESULTS_NAME_UNOPTIMIZED} from "../script/constants";

const checkLatest = () => {
    const latest = readLatest(PERF_LOGS);
    if (latest !== '') {
        const latestOptResults = readLog(latest, RESULTS_NAME_OPTIMIZED);
        const latestUnOptResults = readLog(latest, RESULTS_NAME_UNOPTIMIZED);
        const diff = jsondiffpatch.diff(latestUnOptResults, latestOptResults);
        if (diff) {
            const output = jsondiffpatch.formatters.console.format(diff);
            console.log(output);
        }
    }
};

checkLatest();
