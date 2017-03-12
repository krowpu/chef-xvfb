user 'xvfb' do
  name = node['xvfb']['user']

  only_if { !!name }

  username name
  system true
  shell '/bin/false'
end
