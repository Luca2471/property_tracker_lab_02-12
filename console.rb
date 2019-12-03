require('pry')
require_relative('models/property_sale')

sale1 = Property.new({
'address' => "Royal Mile",
'value' => 100000,
'number_of_bedrooms' => 2,
'build' => "flat"
})

binding.pry
nil
