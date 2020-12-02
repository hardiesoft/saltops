import yaml from "yaml";
import fs from "fs";
import {exec} from "child_process";

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
const now = new Date();
const separator = "____\n";
let versionOutput = "";
let prevVersionOutput = "";

process.chdir("../../../");
// For each branch:
const branches = ["dev", "test", "prod"];
for (const branch of branches) {
    process.chdir(`./${branch}`);
    const slsFiles = getFilesWithExtension(".", "sls");
    versionData[branch] = {};
    for (const path of slsFiles) {
        const data = fs.readFileSync(path, "utf8");
        try {
            const yamlData = yaml.parse(data);
            const versionInfo = findKeyInObject(yamlData, "cacophony.pkg_installed_from_github");
            const name = versionInfo.find(item => item.hasOwnProperty("name")).name;
            const version = versionInfo.find(item => item.hasOwnProperty("version")).version;
            versionData[branch][name] = version;
        } catch (e) {}
    }
    process.chdir("../");
}

// Output the text to the README.md file, if the version info has changed since last time.
for (const branch of branches) {
    versionOutput += `#### Branch \`${branch}\`\n`;
    for (const [key, val] of Object.entries(versionData[branch])) {
        versionOutput += ` * ${key}: ${val}\n`;
    }
}
console.log("Version output", versionOutput);
for (const branch of branches) {
    process.chdir(`./${branch}`);
    console.log("in branch", branch, exec("ls -la"));
    const readme = fs.readFileSync("README.md", "utf8");
    const versionInfoStart = readme.indexOf("\n\n#### Version information");
    let output;
    if (versionInfoStart !== -1) {
        output = readme.substring(0, versionInfoStart);
        prevVersionOutput = readme.substring(readme.indexOf(separator) + separator.length);
    } else {
        output = readme;
    }
    output += "\n\n#### Version information ";
    output += `(_Updated ${now.toLocaleString("en-NZ", { timeZone: "Pacific/Auckland" })}_):\n`;
    output += separator;
    output += versionOutput;
    if (versionOutput !== prevVersionOutput) {
        fs.writeFileSync("README.md", output);
        // exec("git config user.name github-actions");
        // exec("git config user.email github-actions@github.com");
        // exec("git add .");
        // exec("git commit -m \"updated version information\"");
        // exec("git push");

    } else {
        // Version info is unchanged.
        console.log("unchanged");
    }
    process.chdir("../");
}

