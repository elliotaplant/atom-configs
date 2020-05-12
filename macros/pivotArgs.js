// pivotArgs
// turns functionCall(arg, arg2, arg3) into
// functionCall(
//   arg,
//   arg2,
//   arg3,
// )

function pivotArgs(joiner) {
  const editor = atom.workspace.getActiveTextEditor()
  const openCharToCloseChar = { '(': ')', '[': ']', '{': '}' }
  const openingChars = new Set(Object.keys(openCharToCloseChar))
  const closingChars = new Set(Object.values(openCharToCloseChar))

  function charAt(row, column) {
    const range = [[row, column], [row, column + 1]]
    return editor.getTextInBufferRange(range)
  }

  function findOpenChar(startRow, startColumn) {
    let closeCount = 0;
    let currentRow = startRow;
    let currentColumn = startColumn - 1;
    while (currentRow >= 0) {
      const char = charAt(currentRow, currentColumn);
      if (openingChars.has(char)) {
        if (closeCount === 0) {
          return {row: currentRow, column: currentColumn, char}
        } else {
          closeCount--
        }
      } else if (closingChars.has(char)) {
        closeCount++
      }
      currentColumn--
      if (currentColumn < 0) {
        currentRow--
        line = editor.lineTextForBufferRow(currentRow)
        currentColumn = line ? line.length : 0;
      }
    }
    return null
  }

  function findCloseChar(startRow, startColumn, openChar) {
    let openCount = 0
    let currentRow = startRow
    let currentColumn = startColumn
    const closeChar = openCharToCloseChar[openChar]
    while (currentRow <= editor.getLineCount()) {
      if (charAt(currentRow, currentColumn) === closeChar) {
        if (openCount === 0) {
          return {row: currentRow, column: currentColumn, char: closeChar}
        } else {
          openCount--
        }
      } else if (charAt(currentRow, currentColumn) == openChar) {
        openCount++
      }
      currentColumn++
      line = editor.lineTextForBufferRow(currentRow)
      if (!line) {
        return null
      } else if (currentColumn > line.length) {
        currentRow++
        currentColumn = 0
      }
    }
    return null
  }

  editor.cursors.forEach(cursor => {
    const { row, column } = cursor.getBufferPosition();
    const openChar = findOpenChar(row, column);
    const closeChar = findCloseChar(row, column, openChar.char);
    if (!openChar || !closeChar) {
      return null
    }

    const range = [[openChar.row, openChar.column], [closeChar.row, closeChar.column]];
    const currentContents = cursor.editor.getTextInBufferRange(range).slice(1);
    const argList = currentContents.split(',').map(arg => arg.trim());
    if (openChar.row == closeChar.row) {
      const verticalList = openChar.char + '\n' + argList.join(',\n') + '\n'
      cursor.editor.setTextInBufferRange(range, verticalList)
    } else {
      const horizontalList = openChar.char + argList.join(', ') + ''
      cursor.editor.setTextInBufferRange(range, horizontalList)
    }
  })
}

module.exports = { pivotArgs }
