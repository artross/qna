$(document).on('turbolinks:load', () => {
  $('.edit-question-link').on('click','a', function(e) {
    e.preventDefault();
    $(this).closest('li').addClass('hidden');
    $('#edit-question-form' + $(this).data('questionId')).removeClass('hidden');
  });
});
