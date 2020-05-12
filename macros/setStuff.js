function getSets(editor) {
  const textSets = [];
  editor.cursors.forEach((cursor) => {
    const { selection } = cursor;
    const { start, end } = selection.getBufferRange();
    cursor.setBufferPosition(end);
    selection.setBufferRange([[start.row, 0], [end.row, end.column]]);
    selection.selectToEndOfLine();
    const selectionSet = selection.getText().split('\n').filter(Boolean)
    textSets.push(new Set(selectionSet))
  })
  return textSets;
}

function setFirst(text, editor) {
  const { start } = editor.selections[0].getBufferRange()
  editor.selections.forEach(selection => selection.delete());
  editor.selections[0].insertText([...text].join('\n'))
  editor.cursors.forEach(c => c.setBufferPosition(start))
}

function union() {
  const editor = atom.workspace.getActiveTextEditor()
  const textSets = getSets(editor);
  const unionSet = textSets.reduce((unionSet, textSet) => new Set([...unionSet, ...textSet]), new Set());
  setFirst(unionSet, editor)
}

function intersection() {
  const editor = atom.workspace.getActiveTextEditor()
  const [firstSet, ...rest] = getSets(editor);
  const intersectionSet = new Set([...firstSet].filter((item) => rest.some(set => set.has(item))));
  setFirst(intersectionSet, editor)
}

function leftOuter() {
  const editor = atom.workspace.getActiveTextEditor()
  const [firstSet, ...rest] = getSets(editor);
  const leftOuterSet = new Set([...firstSet].filter((item) => !rest.some(set => set.has(item))));
  setFirst(leftOuterSet, editor)
}

module.exports = {
  union,
  intersection,
  leftOuter,
}
