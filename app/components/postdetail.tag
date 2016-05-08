<postDetail>

<div class="well">
{this.post.get('content')}
</div>

<script>
var self = this
postDetailTag = this

this.post = {}

this.on('mount', function() {
 this.getPostContent()
 })

 getPostContent(){
 	console.log('getting post content');
	// API.getDetailsForPost(self.parent.selectedId).then(function(content){
	// 	this.postAnswer = content.post
	// 	self.update()
	// 	})
	}
 
 

</script>

<style scoped>

</style>
</postDetail>