$(document).on('turbolinks:load', function() {
  $('.edit-question-link').on('click','a', function(e) {
    e.preventDefault();
    $(this).closest('li').addClass('hidden');
    $('#edit-question-form' + $(this).data('questionId')).removeClass('hidden');
  });

  $(':file').on('fileselect', function(e, fileNames) {
    $(this).closest('.input-group').find(':text').val(fileNames);
  });

  $(':file').on('change', function(){
    var files = $(this).get(0).files;
    var fileNames = "";
    for(var i = 0; i < files.length; i++) {
      fileNames += "; " + files[i].name;
    }
    $(this).trigger('fileselect', [fileNames.substr(2)]);
  });
});
