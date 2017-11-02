import * as inquirer from 'inquirer';
import {println, readText} from "../../script/utils/io";

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

export const prompt = async (promptData) => {
    return inquirer.prompt([promptData]);
};
