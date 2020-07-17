const path = require('path');

async function searchInCurrentFolder() {
  await atom.commands.dispatch(atom.views.getView(atom.workspace), 'project-find:show')
  if (atom.packages.isPackageActive('find-and-replace')) {
    const rootDir = atom.workspace.project.rootDirectories[0].path;
    const currentDir = atom.workspace.getActiveTextEditor().getDirectoryPath();
    const projectPath = path.relative(rootDir, currentDir);
    const findAndReplace = atom.packages.getActivePackage('find-and-replace');
    findAndReplace.mainModule.projectFindView.pathsEditor.setText(projectPath);

    // findAndReplace.mainModule.projectFindPanel.show()

  }
}

module.exports = {
  searchInCurrentFolder,
};
