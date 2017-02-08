$(document).on('turbolinks:load', function() {
  $('.add-comment-link').on('click', function(e) {
    e.preventDefault();
    // hide every add-comment-form and show every add-comment-link
    $('.add-comment-form').addClass('hidden');
    $('.add-comment-link').removeClass('hidden');
    // show particular form and hide its corresponding link
    $(this).addClass('hidden');
    $('#add-comment-form-' + $(this).data('shortNameWithId')).removeClass('hidden');
  });
});
