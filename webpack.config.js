module.exports = {
    entry: {
        app: "./src/Client/index.js"
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

    externals: {
        'react': 'react',
        'react-dom': 'react-dom',
        'styled-components': 'styled-components'
    },

    mode: "development"
};