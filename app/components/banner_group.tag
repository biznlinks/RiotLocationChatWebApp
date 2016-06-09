<banner>

<div class="banner-container">
	<div class="" align="center">
		<div class="background-image" id="background">
		</div>

		<div class="row group-info">
			<div class="col-md-10 col-md-offset-1 col-lg-8 col-lg-offset-2">
				<div class="group-name">{ containerTag.group.get('name') }</div>
				<div class="members text-muted">{ locale } • { memberCount } joined</div>
				<div class="most-active-container">
					<div each={ user in mostActive } class="most-active">
						<img src={ API.getProfilePicture(user) } class="img-circle most-active-picture">
					</div>
				</div>
				<div class="group-desc">{ containerTag.group.get('description') }</div>
				<div class="join-group" if={ !joined } onclick={ this.submitJoin }>Join</div>
			</div>
		</div>
	</div>
</div>

<script>
	var self = this
	self.joined = false
	self.locale = ''
	self.memberCount = 0

	this.on('mount', function() {
		self.init()
	})

	init() {
		API.getActiveUsers(containerTag.group, 5).then(function(results) {
			self.mostActive = []
			for (var i = 0; i < results.length; i++) self.mostActive.push(results[i].get('user'))
			self.update()
		})
		API.getusercity(containerTag.group.get('location')).then(function(result) {
			self.locale = result
			self.update()
		})

		if (groupsTag.joinedGroups) {
			if (groupsTag.groups.indexOf(containerTag.group) > -1) self.joined = false
			else self.joined = true
			self.update()
		} else {
			API.getUserGroups(Parse.User.current()).then(function(groups) {
				groups = groups.filter(function(group) { return group.get('group').id == containerTag.group.id })
				if (groups.length == 0) self.joined = false
				else self.joined = true
				self.update()
			})
		}

		self.memberCount = containerTag.group.get('memberCount')
		if (containerTag.group.get('image')) {
			bgUrl = containerTag.group.get('image').url()
			$('#background').css("background-image", "url('" + bgUrl + "')")
		} else $('#background').css("background-image", "url('/images/annarbor.jpg')")
		self.update()
	}

	submitJoin() {
		self.joined = true
		self.memberCount++
		self.update()

		var UserGroup = Parse.Object.extend('UserGroup')
		var userGroup = new UserGroup()
		userGroup.save({
			user: Parse.User.current(),
			group: containerTag.group
		},{
			success: function(userGroup) {
				if (self.mostActive.length < 5) self.mostActive.push(Parse.User.current())
				else self.mostActive[4] = Parse.User.current()
				self.update()
			},
			error: function(userGroup, error) {
				console.error("Error saving UserGroup " + error.message)
				self.joined = false
				self.memberCount--
				self.update()
			}
		})
	}

</script>

<style scoped>
	.banner-container {
		margin-top: -57px;
	}

	.background-image {
		background-size: cover;
    	background-repeat: no-repeat;
    	background-position: 50% 50%;
		height: 220px;
	}

	.group-info {
		background-color: white;
		padding: 10px;
	}

	.group-name {
		font-size: x-large;
		font-weight: bolder;
	}

	.members {
		margin-bottom: 10px;
	}

	.join-group {
		text-align: center;
		padding: 8px 15px;
		font-size: large;
		color: white;
		background: #6794ff;
		-webkit-border-radius: 5px;
    	-moz-border-radius: 5px;
    	border-radius: 5px;
	}

	.most-active-container {
		padding-bottom: 10px;
		border-bottom: 1px solid #ddd;
	}

	.most-active {
		margin-right: 10px;
		display: inline-block;
	}

	.most-active-picture {
		width: 35px;
		height: 35px;
		border: 2px solid white;
	}

	.group-desc {
		padding: 10px;
		font-size: large;
	}

	.inline {
		display: inline-block;
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


	@media screen and (min-width: 534px) {
		.background-image {
			height: 300px;
		}
	}
</style>

</banner>