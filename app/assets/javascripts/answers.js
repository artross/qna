$(document).on('turbolinks:load', () => {
  $('.edit-answer-link').on('click','a', function(e) {
    e.preventDefault();
    $(this).closest('li').addClass('hidden');
    $('#edit-answer-form' + $(this).data('answerId')).removeClass('hidden');
  });
});
