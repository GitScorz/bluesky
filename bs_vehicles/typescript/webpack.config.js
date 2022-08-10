const path = require('path')
const {CleanWebpackPlugin} = require("clean-webpack-plugin");

const buildPathServer = path.resolve(__dirname, '../server');
const buildPathClient = path.resolve(__dirname, '../client');

const server = () => ({
    entry: './src/server/server.ts',
    output: {
        path: buildPathServer,
        filename: '[contenthash].server.js',
    },
    devtool: 'source-map',
    module: {
        rules: [
            {
                test: /\.tsx?$/,
                use: ['ts-loader'],
                exclude: /node_modules/,
            }
        ]
    },
    plugins: [
        new CleanWebpackPlugin()
    ],
    optimization: {
        minimize: true
    },
    resolve: {
        extensions: ['.ts', '.js'],
    }
})

const client = () => ({
    entry: './src/client/client.ts',
    output: {
        path: buildPathClient,
        filename: '[contenthash].client.js',
    },
    devtool: 'source-map',
    module: {
        rules: [
            {
                test: /\.tsx?$/,
                use: ['ts-loader'],
                exclude: /node_modules/,
            }
        ]
    },
    plugins: [
        new CleanWebpackPlugin()
    ],
    optimization: {
        minimize: true
    },
    resolve: {
        extensions: ['.ts', '.js'],
    }
})

module.exports = [server, client]