<postitem>
	<div class="container">
		<div class="col-xs-12 ">

			<div class="row">

				<div class='postauthor'>
					<img src = "{this.getProfilePic()}" class = "profile img-circle">
					<span >{post.get('author').get('firstName')} {post.get('author').get('lastName')}</span> 
					<!-- <h4 class="card-title">{getAuthorName(post)}</h4> -->
				</div>

				<p class="">{post.get('content')}</p>



			</div>
			<div class="row">
				<div class='answercount pull-xs-right' if={post.get('answerCount') > 0} 
					href="/post/{ post.id }" class="answerCount">{post.get('answerCount')} answer<span if={post.get('answerCount')>1}>s</span>
				</div>
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


		</div>

		
	</div>
	

	<script>
		var self = this
		self.post = opts.post
		self.answers = []

		this.on('mount', function() {
			if (this.post.get('answerCount')>0)
				API.getanswersforpost(this.post).then(function(answers){
					self.answers = answers
					self.update()
				})
		})

		getProfilePic(){
			var author= self.post.get('author')
			if (author.get('profilePic')){
				profilePic = author.get('profilePic').url()
				if (profilePic){
					return profilePic
				}
			}else {
				return 'https://files.parsetfss.com/135e5227-e041-4147-8248-a5eafaf852ef/tfss-6f1e964e-d7fc-4750-8ffb-43d5a76b136e-kangdo@umich.edu.png'
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
		.postauthor{
			font-size: small;
			padding-bottom: 10px;
			padding-top: 10px;
		}
		.profile {
			width: 40px;
			height: 40px;
			margin-right: 10px;
		}

		.answercount{
			font-size: small;
		}

		@media (min-width: 480px) {
			:scope {
				/*margin-right: 200px;*/
				margin-bottom: 0;
			}
		}
	</style>
</postitem>