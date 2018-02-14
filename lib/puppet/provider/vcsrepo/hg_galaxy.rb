begin
  require 'puppet/provider/vcsrepo/hg'
rescue LoadError
  require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', '..', '..', 'vcsrepo', 'lib',
                           'puppet', 'provider', 'vcsrepo', 'hg.rb'))
end

Puppet::Type.type(:vcsrepo).provide(:hg_galaxy,
                                    :parent => Puppet::Type.type(:vcsrepo).provider(:hg)) do
  def revision
    at_path do
      begin
        hg_wrapper('pull', { :remote => true })
      rescue
      end

      current = hg_wrapper('parents')[/^changeset:\s+(?:-?\d+):(\S+)/m, 1]
      desired = resource[:revision]
      if desired
        if current == hg_wrapper('tags')[/^#{Regexp.quote(desired)}\s+\d+:(\S+)/m, 1]
          # Return the tag name if it maps to the current nodeid
          desired
        elsif current == branch_tip(desired)
          # If desired is a branch, see if it matches current nodeid
          desired
        else
          current
        end
      else
        current
      end
    end
  end

  def revision=(desired)
    at_path do
      # skip pull (already done in revision)
      begin
        hg_wrapper('merge')
      rescue Puppet::ExecutionFailure
        # If there's nothing to merge, just skip
      end
      hg_wrapper('update', '--clean', '-r', desired)
    end
    update_owner
  end

  private

  def branch_tip(branch)
      begin
        hg_wrapper('log', '-r', branch)[/^changeset:\s+(?:-?\d+):(\S+)/m, 1]
      rescue Puppet::ExecutionFailure
        # not a branch, skip
        nil
      end
  end
end
