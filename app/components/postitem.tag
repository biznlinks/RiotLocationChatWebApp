<postitem>
<a href="/post/{ post.id }">
			<div class="card card-block">
			<div class='author'></div>
					<img src = "{post.get('author').get('profilePic').url()}" class = "profile img-circle">
				 <span >{post.get('author').get('firstName')} {post.get('author').get('lastName')}</span> 
				<!-- <h4 class="card-title">{getAuthorName(post)}</h4> -->
				<p class="card-text">{post.get('content')}</p>
				<a if={post.get('answerCount') > 0} href="/post/{ post.id }" class="answerCount">{post.get('answerCount')} answers</a>
				<div if={post.get('answerCount') > 0} class="card card-block">
				{post.postAnswer}
				</div>
			</div>
			
		</a>

	<script>
	var self = this
		self.post = opts.post

		this.on('mount', function() {
			if (this.post.get('answerCount')>0)
				API.getanswersforpost(this.post).then(function(answers){
	        		self.post.postAnswer = answers[0].get('answer')
	        		self.update()
	        	})
		})
	</script>

<style scoped>
  :scope {
   

  }
  .author{
  	font-size: medium;
  }
  .profile {
  	width: 40px;
  	height: 40px;
  }


  @media (min-width: 480px) {
    :scope {
      /*margin-right: 200px;*/
      margin-bottom: 0;
    }
  }
</style>
</postitem>