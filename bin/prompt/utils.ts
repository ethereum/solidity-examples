import * as inquirer from 'inquirer';
import * as path from 'path';
import * as marked from 'marked';
import * as TerminalRenderer from 'marked-terminal';
import {println, readText} from "../../script/utils/io";
import {UNITS, UNITS_EXTENDED} from "../../script/constants";

marked.setOptions({
    // Define custom renderer
    renderer: new TerminalRenderer()
});

export const ROOT_PATH = path.join(__dirname, "..", "..");
export const DOCS_PATH = path.join(ROOT_PATH, 'docs');
export const MISC_DOCS_PATH = path.join(DOCS_PATH, 'misc');
export const PACKAGE_DOCS_PATH = path.join(DOCS_PATH, 'packages');

export const README_PATH = path.join(ROOT_PATH, 'README.md');

export const LOGO_PATH = path.join(MISC_DOCS_PATH, 'logo.txt');
export const INFO_PATH = path.join(MISC_DOCS_PATH, 'info.txt');

export const BITS_DOCS_PATH = path.join(PACKAGE_DOCS_PATH, 'bits.md');
export const BYTES_DOCS_PATH = path.join(PACKAGE_DOCS_PATH, 'bytes.md');
export const MATH_DOCS_PATH = path.join(PACKAGE_DOCS_PATH, 'math.md');
export const PATRICIA_TREE_DOCS_PATH = path.join(PACKAGE_DOCS_PATH, 'patricia_tree.md');
export const STRINGS_DOCS_PATH = path.join(PACKAGE_DOCS_PATH, 'strings.md');
export const TOKEN_DOCS_PATH = path.join(PACKAGE_DOCS_PATH, 'token.md');
export const UNSAFE_DOCS_PATH = path.join(PACKAGE_DOCS_PATH, 'unsafe.md');

export const markedOptions = {
    showSectionPrefix: false,
};

export const BACK_CHOICE = {
    key: 'b',
    name: 'Back',
    value: "back"
};

export const EXIT_CHOICE = {
    key: 'e',
    name: 'Exit',
    value: 'exit'
};

export const NAV_CHOICES = [BACK_CHOICE, EXIT_CHOICE];

export const SEPARATOR = [new inquirer.Separator()];

export const LIB_CHOICES = [{
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

export const librarySelectionData = (name: string) => {
    return {
        type: 'checkbox',
        message: 'Select libraries',
        name,
        choices: [
            {
                name: 'Bits',
                value: UNITS[0]
            },
            {
                name: 'Bytes',
                value: UNITS[1]
            },
            {
                name: 'Math',
                value: UNITS[2]
            },
            {
                name: 'Patricia Tree',
                value: UNITS[3]
            },
            {
                name: 'Strings',
                value: UNITS[4]
            },
            {
                name: 'Unsafe',
                value: UNITS[5]
            },
            {
                name: 'Extended',
                value: UNITS_EXTENDED
            },
        ],
        validate: (answers: string[]) => {
            if (answers.length < 1) {
                return 'You must choose at least one library.';
            }
            return true;
        }
    };
};

export const printDelim = (text: string) => {
    println('-- DOC START --');
    println(text);
    println('-- DOC END --');
};

export const printFile = (filePath: string, delimited: boolean = true) => {
    const text = readText(filePath);
    if (delimited) {
        printDelim(text);
    } else {
        println(text);
    }
};

export const printMarkdownFile = (filePath: string, delimited: boolean = true) => {
    const text = marked(readText(filePath), markedOptions);
    if (delimited) {
        printDelim(text);
    } else {
        println(text);
    }
};

export const printLogo = () => {
    printFile(LOGO_PATH, false);
};

export const printInfo = () => {
    printFile(INFO_PATH);
};

export const prompt = async (promptData) => {
    return inquirer.prompt([promptData]);
};
