// // chi
            // Parse.initialize("NV3PXWz0D6qx90BI1aiWKY1gR8IJ2aBS07jeN566", "QHfiiv5CQkTVNH9Bpj3iMntZJ2ze3L8veDlj912R");
  
 // ictd
 // Parse.initialize("03XBJy9KH27oXnjBDsV7noOSJ4wHTkbRd78XCODg", "Gi8T8CK2XULruSKx71LyY9PHtptBUJk6Jz0ktH1S");

 // ictd-devo
 Parse.initialize("YDTZ5PlTlCy5pkxIUSd2S0RWareDqoaSqbnmNX11", "1KFxPXKErTsVAe5Zu9Gx5SDS40qNV6WxmVQ5gUuB");

 var Post = Parse.Object.extend('Post');
 var Topic = Parse.Object.extend('Topic');


 riot.mixin(OptsMixin)

 riot.compile(function() {

  riot.route.base('/')
  riot.mount('*')
  riot.route.start(true)
})



 lizards = [["Snake", "http://science-all.com/images/snake/snake-08.jpg"], ["Gecko", "http://farm8.staticflickr.com/7498/26679684130_245d9ea1fb_b.jpg"], ["Lizard", "http://farm8.staticflickr.com/7705/26924840426_404bbc8bb2_b.jpg"], ["Ground", "http://farm8.staticflickr.com/7682/26353918663_319904eba8_b.jpg"], ["Forest", "http://farm8.staticflickr.com/7517/26958490925_6903bdddf8_b.jpg"], ["Turtle", "http://farm8.staticflickr.com/7184/26683922170_b1a4db6dc4_b.jpg"],  ["Western", "http://farm8.staticflickr.com/7294/26352550924_15854bd46b_b.jpg"], ["Green", "http://farm8.staticflickr.com/7069/26354009763_b15f130e6c_b.jpg"], ["Mountain", "http://farm8.staticflickr.com/7533/26684881650_4e676896d9_b.jpg"], ["Iguana", "http://farm8.staticflickr.com/7623/26922202176_d1354e2a3f_b.jpg"], ["Water", "http://farm8.staticflickr.com/7296/26684949360_8dd7ef5aac_b.jpg"], ["Spotted", "http://farm8.staticflickr.com/7012/26957368925_772799e4fe_b.jpg"], ["Coral", "http://farm8.staticflickr.com/7063/26889006461_4a225dbc68_b.jpg"], ["Island", "http://farm8.staticflickr.com/7009/26864010482_03de9e01b3_b.jpg"], ["Leaf-toed", "http://farm2.staticflickr.com/1573/24039491944_2f75628a35_b.jpg"], ["Southern", "http://farm8.staticflickr.com/7324/26352185784_499339310d_b.jpg"], ["Eastern", "http://farm8.staticflickr.com/7112/26352226113_dbc3210ce3_b.jpg"], ["Spiny", "http://farm8.staticflickr.com/7366/26349224093_fb13888dae_b.jpg"], ["Striped", "http://farm8.staticflickr.com/7166/26828358531_3125218b5b_b.jpg"], ["Agama", "http://farm8.staticflickr.com/7338/26349274524_e05c9b38bc_b.jpg"], ["Dragon", "http://farm8.staticflickr.com/7169/26864182802_56e46cdea9_b.jpg"], ["Viper", "http://farm2.staticflickr.com/1581/26120302431_872a28ecf2_b.jpg"], ["Racer", "http://farm8.staticflickr.com/7531/26350606803_d88baeeb6c_b.jpg"], ["Keelback", "http://farm8.staticflickr.com/7451/26949094415_6aaf534a83_b.jpg"]];

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

    user.set("lastName", lizard[0])
    user.set("profileImageURL", lizard[1])

    user.save()

  },
  error: function(user, error) {
    console.log("erron in creating a new user");
  }
});