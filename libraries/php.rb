
module PostfixAdmin
  module PHP

    def mt_rand(min, max)
      require 'openssl'

      diff = max - min
      bytes = (diff.to_s(16).length.to_f / 2).ceil
      min + ( OpenSSL::Random.random_bytes(bytes).unpack('C' * bytes).join.to_i % diff )
    end

    def generate_setup_password_salt
      require 'digest/md5'

      salt = "#{Time.new().to_i}*#{node['fqdn']}*#{mt_rand(0, 60000)}"
      ::Digest::MD5.hexdigest(salt)
    end

    def encrypt_setup_password(password, salt)
      require 'digest/sha1'

      "#{salt}:#{::Digest::SHA1.hexdigest("#{salt}:#{password}")}"
    end

  end
end

