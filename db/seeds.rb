require 'active_record'
require_relative './../app/models/user'

last_names = %w(Korhonen Virtanen Mäkinen Nieminen Mäkelä Hämäläinen Laine Heikkinen Koskinen Järvinen Lehtonen Lehtinen).freeze
first_names = %w(Sofia Anastasia Maria Anya Alina Ekaterina Aleksandr Boris Alexei Daniil Leonid Nikita Anatoly Dmitri Igor)


5000.times {
  User.create(first_name: first_names.sample, last_name: last_names.sample, age: rand(18..99))
}
