const catchall = require('./catchall');
const pasteJoined = require('./pasteJoined');
const pivotArgs = require('./pivotArgs');
const setStuff = require('./setStuff');
const togglePointers = require('./togglePointers');
const findAndReplace = require('./findAndReplace');

const allMacros = {
  ...catchall,
  ...pasteJoined,
  ...pivotArgs,
  ...setStuff,
  ...togglePointers,
  ...findAndReplace,
};

for (const macroFunctionName in allMacros) {
  atom.commands.add('atom-text-editor', `macroon:${macroFunctionName}`, () => allMacros[macroFunctionName]());
}
