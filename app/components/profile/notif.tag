<notif>

<div class="outer-container">

	<div class="notif-list">
		<div class="notif" each={ notification in notifications } onclick={ gotoGroup(notification.group) }>
			{notification.count} new post<span if={notification.count!=1}>s</span> in <b>{notification.group.get('name')}</b>
		</div>
	</div>

</div>

<script>
	var self           = this
	notificationTag    = this
	self.rawNotifications = []
	self.notifications = []

	this.on('mount', function() {
	})

	init() {
		var Notifications = Parse.Object.extend('Notifications')
		var query = new Parse.Query(Notifications)
		query.equalTo('pushedTo', Parse.User.current())
		query.equalTo('seen', false)
		query.include('post')

		query.find().then(function(results) {
			self.rawNotifications = results

			var mapCount = new Map()
			for (var i = 0; i < results.length; i++) {
				if (!mapCount.get(results[i].get('post').get('group').id)) mapCount.set(results[i].get('post').get('group').id, 1)
				else mapCount.set(results[i].get('post').get('group').id, mapCount.get(results[i].get('post').get('group').id) + 1)
			}

			self.notifications = []
			mapCount.forEach(function(value, key) {
				API.fetchOne('Group', 'objectId', key).then(function(result) {
					self.notifications.push({group: result, count: value})
					if (self.notifications.length == mapCount.size) self.update()
				})
			})
		})
	}

	gotoGroup(group) {
		return function() {
			riot.route(group.get('groupId'))
			riot.update()

			for (var i = 0; i < self.rawNotifications.length; i++) {
				if (self.rawNotifications[i].get('post').get('group').id == group.id) {
					var notif = self.rawNotifications[i]
					notif.set('seen', true)
					notif.save()
				}
			}
		}
	}
</script>

<style scoped></style>
</notif>