<profile>

<div>
	<div class="info">
		<img class="profile-pic img-circle" src="{ this.getProfilePic() }"></div>
		<div>{ this.getFullname() }</div>
	</div>

	<div>
		<div>
			<ul class="nav nav-tabs" role="tablist">
			  <li class="nav-item">
			  	<a class={ nav-link: true, active: postTab } href="" onclick={ this.toggleTab }>
			  	{this.posts.length} Post<span if={ this.posts.length != 1 }>s</span>
			  	</a>
			  </li>
			  <li class="nav-item">
			  	<a class={ nav-link: true, active: !postTab } href="" onclick={ this.toggleTab }>
			  	{this.replies.length} Repl<span if={this.replies.length == 1}>y</span><span if={this.replies.length != 1}>ies</span>
			  	</a>
			  </li>
			</ul>
		</div>

		<posts name="postList" if={ postTab }></posts>
	</div>
</div>

<script>
	var self     = this
	self.postTab = true
	self.posts   = []
	self.replies = []

	this.on('mount', function() {
		self.updateInfo()
	})

	getProfilePic(){
		var user       = Parse.User.current()
		var profilePic = user.get('profileImageURL')
		if (profilePic){
			return profilePic
		}
	}

	getFullname() {
		return Parse.User.current().get('firstName') + ' ' + Parse.User.current().get('lastName')
	}

	toggleTab() {
		self.postTab = !self.postTab
		self.update()
	}

	updateInfo() {
		var postObject = Parse.Object.extend('Post')
		var query = new Parse.Query(postObject)
		query.equalTo('author', Parse.User.current())
		query.find({
			success: function(posts) {
				self.posts = posts
				self.tags.postList.update({posts: self.posts, loading:false})
				self.update()
			},
			error: function(error) {
			}
		})

		var replyObject = Parse.Object.extend('Answer')
		var query = new Parse.Query(replyObject)
		query.equalTo('author', Parse.User.current())
		query.find({
			success: function(replies) {
				self.replies = replies
				self.update()
			},
			error: function(error) {
			}
		})
	}

</script>

<style scoped>

	.profile-pic {
		width: 150px;
		height: 150px;
	}

</style>

</profile>