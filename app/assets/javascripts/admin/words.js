function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp('new_' + association, 'g')
  $(link).parent().before(content.replace(regexp, new_id));
}
function remove_fields(link) {
  $(link).prev('input[type=hidden]').value = '1';
  $(link).closest('.form-group').remove();
}
function delWord(wordId) {
  console.log(wordId)
  $.ajax({
    type: 'DELETE',
    url: '/admin/words/' + wordId,
    success: function(data){
      if(data.status){
        $("#word-" + wordId).remove();
        alert("Delete success");
      }
      else
        alert("Delete failed");
    },
    error: function(error_message) {
      alert('Failed!');
    },
  });
}
$(document).ready(function() {
  $("#word_search").keyup(function () {
    key = $(this).val();
    $.ajax({
      type: 'GET',
      url: '/admin/words?key=' + key,
      success: function(data){
        html = '';
        for(i=0; i<data.length; i++){
          html+= "<tr id='word-"+data[i].id+"'>"
            +"<td class='text-c'>"+data[i].content
            +"</td>"
            +"<td class='text-c'>"+data[i].category_id+"</td>"
            +"<td class='text-c'>"
            +"<a class = 'btn btn-default glyphicon glyphicon-pencil' href = '/admin/word/"+data[i].id+"/edit'>"
            +"Edit"
            +"</a>"
            +"</td>"
            +"<td class='text-c'>"
            +"<button class = 'btn btn-default delete-category glyphicon glyphicon-trash text-danger'"
            +"onclick= delWord('"+data[i].id+"')>"
            +"Delete</button>"
            +"</td>"
            +"</tr>";
        }
        $("#result_search").html(html);
      },
      error: function(error_message) {
        alert('Failed!');
      },
    });
  });
});
