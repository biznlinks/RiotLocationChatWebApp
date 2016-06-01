<postitem>

<div class="card" onkeyup={ this.gotoPost }>
	<div class="post-author">
		<img class="author-profile img-circle" if={ !post.get('anonymous') } src={ API.getProfilePicture(post.get('author')) }>
		<img class="author-profile img-circle" if={ post.get('anonymous') } src="/images/default_profile.png">

		<span class="author-name">{ this.getAuthorName() }</span>
	</div>

	<div class="post-content" onclick={ this.gotoPost }>
		<p>{ post.get('content') }</p>
	</div>

	<div class="wannaknow pointer" onclick={ this.submitWannaknow }>
		<i class={ fa:true, fa-heart:wannaknown, fa-heart-o:!wannaknown }></i>
		{ wannaknowCount }
	</div>

</div>


<script>
	var self            = this
	self.post           = opts.post
	self.wannaknown     = false
	self.wannaknowCount = 0

	this.on('mount', function() {
		self.wannaknowCount = self.post.get('wannaknowCount')
		// Check if user already followed this post
		var WannaknowObject = Parse.Object.extend('WannaKnow')
		var query           = new Parse.Query(WannaknowObject)
		query.equalTo('post', self.post)
		query.equalTo('user', Parse.User.current())
		query.find({
			success: function(wannaknows) {
				if (wannaknows.length > 0)
					self.wannaknown = true
					self.update()
			},
			error: function(error) {
			}
		})
	})

	getAuthorName() {
		if (self.post.get('anonymous')) return 'Anonymous'
		else {
			var author = self.post.get('author')
			return this.post.get('author').get('firstName') + ' ' + this.post.get('author').get('lastName')
		}
	}

	gotoPost() {
		window.open('https://ictd.sophusapp.com/post/' + self.post.id)
	}

	submitWannaknow() {
		if (!self.wannaknown) {
			// Update UI before processing
			self.wannaknown     = true
			self.wannaknowCount += 1
			self.update()

			var WannaknowObject = Parse.Object.extend('WannaKnow')
			var wannaknowObject = new WannaknowObject()
			wannaknowObject.save({
				post: self.post,
				user: Parse.User.current()
			}, {
				success: function(wannaknowObject) {
				},
				error: function(wannaknowObject, error) {
					// Do something if there is an error
				}
			})
		} else {
			// Update UI before processing
			self.wannaknown     = false
			self.wannaknowCount -= 1
			self.update()

			var WannaknowObject = Parse.Object.extend('WannaKnow')
			var query           = new Parse.Query(WannaknowObject)
			query.equalTo('post', self.post)
			query.equalTo('user', Parse.User.current())
			query.find({
				success: function(wannaknows) {
					if (wannaknows.length > 0) {
						wannaknows[0].destroy({})
						self.update()
					}
				},
				error: function(error) {
				}
			})
		}
	}

</script>

<style scoped>
	.card {
		padding: 8px;
		border: none;
		-webkit-border-radius: 0px;
    	-moz-border-radius: 0px;
    	border-radius: 0px;
    	/*background-color: #FAFAFA;*/
	}

	.author-profile {
		width: 35px;
		height: 35px;
	}

	.author-name {
		font-weight: bold;
		margin-left: 5px;
	}

	.post-content {
		margin-top: 12px;
		text-align: justify;
	}

	.wannaknow {
		font-size: small;
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
</postitem>