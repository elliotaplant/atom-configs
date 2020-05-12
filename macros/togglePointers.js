function togglePointers() {
  atom.workspace.getActiveTextEditor().cursors.forEach(cursor => {
    const { row, column } = cursor.getBufferPosition();
    const range = [
      [row, column],
      [row, column + 1]
    ];
    const currentContents = cursor.editor.getTextInBufferRange(range);
    if (currentContents == '*') {
      cursor.editor.setTextInBufferRange(range, '&');
    } else if (currentContents == '&') {
      cursor.editor.setTextInBufferRange(range, '*');
    }
  });
};

module.exports = { togglePointers }
