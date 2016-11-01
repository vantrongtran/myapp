function delCategory(caId) {
  $.ajax({
    type: 'DELETE',
    url: '/admin/categories/' + caId,
    success: function(data){
      if(data.status)
        alert("Delete success")
      else
        alert("Delete failed")
      $("#category-" + caId).remove();
    },
    error: function(error_message) {
      alert('Failed!');
    },
  });
}
$(document).ready(function() {
  $("#category_search").keyup(function () {
    key = $(this).val();
    $.ajax({
      type: 'GET',
      url: '/admin/categories?key=' + key,
      success: function(data){
        html = '';
        for(i=0; i<data.length; i++){
          html+= "<tr id='category-"+data[i].id+"'>"
            +"<td class='text-c'>"+data[i].name
            +"</td>"
            +"<td class='text-c'>"+data[i].description+"</td>"
            +"<td class='text-c'>"
            +"<a class = 'btn btn-default glyphicon glyphicon-pencil' href = '/admin/categories/"+data[i].id+"/edit'>"
            +"Edit"
            +"</a>"
            +"</td>"
            +"<td class='text-c'>"
            +"<button class = 'btn btn-default delete-category glyphicon glyphicon-trash text-danger'"
            +"onclick= delCategory('"+data[i].id+"')>"
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

