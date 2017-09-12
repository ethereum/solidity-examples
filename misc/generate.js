const fs = require('fs');

const TYPE_TOKEN='$(T)';
const TV_TOKEN='$(TV)';
const TV2_TOKEN='$(TV2)';
const TV3_TOKEN='$(TV3)';

replace('address', '1', '2', '3');

function replace(type, tv, tv2, tv3) {
    const template = fs.readFileSync('IterableSet.solt').toString();
    const name = 'Iterable' + type.substr(0, 1).toUpperCase() + type.substr(1) + 'Set';
    const processed = resolve(template, name, type, tv, tv2, tv3);
    fs.writeFileSync(name + '.sol', processed);
}

function resolve(data, name, type, tv, tv2, tv3) {
    while(data.indexOf('IterableSet') >= 0) {
        data = data.replace('IterableSet', name);
    }
    while(data.indexOf(TYPE_TOKEN) >= 0) {
        data = data.replace(TYPE_TOKEN, type);
    }
    while(data.indexOf(TV_TOKEN) >= 0) {
        data = data.replace(TV_TOKEN, tv);
    }
    while(data.indexOf(TV2_TOKEN) >= 0) {
        data = data.replace(TV2_TOKEN, tv2);
    }
    while(data.indexOf(TV3_TOKEN) >= 0) {
        data = data.replace(TV3_TOKEN, tv3);
    }
    return data;
}