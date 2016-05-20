<postitem>
	<div class="card ">
		<div class="card-block">

			<div class="" onclick={ this.goToPost }>

				<div class='postauthor text-muted'>
					<img src = "{this.getProfilePic()}" class = "profile img-circle">
					<span><span >{this.getAuthorName()}</span> <br/>
					<!-- <span class='author-about text-muted'>{post.get('author').get('about')}</span></span> -->


					<!-- <h4 class="card-title">{getAuthorName(post)}</h4> -->
				</div>

				<p class="post-content">{post.get('content')}</p>



			</div>
			<!-- <a onclick={this.showSignup}> -->
 			<div class="pointer">
 				<div class="text-muted pull-xs-left" onclick={ this.showAnswerBox }>
					<div class='answercount' if={post.get('answerCount') >= 0} >{post.get('answerCount')} answer<span if={post.get('answerCount')!=1}>s</span>
					</div>
				</div>

				<div class="text-muted pull-xs-right">

					<div class='wannaknow text-muted' onclick={ this.submitWannaknow }>
						<!-- <img width="23px" src="/images/wannaknow_gray@2x.png">  -->
						<i class={ fa: true, fa-heart-o: !wannaknown, fa-heart: wannaknown } name="wannaknowButton" aria-hidden="true"></i>
						<!-- {post.get('wannaknowCount')} -->
						{ wannaknowCount }
					</div>
				</div>
			</div>
		</div>
		<div class="card-block" if={ answerBoxEnabled }>
			<textarea name="answerbox" placeholder="Type your reply"></textarea>
			<div class="pointer submit" onclick={ this.submitAnswer }>Submit</div>
		</div>
		<div class="card-block" if={ sending }>
			Sending your reply ...
		</div>
		<div class="row">
			<div class="col-xs-12" >
				<div if={post.get('answerCount')>0}>
					<hr/>
					<div each={ ans in answers }>
						<answeritem answer={ ans }></answeritem>
					</div>

				</div>



			</div>
		</div>


		<!-- <ul class="list-group list-group-flush">
			<li class="list-group-item"><input class="comment-input" type="text" placeholder="Answer" /></li>
		</ul>
	-->
</div>



</div>



<script>
	var self              = this
	self.post             = opts.post
	self.answers          = []
	self.answerBoxEnabled = false
	self.sending          = false
	self.wannaknowCount   = 0
	self.wannaknown       = false

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
		var author= self.post.get('author')
		if (!author.get('profilePic') || this.post.get('anonymous')){
			if (author.get('profileImageURL')){
				return author.get('profileImageURL')
			}
			return 'https://files.parsetfss.com/135e5227-e041-4147-8248-a5eafaf852ef/tfss-6f1e964e-d7fc-4750-8ffb-43d5a76b136e-kangdo@umich.edu.png'

		}else {
			profilePic = author.get('profilePic').url()
			if (profilePic){
				return profilePic
			}
		}
	}

	showAnswerBox(){
		self.answerBoxEnabled = !self.answerBoxEnabled
		self.update()
	}

	submitWannaknow(){
		if (!self.wannaknown) {	// the button is gray a.k.a user hasn't followed
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
			self.answerBoxEnabled = false
			self.answerbox.value  = ''
			self.sending          = true
			self.update()

			var AnswerObject = Parse.Object.extend('Answer')
			var answerObject = new AnswerObject()
			answerObject.save({
				answer: answerContent,
				author: Parse.User.current(),
				likes: 0,
				post: self.post
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

	goToPost(){
		if (window.location.href.indexOf("/post/") == -1) {
			var routeTo = '/post/' + self.post.id
			riot.route(routeTo)
			self.update()
		}
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

	.card-block {
    	padding: 0.9rem;
	}
	.post-content{
		font-size: large;
	}
	.postauthor{
		margin-bottom: 5px;
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

	.submit {
		position: absolute;
		right: 3%;
		color: #5c5c5c;
	}

	textarea {
		width: 100%;
		resize: none;
		-webkit-border-radius: 5px;
    	-moz-border-radius: 5px;
    	border-radius: 5px;
	}

	@media (min-width: 480px) {
		:scope {
			/*margin-right: 200px;*/
			margin-bottom: 0;
		}
	}
</style>
</postitem>