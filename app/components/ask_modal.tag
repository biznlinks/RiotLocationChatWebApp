<ask>
  <!-- <button type="button" class="btn btn-info btn-lg" data-toggle="modal" data-target="#askModal">Ask a new Question</button> -->
  <!-- Modal -->

  <div id="askModal" class="modal fade" role="dialog">

    <div  class="modal-dialog">

      <!-- Modal content-->
      <div class="modal-content">
      <div if={loading} class="modal-body text-xs-center">
          <i class="fa fa-spinner fa-spin fa-3x fa-fw margin-bottom"></i>
          <span class="sr-only">Loading...</span>
        </div>

        <div if={!loading} class="modal-body">
          <div class="info-btns">
            <textarea rows=2 autofocus id="searchField" name="searchField" placeholder="Ask CHI!" class="searchbox">{question}</textarea>
            Name: <input type="text" name="name" placeholder= "Anonymous {lizard[0]}"></input>
          </div>
          <div class="modal-footer text-xs-center">
            <button type="button" class="btn btn-default" onclick={createQuestion}>Go!</button>

          </div>
        </div>
        
      </div>


    </div>
  </div>

  <script>
    askModalTag = this
    self = this
    loading= false

    question="testing"

    this.on('mount', function(){

    })

    show(){
      $('#askModal').modal('show')
      this.searchField.focus()
    }

    hide(){
      $('#askModal').modal('hide')
    }

    var lizards = [["Snake", "http://farm8.staticflickr.com/7335/26352330184_2a7cf1de58_b.jpg"], ["Gecko", "http://farm8.staticflickr.com/7498/26679684130_245d9ea1fb_b.jpg"], ["Lizard", "http://farm8.staticflickr.com/7705/26924840426_404bbc8bb2_b.jpg"], ["Ground", "http://farm8.staticflickr.com/7682/26353918663_319904eba8_b.jpg"], ["Forest", "http://farm8.staticflickr.com/7517/26958490925_6903bdddf8_b.jpg"], ["Turtle", "http://farm8.staticflickr.com/7184/26683922170_b1a4db6dc4_b.jpg"],  ["Western", "http://farm8.staticflickr.com/7294/26352550924_15854bd46b_b.jpg"], ["Green", "http://farm8.staticflickr.com/7069/26354009763_b15f130e6c_b.jpg"], ["Mountain", "http://farm8.staticflickr.com/7533/26684881650_4e676896d9_b.jpg"], ["Iguana", "http://farm8.staticflickr.com/7623/26922202176_d1354e2a3f_b.jpg"], ["Water", "http://farm8.staticflickr.com/7296/26684949360_8dd7ef5aac_b.jpg"], ["Spotted", "http://farm8.staticflickr.com/7012/26957368925_772799e4fe_b.jpg"], ["Coral", "http://farm8.staticflickr.com/7063/26889006461_4a225dbc68_b.jpg"], ["Island", "http://farm8.staticflickr.com/7009/26864010482_03de9e01b3_b.jpg"], ["Leaf-toed", "http://farm2.staticflickr.com/1573/24039491944_2f75628a35_b.jpg"], ["Southern", "http://farm8.staticflickr.com/7324/26352185784_499339310d_b.jpg"], ["Eastern", "http://farm8.staticflickr.com/7112/26352226113_dbc3210ce3_b.jpg"], ["Spiny", "http://farm8.staticflickr.com/7366/26349224093_fb13888dae_b.jpg"], ["Striped", "http://farm8.staticflickr.com/7166/26828358531_3125218b5b_b.jpg"], ["Agama", "http://farm8.staticflickr.com/7338/26349274524_e05c9b38bc_b.jpg"], ["Dragon", "http://farm8.staticflickr.com/7169/26864182802_56e46cdea9_b.jpg"], ["Viper", "http://farm2.staticflickr.com/1581/26120302431_872a28ecf2_b.jpg"], ["Racer", "http://farm8.staticflickr.com/7531/26350606803_d88baeeb6c_b.jpg"], ["Keelback", "http://farm8.staticflickr.com/7451/26949094415_6aaf534a83_b.jpg"]]


    self.lizard =  _.sample(lizards)

    createQuestion(){
      self.loading = true
      // create new user
      var password = username = Date.now()+"@chi.conf"

      var userACL = new Parse.ACL();
      userACL.setPublicReadAccess(true);

      Parse.User.signUp(username, password,{ ACL: userACL}, {
        success: function(user) {
          user.set("username", username);
          user.set("password", username);
          user.set("email", username);
          

          if (self.name.value!=""){
            user.set("firstName", self.name.value)
            user.set("lastName", "")
          } else {
            user.set("firstName", "Anonymous")
            
            user.set("lastName", self.lizard[0])
            user.set("profileImageURL", self.lizard[1])

          }
          user.save()
          var content = self.searchField.value;
          var post = new Post();

          post.set("content",content)
          post.set("author",user)
          post.set("anonymous", false)
          post.set("newsFeedViewsBy",[])
          post.set("answerCount",0)
          post.set("viewcount",0)
          post.set("wannaknowCount",1)

          post.set("university","umich")

          post.save().then(function() {
            console.log("Successfully added a post " )
            self.loading=false
            self.hide()
            homefeedTag.refresh()

          }, function(err) {
            console.error('query failed: ' + JSON.stringify(err))
          })
          
        },
        error: function(user, error) {
          self.$(".signup-form .error").html(error.message).show();
          this.$(".signup-form button").removeAttr("disabled");
        }
      });
    }
  </script>

  <style scoped>
    :scope{
      text-align: center;
    }

    #searchField{
      overflow:hidden;
      resize: none;
      text-align: center;
      min-height: 45px!important;
      margin-bottom: 0;
      width: 100%;
      font-size: 24px;
      padding: 0 15px;
      line-height: 62px;

    }
  </style>

</ask>