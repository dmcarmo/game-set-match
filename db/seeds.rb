User.destroy_all

user_1 = User.create(name: "john", email: "john@email.com", password: "12345678")
user_2 = User.create(name: "martin", email: "martin@email.com", password: "12345678")
user_3 = User.create(name: "sarah", email: "sarah@email.com", password: "12345678")

group_1 = Group.create(name: "gamezzz", owner: user_1)
group_1.memberships.create(user: user_1)
