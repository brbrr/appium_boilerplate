# This file encapsulates our approach to tagging RSpec tests
# In order to ensure a consistent approach to test tagging,
module TagHelper
  XFAIL = { fail: true }
  SMOKE = { smoke: true }
  FRAGILE = { fragile: true }
  FEES = { fees: true }
end

# This is the magic method that applies tags
# It takes a variable number of strings
# and for each string, applies a relevant tag
# raising an error if the string matches no known pattern for any tag
def tag(*tag_args)
  tag_hash = {}
  tag_args.each do |tag|
    # is it a constant in KnewtonCustomTags ?
    if (tag =~ /^\w+$/) && TagHelper.const_defined?(tag.upcase)
      tag_hash.merge! TagHelper.const_get(tag.upcase)

    else
      fail "Unrecognized tag: #{tag}"
    end
  end

  tag_hash
end
