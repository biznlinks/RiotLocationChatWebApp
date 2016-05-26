<postbar>

<div class="input-group search-container">
	<div class="icon-container input-group-addon pointer"><img src={ API.getCurrentUserProfilePicture() } class="profile-icon img-circle"></div>
	<textarea name="postBar" id="searchField" onfocus={ showAskModal } placeholder="Post on ICTD 2016" class="searchbox form-control" rows="1" onfocus={this.searchonfocus}></textarea>
</div>

<script>
	var self = this
	self.anonymous = false

	showAskModal() {
		self.parent.parent.tags.askModal.show()
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
	#searchField{
        overflow:hidden;
        resize: none;
        text-align: left;
        min-height: 45px!important;
        margin-bottom: 0;
        width: 100%;
        height: 62px;
        font-size: 24px;
        padding: 0 15px;
        line-height: 62px;
        border: 1px solid #CCCCCC;
        border-left: 0;
      }

      .search-container {
        margin-bottom: 15px;
      }

      .input-group {
        width: 100%;
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