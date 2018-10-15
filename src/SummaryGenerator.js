//Generates a 'summary' property for a pathsObject based on it's tag

function generate(pathsObject) {
    let result = Object.assign({}, pathsObject);

    let paths = Object.keys(pathsObject);

    paths.forEach(path=> {
        let actions = Object.keys(pathsObject[path])

        actions.forEach(action=> {
            pathsObject[path][action].summary = pathsObject[path][action].tags[0]
        })
    })

    return result;
}

module.exports = {
    generate: generate
}
