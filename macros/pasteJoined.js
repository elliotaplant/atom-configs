// # pasteWithCommas
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

function pasteWithCommas() {
  pasteJoined(', ');
}

function pasteWithCommaNewlines() {
  pasteJoined(',\n');
}

module.exports = {pasteWithCommas, pasteWithCommaNewlines}
