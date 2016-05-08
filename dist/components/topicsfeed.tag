
<topicsfeed>
	<div class="card">
		<div class="card-img-top" alt="Card image cap"><iframe width="100%" src="https://www.youtube.com/embed/zNac9Tjn0LY?list=PLqhXYFYmZ-Vcui07v-6-TXiETq3Zk7YTt" frameborder="0" allowfullscreen></iframe></div>
		<div class="card-block">
			<h4 class="card-title">{self.topic}</h4>
			<p class="card-text">description</p>
			<p class="card-text"><small class="text-muted">3 questions for this topic</small></p>
		</div>
	</div>
	<posts name="topicsFeedPosts"></posts>


	<script>
		var self = this
		topicsfeedtag = this
		self.postsTag = this.tags.topicsFeedPosts
		self.topic = decodeURI(this.parent.selectedTopicId)

		this.on('update', function() {
			console.log("updating "+ this.parent.selectedTopicId);
			if (this.parent.selectedTopicId){
				self.topic = decodeURI(this.parent.selectedTopicId)
				API.constructQuestionsForTopics(self.topic).then(function(results) { 
					self.postsTag.update({posts:results})
				})
			}
		})

		// load information about the topic like picture/ video/ description/ etc
		fetchTopicDetails() {

		}

	</script>

	<style scoped>

	</style>
</topicsfeed>