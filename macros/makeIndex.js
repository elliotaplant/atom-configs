const fs = require("fs");
const path = require("path");

function makeIndexTs(joiner) {
  const editor = atom.workspace.getActiveTextEditor();
  const directoryPath = editor.getDirectoryPath();
  const indexFilePath = path.join(directoryPath, "index.ts");

  const files = fs
    .readdirSync(directoryPath)
    .filter((entry) => fs.lstatSync(path.join(directoryPath, entry)).isFile());

  const withoutExistingIndex = files.filter(
    (fileName) => fileName !== "index.ts"
  );
  const onlyTsFiles = withoutExistingIndex.filter(
    (fileName) => fileName.endsWith(".ts") || fileName.endsWith(".tsx")
  );
  const noTestFiles = onlyTsFiles.filter(
    (fileName) => !(fileName.includes('.spec.') || fileName.includes('.test.'))
  );
  const withoutExtensions = noTestFiles.map((fileName) =>
    fileName.replace(/\.tsx?$/g, "")
  );

  const indexFileContents = withoutExtensions
    .map((fileName) => `export * from './${fileName}';`)
    .sort()
    .join("\n") + "\n";

  fs.writeFileSync(indexFilePath, indexFileContents);
}

module.exports = { makeIndexTs };
