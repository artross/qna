$(document).on('turbolinks:load', function() {
  $('.add-comment-link').on('click', function(e) {
    e.preventDefault();
    $(this).addClass('hidden');
    $('#add-comment-form-' + $(this).data('shortNameWithId')).removeClass('hidden');
  });
});
