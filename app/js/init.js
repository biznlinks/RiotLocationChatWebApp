// // chi
            // Parse.initialize("NV3PXWz0D6qx90BI1aiWKY1gR8IJ2aBS07jeN566", "QHfiiv5CQkTVNH9Bpj3iMntZJ2ze3L8veDlj912R");

 // ictd
 //Parse.initialize("03XBJy9KH27oXnjBDsV7noOSJ4wHTkbRd78XCODg", "Gi8T8CK2XULruSKx71LyY9PHtptBUJk6Jz0ktH1S");
 //FBAppId = '822486861133305';

 // ictd-devo
  Parse.initialize("YDTZ5PlTlCy5pkxIUSd2S0RWareDqoaSqbnmNX11", "1KFxPXKErTsVAe5Zu9Gx5SDS40qNV6WxmVQ5gUuB");
  FBAppId = '399505526886852';

 var Post = Parse.Object.extend('Post');
 var Topic = Parse.Object.extend('Topic');


 riot.mixin(OptsMixin)

 var groupName = "ICTD"
 API.fetchOne("Group", "name", groupName).then(function(group){
  Group = group
  riot.compile(function() {
    riot.route.base('/');
    riot.mount('container', {group: group});
    riot.route.start(true);
  })
})



 if (!Parse.User.current()) {
  lizards = [["Snake", "//science-all.com/images/snake/snake-08.jpg"], ["Gecko", "//farm8.staticflickr.com/7498/26679684130_245d9ea1fb_b.jpg"], ["Lizard", "//farm8.staticflickr.com/7705/26924840426_404bbc8bb2_b.jpg"], ["Ground", "//farm8.staticflickr.com/7682/26353918663_319904eba8_b.jpg"], ["Forest", "//farm8.staticflickr.com/7517/26958490925_6903bdddf8_b.jpg"], ["Turtle", "//farm8.staticflickr.com/7184/26683922170_b1a4db6dc4_b.jpg"],  ["Western", "//farm8.staticflickr.com/7294/26352550924_15854bd46b_b.jpg"], ["Green", "//farm8.staticflickr.com/7069/26354009763_b15f130e6c_b.jpg"], ["Mountain", "//farm8.staticflickr.com/7533/26684881650_4e676896d9_b.jpg"], ["Iguana", "//farm8.staticflickr.com/7623/26922202176_d1354e2a3f_b.jpg"], ["Water", "//farm8.staticflickr.com/7296/26684949360_8dd7ef5aac_b.jpg"], ["Spotted", "//farm8.staticflickr.com/7012/26957368925_772799e4fe_b.jpg"], ["Coral", "//farm8.staticflickr.com/7063/26889006461_4a225dbc68_b.jpg"], ["Island", "//farm8.staticflickr.com/7009/26864010482_03de9e01b3_b.jpg"], ["Leaf-toed", "//farm2.staticflickr.com/1573/24039491944_2f75628a35_b.jpg"], ["Southern", "//farm8.staticflickr.com/7324/26352185784_499339310d_b.jpg"], ["Eastern", "//farm8.staticflickr.com/7112/26352226113_dbc3210ce3_b.jpg"], ["Spiny", "//farm8.staticflickr.com/7366/26349224093_fb13888dae_b.jpg"], ["Striped", "//farm8.staticflickr.com/7166/26828358531_3125218b5b_b.jpg"], ["Agama", "//farm8.staticflickr.com/7338/26349274524_e05c9b38bc_b.jpg"], ["Dragon", "//farm8.staticflickr.com/7169/26864182802_56e46cdea9_b.jpg"], ["Viper", "//farm2.staticflickr.com/1581/26120302431_872a28ecf2_b.jpg"], ["Racer", "//farm8.staticflickr.com/7531/26350606803_d88baeeb6c_b.jpg"], ["Keelback", "//farm8.staticflickr.com/7451/26949094415_6aaf534a83_b.jpg"]];

  lizard = _.sample(lizards);
  var password = username = Date.now()+"@ictd.conf";

  var userACL = new Parse.ACL();
  userACL.setPublicReadAccess(true);

  Parse.User.signUp(username, password,{ ACL: userACL}, {
    success: function(user) {
      user.set("username", username);
      user.set("password", username);
      user.set("email", username);

      user.set("firstName", "Anonymous")
      user.set("type", "dummy")

      user.set("lastName", lizard[0])
      user.set("profileImageURL", lizard[1])

      user.save()

    },
    error: function(user, error) {
      console.log("erron in creating a new user");
    }
  });
}