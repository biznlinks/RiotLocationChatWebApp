OptsMixin = {
    track: function(arg, arg2) {
        console.log("Tracking " + arg + " " + arg2);
    	arg = arg || 'default';
    	arg2 = arg2 || 'Sophus';
    	var tagName = this.root.tagName;
    	fbq('trackCustom', tagName , {"action": arg});
    	ga('send', {
		  "hitType": 'event',
		  "eventCategory": tagName,
		  "eventAction": arg,
		  "eventLabel": arg2,
		});

        document.title = arg2 ;
  }
}