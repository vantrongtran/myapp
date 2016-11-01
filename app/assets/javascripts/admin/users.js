function del(userId) {
  $.ajax({
    type: 'DELETE',
    url: '/admin/users/' + userId,
    success: function(data){
      alert(data.status);
      $("#user-" + userId).remove();
    },
    error: function(error_message) {
      alert('Failed!');
    },
  });
}

$(document).ready(function() {
  $("#user_search").keyup(function () {
    key = $(this).val();
    $.ajax({
      type: 'GET',
      url: '/admin/users?key=' + key,
      success: function(data){
        html = '';
        for(i=0; i<data.length; i++){
          html+= "<tr id='user-"+data[i].id+"'>"
            +"<input type='hidden' value = "+data[i].id+">"
            +"<td class='text-c'>"
            +"<img src ='/assets/user_icon.png' class ='avatar'></img>"
            +"</td>"
            +"<td class='text-c'><a href = users/"+data[i].id+">"+data[i].name
            +"</a></td>"
            +"<td class='text-c'>"+data[i].email+"</td>"
            +"<td class='text-c'>"
            +"<button class = 'delete-user glyphicon glyphicon-trash text-danger'"
            +"onclick= del('"+data[i].id+"')>"
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
