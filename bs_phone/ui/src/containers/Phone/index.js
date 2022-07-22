import { compose } from 'redux';
import { connect, useSelector } from 'react-redux';
import { makeStyles, Slide } from '@material-ui/core';
import Loadable from 'react-loadable';
import { BrowserRouter, Navigate, Route, Routes } from 'react-router-dom';
import withRouter from '../../hooks/withRouter';

import {
	Header,
	Footer,
	Loader,
	Home,
	List,
	Notifications,
	Alerts,
} from '../../components';
import Incoming from '../../Apps/phone/incoming';

import { Wallpapers } from '../../util/Wallpapers';

import phoneImg from '../../s10.png';

export default compose(
	withRouter,
	connect(),
)((props) => {
	const visible = useSelector((state) => state.phone.visible);
	const expanded = useSelector((state) => state.phone.expanded);
	const apps = useSelector((state) => state.phone.apps);
	const installed = useSelector((state) => state.data.data.installed);
	const callData = useSelector((state) => state.call.call);
	const settings = useSelector((state) => state.data.data.settings);

	const useStyles = makeStyles((theme) => ({
		wrapper: expanded
			? {
					height: 750,
					width: 365,
					position: 'absolute',
					top: '30%',
					bottom: 0,
					left: '80%',
					right: 0,
					margin: 'auto',
					overflow: 'hidden',
			  }
			: {
					height: 750,
					width: 365,
					position: 'absolute',
					bottom: '2%',
					right: '2%',
					overflow: 'hidden',
					zoom: `${settings.zoom}%`,
			  },
		phoneImg: {
			zIndex: 100,
			background: `transparent no-repeat center`,
			height: '100%',
			width: '100%',
			position: 'absolute',
			pointerEvents: 'none',
			right: 1,
		},
		phoneWallpaper: {
			height: '92%',
			width: '88%',
			position: 'absolute',
			background: `transparent no-repeat fixed center cover`,
			zIndex: -1,
			borderRadius: 30,
		},
		phone: {
			height: '100%',
			width: '100%',
			padding: '20px 20px',
			overflow: 'hidden',
		},
		screen: {
			height: '84%',
			overflow: 'hidden',
		},
	}));
	const classes = useStyles();

	const DynamicLoad = (app, subapp) => {
		const LoadableSubComponent = Loadable({
			loader: () =>
				import(`../../Apps/${app}/${subapp != null ? subapp.app : ''}`),
			loading() {
				return <Loader app={apps[app]} />;
			},
		});
		LoadableSubComponent.preload(); // Hopefully load the shit? idk lol
		return LoadableSubComponent;
	};

	return (
		<Slide direction="up" in={visible} mountOnEnter unmountOnExit>
			<div className={classes.wrapper}>
				<img className={classes.phoneImg} src={phoneImg} />
				<div className={classes.phone}>
					<img
						className={classes.phoneWallpaper}
						src={
							Wallpapers[settings.wallpaper] != null
								? Wallpapers[settings.wallpaper].file
								: settings.wallpaper
						}
					/>
					<Header />
					<Alerts />
					<div className={classes.screen}>
						<BrowserRouter>
							<Routes>
								<Route exact path="/" component={Home} />
								<Route exact path="/apps" component={List} />
								<Route
									exact
									path="/notifications"
									component={Notifications}
								/>
								{Object.keys(apps).length > 0 &&
								installed.length > 0
									? installed
											.filter((app, i) => app !== 'home')
											.map((app, i) => {
												let routes = [];
												routes.push(
													<Route
														key={i}
														exact
														path={`/apps/${app}/${apps[app].params}`}
														component={DynamicLoad(app)}
													/>,
												);

												if (apps[app].internal != null) {
													{
														apps[app].internal.map(
															(subapp, k) => {
																routes.push(
																	<Route
																		key={
																			installed.length +
																			k
																		}
																		exact
																		path={`/apps/${app}/${
																			subapp.app
																		}/${
																			subapp.params !=
																			null
																				? subapp.params
																				: ''
																		}`}
																		component={DynamicLoad(
																			app,
																			subapp,
																		)}
																	/>,
																);
															},
														);
													}
												}

												return routes;
											})
									: null}
								<Navigate to="/" />
							</Routes>
						</BrowserRouter>
						<Incoming call={callData} />
					</div>
					<Footer />
				</div>
			</div>
		</Slide>
	);
});
