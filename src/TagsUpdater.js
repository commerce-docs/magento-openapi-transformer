function updateTags(pathsObject){
    let results = Object.assign({},pathsObject);

    let pathKeys = Object.keys(results);

    pathKeys.forEach(path=>{
        actions = Object.keys(results[path]);

        actions.forEach(action=>{
            results[path][action].tags = [formatName(path)];    
        });
    });
    
    return results;
}

function formatName(path){
    return path.split('/').slice(2).join('/');
}

module.exports = {
    update: updateTags
};
