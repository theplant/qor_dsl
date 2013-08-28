env '1.9+' do
  ruby ['1.9.3', '2.0']
end

env '1.8.7' do
  ruby '1.8.7'
  gem 'minitest', '4.3'
end
