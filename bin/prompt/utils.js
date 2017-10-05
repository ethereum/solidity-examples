"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : new P(function (resolve) { resolve(result.value); }).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __generator = (this && this.__generator) || function (thisArg, body) {
    var _ = { label: 0, sent: function() { if (t[0] & 1) throw t[1]; return t[1]; }, trys: [], ops: [] }, f, y, t, g;
    return g = { next: verb(0), "throw": verb(1), "return": verb(2) }, typeof Symbol === "function" && (g[Symbol.iterator] = function() { return this; }), g;
    function verb(n) { return function (v) { return step([n, v]); }; }
    function step(op) {
        if (f) throw new TypeError("Generator is already executing.");
        while (_) try {
            if (f = 1, y && (t = y[op[0] & 2 ? "return" : op[0] ? "throw" : "next"]) && !(t = t.call(y, op[1])).done) return t;
            if (y = 0, t) op = [0, t.value];
            switch (op[0]) {
                case 0: case 1: t = op; break;
                case 4: _.label++; return { value: op[1], done: false };
                case 5: _.label++; y = op[1]; op = [0]; continue;
                case 7: op = _.ops.pop(); _.trys.pop(); continue;
                default:
                    if (!(t = _.trys, t = t.length > 0 && t[t.length - 1]) && (op[0] === 6 || op[0] === 2)) { _ = 0; continue; }
                    if (op[0] === 3 && (!t || (op[1] > t[0] && op[1] < t[3]))) { _.label = op[1]; break; }
                    if (op[0] === 6 && _.label < t[1]) { _.label = t[1]; t = op; break; }
                    if (t && _.label < t[2]) { _.label = t[2]; _.ops.push(op); break; }
                    if (t[2]) _.ops.pop();
                    _.trys.pop(); continue;
            }
            op = body.call(thisArg, _);
        } catch (e) { op = [6, e]; y = 0; } finally { f = t = 0; }
        if (op[0] & 5) throw op[1]; return { value: op[0] ? op[1] : void 0, done: true };
    }
};
var _this = this;
Object.defineProperty(exports, "__esModule", { value: true });
var inquirer = require("inquirer");
var path = require("path");
var marked = require("marked");
var TerminalRenderer = require("marked-terminal");
var io_1 = require("../../script/utils/io");
var constants_1 = require("../../script/constants");
marked.setOptions({
    // Define custom renderer
    renderer: new TerminalRenderer()
});
exports.ROOT_PATH = path.join(__dirname, "..", "..");
exports.DOCS_PATH = path.join(exports.ROOT_PATH, 'docs');
exports.MISC_DOCS_PATH = path.join(exports.DOCS_PATH, 'misc');
exports.PACKAGE_DOCS_PATH = path.join(exports.DOCS_PATH, 'packages');
exports.README_PATH = path.join(exports.ROOT_PATH, 'README.md');
exports.LOGO_PATH = path.join(exports.MISC_DOCS_PATH, 'logo.txt');
exports.INFO_PATH = path.join(exports.MISC_DOCS_PATH, 'info.txt');
exports.BITS_DOCS_PATH = path.join(exports.PACKAGE_DOCS_PATH, 'bits.md');
exports.BYTES_DOCS_PATH = path.join(exports.PACKAGE_DOCS_PATH, 'bytes.md');
exports.MATH_DOCS_PATH = path.join(exports.PACKAGE_DOCS_PATH, 'math.md');
exports.PATRICIA_TREE_DOCS_PATH = path.join(exports.PACKAGE_DOCS_PATH, 'patricia_tree.md');
exports.STRINGS_DOCS_PATH = path.join(exports.PACKAGE_DOCS_PATH, 'strings.md');
exports.TOKEN_DOCS_PATH = path.join(exports.PACKAGE_DOCS_PATH, 'token.md');
exports.UNSAFE_DOCS_PATH = path.join(exports.PACKAGE_DOCS_PATH, 'unsafe.md');
exports.markedOptions = {
    showSectionPrefix: false,
};
exports.BACK_CHOICE = {
    key: 'b',
    name: 'Back',
    value: "back"
};
exports.EXIT_CHOICE = {
    key: 'e',
    name: 'Exit',
    value: 'exit'
};
exports.NAV_CHOICES = [exports.BACK_CHOICE, exports.EXIT_CHOICE];
exports.SEPARATOR = [new inquirer.Separator()];
exports.LIB_CHOICES = [{
        key: '1',
        name: 'Bits',
        value: 'bits'
    },
    {
        key: '2',
        name: 'Bytes',
        value: 'bytes'
    },
    {
        key: '3',
        name: 'Math',
        value: 'math'
    },
    {
        key: '4',
        name: 'Patricia Tree',
        value: 'patricia_tree'
    },
    {
        key: '5',
        name: 'Strings',
        value: 'strings'
    },
    {
        key: '6',
        name: 'Token',
        value: 'token'
    },
    {
        key: '7',
        name: 'Unsafe',
        value: 'unsafe'
    }
];
exports.librarySelectionData = function (name) {
    return {
        type: 'checkbox',
        message: 'Pick libraries (choose none to go back)',
        name: name,
        choices: [
            {
                name: 'Bits',
                value: constants_1.UNITS[0]
            },
            {
                name: 'Bytes',
                value: constants_1.UNITS[1]
            },
            {
                name: 'Math',
                value: constants_1.UNITS[2]
            },
            {
                name: 'Patricia Tree',
                value: constants_1.UNITS[3]
            },
            {
                name: 'Strings',
                value: constants_1.UNITS[4]
            },
            {
                name: 'Unsafe',
                value: constants_1.UNITS[5]
            },
            {
                name: 'Extended',
                value: constants_1.UNITS_EXTENDED
            },
        ]
    };
};
exports.printDelim = function (text) {
    io_1.println('-- DOC START --');
    io_1.println(text);
    io_1.println('-- DOC END --');
};
exports.printFile = function (filePath, delimited) {
    if (delimited === void 0) { delimited = true; }
    var text = io_1.readText(filePath);
    if (delimited) {
        exports.printDelim(text);
    }
    else {
        io_1.println(text);
    }
};
exports.printMarkdownFile = function (filePath, delimited) {
    if (delimited === void 0) { delimited = true; }
    var text = marked(io_1.readText(filePath), exports.markedOptions);
    if (delimited) {
        exports.printDelim(text);
    }
    else {
        io_1.println(text);
    }
};
exports.printLogo = function () {
    exports.printFile(exports.LOGO_PATH, false);
};
exports.printInfo = function () {
    exports.printFile(exports.INFO_PATH);
};
exports.prompt = function (promptData) { return __awaiter(_this, void 0, void 0, function () {
    return __generator(this, function (_a) {
        return [2 /*return*/, inquirer.prompt([promptData])];
    });
}); };
