import { object } from 'prop-types';

export const initialState = {
	data: {
		myData: {
			sid: 1,
			cid: 'unique char id',
			name: {
				first: 'Fuck',
				last: 'Me',
			},
			number: '555-555-5555',
			aliases: {
				email: 'fuck_me@pixel.world',
				twitter: '@FuckYou123',
			},
		},
		myJob: {
			job: 'police',
			grade: 5,
		},
		settings: {
			wallpaper: 'wallpaper',
			ringtone: 'ringtone',
			texttone: 'text',
			colors: {
				accent: '#1a7cc1',
			},
			zoom: 80,
			volume: 100,
			notifications: true,
			appNotifications: {
				messages: true,
			},
		},
		installed: [
			'contacts',
			'phone',
			'messages',
			'store',
			'settings',
			'email',
			'irc',
			'bank',
			'twitter',
			'adverts',
		],
		home: [
			'contacts',
			'phone',
			'messages',
			'store',
			'settings',
			'email',
			'irc',
			'bank',
			'twitter',
			'adverts',
		],
		docked: ['contacts', 'phone', 'messages'],
		contacts: [
			{
				_id: 'abc123',
				name: 'Test',
				number: '555-555-5555',
				favorite: true,
				color: '#1a7cc1',
				avatar:
					'https://i.pinimg.com/736x/4a/8b/b1/4a8bb1a316a7179eda8ccbea3ab027b2--oregon-ducks-football-football-s.jpg',
			},
			{
				_id: 'abc124',
				name: 'Test 2',
				number: '555-555-5552',
				favorite: false,
				color: '#1a7cc1',
				avatar:
					'https://i.pinimg.com/236x/df/19/14/df19146777544b82d08e06d3dd102df4.jpg',
			},
		],
		messages: [
			{
				owner: '555-555-5555',
				number: '333-333-3333',
				method: 1,
				time: 1583397349801,
				message:
					'asdfasdfasdfasdfasdfasdfasdf;laksdfjl;aksdfj;laskjdf;laksjdfl;kjas;ldkfja;lsdkfj;laskdjfl;askjdf;laskjsdfl;askjdfl;akjdfl;aksjdf;laskjdfl;as',
				unread: true,
			},
			{
				owner: '555-555-5555',
				number: '333-333-3333',
				method: 0,
				time: 1583397349801,
				message: 'This is a test message',
				unread: true,
			},
			{
				owner: '555-555-5555',
				number: '333-333-3333',
				method: 1,
				time: 1583397349801,
				message: 'This is a test message',
				unread: true,
			},
			{
				owner: '555-555-5555',
				number: '111-111-1111',
				method: 1,
				time: 1583397349801,
				message: 'This is a test message',
				unread: true,
			},
			{
				owner: '555-555-5555',
				number: '111-111-1111',
				method: 0,
				time: 1583397349801,
				message: 'This is a test message',
				unread: true,
			},
			{
				owner: '555-555-5555',
				number: '111-111-1111',
				method: 1,
				time: 1583397349801,
				message: 'This is a test message',
				unread: true,
			},
		],
		calls: [
			{
				owner: '555-555-5555',
				number: '555-555-5555',
				method: 1,
				anonymous: 1,
				time: 1583397349801,
				duration: 122,
			},
		],
		emails: [
			{
				_id: '1',
				sender: 'chop@mechanics.onion',
				subject: 'Offer Expires Soon',
				body:
					'Why in the absolute fuck do we do this to ourselves? Like all this bullshit to just entertain randoms on the internet?',
				time: 1583397349801,
				unread: true,
				flags: {
					location: { x: 0, y: 0, z: 0 },
					expires: Date.now() + 100000,
				},
			},
			{
				_id: '2',
				sender: 'fuckyou@suckmyass.com',
				subject:
					'I Want To Fucking Die I Want To Fucking Die I Want To Fucking Die I Want To Fucking Die I Want To Fucking Die',
				body:
					'Why in the absolute fuck do we do this to ourselves? Like all this bullshit to just entertain randoms on the internet?',
				time: 1583397349801,
				unread: true,
				flags: {
					location: { x: 0, y: 0, z: 0 },
				},
			},
			{
				_id: '3',
				sender: 'fuckyou1@suckmyass.com',
				subject: 'I Want To Fucking Die',
				body:
					'Why in the absolute fuck do we do this to ourselves? Like all this bullshit to just entertain randoms on the internet?',
				time: Date.now(),
			},
			{
				_id: '4',
				sender: 'fuckyou@suckmyass.com',
				subject: 'I Want To Fucking Die',
				body:
					'Why in the absolute fuck do we do this to ourselves? Like all this bullshit to just entertain randoms on the internet?',
				time: 1583397349801,
				unread: true,
				flags: {
					location: { x: 0, y: 0, z: 0 },
				},
			},
			{
				_id: '5',
				sender: 'fuckyou@suckmyass.com',
				subject: 'I Want To Fucking Die',
				body:
					'Why in the absolute fuck do we do this to ourselves? Like all this bullshit to just entertain randoms on the internet?',
				time: 1583397349801,
				unread: true,
				flags: {
					location: { x: 0, y: 0, z: 0 },
				},
			},
			{
				_id: '6',
				sender: 'fuckyou@suckmyass.com',
				subject: 'I Want To Fucking Die',
				body:
					'Why in the absolute fuck do we do this to ourselves? Like all this bullshit to just entertain randoms on the internet?',
				time: 1583397349801,
				unread: true,
				flags: {
					location: { x: 0, y: 0, z: 0 },
				},
			},
			{
				_id: '7',
				sender: 'fuckyou@suckmyass.com',
				subject: 'I Want To Fucking Die',
				body:
					'Why in the absolute fuck do we do this to ourselves? Like all this bullshit to just entertain randoms on the internet?',
				time: 1583397349801,
				unread: true,
				flags: {
					location: { x: 0, y: 0, z: 0 },
				},
			},
			{
				_id: '8',
				sender: 'fuckyou@suckmyass.com',
				subject: 'I Want To Fucking Die',
				body:
					'Why in the absolute fuck do we do this to ourselves? Like all this bullshit to just entertain randoms on the internet?',
				time: 1583397349801,
				unread: true,
				flags: {
					location: { x: 0, y: 0, z: 0 },
				},
			},
			{
				_id: '9',
				sender: 'fuckyou@suckmyass.com',
				subject: 'I Want To Fucking Die',
				body:
					'Why in the absolute fuck do we do this to ourselves? Like all this bullshit to just entertain randoms on the internet?',
				time: 1583397349801,
				unread: true,
				flags: {
					location: { x: 0, y: 0, z: 0 },
				},
			},
			{
				_id: '10',
				sender: 'fuckyou@suckmyass.com',
				subject: 'I Want To Fucking Die',
				body:
					'Why in the absolute fuck do we do this to ourselves? Like all this bullshit to just entertain randoms on the internet?',
				time: 1583397349801,
				unread: true,
				flags: {
					location: { x: 0, y: 0, z: 0 },
				},
			},
			{
				_id: '11',
				sender: 'fuckyou@suckmyass.com',
				subject: 'I Want To Fucking Die',
				body:
					'Why in the absolute fuck do we do this to ourselves? Like all this bullshit to just entertain randoms on the internet?',
				time: 1583397349801,
				unread: true,
				flags: {
					location: { x: 0, y: 0, z: 0 },
				},
			},
			{
				_id: '12',
				sender: 'fuckyou@suckmyass.com',
				subject: 'I Want To Fucking Die',
				body:
					'Why in the absolute fuck do we do this to ourselves? Like all this bullshit to just entertain randoms on the internet?',
				time: 1583397349801,
				unread: true,
				flags: {
					location: { x: 0, y: 0, z: 0 },
				},
			},
			{
				_id: '13',
				sender: 'fuckyou@suckmyass.com',
				subject: 'I Want To Fucking Die',
				body:
					'Why in the absolute fuck do we do this to ourselves? Like all this bullshit to just entertain randoms on the internet?',
				time: 1583397349801,
				unread: true,
				flags: {
					location: { x: 0, y: 0, z: 0 },
				},
			},
			{
				_id: '14',
				sender: 'fuckyou@suckmyass.com',
				subject: 'I Want To Fucking Die',
				body:
					'Why in the absolute fuck do we do this to ourselves? Like all this bullshit to just entertain randoms on the internet?',
				time: 1583397349801,
				unread: true,
				flags: {
					location: { x: 0, y: 0, z: 0 },
				},
			},
			{
				_id: '15',
				sender: 'fuckyou@suckmyass.com',
				subject: 'I Want To Fucking Die',
				body:
					'Why in the absolute fuck do we do this to ourselves? Like all this bullshit to just entertain randoms on the internet?',
				time: 1583397349801,
				unread: true,
				flags: {
					location: { x: 0, y: 0, z: 0 },
				},
			},
			{
				_id: '16',
				sender: 'fuckyou@suckmyass.com',
				subject: 'I Want To Fucking Die',
				body:
					'Why in the absolute fuck do we do this to ourselves? Like all this bullshit to just entertain randoms on the internet?',
				time: 1583397349801,
				unread: true,
				flags: {
					location: { x: 0, y: 0, z: 0 },
				},
			},
			{
				_id: '17',
				sender: 'fuckyou@suckmyass.com',
				subject: 'I Want To Fucking Die',
				body:
					'Why in the absolute fuck do we do this to ourselves? Like all this bullshit to just entertain randoms on the internet?',
				time: 1583397349801,
				unread: true,
				flags: {
					location: { x: 0, y: 0, z: 0 },
				},
			},
			{
				_id: '18',
				sender: 'fuckyou@suckmyass.com',
				subject: 'I Want To Fucking Die',
				body:
					'Why in the absolute fuck do we do this to ourselves? Like all this bullshit to just entertain randoms on the internet?',
				time: 1583397349801,
				unread: true,
				flags: {
					location: { x: 0, y: 0, z: 0 },
				},
			},
		],
		adverts: {
			1: {
				id: 1,
				author: 'Some Name',
				number: '555-555-5551',
				time: 1583397349801,
				title: 'This is a title 😀',
				price: 400,
				short: "This is a short description of what you're offering",
				full:
					'This is a much more depthful description of what service you are currently offering.<br />This should support formatting in some manor, maybe see if we can find some sort of WYSIWYG editor?',
				categories: ['Services'],
			},
			2: {
				id: 2,
				author: 'Some Other Name',
				number: '555-555-5552',
				time: 1583397349801,
				price: 400,
				title: 'This is a title 😀',
				short: "This is a short description of what you're offering",
				full:
					'This is a much more depthful description of what service you are currently offering.<br />This should support formatting in some manor, maybe see if we can find some sort of WYSIWYG editor?',
				categories: ['Services', 'Want-To-Sell'],
			},
			3: {
				id: 3,
				author: 'Fuck Me',
				number: '555-555-5553',
				time: 1583397349811,
				price: 400,
				title: 'This is a title 😀',
				short: "This is a short description of what you're offering",
				full:
					'This is a much more depthful description of what service you are currently offering.<br />This should support formatting in some manor, maybe see if we can find some sort of WYSIWYG editor?',
				categories: ['Help Wanted'],
			},
			4: {
				id: 4,
				author: 'Fuck Me',
				number: '555-555-5553',
				time: 1583397349811,
				price: 400,
				title: 'asdfasdfasdfasdfasdfasdfasdfadfsasdf',
				short: "This is a short description of what you're offering",
				full:
					'This is a much more depthful description of what service you are currently offering.<br />This should support formatting in some manor, maybe see if we can find some sort of WYSIWYG editor?',
				categories: [
					'Services',
					'Want-To-Sell',
					'Want-To-Buy',
					'Help Wanted',
				],
			},
		},
	},
};

export default (state = initialState, action) => {
	switch (action.type) {
		case 'SET_DATA':
			return {
				...state,
				data: {
					...state.data,
					[action.payload.type]: action.payload.data,
				},
			};
		case 'RESET_DATA':
			return initialState;
		case 'ADD_DATA':
			return {
				...state,
				data: {
					...state.data,
					[action.payload.type]:
						state.data[action.payload.type] != null
							? Object.prototype.toString.call(
									state.data[action.payload.type],
							  ) == '[object Array]' &&
							  action.payload.key != null
								? action.payload.first
									? [
											action.payload.data,
											...state.data[action.payload.type],
									  ]
									: [
											...state.data[action.payload.type],
											action.payload.data,
									  ]
								: {
										...state.data[action.payload.type],
										[action.payload.key]:
											action.payload.data,
								  }
							: action.payload.key != null
							? { [action.payload.key]: action.payload.data }
							: [action.payload.data],
				},
			};
		case 'UPDATE_DATA':
			return {
				...state,
				data: {
					...state.data,
					[action.payload.type]:
						Object.prototype.toString.call(
							state.data[action.payload.type],
						) == '[object Array]'
							? state.data[action.payload.type].map((data) =>
									data._id === action.payload.id
										? { ...action.payload.data }
										: data,
							  )
							: (state.data[action.payload.type] = {
									...state.data[action.payload.type],
									[action.payload.id]: action.payload.data,
							  }),
				},
			};
		case 'REMOVE_DATA':
			return {
				...state,
				data: {
					...state.data,
					[action.payload.type]:
						Object.prototype.toString.call(
							state.data[action.payload.type],
						) == '[object Array]'
							? state.data[action.payload.type].filter((data) =>
									Object.prototype.toString.call(
										state.data[action.payload.type],
									) == '[object Array]'
										? data._id !== action.payload.id
										: data !== action.payload.id,
							  )
							: (state.data[action.payload.type] = Object.keys(
									state.data[action.payload.type],
							  ).reduce((result, key) => {
									if (key != action.payload.id) {
										result[key] =
											state.data[action.payload.type][
												key
											];
									}
									return result;
							  }, {})),
				},
			};
		default:
			return state;
	}
};
