<groupslist>

<div if={ joinedGroups.length > 0 }>
	<div class="title">
		<i>Joined</i>
	</div>
	<div class="row">
		<div class="col-sm-1 col-xs-1 fa fa-chevron-left arrow pointer" if={ joinedStart!=0 } onclick={ this.shiftLeft }></div>
		<div style="padding: 0 -1rem;" class={col-sm-10: true, col-xs-10: true, col-sm-offset-1: joinedStart==0 || joinedGroups.length <= joinedLength, col-xs-offset-1: joinedStart==0 || joinedGroups.length <= joinedLength }>
			<div class="row">
				<div class="col-sm-3 col-xs-4 tile pointer" each={ group in joinedGroups.slice(joinedStart, joinedEnd) } onclick={ this.chooseGroup(group.get('group')) }>
					<img src={ API.getGroupImage(group.get('group')) } class="image-joined img-circle">
					<div class="group-title">
						{ group.get('group').get('name').slice(0,20) }
						<span if={ group.get('group').get('name').length > 20 }>...</span>
					</div>
				</div>
			</div>
		</div>

		<div class="col-sm-1 col-xs-1 fa fa-chevron-right arrow pointer" if={ joinedEnd < joinedGroups.length } onclick={ this.shiftRight }></div>
	</div>
</div>
<div if={ joinedGroups.length > 0 }>
	<hr>
</div>
<div class="title">
	<i>Nearby</i>
</div>
<div class="nearby">
	<ul>
		<li each={ group in groups } onclick={ this.chooseGroup(group) }>
			<div class="pointer">
				<img src={ API.getGroupImage(group) } class="image-nearby img-circle">
				<div class="info-box">
					<div class="group-title">{ group.get('name') }</div>
					<div class="desc">{ group.get('description') }</div>
				</div>
			</div>
		</li>
	</ul>
</div>


<script>
	var self = this
	self.joinedGroups = opts.joinedGroups
	self.groups = opts.groups


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
	.row > * {
		padding: 0;
	}

	.title {
		padding: 10px 10px;
		padding-top: 20px;
	}

	.arrow {
		padding-top: 30px;
		padding-bottom: 70px;
	}

	.fa-chevron-right {
		text-align: center;
	}
	.fa-chevron-left {
		text-align: center;
	}

	.tile {
		vertical-align: top;
		text-align: center;
		display: inline-block;
	}

	.nearby li {
		padding-bottom: 20px;
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
		height: 60px;
		width: 60px;
		object-fit: cover;
	}

	.image-nearby {
		height: 60px;
		width: 60px;
		object-fit: cover;
		margin: auto 10px;
	}

	.gray {
		border: none;
		background-image: url('/images/default_image.jpg');
		background-size: cover;
	}

	.nearby .group-title {
		margin-top: 0;
	}

	.info-box{
		display: inline-block;
		vertical-align: middle;
		width: calc(100% - 100px);
		display: inline-block;
		border-bottom: 1px solid #ccc;
		padding-top: 20px;
		padding-bottom: 20px;
	}

	.group-title {
		margin-top: 10px;
		font-size: 14px;
		font-weight: 500;
	}

	.desc{
		font-size: 12px;
	}

	@media (max-width: 480px) {
		.group-title > * {
			font-size: 12px;
		}

		.desc{

		}
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
</groupslist>