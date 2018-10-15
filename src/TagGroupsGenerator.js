// Generates the x-tagGroups object from the Magento paths

function generate(pathsObject){
    let result = [];
    let map = new Map();
    const pathsObjectKeys = Object.keys(pathsObject);

    pathsObjectKeys.forEach(element=>{
        let groupName = formatName(element);

        if(map.get(groupName) === undefined)
            map.set(groupName, []);

        let actions = Object.keys(pathsObject[element]);

        actions.forEach(action=>{
            map.set(groupName, [].concat(pathsObject[element][action].tags, map.get(groupName)))
        });

    });

    map.forEach( (value,key)=>{
        result.push({
            "name": key,
            "tags": Array.from(new Set(value.sort()))
        });
    });

    return result; 
}

function formatName(name){ 

    let result = name.split('/')[2].split('-').join(" ");

    return result;
}

module.exports = {
    generate: generate
}
