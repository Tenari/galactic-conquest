<style>
  .asdfasdf {
    background: pink;
    width: 5px;
  }
.showcursor::after {
  content: " ";
  display: inline-block;
  height: 1.1em;
  margin-top: -4px;
  width: 0.5em;
  vertical-align: middle;
  -webkit-animation: 1s blink step-end infinite;
  -moz-animation: 1s blink step-end infinite;
  -ms-animation: 1s blink step-end infinite;
  -o-animation: 1s blink step-end infinite;
  animation: 1s blink step-end infinite;
}

@keyframes blink {
  from,
  to {
    background: 0 0;
  }
  50% {
    background: #00E567;
  }
}

@-moz-keyframes blink {
  from,
  to {
    background: 0 0;
  }
  50% {
    background: #00E567;
  }
}

@-webkit-keyframes blink {
  from,
  to {
    background: 0 0;
  }
  50% {
    background: #00E567;
  }
}

@-ms-keyframes blink {
  from,
  to {
    background: 0 0;
  }
  50% {
    background: #00E567;
  }
}

@-o-keyframes blink {
  from,
  to {
    background: 0 0;
  }
  50% {
    background: #00E567;
  }
}
</style>

<script>
  let { content, hidecursor, keypress } = $props();
  let focused = $state(false);
  let showcursor = $derived(focused && !hidecursor);

  function onblur(event) {
    focused = false;
  }

  function onfocus(event) {
    focused = true;
  }

  function onkeypress(event) {
    if (event.key === "Enter") {
      event.preventDefault();
      event.stopPropagation();
      event.target.blur();
      if (!!keypress) keypress();
    }
	}

  function onclick(e) {
    var caret = "&#xfeff;<span class='asdfasdf'></span>";
    var sel = window.getSelection();
    if (sel.toString() != "") {
        return;
    }
    const caretPosition = getCaretPosition(e.target);
    console.log(caretPosition, e.target.textContent)
    const content = e.target.textContent;
    const output = content.substr(0, caretPosition) + caret + content.substr(caretPosition);
    e.target.innerHTML = output;
    console.log(output);
    var range = document.createRange();
    range.setStart(e.target.childNodes[0], caretPosition);
    range.collapse(true);
    sel.removeAllRanges();
    sel.addRange(range);
  }

  function getCaretPosition(element) {
    var caretPosition = 0;
    var doc = element.ownerDocument || element.document;
    var win = doc.defaultView || doc.parentWindow;
    var sel;

    if (typeof win.getSelection != "undefined") {
      sel = win.getSelection();
      if (sel.rangeCount > 0) {
        var range = win.getSelection().getRangeAt(0);
        var preCaretRange = range.cloneRange();
        preCaretRange.selectNodeContents(element);
        preCaretRange.setEnd(range.endContainer, range.endOffset);
        caretPosition = preCaretRange.toString().length;
      }
    } else if ( (sel = doc.selection) && sel.type != "Control") {
      var textRange = sel.createRange();
      var preCaretTextRange = doc.body.createTextRange();
      preCaretTextRange.moveToElementText(element);
      preCaretTextRange.setEndPoint("EndToEnd", textRange);
      caretPosition = preCaretTextRange.text.length;
    }
    return caretPosition;
  }

</script>

<span
  {onkeypress}
  {onblur}
  {onfocus}
  {onclick}
  contenteditable="true"
  bind:textContent={content}
  class={[{showcursor}, "outline-none cursor-text caret-transparent min-w-sm"]}></span>

