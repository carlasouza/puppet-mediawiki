module Puppet
	newtype(:mediawiki) do
		@doc = ""

		ensurable do
			desc "The guest's ensure field can assume one of the following values:
	`running`:
		Creates config file, and makes sure the domain is running.
	`installed`:
		Creates config file, but doesn't touch the state of the domain.
	`stopped`:
		Creates config file, and makes sure the domain is not running.
	`absent`:
		Removes config file, and makes sure the domain is not running."
		
			newvalue(:stopped) do
				provider.stop
			end
	
			newvalue(:running) do
				provider.start
			end

			newvalue(:installed) do
				provider.setpresent
			end

			newvalue(:absent) do
				provider.destroy
			end

			defaultto(:running)
			
			def retrieve
				provider.status
			end
	
		end
		
		newparam(:desc) do
			desc "The guest's description."
		end
	
		newparam(:name, :namevar => true) do
			desc "The wiki's name."
		end

		newparam(:servername) do
		end

		newparam(:serveralias) do
		end

		newparam(:admin) do
			desc "Admin's e-mail"
		end	


	end
end
