require('pry')
require_relative('models/property_sale')

sale1 = Property.new({
'address' => "Royal Mile",
'value' => 100000,
'number_of_bedrooms' => 2,
'build' => "flat"
})

sale2 = Property.new({
'address' => "Haymarket",
'value' => 750000,
'number_of_bedrooms' => 1,
'build' => "flat"
})

Property.delete_all()

sale1.save()
sale2.save()

binding.pry
nil
