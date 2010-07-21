require 'test_helper'

class TreeCardTest < Test::Unit::TestCase

  context "A new TreeCard populated with data" do
    setup do 
      @vcard = TreeCard.new(vcard_data('Mark_Ericsson.vcf'))
    end

    should "unfold its lines" do
      assert_equal "REV:20090729T163338Z", @vcard.raw_data.split("\n")[15]
    end

    should "parse its data" do
      assert_equal "Mark S. Ericsson", @vcard.name
      assert_equal ["mericsson@example.com"], @vcard.emails
      assert_equal "(925) 930-6000", @vcard.phone
      assert_equal "(925) 934-5377", @vcard.fax
      assert_equal "Youngman, Ericsson & Low, LLP", @vcard.company
      assert_equal "1981 N. Broadway, Suite 300\nWalnut Creek\nCA\n94596-3841\nUnited States of America", @vcard.address
    end
  end

  context "TreeCard#unfold_lines" do
    should "unfold lines that begin with a single whitespace character" do
      data = "This is the first line\nThis is a long descrip\n tion that exists o\n\tn a long line"
      assert_equal "This is the first line\nThis is a long description that exists on a long line\n", TreeCard.unfold_lines(data)
    end

    should "not unfold if there is no real data on a line" do
      data = "This is another line\n \n"
      assert_equal "This is another line\n \n", TreeCard.unfold_lines(data)
    end

    should "not unfold more than one whitespace character" do
      data = "This is a line\n  test text"
      assert_equal "This is a line\n  test text\n", TreeCard.unfold_lines(data)
    end
  end
end
