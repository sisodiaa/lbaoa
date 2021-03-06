# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Post.delete_all
Category.delete_all

Category.create!(
  title: 'Horticulture',
  description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit'
)
Category.create!(
  title: 'Housekeeping',
  description: 'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua'
)
security = Category.create!(
  title: 'Security',
  description: 'Ut enim ad minim veniam, quis nostrud exercitation ullamco'
)
Category.create!(
  title: 'Technical',
  description: 'Laboris nisi ut aliquip ex ea commodo consequat'
)
helpdesk = Category.create!(
  title: 'Helpdesk',
  description: 'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum'
)

security.posts.create!([
  { title: 'Installing boom barriers' },
  { title: 'More guards in night' }
])
helpdesk.posts.create!([
  { title: 'Launching COVID helpline' },
  { title: 'Installing sanitizer dispenser and wash basins for staff' }
])
