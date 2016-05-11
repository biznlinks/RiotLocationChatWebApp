OptsMixin = {
  // init method is a special one which can initialize
  // the mixin when it's loaded to the tag and is not
  // accessible from the tag its mixed in
  // init: function() {
  //   this.on('updated', function() { console.log(this.root.tagName) })
  // },

  // getOpts: function() {
  //   return this.opts
  // },

  // setOpts: function(opts, update) {
  //   this.opts = opts
  //   if (!update) this.update()
  //   return this
  // },
    track: function(arg='default', arg2="") {
    	var tagName = this.root.tagName
    	fbq('trackCustom', tagName , {action: arg});
    	ga('send', {
		  hitType: 'event',
		  eventCategory: tagName,
		  eventAction: arg,
		  eventLabel: arg2,
		});
  }
}



