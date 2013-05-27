// vim:set ts=8 sts=2 sw=2 tw=0 et:

$(function() {
  var FIXED = 'fixed';
  var BOTTOM = 'bottom';
  var SCROLLABLE = 'scrollable';
  var CHROME_FIX = 'chrome-fix';
  var sidebar = $('.sidebar');
  var parent = sidebar.parent();
  var begin = sidebar.offset().top;

  var requiredHeight = sidebar.height();

  function getEnd() {
    return parent.offset().top + parent.height() - sidebar.height();
  }

  function getNextMode() {
    var mode = 0;
    var curr = $(window).scrollTop();
    if (curr > begin) {
      mode = 1;
      if (curr > getEnd()) {
        mode = 2;
      }
    }
    return mode;
  }

  function getCurrMode() {
    if (sidebar.hasClass(BOTTOM)) {
      return 2;
    } else if (sidebar.hasClass(FIXED)) {
      return 1;
    } else {
      return 0;
    }
  }

  function applyMode(mode) {
    switch (mode) {
      default:
      case 0:
        sidebar.removeClass(FIXED);
        sidebar.removeClass(BOTTOM);
        break;
      case 1:
        sidebar.addClass(FIXED);
        sidebar.removeClass(BOTTOM);
        break;
      case 2:
        sidebar.removeClass(FIXED);
        sidebar.addClass(BOTTOM);
        break;
    }
  }

  function checkScroll() {
    var nextMode = getNextMode();
    if (nextMode != getCurrMode()) {
      applyMode(nextMode);
    }
  }

  function chromeAdjustWidth() {
    if (navigator.userAgent.indexOf('Chrome')) {
      var children = sidebar.children();
      children.toggleClass(CHROME_FIX, true);
      setTimeout(function() {
        children.toggleClass(CHROME_FIX, false);
      }, 10);
    }
  }

  function checkHeight() {
    var isScrollable = sidebar.hasClass(SCROLLABLE) ? true : false;
    var h = $(window).height();
    if (h < requiredHeight) {
      sidebar.height(h);
      if (!isScrollable) {
        sidebar.toggleClass(SCROLLABLE, true);
      }
    } else {
      if (isScrollable) {
        sidebar.height(requiredHeight);
        sidebar.toggleClass(SCROLLABLE, false);
        // chrome workaround: short width after removing scrollbar.
        chromeAdjustWidth();
      }
    }
  }

  $(window).scroll(function() {
    checkScroll();
  });

  $(window).resize(function() {
    checkHeight();
    checkScroll();
  });

  checkHeight();
});
