case xvfb_systype
when 'systemd'
  path = '/etc/systemd/system/xvfb.service'
  src = 'systemd.erb'
when 'upstart'
  path = '/etc/init/xvfb.conf'
  src = 'upstart.erb'
else
  path = '/etc/init.d/xvfb'
  src = 'sysvinit.erb'
end

template path do
  source src
  mode '0755'
  variables(
    user: node['xvfb']['user'],
    display: node['xvfb']['display'],
    screennum: node['xvfb']['screennum'],
    dimensions: node['xvfb']['dimensions'],
    args: node['xvfb']['args']
  )
end

execute 'update' do
  action :nothing
  subscribes :run, "template[#{path}]", :immediately

  only_if { xvfb_systype == 'systemd' }
  command 'systemctl daemon-reload'
end

service 'xvfb' do
  subscribes :restart, "template[#{path}]", :immediately
  action %i(enable start)
end
