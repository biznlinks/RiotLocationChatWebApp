
    loader = riot.observable();

// Current user (logged in or anonymous)
API = {

  getObjectForTopic: function(topicTitle){
    var promise = new Parse.Promise();
    var topicQuery = new Parse.Query(Topic);
    topicQuery.equalTo('name', topicTitle); 
    topicQuery.find().then(function(topic){
      if (topic){
        if (topic[0])
          promise.resolve(topic[0]);
      }
    });
    return promise;
  },
  getDetailsForPost: function(post_id, fn){

    loader.trigger('start');
    var promise = new Parse.Promise();

    var postQuery = new Parse.Query(Post);
    var foundPost;
    var foundTopicImageForPost;

    postQuery.include('author');
    postQuery.get(post_id).then(function(post) {
      if (post) {

      //find image for topic if exists
      foundPost = post;

      
      var commentQuery = new Parse.Query("Answer");
      commentQuery.equalTo('post', post);
      commentQuery.ascending('createdAt');
      commentQuery.include('author');
      return commentQuery.find();


    } else {
      return [];
    }
  }).then(function(answers) {
    var topics = foundPost.get('topics');
    var topicQuery = new Parse.Query(Topic);
    topicQuery.containedIn('name', topics); 
    topicQuery.find().then(function(topics){
      if (topics){
        foundTopicImageForPost = _.chain(topics)
        .filter(function(topic){return (typeof topic.get('image') != 'undefined')})
        .map(function(topic){return topic.get('image').url()})
        .value();
        foundTopicImageForPost.push('/images/header.jpg');
      }
      promise.resolve( {
        post: foundPost,
        topicImage: foundTopicImageForPost[0],
        answers: answers
      });

    })
    

    
  },
  function(err) {
    console.error("failed to query answers: " + JSON.stringify(err));
  });


  return promise;
},

getanswersforpost: function(post, fn){
  loader.trigger('start');
  var promise = new Parse.Promise();

  var query = new Parse.Query("Answer");
  query.equalTo("post", post);
  query.include('author');
  query.find().then(function(answers) {
    loader.trigger('done');
    promise.resolve(answers);
  }, function(err) {
    console.error("failed to query answers: " + JSON.stringify(err));
  });
  return promise;
},
constructFeed: function(fn){
  loader.trigger('start')
  var promise = new Parse.Promise()
  Parse.Cloud.run("constructFeed").then(function(results){
    loader.trigger('done');
    promise.resolve(results);
  }, function(err) {
    console.error("failed to query posts: " + JSON.stringify(err));
  })
  return promise
},
getallposts: function(fn){
  loader.trigger('start');
  var promise = new Parse.Promise();
  var query = new Parse.Query(Post);
  query.descending('createdAt');
  query.include('author');
  query.limit(20);
  query.find().then(function(results) {
    loader.trigger('done');
    promise.resolve(results);
  },
  function(err) {
    console.error("failed to query answers: " + JSON.stringify(err));
  });
  return promise;
},

constructQuestionsForTopics: function(topic, fn){
  loader.trigger('start')
  var promise = new Parse.Promise()
  Parse.Cloud.run("constructQuestionsForTopics", {postContent: topic}).then(function(results){
    loader.trigger('done');
    promise.resolve(results);
  }, function(err) {
    console.error("failed to query posts: " + JSON.stringify(err));
  })
  return promise
}

};