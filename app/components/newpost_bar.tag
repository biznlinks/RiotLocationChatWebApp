<postbar>

<div class="input-group search-container">
	<div class="icon-container input-group-addon pointer"><img src={ API.getCurrentUserProfilePicture() } class="profile-icon img-circle"></div>
	<div name="postBar" id="postBar" onclick={ showAskModal } class="text-muted form-control">What's happenning?</div>
</div>

<script>
	var self = this
	self.anonymous = false

  showAskModal() {
		$('#askModal').modal('show')
	}

	getUserProfilePic() {
		if (self.anonymous && Parse.User.current().get('type') == 'actual') {
			return 'https://files.parsetfss.com/135e5227-e041-4147-8248-a5eafaf852ef/tfss-6f1e964e-d7fc-4750-8ffb-43d5a76b136e-kangdo@umich.edu.png'
			self.update()
		}

		var user       = Parse.User.current()
		var profilePic = user.get('profileImageURL')
		if (profilePic){
			return profilePic
			self.update()
		}
	}
</script>

<style scoped>
	#postBar{
        overflow:hidden;
        resize: none;
        text-align: left;
        min-height: 45px!important;
        margin-bottom: 0;
        width: 100%;
        height: 62px;
        font-size: 20px;
        padding: 0 15px;
        line-height: 62px;
        border: none;
      }

      .search-container {
        margin-bottom: 15px;
      }

      .input-group {
        width: 100%;
      }
      .input-group-addon{
        border: none;
      }

      .icon-container {
        height: 62px;
        width: 62px;
        background-color: white;
        border-right: 0;
      }

      .profile-icon {
        height: 35px;
        width: 35px;
      }
</style>

</postbar>