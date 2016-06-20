<deletegroup>

<div id="deletegroupModal" class="modal fade" role="dialog">
	<div class="modal-dialog">

		<div class="modal-content">
			<div class="header modal-header"><button type="button" class="close" data-dismiss="modal">&times;</button></div>

			<div class="modal-body">
				<div class="text">Are you sure you want to delete {containerTag.group.get('name')}?</div>
				<div class="buttons">
					<button class="btn btn-default" onclick={ deleteGroup }>Yes</button>
					<button class="btn btn-default" data-dismiss="modal">No</button>
				</div>
			</div>
		</div>

	</div>

</div>

<script>
	var self = this

	deleteGroup() {
		containerTag.group.save({deleted: true}, {
			success: function(group) {
				$('#deletegroupModal').modal('hide')
				riot.route('/')
				riot.update()
			}, error: function(group, error) {}
		})
	}
</script>

<style scoped>

</style>
</deletegroup>