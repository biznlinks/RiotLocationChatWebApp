<deletepost>

<div id="deletepostModal" class="modal fade" role="dialog">
	<div class="modal-dialog">

		<div class="modal-content">
			<div class="header modal-header"><button type="button" class="close" data-dismiss="modal">&times;</button></div>

			<div class="modal-body">
				<div class="text">Are you sure you want to delete the post?</div>
				<div class="buttons">
					<button class="btn btn-default" onclick={ deletepost }>Yes</button>
					<button class="btn btn-default" data-dismiss="modal">No</button>
				</div>
			</div>
		</div>

	</div>

</div>

<script>
	var self      = this
	deletepostTag = this
	self.post     = opts.post

	deletepost() {
		self.post.destroy({
			success: function() {
				homefeedTag.init()
				$('#deletepostModal').modal('hide')
			}, error: function(error) {}
		})
	}
</script>

<style scoped>

</style>
</deletepost>