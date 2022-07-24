local _ran = false

function DefaultData()
    if _ran then Startup() return end

    _ran = true
    local Default = exports['bs_base']:FetchComponent('Default')
    Default:Add('phone_apps', 1593902220, {
        {
            name = 'phone',
			storeLabel = 'Phone',
			label = 'Phone',
			icon = 'phone',
			color = '#21a500',
			params = '',
			internal = {
				{
					app = 'call',
					params = ':number?',
				}
            },
            canUninstall = false,
            store = true,
            requirements = {}
		},
		{
            name = 'messages',
			storeLabel = 'Messages',
			label = 'Messages',
			icon = 'comment-alt',
			color = '#ff0000',
			params = '',
			internal = {
				{
					app = 'new',
				},
				{
					app = 'convo',
					params = ':number?',
				},
			},
			canUninstall = false,
            store = true,
            requirements = {}
		},
		{
            name = 'contacts',
			storeLabel = 'Contacts',
			label = 'Contacts',
			icon = 'address-book',
			color = '#ff6a00',
			params = '',
			internal = {
				{
					app = 'add',
					params = ':number?',
				},
				{
					app = 'edit',
					params = ':id?',
				},
			},
			canUninstall = false,
            store = true,
            requirements = {}
		},
		{
            name = 'store',
			storeLabel = 'Blue Sky App Store',
			label = 'App Store',
			icon = 'cloud-download-alt',
			color = '#1a7cc1',
			params = '',
			canUninstall = false,
            store = true,
            requirements = {}
		},
		{
            name = 'settings',
			storeLabel = 'Settings',
			label = 'Settings',
			icon = 'cog',
			color = '#18191e',
			params = '',
			internal = {
				{
					app = 'software',
					params = '',
				},
				{
					app = 'profile',
					params = '',
				},
				{
					app = 'app_notifs',
					params = '',
				},
				{
					app = 'sounds',
					params = '',
				},
				{
					app = 'wallpaper',
					params = '',
				},
				{
					app = 'colors',
					params = '',
				},
			},
			canUninstall = false,
            store = true,
            requirements = {}
		},
		{
            name = 'email',
			storeLabel = 'Email',
			label = 'Email',
			icon = 'envelope',
			color = '#5600a5',
			params = '',
			internal = {
				{
					app = 'view',
					params = ':id?',
				},
			},
			canUninstall = false,
            store = true,
            requirements = {}
		},
		{
            name = 'bank',
			storeLabel = 'Bank',
			label = 'Bank',
			icon = 'university',
			color = '#ff0000',
			params = '',
			canUninstall = true,
            store = true,
            requirements = {}
		},
		{
            name = 'twitter',
			storeLabel = 'Twitter',
			label = 'Twitter',
			icon = {'fab', 'twitter'},
			color = '#00aced',
			params = '',
			canUninstall = true,
            store = true,
            requirements = {}
		},
		{
            name = 'irc',
			storeLabel = 'IRC',
			label = 'IRC',
			icon = 'comment-slash',
			color = '#1de9b6',
			params = '',
			canUninstall = true,
            store = true,
            requirements = {}
		},
		{
            name = 'adverts',
			storeLabel = 'Yellow Pages',
			label = 'YP',
			icon = 'ad',
			color = '#f9a825',
			params = '',
			internal = {
				{
					app = 'view',
					params = ':id'
				},
				{
					app = 'category-view',
					params = ':category'
				},
				{
					app = 'add',
					params = ''
				},
				{
					app = 'edit',
					params = ''
				},
			},
			canUninstall = true,
            store = true,
            requirements = {}
		}
    })

    Startup()
end