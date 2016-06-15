<minipostitem>
	<div class="card outer-container">
		<div class="mini-container card-block pointer">

			<div class="" onclick={ this.goToPost }>

				<div class='postauthor text-muted' if={opts.author}>
					<img if={ !post.get('anonymous') } src = "{ API.getProfilePicture(post.get('author')) }" class = "profile img-circle">
					<img if={ post.get('anonymous') } src="/images/default_profile.png" class="profile img-circle">
					<span class="author">{this.getAuthorName()}</span> <br/>
				</div>

				<p class="post-content" name="content">{post.get('content')}</p>



			</div>
 			<div class="pointer row">
				<div class="col-xs-5 text-muted infodiv">
					<div class='answercount' if={post.get('answerCount') >= 0} >{post.get('answerCount')} Repl<span if={post.get('answerCount')!=1}>ies</span><span if={ post.get('answerCount') == 1 }>y</span>
					</div>

					<div class='wannaknow text-muted' onclick={ this.submitWannaknow }>
						<i class={ fa: true, fa-heart-o: !wannaknown, fa-heart: wannaknown } name="wannaknowButton" aria-hidden="true"></i>
						{ wannaknowCount }
					</div>
				</div>

				<div class="col-xs-7 align-right infodiv" onclick={ this.gotoTopic }>
 					<span class="topic" if={ post.get('topic') }>
 						{ post.get('topic').slice(0,20) } <span if={ post.get('topic').length > 20 }>...</span>
 					</span>
 				</div>
			</div>
		</div>
</div>



</div>



<script>
	var self            = this
	self.post           = opts.post
	self.answers        = []
	self.sending        = false
	self.wannaknowCount = 0
	self.wannaknown     = false
	self.submitButton   = false
	self.anonymous      = false

	this.on('mount', function() {
		if (this.post.get('answerCount')>0)
			API.getanswersforpost(this.post).then(function(answers){
				self.answers = answers
				self.update()
			})

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
		if (this.post.get('anonymous'))
			return 'Anonymous'
		else
			return this.post.get('author').get('firstName') + ' ' + this.post.get('author').get('lastName')
	}

	submitWannaknow(){
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

	submitAnswer(){
		var answerContent = self.answerbox.value

		if (answerContent != '') {
			// Set UI before processing
			self.answerbox.value = ''
			self.sending         = true
			self.submitButton    = false
			self.update()

			var AnswerObject = Parse.Object.extend('Answer')
			var answerObject = new AnswerObject()
			answerObject.save({
				answer: answerContent,
				author: Parse.User.current(),
				likes: 0,
				post: self.post,
				anonymous: self.anonymous
			}, {
				success: function(answerObject) {
					self.post.set('answerCount', self.post.get('answerCount') + 1)
					self.post.save()
					Parse.User.current().set('answerCount', Parse.User.current().get('answerCount') + 1)
					Parse.User.current().save()
					self.answers.push(answerObject)
					self.sending = false
					self.update()
				},
				error: function(answerObject, error) {
					// Do something if error
				}
			})
		}
	}

	onInput() {
		if (self.answerbox.value.length >= 3) {
			self.submitButton = true
			self.update()
		} else {
			self.submitButton = false
			self.update()
		}
	}

	toggleAnonymous() {
		self.anonymous = !self.anonymous
		self.update()
	}

	goToPost(){
		if (window.location.href.indexOf("/post/" + self.post.id) == -1) {
			var routeTo = 'post/' + self.post.id
			riot.route(routeTo)
			self.update()
		}
	}

	gotoTopic() {
		var routeTo = 'schedule/' + encodeURI(self.post.get('topic'))
		riot.route(routeTo)
		self.update()
	}

</script>

<style scoped>
	.container {
		background-color: #f7f7f9;
	}

	:scope {
		font-family: helvetica, arial, sans-serif;
		font-size: 14px;
		color: black;
		font-weight: normal;

	}

	.outer-container {
		margin-bottom: 0;
	}
	.mini-container {
		padding: 0.8rem;
	}

	.post-content{
		font-size: 20px;
		color: #424242;
		margin-top: 15px;
		margin-bottom: 20px;
	}
	.postauthor{
		margin-bottom: 5px;
	}
	.author {
		padding-right: 8px;
	}
	.author-about{
		font-size: smaller;
	}
	.profile {
		width: 40px;
		height: 40px;
		margin-right: 10px;
	}

	.wannaknow{
		display: inline-block;
		font-size: small;

	}

	.answercount{
		display: inline-block;
		font-size: small;
	    padding-right: 20px;
	}

	.comment-input {
		width: 100%
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

	.inline {
		display: inline-block;
	}

	.submit {
		right: 3%;
		padding-right:0.9rem;
		padding-bottom:0.9rem;
		color: #0275D8;
		text-align: center;
	}

	.submit:hover {
		color: #004784;
	}

	.topic {
		font-size: smaller;
		background-color: #EAEAEA;
		color: #787878;
		padding: 5px;
		padding-left: 10px;
    	padding-right: 10px;
		-webkit-border-radius: 17px;
    	-moz-border-radius: 17px;
    	border-radius: 17px;
    	white-space: nowrap;
    	text-overflow: ellipsis;
    	overflow: hidden;
	}
	.infodiv{
		padding: 0px;
	}

	.align-left {
		text-align: left;
		white-space: nowrap;
	}

	.align-right {
		text-align: right;
		white-space: nowrap;
	}

	.reply-container  hr{
		margin: 0;
	}

	@media (min-width: 480px) {
		:scope {
			/*margin-right: 200px;*/
			margin-bottom: 0;
		}
	}
</style>
</minipostitem>