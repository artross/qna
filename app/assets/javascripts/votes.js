$(document).on('turbolinks:load', function() {
  var vr = $('.votes-and-rating');

  vr.bind('ajax:success', function(e, data, status, xhr) {
    var votable = $.parseJSON(xhr.responseText);
    var votes_text = votable.votes === 1 ? " vote" : " votes";
    var region = $("#" + votable.region);

    region.find('.votes-and-rating').find('li:first-child').html("Rating: " + votable.rating + " (" + votable.votes + votes_text + ")");

    if (votable.action === "vote") {
      region.find('.vote-button').addClass('hidden');
      if (votable.vote_value === 1) {
        region.find('.vote-value-up').removeClass('hidden');
      } else if (votable.vote_value === -1) {
        region.find('.vote-value-down').removeClass('hidden');
      }

      var unvote_button = region.find('.unvote-button');
      var old_href = unvote_button.attr("href");

      unvote_button.removeClass('hidden');
      unvote_button.attr("href", old_href.replace(/\/\d+\?/, "/" + votable.vote_id + "?"));

    } else if (votable.action === "unvote") {
      region.find('.vote-button').removeClass('hidden');
      region.find('.unvote-button').addClass('hidden');
      region.find('.vote-value-up').addClass('hidden');
      region.find('.vote-value-down').addClass('hidden');
    }
  }).bind('axaj:error', function(e, xhr, status, error) {
    vr.find('li:first-child').html("456");
  });
});
