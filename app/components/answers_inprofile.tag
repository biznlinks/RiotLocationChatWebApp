<ansprofile>

	<div class="card pointer" each={ reply in replies } onclick={ this.gotoPost(reply) }>
		<div class="card-block">
			<p class="post-content text-muted">{ reply.get('post').get('content') }</p>
			<p class="reply-content">{ reply.get('answer') }</p>

			<div class="likes" align="right">{ reply.get('likes') } like<span if={ reply.get('likes') != 1 }>s</span>  </div>
		</div>
	</div>

<script>
	var self = this
	self.replies = opts.replies

	gotoPost(reply) {
		return function(e) {
			var routeTo = '/post/' + reply.get('post').id
			riot.route(routeTo)
			self.update()
		}
	}
</script>

<style scoped>
	.card-block {
    	padding: 0.9rem;
	}

	.reply-content {
		font-size: large;
	}

	.pointer:hover {
		cursor: pointer;
		-webkit-touch-callout: none;
		-webkit-user-select: none;
		-khtml-user-select: none;
		-moz-user-select: none;
		-ms-user-select: none;
		user-select: none;
	}
</style>

</ansprofile>