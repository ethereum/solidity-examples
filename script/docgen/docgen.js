"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var io_1 = require("../utils/io");
var fs_1 = require("fs");
var path_1 = require("path");
var constants_1 = require("../constants");
var utils_1 = require("../../bin/prompt/utils");
var AnchorWriter = /** @class */ (function () {
    function AnchorWriter() {
        this.found = {};
    }
    AnchorWriter.prototype.getAnchor = function (name) {
        var num = this.found[name];
        if (num === undefined || num === 0) {
            this.found[name] = 1;
            return name;
        }
        if (num > 0) {
            this.found[name]++;
            return name + "_" + num;
        }
    };
    return AnchorWriter;
}());
var SPACES = "                                                                                      ";
var newline = function () { return "\n"; };
var divider = function () { return "***\n\n"; };
var inset = function (sec, spaces) {
    if (spaces === void 0) { spaces = 0; }
    var ret = [];
    for (var _i = 0, sec_1 = sec; _i < sec_1.length; _i++) {
        var s = sec_1[_i];
        var len = s.length + spaces;
        ret.push(("" + SPACES + s).slice(-len));
    }
};
var headLine = function (str, level) {
    if (level === void 0) { level = 0; }
    switch (level) {
        case 1:
            return "# " + str + "\n\n";
        case 2:
            return "## " + str + "\n\n";
        case 3:
            return "### " + str + "\n\n";
        case 4:
            return "#### " + str + "\n\n";
        case 5:
            return "##### " + str + "\n\n";
        default:
            throw new Error("Headline level OOB");
    }
};
var paragraph = function (str) { return str + "\n\n"; };
var paramTypeAndRefType = function (p) {
    var ret = p.type;
    if (p.refType) {
        ret += " " + p.refType;
    }
    return ret;
};
var paramTypeAndRefTypeAnchor = function (p) {
    var ret = p.type.toLowerCase();
    if (p.refType) {
        ret += "-" + p.refType;
    }
    return ret;
};
var funcName = function (func) { return func.name + "(" + func.inParams.map(paramTypeAndRefType).join(', ') + ")"; };
var funcNameAnchor = function (func) { return "" + func.name.toLowerCase() + func.inParams.map(paramTypeAndRefTypeAnchor).join('-'); };
var paramTypeAndName = function (param) {
    var str = param.type;
    if (param.refType) {
        str += " " + param.refType;
    }
    if (param.name) {
        str += " " + param.name;
    }
    return "" + str;
};
var paramDisp = function (param) {
    if (param.desc) {
        return "`" + paramTypeAndName(param) + "`: " + param.desc;
    }
    else {
        return "`" + paramTypeAndName(param) + "`";
    }
};
var funcSig = function (func) {
    var str = "function " + funcName(func) + " " + func.visibility + " " + func.qualifier;
    if (func.modifiers && func.modifiers.length > 0) {
        str += func.modifiers.join(' ');
    }
    if (func.outParams !== undefined && func.outParams.length > 0) {
        var returns = "returns (";
        for (var _i = 0, _a = func.outParams; _i < _a.length; _i++) {
            var p = _a[_i];
            returns += paramTypeAndName(p);
        }
        returns += ")";
        str += " " + returns;
    }
    return "`" + str + "`";
};
var writeFunction = function (perf, func, level) {
    if (level === void 0) { level = 3; }
    var lines = [];
    lines.push(divider());
    var name = funcName(func);
    lines.push(headLine("" + name, level));
    lines.push(funcSig(func) + '\n\n');
    lines.push(paragraph(func.desc));
    if (func.inParams && func.inParams.length > 0) {
        lines.push(headLine("params", level + 2));
        for (var _i = 0, _a = func.inParams; _i < _a.length; _i++) {
            var p = _a[_i];
            lines.push("- " + paramDisp(p) + "\n");
        }
    }
    lines.push(newline());
    if (func.requires && func.requires.length > 0) {
        lines.push(headLine("requires", level + 2));
        for (var _b = 0, _c = func.requires; _b < _c.length; _b++) {
            var r = _c[_b];
            lines.push("- " + r + "\n");
        }
    }
    lines.push(newline());
    if (func.inParams && func.inParams.length > 0) {
        lines.push(headLine("returns", level + 2));
        for (var _d = 0, _e = func.outParams; _d < _e.length; _d++) {
            var p = _e[_d];
            lines.push("- " + paramDisp(p) + "\n");
        }
    }
    lines.push(newline());
    if (func.ensures && func.ensures.length > 0) {
        lines.push(headLine("ensures", level + 2));
        for (var _f = 0, _g = func.ensures; _f < _g.length; _f++) {
            var e = _g[_f];
            lines.push("- " + e + "\n");
        }
    }
    if (func.gas && func.gas.length > 0) {
        lines.push(headLine("gascosts", level + 2));
        for (var _h = 0, _j = func.gas; _h < _j.length; _h++) {
            var g = _j[_h];
            var prf = perf["results"][g[1]];
            if (prf === undefined) {
                throw new Error("No perf acailable for: " + g[1]);
            }
            lines.push("- " + g[0] + ": **" + prf.gasUsed + "**\n");
        }
    }
    lines.push(newline());
    return lines;
};
var createFunctions = function (perf, funcs, level) {
    if (level === void 0) { level = 3; }
    var lines = [];
    for (var _i = 0, funcs_1 = funcs; _i < funcs_1.length; _i++) {
        var func = funcs_1[_i];
        lines = lines.concat(writeFunction(perf, func, level));
    }
    return lines;
};
var createFuncTOC = function (funcs) {
    var lines = [];
    for (var _i = 0, funcs_2 = funcs; _i < funcs_2.length; _i++) {
        var f = funcs_2[_i];
        lines.push("- [" + funcName(f) + "](#" + funcNameAnchor(f) + ")\n");
    }
    lines.push(newline());
    return lines;
};
var createFuncSection = function (funcs, level) {
    if (level === void 0) { level = 2; }
    var perf = io_1.latestPerfLog();
    var lines = [];
    lines.push(headLine("Functions", level));
    lines = lines.concat(createFuncTOC(funcs));
    lines = lines.concat(createFunctions(perf, funcs, level + 1));
    return lines;
};
var createPackageDocs = function (docJson, intro) {
    var root = [];
    root.push(headLine(docJson["name"], 1) + "\n\n");
    root.push("**Package:** " + docJson["package"] + "\n\n");
    root.push("**Contract type:** " + docJson["type"] + "\n\n");
    var sourceName = docJson["name"] + ".sol";
    root.push("**Source file:** [" + sourceName + "](../../src/" + docJson["package"] + "/" + sourceName + ")\n\n");
    var examplesName = docJson["name"] + "Examples.sol";
    root.push("**Example usage:** [" + examplesName + "](../../examples/" + docJson["package"] + "/" + examplesName + ")\n\n");
    var testName = docJson["package"] + "_tests.sol";
    root.push("**Tests source file:** [" + testName + "](../../test/" + docJson["package"] + "/" + testName + ")\n\n");
    var perfName = docJson["package"] + "_perfs.sol";
    root.push("**Perf (gas usage) source file:** [" + perfName + "](../../perf/" + docJson["package"] + "/" + perfName + ")\n\n");
    root.push(newline());
    root.push(headLine("description", 2));
    root.push(intro);
    root.push(newline());
    root.push(newline());
    root = root.concat(createFuncSection(docJson["functions"]));
    return root.join('');
};
var writeDocs = function () {
    var docs = ["Bits", "Bytes", "Math", "Strings"];
    for (var _i = 0, docs_1 = docs; _i < docs_1.length; _i++) {
        var doc = docs_1[_i];
        var docJson = JSON.parse(fs_1.readFileSync(path_1.join(constants_1.PACKAGE_DOCS_DATA_FOLDER, doc + '.json')).toString());
        var intro = fs_1.readFileSync(path_1.join(constants_1.PACKAGE_DOCS_DATA_FOLDER, docJson["intro"])).toString();
        var docMd = createPackageDocs(docJson, intro);
        fs_1.writeFileSync(path_1.join(utils_1.PACKAGE_DOCS_PATH, docJson.name + '.md'), docMd);
    }
};
writeDocs();
