<postDetail>

	<posts></posts>

	<script>
		var self = this
		postDetailTag = this
		self.postsTag = this.tags.posts
		self.postid = this.opts.postid

		this.post = {}

		this.on('mount', function() {
			if (self.postid){
				API.getDetailsForPost(self.postid).then(function(content){
					self.post = content.post
					self.postsTag.update({posts: [self.post], loading:false})
				})
			}
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



}



</script>

<style scoped>
	.card-img-top{
		width: 100%;
	}
	.profile {
		width: 40px;
		height: 40px;
	}
</style>
</postDetail>