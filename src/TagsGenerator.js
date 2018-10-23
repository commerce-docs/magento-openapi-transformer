// Generates a list of tags based on a paths object

function generateTags(pathsObject){

    let result = []

    let tags = new Set();

    const pathsObjectKeys = Object.keys(pathsObject);

    pathsObjectKeys.forEach(element => {

        const pathActionKeys = Object.keys(pathsObject[element]);

        pathActionKeys.forEach(action => {
            pathsObject[element][action].tags.forEach( tag => {
                tags.add(tag);
            }); 
        }); 
    });

    tags.forEach(tag => {
        result.push({ "name": tag });
    });

    return result;

}

module.exports = {
    generate: generateTags
}


