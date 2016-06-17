<groupinfo>

<div>
	<div class="group-info">
		<div if={loading} class="modal-body text-xs-center">
			<i class="fa fa-spinner fa-spin fa-3x fa-fw margin-bottom"></i>
			<span class="sr-only">Loading...</span>
		</div>
		<div if={!loading}>
			<div id="group-pic" style="background-image: url('{ API.getGroupImage(containerTag.group) }')">
				<div if={ containerTag.group.get('image') == undefined && containerTag.group.get('creator').id == Parse.User.current().id }>
					<button class="edit-button btn btn-primary fa fa-pencil" onclick={ showEditGroup }></button>
				</div>
			</div>
		</div>
		<div class="group-name">{ containerTag.group.get('name') }</div>
		<div class="members text-muted">{ locale } • { containerTag.group.get('memberCount') } joined</div>
		<div class="group-desc">{ containerTag.group.get('description') }</div>
	</div>
</div>


<script>
	var self     = this
	groupinfoTag = this
	self.locale  = ''

	this.on('mount', function() {
		editgroupTag.init()
	})

	init() {
		API.getusercity(containerTag.group.get('location')).then(function(result) {
			self.locale = result
			self.update()
		})
	}

	showEditGroup() {
		$('#editgroupModal').modal('show')
	}

</script>

<style scoped>
	:scope {
		text-align: center;
	}

	.group-info {
		margin-top: 5px;
		padding: 10px;
		border-bottom: 1px solid #ccc;
	}

	#group-pic {
		width: 100%;
		height:300px;
		background-size: cover;
		background-position: 50% 30%;
		position: relative;
	}

	#uploaded-image {
		width: 100%;
		height: 300px;
	}

	.edit-button {
		position: absolute;
		bottom: 0;
		right: 0;
		margin-bottom: 0;
	}

	.group-name {
		font-size: x-large;
		font-weight: bolder;
	}

	.members {
		margin-bottom: 10px;
	}

	.group-desc {
		padding: 10px;
		font-size: large;
	}
</style>
</groupinfo>