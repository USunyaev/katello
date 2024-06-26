require 'katello_test_helper'
require 'support/pulp3_support'

module Katello
  module Service
    module Pulp3
      class DebTest < ActiveSupport::TestCase
        include Katello::Pulp3Support

        def setup
          @primary = SmartProxy.pulp_primary
          @repo = katello_repositories(:debian_pulp_ragnarok)
          ensure_creatable(@repo, @primary)
          create_repo(@repo, @primary)
          @repo.reload
        end

        def teardown
          ensure_creatable(@repo, @primary)
        end

        def test_index_model
          Katello::Deb.destroy_all
          sync_args = {:smart_proxy_id => @primary.id, :repo_id => @repo.id}
          ForemanTasks.sync_task(::Actions::Pulp3::Orchestration::Repository::Sync, @repo, @primary, sync_args)
          @repo.reload
          @repo.index_content
          post_unit_count = Katello::Deb.all.count
          post_unit_repository_count = Katello::RepositoryDeb.where(:repository_id => @repo.id).count

          assert_equal post_unit_count, 3
          assert_equal post_unit_repository_count, 3
        end

        def test_index_on_sync
          Katello::Deb.destroy_all
          sync_args = {:smart_proxy_id => @primary.id, :repo_id => @repo.id}
          ForemanTasks.sync_task(::Actions::Pulp3::Orchestration::Repository::Sync, @repo, @primary, sync_args)
          index_args = {:id => @repo.id, :contents_changed => true}
          ForemanTasks.sync_task(::Actions::Katello::Repository::IndexContent, index_args)
          @repo.reload
          post_unit_count = Katello::Deb.all.count
          post_unit_repository_count = Katello::RepositoryDeb.where(:repository_id => @repo.id).count

          assert_equal post_unit_count, 3
          assert_equal post_unit_repository_count, 3
        end
      end
    end
  end
end
