<answeritem>
	<div class="row">
		<div class="col-xs-1 col-md-1 profilePic">
			<img if={ !answer.get('anonymous') } src="{API.getProfilePicture(answer.get('author'))}" class="answer-profile-img img-circle">
			<img if={ answer.get('anonymous') } src="/images/default_profile.png" class="answer-profile-img img-circle">
		</div>
		<div class="col-xs-11 col-md-11 content" >
			<div class="row">
				<span class="author text-muted">{ this.getAuthorName() }</span>
				<span class="content-text">
					{answer.get('answer')}
				</span>
			</div>
			<div class="row pointer" onclick={this.submitLike}>
				<div class='helpful text-muted'> Helpful   •   <i name="likeButton" class={ fa: true, fa-thumbs-up: liked, fa-thumbs-o-up: !liked } aria-hidden="true"/> { likeCount } </div>
			</div>

		</div>
	</div>

	<script>
		var self       = this
		self.answer    = opts.answer
		self.liked     = false
		self.likeCount = 0

		this.on('mount', function() {
			self.likeCount = self.answer.get('likes')

			// Check if user already liked this answer
			var LikeObject = Parse.Object.extend('Like')
			var query      = new Parse.Query(LikeObject)
			query.equalTo('answer', self.answer)
			query.equalTo('user', Parse.User.current())
			query.find({
				success: function(likes) {
					if (likes.length > 0)
						self.liked = true
					self.update()
				},
				error: function(error) {
				}
			})
		})

		this.on('update', function() {
			answer = this.answer
		})

		getAuthorName() {
			if (self.answer.get('anonymous'))
				return 'Anonymous'
			else
				return self.answer.get('author').get('firstName') + ' ' + self.answer.get('author').get('lastName')
		}

		getProfilePic(){
			if (self.answer.get('anonymous'))
				return '/images/default_profile.png'

			var author = self.answer.get('author')
			if (author.get('profileImageURL')){
				profilePic = author.get('profileImageURL')
				if (profilePic){
					return profilePic
				}
			}else {
				return '/images/default_profile.png'
			}
		}

		submitLike(){
			if (!self.liked) {	// If the button is empty a.k.a user hasn't liked
				self.liked     = true
			self.likeCount += 1
			self.update()

			var LikeObject = Parse.Object.extend('Like')
			var likeObject = new LikeObject()

			likeObject.save({
				answer: self.answer,
				user: Parse.User.current()
			}, {
				success: function(likeObject) {
				},
				error: function(likeObject, error) {
						// Do something if there is an error
					}
				})
		} else {
			self.liked     = false
			self.likeCount -= 1
			self.update()

			var LikeObject = Parse.Object.extend('Like')
			var query      = new Parse.Query(LikeObject)
			query.equalTo('answer', self.answer)
			query.equalTo('user', Parse.User.current())
			query.find({
				success: function(likes) {
					if (likes.length > 0) {
						likes[0].destroy({})
					}
				},
				error: function(error) {
				}
			})
		}
	}

</script>


<style scoped>
	:scope {
		font-family: helvetica, arial, sans-serif;
		font-size: small;
		color: black;
		font-weight: normal

	}
	.row{
		margin-bottom: 10px;
		margin-left: 1px;
	}
	.author{
		content: #616161;
	}
	.answer-profile-img {
		width: 30px;
		height: 30px;
	}
	.content {
		/* margin-left: 10px; */
		padding-left: 20px;
		font-size: 14px;
	}
	.content-text{
		color: #424242;
	}
	.helpful {
		display: inline-block;
		font-size: smaller;
	}
	.inline {
		display:inline-block;
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
	.profilePic{
		padding-left: 0px;
    	padding-top: 0px;
	}


	@media (min-width: 480px) {
		:scope {
			/*margin-right: 200px;*/
			margin-bottom: 0;
		}
	}
</style>
</answeritem>