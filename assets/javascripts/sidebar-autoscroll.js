// vim:set ts=8 sts=2 sw=2 tw=0 et:
$(function() {
  var sidebar = $('.sidebar');
  if (sidebar.length > 0) {
    setupSidebarScroll(sidebar);
  }

  function setupSidebarScroll(target) {
    var parent = target.parent();
    var targetTop = target.offset().top;
    $(window).scroll(function() {
      var scrollTop = $('body').scrollTop();
      var offset = 0;
      var max = parent.height() - target.height();
      if (scrollTop > targetTop) {
        offset = scrollTop - targetTop;
        if (offset > max) {
          offset = max;
        }
      }
      //console.log('offset=%d scrollTop=%d', offset, scrollTop);
      target.offset({ top: targetTop + offset });
    });
  }
});
