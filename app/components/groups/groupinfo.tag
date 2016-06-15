<groupinfo>

<div>
	<div class="group-info">
		<div class="group-name">{ containerTag.group.get('name') }</div>
		<div class="members text-muted">{ locale } • { containerTag.group.get('memberCount') } joined</div>
		<div class="group-desc">{ containerTag.group.get('description') }</div>
	</div>
</div>


<script>
	var self = this
	self.locale = ''

	this.on('mount', function() {

	})

	init() {
		API.getusercity(containerTag.group.get('location')).then(function(result) {
			self.locale = result
			self.update()
		})
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