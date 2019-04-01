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
  const toPaste = atom.clipboard.metadata.selections.map(selection => selection.text).join(joiner);
  atom.workspace.getActiveTextEditor()
    .selections.forEach(selection => selection.insertText(toPaste), { select: true });
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

# propTypes
`
this.propTypes = function propTypes(joiner) {
  const componentLine = '.propTypes = {'
  const firstProptype = '  prop: PropTypes.string.isRequired,';
  const closing = '}';
  const importStatement = "import PropTypes from 'prop-types';"
  console.log(atom.workspace.getActiveTextEditor())
  atom.workspace.getActiveTextEditor()
    .selections[0].insertText([
      componentLine,
      firstProptype,
      closing,
      importStatement,
    ].join('\n'))
}
`