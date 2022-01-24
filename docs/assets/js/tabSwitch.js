function openTab(tabName) {
  var i, x, tablinks;
  x = document.getElementsByClassName("content-tab");
  for (i = 0; i < x.length; i++) {
    x[i].style.display = "none";
  }
  tablinks = document.getElementsByClassName("tab");
  for (i = 0; i < x.length; i++) {
    tablinks[i].className = tablinks[i].className.replace(" is-active", "");
  }
  tabID = '#' + tabName;
  headingID = tabName + '-heading';

  document.getElementById(tabName).style.display = "block";
  document.getElementById(headingID).className += " is-active";

  history.pushState({}, null, tabID)
}

hash = window.location.hash.substr(1);

if (hash.length) {
  openTab(hash);
}
