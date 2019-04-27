module.exports = {
    entry: {
        app: "./src/Client"
    },
    output: {
        filename: "public/[name].js"
    },
    devtool: "source-map",
    resolveLoader: {
        moduleExtensions: ["-loader"]
    },
    resolve: {
        extensions: [".js", "jsx", ".ts", ".tsx"]
    },
    module: {
        rules: [{
            test: /\.tsx?$/,
            use: {
                loader: "ts-loader",
                options: {
                    transpileOnly: true
                }
            },
            exclude: /node_modules/
        }]
    },
    externals: {
        'react': 'react',
        'react-dom': 'react-dom',
        'styled-components': 'styled-components'
    },

    mode: "development"
};