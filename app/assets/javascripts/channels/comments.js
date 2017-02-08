App.questions = App.cable.subscriptions.create("CommentsChannel", {
  connected: function() {},
  disconnected: function() {},
  received: function(data) {
    var userId = $('.user-id-data-storage').data('userId');
    var currentQuestionId = $('.question.question-show').data('id') || 0;
    if ((currentQuestionId == data.question.id) && (userId != data.comment.authorId)) {
      $('#' + data.region).find('ul.comments').append(JST['templates/comment']({ comment: data.comment }));
    }
  }
});
