# inputs:
# - str
# outputs:
# - str
# reqs:
# - take a str, w/ words sep'd by 1+ spaces, terminated by a pt
# - output the str, w/ words sep'd by exactly 1 space (w/ odd numbered words
#   reversed), terminated by a period
# rules:
# - none
# struct:
# - arr (to hold words)
# algo:
# - remove leading whitespace from the str
# - split the str into an arr of words
#   - split on one or more spaces OR a period
# - for each word at a given arr ndx
#   - if the ndx is odd
#     - reverse the word
#   - map the word back to the arr
# - join the arr elems (sep'd by a space) to form a new str
# - add a pt to the end of the new_str
# - output the new_str

def reverse_odd_words(str)
  str.gsub!(/^\s+/, "")
  arr = str.split(/ +|\./)
  arr.map.with_index do |word, ndx|
    ndx.odd? ? word.reverse : word
  end.join(' ') + '.'
end

p reverse_odd_words("whats the matter with kansas")
p reverse_odd_words("whats   the matter with kansas .")
p reverse_odd_words("")
p reverse_odd_words(".")
p reverse_odd_words("what")
p reverse_odd_words("   what the ? .  ")
