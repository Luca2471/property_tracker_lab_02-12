require('pg')

class Property

  attr_reader :id
  attr_accessor :address, :value, :number_of_bedrooms, :build

  def initialize( options )
    @id = options['id'].to_i()if options['id']
    @address = options['address']
    @value = options['value'].to_i
    @number_of_bedrooms = options['number_of_bedrooms'].to_i
    @build = options['build']
  end

  def Property.all()
    db = PG.connect({ dbname: 'property_tracker', host: 'localhost' })
    sql = "SELECT * FROM property_sales;"
    db.prepare("all", sql)
    sales = db.exec_prepared("all")
    db.close
    return sales.map { |sales_hash| Property.new(sales_hash) }
  end

  def Property.delete_all()
    db = PG.connect({ dbname: 'property_tracker', host: 'localhost' })
    sql = "DELETE FROM property_sales;"
    db.prepare("delete_all", sql)
    db.exec_prepared("delete_all")
    db.close()
  end

  def Property.find_by_id(id)
    db = PG.connect({ dbname: 'property_tracker', host: 'localhost' })
    sql = "SELECT * FROM property_sales WHERE id = $1;"
    values = [id]
    db.prepare('find_by_id', sql)
    property_found = db.exec_prepared('find_by_id', values)
    db.close()
    return property_found.map { |id_hash| Property.new(id_hash)}
  end

  def Property.find_by_address(address)
    db = PG.connect({ dbname: 'property_tracker', host: 'localhost' })
    sql = "SELECT * FROM property_sales WHERE address = $1;"
    values = [address]
    db.prepare('find_by_address', sql)
    property_found = db.exec_prepared('find_by_address', values)
    result = property_found.map { |address_hash| Property.new(address_hash)}
    if result == []
      return nil
    end
    return result
  end

  def Property.find_by_build(build)
    db = PG.connect({ dbname: 'property_tracker', host: 'localhost' })
    sql = "SELECT * FROM property_sales WHERE build = $1;"
    values = [build]
    db.prepare('find_by_build', sql)
    property_found = db.exec_prepared('find_by_build', values)
    result = property_found.map { |build_hash| Property.new(build_hash)}
    if result == []
      return nil
    end
    return result
  end

  def save()
    db = PG.connect({ dbname: 'property_tracker', host: 'localhost' })
    sql =
    "
    INSERT INTO property_sales (
      address,
      value,
      number_of_bedrooms,
      build
      )
     VALUES ($1, $2, $3, $4) RETURNING id;
    "
    values = [@address, @value, @number_of_bedrooms, @build]
    db.prepare('save', sql)
    @id = db.exec_prepared('save', values)[0]['id'].to_i()
    db.close
  end

  def update()
    db = PG.connect({ dbname: 'property_tracker', host: 'localhost' })
    sql =
    "
    UPDATE property_sales SET (
      address,
      value,
      number_of_bedrooms,
      build
    ) = (
      $1, $2, $3, $4
    ) WHERE id = $5;
    "
    values = [@address, @value, @number_of_bedrooms, @build, @id]
    db.prepare("update", sql)
    db.exec_prepared("update", values)
    db.close()
  end

  def delete()
    db = PG.connect({ dbname: 'property_tracker', host: 'localhost' })
    sql = "DELETE FROM property_sales WHERE id = $1;"
    values = [@id]
    db.prepare('delete_one', sql)
    db.exec_prepared('delete_one', values)
    db.close()
  end

end
