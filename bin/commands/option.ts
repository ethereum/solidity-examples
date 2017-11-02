export class Option {

    private __name: string;
    private __shortForm: string;
    private __info: string;

    public constructor(name: string, shortForm: string, info: string) {
        this.__name = name;
        this.__shortForm = shortForm;
        this.__info = info;
    }

    public name(): string {
        return this.__name;
    }

    public shortForm(): string {
        return this.__shortForm;
    }

    public info(): string {
        return this.__info;
    }
}

export const OPTIONS: { [name: string]: Option } = {
    help: new Option('help', 'H', 'Display the help-text for the given command.'),
    version: new Option('version', 'V', 'Show the current version.'),
    optAndUnopt: new Option('optAndUnopt', 'O', 'Run the suit both with optimized and un-opttimized code.'),
    extended: new Option('extended', 'E', 'Include the extended tests/performance units.'),
    silent: new Option('silent', 'S', 'Do not show a detailed results from tests or perf.'),
    diff: new Option('diff', 'I', 'Compare perf results with the results from the previous perf (if any).')
};

export const GLOBAL_OPTIONS: { [name: string]: Option } = {
    debug: new Option('debug', 'D', 'Enable debug logging.')
};
