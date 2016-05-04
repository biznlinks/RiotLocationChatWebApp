<postdetail> <div class=well> {post.get('content')} </div> <script>
var self = this
postDetailTag = this

this.post = {}

this.on('update', function() {
 this.getPostContent()
 })

getPostContent() {
  if (self.parent.selectedId){
   var post = Post.createWithoutData(self.parent.selectedId);
   post.fetch().then(function(post) {
    self.update({post: post})
    })
 }
 
 
}

</script> <style scoped>

</style> </postdetail>