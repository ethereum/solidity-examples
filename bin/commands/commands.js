"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var cmd_solstl_1 = require("./cmd_solstl");
var cmd_perf_1 = require("./cmd_perf");
var cmd_tests_1 = require("./cmd_tests");
var cmd_interactive_1 = require("./cmd_interactive");
var cmd_compile_1 = require("./cmd_compile");
exports.COMMANDS = {
    solstl: new cmd_solstl_1.SolStlCommand(),
    perf: new cmd_perf_1.PerfCommand(),
    tests: new cmd_tests_1.TestsCommand(),
    interactive: new cmd_interactive_1.InteractiveCommand(),
    compile: new cmd_compile_1.CompileCommand()
};
