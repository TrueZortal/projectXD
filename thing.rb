generation_key = {
  'grass': {'grass': 4,'road': 1,'tree': 1},
  'road': {'road': 3,'grass': 3,'tree': 1},
  'tree': {'grass': 3,'tree': 1}
}

surface_pool = []
generation_key['grass'.to_sym].map do |surface, weight|
  weight.times {surface_pool << surface}
end

p surface_pool.sample

p generation_key['grass'.to_sym]
p generation_key['grass'.to_sym].size
p generation_key['grass'.to_sym][rand(generation_key['grass'.to_sym].size)]