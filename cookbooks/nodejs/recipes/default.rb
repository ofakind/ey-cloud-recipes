#
# Cookbook Name:: nodejs
# Recipe:: default
#
# Build and install node.js
#

if ['app','app_master','solo'].include?(node[:instance_role])
  version_tag     = "v0.4.8"
  source_base_dir = "/data/nodejs"
  source_dir      = "#{source_base_dir}/#{version_tag}"
  install_dir     = "/usr/local/bin"

  ey_cloud_report "node.js" do
    message "Setting up node.js"
  end

  ey_cloud_report "nodejs" do
    message "configuring nodejs #{version_tag}"
  end

  directory "#{source_base_dir}" do
    owner 'root'
    group 'root'
    mode 0755
    recursive true
  end

  # download nodejs source and checkout specific version
  execute "fetch nodejs from GitHub" do
    command "git clone https://github.com/joyent/node.git #{source_dir} && cd #{source_dir} && git checkout #{version_tag}"
    not_if { FileTest.exists?(source_dir) }
  end

  # compile nodejs
  execute "configure nodejs" do
    command "cd #{source_dir} && ./configure"
    not_if { FileTest.exists?("#{source_dir}/node") }
  end
  execute "build nodejs" do
    command "cd #{source_dir} && make"
    not_if { FileTest.exists?("#{source_dir}/node") }
  end
  execute "symlink nodejs" do
    command "ln -s #{source_dir}/node #{install_dir}"
    not_if { FileTest.exists?("#{install_dir}/node") }
  end
end#
