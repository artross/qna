App.questions = App.cable.subscriptions.create("QuestionsChannel", {
  connected: function() {},
  disconnected: function() {},
  received: function(data) {
    var userId = $('.user-id-data-storage').data('userId');
    if (userId != data.question.authorId) {
      $('.questions').find('ul.list-group').append(JST['templates/question']({ question: data.question }));
    }
  }
});
