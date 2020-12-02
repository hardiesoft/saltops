import yaml from "yaml";
import fs from "fs";

//process.chdir("../../");
const getFilesWithExtension = (path, ext) => {
    const items = fs.readdirSync(path)
        .filter(item => (
            !item.startsWith(".") &&
            !item.startsWith("_") &&
            (item.endsWith(`.${ext}`) || fs.lstatSync(`${path}/${item}`).isDirectory())
        ))
        .map(item => ({ name: item, isDir: fs.lstatSync(`${path}/${item}`).isDirectory() }));
    let files = [];
    for (const item of items) {
        if (item.isDir) {
            files = [...files, ...getFilesWithExtension(`${path}/${item.name}`, ext)];
        } else {
            files.push(`${path}/${item.name}`);
        }
    }
    return files;
}
const slsFiles = getFilesWithExtension(".", "sls");

const findKeyInObject = (obj, key) => {
    for (const [k, v] of Object.entries(obj)) {
        if (k === key) {
            return v;
        } else if (typeof v === 'object') {
            const deeper = findKeyInObject(v, key);
            if (deeper !== false) {
                return deeper;
            }
        }
    }
    return false;
}

const versionData = {};
for (const path of slsFiles) {
    const data = fs.readFileSync(path, "utf8");
    try {
        const yamlData = yaml.parse(data);
        const versionInfo = findKeyInObject(yamlData, "cacophony.pkg_installed_from_github");
        const name = versionInfo.find(item => item.hasOwnProperty("name")).name;
        const version = versionInfo.find(item => item.hasOwnProperty("version")).version;
        versionData[name] = version;
    } catch (e) {}
}
console.log(versionData);


