<postitem>
	<div class="card ">
		<div class="card-block">

			<div class="">

				<div class='postauthor text-muted'>
					<img src = "{this.getProfilePic()}" class = "profile img-circle">
					<span><span >{this.getAuthorName()}</span> <br/>
					<!-- <span class='author-about text-muted'>{post.get('author').get('about')}</span></span> -->
					

					<!-- <h4 class="card-title">{getAuthorName(post)}</h4> -->
				</div>

				<p class="post-content">{post.get('content')}</p>



			</div>
			<a onclick={this.showSignup}>
				<div class="text-muted pull-xs-left">
					<div class='answercount' if={post.get('answerCount') >= 0} >{post.get('answerCount')} answer<span if={post.get('answerCount')!=1}>s</span>
					</div>
				</div>

				<div class="text-muted pull-xs-right">


					<div class='wannaknow text-muted' >
						<img width="23px" src="/images/wannaknow_gray@2x.png"> 
						{post.get('wannaknowCount')}
					</div> 
				</div>
			</a>
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

	getAuthorName() {
		if (this.post.get('anonymous'))
			return 'Anonymous'
		else 
			return this.post.get('author').get('firstName') + ' ' + this.post.get('author').get('lastName')
	}

	this.on('mount', function() {
		if (this.post.get('answerCount')>0)
			API.getanswersforpost(this.post).then(function(answers){
				self.answers = answers
				self.update()
			})
	})

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

	showSignup(){
		$('#signupModal').modal('show')
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