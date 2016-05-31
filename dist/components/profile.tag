<profile>

<div>
	<div class="info">
		<img class="profile-pic img-circle" src="{ this.getProfilePic() }">
		<div class="detail inline">
			<div if={ !edit }>
				<div class="name">{ this.getFullname() }</div>
				<div class="score"><img src="/images/cup.png" id="cup">{ this.getScore() }</div>
				<div class="about info-item">{ Parse.User.current().get('about') }</div>

				<div class="info-item">
					<button class="btn btn-sm" onclick={ this.toggleEdit }>Edit Profile</button>
				</div>
			</div>

			<div if={ edit }>
				<form>
					<div class="form-group">
						<input name="name" type="text" class="form-control" id="name" placeholder="What's your name?">
					</div>
					<div class="form-group">
						<input name="about" type="text" class="form-control" id="about" placeholder="Tell us something about yourself">
					</div>
					<button class="fa fa-check btn btn-success btn-sm" onclick={ this.submitEdit }></button>
					<button class="fa fa-close btn btn-warning btn-sm" onclick={ this.toggleEdit }></button>
				</form>
			</div>
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
	var self     = this
	self.edit    = false
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

	getScore() {
		var score = Parse.User.current().get('score')
		if (typeof score == 'undefined') return 0
		else return score
	}

	toggleEdit() {
		self.edit = !self.edit

		if (self.edit) {
			self.name.value = self.getFullname()
			if (Parse.User.current().get('about'))
				self.about.value = Parse.User.current().get('about')
		} else {
			self.name.value  = ''
			self.about.value = ''
		}

		self.update()
		// Focus on name's input and set cursor at beginning
		self.name.setSelectionRange(0, 0)
		self.name.focus()
	}

	toggleTab() {
		self.postTab = !self.postTab
		self.update()
	}

	submitEdit() {
		var user         = Parse.User.current()
		var about        = self.about.value
		var userFullname = self.name.value

		if (userFullname != '') {
			var userFirstname = userFullname.split(" ")[0]
			var userLastname  = userFullname.substring(userFullname.indexOf(" ") + 1)
			user.set('firstName', userFirstname)
			user.set('lastName', userLastname)
		}
		if (about != '') {
			user.set('about', about)
		}

		user.save(null, {
			success: function(user) {
				self.toggleEdit()
			},
			error: function(user, error) {
				self.toggleEdit()
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
		margin-left: 2vw;
		width: 40vw;
	}

	.name {
		color: #616161;
		font-size: xx-large;
	}

	.profile-pic {
		width: 15vw;
		height: 15vw;
		vertical-align: top;
	}

	.info-item {
		margin-top: 8px;
	}

	#cup {
		width: 15px;
		height: 15px;
		margin-right: 4px;
	}

	.inline {
		display: inline-block;
	}

	#name {
		font-size: xx-large;
	}

	#about {
		margin-top: 29px;
	}

	.fa-pencil {
	}

	.form-control {
		padding: 0;
		border: 0;
		border-bottom: 1px dashed #ccc;
		-webkit-appearance: none;
        -moz-appearance: none;
	    -ms-appearance: none;
	    -o-appearance: none;
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