# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

martijn = User.new name: 'Martijn Bolhuis', email: 'martijn.bolhuis@gmail.com', password: '123456', password_confirmation: '123456', global_role: 'admin'
martijn.skip_confirmation!
martijn.save!

wouter = User.new name: 'Wouter Kooij', email: 'wjkooij87@gmail.com', password: '123456', password_confirmation: '123456', global_role: 'admin'
wouter.skip_confirmation!
wouter.save!

daniel = User.new name: 'Daniel Moscoviter', email: 'daniel.moscoviter@gmail.com', password: '123456', password_confirmation: '123456', global_role: 'admin'
daniel.skip_confirmation!
daniel.save!

xiao = User.new name: 'Xiao Hao Ye', email: 'xeres_xhy@hotmail.com', password: '123456', password_confirmation: '123456', global_role: 'admin'
xiao.skip_confirmation!
xiao.save!

deepshit = Community.new name: 'Deepshit', subdomain: 'deepshit', max_users: 100

deepshit.community_users.build role: 'admin', user: martijn
deepshit.community_users.build role: 'admin', user: daniel
deepshit.community_users.build role: 'admin', user: xiao
deepshit.community_users.build role: 'admin', user: wouter

deepshit.save!