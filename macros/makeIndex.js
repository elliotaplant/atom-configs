const { Directory, File } = require("pathwatcher");

async function makeIndexTs(joiner) {
  try {
    const editor = atom.workspace.getActiveTextEditor();
    const directoryPath = editor.getDirectoryPath();
    const indexFilePath = `${directoryPath}/index.ts`;
    const directory = new Directory(directoryPath);
    const indexFile = new File(indexFilePath);
    const created = await indexFile.create();
    const entries = directory.getEntriesSync();
    console.log("entries", entries);
    const filesToExport = entries
      .filter((entry) => entry instanceof File)
      .map((file) => file.path)
      .filter(
        (path) =>
          !path.endsWith("/index.ts") &&
          (path.endsWith(".ts") || path.endsWith(".tsx"))
      )
      .map((path) =>
        path
          .split("/")
          .slice(-1)[0]
          .replace(/\.tsx?$/g, "")
      );
    const indexFileContents = filesToExport
      .map((fileName) => `export * from './${fileName}';`)
      .sort()
      .join("\n");

    indexFile.writeSync(indexFileContents);
  } catch (e) {
    console.error(e);
  }
}

module.exports = { makeIndexTs };
