import * as chlk from "chalk";
import {indexedLogFolders, println, readLog} from "./io";
import * as jsondiffpatch from "jsondiffpatch";
import {PERF_LOGS_PATH, RESULTS_NAME_OPTIMIZED, RESULTS_NAME_UNOPTIMIZED} from "../constants";
import * as path from "path";

const chalk: any = chlk; // TODO Something going on with this thing.

const PASSED = chalk["greenBright"]("PASSED");
const FAILED = chalk["redBright"]("FAILED");

const WHITE_ARROW = chalk["white"]("->");

export const printTestLog = (jsonObj) => {
    println('\n' + chalk["cyanBright"]("Test report") + '\n');
    println(chalk["bold"]["white"]('Context'));
    println(chalk`\t{white Compiler version}: {magentaBright ${jsonObj.solcVersion}}`);
    println(chalk`\t{white EVM version}: {magentaBright ${jsonObj.evmVersion}}`);
    println(chalk["bold"]["white"]('Test results'));
    const results = jsonObj.results;
    for (const objName in results) {
        if (results.hasOwnProperty(objName)) {
            println(chalk`\t{white ${objName}}: ${results[objName].passed ? PASSED : FAILED}`);
        }
    }
    println('\n');
};

export const printPerfLog = (jsonObj) => {
    println('\n' + chalk["cyanBright"]('Perf report') + '\n');
    println(chalk["bold"]["white"]('Context'));
    println(chalk`\t{white Compiler version}: {magentaBright ${jsonObj.solcVersion}}`);
    println(chalk`\t{white EVM version}: {magentaBright ${jsonObj.evmVersion}}`);
    println(chalk["bold"]["white"]('Gas usage'));
    const results = jsonObj.results;
    for (const objName in results) {
        if (results.hasOwnProperty(objName)) {
            println(chalk`\t{white ${objName}}: {blueBright ${results[objName].gasUsed}}`);
        }
    }
    println('\n');
};

export const diff = (oldLog, newLog) => jsondiffpatch["diff"](oldLog, newLog);

export const printPerfDiff = (delta, oldLog, newLog) => {
    println('\n' + chalk["cyanBright"]('Perf diff') + '\n');

    if (delta === undefined || delta === null) {
        println(chalk["greenBright"]('No changes'));
    } else {
        if (delta.solcVersion !== undefined || delta.evmVersion !== undefined) {
            println(chalk["bold"]["white"]('Context diff'));
            if (delta.solcVersion !== undefined) {
                println(chalk`\t{white Compiler version}: {magentaBright ${oldLog.solcVersion} ${WHITE_ARROW} ${newLog.solcVersion}}`);
            }
            if (delta.solcVersion !== undefined) {
                println(chalk`\t{white EVM version}: {magentaBright ${oldLog.evmVersion} ${WHITE_ARROW} ${newLog.evmVersion}}`);
            }
        }
        if (delta.results !== undefined && Object.keys(delta).length > 0) {
            println(chalk["bold"]["white"]('Results'));
            const results = delta.results;
            for (const objName in results) {
                if (results.hasOwnProperty(objName)) {
                    const vDelta = results[objName];
                    if (vDelta instanceof Array && vDelta.length === 1) {
                        println(chalk`\t({greenBright ++}) {white ${objName}}`);
                    } else if (vDelta instanceof Array && vDelta.length === 3) {
                        println(chalk`\t({redBright --}) {white ${objName}}`);
                    } else {
                        const oldGas = vDelta.gasUsed[0];
                        const newGas = vDelta.gasUsed[1];
                        if (newGas > oldGas) {
                            println(chalk`\t{white ${objName}}: ${chalk.blueBright(oldGas)} ${WHITE_ARROW} ${chalk.redBright(newGas)}`);
                        } else {
                            println(chalk`\t{white ${objName}}: ${chalk.blueBright(oldGas)} ${WHITE_ARROW} ${chalk.greenBright(newGas)}`);
                        }
                    }
                }
            }
        }
    }
    println('\n');
};

export const printLatestDiff = (optimized: boolean = true): boolean => {
    const logFolders = indexedLogFolders(PERF_LOGS_PATH, 2);
    if (logFolders.length < 2) {
        return false;
    }
    const file = optimized ? RESULTS_NAME_OPTIMIZED : RESULTS_NAME_UNOPTIMIZED;
    const newLog = readLog(path.join(PERF_LOGS_PATH, logFolders[0]), file);
    const oldLog = readLog(path.join(PERF_LOGS_PATH, logFolders[1]), file);
    const delta = diff(oldLog, newLog);
    printPerfDiff(delta, oldLog, newLog);
    return true;
};
