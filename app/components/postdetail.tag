<postDetail>

	<posts name="post"></posts>

	<div class="related-container">
		<div class="related-text">Related Posts</div>
		<miniposts class="related-posts" name="minifiedPosts"></miniposts>
	</div>

	<script>
		var self = this
		postDetailTag = this
		self.postid = this.opts.postid

		this.post = {}

		this.on('mount', function() {
			self.init()
		})

		init() {
			$(document).scrollTop(0)
			if (self.postid){
				API.getDetailsForPost(self.postid).then(function(content){
					self.post = content.post
					self.tags.post.update({posts: [self.post], loading:false})
					self.update()
				})

				API.getallposts(3).then(function(results){
					self.tags.minifiedPosts.update({posts:results, loading:false, author:false})
					self.update()
				})
			}
		}

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

	.related-container {
		margin-top: 20px;
	}
	.related-text {
		font-weight: bold;
		font-size: large;
		margin-bottom: 20px;
		padding-left: 10px;
	}
</style>
</postDetail>