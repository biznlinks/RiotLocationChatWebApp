
<topicsfeed>
	<div class="card">
		<img class="card-img-top" src="{this.getTopicImage()}" alt="Card image cap"></img>
		<div class="card-block">
			<h4 class="card-title">#{topicName}</h4>
			<p class="card-text"></p>
			<p class="card-text"><small class="text-muted">{postCount} questions for this topic</small></p>
		</div>
	</div>
	<posts name="topicsFeedPosts"></posts>


	<script>
		var self = this
		topicsfeedtag = this
		self.postsTag = this.tags.topicsFeedPosts
		self.topicName = decodeURI(this.opts.topicName)
		self.postCount = 0
		// self.topicName = decodeURI(this.parent.selectedTopicId)

		this.on('mount', function() {
			console.log("updating "+ self.topicName);
			this.fetchTopicDetails()
			self.postsTag.update({loading:true})
			if (self.topicName){
				self.topicName = decodeURI(self.topicName)
				API.constructQuestionsForTopics(self.topicName).then(function(results) { 
					self.update({postCount: results.length})
					self.postsTag.update({posts:results, loading:false})
				})
			}
		})

		getTopicImage(){
			if (!self.topic || !self.topic.get('image')){
				return 'http://files.parsetfss.com/57d0a677-36de-4c63-b991-c2bb1ac2dbb5/tfss-9c330043-dcf6-4139-9091-d8ea601ad14b-chi.jpeg'
				
			}
			return self.topic.get('image').url()
			// else

		}

		// load information about the topic like picture/ video/ description/ etc
		fetchTopicDetails() {
			if (self.topicName){
				self.topicName = decodeURI(self.topicName)
				API.getObjectForTopic(self.topicName.toLowerCase()).then(function(topic){
					self.topic = topic
					self.update()
				})
			}
			
		}

	</script>

	<style scoped>
		.card-img-top{
			width: 100%;
		}
	</style>
</topicsfeed>