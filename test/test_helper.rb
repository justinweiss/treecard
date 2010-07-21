require 'shoulda'
require 'treecard'
require 'pathname'

class Test::Unit::TestCase

  @@my_path = Pathname.new(File.expand_path(File.dirname(__FILE__)))
  
  def vcard_data(vcard_file_name)
    File.read(@@my_path + 'data' + vcard_file_name)
  end
end
