<answeritem>
	<div class="row">
		<div class="col-xs-1">
			<img src = "{this.getProfilePic()}" class = "answer-profile-img img-circle"></img>
		</div>
		<div class="col-xs-9 content" >
		<div class="row">
			<span class="author">{answer.get('author').get('firstName')} {answer.get('author').get('lastName')}</span> 
			<span class="content-text">
				{answer.get('answer')}
			</span>
			</div>
			<div class="row pointer" onclick={this.submitLike}>
				<div class='helpful text-muted'> Helpful   •   <i name="likeButton" class="fa fa-thumbs-o-up" aria-hidden="true"/> { likeCount } </div>
			</div>
			
		</div>
	</div>

	<script>
		var self = this
		self.answer = opts.answer
		self.liked = false
		self.likeCount = 0

		this.on('mount', function() {
			self.likeCount = self.answer.get('likes')

			// Check if user already liked this answer
			var LikeObject = Parse.Object.extend('Like')
			var query = new Parse.Query(LikeObject)
			query.equalTo('answer', self.answer)
			query.equalTo('user', Parse.User.current())
			query.find({
				success: function(likes) {
					if (likes.length > 0) {
						self.likeButton.className = "fa fa-thumbs-up"
						self.liked = true
					}
				},
				error: function(error) {
				}
			})
		})

		this.on('update', function() {
			answer = this.answer
		})

		getProfilePic(){
			var author= self.answer.get('author')
			if (author.get('profilePic')){
				profilePic = author.get('profilePic').url()
				if (profilePic){
					return profilePic
				}
			}else {
				return 'https://files.parsetfss.com/135e5227-e041-4147-8248-a5eafaf852ef/tfss-6f1e964e-d7fc-4750-8ffb-43d5a76b136e-kangdo@umich.edu.png'
			}
		}

		submitLike(){
			if (!self.liked) {	// If the button is empty a.k.a user hasn't liked
				self.likeButton.className = "fa fa-thumbs-up"
				self.liked = true
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
				self.likeButton.className = "fa fa-thumbs-o-up"
				self.liked = false
				self.likeCount -= 1
				self.update()

				var LikeObject = Parse.Object.extend('Like')
				var query = new Parse.Query(LikeObject)
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
			font-weight: bold;
		}
		.answer-profile-img {
			width: 30px;
			height: 30px;
			margin-right: 10px;
		}
		.content {
			margin-left: 10px;
			   
		}
		.content-text{
			 white-space: pre-wrap;
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


		@media (min-width: 480px) {
			:scope {
				/*margin-right: 200px;*/
				margin-bottom: 0;
			}
		}
	</style>
</answeritem>