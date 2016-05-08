<postDetail>

<div class="col-lg-12 ">
        <img class="card-img-top" src="{this.getTopicImage()}" alt="Card image cap"></img>
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
</div>

	<answers name="answers" ></answers>

<script>
var self = this
postDetailTag = this

this.post = {}

this.on('mount', function() {
 this.getPostContent()
 })

getTopicImage(){
			var image = self.topicImage
			if (image)
				return image.url()
		}

// load information about the topic like picture/ video/ description/ etc
fetchTopicImageForPost() {
	API.getObjectForTopic(self.topicName.toLowerCase()).then(function(topic){
		self.update({topic:topic})
	})
}

 getPostContent(){
 	console.log('getting post content');
	API.getDetailsForPost(self.parent.selectedId).then(function(content){
		self.post = content.post
		self.answers = content.answers
		self.topicImage = content.topicImage
		self.update()
		})
	}
 
 

</script>

<style scoped>
	.card-img-top{
		width: 100%;
	}
	 .author{
  	font-size: medium;
  }
  .profile {
  	width: 40px;
  	height: 40px;
  }
	</style>
</postDetail>