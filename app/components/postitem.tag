<postitem>
	<div class="card">
		<div class="card-block pointer">

			<div class="" onclick={ this.goToPost }>

				<div class='postauthor text-muted'>
					<img if={ !post.get('anonymous') } src = "{ API.getProfilePicture(post.get('author')) }" class = "profile img-circle">
					<img if={ post.get('anonymous') } src="/images/default_profile.png" class="profile img-circle">
					<span class="author">{this.getAuthorName()}</span> <br/>
					<!-- <span class='author-about text-muted'>{post.get('author').get('about')}</span></span> -->


					<!-- <h4 class="card-title">{getAuthorName(post)}</h4> -->
				</div>

				<p class="post-content">{post.get('content')}</p>



			</div>
			<!-- <a onclick={this.showSignup}> -->
 			<div class="pointer row">
				<div class="col-xs-5 text-muted infodiv">
					<div class='answercount' if={post.get('answerCount') >= 0} >{post.get('answerCount')} Repl<span if={post.get('answerCount')!=1}>ies</span><span if={ post.get('answerCount') == 1 }>y</span>
					</div>

					<div class='wannaknow text-muted' onclick={ this.submitWannaknow }>
						<!-- <img width="23px" src="/images/wannaknow_gray@2x.png">  -->
						<i class={ fa: true, fa-heart-o: !wannaknown, fa-heart: wannaknown } name="wannaknowButton" aria-hidden="true"></i>
						<!-- {post.get('wannaknowCount')} -->
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
		<hr if={post.get('answerCount')>0}/>
		<div class="row">
			<div class="col-xs-12" >
				<div if={post.get('answerCount')>0}>

					<div each={ ans in answers }>
						<answeritem answer={ ans }></answeritem>
					</div>

				</div>
			</div>
		</div>


		<div class="reply-container">
			<hr/>
			<div class="card-block input-group">
				<div class="input-group-addon answer-icon-container pointer" onclick={ this.toggleAnonymous }>
					<img src={ API.getCurrentUserProfilePicture() } class="answer-icon img-circle" if={ !anonymous }>
					<img src="/images/default_profile.png" class="answer-icon img-circle" if={ anonymous }>
				</div>
				<textarea class="form-control" name="answerbox" id="answerbox" oninput={ this.onInput } rows="1" placeholder="Add reply"></textarea>
			</div>
			<a class="submit pointer" onclick={ this.submitAnswer } if={ submitButton }>Send</a>
			<div class="card-block" if={ sending }>
				Sending your reply ...
			</div>
		</div>


		<!-- <ul class="list-group list-group-flush">
			<li class="list-group-item"><input class="comment-input" type="text" placeholder="Answer" /></li>
		</ul>
	-->
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

	getProfilePic(){
		var author = self.post.get('author')
		if (!author.get('profilePic') || this.post.get('anonymous')){
			if (author.get('profileImageURL')){
				return author.get('profileImageURL')
			}
			return '/images/default_profile.png'

		}else {
			profilePic = author.get('profilePic').url()
			if (profilePic){
				return profilePic
			}
		}
	}

	getUserProfilePic() {
		if (self.anonymous && Parse.User.current().get('type') == 'actual')
			return '/images/default_profile.png'

		var user       = Parse.User.current()
		var profilePic = user.get('profileImageURL')
		if (profilePic){
			return profilePic
		}
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
		if (window.location.href.indexOf("/post/") == -1) {
			var routeTo = '/post/' + self.post.id
			riot.route(routeTo)
			self.update()
		}
	}

	gotoTopic() {
		var routeTo = '/schedule/' + encodeURIComponent(self.post.get('topic'))
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
	hr {
		margin: 0px;
		margin-bottom: 1rem;
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
		text-align: right;
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

	.answer-icon-container {
		background-color: #FFFFFF;
		border-right: 0;
	}

	.answer-icon {
		width: 25px;
		height: 25px;
	}

	.form-control {
		padding: .8rem;
		border: none;
	}

	.input-group {
		padding: 0px;
	}

	.input-group-addon {
		padding: .375rem;
		padding-left: .8rem;
		border: none;
	}

	textarea {
		width: 100%;
		font-size: large;
		resize: none;
		-webkit-border-radius: 5px;
    	-moz-border-radius: 5px;
    	border-radius: 5px;
    	border: none;
	}

	@media (min-width: 480px) {
		:scope {
			/*margin-right: 200px;*/
			margin-bottom: 0;
		}
	}
</style>
</postitem>