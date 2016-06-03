<postbar>

<button class="btn mfb-component--br" name="submit" onclick={ showAskModal }><svg style="width:24px;height:24px;" viewBox="0 0 24 24">
    <path fill="#FFFFFF" d="M20.71,7.04C21.1,6.65 21.1,6 20.71,5.63L18.37,3.29C18,2.9 17.35,2.9 16.96,3.29L15.12,5.12L18.87,8.87M3,17.25V21H6.75L17.81,9.93L14.06,6.18L3,17.25Z"></path>
  </svg>
</button>
<!-- 
<div class="input-group search-container">
  <div class="icon-container input-group-addon pointer"><img src={ API.getCurrentUserProfilePicture() } class="profile-icon img-circle"></div>
  <textarea name="postBar" id="searchField" onclick={ showAskModal } placeholder="What's happening?" class="searchbox form-control" rows="1"></textarea>
</div> -->

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
  #searchField{
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

</postbar>