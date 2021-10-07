function decodeBase64() {
  const textEditor = atom.workspace.getActiveTextEditor();
  const selections = textEditor.getSelections();
  selections.forEach(selection => {
    selection.insertText(decodeURIComponent(escape(atob(selection.getText()))), { select: true })
  })
}

function alignSpacing() {
  const textEditor = atom.workspace.getActiveTextEditor();
  const checkpoint = textEditor.buffer.createCheckpoint();
  const selections = textEditor.getSelections();
  const maxColumn = selections.reduce((maxColumn, selection) => Math.max(maxColumn, selection.getBufferRange().start.column), 0)
  selections.forEach((selection) => {
    const start = selection.getBufferRange().start.column;
    const spaces = " ".repeat(maxColumn - start);
    selection.insertText(spaces + selection.getText());
  })
  textEditor.buffer.groupChangesSinceCheckpoint(checkpoint)
}

function evalJS() {
  const textEditor = atom.workspace.getActiveTextEditor();
  const checkpoint = textEditor.buffer.createCheckpoint();
  const selections = textEditor.getSelections();
  const texts = selections.map(selection => selection.getText())
  const evalled = texts.map(txt => eval(txt))
  selections.forEach((selection, i) => selection.insertText(String(evalled[i])))
  textEditor.buffer.groupChangesSinceCheckpoint(checkpoint)
}

function pythonClean() {
  const textEditor = atom.workspace.getActiveTextEditor();
  const checkpoint = textEditor.buffer.createCheckpoint();
  const selections = textEditor.getSelections();
  const texts = selections.map(selection => selection.getText())
  const replaced = texts.map(txt => txt.replace(/'/g, '"').replace(/Decimal\(/gi, '').replace(/\)/, ''))
  selections.forEach((selection, i) => selection.insertText(replaced[i]))
  textEditor.buffer.groupChangesSinceCheckpoint(checkpoint)
}

function now() {
  atom.notifications.addSuccess(new Date().toLocaleString());
}

module.exports = {
  decodeBase64,
  alignSpacing,
  evalJS,
  pythonClean,
  now,
}
