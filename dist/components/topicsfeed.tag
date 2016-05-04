
<topicsfeed>
	<posts name="topicsFeedPosts"></posts>


	<script>
		var self = this
		topicsfeedtag = this
		self.postsTag = this.tags.topicsFeedPosts

		this.on('update', function() {
			console.log("updating "+ this.parent.selectedTopicId);
			if (this.parent.selectedTopicId){
				self.topic = decodeURI(this.parent.selectedTopicId)

				API.constructQuestionsForTopics(self.topic).then(function(results) { 
					self.postsTag.update({posts:results})
				})


			}
		})

	</script>

	<style scoped>

	</style>
</topicsfeed>