require 'test_helper'
require 'capistrano/scm/s3'

class Capistrano::Scm::S3Test < Minitest::Test
  def setup
    @subject = Capistrano::Scm::S3::Plugin.new

    @env = Capistrano::Configuration.env
    @backend = MiniTest::Mock.new



    Rake::Task.define_task("deploy:new_release_path")
    Rake::Task.define_task("deploy:check")
    Rake::Task.define_task("deploy:set_current_revision")

  end

  def teardown
    Rake::Task.clear
    Capistrano::Configuration.reset!
  end

  def test_that_it_has_a_version_number
    refute_nil ::Capistrano::Scm::S3::VERSION
  end

  def test_define_tasks
    SSHKit::Backend.stub :current, @backend do
      @backend.expect :execute, 0
      @subject.define_tasks()

      assert Rake::Task.task_defined?("scm:s3:create_release")
      assert Rake::Task.task_defined?("scm:s3:set_current_revision")
    end
  end

  def test_register_hooks
    SSHKit::Backend.stub :current, @backend do
      @subject.define_tasks()
      @subject.register_hooks()

      #puts Rake::Task["scm:none:create_release"].inspect
      #puts Rake::Task.tasks
      # TODO find out how to check the before / after
    end
  end
end
