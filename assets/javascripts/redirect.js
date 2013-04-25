// vim:set sts=2 sw=2 tw=0 et:
function redirect(table)
{
  var new_url = table[location.pathname];
  if (new_url) {
    console.log('redirect to: ' + new_url);
    location.href = new_url;
  }
}
