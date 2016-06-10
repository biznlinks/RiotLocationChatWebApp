<groups>
<div class="outer-container">
	<!-- <div class="search-container row">
		<div class="col-sm-8 col-sm-offset-2">
			<textarea placeholder="Search Groups" class="search-groups" rows="1"></textarea>
		</div>
	</div> -->

	<div class="groups-container">
		<div class="title">
			<i>Joined</i>
		</div>
		<div class="joined">
			<div class="row">
				<div class="col-sm-1 col-xs-1 fa fa-chevron-left arrow pointer" if={ joinedStart!=0 } onclick={ this.shiftLeft }></div>

				<div class={col-sm-10: true, col-xs-10: true, col-sm-offset-1: joinedStart==0 || joinedGroups.length <= joinedLength, col-xs-offset-1: joinedStart==0 || joinedGroups.length <= joinedLength }>
					<div class="row">
						<div class="col-sm-3 col-xs-4 tile pointer" each={ group in joinedGroups.slice(joinedStart, joinedEnd) } onclick={ this.chooseGroup(group.get('group')) }>
							<div>
								<img if={ typeof group.get('group').get('image')!='undefined' } src={ group.get('group').get('image').url() } class="image-joined img-circle">
								<img if={ typeof group.get('group').get('image')=='undefined' } src="" class="image-joined gray img-circle">
							</div>
							<div class="name">
								{ group.get('group').get('name').slice(0,20) }
								<span if={ group.get('group').get('name').length > 20 }>...</span>
							</div>
						</div>
					</div>
				</div>

				<div class="col-sm-1 col-xs-1 fa fa-chevron-right arrow pointer" if={ joinedEnd < joinedGroups.length } onclick={ this.shiftRight }></div>
			</div>
		</div>

		<div class="title">
			<i>Nearby</i>
		</div>
		<div class="nearby">
			<ul>
				<li each={ group in groups } onclick={ this.chooseGroup(group) }>
					<div class="row pointer">
							<img if={ typeof group.get('image')!='undefined' } src={ group.get('image').url() } class="image-nearby img-circle">
							<img if={ typeof group.get('image')=='undefined' } src="" class="image-nearby gray img-circle">
							<div class="info-box">
								<div class="name">{ group.get('name') }</div>
								<div class="desc">{ group.get('description') }</div>
							</div>
						</div>
					</div>
				</li>
			</ul>
		</div>
	</div>

	<button class="btn mfb-component--br" name="submit" onclick={ showCreateModal }>
		<svg style="width:24px;height:24px" viewBox="0 0 24 24">
		    <path d="M19,13H13V19H11V13H5V11H11V5H13V11H19V13Z" stroke="white" stroke-width="2" fill="none"/>
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
			API.getallgroups().then(function(groups) {
				self.groups = groups.filter(function(group) {
					for (var i = 0; i < self.joinedGroups.length; i++)
						if (group.id == self.joinedGroups[i].get('group').id) return false
					return true
				})
				self.update()
			})
		})
	}

	showCreateModal() {
		$('#creategroupModal').modal('show')
	}

	chooseGroup(group) {
		return function() {
			containerTag.group = group
			riot.route(encodeURI(group.get('groupId')))
			self.update()
		}
	}

	shiftLeft() {
		self.joinedEnd = self.joinedStart
		self.joinedStart -= self.joinedLength
		self.update()
	}

	shiftRight() {
		self.joinedStart = self.joinedEnd
		self.joinedEnd += self.joinedLength
		self.update()
	}
</script>
<style scoped>
	:scope {
		color: #909090;
	}

	.outer-container {
		background-color: white;
		padding: 10px;
		margin-top: 50px;
	}

	.user-locale {
		text-align: center;
	}

	.search-container {
		text-align: center;
		margin-top: 25px;
	}

	.search-groups {
		resize: none;
		text-align: center;
		font-size: large;
		padding: 7px 0;
		width: 100%;
		-webkit-border-radius: 25px;
    	-moz-border-radius: 25px;
    	border-radius: 25px;
	}

	.search-groups:focus {
		outline: none;
	}

	.groups-container {
		margin-top: 20px;
	}

	.title {
		padding: 5px 10px;
	}

	.joined {
		margin-top: 10px;
		padding-bottom: 20px;
		border-bottom: 1px solid #909090;
	}

	.arrow {
		padding-top: 40px;
		padding-bottom: 70px;
	}

	.fa-chevron-right {
		text-align: left;
		padding-left: 0;
	}
	.fa-chevron-left {
		text-align: right;
		padding-right: 0;
	}

	.tile {
		vertical-align: top;
		text-align: center;
		display: inline-block;
	}

	.nearby li {
		padding-top: 20px;
		padding-bottom: 20px;
		border-bottom: 1px solid #ccc;
	}

	.nearby ul {
		list-style: none;
		margin-bottom: 0;
		padding: 0;
	}

	.image-container {
		text-align: center;
	}

	.image-joined {
		height: 70px;
		width: 70px;
		object-fit: cover;
	}

	.image-nearby {
		height: 70px;
		width: 70px;
		object-fit: cover;
		margin: auto 10px;
	}

	.gray {
		border: none;
		background-image: url('/images/default_image.jpg');
		background-size: cover;
	}

	.nearby .name {
		margin-top: 0;
		font-size: large;
		color: #555;
	}

	.info-box{
		display: inline-block;
		vertical-align: middle;
	}

	.name {
		margin-top: 10px;
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
</groups>