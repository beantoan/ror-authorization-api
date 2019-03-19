after :roles do
  User.create({email: 'admin@pms.vn', password: '123456789', name: 'Admin', nickname: 'Admin', role_id: Role.with_name(:admin).id, status: User::STATUS_ACTIVE})
end
