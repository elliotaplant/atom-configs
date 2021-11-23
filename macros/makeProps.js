function makeProps() {
  const editor = atom.workspace.getActiveTextEditor();
  const allWords = editor.cursors.every((cursor) => cursor.isInsideWord());
  if (!allWords) {
    atom.atom.notifications.addError("All cursors must be on words", {
      dismissable: true,
    });
    return;
  }

  editor.cursors.forEach((cursor) => {
    const wordRange = cursor.getCurrentWordBufferRange();
    const componentName = editor.getTextInBufferRange(wordRange);
    const propsInterface = `${componentName}Props`;

    const hasProps = cursor.getCurrentBufferLine().includes("({");
    const lastParenIndex = cursor.getCurrentBufferLine().lastIndexOf(")");

    if (hasProps && lastParenIndex > cursor.getBufferColumn()) {
      editor.buffer.insert(
        [wordRange.start.row, lastParenIndex],
        `: ${propsInterface}`
      );
    }

    editor.buffer.insert(
      [wordRange.start.row, 0],
      `interface ${propsInterface} {\n}\n\n`
    );
  });
}

module.exports = {
  makeProps,
};
