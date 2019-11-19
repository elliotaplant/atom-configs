# All functions defined on "this" are available as atom commands.
#
# If the `toolbar` package is installed, toolbar icons are automatically generated.
#
# Set these properties of your function to configure the icons:
# * icon - name of the icon (Or a method returning the icon name, possibly prepended with 'ion-' or 'fa-')
# * title - The toolbar title (or a method returning the title)
# * hideIcon - set to true to hide the icon from the toolbar
#

# helloWorld helloWorld helloWorld helloWorld


# If you prefer Javascript, write it between backticks.
# cycleVariableType
`
const availableFormats = {
  CAMEL_CASE: 'camelCase',
  SNAKE_CASE: 'snake_case',
  KEBOB_CASE: 'kebob-case',
  CONST_CASE: 'CONST_CASE',
  CLASS_CASE: 'ClassCase',
  SENTANCE_CASE: 'sentance case',
}
function getFormat(words) {
  if (words.includes(' ')) {
    return availableFormats.SENTANCE_CASE;
  }
  if (words[0] === words[0].toLowerCase()) {
    if (words.includes('_')) {
      return availableFormats.SNAKE_CASE;
    }
    if (words.includes('-')) {
      return availableFormats.KEBOB_CASE;
    }
    return availableFormats.CAMEL_CASE;
  } else if (words === words.toUpperCase()) {
    return availableFormats.CONST_CASE;
  }
  return availableFormats.CLASS_CASE;
}

function splitWords(words) {
  const format = getFormat(words);
  if (format === availableFormats.SENTANCE_CASE) {
    return words.split(' ');
  }
  if (format === availableFormats.KEBOB_CASE) {
    return words.split('-');
  }
  if (format === availableFormats.SNAKE_CASE || format === availableFormats.CONST_CASE) {
    return words.split('_');
  }
  if (format === availableFormats.CLASS_CASE || format === availableFormats.CAMEL_CASE) {
    return Array.from(words).map(char => {
      if (char === char.toUpperCase()) {
        return '_' + char;
      }
      return char;
    }).join('').split('_').filter(Boolean);
  }
}

function sendToFormat(words, format) {
  const splittedWords = splitWords(words);

  if (format === availableFormats.CAMEL_CASE) {
    return splittedWords.map((word, index) => {
      if (index > 0) {
        return word[0].toUpperCase() + word.slice(1).toLowerCase();
      }
      return word.toLowerCase();
    }).join('');
  }
  if (format === availableFormats.SNAKE_CASE) {
    return splittedWords.join('_').toLowerCase();
  }
  if (format === availableFormats.KEBOB_CASE) {
    return splittedWords.join('-').toLowerCase();
  }
  if (format === availableFormats.CONST_CASE) {
    return splittedWords.join('_').toUpperCase();
  }
  if (format === availableFormats.CLASS_CASE) {
    return splittedWords.map((word) => word[0].toUpperCase() + word.slice(1).toLowerCase()).join('');
  }
  if (format === availableFormats.SENTANCE_CASE) {
    return splittedWords.join(' ').toLowerCase();
  }
  return splittedWords.join(' ');
}

this.cycleVariableType = function() {
  const textEditor = atom.workspace.getActiveTextEditor();
  const selections = textEditor.getSelections();
  const selectionWords = selections.map(selection => selection.getText());
  if (selectionWords.filter(Boolean).length === 0) {
    return;
  }
  const formatOrder = [
    availableFormats.CONST_CASE,
    availableFormats.KEBOB_CASE,
    availableFormats.SNAKE_CASE,
    availableFormats.CAMEL_CASE,
    availableFormats.CLASS_CASE,
    availableFormats.SENTANCE_CASE,
  ];

  const formats = Array.from(new Set(selectionWords.map(words => getFormat(words))));
  console.log('formats[0]', formats[0])

  let formattedWords = selectionWords;
  let nextFormat = formatOrder[(formatOrder.indexOf(formats[0]) + 1) % formatOrder.length];
  console.log('nextFormat', nextFormat)
  if (formats.length > 1) {
    nextFormat = formats[0];
  }
  formattedWords = selectionWords.map(selectionText => sendToFormat(selectionText, nextFormat));
  selections.forEach((selection, index) => selection.insertText(formattedWords[index], { select: true }))
}
this.cycleVariableType.hideIcon = true; // dont show this on the toolbar
`

# pasteWithCommas
`
function pasteJoined(joiner) {
  const clipMeta = atom.clipboard.metadata
  if (clipMeta) {
    let toPaste = "";
    if (clipMeta.selections) {
      clipMeta.selections.map(selection => selection.text).join(joiner);

      toPaste = atom.clipboard.metadata.selections.map(selection => selection.text).join(joiner);
    } else {
      toPaste = atom.clipboard.read();
    }
    const te = atom.workspace.getActiveTextEditor()
    if (te) {
      te.selections.forEach(selection => selection.insertText(toPaste), { select: true });
    }
  }
}

this.pasteWithCommas = function() {
  pasteJoined(', ');
}
this.pasteWithCommas.hideIcon = true;

this.pasteWithCommaNewlines = function() {
  pasteJoined(',\n');
}
this.pasteWithCommaNewlines.hideIcon = true;
`

# collapseAll
@collapseAll = ->
  # dispatchEditorCommand('tree-view:collapse-all')
  # dispatchWorkspaceCommand('tree-view:collapse-all')
  dispatchEditorCommand('tree-view:toggle-focus')
    .then((e) -> console.log(e))
  # dispatchWorkspaceCommand('tree-view:collapse-all')
  #   .then(e => console.log(e))
  # dispatchWorkspaceCommand('tree-view:toggle')
  #   .then(() -> console.log('done!'))
  #   .then(() -> )
  #   .then(() -> console.log('well here we are!'))


  # dispatchEditorCommand('tree-view:collapse-all')
  # dispatchEditorCommand('tree-view:toggle-focus')


# propTypes
`
this.propTypes = function propTypes(joiner) {
  const componentLine = '.propTypes = {'
  const firstProptype = '  prop: PropTypes.string.isRequired,';
  const closing = '}';
  const importStatement = "import PropTypes from 'prop-types';"
  atom.workspace.getActiveTextEditor()
    .selections[0].insertText([
      componentLine,
      firstProptype,
      closing,
      importStatement,
    ].join('\n'))
}
`

# togglePointers
# Toggles * and & characters
`
this.togglePointers = function togglePointers(joiner) {
  atom.workspace.getActiveTextEditor().cursors.forEach(cursor => {
    const { row, column } = cursor.getBufferPosition()
    const range = [[row, column], [row, column + 1]]
    const currentContents = cursor.editor.getTextInBufferRange(range)
    if (currentContents == '*') {
      cursor.editor.setTextInBufferRange(range, '&')
    } else if (currentContents == '&') {
      cursor.editor.setTextInBufferRange(range, '*')
    }
  })
}
`

# pivotArgs
# turns functionCall(arg, arg2, arg3) into
# functionCall(
#   arg,
#   arg2,
#   arg3,
# )
`
this.pivotArgs = function pivotArgs(joiner) {
  const editor = atom.workspace.getActiveTextEditor()

  function charAt(row, column) {
    const range = [[row, column], [row, column + 1]]
    return editor.getTextInBufferRange(range)
  }

  function findOpenParen(startRow, startColumn) {
    let closeCount = 0;
    let currentRow = startRow;
    let currentColumn = startColumn - 1;
    while (currentRow >= 0) {
      if (charAt(currentRow, currentColumn) === '(') {
        if (closeCount === 0) {
          return {row: currentRow, column: currentColumn}
        } else {
          closeCount--
        }
      } else if (charAt(currentRow, currentColumn) == ')') {
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

  function findCloseParen(startRow, startColumn) {
    let openCount = 0
    let currentRow = startRow
    let currentColumn = startColumn
    while (currentRow <= editor.getLineCount()) {
      if (charAt(currentRow, currentColumn) === ')') {
        if (openCount === 0) {
          return {row: currentRow, column: currentColumn}
        } else {
          openCount--
        }
      } else if (charAt(currentRow, currentColumn) == '(') {
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
    const openParen = findOpenParen(row, column);
    const closeParen = findCloseParen(row, column);
    if (!openParen || !closeParen) {
      return null
    }

    const range = [[openParen.row, openParen.column], [closeParen.row, closeParen.column]];
    const currentContents = cursor.editor.getTextInBufferRange(range).slice(1);
    const argList = currentContents.split(',').map(arg => arg.trim());
    if (openParen.row == closeParen.row) {
      const verticalList = '(\n' + argList.join(',\n') + '\n'
      cursor.editor.setTextInBufferRange(range, verticalList)
    } else {
      const horizontalList = '(' + argList.join(', ') + ''
      cursor.editor.setTextInBufferRange(range, horizontalList)
    }
  })
}
`

# union
`
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

this.union = function union() {
  const editor = atom.workspace.getActiveTextEditor()
  const textSets = getSets(editor);
  const unionSet = textSets.reduce((unionSet, textSet) => new Set([...unionSet, ...textSet]), new Set());
  setFirst(unionSet, editor)
}

this.intersection = function intersection() {
  const editor = atom.workspace.getActiveTextEditor()
  const [firstSet, ...rest] = getSets(editor);
  const intersectionSet = new Set([...firstSet].filter((item) => rest.some(set => set.has(item))));
  setFirst(intersectionSet, editor)
}

this.leftOuter = function leftOuter() {
  const editor = atom.workspace.getActiveTextEditor()
  const [firstSet, ...rest] = getSets(editor);
  const leftOuterSet = new Set([...firstSet].filter((item) => !rest.some(set => set.has(item))));
  setFirst(leftOuterSet, editor)
}
`
