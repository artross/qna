App.answers = App.cable.subscriptions.create("AnswersChannel", {
  connected: function() {},
  disconnected: function() {},
  received: function(data) {
    var userId = $('.user-id-data-storage').data('userId');
    var currentQuestionId = $('.question.question-show').data('id') || 0;
    if ((currentQuestionId == data.question.id) && (userId != data.answer.authorId)) {
      $('#answers-count').html("Answers: " + data.question.answersCount);
      if (data.question.answersCount == 1) {
        $('.answers').append("<h3 class='text-muted'>Answers:</h3>");
        $('.answers').append("<ul class='list-group'></ul>");
      }
      $('.answers').find('ul.list-group').append(JST['templates/answer']({ answer: data.answer, isQuestionsAuthor: (data.question.authorId == userId) }));
    }
  }
});
