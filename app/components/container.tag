<container>
    <app-navi></app-navi>
     <!-- Page Content -->
    <div class="container">
    <!-- <h1>{ title }</h1> -->

        
    

        <div class="row">
            <div class="col-lg-6 col-md-offset-3  text-center">
                <feed if={ route=="posts" }></feed>
                <topics if={ route=="topics" }></topics>
                <postDetail if={ route=="postDetail" }></postDetail>
                <topicsfeed if={ route=="topicsfeed" }></topicsfeed>
            </div>
        </div>
        
        <!-- /.row -->
    </div>
    <!-- /.container -->

  <script>
    var self = this
    containerTag = this
    self.title = 'Now loading...'
    self.body = ''
    
    self.route = "home"

    this.on("mount", function(){
      $.getJSON("/data/papers_with_youtube_id.json", function(json) {
        allTopics = json
      });
    })
    
    var r = riot.route.create()
    r('#',       home       )
    r('post',   post      )
    r('post/*', postDetail)
    r('topics',  topics     )
    r('topics/*', topicsfeed)
    r(           home       ) // `notfound` would be nicer!

    function home() {
      self.update({
        title:  "Welcome to Sophus!",
        body:  "This is the feed!",
        route: "posts",
        selectedId: null,
      })
    }
    function post() {
      self.update({
        title: "Recent Posts",
        body: "Lists of posts",
        route: "posts",
        selectedId: null,
      })
    }
    function postDetail(id) {
      self.update({
        title: "",
        body: "",
        selectedId: id,
        route: "postDetail"
      })
    }
    function topics() {
      
      self.update({
        title: "Trending Topics",
        body: "",
        selectedId: null,
        route: "topics"
      })
    }
    function topicsfeed(id) {
      
      self.update({
        title: "",
        body: "",
        selectedId: null,
        selectedTopicId: id,
        route: "topicsfeed"
      })
    }

            loader = riot.observable();


    
         // Current user (logged in or anonymous)
        API = {

          getObjectForTopic: function(topicTitle){
            return _.filter(allTopics, function(topic){
              if (topic.title === topicTitle){
                return topic
              }
            })
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
  </script>

  <style scoped>
    :scope {
      display: block;
      font-family: sans-serif;
      /*margin-right: 0;*/
      margin-bottom: 130px;
      /*margin-left: 50px;*/
      padding: 1em;
      /*text-align: center;*/
      color: #666;

    }
    
   
    @media (min-width: 480px) {
      :scope {
        /*margin-right: 200px;*/
        margin-bottom: 0;
      }
    }
  </style>

</container>

