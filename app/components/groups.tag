<groups>
<div class="outer-container">
	<!-- <div class="search-container row">
		<div class="col-sm-8 col-sm-offset-2">
			<textarea placeholder="Search Groups" class="search-groups" rows="1"></textarea>
		</div>
	</div> -->

	<div class="groups-container">
		<groupsmap name="groupsmap"></groupsmap>
		<groupslist name="groupslist"></groupslist>
	</div>

	<button class="btn mfb-component--br" name="submit" onclick={ showCreateModal }>
		<svg width="20px" height="20px" viewBox="0 0 20 20" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
    <!-- Generator: Sketch 3.8.3 (29802) - http://www.bohemiancoding.com/sketch -->
    <title>Shape</title>
    <desc>Created with Sketch.</desc>
    <defs></defs>
    <g id="Page-1" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
        <polygon id="Shape" fill="#FFFFFF" points="20 11.4285714 11.4285714 11.4285714 11.4285714 20 8.57142857 20 8.57142857 11.4285714 0 11.4285714 0 8.57142857 8.57142857 8.57142857 8.57142857 0 11.4285714 0 11.4285714 8.57142857 20 8.57142857"></polygon>
    </g>
</svg>
	</button>
</div>


<script>
	var self          = this
	groupsTag         = this
	self.joinedStart  = 0
	self.joinedEnd    = 0
	self.joinedLength = 0

	this.on('mount', function() {
		if ($(window).width() > 543) self.joinedLength = 4
		else self.joinedLength = 3
		self.joinedEnd = self.joinedStart + self.joinedLength

		self.init()
	})

	init() {
		containerTag.group = null
		API.getjoinedgroups(Parse.User.current()).then(function(joinedGroups) {
			self.joinedGroups = joinedGroups
			API.getallgroups().then(function(groups) {		//TODO Add another filter to get the groups in joinedGroups UserGroup object
				self.groups = groups.filter(function(group) {
					for (var i = 0; i < self.joinedGroups.length; i++)
						if (group.id == self.joinedGroups[i].get('group').id) return false
					return true
				})

				self.tags.groupsmap.update({joinedGroups: self.joinedGroups, groups: self.groups})
				self.tags.groupsmap.initMap()
				self.tags.groupslist.update({joinedGroups: self.joinedGroups, groups: self.groups})
				self.update()
			})
		})
	}

	showCreateModal() {
		$('#creategroupModal').modal('show')
	}

</script>
<style scoped>

	.outer-container {
		background-color: white;
		padding-top: 10px;
		padding-left: 10px;
		padding-right: 10px;
		margin-top: 50px;
	}

	.groups-container {
		margin-top: 20px;
	}

	.mfb-component--br {
		right: 0;
		bottom: 0;
		text-align: center;
	}
	.mfb-component--tl, .mfb-component--tr, .mfb-component--bl, .mfb-component--br {
		box-sizing: border-box;
		margin: 25px;
		position: fixed;
		white-space: nowrap;
		z-index: 30;
		list-style: none;
		border-radius: 50%;
		width: 55px;
		height: 55px;
		padding: 0px;
		background: #039be5;
		color: white;
		font-size: 1.6em;
		box-shadow: 0 2px 5px 0 rgba(0,0,0,0.16),0 2px 10px 0 rgba(0,0,0,0.12);
	}

</style>
</groups>