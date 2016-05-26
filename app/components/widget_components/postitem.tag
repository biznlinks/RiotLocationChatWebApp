<postitem>

<div class="card">
	<div class="post-author">
		<img class="author-profile img-circle" if={ !post.get('anonymous') } src={ API.getProfilePicture(post.get('author')) }>
		<img class="author-profile img-circle" if={ post.get('anonymous') } src="/images/default-profile.png">

		<span class="author-name">{ this.getAuthorName() }</span>
	</div>

	<div class="post-content">
		<p>{ post.get('content') }</p>
	</div>

</div>

<script>
	var self = this
	self.post = opts.post

	getAuthorName() {
		if (self.post.get('anonymous')) return 'Anonymous'
		else {
			var author = self.post.get('author')
			return author.get('firstName') + ' ' + author.get('lastName')[0] + '.'
		}
	}
</script>

<style scoped>
	.card {
		padding: 8px;
		border: none;
		-webkit-border-radius: 0px;
    	-moz-border-radius: 0px;
    	border-radius: 0px;
	}

	.author-profile {
		width: 35px;
		height: 35px;
	}

	.author-name {
		font-weight: bold;
	}

	.post-content {
		margin-top: 8px;
	}
</style>
</postitem>