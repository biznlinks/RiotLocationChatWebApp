
    loader = riot.observable();


API = {
  fetchOne: function(className, key, value){
    var promise = new Parse.Promise();
    var Class = Parse.Object.extend(className);
    var query = new Parse.Query(Class);
    query.equalTo(key, value);
    query.first().then(function(object) {
        if (object) {
          promise.resolve(object);
        } else {
          promise.reject()
        }
    }, function(err) {
        console.error('query failed: ' + JSON.stringify(err));
    });
    return promise;
  },

  getProfilePicture: function(user) {
    if (!user.get('profilePic')){
      if (user.get('profileImageURL')){
        return user.get('profileImageURL');
      }
      return '/images/default_profile.png';

    }else {
      profilePic = user.get('profilePic').url();
      if (profilePic){
        return profilePic;
      }
    }
  },

  getCurrentUserProfilePicture: function() {
    var user = Parse.User.current();

    if (!user || user.get('type') == 'dummy')
      return '/images/default_profile.png';

    if (!user.get('profilePic')){
      if (user.get('profileImageURL')){
        return user.get('profileImageURL');
      }
      return '/images/default_profile.png';

    }else {
      profilePic = user.get('profilePic').url();
      if (profilePic){
        return profilePic;
      }
    }
  },

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

    });



  },
  function(err) {
    console.error("failed to query answers: " + JSON.stringify(err));
  });


  return promise;
},

getanswersforpost: function(post){
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
constructFeed: function(){
  loader.trigger('start');
  var promise = new Parse.Promise();
  Parse.Cloud.run("constructFeed").then(function(results){
    loader.trigger('done');
    promise.resolve(results);
  }, function(err) {
    console.error("failed to query posts: " + JSON.stringify(err));
  });
  return promise;
},

getallposts: function(limit){
  limit = limit || 1000;
  loader.trigger('start');
  var promise = new Parse.Promise();
  var query = new Parse.Query(Post);
  query.descending('createdAt');
  query.include('author');
  query.limit(limit);
  query.find().then(function(results) {
    loader.trigger('done');
    promise.resolve(results);
  },
  function(err) {
    console.error("failed to query answers: " + JSON.stringify(err));
  });
  return promise;
},
constructQuestionsForTopic: function(topic){
  var promise = new Parse.Promise();
  var query = new Parse.Query(Post);
  query.equalTo("topic", topic);
  query.descending('wannaknowCount');
  query.find().then(function(results) {
    promise.resolve(results);
  },
  function(err) {
    console.error("failed to query answers: " + JSON.stringify(err));
  });

  return promise;
},
getallgroups: function() {
  loader.trigger('start');
  var promise = new Parse.Promise();
  var query = new Parse.Query(Parse.Object.extend('Group'));
  query.equalTo("type", "group");
  query.find().then(function(results) {
    loader.trigger('done');
    results.sort(API.comparedistance);
    promise.resolve(results);
  },
  function(err) {
    console.error("failed to query groups: " + JSON.stringify(err));
  });
  return promise;
},
getallevents: function() {
  loader.trigger('start');
  var promise = new Parse.Promise();
  var query = new Parse.Query(Parse.Object.extend('Group'));
  query.equalTo("type", "event");
  query.find().then(function(results) {
    loader.trigger('done');
    results.sort(API.comparedistance);
    promise.resolve(results);
  },
  function(err) {
    console.error("failed to query groups: " + JSON.stringify(err));
  });
  return promise;
},
getusercity: function(userlocation) {
  var promise = new Parse.Promise();
  var geocoder = new google.maps.Geocoder;
  userlocation = {lat: userlocation.latitude, lng: userlocation.longitude};
  geocoder.geocode({'location': userlocation}, function(results, status) {
    if (status === google.maps.GeocoderStatus.OK) {
      for (var i = 0; i < results.length; i++)
        if (results[i].types[0] == 'locality') {
          promise.resolve(results[i].address_components[0].long_name);
        }
    }
  });
  return promise;
},
comparedistance: function(groupA, groupB) {
  var distance = function(p1, p2) {
    var R = 6371;
    var dLat = (p2.latitude - p1.latitude) * Math.PI / 180;
    var dLong = (p2.longitude - p1.longitude) * Math.PI / 180;
    var lat1 = p1.latitude * Math.PI / 180;
    var lat2 = p2.latitude * Math.PI / 180;

    var a = Math.sin(dLat/2) * Math.sin(dLat/2) + Math.sin(dLong/2) * Math.sin(dLong/2) * Math.cos(lat1) * Math.cos(lat2);
    var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
    return R * c;
  };

  if (distance(groupA.get('location'), USER_POSITION) > distance(groupB.get('location'), USER_POSITION)) return 1;
  else if (distance(groupA.get('location'), USER_POSITION) < distance(groupB.get('location'), USER_POSITION)) return -1;
  else return 0;
}

};