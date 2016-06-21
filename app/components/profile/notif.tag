<notif>

<div class="outer-container">

	<div class="notif-list">
		<div class="not-seen">
			<div class="notif" each={ notification in notSeens } onclick={ gotoGroup(notification.group) }>
				<img class="group-pic" src={ API.getGroupImage(notification.group) }>
				<span if={ notification.count > 1 }>
					{notification.count} new posts in <b>{notification.group.get('name')}</b>
				</span>
				<span if={notification.count == 1}>
					<b>{notification.from.get('firstName')}</b> posted in <b>{notification.group.get('name')}</b>: "{ notification.post.get('content').slice(0,25) } <span if={notification.post.get('content').length > 25}>...</span>"
				</span>
			</div>
		</div>
		<div class="seen">
			<div class="notif" each={ notification in seens } onclick={ gotoGroup(notification.group) }>
				<img class="group-pic" src={ API.getGroupImage(notification.group) }>
				<span if={ notification.count > 1 }>
					{notification.count} new posts in <b>{notification.group.get('name')}</b>
				</span>
				<span if={notification.count == 1}>
					<b>{notification.from.get('firstName')}</b> posted in <b>{notification.group.get('name')}</b>: "{ notification.post.get('content').slice(0,25) } <span if={notification.post.get('content').length > 25}>...</span>"
				</span>
			</div>
		</div>
	</div>

</div>

<script>
	var self              = this
	notificationTag       = this
	self.rawNotifications = []
	self.notSeens         = []
	self.seens            = []

	this.on('mount', function() {
	})

	init() {
		var Notifications = Parse.Object.extend('Notifications')

		var notseenQuery = new Parse.Query(Notifications)
		notseenQuery.equalTo('pushedTo', Parse.User.current())
		notseenQuery.equalTo('seen', false)
		notseenQuery.include('post')
		notseenQuery.include('post.group')
		notseenQuery.include('pushedFrom')
		notseenQuery.find().then(function(results) {
			var mapCount = new Map()
			for (var i = 0; i < results.length; i++) {
				if (!mapCount.get(results[i].get('post').get('group').id)) {
					mapCount.set(results[i].get('post').get('group').id, {
						count: 1,
						notif: results[i]
					})
				} else {
					var value = mapCount.get(results[i].get('post').get('group').id)
					mapCount.set(results[i].get('post').get('group').id, {
						count: value.count + 1,
						notif: Date.parse(results[i].get('createdAt')) > Date.parse(value.notif.get('createdAt')) ? results[i] : value.notif
					})
				}

				results[i].save({seen: true})
			}

			self.notSeens = []
			mapCount.forEach(function(value, key) {
				self.notSeens.push({
					count: value.count,
					from: value.notif.get('pushedFrom'),
					post: value.notif.get('post'),
					group: value.notif.get('post').get('group')
				})
			})
			self.update()
		})

		var seenQuery = new Parse.Query(Notifications)
		seenQuery.equalTo('pushedTo', Parse.User.current())
		seenQuery.equalTo('seen', true)
		seenQuery.include('post')
		seenQuery.include('post.group')
		seenQuery.include('pushedFrom')
		seenQuery.limit(20)
		seenQuery.find().then(function(results) {
			self.fortesting = results
			var mapCount = new Map()
			for (var i = 0; i < results.length; i++) {
				if (!mapCount.get(results[i].get('post').get('group').id)) {
					mapCount.set(results[i].get('post').get('group').id, {
						count: 1,
						notif: results[i]
					})
				} else {
					var value = mapCount.get(results[i].get('post').get('group').id)
					mapCount.set(results[i].get('post').get('group').id, {
						count: value.count + 1,
						notif: Date.parse(results[i].get('createdAt')) > Date.parse(value.notif.get('createdAt')) ? results[i] : value.notif
					})
				}
			}

			self.seens = []
			mapCount.forEach(function(value, key) {
				self.seens.push({
					count: value.count,
					from: value.notif.get('pushedFrom'),
					post: value.notif.get('post'),
					group: value.notif.get('post').get('group')
				})
			})
			self.update()
		})
	}

	gotoGroup(group) {
		return function() {
			riot.route(group.get('groupId'))
			riot.update()
		}
	}
</script>

<style scoped>
	:scope {

	}

	.outer-container {
		padding-top: 10px;
		margin: 0 auto;
		max-width: 700px;
	}

	.notif-list {
		padding: 0 30px;
	}

	.not-seen .notif {
		background-color: #f3f3f3;
	}

	.notif {
		padding: 10px 25px;
		border-bottom: 1px dashed #bbb;
	}
	.notif:hover {
		background-color: #f8f8f8;
	}

	.group-pic {
		height: 40px;
		width: 40px;
		object-fit: cover;
		margin-right: 10px;
	}
</style>
</notif>