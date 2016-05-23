<profile>

<div>
	<div class="info">
		<img class="profile-pic img-circle" src="{ this.getProfilePic() }">
		<div class="detail">
			<div class="name">{ this.getFullname() }</div>
			<div if={ !aboutBox }><div class="text-muted pointer" onclick={ this.toggleAboutBox }>About: </div>{ Parse.User.current().get('about') }</div>
			<div if={ aboutBox } class="edit-about">
				<textarea rows="1" placeholder="About you" name="aboutInput"></textarea>
				<button class="btn btn-default about-form-btn" onclick={ this.submitAbout }><i class="fa fa-check"></i></button>
				<button class="btn btn-default about-form-btn" onclick={ this.toggleAboutBox }><i class="fa fa-close"></i></button>
			</div>
			<div class="score">{ this.getScore() }</div>
		</div>
	</div>

	<div class="body">
		<div class="navigation">
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

		<div class="tab-content">
			<posts name="postList" if={ postTab }></posts>
			<ansprofile name="replyList" if={ !postTab }></ansprofile>
		</div>
	</div>
</div>

<script>
	var self      = this
	self.aboutBox = false
	self.postTab  = true
	self.posts    = []
	self.replies  = []

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

	getScore() {
		var score = Parse.User.current().get('score')
		if (typeof score == 'undefined') return 0
		else return score
	}

	toggleTab() {
		self.postTab = !self.postTab
		self.update()
	}

	toggleAboutBox() {
		self.aboutBox = !self.aboutBox
		self.aboutInput.value = typeof Parse.User.current().get('about') == 'undefined' ? '' : Parse.User.current().get('about')
		self.update()
	}

	submitAbout() {
		Parse.User.current().set('about', self.aboutInput.value)
		Parse.User.current().save({
			success: function(user) {
				self.toggleAboutBox()
			},
			error: function(error) {
			}
		})
	}

	updateInfo() {
		var postObject = Parse.Object.extend('Post')
		var query      = new Parse.Query(postObject)
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
		var query       = new Parse.Query(replyObject)
		query.equalTo('author', Parse.User.current())
		query.find({
			success: function(replies) {
				self.replies = replies
				self.tags.replyList.update({replies: self.replies})
				self.update()
			},
			error: function(error) {
			}
		})
	}

</script>

<style scoped>

	.detail {
		display: inline-block;
		margin-left: 2vw;
	}

	.name {
		font-size: x-large;
	}

	.profile-pic {
		width: 17vw;
		height: 17vw;
		vertical-align: top;
	}

	textarea {
		resize: none;
		-webkit-border-radius: 5px;
    	-moz-border-radius: 5px;
    	border-radius: 5px;
    	padding:7px;
	}

	.about-form-btn {
		display: inline-block;
		vertical-align: top;
	}

	.body {
		margin-top: 15px;
	}

	.tab-content {
		margin-top: 5px;
	}

	.pointer:hover {
		cursor: pointer;
		-webkit-touch-callout: none;
		-webkit-user-select: none;
		-khtml-user-select: none;
		-moz-user-select: none;
		-ms-user-select: none;
		user-select: none;
	}

</style>

</profile>