require 'shellwords'
require 'travis/build/addons/base'

module Travis
  module Build
    class Addons
      class MssqlServer < Base
        SUPER_USER_SAFE = true

        def after_prepare
          sh.if '"$TRAVIS_OS_NAME" != linux' do
            sh.echo "Addon MssqlServer is not supported on #{data[:config][:os]}", ansi: :red
          end
          sh.else do
            sh.fold 'mssql_server' do
              sh.raw bash('travis_setup_mssql_server'), echo: false, timing: false
              sh.cmd "travis_setup_mssql_server #{version}", echo: true, timing: true
            end
          end
        end

        private

          def version
            config.to_s.shellescape
          end
      end
    end
  end
end
