var codeBlocks = document.querySelectorAll('.code-header + .highlighter-rouge');
var copyCodeButtons = document.querySelectorAll('.copy-button');

copyCodeButtons.forEach((copyCodeButton, index) => {
  var code = codeBlocks[index].innerText;

  copyCodeButton.addEventListener('click', () => {
    window.navigator.clipboard.writeText(code);
    copyCodeButton.classList.add('copied');

    setTimeout(() => {
      copyCodeButton.classList.remove('copied');
    }, 2000);
  });
});
