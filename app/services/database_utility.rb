class DatabaseUtility

  def self.create(name)
    Apartment::Database.create(name)
  end

  def self.switch(db=nil)
    Apartment::Database.switch(db)
  end

  def self.current
    Apartment::Database.current_database
  end

  def self.list
    Apartment::Database.list
  end

  def self.exists?(db)
    Apartment::Database.exists?(db)
  end
end
