<login>

<!-- Modal -->
<div id="loginModal" class="modal fade" role="dialog">
	<div class="modal-dialog">

		<!-- Modal content -->
		<div class="modal-content">
			<div class="modal-header">
			<button type="button" class="close" data-dismiss="modal">&times;</button>
				<div class="facebook-option">
					<button class="btn btn-default btn-primary" onclick={ this.submitFacebook }>
						<i class="fa fa-facebook-f" id="facebook-logo"></i> Log in with Facebook
					</button>
				</div>
			</div>
			<div class="divider">
				<strong class="divider-title ng-binding">or</strong>
			</div>

			<div class="modal-body">
				<form>
					<div class="input-group">
						<span class="input-group-addon"><i class="fa fa-envelope-o fa-fw"></i></span>
						<input type="text" class="form-control" name="email" placeholder="Email" />
					</div>
					<div class="input-group">
						<span class="input-group-addon"><i class="fa fa-key fa-fw"></i></span>
						<input type="password" class="form-control" name="password" placeholder="Password" />
					</div>

					<br/>
					<button class="btn btn-sm" name="submit" onclick={ this.submitLogin }>Submit</button>
					<div class="text-warning info" if={ isError }>{ error }</div>
				</form>

				<div class="info">
					or
					<div class="text-info pointer inline" onclick={ this.showSignup }>Sign Up</div> |
					<div class="text-info pointer inline" onclick={ this.forgotPassword }>Reset Password</div>
				</div>

				<!-- <div class="info">
					Forgot Password?
					<div class="text-info pointer inline" name="forgotPassword" onclick={ this.forgotPassword }>Reset</div>
				</div>
				<div class="info">
					Don't have an account?
					<div class="text-info pointer inline" name="signup" onclick={ this.showSignup }>Sign Up</div>
				</div> -->
			</div>
		</div>

	</div>
</div>

<script>
	var self        = this
	loginTag        = this
	self.needSignup = opts.needSignup
	self.caller     = opts.caller
	self.isError    = false
	self.error      = ""

	this.on('mount', function(){
		$('#loginModal').on('show.bs.modal', function() {
	    	self.track()
	    	$(document).bind("touchmove", function(e){
			    e.preventDefault();
			});
		})

		$('#loginModal').on('hidden.bs.modal', function () {
			$(document).unbind('touchmove');
			self.isError        = false
			self.error          = ""
			self.email.value    = ""
			self.password.value = ""

			self.update()
		})
	})

	submitLogin() {
		var annonymous     = Parse.User.current().get('username')
		Parse.User.logOut()

		Parse.User.logIn(self.email.value, self.password.value, {
			success: function(user) {
				self.loginSuccess()
			},
			error: function(user, error) {
				Parse.User.logIn(annonymous, annonymous, {
					success: function(user) {
					},
					error: function(error) {
					}
				})
				self.isError = true
				self.error   = "Incorrect email or password"
				self.update()
			}
		})
	}

	submitFacebook() {
		Parse.User.logOut().then(function() {
			Parse.FacebookUtils.logIn('public_profile, email', {
				success: function(user) {
					if (user.existed()) {
						self.loginSuccess()
					} else {
						FB.api('/me?fields=first_name, last_name, picture, email', function(response) {
							Parse.User.current().set('firstName', response.first_name)
							Parse.User.current().set('lastName', response.last_name)
							Parse.User.current().set('email', response.email)
							Parse.User.current().set('username', response.email)
							Parse.User.current().set('profileImageURL', response.picture.data.url)
							//Parse.User.current().set('friends', response.friends.data)
							Parse.User.current().set('facebookID', response.id)
							Parse.User.current().set('type', 'actual')
							Parse.User.current().save(null, {
								success: function(user) {
									self.loginSuccess()
								},
								error: function(user, error) {
									self.isError = true
									self.error = error.message
									self.update()
								}
							})
						})
					}
				},
				error: function(user, error) {
					self.isError = true
					self.error = error.message
					self.update()
				}
			})
		})
	}

	loginSuccess() {
		$('#loginModal').modal('hide')
		if (self.needSignup) {
			self.caller.trigger('signedUp')
		} else {
			riot.route('')
		    window.location.reload()
		}
	}

	forgotPassword() {
		$('#loginModal').modal('hide')
		$('#forgotModal').modal('show')
	}

	showSignup() {
		$('body').addClass('noScroll');
		$('#loginModal').modal('hide')
		$('#signupModal').modal('show')
	}

</script>

<style scoped>
	:scope{
		text-align: center;
	}

	.noScroll {
    overflow: hidden;
    position: fixed;
	}

	.facebook-option {
		margin-top: 20px;
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

	.inline {
		display: inline-block;
	}

	.input-group {
		margin-top: 7px;
	}

	.info {
		margin-top: 20px;
		margin-bottom: 10px;
	}

	.divider {
	    border-top: 1px solid #d9dadc;
	    display: block;
	    line-height: 1px;
	    margin: 15px 0;
	    position: relative;
	    text-align: center;
	}

	.divider .divider-title {
	    background: #fff;
	    font-size: 12px;
	    letter-spacing: 1px;
	    padding: 0 20px;
	    text-transform: uppercase;
	}

	.modal-header{
		border-bottom:0px;
	}
</style>

</login>