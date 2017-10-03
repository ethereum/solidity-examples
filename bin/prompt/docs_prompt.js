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
var utils_1 = require("./utils");
exports.docsPrompt = {
    type: 'list',
    name: 'docs',
    message: 'Select an action to perform',
    choices: [
        {
            key: 'r',
            name: 'README',
            value: 'readme'
        }
    ].concat(utils_1.SEPARATOR).concat(utils_1.LIB_CHOICES).concat(utils_1.SEPARATOR).concat(utils_1.NAV_CHOICES)
};
exports.docsMenu = function () { return __awaiter(_this, void 0, void 0, function () {
    var selected;
    return __generator(this, function (_a) {
        switch (_a.label) {
            case 0: return [4 /*yield*/, utils_1.prompt(exports.docsPrompt)];
            case 1:
                selected = _a.sent();
                switch (selected.docs) {
                    case "readme":// General docs
                        utils_1.printMarkdownFile(utils_1.README_PATH);
                        break;
                    case "bits":// Libs
                        utils_1.printMarkdownFile(utils_1.BITS_DOCS_PATH);
                        break;
                    case "bytes":
                        utils_1.printMarkdownFile(utils_1.BYTES_DOCS_PATH);
                        break;
                    case "math":
                        utils_1.printMarkdownFile(utils_1.MATH_DOCS_PATH);
                        break;
                    case "patricia_tree":
                        utils_1.printMarkdownFile(utils_1.PATRICIA_TREE_DOCS_PATH);
                        break;
                    case "strings":
                        utils_1.printMarkdownFile(utils_1.STRINGS_DOCS_PATH);
                        break;
                    case "token":
                        utils_1.printMarkdownFile(utils_1.TOKEN_DOCS_PATH);
                        break;
                    case "unsafe":
                        utils_1.printMarkdownFile(utils_1.UNSAFE_DOCS_PATH);
                        break;
                    case "back":// Navigation
                        return [2 /*return*/];
                    case "exit":
                        process.exit(0);
                        break; // Make linter shut up.
                    default:
                        process.exit(1);
                }
                return [4 /*yield*/, exports.docsMenu()];
            case 2:
                _a.sent();
                return [2 /*return*/];
        }
    });
}); };
