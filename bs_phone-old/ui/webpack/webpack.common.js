const path = require('path');
const webpack = require('webpack');

module.exports = (options) => ({
	mode: options.mode,
	entry: options.entry,
	output: {
		path: path.resolve(process.cwd(), 'html'),
		publicPath: options.mode !== 'production' ? '/' : '/ui/html/',
		filename: '[name].js',
	},
	performance: {
		hints: false,
	},
	optimization: {
		splitChunks: {
			minSize: 10000,
			maxSize: 250000,
		},
	},
	module: {
		rules: [
			{
				test: /\.jsx?$/, // Transform all .js and .jsx files required somewhere with Babel
				exclude: /node_modules/,
				use: {
					loader: 'babel-loader',
				},
			},
			{
				// Preprocess our own .css files
				// This is the place to add your own loaders (e.g. sass/less etc.)
				// for a list of loaders, see https://webpack.js.org/loaders/#styling
				test: /\.css$/,
				exclude: /node_modules/,
				use: ['style-loader', 'css-loader'],
			},
			{
				// Preprocess 3rd party .css files located in node_modules
				test: /\.css$/,
				include: /node_modules/,
				use: ['style-loader', 'css-loader'],
			},
			{
				test: /\.(eot|otf|ttf|woff|woff2)$/,
				use: 'file-loader',
			},
			{
				test: /\.svg$/,
				use: [
					{
						loader: 'svg-url-loader',
						options: {
							// Inline files smaller than 10 kB
							limit: 10 * 1024,
							noquotes: true,
						},
					},
				],
			},
			{
				test: /\.(jpg|png|gif|webp)$/,
				use: [
					{
						loader: 'url-loader',
						options: {
							// Inline files smaller than 10 kB
							limit: 10 * 1024,
						},
					},
					{
						loader: 'image-webpack-loader',
						options: {
							mozjpeg: {
								enabled: false,
								// NOTE: mozjpeg is disabled as it causes errors in some Linux environments
								// Try enabling it in your environment by switching the config to:
								// enabled: true,
								// progressive: true,
							},
							gifsicle: {
								interlaced: false,
							},
							optipng: {
								optimizationLevel: 7,
							},
							pngquant: { quality: [0.65, 0.9], speed: 4 },
							webp: {
								quality: 75,
							},
						},
					},
				],
			},
			{
				test: /\.html$/,
				use: 'html-loader',
			},
			{
				test: /\.(mp4|webm)$/,
				use: {
					loader: 'url-loader',
					options: {
						limit: 10000,
					},
				},
			},
			{
				test: /\.js$/,
				exclude: /node_modules/,
				use: [
					{
						loader: `ifdef-loader`,
						options: {
							DEBUG: options.mode !== 'production',
							version: 3,
							'ifdef-verbose': true, // add this for verbose output
							'ifdef-triple-slash': true, // add this to use double slash comment instead of default triple slash
						},
					},
				],
			},
		],
	},
	plugins: options.plugins,
	resolve: {
		modules: ['src', 'node_modules'],
		extensions: ['.js', '.jsx', '.react.js'],
	},
});
