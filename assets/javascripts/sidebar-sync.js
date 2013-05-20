// vim:set sts=2 sw=2 tw=0 et:

$(function() {
  var w = $(window);
  var jump_table;
  var last_index = -1;

  function find_nav_link(id) {
    return $('a[href="#' + id + '"]');
  }

  function build_table() {
    var table = [];
    var anchors = $('a[name]');
    for (var i = 0, len = anchors.length; i < len; ++i) {
      var anchor = $(anchors[i]);
      var top = anchor.offset().top;
      var id = anchor.attr('name');
      var nav_link = find_nav_link(id);
      table.push({ top: top, id: id, nav_link: nav_link });
    }
    return table;
  }

  function binary_search(pos) {
    var start = 0;
    var end = jump_table.length - 1;
    while (start <= end) {
      var mid = Math.floor((start + end) / 2);
      if (pos < jump_table[mid].top) {
        end = mid - 1;
      } else if (pos >= jump_table[mid + 1].top) {
        start = mid + 1;
      } else {
        return mid;
      }
    }
    return -1;
  }

  function find_index(pos) {
    if (pos < jump_table[0].top) {
      return 0;
    } else if (pos >= jump_table[jump_table.length - 1].top) {
      return jump_table.length - 1;
    } else {
      return binary_search(pos);
    }
  }

  function select_li_array(index) {
    var nav_link = jump_table[index].nav_link;
    return nav_link.parents('li');
  }

  function clear_selected() {
    $('li.selected').each(function() {
      $(this).removeClass('selected');
    });
    $('li.selected_parent').each(function() {
      $(this).removeClass('selected_parent');
    });
  }

  function on_index_chaged(index) {
    var array = select_li_array(index);
    clear_selected();
    var selected = $(array[0]);
    selected.addClass('selected');
    array.slice(1).each(function() {
      $(this).addClass('selected_parent');
    });
  }

  function on_scroll() {
    var curr = w.scrollTop() + 1;
    var index = find_index(curr);
    if (index != last_index) {
      last_index = index;
      on_index_chaged(index);
    }
  }

  jump_table = build_table();
  w.scroll(on_scroll);
});
