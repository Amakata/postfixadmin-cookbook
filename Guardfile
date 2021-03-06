# encoding: UTF-8
# -*- mode: ruby -*-
# vi: set ft=ruby :

# More info at https://github.com/guard/guard#readme

# Style Tests
# ===========
# - Foodcritic
# - RuboCop

group :style,
      halt_on_fail: true do

  guard :foodcritic,
        cli: '--exclude spec',
        cookbook_paths: '.',
        all_on_start: false do
    watch(/attributes\/.+\.rb$/)
    watch(/definitions\/.+\.rb$/)
    watch(/libraries\/.+\.rb$/)
    watch(/providers\/.+\.rb$/)
    watch(/recipes\/.+\.rb$/)
    watch(/resources\/.+\.rb$/)
    watch(/templates\/.+\.erb$/)
    watch('metadata.rb')
  end

  guard :rubocop,
        all_on_start: false do
    watch(/.+\.rb$/)
    watch('Gemfile')
    watch('Rakefile')
    watch('Capfile')
    watch('Guardfile')
    watch('Podfile')
    watch('Thorfile')
    watch('Vagrantfile')
  end

end # group style

# Unit Tests
# ==========
# - spec/unit/${library}_spec.rb: Unit tests for libraries.
# - spec/functional/${library}_spec.rb: Functional tests for libraries.
# - spec/integration/${library}_spec.rb: Integration tests for libraries.
# - spec/recipes/${recipe}_spec.rb: ChefSpec tests for recipes.
# - spec/resources/${resource}_spec.rb: ChefSpec tests for resources.

group :unit do

  guard :rspec,
        cmd: 'bundle exec rspec',
        all_on_start: false do
    watch(/^libraries\/(.+)\.rb$/) do |m|
      [
        "spec/unit/#{m[1]}_spec.rb",
        "spec/functional/#{m[1]}_spec.rb",
        "spec/integration/#{m[1]}_spec.rb"
      ]
    end
    watch(/^recipes\/(.+)\.rb$/) { |m| "spec/recipes/#{m[1]}_spec.rb" }
    watch(/^(?:providers|resources)\/(.+)\.rb$/) do |m|
      "spec/resources/#{m[1]}_spec.rb"
    end
    watch(/^spec\/.+_spec\.rb$/)
    watch('spec/spec_helper.rb') { 'spec' }
  end

end # group unit

# Integration Tests
# =================
# - test-kitchen

group :integration do

  guard 'kitchen',
        all_on_start: false do
    watch(/attributes\/.+\.rb$/)
    watch(/definitions\/.+\.rb$/)
    watch(/libraries\/.+\.rb$/)
    watch(/providers\/.+\.rb$/)
    watch(/recipes\/.+\.rb$/)
    watch(/resources\/.+\.rb$/)
    watch(/files\/.+/)
    watch(/templates\/.+\.erb$/)
    watch('metadata.rb')
    watch(/test\/.+$/)
    watch('Berksfile')
  end

end # group integration

scope groups: [:style, :unit]
