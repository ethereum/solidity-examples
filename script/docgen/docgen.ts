import {latestPerfLog} from "../utils/io";
import {readFileSync, writeFileSync} from "fs";
import {join} from 'path';
import {PACKAGE_DOCS_DATA_FOLDER} from "../constants";
import {PACKAGE_DOCS_PATH} from "../../bin/prompt/utils";

interface IParam {
    name?: string;
    type: string;
    refType?: 'memory' | 'storage';
    desc?: string;
}

interface IFunc {
    name: string;
    desc: string;
    visibility: 'external' | 'public' | 'internal' | 'private';
    qualifier: 'payable' | 'view' | 'pure';
    modifiers?: string[];
    inParams?: IParam[];
    outParams?: IParam[];
    requires?: string[];
    ensures?: string[];
    gas?: Array<[string, string]>;
}

class AnchorWriter {
    private found: { [map: string]: number } = {};

    public getAnchor(name: string): string {
        const num = this.found[name];
        if (num === undefined || num === 0) {
            this.found[name] = 1;
            return name;
        }
        if (num > 0) {
            this.found[name]++;
            return `${name}_${num}`;
        }
    }
}

const SPACES = "                                                                                      ";

const newline = () => `\n`;

const divider = () => `***\n\n`;

const inset = (sec: string[], spaces: number = 0) => {
    const ret = [];
    for (const s of sec) {
        const len = s.length + spaces;
        ret.push(`${SPACES}${s}`.slice(-len));
    }
};

const headLine = (str: string, level: number = 0) => {
    switch (level) {
        case 1:
            return `# ${str}\n\n`;
        case 2:
            return `## ${str}\n\n`;
        case 3:
            return `### ${str}\n\n`;
        case 4:
            return `#### ${str}\n\n`;
        case 5:
            return `##### ${str}\n\n`;
        default:
            throw new Error("Headline level OOB");
    }
};

const paragraph = (str: string) => `${str}\n\n`;

const funcName = (func: IFunc) => `${func.name}(${func.inParams.map((elem) => elem.type).join(', ')})`;

const paramTypeAndName = (param: IParam) => {
    let str = param.type;
    if (param.refType) {
        str += ` ${param.refType}`;
    }
    if (param.name) {
        str += ` ${param.name}`;
    }
    return `${str}`;
};

const paramDisp = (param: IParam) => {
    if (param.desc) {
        return `\`${paramTypeAndName(param)}\`: ${param.desc}`;
    } else {
        return `\`${paramTypeAndName(param)}\``;
    }
};

const funcSig = (func: IFunc) => {
    let str = `function ${funcName(func)} ${func.visibility} ${func.qualifier}`;
    if (func.modifiers && func.modifiers.length > 0) {
        str += func.modifiers.join(' ');
    }
    if (func.outParams !== undefined && func.outParams.length > 0) {
        let returns = `returns (`;
        for (const p of func.outParams) {
            returns += paramTypeAndName(p);
        }
        returns += `)`;
        str += ` ${returns}`;
    }
    return `\`${str}\``;
};

const writeFunction = (aw: AnchorWriter, perf: object, func: IFunc, level: number = 3) => {
    const lines = [];
    lines.push(divider());
    const name = funcName(func);
    lines.push(headLine(`<a name="${aw.getAnchor(func.name)}"/>${name}`, level));
    lines.push(funcSig(func) + '\n\n');
    lines.push(paragraph(func.desc));
    if (func.inParams && func.inParams.length > 0) {
        lines.push(headLine("params", level + 2));
        for (const p of func.inParams) {
            lines.push(`- ${paramDisp(p)}\n`);
        }
    }
    lines.push(newline());
    if (func.requires && func.requires.length > 0) {
        lines.push(headLine("requires", level + 2));
        for (const r of func.requires) {
            lines.push(`- ${r}\n`);
        }
    }
    lines.push(newline());
    if (func.inParams && func.inParams.length > 0) {
        lines.push(headLine("returns", level + 2));
        for (const p of func.outParams) {
            lines.push(`- ${paramDisp(p)}\n`);
        }
    }
    lines.push(newline());
    if (func.ensures && func.ensures.length > 0) {
        lines.push(headLine("ensures", level + 2));
        for (const e of func.ensures) {
            lines.push(`- ${e}\n`);
        }
    }
    if (func.gas && func.gas.length > 0) {
        lines.push(headLine("gascosts", level + 2));
        for (const g of func.gas) {
            const prf = perf["results"][g[1]];
            if (prf === undefined) {
                throw new Error(`No perf acailable for: ${g[1]}`);
            }
            lines.push(`- ${g[0]}: ${prf.gasUsed}\n`);
        }
    }
    lines.push(newline());
    return lines;
};

const createFunctions = (aw: AnchorWriter, perf: object, funcs: IFunc[], level: number = 3) => {
    let lines = [];
    for (const func of funcs) {
        lines = lines.concat(writeFunction(aw, perf, func, level));
    }
    return lines;
};

const createFuncTOC = (aw: AnchorWriter, funcs: IFunc[]) => {
    const lines = [];
    for (const f of funcs) {
        lines.push(`- [${funcName(f)}](#${aw.getAnchor(f.name)})\n`);
    }
    lines.push(newline());
    return lines;
};

const createFuncSection = (funcs: IFunc[], level: number = 2) => {
    const perf = latestPerfLog();
    let lines = [];
    lines.push(headLine("Functions", level));
    lines = lines.concat(createFuncTOC(new AnchorWriter(), funcs));
    lines = lines.concat(createFunctions(new AnchorWriter(), perf, funcs, level + 1));
    return lines;
};

const createPackageDocs = (docJson: object, intro: string) => {
    let root = [];
    root.push(`${headLine(docJson["name"], 1)}\n\n`);
    root.push(`**Package:** ${docJson["package"]}\n\n`);
    root.push(`**Contract type:** ${docJson["type"]}\n\n`);
    root.push(intro);
    root.push(newline());
    root.push(newline());
    const name = docJson["name"] + "Examples.sol";
    root.push(`**Example usage:** [${name}](../../examples/${docJson["package"]}/${name})})\n\n`);
    root = root.concat(createFuncSection(docJson["functions"]));
    return root.join('');
};

const writeDocs = () => {
    const bitsJson = JSON.parse(readFileSync(join(PACKAGE_DOCS_DATA_FOLDER, "bits.json")).toString());
    const intro = readFileSync(join(PACKAGE_DOCS_DATA_FOLDER, bitsJson["intro"])).toString();
    const bitsMd = createPackageDocs(bitsJson, intro);
    writeFileSync(join(PACKAGE_DOCS_PATH, bitsJson.name + '.md'), bitsMd);
};

writeDocs();
