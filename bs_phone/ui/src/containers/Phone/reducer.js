import Nui from '../../util/Nui';

export const initialState = {
	visible: true,
	clear: false,
	expanded: true,
	apps: {
		phone: {
			storeLabel: 'Phone',
			label: 'Phone',
			icon: 'phone',
			name: 'phone',
			color: '#21a500',
			canUninstall: false,
			params: '',
			internal: [
				{
					app: 'call',
					params: ':number?',
				}
			]
		},
		messages: {
			storeLabel: 'Messages',
			label: 'Messages',
			icon: 'comment-alt',
			name: 'messages',
			color: '#ff0000',
			canUninstall: false,
			params: '',
			internal: [
				{
					app: 'new',
				},
				{
					app: 'convo',
					params: ':number?',
				},
			],
		},
		contacts: {
			storeLabel: 'Contacts',
			label: 'Contacts',
			icon: 'address-book',
			name: 'contacts',
			color: '#ff6a00',
			canUninstall: false,
			params: '',
			internal: [
				{
					app: 'add',
					params: ':number?',
				},
				{
					app: 'edit',
					params: ':id?',
				},
			],
		},
		store: {
			storeLabel: 'Blue Sky App Store',
			label: 'App Store',
			icon: 'cloud-download-alt',
			name: 'store',
			color: '#1a7cc1',
			canUninstall: false,
			params: ''
		},
		settings: {
			storeLabel: 'Settings',
			label: 'Settings',
			icon: 'cog',
			name: 'settings',
			color: '#18191e',
			canUninstall: false,
			params: '',
			internal: [
				{
					app: 'software',
					params: ''
				},
				{
					app: 'profile',
					params: ''
				},
				{
					app: 'app_notifs',
					params: '',
				},
				{
					app: 'sounds',
					params: '',
				},
				{
					app: 'wallpaper',
					params: '',
				},
				{
					app: 'colors',
					params: '',
				},
			]
		},
		email: {
			storeLabel: 'Email',
			label: 'Email',
			icon: 'envelope',
			name: 'email',
			color: '#5600a5',
			canUninstall: false,
			params: '',
			internal: [
				{
					app: 'view',
					params: ':id'
				},
			]
		},
		bank: {
			storeLabel: 'Bank',
			label: 'Bank',
			icon: 'university',
			name: 'bank',
			color: '#ff0000',
			canUninstall: true,
			params: '',
		},
		twitter: {
			storeLabel: 'Twitter',
			label: 'Twitter',
			icon: ['fab', 'twitter'],
			name: 'twitter',
			color: '#00aced',
			canUninstall: true,
			params: '',
		},
		irc: {
			storeLabel: 'IRC',
			label: 'IRC',
			icon: 'comment-slash',
			name: 'irc',
			color: '#1de9b6',
			canUninstall: true,
			params: '',
		},
		adverts: {
			storeLabel: 'Yellow Pages',
			label: 'YP',
			icon: 'ad',
			name: 'adverts',
			color: '#f9a825',
			canUninstall: true,
			params: '',
			internal: [
				{
					app: 'view',
					params: ':id'
				},
				{
					app: 'category-view',
					params: ':category'
				},
				{
					app: 'add',
					params: ''
				},
				{
					app: 'edit',
					params: ''
				},
			]
		},
	},
};

const appReducer = (state = initialState, action) => {
	switch (action.type) {
		case 'PHONE_VISIBLE':
			return {
				...state,
				visible: true,
			};
		case 'PHONE_NOT_VISIBLE':
			Nui.send('ClosePhone', null);
			return {
				...state,
				visible: false,
			};
		case 'CLEAR_HISTORY':
			return {
				...state,
				clear: true,
			};
		case 'TOGGLE_EXPANDED':
			console.log('???????????')
			return {
				...state,
				expanded: !state.expanded,
			};
		case 'CLEARED_HISTORY':
			Nui.send('CDExpired');
			return {
				...state,
				clear: false,
			};
		case 'SET_APPS':
			return {
				...state,
				apps: action.payload,
			};
		case 'REORDER_APP':
			let home = state.home.filter(app => app !== action.payload.app);
			home.splice(action.payload.index, 0, action.payload.app);
			return {
				...state,
				home: home,
			};
		case 'REORDER_APP_DOCK':
			let docked = state.docked.filter(app => app !== action.payload.app);
			docked.splice(action.payload.index, 0, action.payload.app);
			return {
				...state,
				docked: docked,
			};
		case 'ADD_TO_HOME':
			return {
				...state,
				home: [...state.home, action.payload.app],
			};
		case 'REMOVE_FROM_HOME':
			return {
				...state,
				home: state.home.filter(app => app != action.payload.app),
			};
		case 'DOCK_APP':
			return {
				...state,
				docked: [...state.docked, action.payload.app],
			};
		case 'UNDOCK_APP':
			return {
				...state,
				docked: state.docked.filter(app => app != action.payload.app),
			};
		default:
			return state;
	}
};

export default appReducer;
