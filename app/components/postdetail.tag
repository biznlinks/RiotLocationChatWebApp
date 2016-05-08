<postDetail>

<div class="well">
{post.get('author').get('firstName')}
{post.get('author').get('lastName')}
{post.get('content')}
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
	API.getDetailsForPost(self.parent.selectedId).then(function(content){
		self.post = content.post
		self.update()
		})
	}
 
 

</script>

<style scoped>

</style>
</postDetail>