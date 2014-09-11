# encoding: UTF-8

def whyrun_supported?
  true
end

def address
  new_resource.address
end

def goto
  new_resource.goto
end

def active
  new_resource.active
end

def login_username
  new_resource.login_username
end

def login_password
  new_resource.login_password
end

def db_type
  new_resource.db_type(
    if new_resource.db_type.nil?
      node['postfixadmin']['database']['type']
    else
      new_resource.db_type
    end
  )
end

def db_user
  new_resource.db_user(
    if new_resource.db_user.nil?
      node['postfixadmin']['database']['user']
    else
      new_resource.db_user
    end
  )
end

def db_password
  new_resource.db_password(
    if new_resource.db_password.nil?
      node['postfixadmin']['database']['password']
    else
      new_resource.db_password
    end
  )
end

def default_db_port
  case db_type
  when 'mysql'
    node['mysql']['port']
  when 'postgresql'
    node['postgresql']['config']['port']
  else
    fail "Port for \"#{db_type}\" type not known."
  end
end

def db_port
  new_resource.db_port(
    if new_resource.db_port.nil?
      default_db_port
    else
      new_resource.db_port
    end
  )
end

def db_name
  new_resource.db_name(
    if new_resource.db_name.nil?
      node['postfixadmin']['database']['name']
    else
      new_resource.db_name
    end
  )
end

def db_host
  new_resource.db_host(
    if new_resource.db_host.nil?
      node['postfixadmin']['database']['host']
    else
      new_resource.db_host
    end
  )
end

def ssl
  new_resource.ssl(
    if new_resource.ssl.nil?
      node['postfixadmin']['ssl']
    else
      new_resource.ssl
    end
  )
end

action :create do
  username, domain = address.split('@', 2)
  if domain.nil?
    fail Chef::Exceptions::ArgumentError,
         'Could not get the domain name from the address argument, it should '\
         'have the following format: user@domain.tld'
  end
  db = PostfixAdmin::DB.new(
    type: db_type, user: db_user, password: db_password, dbname: db_name,
    host: db_host, port: db_port
  )
  next if db.alias_exist?(address)
  converge_by("Create #{new_resource}") do
    ruby_block "create alias #{address}" do
      block do
        api = PostfixAdmin::API.new(ssl, login_username, login_password)
        result = api.create_alias(username, domain, goto, active)
        Chef::Log.info("Created #{new_resource}: #{result}")
      end
      action :create
    end
  end
end
