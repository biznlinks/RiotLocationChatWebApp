<groups>
<groupsmap name="groupsmap"></groupsmap>

<!-- Modal -->
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
        <img src="images/logo.png" style="width: 70%">
      </div>
      <div class="modal-body">
        Welcome to Sophus, the local group discovery platform that tells you what is happening right now near you. Join interest groups and discover what people like you are up to nearby. <br><br>
        To show you what's happening near you please allow location services. (Otherwise you'll see what's happening around our office in San Francisco).
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-primary center-block" data-dismiss="modal">Allow locations</button>
      </div>
    </div>
  </div>
</div>


<div class="outer-container" style="
    margin-right: auto;
    margin-left: auto;
    max-width: 700px;">
	<!-- <div class="search-container row">
		<div class="col-sm-8 col-sm-offset-2">
			<textarea placeholder="Search Groups" class="search-groups" rows="1"></textarea>
		</div>
	</div> -->
	<!-- <h3 style="text-align: center; padding-top: 1em;">#Yoga</h3> -->
	<div class="groups-container">
		<groupslist name="groupslist"></groupslist>
	</div>

	<button class="btn mfb-component--br" name="submit" onclick={ showCreateModal }>
		<svg width="20px" height="20px" viewBox="0 0 20 20" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
    <g id="Page-1" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
        <polygon id="Shape" fill="#FFFFFF" points="20 11.4285714 11.4285714 11.4285714 11.4285714 20 8.57142857 20 8.57142857 11.4285714 0 11.4285714 0 8.57142857 8.57142857 8.57142857 8.57142857 0 11.4285714 0 11.4285714 8.57142857 20 8.57142857"></polygon>
    </g>
</svg>
	</button>
</div>


<script>
	var self    = this
	groupsTag   = this
	self.filter = opts.filter

	this.on('mount', function() {
	})

	init() {
		containerTag.group = null
		API.getjoinedgroups(Parse.User.current()).then(function(joinedGroups) {
			self.joinedGroups = joinedGroups
			fortesting = joinedGroups
			API.getallgroups(null, self.filter).then(function(groups) {		//TODO Add another filter to get the groups in joinedGroups UserGroup object
				self.groups = groups.filter(function(group) {
					for (var i = 0; i < self.joinedGroups.length; i++)
						if (group.id == self.joinedGroups[i].get('group').id) return false
					return true
				})

				self.tags.groupsmap.update({joinedGroups: self.joinedGroups, groups: self.groups})
				self.tags.groupsmap.trigger('groupsUpdated')
				self.tags.groupslist.update({joinedGroups: self.joinedGroups, groups: self.groups})
				self.tags.groupslist.createSwiper()
				self.update()
			})
		})
	}

	sortGroupsByDistance() {
		if (self.groups) {
			self.groups.sort(API.comparedistance)
			self.update()
		}
	}

	showCreateModal() {
		$('#creategroupModal').modal('show')
	}

</script>
<style scoped>
	.groups-container {
		margin-top: 20px;
	}

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

	.nearby li:last-child .info-box{
    	border: none;
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