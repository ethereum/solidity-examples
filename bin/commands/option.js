"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var Option = /** @class */ (function () {
    function Option(name, shortForm, info) {
        this.__name = name;
        this.__shortForm = shortForm;
        this.__info = info;
    }
    Option.prototype.name = function () {
        return this.__name;
    };
    Option.prototype.shortForm = function () {
        return this.__shortForm;
    };
    Option.prototype.info = function () {
        return this.__info;
    };
    return Option;
}());
exports.Option = Option;
exports.OPTIONS = {
    help: new Option('help', 'H', 'Display the help-text for the given command.'),
    version: new Option('version', 'V', 'Show the current version.'),
    optAndUnopt: new Option('optAndUnopt', 'O', 'Run the suit both with optimized and un-opttimized code.'),
    extended: new Option('extended', 'E', 'Include the extended tests/performance units.'),
    silentTests: new Option('silentTests', 'S', 'Only failed tests are reported in the console.')
};
exports.GLOBAL_OPTIONS = {
    debug: new Option('debug', 'D', 'Enable debug logging.')
};
