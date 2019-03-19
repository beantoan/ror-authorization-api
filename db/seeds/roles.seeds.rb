admin = Role.create(name: 'admin', title: 'Admin', description: 'Administrator')
admin.update_role({ system: { administrator: true } })
