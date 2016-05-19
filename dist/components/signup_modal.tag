<signup>

<!-- Modal -->
<div id="signupModal" class="modal fade" role="dialog">
	<div class="modal-dialog">

		<!-- Modal content -->
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">&times;</button>
				<h4 class="modal-title">Join Sophus!</h4>
			</div>

			<div class="modal-body">
				Email: <input type="text" name="email" /> <br/>
				Password: <input type="password" name="password"/> <br/>
				Fullname: <input type="text" name="fullname"/> <br/>
				<div name="submit" onclick="{ this.submitSignup }">Submit</div>
				<div if={ isError }>{ error }</div>
			</div>

			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
			</div>
		</div>

	</div>
</div>

<script>
	var self     = this
	self.isError = false
	self.error   = ""

	this.on('mount', function(){
		$('#signupModal').on('show.bs.modal', function() {
	    	self.track()
		})
	})

	submitSignup(){
		if (self.checkValidity())
			self.showError(self.checkValidity())
		else {
			var user          = Parse.User.current()
			var userEmail     = self.email.value
			var userPassword  = self.password.value
			var userFullname  = self.fullname.value

			var userFirstname = userFullname.split(" ")[0]
			var userLastname  = userFullname.substring(userFullname.indexOf(" "))

			user.set('username', userEmail)
			user.set('password', userPassword)
			user.set('email', userEmail)
			user.set('firstName', userFirstname)
			user.set('lastName', userLastname)
			user.save(null, {
				success: function(user) {
					$('#signupModal').modal('hide')
				},
				error: function(user, error) {
					self.isError = true
					self.error   = error.message
					self.update()
				}
			})
		}
	}

	checkValidity() {
		if (!self.validateEmail(self.email.value)) return 1
		if (self.password.value.length < 6) return 2
		if (self.password.value.length > 32) return 2
		if (self.fullname.value.length < 1) return 3
		return 0
	}

	validateEmail(email) {
    	var re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    	return re.test(email);
	}

	showError(errorCode) {
		self.isError = true
		switch(errorCode) {
			case 1:
				self.error = "Email is not valid. Please enter a valid email"
				break
			case 2:
				self.error = "Password should be from 6 to 32 characters of length"
				break
			case 3:
				self.error = "Fullname cannot be empty"
				break
			default:
				self.isError = false
				self.error   = ""
				break
		}

		self.update()
	}

</script>

<style scoped>
:scope{
	text-align: center;
}

</style>

</signup>