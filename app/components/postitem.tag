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
 			<a>
 				<div class="text-muted pull-xs-left" onclick={ this.showAnswerBox }>
					<div class='answercount' if={post.get('answerCount') >= 0} >{post.get('answerCount')} answer<span if={post.get('answerCount')!=1}>s</span>
					</div>
				</div>

				<div class="text-muted pull-xs-right">

					<div class='wannaknow text-muted' >
						<!-- <img width="23px" src="/images/wannaknow_gray@2x.png">  -->
						<i class="fa fa-heart-o" name="wannaknowButton" aria-hidden="true" onclick={ this.submitWannaknow }></i>
						{post.get('wannaknowCount')}
					</div> 
				</div>
			</a>
		</div>
		<div class="card-block" if={ answerBoxEnabled }>
			<textarea name="answerbox" placeholder="Answer"></textarea>
			<div onclick={ this.submitAnswer }>Submit</div>
		</div>
		<div class="row">
			<div class="col-xs-12" >
				<div if={post.get('answerCount')>0}>
					<hr/>
					<div each={ answer in answers }>
						<answeritem answer=answer></answeritem>
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
	var self = this
	self.post = opts.post
	self.answers = []
	self.answerBoxEnabled = false

	this.on('mount', function() {
		if (this.post.get('answerCount')>0)
			API.getanswersforpost(this.post).then(function(answers){
				self.answers = answers
				self.update()
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

	showSignup(){
		$('#signupModal').modal('show')
	}

	submitWannaknow(){
		if (self.wannaknowButton.className.indexOf("fa-heart-o") != -1) {	// the button is gray a.k.a user hasn't followed
			var WannaknowObject = Parse.Object.extend('WannaKnow')
			var wannaknowObject = new WannaknowObject()

			wannaknowObject.save({
				post: self.post,
				//user:
			}, {
				success: function(wannaknowObject) {
					self.post.set('wannaknowCount', self.post.get('wannaknowCount') + 1)
					self.post.save()

					self.wannaknowButton.className = 'fa fa-heart'
					self.update()
				},
				error: function(wannaknowObject, error) {
					// Do something if there is an error
				}
			})
		} else {
			// Deselect wannaknow here
		}
	}

	submitAnswer(){
		var answerContent = self.answerbox.value

		if (answerContent != '') {
			var AnswerObject = Parse.Object.extend('Answer')
			var answerObject = new AnswerObject()
			answerObject.save({
				anonymous: true,
				answer: answerContent,
				//author: ,
				likes: 0,
				post: self.post,
				//university: ,
			}, {
				success: function(answerObject) {
					self.post.set('answerCount', self.post.get('answerCount') + 1)
					self.post.save()

					self.answers.push(answerObject)

					self.answerBoxEnabled = false
					self.answerbox.value = ''
					self.update()
				},
				error: function(answerObject, error) {
					// Do something if error
				}
			})
		}
	}

	goToPost(){
		var routeTo = '/post/' + self.post.id
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

	@media (min-width: 480px) {
		:scope {
			/*margin-right: 200px;*/
			margin-bottom: 0;
		}
	}
</style>
</postitem>