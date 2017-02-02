App.questions = App.cable.subscriptions.create("QuestionsChannel", {
  connected: function() {},
  disconnected: function() {},
  received: function(data) {
    if (data.action === 'broadcast') {
      console.log('BR: ' + data.question + '; author: ' + data.question.author_id);
      console.log($('.user-id-data-storage').data('userId'));
    }
  }
});
