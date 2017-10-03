import {
    BITS_DOCS_PATH, BYTES_DOCS_PATH, LIB_CHOICES, MATH_DOCS_PATH, NAV_CHOICES, PATRICIA_TREE_DOCS_PATH,
    printMarkdownFile, prompt, README_PATH,
    SEPARATOR, STRINGS_DOCS_PATH, TOKEN_DOCS_PATH, UNSAFE_DOCS_PATH
} from "./utils";

export const docsPrompt = {
    type: 'list',
    name: 'docs',
    message: 'Select an action to perform',
    choices: [
        {
            key: 'r',
            name: 'README',
            value: 'readme'
        }].concat(SEPARATOR).concat(LIB_CHOICES).concat(SEPARATOR).concat(NAV_CHOICES)
};

export const docsMenu = async (): Promise<void> => {
    const selected = await prompt(docsPrompt);
    switch (selected.docs) {
        case "readme":                           // General docs
            printMarkdownFile(README_PATH);
            break;
        case "bits":                             // Libs
            printMarkdownFile(BITS_DOCS_PATH);
            break;
        case "bytes":
            printMarkdownFile(BYTES_DOCS_PATH);
            break;
        case "math":
            printMarkdownFile(MATH_DOCS_PATH);
            break;
        case "patricia_tree":
            printMarkdownFile(PATRICIA_TREE_DOCS_PATH);
            break;
        case "strings":
            printMarkdownFile(STRINGS_DOCS_PATH);
            break;
        case "token":
            printMarkdownFile(TOKEN_DOCS_PATH);
            break;
        case "unsafe":
            printMarkdownFile(UNSAFE_DOCS_PATH);
            break;
        case "back":                             // Navigation
            return;
        case "exit":
            process.exit(0);
            break; // Make linter shut up.
        default:
            process.exit(1);
    }
    await docsMenu();
};
